--This code overrides the default bed node definitions and adds a new definition
--that when a player goes into a bed by punching it the mod will send a chat message
--to all the players so everyone can sleep to skip the night.

local old_bed_bottom_on_rightclick = minetest.registered_nodes["beds:bed_bottom"].on_rightclick
minetest.override_item("beds:bed_bottom", {
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local time = minetest.get_timeofday()
        if time < 0.2 or time > 0.805 then  -- adjust these values as needed
            local player_name = clicker:get_player_name()
            minetest.chat_send_all(player_name .. " has gone to bed.")
        end
        if old_bed_bottom_on_rightclick then
            return old_bed_bottom_on_rightclick(pos, node, clicker, itemstack, pointed_thing)
        end
    end
})

local old_fancy_bed_bottom_on_rightclick = minetest.registered_nodes["beds:fancy_bed_bottom"].on_rightclick
minetest.override_item("beds:fancy_bed_bottom", {
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local time = minetest.get_timeofday()
        if time < 0.2 or time > 0.805 then  -- adjust these values as needed
            local player_name = clicker:get_player_name()
            minetest.chat_send_all(player_name .. " has gone to bed.")
        end
        if old_fancy_bed_bottom_on_rightclick then
            return old_fancy_bed_bottom_on_rightclick(pos, node, clicker, itemstack, pointed_thing)
        end
    end
})