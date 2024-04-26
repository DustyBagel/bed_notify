This is the documentation file for the "bed_notify" mod.

For Version 2.0.2 and Earlier.

There are 2 global functions in this mod, one for adding the 
"player name has gone to bed" chat message and one for the
"player name has left there bed" chat message. These functions
probably wouldn't work if you are not using the beds api in
the defualt "beds" mod that comes with minetest_game.

add_enter_bed_support(node_name)

This function ovverides the bed node and adds the arguemnt 
on_rightclick which checks if the node is right clicked and
if it is it checks if it is night time and if the player is 
attached to a bed node if both of the conditions are met the 
chat message "player_name is in bed." will be sent to all 
the players.

The function can be called like this:
add_enter_bed_support(node_name)
Make sure to replace the node_name with the name of your bed 
node.

add_leave_bed_support(leave_bed_formspec_name)

This function checks if the player has exited the bed formspec
or if the button "Leave bed", "Good morning" or the 
"Force night skip" button is pressed or the formspec is closed
then it prints out the player_name has left bed."

The function can be called like this:
add_leave_bed_support(node_form_name)
Make sure to replace the node_form_name with the name of the 
formspec of the bed node you are trying to add support for.

For Version 3.0.0 and Later

Now you don't need to do anything for you bed node/item to be
supported as long as it uses the beds mod api in minetest_game.
If your bed node/item does not use the beds api then support for
it will have to be added manually.

To add support manually, you will need call the
bed_notifications.player_goes_to_bed(player_name) function when a
player enters your bed node/item and call the
bed_notifications.player_leaves_bed(player_name) when a player
leaves your bed node/item. Both functions need the player name
as an argument.

It doesn't matter where in your node/itmem definition you call
these functions, as long as the correct one is called when a player
enters or leaves a bed.

Example:

minetest.register_node(your_mod_name:your_node_name, {
    --Other node properties.
    on_rightclick = function(something, something, player)
        local name = player:get_player_name(player)
        bed_notifications.player_goes_to_bed(name)
    end,
})

If you have an item instead of a node then you can just call do
the same thing in your item definition but with a on_use callback
function instead of on_rightclick.

Example:

minetest.register_item(your_mod_name:your_item_name, {
    --Other item properies.
    on_use = function(something, something, player)
        local name = player:get_player_name(player)
        bed_notifications.player_leaves_bed(name)
    end,
})

If your node uses a formspec then you can call
bed_notifications.player_leaves_bed(player_name) when the player exits
the bed formspec or clicks the button that makes them sleep.

Example:

minetest.register_on_player_receive_fields(function(player)
    If form_name ~= your_formspec_name then
        return
    end

    if fields.quit or fields.leave then
        local name = player:get_player_name(player)
        bed_notifications.player_leaves_bed(name)
    end
end)
