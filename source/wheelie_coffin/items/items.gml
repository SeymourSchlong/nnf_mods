// In this file you can register your mod's items.

// To register an item, call the mod_register_item(item_struct) function.

// For more information, see https://github.com/Skirlez/nubbys-forgery/wiki/Registering-Items

var jump_spring = mod_get_code_globals("items/wheelie_coffin.gml").construct()
mod_register_item(jump_spring, "wheelie_coffin")

var jump_spring_plus = mod_get_code_globals("items/wheelie_coffin_upgrade.gml").construct()
mod_register_item(jump_spring_plus, "wheelie_coffin_upgrade")