function scr_player_Sjump()
{
	hsp = 0
	mach2 = 0
	
	jumpAnim = true
	dashAnim = true
	landAnim = false
	moveAnim = true
	stopAnim = true
	crouchslideAnim = true
	crouchAnim = false
	machhitAnim = false
	
	move = key_right + key_left
	sjump = false
	
	// set vsp
	if global.gameplay == 0 or sprite_index == spr_playerV_superjump2
	{
		sjumpvsp = -15;
		vsp = sjumpvsp;
	}
	
	if (sprite_index == spr_superjump or sprite_index == spr_playerV_superjump2 or sprite_index == spr_superspringplayer) && (character != "V" or springsjump)
		vsp = sjumpvsp;
	sjumpvsp -= 0.1;
	
	if character == "V" && image_index > 3 && !springsjump
		vsp = -11
	
	if sprite_index == spr_player_supersidejump
	{
		if a < 25
			a ++
		hsp = xscale * a
		vsp = 0
	}
	
	vsp *= gravmult;
	
	//Back to other states
	//Freefallland
	if scr_solid(x, y - 1) && !place_meeting(x, y - 1, obj_destructibles) && !(place_meeting(x, y - 1, obj_metalblock) && (springsjump or check_sugary()))
	{
		// attempt to push player slightly
		var closest = 0;
		for(var i = 0; i < 16; i++)
		{
			if !scr_solid(x + i, y - 1)
			{
				closest = i;
				break;
			}
		}
		for(var i = 0; i < 16; i++)
		{
			if !scr_solid(x - i, y - 1)
			{
				if abs(i) > closest
					closest = i;
				break;
			}
		}
		if closest != 0
			x += closest;
		else
		{
			// you CLEARLY hit the ceiling there is no forgiveness
			springsjump = false;
			a = 0;
		
			if sprite_index = spr_player_supersidejump
				sprite_index = spr_player_supersidejumpland
		
			if sprite_index == spr_superjump or sprite_index == spr_playerV_superjump2 or sprite_index == spr_superspringplayer
			{
				/*
				if sprite_index == spr_superspringplayer && character == "SP"
					sprite_index = spr_playerSP_hitceiling;
				else
				*/
					sprite_index = spr_superjumpland;
			}
		
			with obj_camera
			{
				shake_mag = 10;
				shake_mag_acc = 30 / room_speed;
			}
			
			with obj_baddie
			{
				if point_in_camera(x, y, view_camera[0])
				{
					image_index = 0
					if grounded
						vsp = -7
				}
			}
		
			audio_stop_sound(sfx_groundpound)
			scr_soundeffect(sfx_groundpound)
			image_index = 0
			state = states.Sjumpland
			machhitAnim = false
		}
	}
	else if sprite_index == spr_player_Sjumpcancelstart
	{
		vsp = 0
		if move != 0
			xscale = move
		if floor(image_index) == image_number - 1
		{
			vsp = -5
			movespeed = 12
			image_index = 0
			sprite_index = spr_player_Sjumpcancel
			state = states.punch
			with instance_create(x, y, obj_crazyruneffect)
			    image_xscale = other.xscale
		}
	}
	else
	{
		if (sprite_index != spr_superspringplayer or sprite_index == spr_superjump)
		{
			if (key_attack2 or key_slap2) && (!(character == "N" && noisetype == 0) && character != "V" && (character != "SP" or global.gameplay != 0))
			{
				if global.gameplay != 0 && character == "P"
				{
					image_index = 0
					sprite_index = spr_player_Sjumpcancelstart
				}
				else
				{
					jumpstop = false;
					springsjump = false;
					if move != 0
						xscale = move
				
					sprite_index = spr_mach4
					if global.gameplay != 0
					{
						image_index = 0
						sprite_index = spr_dashpadmach
					}
					state = states.mach3
					movespeed = 12
				}
			}
			else if key_attack2 && character == "SP"
			{
				landAnim = false;
				mach2 = 35;
				momentum = true;
				jumpstop = true;
				springsjump = false;
		
				if move != 0
					xscale = move
				dir = xscale;
		
				scr_soundeffect(sfx_suplexdashSP)
				movespeed = 10
				sprite_index = spr_mach2jump
		
				with instance_create(x, y, obj_mach3effect)
				{
					vspeed = 4;
					hspeed = 8;
			
					playerid = other.object_index
					image_index = other.image_index - 1
					image_xscale = other.xscale
					sprite_index = other.sprite_index
				}
				with instance_create(x, y, obj_mach3effect)
				{
					vspeed = 4;
					hspeed = -8;
			
					playerid = other.object_index
					image_index = other.image_index - 1
					image_xscale = other.xscale
					sprite_index = other.sprite_index
				}
		
				flash = true
				state = states.mach2
				vsp = -10
				exit;
			}

			if character == "N" && key_jump2 && noisetype == 0
			{
				springsjump = false;
			
				scr_soundeffect(sfx_jump)
				scr_soundeffect(sfx_woosh)
				jumpstop = false
				vsp = -15
				state = states.jump
				sprite_index = spr_playerN_noisebombspinjump
				image_index = 0
				with instance_create(x, y, obj_jumpdust)
				image_xscale = other.xscale
			}
			
			//Jetpack
			if key_attack2 && character == "N" && noisetype == 0
			{
				springsjump = false;
				scr_soundeffect(sfx_noisewoah)
				state = states.Sjumpprep
				image_index = 0
				sprite_index = spr_playerN_jetpackstart
				hsp = 0
				vsp = 0
				if move != 0
					xscale = move
			}

			//Spin attack
			if key_slap2 && !key_up && character == "N" && noisetype == 0
			{
				springsjump = false;
				state = states.punch
				sprite_index=  spr_playerN_spin
				image_index = 0
				movespeed = 15
			}

			//Stir
			if character == "N" && noisetype == 0
			{
				if move = 1
					hsp = 3
				if move = -1
					hsp = -3
			}


			if character == "V"
			&& floor(image_index) >= image_number - 1
			{
				state = states.jump
				sprite_index = spr_playerV_fall
			}
		}
		else if character == "V" && floor(image_index) >= 8
			sprite_index = spr_playerV_superjump2
	}
	
	//Animations
	image_speed = 0.5
}

