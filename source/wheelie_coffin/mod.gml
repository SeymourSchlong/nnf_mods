// Runs when the mod is loaded
on_load = function() {
	mod_execute_code("functions.gml")
	mod_execute_code("sprites/sprites.gml")
	mod_execute_code("items/items.gml")
}
// Runs when the mod is unloaded
// Please clean up any dynamic structures you created here
// as to not cause memory leaks
on_unload = function() {

}
