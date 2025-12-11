construct = function() {
	// Reliable way to get your own mod ID
	var mod_id = global.cmod.mod_id

	// Create the supervisor struct
	var sv = {}

	// The translation key of the supervisor's name
	sv.display_name = mod_identifier(mod_id, "glass_supervisor_name");

	// mod_identifier is a quick way to combine our mod ID and another string with a semicolon.
	// So in the call above, the result will be "example_mod:example_supervisor_name"


	// The translation key of the supervisor's description
	sv.description = mod_identifier(mod_id, "glass_supervisor_desc", 5);



	// This is the supervisor's sprite struct.
	// You only actually need 2 sprites: idle, which is shown during gameplay,
	// and preview, which is shown on the selection screen.

	// Any states/emotions you don't supply use the idle sprite.
	
	sv.sprites = {
		idle_neutral : spr_SV5IdleNeutral,
		preview : spr_SVPrev_Glass,
		angry : spr_SV5Angry,
		evil : spr_SV5Evil,
		happy : spr_SV5Happy,
		head_swivel : spr_SV5HeadSwivel,
		idle_grimace : spr_SV5IdleGrimace,
		idle_happy : spr_SV5IdleHappy,
		idle_sad : spr_SV5IdleSad,
		idle_weird : spr_SV5IdleWeird,
		sad : spr_SV5Sad,
		scream : spr_SV5Scream,
		talk : spr_SV5Talk,
	}


	sv.clicked_sounds = [
		au_TonyGlass_VO1,
		au_TonyGlass_VO2,
		au_TonyGlass_VO3,
		au_TonyGlass_VO4
	];
	
	sv.go_sound = au_Tony_VOGo;
	// Supervisor selection name color
	// Catspeak supports colors in this format: #RRGGBB
	sv.name_color = #000000

	// Cost in stars
	// Can be set to 0
	sv.cost = 0


	sv.on_create = function(this) {
		// Runs when the run begins
		// Create a functional object that will make it so we can only reroll when we have enough money, and subtracts money when we reroll
		
		// Base create event stuffs
		with (obj_ItemMGMT) {
			let i = 0;
			while (i < array_length(self.ItemID)) {
				if (self.ItemPrice[i] > 0) {
					self.ItemPrice[i] = floor(self.ItemPrice[i] / 2);
				}
				i += 1;
			}
		}

		obj_ItemMGMT.BaseRerolls = 3;



		this.glass_helper = instance_create_depth(0, 0, 0, obj_functional_object, {	
			on_create : function(this) {
				
			},
			on_draw : function(this) {
				
			},
			on_step : function(this) {
				if (global.GameMode == 1) {
					let item_manager = instance_find(obj_ItemMGMT, 0);

					let WhatSlot = 1;
					while (WhatSlot <= 7) {
						if (item_manager.Item[WhatSlot] != -1 and item_manager.ItemInst[WhatSlot] != -1) {
							with (item_manager.ItemInst[WhatSlot]) {
								if (alarm_get(0) == 0) {
									if (self.MyItemID != 99 and self.MyItemID != 31) {
										let _Odds = irandom(19);
										let item_mgmt = instance_find(obj_ItemMGMT, 0);
										
										if (_Odds == 1) {
											item_mgmt.Item[self.WhatSlot] = -1;
											item_mgmt.ItemInst[self.WhatSlot] = -1;
											
											if (self.ItemTemporary == true) {
												if (item_mgmt.TempMutate[self.WhatSlot] != -1) {
													instance_activate_object(item_mgmt.TempMutate[self.WhatSlot]);
													instance_destroy(item_mgmt.TempMutate[self.WhatSlot]);
													item_mgmt.TempMutate[self.WhatSlot] = -1;
												}
												
												if (item_mgmt.RemItem[self.WhatSlot] != -1) {
													if (instance_exists(item_mgmt.RemItem[self.WhatSlot])) {
														instance_activate_object(item_mgmt.RemItem[self.WhatSlot]);
														instance_destroy(item_mgmt.RemItem[self.WhatSlot]);
													}
													
													item_mgmt.RemItem[self.WhatSlot] = -1;
												}
											}
											
											scr_FX_ItemExplosion(1);
											instance_destroy(self);
										}
									}
								}
							}
						}

						WhatSlot += 1;
					}
				}
			},
			// This name gets printed if this object errors
			name : "glass_helper",


		})


		/*
		var object_depth = any(obj_ItemMGMT).depth - 4 // Create the object 1 depth above all the reroll buttons
		this.reroll_object = instance_create_depth(0, 0, object_depth, obj_functional_object, {
			on_create : function(this) {
				// There are 3 types of reroll buttons: shop, cafe, and black market. We need to check for the existence of any of them.
				this.button_objects = [obj_RerollBtn, obj_RerollBtnCafe, obj_RerollBtnBM]

				// For the regular shop, we want to track the cost for cafe and normal reroll independently.
				this.costs = [2, 2, 2]

				// If this is true, costs will not reset when entering a shop. This is set in supervisors.gml to prevent loading an autosave resetting costs.
				this.skip_reset = false;

			},
			on_step : function(this) {

				// These variables are made to track how much rerolls you have in the button when you're not there (?)
				// We don't need these.
				any(obj_ItemMGMT).RerollInfoCafe = -1
				any(obj_ItemMGMT).RerollInfoNubbyMart = -1

				with (this) {
					var i = array_length(button_objects)
					// no for loops in catspeak, we must use while
					while (i > 0) {
						i -= 1;
						var button = any(button_objects[i]) 
						if (!instance_exists(button)) {
							continue
						}

						// Button exists. We have its instance.
						if (global.Money >= costs[i]) {
							// We can reroll.
							if (button.RerollLimit == -1) {
								// If we disabled reroll, renable
								button.RerollLimit = 1
							}

							// If button was pressed, reroll limit will be 0
							// we only check once reroll limit hits 0
							if (button.RerollLimit == 0) {
								button.RerollLimit = 1
								scr_PayMoney(costs[i])
								costs[i] += 1

								// double autosave, since rerolling already does that, but whatever.
								// it's possible that this could be avoided by registering an autosave callback and checking if the button was pressed there.
								scr_Save_AutoSave(1);
							}
						}
						else {
							// Disable
							button.RerollLimit = -1
						}
					}
					

					// Quite conveniently, when entering or exiting the shop or black market, ItemMGMT's alarm 0 event becomes 15. Perfect time to reset costs.
					with (obj_ItemMGMT) {
				
						if (alarm_get(0) == 15) {
							if this.skip_reset {
								this.skip_reset = false;
							}
							else {
								other.costs[0] = 2
								other.costs[1] = 2
								other.costs[2] = 2
							}
						}
					}
				}
			},
			on_draw : function(this) {
				with (this) {
					var i = array_length(self.button_objects)
					while (i > 0) {
						i -= 1;
						var button = any(button_objects[i])
						if (!instance_exists(button)) {
							continue
						}
						// Draw price
						if (global.Money >= costs[i]) {
							draw_set_color(c_white)
						}
						else {
							draw_set_color(0x6666FF)
						}
						draw_set_halign(fa_center)
						draw_set_valign(fa_middle)
						var price_length = string_width(costs[i])
						draw_text(button.x, (button.y + 45), costs[i])
						draw_sprite(spr_GoldCoinSm, 0, (button.x + price_length + 10), (button.y + 45))
					}
				}
			},
			// This name gets printed if this object errors
			name : "gambler_tony_reroll_object",
		})*/
	}

	sv.on_destroy = function(this) {
		if (instance_exists(this.glass_helper)) {
			instance_destroy(glass_helper)
		}
	}



	// Return our supervisor struct so it can be registered in supervisors.gml
	return sv;
}