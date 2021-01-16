.float timer_item_cnt;
.float old_cnt;
.float old_item_cnt;

void() hud_message2_think = 
{
	if (self.owner.item_cnt)
	{
		self.item_cnt += self.owner.item_cnt;
		self.owner.item_cnt = 0;
		self.cnt = 20;
	}
	self.old_item_cnt = self.item_cnt;
	self.cnt -= 1;
	self.SendFlags |= 0x2;
	if (self.cnt > 0)
		self.think = hud_message2_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};
.float alwaystouchable;

void(entity e) flash_screen_item =
{
	float checked_flash = cvar("saved6");
	if(checked_flash != 1)
		return;
	string flash_command_a = strcat ("bf ",ftos(flash_color_x)," ",ftos(flash_color_y)," ");
	string flash_command_b = strcat (ftos(flash_color_z)," ",ftos(flash_alpha)," ",ftos(flash_fade),"\n");
	string flash_command =  strcat (flash_command_a,flash_command_b);
	stuffcmd (e, flash_command);
}


float() Send_Item2 = 
{
	WriteByte(MSG_ENTITY, ENT_HUDMSG2);
	WriteShort(MSG_ENTITY, self.msg);
	WriteShort(MSG_ENTITY, self.item_cnt);
	return TRUE;
};

float() Send_Item = 
{
	WriteByte(MSG_ENTITY, ENT_HUDMSG);
	WriteShort(MSG_ENTITY, self.msg);
	return TRUE;
};

void(float mtype, vector org, entity ownr, float item_cntr) Hud_message2 = 
{
	local entity HudMessage;
	if(!(ownr.flags & FL_CLIENT))return;if (ownr.classname != "player")return;
	HudMessage = spawn();
	HudMessage.owner = ownr;
	HudMessage.drawonlytoclient = ownr;
	setmodel(HudMessage, "models/misc/null.md3");
	HudMessage.origin = org + '0 0 25';
	HudMessage.movetype = MOVETYPE_NOCLIP;
	HudMessage.msg = mtype;
	HudMessage.item_cnt = item_cntr;
	HudMessage.cnt = 20;
	HudMessage.wrathflags += FL_MESSAGE;
	HudMessage.SendEntity = Send_Item2;
	//	HudMessage.SendFlags |= 0x2;
	HudMessage.SendFlags = -1;
	HudMessage.think = hud_message2_think;
	HudMessage.nextthink = time;
};
.float fullitemtime;
void(float mtype, vector org, entity ownr) Hud_message = 
{ 
	if(!(ownr.flags & FL_CLIENT))
		return;
	if (ownr.classname != "player")
		return;
	ownr.stat_time_hudmessage = 1;
	/*if(mtype == 109)
	{
	if(ownr.time_hudmessage > time)
	return;
	}*/
	ownr.time_hudmessage = time + 2;
	local entity HudMessage;
	HudMessage = spawn();
	HudMessage.classname = "hudmessage";
	HudMessage.drawonlytoclient = ownr;
	setmodel(HudMessage, "models/misc/null.md3");
	HudMessage.origin = org + '0 0 25';
	HudMessage.movetype = MOVETYPE_NOCLIP;
	HudMessage.msg = mtype;
	HudMessage.wrathflags += FL_MESSAGE;
	HudMessage.SendEntity = Send_Item;
	//	HudMessage.SendFlags  = self.SendFlags  + 1;
	HudMessage.SendFlags = -1;
	HudMessage.think = SUB_Remove;
	HudMessage.nextthink = time + 2;
	
};

void() Message_delay =
{
	self.classname = "hudmessage";
	self.SendEntity = Send_Item;
	//	HudMessage.SendFlags  = self.SendFlags  + 1;
	self.SendFlags = -1;
	self.think = SUB_Remove;
	self.nextthink = time + 2;
}	

void(float mtype, vector org, entity ownr) Hud_message_delay = 
{
	

	if(!(ownr.flags & FL_CLIENT))return;if (ownr.classname != "player")return;
	ownr.stat_time_hudmessage = 1;
	ownr.time_hudmessage = time + 2;
	local entity HudMessage;
	HudMessage.wrathflags += FL_MESSAGE;
	HudMessage = spawn();
	HudMessage.classname = "hudmessage_delay";
	HudMessage.drawonlytoclient = ownr;
	setmodel(HudMessage, "models/misc/null.md3");
	HudMessage.origin = org + '0 0 25';
	HudMessage.movetype = MOVETYPE_NOCLIP;
	HudMessage.msg = mtype;
	HudMessage.nextthink = time + 0.5;
	HudMessage.think = Message_delay;
	
};


void() respawn_items = 
{ 
	self.pflags =  self.oldpflags;
	self.touch = self.oldtouch; 
	self.solid = self.oldsolid;
	self.colormod = '1 1 1';
	self.alpha = 1;
	self.think = SUB_Null;
	self.nextthink = time; 
};

void() siframes = 
{
	/*if (self.frame >= 16)
		self.frame = 0; 
	self.frame += 1;
	*/

	self.nextthink = time + 0.05;	// items start after other solids
	self.think = siframes;
};

void() twframes = 
{
	if (self.frame >= 20)
		self.frame = 0;
	self.frame += 1;
	self.nextthink = time + 0.1;	// items start after other solids
	self.think = twframes;
};
.float rwpn;
void() artifact_drop = 
{
	

	if(self.flags & FL_ONGROUND)
	self.flags -= FL_ONGROUND;
	self.movetype = MOVETYPE_TOSS;
	self.velocity_x = crandom() *10;
	self.velocity_y = crandom() *10;
	self.velocity_z = 50 + random() *70;
}


void()check_item_onfloor =
{
	local vector rintvelocity;
	rintvelocity_x = rint(self.velocity_x);
	rintvelocity_y = rint(self.velocity_y);

	if((rintvelocity_x == 0) && (rintvelocity_y == 0) &&(!(self.flags & FL_ONGROUND)))
	{
	self.movetype = MOVETYPE_TOSS;
	self.velocity_x = crandom() *10;
	self.velocity_y = crandom() *10;
	self.velocity_z = random() *10;
	}

	if((self.flags & FL_ONGROUND) && (self.oldgroundentity == world))	
	self.think = SUB_Null;
	else
	self.think = check_item_onfloor;
	
	self.nextthink = time  + 0.05;
};

void() vel_item = 
{
	self.solid = SOLID_TRIGGER;
	
	local vector rintvelocity;
	rintvelocity_x = rint(self.velocity_x);
	rintvelocity_y = rint(self.velocity_y);

	if((rintvelocity_x == 0) && (rintvelocity_y == 0) &&(!(self.flags & FL_ONGROUND)))
	{
	self.movetype = MOVETYPE_TOSS;
	self.velocity_x = crandom() *10;
	self.velocity_y = crandom() *10;
	self.velocity_z = random() *10;
	}
	
	if((self.flags & FL_ONGROUND) && (self.oldgroundentity == world))	
	self.think = SUB_Null;
	else
	self.think = vel_item;

	self.nextthink = time + 0.05;
};
void() PlaceItem = {

	self.origin_z = self.origin_z + 12;
	self.movetype = MOVETYPE_TOSS;
	if (!droptofloor())
	{
		dprint("Bonus item fell out of level at ");
		dprint(vtos(self.origin));
		dprint("\n");
		remove(self);
		return;
	}
	local float oldz;
	self.solid = SOLID_TRIGGER;
	if (self.rwpn == 1)
	{
		self.modelflags = MF_ROTATE;
	}
	self.velocity = '0 0 0';
	oldz = self.origin_z;
};

void(float ie) StartItem = {

	if(self.classname == "bbox_touch")
	return;
	if (ie == 1)
	{
	}
	else if (ie == 2)
	{
	}
	else if (ie == 3)	//life
	{
		self.scale = 0.5;
		self.pflags = 128 | 1;
	}
	else if (ie == 4)	//armor
	{
		self.style = 0;
		self.pflags = 128 | 1;
	}
	else if (ie == 5)	//artifacts
	{
		self.modelflags = 8;
		self.effects = EF_ADDITIVE;
		self.cnt = 1;
		self.solid = SOLID_TRIGGER;
		self.nextthink = time + 0.2;	// items start after other solids
		self.think = siframes;
		return;
	}
	else if (ie == 6)	//sigil
	{
		self.light_lev = 125;
		self.pflags = 128 | 1;
		self.color = '0.3 1 0.3';
		self.style = 6;
		setsize(self, '-12 -12 -16', '12 12 16');
		self.cnt = 1;
	}
	self.use = artifact_drop;
	self.nextthink = time + 0.2;	// items start after other solids
	self.think = PlaceItem;
};

void() start_key = 
{
	copy_old_data(self);
		self.use = artifact_drop;
		self.nextthink = time + 0.2;	// items start after other solids
		self.think = PlaceItem;
		self.wrathflags = FL_RESPAWN;
	}
	.float msg2;
.float itemisweapon;
.float time_emptymessage;
////////////////////////////////
///weapons and ammo///
////////////////////////////////
void() wammo_touch = 
{
	
		
	if(!(other.flags & FL_CLIENT))
		return;
	if (other.classname != "player")
		return;
	if ((other.items &self.items))
	{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	if ((other.attack_finished > time) && (self.itemisweapon == 1))
		return;
	
	if (self.msg == 90)
	{
		other.coachgunclip = 3;
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;
		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))
		other.oldimpulse = 2;
		other.itemtime = time + 0.5;
		Hud_message(35, other.origin, other);
	}
	if (self.msg == 91)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;

		other.oldimpulse = 3;
		other.itemtime = time + 0.5;
		Hud_message(35, other.origin, other);
	}
	if (self.msg == 92)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;
		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 4;
		other.itemtime = time + 0.5;
		Hud_message(35, other.origin, other);
	}
	if (self.msg == 93)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;
		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 5;
		other.itemtime = time + 0.5;
		Hud_message(35, other.origin, other);
	}

	if (self.msg == 94)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;

		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 6;
		other.itemtime = time + 0.5;
		Hud_message(35, other.origin, other);
	}
	if (self.msg == 95)
	{
		other.time_pickupweapon = time + 0.75;
		if (self.spawnflags &1)
			other.time_pickupweapon = 0;

		//if ((time > other.attack_finished) && (!other.button0) && (!other.button3))		
		other.oldimpulse = 7;
		other.itemtime = time + 0.5;
		Hud_message(35, other.origin, other);
	}
	if (self.msg == 18)
	{
		if ((other.ammo_coachgun >= max_ammo_coachgun )&& (self.alwaystouchable != 1))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
		if ((other.ammo_coachgun <= 0))
		{
			other.precoachgunclip = 1;
			if ((other.weapon == IT_COACHGUN) && (other.vweaponframe == 0))
				stuffcmd(other, "impulse 30\n");
		}
	}
	if (self.msg == 19)
	{
		if ((other.ammo_cannon >= max_ammo_cannon )&& (self.alwaystouchable != 1))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	}
	if (self.msg == 20)
	{
		if ((other.ammo_shotgun >= max_ammo_shotgun)&& (self.alwaystouchable != 1))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
		if ((other.weapon == IT_SHOTGUN) && (other.empty_shells == 1))
		{
			stuffcmd(other, "impulse 36\n");
		}
	}

	if (self.msg == 21)
	{
		if ((other.ammo_spitter >= max_ammo_spitter)&& (self.alwaystouchable != 1))
			{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	}
	if (self.msg == 25)
	{
		if ((other.ammo_lance >= max_ammo_lance)&& (self.alwaystouchable != 1))
			{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	}
	if (self.msg == 30)
	{
		if ((other.ammo_retcher >= max_ammo_retcher) && (self.alwaystouchable != 1))
			{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
		if ((other.ammo_retcher <= 0))
		{
			other.preloadcyst = 1;
			if ((other.weapon == IT_RETCHER) && (other.vweaponframe == 0))
				stuffcmd(other, "impulse 34\n");
		}
	}
	if(deathmatch)
		other.time_pickupweapon = 0;
	other.items += self.items;
	other.ammo_coachgun = self.ammo_coachgun + other.ammo_coachgun;
	if (other.ammo_coachgun > max_ammo_coachgun)
		other.ammo_coachgun = max_ammo_coachgun;
	other.ammo_shotgun = self.ammo_shotgun + other.ammo_shotgun;
	if (other.ammo_shotgun > max_ammo_shotgun)
		other.ammo_shotgun = max_ammo_shotgun;
	other.ammo_cannon = self.ammo_cannon + other.ammo_cannon;
	if (other.ammo_cannon > max_ammo_cannon)
		other.ammo_cannon = max_ammo_cannon;
	other.ammo_spitter = self.ammo_spitter + other.ammo_spitter;
	if (other.ammo_spitter > max_ammo_spitter)
		other.ammo_spitter = max_ammo_spitter;
	other.ammo_retcher = self.ammo_retcher + other.ammo_retcher;
	if (other.ammo_retcher > max_ammo_retcher)
		other.ammo_retcher = max_ammo_retcher;
	other.ammo_lance = self.ammo_lance + other.ammo_lance;
	if (other.ammo_lance > max_ammo_lance)
		other.ammo_lance = max_ammo_lance;

	if (self.msg)
		Hud_message(self.msg, other.origin, other);
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	SUB_UseTargets();

	if (self.ammo_coachgun)	// 4-8
	{
		other.slugspulsetime = time + 0.5;
		if (other.slugspulsetime > time)
		{
			if (!(other.pulseicons &8))
				other.pulseicons += 8;
			other.rslugspulsetime = time + 0.01;
		}
	}
	if (self.ammo_shotgun)	// 16- 32
	{
		other.shellspulsetime = time + 0.5;
		if (other.shellspulsetime > time)
		{
			if (!(other.pulseicons &32))
				other.pulseicons += 32;
			other.rshellspulsetime = time + 0.01;
		}
	}
	if (self.ammo_spitter)	// 64 - 128
	{
		other.spitterpulsetime = time + 0.5;
		if (other.spitterpulsetime > time)
		{
			if (!(other.pulseicons &64))
				other.pulseicons += 64;
			other.rspitterpulsetime = time + 0.01;
		}
	}
	if (self.ammo_retcher)	//256 - 512
	{
		other.retcherpulsetime = time + 0.5;
		if (other.retcherpulsetime > time)
		{
			if (!(other.pulseicons &256))
				other.pulseicons += 256;
			other.rretcherpulsetime = time + 0.01;
		}
	}
	if (self.ammo_cannon)	//1024 - 2048
	{
		other.cannonpulsetime = time + 0.5;
		if (other.cannonpulsetime > time)
		{
			if (!(other.pulseicons &1024))
				other.pulseicons += 1024;
			other.rcannonpulsetime = time + 0.01;
		}
	}
	if (self.ammo_lance)	//4096 - 8192
	{
		other.lancepulsetime = time + 0.5;
		if (other.lancepulsetime > time)
		{
			if (!(other.pulseicons &4096))
				other.pulseicons += 4096;
			other.rlancepulsetime = time + 0.01;
		}
	}

	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_message(27, other.origin, other);
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
	}


	flash_screen_item(other);
	if (deathmatch)
	{
		self.oldsolid = self.solid;
		self.oldtouch = self.touch;
		self.touch = SUB_Null;
		self.oldpflags = self.pflags;
		self.pflags =  0;
		self.alpha = 0.1;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.think = respawn_items;
		self.nextthink = time + 25;
		if(self.classname == "bbox_touch")
		{
		self.owner.oldpflags = self.pflags;
		self.owner.pflags =  0;
		self.owner.alpha = 0.1;
		self.owner.colormod = '0.5 0.5 1';
		self.owner.solid = SOLID_NOT;
		self.owner.think = respawn_items;
		self.owner.nextthink = time + 25;
		}	
	}
	else
	{
	remove(self);
	if(self.classname == "bbox_touch")
	remove(self.owner);
	}

};

void() weapon_shotgun = 
{
	self.items = IT_SHOTGUN;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/shotgun/w_shotgun.md3");
	self.ammo_shotgun = 2;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.rwpn = 1;
	//self.noise  ="items/shotgun.ogg";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg = 91;
	setsize(self, '-12 -12 -24' ,'12 12 8');
};

void() weapon_coachgun = 
{
	self.items = IT_COACHGUN;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/coachgun/w_coachgun.md3");
	self.ammo_coachgun = 3;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.rwpn = 1;
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg =90;
	setsize(self, '-12 -12 -24' ,'12 12 8');
};

void() weapon_retcher = 
{
	self.items = IT_RETCHER;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/retcher/w_retcher.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	self.ammo_retcher = 6;
	self.scale = 1;
	self.rwpn = 1;
	StartItem(1);
	self.origin_z += 24;
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg = 93;
};

void() weapon_spitter = 
{
	self.items = IT_SPITTER;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/spitter/w_spitter.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	self.ammo_spitter = 20;
	self.rwpn = 1;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.touch = wammo_touch;
	self.msg =92;
};

void() weapon_cannon = 
{
	self.items = IT_CANNON;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/cannon/w_cannon.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.ammo_cannon = 20;
	self.rwpn = 1;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.touch = wammo_touch;
	self.msg = 94;
};

void() weapon_lance = 
{
	self.items = IT_LANCE;
	self.itemisweapon = 1;
	setmodel(self, "models/weapons/lance/w_lance.md3");
	setsize(self, '-12 -12 -24' ,'12 12 8');
	//self.noise  ="misc/null.wav";
	precache_sound(self.noise);
	self.ammo_lance = 20;
	self.rwpn = 1;
	self.scale = 1;
	StartItem(1);
	self.origin_z += 24;
	self.touch = wammo_touch;
	self.msg = 95;
};
void(entity ownr) spawn_bbox_collider =
{


ownr.wrathflags += FL_PICKUPABLE;
entity bbox_touch;
bbox_touch = spawn();
copyentity (ownr,bbox_touch);
bbox_touch.owner = ownr;
bbox_touch.classname = "bbox_touch";
bbox_touch.solid = SOLID_TRIGGER;
setmodel(bbox_touch,"models/misc/null.md3");

setsize(bbox_touch,bbox_touch.nsize_bbox,bbox_touch.size_bbox);
//bbox_touch.touch = bbox_touch.owner.oldtouch;
bbox_touch.movetype = MOVETYPE_FOLLOW;
bbox_touch.aiment = ownr;
bbox_touch.think = null;
ownr.solid = SOLID_NOT;
ownr.touch = null;
};
void() spawnfunc_ammo_shells = 
{
	self.noise = "items/shells.ogg";
	self.ammo_shotgun = 20;
	setmodel(self, "models/items/shells.md3");
	setsizeitem2(self, shells_size);
	self.msg = 20;
	precache_sound(self.noise);
	StartItem(1);
	self.scale = 1;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};


void() spawnfunc_ammo_slugs = 
{
	self.noise = "items/slugs.ogg";
	if (self.spawnflags)
	{
		self.ammo_coachgun = 15;
		setmodel(self, "models/items/slugs.md3");
		setsizeitem2(self, shellsl_size);
		self.msg = 18;
	}
	else
	{
		self.ammo_coachgun = 15;
		setmodel(self, "models/items/slugs.md3");
		setsizeitem2(self, shellsl_size);
		self.msg = 18;
	}
	precache_sound(self.noise);
	StartItem(1);
	self.scale = 1;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};
void() ammo_cysts = 
{
	setmodel(self, "models/items/cysts.md3");
	self.noise = "items/cysts.ogg";
	if (self.spawnflags == 1)
	{
		setsizeitem2(self, explosives_size);
		self.ammo_retcher = retcher_ammount;
	}
	else if (self.spawnflags == 2)
	{
		setsizeitem2(self, explosivesl_size);
		self.ammo_retcher = retcher_ammount;
	}
	else
	{
		setsizeitem2(self, explosives_size);
		self.ammo_retcher = 9;
	}
	precache_sound(self.noise);
	StartItem(2);
	self.scale = 1;
	self.msg = 30;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};

void() spawnfunc_ammo_lance = 
{
	setmodel(self, "models/items/ammo_lance.md3");
	self.noise = "items/ammo_lance.ogg";
	setsizeitem2(self, explosives_size);
	self.ammo_lance = 10;
	precache_sound(self.noise);
	StartItem(2);
	self.classname = "lances";
	self.scale = 1;
	self.msg = 30;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
};

void() spawnfunc_ammo_ore = 
{
	if (self.spawnflags == 1)
	{
		setmodel(self, "models/items/ore.md3");
		setsizeitem2(self, orel_size);
		self.ammo_cannon = cannon_ammount;
		self.noise = "items/ore.ogg";
		self.msg = 19;
	}
	else
	{
		setmodel(self, "models/items/ore.md3");
		setsizeitem2(self, ore_size);
		self.ammo_cannon = cannon_ammount;
		self.noise = "items/ore.ogg";
		self.msg = 19;
	}
	precache_sound(self.noise);
	StartItem(2);
	self.scale = 1;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	};

void()wammo_special_touch =
{
return;
};



void() ammo_fangs = 
{
	self.noise = "items/fangs.ogg";

	if (self.spawnflags == 1)
	{
		setmodel(self, "models/items/fangs.md3");
		setsizeitem2(self, resinl_size);
		self.ammo_spitter = fang_ammount;
		self.msg = 21;
	}
	else
	{
		setmodel(self, "models/items/fangs.md3");
		setsizeitem2(self, resin_size);
		self.ammo_spitter = fang_ammount;
		self.msg = 21;
	}
	precache_sound(self.noise);
	StartItem(2);
	self.scale = 1;
	self.touch = wammo_touch;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

/////////////////////////
///armor &health///
/////////////////////////
void() larmor_touch = 
{
	if (other.classname != "player")
	if(!(other.flags & FL_CLIENT))		return;


	if ((other.health == 100) && (self.health))
	{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	other.health += self.health;
	if (other.health > 100)
		other.health = 100;
	if (self.health)
	{
		sound(other, CHAN_AUTO, "player/gain_health.ogg", 1, ATTN_NORM);
		other.healthpulsetime = time + 0.5;

		if (other.healthpulsetime > time)
		{
			if (!(other.pulseicons &2))
				other.pulseicons += 2;
			other.rhealthpulsetime = time + 0.01;
		}
	}

	if (self.rarmorvalue)	//8192 - 16384
	{
		if ((other.rarmorvalue == 100))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
		other.rarmorvalue += self.rarmorvalue;
		if (other.rarmorvalue > 100)
			other.rarmorvalue = 100;
		other.armorpulsetime = time + 0.5;
		if (other.armorpulsetime > time)
		{
			if (!(other.pulseicons &16384))
				other.pulseicons += 16384;
			other.rarmorpulsetime = time + 0.01;
		}
	}
	if (self.darmorvalue)	//32768 -65536
	{
		if ((other.darmorvalue == 100))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
		other.darmorvalue += self.darmorvalue;
		if (other.darmorvalue > 100)
			other.darmorvalue = 100;
		other.darmorpulsetime = time + 0.5;
		if (other.darmorpulsetime > time)
		{
			if (!(other.pulseicons &65536))
				other.pulseicons += 65536;
			other.rdarmorpulsetime = time + 0.01;
		}
	}
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();
	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_message(27, other.origin, other);
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
	}
	flash_screen_item(other);
	if (deathmatch)
	{
		self.oldsolid = self.solid;
		self.oldtouch = self.touch;
		self.touch = SUB_Null;
		self.alpha = 0.1;
		self.oldpflags = self.pflags;
		self.pflags =  0;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.think = respawn_items;
		self.nextthink = time + 25;
		if(self.classname == "bbox_touch")
		{
		self.owner.oldpflags = self.pflags;
		self.owner.pflags =  0;
		self.owner.alpha = 0.1;
		self.owner.colormod = '0.5 0.5 1';
		self.owner.solid = SOLID_NOT;
		self.owner.think = respawn_items;
		self.owner.nextthink = time + 25;
		}	
	}
	else
	{
	remove(self);
	if(self.classname == "bbox_touch")
	remove(self.owner);
	}


};

void() health_life_vial = 
{
	self.noise = "items/lifeblood_vial1.ogg";
	self.pflags = 129;
	self.health = 10;
	self.light_lev = 15;
	self.color = '3 0 0';
	self.colormod = '1 1 1';
	setmodel(self, "models/items/lifeblood_vial.md3");
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	setsizeitem2(self, vial_size);
	self.touch = larmor_touch;
//	self.nextthink = time + 0.2;	// items start after other solids
//	self.think = PlaceItem;
	self.msg = 11;

	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() health_life_beaker = 
{
	local float r;
	r = random() *3;
	if (r < 3)
		self.noise = ("items/lifeblood_beaker3.ogg");
	if (r < 2)
		self.noise = ("items/lifeblood_beaker2.ogg");
	if (r < 1)
		self.noise = ("items/lifeblood_beaker1.ogg");

	self.pflags = 129;
	self.health = 30;
	self.light_lev = 25;
	self.color = '3 0 0';
	self.colormod = '1 1 1';
	setmodel(self, "models/items/lifeblood_beaker.md3");
	self.touch = larmor_touch;
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	setsizeitem2(self, beaker_size);
	self.msg = 10;
//	self.nextthink = time + 0.2;	// items start after other solids
//	self.think = PlaceItem;
	spawn_bbox_collider(self);
	self.oldtouch = self.touch;
	
};

void() health_life_chalice = 
{
	self.noise = "items/lifeblood_vial3.ogg";
	self.pflags = 129;
	self.health = 50;
	self.light_lev = 32;
	self.color = '1 2 1';
	self.colormod = '1 5 1';
	setmodel(self, "models/items/lifeblood_vial.md3");
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	setsizeitem2(self, chalice_size);
	self.touch = larmor_touch;
//	self.nextthink = time + 0.2;	// items start after other solids
//	self.think = PlaceItem;
	self.msg = 11;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() health_life_heart = 
{
	self.noise = "items/lifeblood_beaker1.ogg";
	StartItem(3);
	self.health = 100;
	self.light_lev = 64;
	self.color = '0 1 3';
	self.colormod = '1 1 5';
	setmodel(self, "models/items/life_heart.spr");
	self.movetype = MOVETYPE_TOSS;
	self.solid = SOLID_TRIGGER;
	setsizeitem2(self, heart_size);
	self.touch = larmor_touch;
//	self.nextthink = time + 0.2;	// items start after other solids
//	self.think = PlaceItem;
	self.msg = 11;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_shard = 
{
	local float r;
	r = floor(random() *3);
	if (r < 1)
		self.noise = "items/armor_shard1.ogg";
	if (r < 2)
		self.noise = "items/armor_shard2.ogg";
	else
		self.noise = "items/armor_shard3.ogg";
	precache_sound(self.noise);
	self.rarmorvalue = 10;
	setmodel(self, "models/items/armor_shard.md3");
	setsize2(self, shard_nsize, shard_size);
	self.touch = larmor_touch;
	self.color = shard_light_col;
	self.light_lev = shard_lightlev;
	StartItem(4);
	self.msg = 13;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_helm = 
{
	self.noise = "items/helm1.ogg";
	precache_sound(self.noise);
	self.rarmorvalue = 30;
	setmodel(self, "models/items/helm.md3");
	setsize2(self, helm_nsize, helm_size);
	self.touch = larmor_touch;
	self.color = helm_light_col;
	self.light_lev = helm_lightlev;
	StartItem(4);
	self.msg = 9;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_armor = 
{
	self.noise = "items/armor1.ogg";
	precache_sound(self.noise);
	self.rarmorvalue = 50;
	setmodel(self, "models/items/armor.md3");
	setsize2(self, armor_nsize, armor_size);
	self.touch = larmor_touch;
	self.color = armor_light_col;
	self.light_lev = armor_lightlev;
	StartItem(4);
	self.msg = 2;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_shard_dark = 
{
	local float r;
	r = floor(random() *3);
	if (r < 1)
		self.noise = "items/armor_shard_dark1.ogg";
	if (r < 2)
		self.noise = "items/armor_shard_dark2.ogg";
	else
		self.noise = "items/armor_shard_dark3.ogg";
	precache_sound(self.noise);
	self.darmorvalue = 10;
	setmodel(self, "models/items/armor_shard_dark.md3");
	setsize2(self, dark_shard_nsize, dark_shard_size);
	self.touch = larmor_touch;
	self.color = dark_shard_light_col;
	self.light_lev = dark_shard_lightlev;
	StartItem(4);
	self.msg = 6;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_armor_dark = 
{
	self.noise = "items/armor_dark1.ogg";
	precache_sound(self.noise);
	self.darmorvalue = 50;
	setmodel(self, "models/items/armor_dark.md3");
	setsize2(self, dark_armor_nsize, dark_armor_size);
	self.touch = larmor_touch;
	self.color = dark_armor_light_col;
	//	self.skin = 1;
	self.light_lev = dark_armor_lightlev;
	StartItem(4);
	self.msg = 4;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() armor_helm_dark = 
{
	self.noise = "items/helm_dark1.ogg";
	precache_sound(self.noise);
	self.darmorvalue = 30;
	setmodel(self, "models/items/helm_dark.md3");
	setsize2(self, dark_helm_nsize, dark_helm_size);
	self.touch = larmor_touch;
	self.color = dark_helm_light_col;
	self.light_lev = dark_helm_lightlev;
	StartItem(4);
	self.msg = 5;
	self.oldtouch = self.touch;
	spawn_bbox_collider(self);
	
};

void() guardian_shield = {};
/////////////////
///artifacts///
/////////////////

	
void() artifact_touch = 
{
	if (other.classname != "player")
		return;
	if(!(other.flags & FL_CLIENT))		return;


	if ((other.Attar >= 9) && (self.Attar))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	if ((other.LifeSiphon >= 9) && (self.LifeSiphon))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	if ((other.TrinketofRespite >= 9) && (self.TrinketofRespite))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	if ((other.Aegis >= 9) && (self.Aegis))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	if ((other.DrownerApp >= 9) && (self.DrownerApp))
		{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	if ((!(other.centerprint_messages &1)) && (!self.SoulTether))
	{
		Hud_message(256, other.origin, other);
		other.centerprint_messages += 1;
	}
	if((self.SoulTether) && (!(other.centerprint_messages &4)) )
	{	
		Hud_message(260, other.origin, other);
		other.centerprint_messages += 4;
	}

	other.LifeSiphon += self.LifeSiphon;
	other.SoulTether += self.SoulTether;
	other.Attar += self.Attar;
	
	
	other.TrinketofRespite += self.TrinketofRespite;
	other.DrownerApp += self.DrownerApp;
	other.Aegis += self.Aegis;
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);

	if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();

	flash_screen_item(other);


	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_message(27, other.origin, other);
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
		self.nextthink = time + 1;
		self.think = SUB_Remove;
		self.solid = SOLID_NOT;
		self.secret  = 0;
		self.alpha = -1;
	return;
	}
	if (deathmatch)
	{
		self.oldsolid = self.solid;
		self.oldtouch = self.touch;
		self.touch = SUB_Null;
		self.alpha = 0.1;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.oldpflags = self.pflags;
		self.pflags =  0;
		self.think = respawn_items;
		self.nextthink = time + 25;
		if(self.classname == "bbox_touch")
		{
		self.owner.oldpflags = self.pflags;
		self.owner.pflags =  0;
		self.owner.alpha = 0.1;
		self.owner.colormod = '0.5 0.5 1';
		self.owner.solid = SOLID_NOT;
		self.owner.think = respawn_items;
		self.owner.nextthink = time + 25;
		}	
	}
	else
	{
	remove(self);
	if(self.classname == "bbox_touch")
	remove(self.owner);
	}

};

void() radial = 
{
	self.scale = 1;
	self.movetype = MOVETYPE_BOUNCE;
	self.solid = SOLID_TRIGGER;
	self.cnt = 1;
	self.origin_z += 12;
	self.use = artifact_drop;
};

void() artifact_soul_tether = 
{
	radial();
	self.modelflags = 8;
	self.noise = "items/artifacts/artifactE_pickup.ogg";
	self.noise1 = "items/artifacts/artifactE_use.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.SoulTether = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/soul_tether.md3");
	setsize(self, artifact_nsize, artifact_size);
	//setsize (self, '-8 -8 -8', ' 9 9 9');

	self.msg = 110;
	self.touch = artifact_touch;
	self.oldtouch = self.touch;

	
};

void() artifact_life_siphon = 
{
	radial();
	self.modelflags = 8;
	self.noise = "items/artifacts/artifactF_pickup.ogg";
	self.noise1 = "items/artifacts/artifactF_use.ogg";
	self.noise2 = "items/artifacts/artifactF_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.LifeSiphon = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/life_siphon.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.traileffectnum = particleeffectnum("life_siphon");
	self.msg = 106;
	self.touch = artifact_touch;
	self.oldtouch = self.touch;

	
};

void() artifact_drowners_apparatus = 
{
	radial();
	self.noise = "items/artifacts/artifactB_pickup.ogg";
	self.noise1 = "items/artifacts/artifactB_use.ogg";
	self.noise2 = "items/artifacts/artifactB_end.ogg";
	self.modelflags = 8;
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.DrownerApp = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/drowners_apparatus.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 102;
	self.touch = artifact_touch;
	self.oldtouch = self.touch;

}

void() artifact_TrinketofRespite = {};

void() artifact_trinket_respite = 
{
	radial();
	self.noise = "items/artifacts/artifactG_pickup.ogg";
	self.noise1 = "items/artifacts/artifactG_use.ogg";
	self.noise2 = "items/artifacts/artifactG_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.modelflags = 8;
	self.TrinketofRespite = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/trinket_of_reflection.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 107;
	self.touch = artifact_touch;
	self.oldtouch = self.touch;	
};

void() artifact_cruel_aegis = 
{
	radial();
	self.noise = "items/artifacts/artifactH_pickup.ogg";
	self.noise1 = "items/artifacts/artifactH_use.ogg";
	self.noise2 = "items/artifacts/artifactH_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.modelflags = 8;
	self.Aegis = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/cruel_aegis.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 108;
	self.touch = artifact_touch;
	self.oldtouch = self.touch;	
};

void() artifact_confounding_attar = 
{
	radial();
	self.noise = "items/artifacts/artifactD_pickup.ogg";
	self.noise1 = "items/artifacts/artifactD_use.ogg";
	self.noise2 = "items/artifacts/artifactD_end.ogg";
	precache_sound(self.noise);precache_sound(self.noise1);precache_sound(self.noise2);
	self.modelflags = 8;
	self.Attar = 1;
	if (self.secret)
		{total_secrets++;	self.wrathflags += FL_SECRET;}
	setmodel(self, "models/artifacts/confounding_attar.md3");
	setsize(self, artifact_nsize, artifact_size);
	self.msg = 104;
	self.touch = artifact_touch;
	self.oldtouch = self.touch;

	
};

void(vector org, string class, float ammount, entity ownr) drop_item;
.float item_ammount;
.float classweapon1;
.float classweapon2;
.float classweapon3;
.float classweapon4;
.float classweapon5;
void(vector origin, string classt, float item_amm, entity slf) convert_to_item;
void() weapon_spawner_use = 
{
	local entity pl;
	pl = find(world, classname, "player");
	if (pl.oldrelics)
	{
		if (pl.oldrelics == 1)
			self.cnt = self.classweapon2;
		if (pl.oldrelics == 2)
			self.cnt = self.classweapon3;
		if (pl.oldrelics == 3)
			self.cnt = self.classweapon4;
		if (pl.oldrelics == 4)
			self.cnt = self.classweapon5;
	}
	if (self.cnt == 1) 
	{
		if (!(pl.items &IT_COACHGUN))
			self.classtype = "coachgun";
		else
		{	self.classtype = "slugs";
			self.item_ammount = coachgun_ammount;
			self.alwaystouchable = 1;}
	}
	if (self.cnt == 2) 
	{
		if (!(pl.items &IT_SHOTGUN))
			self.classtype = "shotgun";
		else
		{	self.classtype = "shells";	
			self.item_ammount = shotgun_ammount;
			self.alwaystouchable = 1;}
	}
	if (self.cnt == 3) 
	{
		if (!(pl.items &IT_SPITTER))
			self.classtype = "spitter";
		else
		{	self.classtype = "fangs";
			self.item_ammount = fang_ammount;
			self.alwaystouchable = 1;}
	}
	
	if (self.cnt == 4)
	{
		if (!(pl.items &IT_RETCHER))
			self.classtype = "retcher";
		else
		{	self.classtype = "cyst";
			self.item_ammount = retcher_ammount;
			self.alwaystouchable = 1;}
	}
	if (self.cnt == 5)
	{
		if (!(pl.items &IT_CANNON))
			self.classtype = "slagcannon";
		else
		{	self.classtype = "ore";
			self.item_ammount = cannon_ammount;
			self.alwaystouchable = 1;}
	}
	if (self.cnt == 6)
	{
		if (!(pl.items &IT_LANCE))
			self.classtype = "lance";
		else
		{	self.classtype = "lances";
			self.item_ammount = 10;
			self.alwaystouchable = 1;}
	}
	if ((self.classtype) && (self.cnt))
	{
		self.use =SUB_Null;
		convert_to_item(self.origin, self.classtype, self.item_ammount, self);
	}

	//	drop_item(self.origin, self.classtype, self.item_ammount, self);
	//	remove(self);
	else
		remove(self);
};

void() weapon_spawner = 
{
	if (self.targetname)
		self.use = weapon_spawner_use;
	if (!self.targetname)
	{				
		self.think = wrath_objerror;
		self.nextthink = time + random();
	}
	self.cnt = self.classweapon1;
};
.float classitem1;
.float classitem0;
.float classitem2;
.float classitem3;
.float classitem4;
.float classitem5;

.float checkweapon;
void() item_spawner_use = 
{
	local entity pl;
	pl = find(world, classname, "player");


	if (pl.oldrelics)
	{
		if (pl.oldrelics == 1)
			self.classitem1 = self.classitem2;
		if (pl.oldrelics == 2)
			self.classitem1 = self.classitem3;
		if (pl.oldrelics == 3)
			self.classitem1 = self.classitem4;
		if (pl.oldrelics == 4)
			self.classitem1 = self.classitem5;
		if (pl.oldrelics == 5)
			self.classitem1 = self.classitem1;
	}


	
	if(self.checkweapon == 1)
	{
		if((!(pl.items & IT_COACHGUN)) && (self.classitem1 ==  1))
			remove(self);
		if((!(pl.items & IT_SHOTGUN)) && (self.classitem1 ==  2))
			remove(self);
		if((!(pl.items & IT_SPITTER)) && (self.classitem1 ==  3))
			remove(self);
		if((!(pl.items & IT_RETCHER)) && (self.classitem1 ==  4))
			remove(self);
		if((!(pl.items & IT_CANNON)) && (self.classitem1 ==  25))
			remove(self);
	}


	if (self.classitem1 == 1)
	{
		if (!self.item_ammount)
			self.item_ammount = 12;	//coachgun_ammount;
		self.classtype = "slugs";
	}
	if (self.classitem1 == 2)
	{
		if (!self.item_ammount)
			self.item_ammount = retcher_ammount;
		self.classtype = "cyst";
	}
	if (self.classitem1 == 3)
	{
		if (!self.item_ammount)
			self.item_ammount = shotgun_ammount;
		self.classtype = "shells";
	}
	if (self.classitem1 == 4)
	{
		if (!self.item_ammount)
			self.item_ammount = fang_ammount;
		self.classtype = "fangs";
	}

	if(self.classitem1 ==  25)
	{
		if (!self.item_ammount)
		self.item_ammount  = cannon_ammount;
		self.classtype = "ore";
	}
	if(self.classitem1 ==  26)
	{
		if (!self.item_ammount)
		self.item_ammount  = cannon_ammount;
		self.classtype = "lances";
	}
	if (self.classitem1 == 5)
		(self.classtype = "shard");
	if (self.classitem1 == 6)
		(self.classtype = "armor");
	if (self.classitem1 == 7)
		(self.classtype = "helm");
	if (self.classitem1 == 8)
		(self.classtype = "shard_dark");
	if (self.classitem1 == 9)
		(self.classtype = "armor_dark");
	if (self.classitem1 == 10)
		(self.classtype = "helm_dark");
	if (self.classitem1 == 11)
		(self.classtype = "vial");
	if (self.classitem1 == 12)
		(self.classtype = "beaker");
	if (self.classitem1 == 20)
		(self.classtype = "apparatus");
	if (self.classitem1 == 21)
		(self.classtype = "theter");
	if (self.classitem1 == 22)
		(self.classtype = "siphon");
	if (self.classitem1 == 23)
		(self.classtype = "aegis");
	if(self.classitem1 ==  24)
		(self.classtype = "attar");

	if(self.classitem1 ==  27)
		(self.classtype = "trinket");

	if (self.classitem1)
	{
		self.use = SUB_Null;
		convert_to_item(self.origin, self.classtype, self.item_ammount, self);
	}
	//drop_item(self.origin, self.classtype, self.item_ammount, self);
	//remove(self);
};

.float classitem1;
.float classitem2;
.float classitem3;
.float classitem4;
.float classitem5;

void() item_spawner = 
{
	/*	if (!self.classitem0)
			self.classitem0 = 1;

		if (!self.classitem1)
			self.classitem1 = self.classitem0;
		if (!self.classitem2)
			self.classitem2 = self.classitem0;
		if (!self.classitem3)
			self.classitem3 = self.classitem0;
		if (!self.classitem4)
			self.classitem4 = self.classitem0;
		if (!self.classitem5)
			self.classitem5 = self.classitem0;
	*/
	if (!self.targetname)
	{				
		self.think = wrath_objerror;
		self.nextthink = time + random();
	}
	if (self.targetname)
		self.use = item_spawner_use;
};

.float PreStartItemvalue;

void() PreStartItem = 
{
	StartItem(self.PreStartItemvalue);
};
.float counter_coffer_use;
.float counter_coffer_ammount;

void(vector org, string class, float ammount, entity ownr) drop_item = 
{
	local entity dropped;
	dropped = spawn();
	dropped.origin = org;
	dropped.movetype = MOVETYPE_TOSS;
	dropped.owner = ownr;
	dropped.angles = ownr.angles;
	
	
	local vector revel;
	
	if ((dropped.owner.flags &FL_MONSTER))
	{
		makevectors(ownr.angles);
			revel = v_forward *(120 + random() *50);
		revel_z += (150 + random() *50);
	}
	else
	{
		if (self.owner.target)
			dropped.target = self.owner.target;
	}
	if(ownr.classname == "coffer")
	{
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.gravity = coffer_item_gravity;
		dropped.bouncefactor = coffer_item_bounce;
		makevectors(ownr.angles);
		local float right_vel;
		
		if(ownr.counter_coffer_ammount == 4)
		{
			if(ownr.counter_coffer_use == 4)
				right_vel = -67.5;
			if(ownr.counter_coffer_use == 3)
				right_vel = -22.5;
			if(ownr.counter_coffer_use == 2)
				right_vel = 22.5;
			if(ownr.counter_coffer_use == 1)
				right_vel = 67.5;			
		}
		if(ownr.counter_coffer_ammount == 3)
		{
			if(ownr.counter_coffer_use == 3)
				right_vel = -45;
			if(ownr.counter_coffer_use == 1)
				right_vel = 45;			
		}
		if(ownr.counter_coffer_ammount == 2)
		{
			if(ownr.counter_coffer_use == 2)
				right_vel = -22.5;
			if(ownr.counter_coffer_use == 1)
				right_vel = 22.5;			
		}
		revel = (v_forward * coffer_item_vel) + v_right * (right_vel) * 2;
		revel_z += (coffer_item_vel);
	}


	if (class == "slugs")
	{
		setmodel(dropped, "models/items/slugs.md3");
		dropped.ammo_cannon = ammount;
		dropped.noise = "items/slugs.ogg";
		dropped.msg = 18;
		setsizeitem2(dropped, shellsl_size);
		dropped.ammo_coachgun = 15;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "cyst")
	{
		setmodel(dropped, "models/items/cysts.md3");
		setsizeitem2(dropped, explosives_size);
		dropped.noise = "items/cysts.ogg";
		dropped.msg = 30;
		dropped.scale = 1;
		dropped.ammo_retcher = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "shells")
	{
		setmodel(dropped, "models/items/shells.md3");
		dropped.noise = "items/shells.ogg";
		dropped.msg = 20;
		setsizeitem2(dropped, shells_size);
		dropped.ammo_shotgun = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "shells_inv")
	{
		setmodel(dropped, "models/items/shells_drop.md3");
		dropped.avelocity_y = (random() *120 + 120) *crandom();
		dropped.noise = "items/shells.ogg";
		dropped.msg = 20;
		setsizeitem2(dropped, shells_size_invader);
		dropped.ammo_shotgun = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "fangs")
	{
		setmodel(dropped, "models/items/fangs.md3");
		dropped.noise = "items/fangs.ogg";
		dropped.msg = 21;
		setsizeitem2(dropped, resin_size);
		dropped.ammo_spitter = fang_ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "ore")
	{
		setmodel(dropped,"models/items/ore.md3");
		dropped.noise = "items/ore.ogg";
		dropped.msg = 19;
		setsizeitem2(dropped, shellsl_size);
		dropped.ammo_cannon = ammount;
		dropped.touch = wammo_touch;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
	}	

	if (class == "shard")
	{
		dropped.noise = "items/armor_shard3.ogg";
		dropped.rarmorvalue = 10;
		setmodel(dropped, "models/items/armor_shard.md3");
		setsize2(dropped, shard_nsize, shard_size);
		dropped.touch = larmor_touch;
		dropped.color = shard_light_col;
		dropped.light_lev = shard_lightlev;
		dropped.msg = 13;
		dropped.pflags = 128 | 1;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "armor")
	{
		dropped.noise = "items/armor1.ogg";
		dropped.rarmorvalue = 50;
		setmodel(dropped, "models/items/armor.md3");
		setsize2(dropped, armor_nsize, armor_size);
		dropped.touch = larmor_touch;
		dropped.color = armor_light_col;
		dropped.light_lev = armor_lightlev;
		dropped.msg = 2;
		dropped.pflags = 128 | 1;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "helm")
	{
		dropped.noise = "items/armor1.ogg";
		dropped.rarmorvalue = 30;
		setmodel(dropped, "models/items/helm.md3");
		setsize2(dropped, helm_nsize, helm_size);
		dropped.touch = larmor_touch;
		dropped.color = helm_light_col;
		dropped.light_lev = helm_lightlev;
		dropped.msg = 9;
		dropped.pflags = 128 | 1;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "shard_dark")
	{
		local float r;
		r = floor(random() *3);
		if (r < 1)
			dropped.noise = "items/armor_shard_dark1.ogg";
		if (r < 2)
			dropped.noise = "items/armor_shard_dark2.ogg";
		else
			dropped.noise = "items/armor_shard_dark3.ogg";

		dropped.darmorvalue = 10;
		setmodel(dropped, "models/items/armor_shard_dark.md3");
		setsize2(dropped, dark_shard_nsize, dark_shard_size);
		dropped.touch = larmor_touch;
		dropped.color = dark_shard_light_col;
		dropped.light_lev = dark_shard_lightlev;
		dropped.pflags = 128 | 1;
		dropped.msg = 6;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "armor_dark")
	{
		dropped.noise = "items/armor_dark1.ogg";
		dropped.darmorvalue = 50;
		setmodel(dropped, "models/items/armor_dark.md3");
		setsize2(dropped, dark_armor_nsize, dark_armor_size);
		dropped.touch = larmor_touch;
		dropped.color = dark_armor_light_col;
		dropped.light_lev = dark_armor_lightlev;
		dropped.pflags = 128 | 1;
		dropped.msg = 4;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "helm_dark")
	{
		dropped.noise = "items/armor_dark1.ogg";
		dropped.darmorvalue = 30;
		setmodel(dropped, "models/items/helm_dark.md3");
		setsize2(dropped, dark_helm_nsize, dark_helm_size);
		dropped.touch = larmor_touch;
		dropped.color = dark_helm_light_col;
		dropped.light_lev = dark_helm_lightlev;
		dropped.pflags = 128 | 1;
		dropped.msg = 5;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "vial")
	{
		dropped.noise = "items/lifeblood_vial1.ogg";
		dropped.pflags = 129;
		dropped.health = 10;
		dropped.light_lev = 15;
		dropped.color = '3 0 0';
		dropped.colormod = '1 1 1';
		setmodel(dropped, "models/items/lifeblood_vial.md3");
		dropped.touch = larmor_touch;
		setsizeitem2(dropped, vial_size);
		/*if(ownr.classname != "coffer")
		{
		dropped.nextthink = time + 0.2;	// items start after other solids
		dropped.think = PlaceItem;
		}*/
		dropped.msg = 11;
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "beaker")
	{
		dropped.noise = ("items/lifeblood_beaker1.ogg");
		dropped.pflags = 129;
		dropped.health = 30;
		dropped.light_lev = 25;
		dropped.color = '3 0 0';
		dropped.colormod = '1 1 1';
		setmodel(dropped, "models/items/lifeblood_beaker.md3");
		dropped.touch = larmor_touch;
		setsizeitem2(dropped, beaker_size);
		dropped.msg = 10;
		/*if(ownr.classname != "coffer")
		{
		dropped.nextthink = time + 0.2;	// items start after other solids
		dropped.think = PlaceItem;
		}*/
		spawn_bbox_collider(dropped);
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "siphon")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.modelflags = 8;
		dropped.noise = "items/artifacts/artifactF_pickup.ogg";
		dropped.LifeSiphon = 1;
		setmodel(dropped, "models/artifacts/life_siphon.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.traileffectnum = particleeffectnum("life_siphon");
		dropped.msg = 106;
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "apparatus")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactB_pickup.ogg";
		dropped.modelflags = 8;
		dropped.DrownerApp = 1;
		setmodel(dropped, "models/artifacts/drowners_apparatus.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 102;
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "theter")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.modelflags = 8;
		dropped.noise = "items/artifacts/artifactE_pickup.ogg";
		dropped.SoulTether = 1;
		precache_model("models/artifacts/soul_tether.md3");
		setmodel(dropped, "models/artifacts/soul_tether.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 110;
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "aegis")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactH_pickup.ogg";
		dropped.modelflags = 8;
		dropped.Aegis = 1;
		setmodel(dropped, "models/artifacts/cruel_aegis.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 108;
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
		
	}
	if (class == "attar")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.classname = "artifact_confounding_attar";
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactD_pickup.ogg";
		dropped.modelflags = 8;
		dropped.Attar = 1;
		setmodel(dropped, "models/artifacts/confounding_attar.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 104;
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}
		if (class == "trinket")
	{
		dropped.scale = 1;
		dropped.movetype = MOVETYPE_BOUNCE;
		dropped.solid = SOLID_TRIGGER;
		dropped.classname = "artifact_trinket_of_respite";
		dropped.cnt = 1;
		dropped.origin_z += 12;
		dropped.noise = "items/artifacts/artifactG_pickup.ogg";
		dropped.modelflags = 8;
		dropped.TrinketofRespite = 1;
		setmodel(dropped, "models/artifacts/trinket_of_reflection.md3");
		setsize(dropped, artifact_nsize, artifact_size);
		dropped.msg = 107;
		dropped.touch = artifact_touch;
		dropped.oldtouch = dropped.touch;
	}
	dropped.nextthink = time + 0.1;	// items start after other solids
	dropped.think = check_item_onfloor;
	
	if (class == "shotgun")
	{
		dropped.items = IT_SHOTGUN;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/shotgun/w_shotgun.md3");
		dropped.ammo_shotgun = 2;
		StartItem(1);
		dropped.modelflags = 8;
		dropped.origin_z += 24;
		dropped.rwpn = 1;
		precache_sound(dropped.noise);
		dropped.touch = wammo_touch;
		dropped.msg = 33;
		setsize(dropped, coach_nsize, coach_size);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "coachgun")
	{
		dropped.items = IT_COACHGUN;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/coachgun/w_coachgun.md3");
		dropped.ammo_coachgun = 3;
		StartItem(1);
		dropped.modelflags = 8;
		dropped.origin_z += 24;
		dropped.rwpn = 1;
		precache_sound(dropped.noise);
		dropped.touch = wammo_touch;
		dropped.msg = 3;
		setsize(dropped, coach_nsize, coach_size);
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "retcher")
	{
		dropped.items = IT_RETCHER;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/retcher/w_retcher.md3");
		setsize(dropped, retcher_nsize, retcher_size);
		dropped.ammo_retcher = 6;
		dropped.rwpn = 1;
		StartItem(1);
		dropped.modelflags = 8;
		dropped.origin_z += 24;
		precache_sound(dropped.noise);
		dropped.touch = wammo_touch;
		dropped.msg = 25;
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "spitter")
	{
		dropped.items = IT_SPITTER;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/spitter/w_spitter.md3");
		setsize(dropped, spitter_nsize, spitter_size);
		dropped.ammo_spitter = 20;
		dropped.rwpn = 1;
		StartItem(1);
		dropped.modelflags = 8;
		dropped.origin_z += 24;
		precache_sound(dropped.noise);
		dropped.touch = wammo_touch;
		dropped.msg = 8;
		dropped.oldtouch = dropped.touch;
		
	}

	if (class == "slagcannon")
	{
		dropped.items = IT_CANNON;
		dropped.spawnflags = ownr.spawnflags;
		dropped.itemisweapon = 1;
		setmodel(dropped, "models/weapons/cannon/w_cannon.md3");
		setsize(dropped, slag_nsize, slag_size);
		precache_sound(dropped.noise);
		dropped.ammo_cannon = 20;
		dropped.rwpn = 1;
		StartItem(1);
		dropped.modelflags = 8;
		dropped.origin_z += 24;
		dropped.touch = wammo_touch;
		dropped.msg = 14;
		dropped.oldtouch = dropped.touch;
		
	}

	dropped.velocity = revel;
	dropped.solid = SOLID_TRIGGER;
	
	
 	if(dropped.owner.classname == "coffer")
	{
	dropped.solid = SOLID_NOT;
	dropped.nextthink = time + 0.1;	// items start after other solids
	dropped.think = vel_item;
//	dropped.think = 
	}

};

void(vector org, string class, float ammount, entity slf) convert_to_item = 
{
	self.origin = org;
	self.movetype = MOVETYPE_TOSS;
	self.angles = self.angles;
	//	if(!(self.flags &FL_ITEM))
	//	self.flags += FL_ITEM;		// make extra wide
	//self.targetname = string_null;
	self.use = artifact_drop;
	self.classtype = string_null;
	self.classitem1 = 0;
	self.classitem2 = 0;
	self.classitem3 = 0;
	self.classitem4 = 0;
	self.classitem5 = 0;
	vector revel;
	if (class == "ore")
	{
		setmodel(self, "models/items/ore.md3");
		self.noise = "items/ore.ogg";
		self.classname = "ammo_cannon";
		self.msg = 19;
		setsizeitem2(self, shellsl_size);
		self.ammo_cannon = ammount;
			self.alwaystouchable = slf.alwaystouchable;
		self.touch = wammo_touch;
	}	
	if (class == "slugs")
	{
		setmodel(self, "models/items/slugs.md3");
		self.noise = "items/slugs.ogg";
		self.classname = "ammo_slugs";
		self.msg = 18;
		setsizeitem2(self, shellsl_size);
		self.ammo_coachgun = 15;
			self.alwaystouchable = slf.alwaystouchable;
		self.touch = wammo_touch;
	}
	if (class == "cyst")
	{
		setmodel(self, "models/items/cysts.md3");
		setsizeitem2(self, explosives_size);
		self.noise = "items/cysts.ogg";
		self.classname = "ammo_cysts";
		self.msg = 30;
		self.scale = 1;
		self.ammo_retcher = ammount;
			self.alwaystouchable = slf.alwaystouchable;
		self.touch = wammo_touch;
	}
	if (class == "shells")
	{
		setmodel(self, "models/items/shells.md3");
		self.noise = "items/shells.ogg";
		self.classname = "ammo_shells";
		self.msg = 20;
		setsizeitem2(self, shells_size);
		self.ammo_shotgun = ammount;
			self.alwaystouchable = slf.alwaystouchable;
		self.touch = wammo_touch;
	}
	if (class == "shells_inv")
	{
		setmodel(self, "models/items/shells_drop.md3");
		self.avelocity_y = (random() *120 + 120) *crandom();
		self.noise = "items/shells.ogg";
		self.classname = "ammo_shells";
		self.msg = 20;
		setsizeitem2(self, shells_size_invader);
		self.ammo_shotgun = ammount;
		self.touch = wammo_touch;
	}
	if (class == "fangs")
	{
		setmodel(self, "models/items/fangs.md3");
		self.classname = "ammo_fangs";
		self.noise = "items/fangs.ogg";
		self.msg = 21;
		setsizeitem2(self, resin_size);
		self.ammo_spitter = fang_ammount;
		self.touch = wammo_touch;
	}
	if (class == "lances")
	{
		self.colormod = '0 1 3';
		setmodel(self, "models/items/lances.md3");
		self.classname = "ammo_lance";
		self.noise = "items/lance.ogg";
		self.msg = 22;
		setsizeitem2(self, resin_size);
		self.ammo_lance = 10;
		self.touch = wammo_touch;
	}
	if (class == "shard")
	{
		self.noise = "items/armor_shard3.ogg";
		self.rarmorvalue = 10;
		setmodel(self, "models/items/armor_shard.md3");
		self.classname = "armor_shard";
		setsize2(self, shard_nsize, shard_size);
		self.touch = larmor_touch;
		self.color = shard_light_col;
		self.light_lev = shard_lightlev;
		self.msg = 13;
		self.pflags = 128 | 1;
	}
	if (class == "armor")
	{
		self.noise = "items/armor1.ogg";
		self.rarmorvalue = 50;
		setmodel(self, "models/items/armor.md3");
		setsize2(self, armor_nsize, armor_size);
		self.touch = larmor_touch;
		self.classname = "armor_armor";
		self.color = armor_light_col;
		self.light_lev = armor_lightlev;
		self.msg = 2;
		self.pflags = 128 | 1;
	}

	if (class == "helm")
	{
		self.noise = "items/armor1.ogg";
		self.rarmorvalue = 30;
		setmodel(self, "models/items/helm.md3");
		setsize2(self, helm_nsize, helm_size);
		self.classname = "armor_helm";
		self.touch = larmor_touch;
		self.color = helm_light_col;
		self.light_lev = helm_lightlev;
		self.msg = 9;
		self.pflags = 128 | 1;
	}
	if (class == "shard_dark")
	{
		local float r;
		r = floor(random() *3);
		if (r < 1)
			self.noise = "items/armor_shard_dark1.ogg";
		if (r < 2)
			self.noise = "items/armor_shard_dark2.ogg";
		else
			self.noise = "items/armor_shard_dark3.ogg";

		self.classname = "armor_shard_dark";
		self.darmorvalue = 10;
		setmodel(self, "models/items/armor_shard_dark.md3");
		setsize2(self, dark_shard_nsize, dark_shard_size);
		self.touch = larmor_touch;
		self.color = dark_shard_light_col;
		self.light_lev = dark_shard_lightlev;
		self.pflags = 128 | 1;
		self.msg = 6;
	}
	if (class == "armor_dark")
	{
		self.noise = "items/armor_dark1.ogg";
		self.darmorvalue = 50;
		setmodel(self, "models/items/armor_dark.md3");
		setsize2(self, dark_armor_nsize, dark_armor_size);
		self.classname = "armor_armor_dark";
		self.touch = larmor_touch;
		self.color = dark_armor_light_col;
		self.light_lev = dark_armor_lightlev;
		self.pflags = 128 | 1;
		self.msg = 4;
	}

	if (class == "helm_dark")
	{
		self.noise = "items/armor_dark1.ogg";
		self.darmorvalue = 30;
		setmodel(self, "models/items/helm_dark.md3");
		setsize2(self, dark_helm_nsize, dark_helm_size);
		self.touch = larmor_touch;
		self.classname = "armor_helm_dark";
		self.color = dark_helm_light_col;
		self.light_lev = dark_helm_lightlev;
		self.pflags = 128 | 1;
		self.msg = 5;
	}

	if (class == "vial")
	{
		self.noise = "items/lifeblood_vial1.ogg";
		self.pflags = 129;
		self.health = 10;
		self.light_lev = 15;
		self.color = '3 0 0';
		self.colormod = '1 1 1';
		self.classname = "health_life_vial";
		setmodel(self, "models/items/lifeblood_vial.md3");
		setsizeitem2(self, vial_size);
		self.touch = larmor_touch;
		self.oldtouch = self.touch;
		self.msg = 11;
	}

	if (class == "beaker")
	{
		self.noise = ("items/lifeblood_beaker1.ogg");
		self.pflags = 129;
		self.health = 30;
		self.light_lev = 25;
		self.color = '3 0 0';
		self.colormod = '1 1 1';
		self.classname = "health_life_beaker";
		setmodel(self, "models/items/lifeblood_beaker.md3");
		self.touch = larmor_touch;
		setsizeitem2(self, beaker_size);
		self.msg = 10;
//		self.nextthink = time + 0.2;	// items start after other solids
//		self.think = PlaceItem;
//		return;
	}
	if (class == "siphon")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.cnt = 1;
		self.origin_z += 12;
		self.classname = "artifact_life_siphon";
		self.modelflags = 8;
		self.noise = "items/artifacts/artifactF_pickup.ogg";
		self.LifeSiphon = 1;
		setmodel(self, "models/artifacts/life_siphon.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.traileffectnum = particleeffectnum("life_siphon");
		self.msg = 106;
		self.touch = artifact_touch;
	}
	self.velocity = revel;
	self.solid = SOLID_TRIGGER;
	spawn_bbox_collider(self);
	
	if (class == "apparatus")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.cnt = 1;
		self.origin_z += 12;
		self.classname = "artifact_drowners_apparatus";
		self.noise = "items/artifacts/artifactB_pickup.ogg";
		self.modelflags = 8;
		self.DrownerApp = 1;
		setmodel(self, "models/artifacts/drowners_apparatus.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 102;
		self.touch = artifact_touch;
	}
	if (class == "theter")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.cnt = 1;
		self.origin_z += 12;
		self.classname = "artifact_soul_tether";
		self.modelflags = 8;
		self.noise = "items/artifacts/artifactE_pickup.ogg";
		self.SoulTether = 1;
		precache_model("models/artifacts/soul_tether.md3");
		setmodel(self, "models/artifacts/soul_tether.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 110;
		self.touch = artifact_touch;
	}

	if (class == "aegis")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_cruel_aegis";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactH_pickup.ogg";
		self.modelflags = 8;
		self.Aegis = 1;
		setmodel(self, "models/artifacts/cruel_aegis.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 108;
		self.touch = artifact_touch;
	}
	if (class == "attar")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_confounding_attar";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactD_pickup.ogg";
		self.modelflags = 8;
		self.Attar = 1;
		setmodel(self, "models/artifacts/confounding_attar.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 104;
		self.touch = artifact_touch;
	}
	if (class == "trinket")
	{
		self.scale = 1;
		self.movetype = MOVETYPE_BOUNCE;
		self.solid = SOLID_TRIGGER;
		self.classname = "artifact_trinket_of_respite";
		self.cnt = 1;
		self.origin_z += 12;
		self.noise = "items/artifacts/artifactG_pickup.ogg";
		self.modelflags = 8;
		self.TrinketofRespite = 1;
		setmodel(self, "models/artifacts/trinket_of_reflection.md3");
		setsize(self, artifact_nsize, artifact_size);
		self.msg = 107;
		self.touch = artifact_touch;
	}	
	if (class == "shotgun")
	{
		self.items = IT_SHOTGUN;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_shotgun";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/shotgun/w_shotgun.md3");
		self.ammo_shotgun = 2;
		StartItem(1);
		self.modelflags = 8;
		self.origin_z += 24;
		self.rwpn = 1;
		precache_sound(self.noise);
		self.touch = wammo_touch;
		self.msg = 91;
		setsize(self, coach_nsize, coach_size);
	}

	if (class == "coachgun")
	{
		self.items = IT_COACHGUN;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_coachgun";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/coachgun/w_coachgun.md3");
		self.ammo_coachgun = 3;
		StartItem(1);
		self.modelflags = 8;
		self.origin_z += 24;
		self.rwpn = 1;
		precache_sound(self.noise);
		self.touch = wammo_touch;
		self.msg = 90;
		setsize(self, coach_nsize, coach_size);
	}

	if (class == "retcher")
	{
		self.items = IT_RETCHER;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_retcher";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/retcher/w_retcher.md3");
		setsize(self, retcher_nsize, retcher_size);
		self.ammo_retcher = 6;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = 8;
		self.origin_z += 24;
		precache_sound(self.noise);
		self.touch = wammo_touch;
		self.msg = 93;
	}

	if (class == "spitter")
	{
		self.items = IT_SPITTER;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_spitter";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/spitter/w_spitter.md3");
		setsize(self, spitter_nsize, spitter_size);
		self.ammo_spitter = 20;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = 8;
		self.origin_z += 24;
		precache_sound(self.noise);
		self.touch = wammo_touch;
		self.msg = 92;
	}

	if (class == "slagcannon")
	{
		self.items = IT_CANNON;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_slaggcannon";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/cannon/w_cannon.md3");
		setsize(self, slag_nsize, slag_size);
		precache_sound(self.noise);
		self.ammo_cannon = 20;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = 8;
		self.origin_z += 24;
		self.touch = wammo_touch;
		self.msg = 94;
	}
	if (class == "lance")
	{
		self.items = IT_LANCE;
		self.spawnflags = self.spawnflags;
		self.classname = "weapon_lance";
		self.itemisweapon = 1;
		setmodel(self, "models/weapons/lance/w_lance.md3");
		setsize(self, slag_nsize, slag_size);
		precache_sound(self.noise);
		self.ammo_cannon = 10;
		self.rwpn = 1;
		StartItem(1);
		self.modelflags = 8;
		self.origin_z += 24;
		self.touch = wammo_touch;
		self.msg = 95;
	}
	self.velocity = revel;
	self.solid = SOLID_TRIGGER;


	self.oldtouch = self.touch;
	
};

void() item_Sigil = 
{
	StartItem(6);
	self.touch = artifact_touch;
	setsize(self, '-14 -14 -14', '14 14 14');
};

void() key_touch = 
{
	if (other.classname != "player")
		return;
	if ((other.items &self.items))
	{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}

	if (self.slot_keys)
	{
		if (!other.slot_keys)
			other.slot_keys = self.slot_keys * 100;
		else
		{
			local string slotdigits, slotdigitsdozen;
			local float slotdozens;
			slotdigits = ftos(other.slot_keys);
			slotdigitsdozen = substring(slotdigits, 1, 2);
			slotdozens = stof(slotdigitsdozen);
			if (slotdozens)
				other.slot_keys += self.slot_keys;
			else
				other.slot_keys += self.slot_keys * 10;
		}
	}
	other.items += self.items;
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();
	flash_screen_item(other);
	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_message(27, other.origin, other);
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
	}
	if (deathmatch)
	{
		self.alpha = 0.1;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.think = respawn_items;
		self.nextthink = time + 25;
	}
	else
	{
		self.effects = EF_NODRAW;
		self.touch = SUB_Null;
		self.solid = SOLID_NOT;

		if (self.msg == 31)
			other.rkeyson = self;
		if (self.msg == 28)
			other.bkeyson = self;
		if (self.msg == 32)
			other.ykeyson = self;
	}
};

void() coffer_key_touch = 
{
	if (other.classname != "player")
		return;
	if ((other.items &IT_COFFERKEY3))
	{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}

	
	
	if (!(other.items & IT_COFFERKEY1))
		{other.items += self.items;other.keyson1 = self;}
	else
	{
	if ((other.items & IT_COFFERKEY1) && (other.items & IT_COFFERKEY2) )
		{other.items +=  IT_COFFERKEY3;other.keyson3 = self;}

	else
		{other.items +=  IT_COFFERKEY2;other.keyson2 = self;}

	}
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();
	flash_screen_item(other);
	if (self.secret == 1)
	{
		sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
		Hud_message(27, other.origin, other);
		local entity oself;
		oself = self;
		self = other;
		found_secrets = found_secrets + 1;
		self = oself;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
	}
	if (deathmatch)
	{
		self.alpha = 0.1;
		self.colormod = '0.5 0.5 1';
		self.solid = SOLID_NOT;
		self.think = respawn_items;
		self.nextthink = time + 25;
	}
	else
	{
		self.effects = EF_NODRAW;
		self.touch = SUB_Null;
		self.solid = SOLID_NOT;

	}
};
void() key_coffer = 
{
	self.modelflags = 8;
	self.rwpn = 1;
	self.noise = "items/coffer_key.ogg";
	precache_sound(self.noise);
	self.items = IT_COFFERKEY1;
	setmodel(self, "models/items/coffer_key1.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	self.light_lev = cofferkey_lightlev;
	self.color = cofferkey_light_col;
	StartItem(4);
	self.scale = 1;
	self.classname = "coffer_key";
	self.touch = coffer_key_touch;
	self.msg = 23;
	self.wrathflags += FL_RESPAWN;
	copy_old_data(self);
};

/*Plays sound when unlocked by glyph (objects/door_unlocked.ogg)
ITEM_GLYPH_BLUE
-4 -4 -4, 4 4 4 bbox
items/glyph.ogg (played when picked up)
models/items/glyph_blue.md3
Hud element (icon in upper right hand corner where coffer key icon goes) gfx/hud/glyph_blue.tga
Show message on pick up (gfx/hud/msg_glyph_blue.tga)
*/

void() key_red = 
{
	self.noise = "items/glyph.ogg";
	precache_sound(self.noise);
	self.items = IT_KEY1;
	setmodel(self, "models/items/glyph_red.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	StartItem(1);
	self.scale = 1;
	self.touch = key_touch;
	self.msg = 31;
	self.slot_keys = 1;
	self.wrathflags += FL_RESPAWN;
	copy_old_data(self);
};

void() key_blue = 
{
	self.noise = "items/glyph.ogg";
	precache_sound(self.noise);
	self.items = IT_KEY2;
	setmodel(self, "models/items/glyph_blue.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	StartItem(1);
	self.scale = 1;
	self.touch = key_touch;
	self.msg = 28;
	self.slot_keys = 2;
	self.wrathflags += FL_RESPAWN;
	copy_old_data(self);
};

void() key_yellow = 
{
	self.noise = "items/glyph.ogg";
	precache_sound(self.noise);
	self.items = IT_KEY3;
	setmodel(self, "models/items/glyph_yellow.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	StartItem(1);
	self.scale = 1;
	self.touch = key_touch;
	self.msg = 32;
	self.slot_keys = 3;
	self.wrathflags += FL_RESPAWN;
	copy_old_data(self);
};

.float relic_dthou;
.float relic_thou;
.float relic_cent;
.float relic_doze;
.float relic_unit;

void() relic_touch = 
{
	if (other.classname != "player")
		return;
	if ((other.relics &self.relics))
	{if(other.time_emptymessage < time)Hud_message(109, other.origin, other);other.time_emptymessage = time + 2.1;return;}
	other.relics += self.relics;
	other.foundedrelics += self.relics;
	other.oldrelics++;
	if (self.slot_relics)
	{
		if (!other.slot_relics)
			other.slot_relics = self.slot_relics * 10000;
		else
		{
			local string slotdigits, slotdigitsdozen, slotdigitscent, slotdigitsthou;
			local float slotdozens, slotcents, slotthou;
			slotdigits = ftos(other.slot_relics);
			slotdigitsthou = substring(slotdigits, 1, 2);

			slotthou = stof(slotdigitsthou);
			if (!slotthou)
				other.slot_relics += self.slot_relics * 1000;
			else
			{
				slotdigitscent = substring(slotdigits, 2, 3);
				slotcents = stof(slotdigitscent);
				if (!slotcents)
					other.slot_relics += self.slot_relics * 100;
				else
				{
					slotdigitsdozen = substring(slotdigits, 3, 4);
					slotdozens = stof(slotdigitsdozen);
					if (!slotdozens)
						other.slot_relics += self.slot_relics * 10;
					else
						other.slot_relics += self.slot_relics;
				}
			}
		}
	}
	sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
	if (self.msg)
		Hud_message(self.msg, other.origin, other);
	SUB_UseTargets();
	flash_screen_item(other);
	slotdigits = ftos(other.slot_relics);
	other.relic_dthou = stof(substring(slotdigits, 0, 1));
	other.relic_thou = stof(substring(slotdigits, 1, 1));
	other.relic_cent = stof(substring(slotdigits, 2, 1));
	other.relic_doze = stof(substring(slotdigits, 3, 1));
	other.relic_unit = stof(substring(slotdigits, 4, 1));

	remove(self);
};

void() relic_e1m1 = 
{
	self.noise = "items/relic.ogg";
	precache_sound(self.noise);
	self.relics = RL_E1M1;
	setmodel(self, "models/items/relic.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	self.skin = 1;
	StartItem(1);
	self.touch = relic_touch;
	self.msg = 50;
	self.slot_relics = 1;
};
void() relic_e1m2 = 
{
	self.noise = "items/relic.ogg";
	precache_sound(self.noise);
	self.relics = RL_E1M2;
	setmodel(self, "models/items/relic.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	self.skin = 2;
	StartItem(1);
	self.touch = relic_touch;
	self.msg = 51;
	self.slot_relics = 2;

};
void() relic_e1m3 = 
{
	self.noise = "items/relic.ogg";
	precache_sound(self.noise);
	self.relics = RL_E1M3;
	setmodel(self, "models/items/relic.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	self.skin = 3;
	StartItem(1);
	self.touch = relic_touch;
	self.msg = 52;
	self.slot_relics = 3;

};
void() relic_e1m4 = 
{
	self.noise = "items/relic.ogg";
	precache_sound(self.noise);
	self.relics = RL_E1M4;
	setmodel(self, "models/items/relic.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	self.skin = 4;
	StartItem(1);
	self.touch = relic_touch;
	self.msg = 53;
	self.slot_relics = 4;

};

void() relic_e1m5 = 
{
	self.noise = "items/relic.ogg";
	precache_sound(self.noise);
	self.relics = RL_E1M5;
	setmodel(self, "models/items/relic.md3");
	setsize(self, coffer_key_nsize, coffer_key_size);
	self.skin = 5;
	StartItem(1);
	self.touch = relic_touch;
	self.msg = 54;
	self.slot_relics = 5;

};


void() coffer_item_think = 
{
	local entity pl;
	pl = find(world, classname, "player");
	setorigin(self, pl.origin);
	self.think = SUB_Remove;
	self.nextthink = time + 2.5;
};


.float coffer_random_order;

.float coffer_step;


void() trigger_coffer_use = 
{ 	local entity ca, ch;
	self.classname = "coffer";


	if((self.counter_coffer_use == self.counter_coffer_ammount))
	self.think = SUB_Null;
	else
	self.think = trigger_coffer_use ;
	self.nextthink = time + 0.25;

	if (self.coffer_artifacts)
	{
		self.counter_coffer_use ++;
		ca = spawn();
		if (self.coffer_artifacts == 2)
			drop_item(self.origin + '0 0 32', "apparatus", 1, self);
		if (self.coffer_artifacts == 4)
			drop_item(self.origin + '0 0 32', "attar", 1, self);
		else if (self.coffer_artifacts == 5)			
			drop_item(self.origin + '0 0 32', "theter", 1, self);
		else if (self.coffer_artifacts == 6)
			drop_item(self.origin + '0 0 32', "siphon", 1, self);
		else if (self.coffer_artifacts == 7)
			drop_item(self.origin + '0 0 32', "trinket", 1, self);
		else if (self.coffer_artifacts == 8)
			drop_item(self.origin + '0 0 32', "aegis", 1, self);
			self.coffer_artifacts = 0;
		return;		
	}		
	if (self.coffer_ammo)
	{
		self.counter_coffer_use ++;
		if (self.coffer_ammo == 1)
			drop_item(self.origin + '0 0 32', "slugs", 15, self);
		else if (self.coffer_ammo == 2)
			drop_item(self.origin + '0 0 32', "shells", 10, self);
		else if (self.coffer_ammo == 3)
			drop_item(self.origin + '0 0 32', "fangs", 20, self);
		else if (self.coffer_ammo == 4)
			drop_item(self.origin + '0 0 32', "cysts", 10, self);
		self.coffer_ammo = 0;
		return;		
	}
	if (self.coffer_armor)
	{
		self.counter_coffer_use ++;
		if (self.coffer_armor == 1)
			drop_item(self.origin + '0 0 32', "shard", 1, self);
		if (self.coffer_armor == 2)
			drop_item(self.origin + '0 0 32', "armor", 1, self);
		if (self.coffer_armor == 3)
			drop_item(self.origin + '0 0 32', "helm", 1, self);
		if (self.coffer_armor == 4)
			drop_item(self.origin + '0 0 32', "shard_dark", 1, self);
		if (self.coffer_armor == 5)
			drop_item(self.origin + '0 0 32', "armor_dark", 1, self);
		if (self.coffer_armor == 6)
			drop_item(self.origin + '0 0 32', "helm_dark", 1, self);
		self.coffer_armor = 0;
		return;		
	}
	if (self.coffer_health)
	{
		self.counter_coffer_use ++;
		ch = spawn();
		if (self.coffer_health == 1)
			drop_item(self.origin + '0 0 32', "vial", 1, self);
		if (self.coffer_health == 2)
			drop_item(self.origin + '0 0 32', "beaker", 1, self);
		self.coffer_health = 0;
		return;		
	}

};


void() manuscript_touch = 
{
	if (other.classname != "player")
		return;
	if (!(other.journal_jmessages &self.journal_jmessages))
	{
		other.journal_jmessages += self.journal_jmessages;
		sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
		remove(self);
	}
	if (!(other.journal_jmessagesm &self.journal_jmessagesm))
	{
		other.journal_jmessagesm += self.journal_jmessagesm;
		sound(self, CHAN_AUTO, self.noise, 1, ATTN_NORM);
		remove(self);
	}
};
.float bestiary;
.float jmessage;
.float jmessagem;
void() item_manuscript = 
{
	setmodel(self, "models/items/manuscript.md3");
	setsizeitem(self, '4 4 24');
	self.noise = "misc/null.wav";
	precache_sound(self.noise);
	if (!(self.bestiary))
	{
		if (!self.jmessage)
			self.jmessage = 1;
		self.journal_jmessages = pow(2, (self.jmessage - 1));
		if (self.jmessage == 1)
			self.journal_jmessages = 1;
	}
	else
	{
		if (!self.jmessagem)
			self.jmessagem = 1;
		self.journal_jmessagesm = pow(2, (self.jmessagem - 1));
		if (self.jmessagem == 1)
			self.journal_jmessagesm = 1;
	}
	self.origin_z += 24;
	self.light_lev = 64;
	self.pflags = 129;
	self.color = '1 1 0.5';
	self.effects = 512;
	StartItem(1);
	self.scale = 0.5;
	self.touch = manuscript_touch;

};

void() coffer_model_think = 
{
	self.frame = self.owner.frame;
	self.glowmod = self.owner.glowmod;
	self.think = coffer_model_think;
	self.nextthink = time + 0.01;
	if (self.frame == 1)
		self.usable = 0;
	if (self.owner.frame >= 19)
	{
		self.nextthink = time + 1;
		self.think = null;
	}
};

void() use_coffer = 
{
	local float ft;
	//	if(self.frame == -5)
	//		sound (self, CHAN_AUTO, "objects/coffers/coffer1_locked_activate.ogg", 1, ATTN_NORM);
	self.frame += 1;
	if (self.frame <= 10)
	{
		self.glowmod_x -= 0.11;
		self.glowmod_y -= 0.11;
		self.glowmod_z -= 0.11;
	}
	if (self.frame < 1)
		ft = 0.1;
	if (self.frame == 1)
	{
		//	if(self.frame == 17)
		sound(self, CHAN_AUTO, "objects/coffers/coffer1_unlocked.ogg", 1, ATTN_NORM);

		//	sound (self, CHAN_AUTO, "objects/coffers/coffer1_locked_rotate.ogg", 1, ATTN_NORM);
		self.use = null;
		self.classname = "coffer_open";
	}
	if ((self.frame >= 1) && (self.frame <= 15))
	{
		ft = 0.1;
	}
	if (self.frame == 16)
	{
		ft = 0.4;
	}
	if (self.frame > 16)
		ft = 0.1;
	if (self.frame == 18)
	{		
		SUB_UseTargets();
	}
	self.nextthink = time + ft;
	self.think = use_coffer;
	if (self.frame >= 19)
	{
		//self.counter_coffer_use ++;
	if (self.coffer_artifacts)
	self.counter_coffer_ammount ++;
	if (self.coffer_ammo)
	self.counter_coffer_ammount ++;
	if (self.coffer_armor)
	self.counter_coffer_ammount ++;
	if (self.coffer_health)
	self.counter_coffer_ammount ++;
		self.nextthink = time + ft;
		self.think = trigger_coffer_use;
	}
};

void() object_coffer = 
{
	self.glowmod = '1 1 1';
	//self.noise = 
	self.noise2 = "objects/coffers/coffer1_locked.ogg";
	self.classname = "coffer";
	self.frame = 0;
	self.usable = 1;
	self.keyrequired = 1;
	self.alpha = -1;
	local entity coffer_model;
	coffer_model = spawn();
	coffer_model.usable = 1;
	coffer_model.owner = self;
	setmodel(coffer_model, "models/objects/coffers/coffer1_locked.md3");
	setattachment(coffer_model, self, "");
	coffer_model.think = coffer_model_think;
	coffer_model.nextthink = time + 0.05;
	precache_model("models/objects/coffers/coffer1_collision.md3");
	self.solid = SOLID_BSP;
	setmodel(self, "models/objects/coffers/coffer1_collision.md3");
	self.use = use_coffer;
};

void(float velf) spawn_spining_head =
{
	makevectors(self.angles);
	vector revel = v_forward *(64 + random(32, 64)) * velf * 2;
	revel += v_right * random (-64 ,64) * velf;
	revel_z += (32 + random(16,32)) * velf;
	entity new = spawn();
	new.origin = self.origin + ' 0 0 16';
	setmodel(new,"models/enemies/wretch/gibs/gib_head_spin.md3");
	//setsize(new, '-8 -8 -8', '8 8 8');
	new.wrathflags += FL_GIB;
	new.bouncefactor = 0;
	new.touch = gib_touch2;
	new.time2 = time + random(3,5); // timing for nextthink alternative
	new.lifetime = time + wretch_sht;
	new.movetype = MOVETYPE_BOUNCE;
	new.bouncefactor = 1;
	new.velocity = revel;
	new.solid = SOLID_CORPSE;
	new.think = wretch_spining_head;
	new.nextthink = time + 0.05;
	new.frame = 0;
	new.flags = 0;
};
.entity ent_light;
void() use_fakecoffer = 
{
	local float ft;
	//	if(self.frame == -5)
	//		sound (self, CHAN_AUTO, "objects/coffers/coffer1_locked_activate.ogg", 1, ATTN_NORM);
	self.frame += 1;
	if (self.frame <= 10)
	{
		self.glowmod_x -= 0.11;
		self.glowmod_y -= 0.11;
		self.glowmod_z -= 0.11;
	}
	if (self.frame < 1)
		ft = 0.1;
	if (self.frame == 1)
	{
		//	if(self.frame == 17)
		sound(self, CHAN_AUTO, "objects/coffers/coffer1_unlocked.ogg", 1, ATTN_NORM);

		//	sound (self, CHAN_AUTO, "objects/coffers/coffer1_locked_rotate.ogg", 1, ATTN_NORM);
		self.use = null;
		self.classname = "coffer_open";
	}
	if ((self.frame >= 1) && (self.frame <= 15))
	{
		ft = 0.1;
	}
	if (self.frame == 16)
	{
		ft = 0.4;
	}
	if (self.frame > 16)
		ft = 0.1;

	if (self.frame == 17)
		spawn_spining_head (1);

	if (self.frame == 18)
	{		
		spawn_spining_head (1.5);
	}
	if (self.frame >= 19)
	{

		spawn_spining_head (2);
		sound(self, CHAN_WEAPON, "misc/null.wav", 1, 1);
		self.attached_cloud.think = alphafade;
		self.attached_cloud.nextthink = time;
		remove(self.ent_light);	
		remove(self);

	}
	else
	self.think = use_fakecoffer;
	self.nextthink = time + ft;
};

void() object_fakecoffer = 
{
	self.glowmod = '1 1 1';
	//self.noise = 
	self.noise2 = "objects/coffers/coffer1_locked.ogg";
	self.classname = "coffer_trap";
	self.usable = 1;
	self.alpha = -1;
	local entity coffer_model;
	coffer_model = spawn();
	self.attached_cloud = coffer_model;
	randomsound2("enemies/wraith/proj_loop", 3, 0.25, CHAN_WEAPON, 0, 0.75);

	entity selflight = spawn();
	selflight.origin = self.origin + '0 0 48';
	selflight.pflags = 129;
	selflight.light_lev = 128;
	selflight.color =  '0.75 0.75 1';
	selflight.style = 11;
	self.ent_light = self;
	coffer_model.usable = 1;
	coffer_model.owner = self;
	coffer_model.colormod = '0.75 0.75 1';
	setmodel(coffer_model, "models/objects/coffers/coffer1_locked.md3");
	setattachment(coffer_model, self, "");
	coffer_model.think = coffer_model_think;
	coffer_model.nextthink = time + 0.05;
	precache_model("models/objects/coffers/coffer1_collision.md3");
	self.solid = SOLID_BSP;
	setmodel(self, "models/objects/coffers/coffer1_collision.md3");
	self.use = use_fakecoffer;
	droptofloor();
};

void() cannon_item_think = {	//void(float effectnum, vector org, vector vel, float howmany) pointparticles 

	if (self.cnt != 1)
	{
		self.glowmod_x += 0.05;
		self.glowmod_y += 0.05;
		self.glowmod_z += 0.05;
		self.light_lev += 0.5;
		self.color_x += 0.05;
		self.color_y += 0.1;
		self.color_z += 0.05;
		self.count += 1;

		if (self.glowmod_x >= 2.2)
			self.cnt = 1;
	}
	else
	{
		self.color_x -= 0.05;
		self.color_y -= 0.1;
		self.color_z -= 0.05;
		self.glowmod_x -= 0.05;
		self.glowmod_y -= 0.05;
		self.glowmod_z -= 0.05;
		self.light_lev -= 0.5;
		self.count -= 1;
		if (self.glowmod_x <= 0.2)
			self.cnt = 0;
	}

	if (self.glowmod_x > 1.9)
		pointparticles(particleeffectnum("cystsnow4"), self.origin, '0 0 0', 1);
	if ((self.glowmod_x < 1.9) && (self.glowmod_x > 1.6))
		pointparticles(particleeffectnum("cystsnow3"), self.origin, '0 0 0', 1);
	if ((self.glowmod_x < 1.6) && (self.glowmod_x > 1.2))
		pointparticles(particleeffectnum("cystsnow2"), self.origin, '0 0 0', 1);
	if ((self.glowmod_x < 1.2) && (self.glowmod_x > 0.8))
		pointparticles(particleeffectnum("cystsnow1"), self.origin, '0 0 0', 1);
	if (self.glowmod_x < 0.8)
		pointparticles(particleeffectnum("cystsnow"), self.origin, '0 0 0', 1);

	self.think = cannon_item_think;
	self.nextthink = time + 0.1;
};
void() cannon_item = 
{
	setmodel(self, "models/projectiles/proj_cyst.md3");
	self.glowmod = '0.2 0.2 0.2';
	self.color = '0.5 1 0.5';
	self.scale = 1;
	self.cnt = 0;
	self.light_lev = 32;
	self.pflags = 131;
	self.think = cannon_item_think;
	self.nextthink = time + 0.05;
};

void (string classnme,vector org, float c1, float c2,float c3,float c4,float c5, float coun) write_stuff_monsters =
{
	local float	writeparms;
	local string	s1, s2, s3, s4, s5; 
	writeparms = fopen (strcat (mapname, "monsters_list.txt"), FILE_APPEND);    //open what file to use in write mode
	string sorg = vtos (org);
		if (c1 == 1)
			s1 = "fallen";
		if (c1 == 2)
			s1 = "invader";
		if (c1 == 3)
			s1 = "wretch";
		if (c1 == 4)
			s1 = "incisor";
		if (c1 == 5)
			s1 = "widow";
		if (c1 == 6)
			s1 = "wraith";
		if (c1 == 7)
			s1 = "heretic";
		if (c1 == 8)
			s1 = "fallen";
		if (c1 == 9)
			s1 = "oppressor";
		if (c1 == 10)
			s1 = "executioner";
		if (c1 == 11)
			s1 = "stricken";
		if (c1 == 12)
			s1 = "afflicted";

		if (c2 == 1)
			s2 = "fallen";
		if (c2 == 2)
			s2 = "invader";
		if (c2 == 3)
			s2 = "wretch";
		if (c2 == 4)
			s2 = "incisor";
		if (c2 == 5)
			s2 = "widow";
		if (c2 == 6)
			s2 = "wraith";
		if (c2 == 7)
			s2 = "heretic";
		if (c2 == 8)
			s2 = "fallen";
		if (c2 == 9)
			s2 = "oppressor";
		if (c2 == 10)
			s2 = "executioner";
		if (c2 == 11)
			s2 = "stricken";
		if (c2 == 12)
			s2 = "afflicted";

		if (c3 == 1)
			s3 = "fallen";
		if (c3 == 2)
			s3 = "invader";
		if (c3 == 3)
			s3 = "wretch";
		if (c3 == 4)
			s3 = "incisor";
		if (c3 == 5)
			s3 = "widow";
		if (c3 == 6)
			s3 = "wraith";
		if (c3 == 7)
			s3 = "heretic";
		if (c3 == 8)
			s3 = "fallen";
		if (c3 == 9)
			s3 = "oppressor";
		if (c3 == 10)
			s3 = "executioner";
		if (c3 == 11)
			s3 = "stricken";
		if (c3 == 12)
			s3 = "afflicted";

		if (c4 == 1)
			s4 = "fallen";
		if (c4 == 2)
			s4 = "invader";
		if (c4 == 3)
			s4 = "wretch";
		if (c4 == 4)
			s4 = "incisor";
		if (c4 == 5)
			s4 = "widow";
		if (c4 == 6)
			s4 = "wraith";
		if (c4 == 7)
			s4 = "heretic";
		if (c4 == 8)
			s4 = "fallen";
		if (c4 == 9)
			s4 = "oppressor";
		if (c4 == 10)
			s4 = "executioner";
		if (c4 == 11)
			s4 = "stricken";
		if (c4 == 12)
			s4 = "afflicted";

		if (c5 == 1)
			s5 = "fallen";
		if (c5 == 2)
			s5 = "invader";
		if (c5 == 3)
			s5 = "wretch";
		if (c5 == 4)
			s5 = "incisor";
		if (c5 == 5)
			s5 = "widow";
		if (c5 == 6)
			s5 = "wraith";
		if (c5 == 7)
			s5 = "heretic";
		if (c5 == 8)
			s5 = "fallen";
		if (c5 == 9)
			s5 = "oppressor";
		if (c5 == 10)
			s5 = "executioner";
		if (c5 == 11)
			s5 = "stricken";
		if (c5 == 12)
			s5 = "afflicted";

	string string1 = strcat (classnme," ","origin ",sorg,"      ",s1," ",s2);
	string string2 = strcat (" ",s3," ",s4," ",s5,"     count"," ");
	string string3 = strcat (ftos(coun), "\n");
	fputs (writeparms, strcat (string1,string2,string3));

	fclose (writeparms);
};

void() recount_spawner_monsters =
{
	local entity spawner;
	spawner = findradius(self.origin, 1000000);
	while (spawner)	//Loops through everything put in the missile entit
	{
		if ((spawner.wrathflags &FL_SPAWNER))
		{
			write_stuff_monsters(spawner.classname,spawner.origin, spawner.classmonster1, spawner.classmonster2, spawner.classmonster3, spawner.classmonster4, spawner.classmonster5, spawner.count);
		}
		spawner = spawner.chain;
	}

};







void (vector org, float c1, float c2,float c3,float c4,float c5) write_stuff_items =
{
	local float	writeparms;
	local string	s1, s2, s3, s4, s5; 
	writeparms = fopen (strcat (mapname, "items_list.txt"), FILE_APPEND);    //open what file to use in write mode
	string sorg = vtos (org);
	s1 =  ftos (c1);
	s2 =  ftos (c2);
	s3 =  ftos (c3);
	s4 =  ftos (c4);
	s5 =  ftos (c5);
	string string1 = strcat ("item_spawner ","origin ",sorg," ",s1," ",s2," ");
	string string2 =  strcat (s3," ",s4," ",s5,"\n");
	fputs (writeparms, strcat (string1,string2));
	fclose (writeparms);
};

void() recount_spawner_itemss =
{
	local entity spawner;
	spawner = findradius(self.origin, 1000000);
	while (spawner)	//Loops through everything put in the missile entit
	{
		if ((spawner.classname == "item_spawner"))
		{
			write_stuff_items(spawner.origin, spawner.classitem1, spawner.classitem2, spawner.classitem3, spawner.classitem4, spawner.classitem5);
		}

		spawner = spawner.chain;
	}

};

void() recount_spawner_items =
{
/*
1 : "Slugs" - TOTAL AMOUNT IN MAP
2 : "Cysts" - TOTAL AMOUNT IN MAP
3 : "Shells" - TOTAL AMOUNT IN MAP
4 : "Fans" - TOTAL AMOUNT IN MAP
25 : "Ammo Cannon" - TOTAL AMOUNT IN MAP
26 : "Ammo Lance" - TOTAL AMOUNT IN MAP
5 : "Armor Shard" - TOTAL AMOUNT IN MAP
6 : "Armor Armor" - TOTAL AMOUNT IN MAP
7 : "Armor Helm" - TOTAL AMOUNT IN MAP
8 : "Dark Armor Shard" - TOTAL AMOUNT IN MAP
9 : "Dark Armor Armor" - TOTAL AMOUNT IN MAP
10 : "Dark Armor Helm" - TOTAL AMOUNT IN MAP
11 : "Health Vial" - TOTAL AMOUNT IN MAP
12 : "Health Baker" - TOTAL AMOUNT IN MAP
20 : "Artifact Apparatus" - TOTAL AMOUNT IN MAP
21 : "Artifact Theter" - TOTAL AMOUNT IN MAP
22 : "Artifact Siphon" - TOTAL AMOUNT IN MAP
23 : "Artifact Aegis" - TOTAL AMOUNT IN MAP
24 : "Confounding Attar" - TOTAL AMOUNT IN MAP
*/



	float ammount1, ammount2, ammount3, ammount4, ammount5;
	float ammounta1, ammounta2, ammounta3, ammounta4, ammounta5;
	float ammountb1, ammountb2, ammountb3, ammountb4, ammountb5;
	float ammountc1, ammountc2, ammountc3, ammountc4, ammountc5;
	float ammountd1, ammountd2, ammountd3, ammountd4, ammountd5;
	float ammounte1, ammounte2, ammounte3, ammounte4, ammounte5;
	float ammountf1, ammountf2, ammountf3, ammountf4, ammountf5;
	float ammountg1, ammountg2, ammountg3, ammountg4, ammountg5;
	float ammounth1, ammounth2, ammounth3, ammounth4, ammounth5;
	float ammountz1, ammountz2, ammountz3, ammountz4, ammountz5;
	float ammounti1, ammounti2, ammounti3, ammounti4, ammounti5;
	float ammountj1, ammountj2, ammountj3, ammountj4, ammountj5;
	float ammountk1, ammountk2, ammountk3, ammountk4, ammountk5;
	float ammountl1, ammountl2, ammountl3, ammountl4, ammountl5;
	float ammountm1, ammountm2, ammountm3, ammountm4, ammountm5;
	float ammountn1, ammountn2, ammountn3, ammountn4, ammountn5;
	float ammounto1, ammounto2, ammounto3, ammounto4, ammounto5;
	float ammountp1, ammountp2, ammountp3, ammountp4, ammountp5;
	float ammountq1, ammountq2, ammountq3, ammountq4, ammountq5;
	//float ammountr1, ammountr2, ammountr3, ammountr4, ammountr5;



	local entity spawner;
	spawner = findradius(self.origin, 1000000);
	while (spawner)	//Loops through everything put in the missile entit
	{
		if ((spawner.classname == "item_spawner"))
		{
			if(spawner.classitem1 == 1) ammount1 ++;		if(spawner.classitem2 == 1) ammount2 ++;		if(spawner.classitem3 == 1) ammount3 ++;		if(spawner.classitem4 == 1) ammount4 ++; if(spawner.classitem5 == 1) ammount5 ++;	
			if(spawner.classitem1 == 2) ammounta1 ++;	if(spawner.classitem2 == 2) ammounta2 ++;	if(spawner.classitem3 == 2) ammounta3 ++;	if(spawner.classitem4 == 2) ammounta4 ++; if(spawner.classitem5 == 2) ammounta5 ++;	
			if(spawner.classitem1 == 3) ammountb1 ++;	if(spawner.classitem2 == 3) ammountb2 ++;	if(spawner.classitem3 == 3) ammountb3 ++;	if(spawner.classitem4 == 3) ammountb4 ++; if(spawner.classitem5 == 3) ammountb5 ++;	
			if(spawner.classitem1 == 4) ammountc1 ++;	if(spawner.classitem2 == 4) ammountc2 ++;	if(spawner.classitem3 == 4) ammountc3 ++;	if(spawner.classitem4 == 4) ammountc4 ++; if(spawner.classitem5 == 4) ammountc5 ++;	
			if(spawner.classitem1 == 25) ammountd1 ++;	if(spawner.classitem2 == 25) ammountd2 ++;	if(spawner.classitem3 == 25) ammountd3 ++;	if(spawner.classitem4 == 25) ammountd4 ++; if(spawner.classitem5 == 25) ammountd5 ++;	
			if(spawner.classitem1 == 26) ammounte1 ++;	if(spawner.classitem2 == 26) ammounte2 ++;	if(spawner.classitem3 == 26) ammounte3 ++;	if(spawner.classitem4 == 26) ammounte4 ++; if(spawner.classitem5 == 26) ammounte5 ++;	
			if(spawner.classitem1 == 5) ammountf1 ++;	if(spawner.classitem2 == 5) ammountf2 ++;	if(spawner.classitem3 == 5) ammountf3 ++;	if(spawner.classitem4 == 5) ammountf4 ++; if(spawner.classitem5 == 5) ammountf5 ++;	
			if(spawner.classitem1 == 6) ammountg1 ++;	if(spawner.classitem2 == 6) ammountg2 ++;	if(spawner.classitem3 == 6) ammountg3 ++;	if(spawner.classitem4 == 6) ammountg4 ++; if(spawner.classitem5 == 6) ammountg5 ++;	
			if(spawner.classitem1 == 7) ammounth1 ++;	if(spawner.classitem2 == 7) ammounth2 ++;	if(spawner.classitem3 == 7) ammounth3 ++;	if(spawner.classitem4 == 7) ammounth4 ++; if(spawner.classitem5 == 7) ammounth5 ++;	
			if(spawner.classitem1 == 8) ammountz1 ++;	if(spawner.classitem2 == 8) ammountz2 ++;	if(spawner.classitem3 == 8) ammountz3 ++;		if(spawner.classitem4 == 8) ammountz4 ++; if(spawner.classitem5 == 8) ammountz5 ++;	
			if(spawner.classitem1 == 9) ammounti1 ++;	if(spawner.classitem2 == 9) ammounti2 ++;	if(spawner.classitem3 == 9) ammounti3 ++;	if(spawner.classitem4 == 9) ammounti4 ++; if(spawner.classitem5 == 9) ammounti5 ++;	
			if(spawner.classitem1 == 10) ammountj1 ++;	if(spawner.classitem2 == 10) ammountj2 ++;	if(spawner.classitem3 == 10) ammountj3 ++;	if(spawner.classitem4 == 10) ammountj4 ++; if(spawner.classitem5 == 10) ammountj5 ++;	
			if(spawner.classitem1 == 11) ammountk1 ++;	if(spawner.classitem2 == 11) ammountk2 ++;	if(spawner.classitem3 == 11) ammountk3 ++;	if(spawner.classitem4 == 11) ammountk4 ++; if(spawner.classitem5 == 11) ammountk5 ++;	
			if(spawner.classitem1 == 12) ammountl1 ++;	if(spawner.classitem2 == 12) ammountl2 ++;	if(spawner.classitem3 == 12) ammountl3 ++;	if(spawner.classitem4 == 12) ammountl4 ++; if(spawner.classitem5 == 12) ammountl5 ++;	
			if(spawner.classitem1 == 20) ammountm1 ++;	if(spawner.classitem2 == 20) ammountm2 ++;	if(spawner.classitem3 == 20) ammountm3 ++;	if(spawner.classitem4 == 20) ammountm4 ++; if(spawner.classitem5 == 20) ammountm5 ++;	
			if(spawner.classitem1 == 21) ammountn1 ++;	if(spawner.classitem2 == 21) ammountn2 ++;	if(spawner.classitem3 == 21) ammountn3 ++;	if(spawner.classitem4 == 21) ammountn4 ++; if(spawner.classitem5 == 21) ammountn5 ++;	
			if(spawner.classitem1 == 22) ammounto1 ++;	if(spawner.classitem2 == 22) ammounto2 ++;	if(spawner.classitem3 == 22) ammounto3 ++;	if(spawner.classitem4 == 22) ammounto4 ++; if(spawner.classitem5 == 22) ammounto5 ++;	
			if(spawner.classitem1 == 23) ammountp1 ++;	if(spawner.classitem2 == 23) ammountp2 ++;	if(spawner.classitem3 == 23) ammountp3 ++;	if(spawner.classitem4 == 23) ammountp4 ++; if(spawner.classitem5 == 23) ammountp5 ++;	
			if(spawner.classitem1 == 24) ammountq1 ++;	if(spawner.classitem2 == 24) ammountq2 ++;	if(spawner.classitem3 == 24) ammountq3 ++;	if(spawner.classitem4 == 24) ammountq4 ++; if(spawner.classitem5 == 24) ammountq5 ++;	
		}

		spawner = spawner.chain;
	}




	string subline1 =strcat("1: Slugs-", " enc1:",(ftos (ammount1)),  " enc2:",(ftos (ammount2)),  " enc3:",(ftos (ammount3)),  " enc4");
	string subline1b =strcat((ftos (ammount4)),  " enc5:",(ftos (ammount5)));  
	string line1 = strcat (subline1, subline1b);

	string subline2 =strcat("2: Cysts -", " enc1:",(ftos (ammounta1)),  " enc2:",(ftos (ammounta2)),  " enc3:",(ftos (ammounta3)),  " enc4");
	string subline2b =strcat((ftos (ammounta4)),  " enc5:",(ftos (ammounta5)));  
	string line2 = strcat (subline2, subline2b);

	string subline3 =strcat("3: Shells -", " enc1:",(ftos (ammountb1)),  " enc2:",(ftos (ammountb2)),  " enc3:",(ftos (ammountb3)),  " enc4");
	string subline3b =strcat((ftos (ammountb4)),  " enc5:",(ftos (ammountb5)));  
	string line3 = strcat (subline3, subline3b); 

	string subline4 =strcat("4: Fans -", " enc1:",(ftos (ammountc1)),  " enc2:",(ftos (ammountc2)),  " enc3:",(ftos (ammountc3)),  " enc4");
	string subline4b =strcat((ftos (ammountc4)),  " enc5:",(ftos (ammountc5)));  
	string line4 = strcat (subline4, subline4b);

	string subline5 =strcat("25: Ammo Cannon -", " enc1:",(ftos (ammountd1)),  " enc2:",(ftos (ammountd2)),  " enc3:",(ftos (ammountd3)),  " enc4");
	string subline5b =strcat((ftos (ammountd4)),  " enc5:",(ftos (ammountd5)));  
	string line5 = strcat (subline5, subline5b);

	string subline6 =strcat("26: Ammo Lance -", " enc1:",(ftos (ammounte1)),  " enc2:",(ftos (ammounte2)),  " enc3:",(ftos (ammounte3)),  " enc4");
	string subline6b =strcat((ftos (ammounte4)),  " enc5:",(ftos (ammounte5)));  
	string line6 = strcat (subline6, subline6b);

	string subline7 =strcat("5: Armor Shard -", " enc1:",(ftos (ammountf1)),  " enc2:",(ftos (ammountf2)),  " enc3:",(ftos (ammountf3)),  " enc4");
	string subline7b =strcat((ftos (ammountf4)),  " enc5:",(ftos (ammountf5)));  
	string line7 = strcat (subline7, subline7b);

	string subline8 =strcat("6: Armor Armor -", " enc1:",(ftos (ammountg1)),  " enc2:",(ftos (ammountg2)),  " enc3:",(ftos (ammountg3)),  " enc4");
	string subline8b =strcat((ftos (ammountg4)),  " enc5:",(ftos (ammountg5)));  
	string line8 = strcat (subline8, subline8b);

	string subline9 =strcat("7: Armor Helm -", " enc1:",(ftos (ammounth1)),  " enc2:",(ftos (ammounth2)),  " enc3:",(ftos (ammounth3)),  " enc4");
	string subline9b =strcat((ftos (ammounth4)),  " enc5:",(ftos (ammounth5)));  
	string line9 = strcat (subline9, subline9b);

	string subline10 =strcat("8: Dark Armor Shard -", " enc1:",(ftos (ammountz1)),  " enc2:",(ftos (ammountz2)),  " enc3:",(ftos (ammountz3)),  " enc4");
	string subline10b =strcat((ftos (ammountz4)),  " enc5:",(ftos (ammountz5)));  
	string line10 = strcat (subline10, subline10b);

	string subline11 =strcat("9: Dark Armor Armor -", " enc1:",(ftos (ammounti1)),  " enc2:",(ftos (ammounti2)),  " enc3:",(ftos (ammounti3)),  " enc4");
	string subline11b =strcat((ftos (ammounti4)),  " enc5:",(ftos (ammounti5)));  
	string line11 = strcat (subline11, subline11b);

	string subline12 =strcat("10: Dark Armor Helm -", " enc1:",(ftos (ammountj1)),  " enc2:",(ftos (ammountj2)),  " enc3:",(ftos (ammountj3)),  " enc4");
	string subline12b =strcat((ftos (ammountj4)),  " enc5:",(ftos (ammountj5)));  
	string line12 = strcat (subline12, subline12b);

	string subline13 =strcat("11: Health Vial -", " enc1:",(ftos (ammountk1)),  " enc2:",(ftos (ammountk2)),  " enc3:",(ftos (ammountk3)),  " enc4");
	string subline13b =strcat((ftos (ammountk4)),  " enc5:",(ftos (ammountk5)));  
	string line13 = strcat (subline13, subline13b);

	string subline14 =strcat("12: Health Baker -", " enc1:",(ftos (ammountl1)),  " enc2:",(ftos (ammountl2)),  " enc3:",(ftos (ammountl3)),  " enc4");
	string subline14b =strcat((ftos (ammountl4)),  " enc5:",(ftos (ammountl5)));  
	string line14 = strcat (subline14, subline14b);

	string subline15 =strcat("20: Artifact Apparatus -", " enc1:",(ftos (ammountm1)),  " enc2:",(ftos (ammountm2)),  " enc3:",(ftos (ammountm3)),  " enc4");
	string subline15b =strcat((ftos (ammountm4)),  " enc5:",(ftos (ammountm5)));  
	string line15 = strcat (subline15, subline15b);

	string subline16 =strcat("21: Artifact Theter -", " enc1:",(ftos (ammountn1)),  " enc2:",(ftos (ammountn2)),  " enc3:",(ftos (ammountn3)),  " enc4");
	string subline16b =strcat((ftos (ammountn4)),  " enc5:",(ftos (ammountn5)));  
	string line16 = strcat (subline16, subline16b);

	string subline17 =strcat("22: Artifact Siphon -", " enc1:",(ftos (ammounto1)),  " enc2:",(ftos (ammounto2)),  " enc3:",(ftos (ammounto3)),  " enc4");
	string subline17b =strcat((ftos (ammounto4)),  " enc5:",(ftos (ammounto5)));  
	string line17 = strcat (subline17, subline17b);

	string subline18 =strcat("23: Artifact Aegis -", " enc1:",(ftos (ammountp1)),  " enc2:",(ftos (ammountp2)),  " enc3:",(ftos (ammountp3)),  " enc4");
	string subline18b =strcat((ftos (ammountp4)),  " enc5:",(ftos (ammountp5)));  
	string line18 = strcat (subline18, subline18b);

	string subline19 =strcat("24: Confounding Attar -", " enc1:",(ftos (ammountq1)),  " enc2:",(ftos (ammountq2)),  " enc3:",(ftos (ammountq3)),  " enc4");
	string subline19b =strcat((ftos (ammountq4)),  " enc5:",(ftos (ammountq5)));
	string line19 = strcat (subline19, subline19b);

	local float	writeparms;
	writeparms = fopen (strcat (mapname, "items_list.txt"), FILE_APPEND);    //open what file to use in write mode
	fputs (writeparms, strcat (line1,"\n"));
	fputs (writeparms, strcat (line2,"\n"));
	fputs (writeparms, strcat (line3,"\n"));
	fputs (writeparms, strcat (line4,"\n"));
	fputs (writeparms, strcat (line5,"\n"));
	fputs (writeparms, strcat (line6,"\n"));
	fputs (writeparms, strcat (line7,"\n"));
	fputs (writeparms, strcat (line8,"\n"));
	fputs (writeparms, strcat (line9,"\n"));
	fputs (writeparms, strcat (line10,"\n"));
	fputs (writeparms, strcat (line11,"\n"));
	fputs (writeparms, strcat (line12,"\n"));
	fputs (writeparms, strcat (line13,"\n"));
	fputs (writeparms, strcat (line14,"\n"));
	fputs (writeparms, strcat (line15,"\n"));
	fputs (writeparms, strcat (line16,"\n"));
	fputs (writeparms, strcat (line17,"\n"));
	fputs (writeparms, strcat (line18,"\n"));
	fputs (writeparms, strcat (line19,"\n"));
	fclose (writeparms);

}
  
///////////////end of qc file