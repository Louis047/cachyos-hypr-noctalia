-- Dynamic window animations: solo popin vs multi slide.
-- Global leaves default to bare "slide" (nearest-monitor-edge, both In/Out).
-- This file forces per-window overrides via static tags:
--   solo tiled            -> popin 80% (popup open, shrink close)
--   multi tiled           -> slide (directional open + close)
--   floating (non-special)-> popin 80% (centered dialogs shouldn't slide)
--   special workspace     -> slide (per request, even though floating)
-- windowrule animation is dynamic and takes precedence over global leaves.

hl.window_rule({ name = "anim-popin", match = { tag = "anim-popin" }, animation = "popin 80%" })
hl.window_rule({ name = "anim-slide", match = { tag = "anim-slide" }, animation = "slide" })

local TAG_POPIN = "anim-popin"
local TAG_SLIDE = "anim-slide"

local function has_tag(win, tag)
    local ok, tags = pcall(function() return win.tags end)
    if not ok or tags == nil then
        return false
    end
    if type(tags) == "table" then
        for _, t in pairs(tags) do
            if t == tag then
                return true
            end
        end
        return false
    elseif type(tags) == "string" then
        return tags:find(tag, 1, true) ~= nil
    end
    return false
end

local function set_anim_tag(win, want)
    if win == nil then
        return
    end
    local other = (want == TAG_POPIN) and TAG_SLIDE or TAG_POPIN
    -- If already correct (and other absent), skip to avoid redundant refresh.
    if has_tag(win, want) and not has_tag(win, other) then
        return
    end
    pcall(hl.dispatch, hl.dsp.window.tag({ tag = "-" .. other, window = win }))
    pcall(hl.dispatch, hl.dsp.window.tag({ tag = "+" .. want, window = win }))
end

local function is_special_workspace(ws)
    if ws == nil then
        return false
    end
    local ok, special = pcall(function() return ws.special end)
    return ok and special == true
end

local function is_floating(win)
    local ok, floating = pcall(function() return win.floating end)
    return ok and floating == true
end

local function resync_workspace(ws)
    if ws == nil then
        return
    end
    local ok, wins = pcall(function() return hl.get_workspace_windows(ws) end)
    if not ok or wins == nil then
        return
    end
    local count = #wins
    local special = is_special_workspace(ws)
    for _, w in ipairs(wins) do
        local want
        if special then
            want = TAG_SLIDE
        elseif is_floating(w) then
            want = TAG_POPIN
        elseif count <= 1 then
            want = TAG_POPIN
        else
            want = TAG_SLIDE
        end
        set_anim_tag(w, want)
    end
end

local function resync_all()
    local ok, workspaces = pcall(hl.get_workspaces)
    if not ok or workspaces == nil then
        return
    end
    for _, ws in ipairs(workspaces) do
        resync_workspace(ws)
    end
end

-- New window may turn a solo popin workspace into multi slide: retag all.
hl.on("window.open", function(_win)
    resync_all()
end)

-- Closing window keeps its open-time tag (correct slide-if-multi).
-- Remainder is fixed on destroy when count has dropped.
hl.on("window.close", function(_win)
    resync_all()
end)

hl.on("window.destroy", function()
    resync_all()
end)

hl.on("window.move_to_workspace", function(_win, _ws)
    resync_all()
end)

-- Float toggles don't emit open/close; they re-evaluate dynamic rules.
-- update_rules fires there (WindowRuleApplicator.cpp emits it), so resync.
-- pin/fullscreen included for the same reason (layout-affecting changes).
-- set_anim_tag skips already-correct windows, so the resulting
-- update_rules -> resync loop converges without spam.
hl.on("window.update_rules", function(_win)
    resync_all()
end)

hl.on("window.pin", function(_win)
    resync_all()
end)

hl.on("window.fullscreen", function(_win)
    resync_all()
end)

hl.on("config.reloaded", function()
    resync_all()
end)

-- Initial sync for windows present at reload/start.
pcall(resync_all)
