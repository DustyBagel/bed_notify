This is the documentation file for the "bed_notify" mod.

There are 2 global functions in this mod, one for adding the 
"player name has gone to bed" chat message and one for the
"player name has left there bed" chat message. These functions probably wouldn't work if
you are not using the beds api in the defualt "beds" mod that
comes with minetest_game.

add_enter_bed_support(node_name)

This function ovverides the bed node and adds the arguemnt 
on_rightclick which checks if the node is right clicked and
if it is it checks if it is night time and if the player is 
attached to a bed node if both of the conditions are met the 
chat message "player name is in bed." will be sent to all 
the players.

The function can be called like this:
add_enter_bed_support(node_name)
Make sure to replace the node_name with the name of your bed 
node.

add_leave_bed_support(leave_bed_formspec_name)

This function checks if the player has exited the formspec or
if the button "Leave bed", "Good morning" or the 
"Force night skip" button is pressed or the formspec is closed
then it prints out the player mame has left bed."

The function can be called like this:
add_leave_bed_support(node_form_name)
Make sure to replace the node_form_name with the name of the 
formspec of the bed node you are trying to add support for.