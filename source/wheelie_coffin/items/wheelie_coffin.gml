construct = function() {
	// Reliable way to get your own mod ID
	var mod_id = global.cmod.mod_id

	// Create the item struct
	var item = {}

	// The translation key of the item's name
	item.display_name = mod_identifier(mod_id, "wheelie_coffin_name")

	// mod_identifier is a quick way to combine our mod ID and another string with a semicolon.
	// So in the call above, the result will be "example_mod:example_item_name"

	// The translation key of the item's description
	item.description = mod_identifier(mod_id, "wheelie_coffin_desc")

	// The sprite that should be assigned to the item's object
	// This sprite was registered in the sprites folder
	item.sprite = mod_get_sprite("spr_wheelie_coffin")

	// The game event on which the item triggers.
	// For a list, see here https://github.com/Skirlez/nubbys-forgery/wiki/List-of-Game-Events
	item.game_event = "NubbyDies"

	// Alternate Game Event for mutant tony
	item.alt_game_event = "5Second"

	// 1 is used for normal items, 2 is used for upgraded items
	item.level = 1
	
	// Tiers:
	// 0 - Common
	// 1 - Rare
	// 2 - Ultra-Rare
	item.tier = 1

	// Augments:
	// Normal items use "none"
	// Corrupted items use "corrupted"
	item.augment = "corrupted"

	// effect is a string describing what the item does
	// It is only used for identification by other objects in code,
	// for example the The Eggy Perk, the perk that retriggers summoning items,
	// checks this variable so it knows what to retrigger.
	// For a list of base game effects see TODO
	item.effect = "misc"

	// Which pool this item will show up in
	// 0 - Unobtainable
	// 1 - Nubby-Mart
	// 2 - Black Market
	// 3 - Café Nubby

	// Do not set it to 3.
	item.pool = 1

	// Price added to the item's base rarity price (can be negative)
	// Base rarity prices:
	// Common - 5
	// Rare, Ultra-Rare - 10
	item.offset_price = 8

	// Pair item's ID
	// Essentially this is the upgraded item's ID
	item.pair_id = mod_identifier(mod_id, "wheelie_coffin_upgrade")

	// odds that affect the item's chance of appearing in early, mid, and endgame.
	item.odds_weight_early = 3
	item.odds_weight_mid = 5
	item.odds_weight_end = 5

	// Event functions
	// These functions are going to be called by the modloader!
	// In all event functions, self is the instance of the item running this code

	// Runs when the item is created
	item.on_create = function(inst) {
		
	}

	// Runs when triggered
	item.on_trigger = function(inst) {
		with (inst) {
			if (DisableItem == false and global.GameMode == 1) {

				var _time_limit = 6
				if (any(obj_DrawHUD).RoundTime <= 60*_time_limit) {
					var _spawn_x = 958
					var _spawn_y = 325
					var _NubDupe = instance_create_depth(_spawn_x, _spawn_y, depth, obj_NubbyDupe);
					
					with (_NubDupe) {
						motion_add(irandom(359), 15)
					}


					var _ValidPegs = ds_list_create();
					ds_list_clear(_ValidPegs);
					
					for (var i = 0; i < instance_number(obj_ParPeg); i += 1)
					{
						var _Tar = instance_find(obj_ParPeg, i)
						
						if (instance_exists(_Tar) && _Tar != -1)
						{
							if (_Tar.PegDead == false)
							{
								if (instance_position(_Tar.x, _Tar.y, obj_GridCell) != any(obj_LvlMGMT).Initial_FirstPegGCell) {
									ds_list_add(_ValidPegs, _Tar)
								}
							}
						}
					}
					
					if (ds_list_size(_ValidPegs) > 0)
					{
						ds_list_shuffle(_ValidPegs)

						var _AmtToCopy = 5
						_AmtToCopy = min(_AmtToCopy, ds_list_size(_ValidPegs))
						
						if (global.ItemSfx == true) {
							audio_play_sound(au_WindUpFish, 1, 0, 0.5)
						}
						
						for (var i = 0; i < _AmtToCopy; i += 1)
						{
							with (ds_list_find_value(_ValidPegs, i))
							{
								scr_Part_PegCopy(scr_PartAmt(20), 1);

								var _og_val = any(obj_LvlMGMT).Grid[instance_position(x, y, obj_GridCell).GridVal];
								
								scr_SpawnPeg(1, id, _og_val);
							}
						}
					}
					
					ds_list_destroy(_ValidPegs);
				}

				scr_FX_ItemFire(au_ItemFireGrl)
				scr_TrackFire()
				scr_PositionalEv()
			}
			scr_ItemQueue()
		}
	}


	// Return our item struct so it can be registered in items.gml
	return item;
}

