--This code overrides the default bed node definitions and adds a new definition
--that when a player goes into a bed by punching it the mod will send a chat message
--to all the players so everyone can sleep to skip the night.

function add_enter_bed_support(node_name)
    local old_bed_bottom_on_rightclick = minetest.registered_nodes[node_name].on_rightclick
    minetest.override_item(node_name, {
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            local time = minetest.get_timeofday()
            local player_name = clicker:get_player_name()
            if old_bed_bottom_on_rightclick then
                old_bed_bottom_on_rightclick(pos, node, clicker, itemstack, pointed_thing)
            end
            minetest.after(0.5, function()  -- Add a delay
                if time < 0.23 or time > 0.805 then  
                    -- Check if the player is in bed
                    if beds.player and beds.player[player_name] then
                        minetest.chat_send_all(player_name .. " has gone to bed.")
                    end
                end
            end)
        end
    })
end

function add_leave_bed_support(node_form_name)
    minetest.register_on_player_receive_fields(function(player, formname, fields)
        if formname == node_form_name and (fields.quit or fields.leave) then
            local player_name = player:get_player_name()
            minetest.chat_send_all(player_name .. " has left bed.")
        end
    end)
end

--run support functions
add_enter_bed_support("beds:bed_bottom")
add_enter_bed_support("beds:fancy_bed_bottom")

add_leave_bed_support("beds_form")

--Beds redo support
--This has to be checked using the minetest.registered_nodes instead of minetest.get_modpath
--because the default beds and beds redo have the same technical name and it will cause errors.
if minetest.registered_nodes["beds:fancy_bed_pink"] then 
    add_enter_bed_support("beds:fancy_bed_pink")
    add_enter_bed_support("beds:bed_white")
    add_enter_bed_support("beds:bed_blue")
end