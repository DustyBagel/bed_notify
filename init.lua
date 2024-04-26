--This adds the red letters for the mod_name string placed at the start
--of the bed notifications.
local mod_name_prefix

if minetest.settings:get_bool("mod_name_prefix") or true then
    mod_name_prefix = "[B"..minetest.colorize("red", "ed").." Notifications] "
else
    mod_name_prefix = ""
end

--API stuff
bed_notifications = {}
bed_notifications.other_players_in_bed = {}

--Adds the player name argument to the list of players when they enter a bed
--that isn't supported automatically.
function bed_notifications.player_goes_to_bed(player_name)
    bed_notifications.other_players_in_bed[player_name] = true
end

--Removes the player from the list. 
function bed_notifications.player_leaves_bed(player_name)
    bed_notifications.other_players_in_bed[player_name] = nil
end

--Internal functions/stuff needed to function properly.
local was_in_bed = {}
local message_sent = false

--Returns true if players can sleep.
local function is_night(time)
    if time < 0.2 or time > 0.805 then
        return true
    end
    return false
end

--This registers a global step that only runs the function passed to it
--at a set interval in secounds.
local function run_periodically(period, func)
    local timer = 0
    minetest.register_globalstep(function(dtime)
        timer = timer + dtime
        if timer >= period then
            func()
            timer = 0
        end
    end)
end

--For some reason, minetest doesn't put a setting in the minetest.conf
--if a setting is at its default value then when we retrive the setting
--it will return nil. This code handles that.
local time_to_sleep_notification = minetest.settings:get_bool("time_to_sleep_notification")
if time_to_sleep_notification == nil then
    time_to_sleep_notification = true
end

--If the setting is enabled then this handles the Time to sleep message.
if time_to_sleep_notification then
    local message = minetest.settings:get("sleep_message") or "Time to go to bed."

    run_periodically(1, function()
        local time = minetest.get_timeofday()

        if not is_night(time) then
            message_sent = false
        elseif message_sent == false and is_night(time) then
            minetest.chat_send_all(mod_name_prefix..message)
            message_sent = true
        end
    end)
end
if minetest.settings:get_bool("server_mode") or false then
    local player_count = 0
    minetest.register_on_joinplayer(function()
        player_count = player_count + 1
    end)
    minetest.register_on_leaveplayer(function()
        player_count = player_count - 1
    end)
    local sleeping_players = 0
    local previous_sleeping_players = 0
    run_periodically(4, function()
        --I would really appreciate if someone could tell me how
        --to make this preform better. 
        if player_count == 0 then
            return
        end

        for _,player in ipairs(minetest.get_connected_players()) do
            local name = player:get_player_name()
            -- Check if the player is in bed
            if beds.player[name] or bed_notifications.other_players_in_bed[name] then
                -- If the player was not in bed before, they just went to bed
                if not was_in_bed[name] then
                    sleeping_players = sleeping_players + 1
                    was_in_bed[name] = true
                end
            else
                -- If the player was in bed before, they just got out of bed
                if was_in_bed[name] then
                    sleeping_players = sleeping_players - 1
                    was_in_bed[name] = nil
                end
            end
        end
        if previous_sleeping_players ~= sleeping_players and is_night(minetest.get_timeofday()) then
            minetest.chat_send_all(mod_name_prefix..sleeping_players.." of "..player_count.." players in bed.")
        end
        previous_sleeping_players = sleeping_players
    end)
else
    run_periodically(2, function()
        for _,player in ipairs(minetest.get_connected_players()) do
            local name = player:get_player_name()
            -- Check if the player is in bed
            if beds.player[name] or bed_notifications.other_players_in_bed[name] then
                -- If the player was not in bed before, they just went to bed
                if not was_in_bed[name] then
                    minetest.chat_send_all(mod_name_prefix..name.." has gone to bed.")
                    was_in_bed[name] = true
                end
            else
                -- If the player was in bed before, they just got out of bed
                if was_in_bed[name] then
                    minetest.chat_send_all(mod_name_prefix..name.." has left a bed.")
                    was_in_bed[name] = nil
                end
            end
        end
    end)
end

--[[minetest.register_node("bed_notify:test_node", {
    description = "Test node for the api.",
    textures = "default_stone.png",
    groups = {oddly_breakable_by_hand = 1, cracky = 3},
    on_rightclick = function(pos, other, player)
        if player:is_player() then
            local name = player:get_player_name()
            bed_notifications.player_goes_to_bed(name)
        else
            minetest.chat_send_all(dump(player))
        end
    end,
    on_punch = function(something, something, player)
        local name = player:get_player_name()
        bed_notifications.player_leaves_bed(name)
    end
})]]
