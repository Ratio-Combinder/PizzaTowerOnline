if cooldown <= 0 && !instance_exists(boulderID)
{
	with instance_create(x, y, obj_boulder)
	{
		image_xscale = other.image_xscale 
		other.boulderID = id
	}
	if global.gameplay != 0
	{
		cooldown = 1000;
		instance_create(x, y, obj_genericpoofeffect);
	}
}
if cooldown > 0
	cooldown--;

