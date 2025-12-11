construct = function() {
	// Reliable way to get your own mod ID
	var mod_id = global.cmod.mod_id

	// Create the supervisor struct
	var sv = {}

	// The translation key of the supervisor's name
	sv.display_name = mod_identifier(mod_id, "balogna_supervisor_name");

	// mod_identifier is a quick way to combine our mod ID and another string with a semicolon.
	// So in the call above, the result will be "example_mod:example_supervisor_name"


	// The translation key of the supervisor's description
	sv.description = mod_identifier(mod_id, "balogna_supervisor_desc");



	// This is the supervisor's sprite struct.
	// You only actually need 2 sprites: idle, which is shown during gameplay,
	// and preview, which is shown on the selection screen.

	// Any states/emotions you don't supply use the idle sprite.
	
	sv.sprites = {
		idle_neutral : spr_SV7IdleNeutral,
		preview : spr_SVPrev_Balogna,
		angry : spr_SV7Angry,
		evil : spr_SV7Evil,
		happy : spr_SV7Happy,
		head_swivel : spr_SV7HeadSwivel,
		idle_grimace : spr_SV7IdleGrimace,
		idle_happy : spr_SV7IdleHappy,
		idle_sad : spr_SV7IdleSad,
		idle_weird : spr_SV7IdleWeird,
		sad : spr_SV7Sad,
		scream : spr_SV7Scream,
		talk : spr_SV7Talk,
	}


	sv.clicked_sounds = [
		au_TonyBalogna_VO1,
		au_TonyBalogna_VO2,
		au_TonyBalogna_VO3
	];
	
	sv.go_sound = au_Tony_VOGo;
	// Supervisor selection name color
	// Catspeak supports colors in this format: #RRGGBB
	sv.name_color = #000000

	// Cost in stars
	// Can be set to 0
	sv.cost = 0


	sv.on_create = function(this) {
		// Basic stat randomization, just have it ready
		global.Gravity = choose(1.4, 1.7, 1.8, 1.9, 2, 2.1, 2.2, 2.3, 2.4);
		var level_manager = instance_find(obj_LvlMGMT, 0);
		level_manager.NubbyScale = choose(0.25, 0.5, 1, 1, 2, 3);
		level_manager.NubbyLaunchSpd = choose(15, 18, 20, 22, 24, 25, 26, 27, 28, 30);
		
		// Set random rare/ultrarare odds
		var _OddsType = choose(0, 1, 2, 3, 4);

		if (_OddsType == 1) {
			level_manager.ComnOdds = 900;
			level_manager.RareOdds = 100;
			level_manager.UltraRareOdds = 6;
			level_manager.PerkComnOdds = 900;
			level_manager.PerkRareOdds = 100;
			level_manager.PerkUltraRareOdds = 6;
		}
		if (_OddsType == 2) {
			level_manager.ComnOdds = 800;
			level_manager.RareOdds = 200;
			level_manager.UltraRareOdds = 12;
			level_manager.PerkComnOdds = 800;
			level_manager.PerkRareOdds = 200;
			level_manager.PerkUltraRareOdds = 12;
		}
		if (_OddsType == 3) {
			level_manager.ComnOdds = 850;
			level_manager.RareOdds = 150;
			level_manager.UltraRareOdds = 7;
			level_manager.PerkComnOdds = 850;
			level_manager.PerkRareOdds = 150;
			level_manager.PerkUltraRareOdds = 7;
		}
		if (_OddsType == 4) {
			level_manager.ComnOdds = 700;
			level_manager.RareOdds = 300;
			level_manager.UltraRareOdds = 20;
			level_manager.PerkComnOdds = 700;
			level_manager.PerkRareOdds = 300;
			level_manager.PerkUltraRareOdds = 20;
		}

		// Randomize item prices
		with (obj_ItemMGMT) {
			var i = 0;
			while (i < array_length(self.ItemID)) {
				self.ItemPrice[i] = irandom_range(0, 20);
				i += 1;
			}
		}

		this.balogna_helper = instance_create_depth(0, 0, 0, obj_functional_object, {
			on_create : function(this) {
				// used for when the gamemode changes (active/inactive)
				with (this) {
					self.changed_last_frame = false;
				}
			},
			on_draw : function(this) {

			},
			on_step : function(this) {
				with (this) {
					// when the gamemode is not in "play" mode anymore, check if it just changed and randomize the stuff again
					if (global.GameMode != 1) {
						if (self.changed_last_frame == true) {
							global.Gravity = choose(1.4, 1.7, 1.8, 1.9, 2, 2.1, 2.2, 2.3, 2.4);
							var level_manager = instance_find(obj_LvlMGMT, 0);
							level_manager.NubbyScale = choose(0.25, 0.5, 1, 1, 2, 3);
							level_manager.NubbyLaunchSpd = choose(15, 18, 20, 22, 24, 25, 26, 27, 28, 30);
							self.changed_last_frame = false;
						}
					} else {
						self.changed_last_frame = true;
					}

					// randomized timeline
					with (obj_TimeLineMGMT) {
						if (alarm_get(0) == 0) {
							self.TimeLine[1] = 0;
							self.TimeLine[2] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[3] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[4] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[5] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[6] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[7] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[8] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[9] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[10] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[11] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[12] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[13] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[14] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[15] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[16] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[17] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[18] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[19] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[20] = 3;
							self.TimeLine[21] = 5;
							self.TimeLine[22] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[23] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[24] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[25] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[26] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[27] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[28] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[29] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[30] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[31] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[32] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[33] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[34] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[35] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[36] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[37] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[38] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[39] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[40] = 3;
							self.TimeLine[41] = 5;
							self.TimeLine[42] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[43] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[44] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[45] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[46] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[47] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[48] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[49] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[50] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[51] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[52] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[53] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[54] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[55] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[56] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[57] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[58] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[59] = choose(0, 0, 1, 2, 3, 5, 6);
							self.TimeLine[60] = 3;
							self.TimeLine[61] = 5;
							self.TimeLine[62] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[63] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[64] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[65] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[66] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[67] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[68] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[69] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[70] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[71] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[72] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[73] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[74] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[75] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[76] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[77] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[78] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[79] = choose(0, 0, 1, 2, 5, 6);
							self.TimeLine[80] = 3;
							self.TimeLine[81] = 4;
						}
					}
				}
			},
			// This name gets printed if this object errors
			name : "balogna_helper",
		})
	}
	sv.on_destroy = function(this) {
		if (instance_exists(this.glass_helper)) {
			instance_destroy(balogna_helper)
		}
	}

	// Return our supervisor struct so it can be registered in supervisors.gml
	return sv;
}