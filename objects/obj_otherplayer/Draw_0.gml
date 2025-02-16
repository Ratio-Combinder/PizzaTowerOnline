/// @description has the most code
if room == rank_room or room == timesuproom or !viewable
	exit;
if gms_other_get_real(player_id, "room") != scr_gms_room()
	exit;

// player color
var col = image_blend;
var alp = image_alpha; // leftover because i'm lazy. don't delete unless you are willing to clean this code.

// pln hub color
if room == hub_roomPLN
	col = merge_colour(col, c_black, 0.4);

// taxi
if state == states.taxi
{	
	x = gms_other_get_real(player_id, "taxix");
	y = gms_other_get_real(player_id, "taxiy");
	var sprit = spr_taximove;
	
	baddieframe += 0.35;
	if baddieframe >= sprite_get_number(sprit)
		baddieframe = 0;
	
	draw_sprite_ext(sprit, baddieframe, x, y, 1, 1, image_angle, c_white, 1);
}
else
{
	var pausedcolor = (pause ? merge_colour(col, c_black, 0.75) : col);
	
	// baddie grabbie
	var baddiegrabbed = gms_other_get_real(player_id, "grabenemy");
	if sprite_exists(baddiegrabbed)
	&& state != states.backbreaker
	{
		if baddiegrabbed != spr_junk
		{
			if !pause
			{
				baddieframe += 0.35;
				if baddieframe >= sprite_get_number(baddiegrabbed)
					baddieframe = 0;
			}
			
			if gms_other_get_real(player_id, "grabenemycigar")
				baddiegrabbed = spr_sausagemansmoked_grabbed;
			draw_sprite_ext(baddiegrabbed, baddieframe, gms_other_get_real(player_id, "grabenemyx"), gms_other_get_real(player_id, "grabenemyy"), -xscale, yscale, 1, c_white, 0.5);
		}
		else
		{
			var baddiegrabbedimg = player_id % (sprite_get_number(baddiegrabbed) - 1);
			if gms_other_get_real(player_id, "grabenemycigar")
			{
				baddiegrabbed = spr_punchball;
				baddiegrabbedimg = 0;
			}
			draw_sprite_ext(baddiegrabbed, baddiegrabbedimg, gms_other_get_real(player_id, "grabenemyx"), gms_other_get_real(player_id, "grabenemyy"), (baddiegrabbed == spr_punchball ? abs(xscale) : -xscale), yscale, 1, c_white, 0.5);
		}
	}
	
	// ladder
	if gms_other_get_real(player_id, "hooked")
	{
		if !pause
		{
			baddieframe += 0.35;
			if baddieframe >= sprite_get_number(spr_flyingladder)
				baddieframe = 0;
		}
		
		draw_sprite_ext(spr_flyingladder, baddieframe, x - 16, gms_other_get_real(player_id, "hooky"), 1, 1, image_angle, c_white, 0.5);
	}
	
	// pet
	var petind = gms_other_get_real(player_id, "petind");
	if petind > -1
	{
		var petx = gms_other_get_real(player_id, "petx");
		var pety = gms_other_get_real(player_id, "pety");
		
		if petx == 0
			petx = x;
		if pety == 0
			pety = y;
		
		var petxscale = xscale;
		scr_petspr(petind);
		
		var petspr = spr_petidle;
		if floor(petx) != floor(petxprev) && petx != x
		{
			petspr = spr_petrun;
			petxscale = sign(petx - petxprev);
			petxprev = petx;
		}
		
		if !pause
		{
			petframe += 0.35 * sprite_get_speed(petspr);
			if petframe >= sprite_get_number(petspr)
				petframe -= sprite_get_number(petspr);
		}
		
		draw_sprite_ext(petspr, petframe, petx, pety, petxscale, 1, 0, pausedcolor, alp);
	}
	
	// determine some things, then draw
	var sprit = sprite_index;
	if !is_real(sprit) or !sprite_exists(sprit) or sprit == 0
		sprit = spr_player_idle;
	
	var _img = image_index;
	if state != states.cheeseball && state != states.cotton
	{
		if spr_palette == spr_peppalette && paletteselect == 17
			sprit = spr_player_petah;
		if spr_palette == spr_noisepalette && paletteselect == 15
			sprit = spr_playerN_chungus;
		if spr_palette == spr_snickpalette && paletteselect == 13
			sprit = spr_sbombic;
		if spr_palette == spr_pufferpalette
		{
			if x != xprevious
				sprit = spr_pufferfish_move;
			else
				sprit = spr_pufferfish_idle;
		}
	}
	
	// draw the player
	var flash = gms_other_get_real(player_id, "flash");
	if !flash
	{
		if is_real(spr_palette) && spr_palette != 0 && sprite_exists(spr_palette)
		&& (state != states.cheeseball or sprit == spr_playerSP_cheeseball or sprit == spr_playerPP_cheeseball) && (state != states.ghost or (sprit == spr_player_ghostend && _img >= 12) or spr_palette == spr_noisepalette)
			pal_swap_set(spr_palette, paletteselect, false);
	}
	else
		draw_set_flash(true);
	
	draw_sprite_ext(sprit, _img, x, y, xscale, yscale, img_angle, pausedcolor, alp);
	pal_swap_reset();
	
	draw_set_flash(false);
	
	// pizza shield
	if gms_other_get_real(player_id, "pizzashield")
	{
		if !pause
		{
			shieldframe += 0.35;
			if shieldframe >= sprite_get_number(spr_pizzashield)
				shieldframe = 0;
		}
		draw_sprite_ext(spr_pizzashield, shieldframe, x, y, xscale, yscale, image_angle, pausedcolor, alp);
	}
	
	// cowboy hat
	var cowboy = gms_other_get_real(player_id, "cowboy");
	if sprite_exists(cowboy)
	{
		if !pause
		{
			cowboyframe += sprite_get_speed(cowboy);
			if cowboyframe >= sprite_get_number(cowboy)
				cowboyframe -= sprite_get_number(cowboy);
		}
		
		var yplus = lengthdir_y(-sprite_get_bbox_top(sprit) + 40, img_angle + 90);
		draw_sprite_ext(cowboy, cowboyframe, x, y + yplus, xscale, yscale, img_angle, pausedcolor, alp);
	}
	
	// treasure
	var treasure = gms_other_get_real(player_id, "treasure");
	if sprite_exists(treasure)
	{
		if !pause
		{
			baddieframe += 0.35;
			if baddieframe >= sprite_get_number(treasure)
				baddieframe = 0;
		}
		var treasure_x = x;
		var treasure_y = y - 35;
		
		if sprit == spr_playerSP_gottreasure
		{
			treasure_x -= 25;
			treasure_y -= 25;
		}
		draw_sprite_ext(treasure, baddieframe, treasure_x, treasure_y, 1, 1, image_angle, c_white, 1);
	}
}

// draw name
var typingy;
if global.shownames
{
	// get the player's name
	var nickname = gms_other_get_string(player_id, "nickname");
	if nickname == ""
		nickname = name;
	if global.streamer
		nickname = "Player" + string(player_id);
	
	// apply the color
	var nickcol = col;
	if gms_other_isowner(player_id)
		nickcol = c_owner;
	else if nickname == "DenchickMario"
		nickcol = c_pvp;
	else if gms_other_admin_rights(player_id)
		nickcol = c_admin;
	else if gms_other_get_real(player_id, "pvp")
		nickcol = c_pvp;
		
	draw_set_colour(make_colour_hsv(color_get_hue(nickcol), color_get_saturation(nickcol), color_get_value(nickcol) * (color_get_value(col) / 255)));
	
	// setup
	draw_set_font(global.font_small);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_alpha(alp);
	
	var yy = clamp(sprite_get_bbox_top(sprit)+ y - 75, 0, room_height - 16);
	if room == custom_lvl_room // ignore room boundaries in a custom level
		yy = sprite_get_bbox_top(sprit) + y - 75;
	
	// draw it
	draw_text(x, yy, nickname);
	
	// reset
	draw_set_alpha(1);
	draw_set_colour(c_white);
	typingy = sprite_get_bbox_top(sprit) + y - 95;
}
else
	typingy = sprite_get_bbox_top(sprit) + y - 75;

// typing indicator
var panicy = typingy;

var get_chat = gms_other_get_real(player_id, "chat");
if get_chat or gms_other_get_real(player_id, "busy")
{
	draw_set_font(global.font_small);
	draw_set_colour(get_chat ? c_white : merge_colour(c_red, c_white, 0.5));
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text(x, typingy, "...");
	panicy -= 16;
}

// panic timer
var panic = gms_other_get_real(player_id, "panic");
if panic > 0
{
	var minutes = gms_other_get_real(player_id, "panic_min");
	var seconds = gms_other_get_real(player_id, "panic_sec");
	
	var purple = make_colour_rgb(152, 80, 248);
	var dark_purple = make_colour_rgb(88, 0, 184);
	
	draw_set_font(global.bigfont);
	
	if panic == 3
		draw_set_colour(minutes < 1 && seconds <= 30 ? merge_colour(dark_purple, c_red, 0.5) : dark_purple);
	else if panic == 2
		draw_set_colour(minutes < 1 && seconds <= 30 ? merge_colour(purple, c_red, 0.5) : purple);
	else
		draw_set_colour(minutes < 1 && seconds <= 30 ? c_red : c_white);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text_transformed(x + random_range(-1, 1), panicy + random_range(-1, 1), string(minutes) + ":" + (seconds < 10 ? "0" : "") + string(seconds), 0.5, 0.5, 1);
}
