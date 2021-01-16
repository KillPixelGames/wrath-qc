entity s;
.float teleported_time;
float SPAWNFLAG_NOMESSAGE = 1;
float SPAWNFLAG_NOTOUCH = 1;
float PLAYER_ONLY = 1;
float SILENT = 2;
float PUSH_ONCE = 1;
void(float mtype, vector org, entity owner) Hud_message;

void() trigger_reactivate = 
{
	self.solid = SOLID_TRIGGER;
};

void() multi_wait = 
{
	if (self.max_health)
	{
		self.health = self.max_health;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
	}
};
.float triggeronce;
.float respawnflags;
void() multi_trigger = 
{
	if (self.nextthink > time)
	{
		return;	// allready been triggered
	}

	if (self.classname == "trigger_secret")
	{
		if (self.enemy.classname != "player")
			return;
		found_secrets = found_secrets + 1;
		WriteByte(MSG_ALL, SVC_FOUNDSECRET);
	}

	if (self.noise != string_null)
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);

	// don't trigger again until reset
	self.takedamage = DAMAGE_NO;

	activator = self.enemy;

	SUB_UseTargets();

	if (self.wait > 0)
	{
		self.think = multi_wait;
		self.nextthink = time + self.wait;
	}
	else
	{
		// we can't just remove (self) here, because this is a touch function
		// called wheil C code is looping through area links...
		if (self.respawnable)
		{
			self.wrathflags = FL_RESPAWN;
			self.oldtouch = multi_touch;
			self.touch = SUB_Null;
		}
		else
		{
			self.touch = SUB_Null;
			self.nextthink = time + 0.1;
			self.think = SUB_Remove;
		}
	}
};

void() multi_killed = 
{
	self.enemy = damage_attacker;
	multi_trigger();
};

void() multi_use = 
{
	if (self.using == -1)
	{
		self.using = 1;
		return;
	}

	if ((self.using == 1) && (self.disarmed))
	{
		self.using = -1;
		return;
	}

	self.enemy = activator;
	multi_trigger();
};
.float player_weapon;
void() multi_touch = 
{
	if (self.using == -1)
		return;

	if ((self.player_weapon) && (!(other.items &self.player_weapon)))
	{
		return;
	}

	if ((other.classname == "player") && (other.flags &FL_CLIENT))
	{
		// if the trigger has an angles field, check player's facing direction

		if (self.classname != "trigger_generic")
		{
			if (self.movedir != '0 0 0')
			{
				makevectors2(other.angles);
				if (v_forward *self.movedir < 0)
					return;	// not facing the right way
			}
		}

		self.enemy = other;
		multi_trigger();
	}
};


void() trigger_multiple = 
{
	if (!self.wait)
		self.wait = -1;

	self.use = multi_use;

	InitTrigger();

	if (self.health)
	{
		if (self.spawnflags &SPAWNFLAG_NOTOUCH)
			objerror("health and notouch don't make sense\n");

		self.max_health = self.health;
		self.th_die = multi_killed;
		self.takedamage = DAMAGE_YES;
		self.solid = SOLID_BBOX;
		setorigin(self, self.origin);	// make sure it links into the world
	}
	else
	{
		if (!(self.spawnflags &SPAWNFLAG_NOTOUCH))
		{
			self.touch = multi_touch;
		}
	}
};
void() trigger_generic = 
{
	if (!self.wait)
		self.wait = -1;
	self.use = multi_use;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.touch = multi_touch;
	self.modelindex = 0;
	self.model = string_null;
};


void() trigger_once = 
{
	self.wait = -1;
	trigger_multiple();
	if (self.sounds == 1)
		self.noise = "misc/centerprint.ogg";
	if (self.noise)
		precache_sound(self.noise);
	self.triggeronce = 1;

	if (self.respawnable)
		copy_old_data(self);
};

void() trigger_oncebac = 
{
	local entity trig;
	trig = spawn();
	trig.solid = SOLID_TRIGGER;
	setmodel(trig, "");
	setsize(trig, self.absmin, self.absmax);
};

//=============================================================================

void() trigger_relay = 
{
	self.use = SUB_UseTargets;



};


//=============================================================================

void() trigger_secret2 = 
{
	self.wait = -1;

	if (!self.message)
		self.message = "You found a secret area!";

	if (!self.sounds)
		self.sounds = 1;

	if (self.sounds == 1)
	{
		self.noise = "misc/secret.ogg";
	}
	else if (self.sounds == 2)
	{
		self.noise = "misc/talk.ogg";
	}

	trigger_multiple();
};

//=============================================================================

void() counter_use = 
{
	

	if ((self.origin == '-3032 -3292 -172') || (self.origin == '-3080-3292 -172') && (self.count > 3) && (skill == 0) && (world.model == "maps/e1m4.bsp"))
		self.count -= 3;

	self.count = self.count - 1;

	if (self.count < 0)
		return;

	if (self.count != 0)
		return;

	self.enemy = activator;
	multi_trigger();
};


void() trigger_counter = 
{
	self.wait = -1;

	if (!self.count)
		self.count = 2;

	self.use = counter_use;
};


//============================================================================

void() play_teleport = 
{
	local float v;
	local string tmpstr;

	v = random() *5;

	if (v < 1)
		tmpstr = "fx/tele1.ogg";

	else if (v < 2)
		tmpstr = "fx/tele2.ogg";

	else if (v < 3)
		tmpstr = "fx/tele3.ogg";

	else if (v < 4)
		tmpstr = "fx/tele4.ogg";

	else
		tmpstr = "fx/tele5.ogg";

	sound(self, CHAN_VOICE, tmpstr, 1, ATTN_NORM);
	remove(self);
};

void(vector org) spawn_tfog = 
{
	s = spawn();
	s.origin = org;
	s.nextthink = time + 0.2;
	s.think = play_teleport;
};

void() tdeath_touch = 
{
	if (other == self.owner)
		return;

	// frag anyone who teleports in on top of an invincible player
	if (other.classname == "player")
	{
		if (other.invincible_finished > time)
			self.classname = "teledeath2";

		if (self.owner.classname != "player")
		{
			// other monsters explode themselves
			T_Damage(self.owner, self, self, 50000);
			return;
		}
	}

	if (other.health)
	{
		T_Damage(other, self, self, 50000);
	}
};

void(vector org, entity death_owner) spawn_tdeath = 
{
	local entity death;

	death = spawn();
	death.classname = "teledeath";
	death.movetype = MOVETYPE_NONE;
	death.solid = SOLID_TRIGGER;
	death.angles = '0 0 0';
	setsize(death, death_owner.mins - '1 1 1', death_owner.maxs + '1 1 1');
	setorigin(death, org);
	death.touch = tdeath_touch;
	death.nextthink = time + 0.2;
	death.think = SUB_Remove;
	death.owner = death_owner;

	force_retouch = 2;	// make sure even still objects get hit
};

void() teleport_touch = 
{ 
	local entity t;
	local vector org;
	if (other.teleported_time > time)
	{
		other.teleported_time = time + 0.7;
		//other.
		return;
	}

	if ((self.targetname != string_null) && (self.classname == "trigger_teleport"))
	{
		if (self.nextthink < time)
		{
			return;	// not fired yet
		}
	}

	if (other.classname != "player")
		return;

	// only teleport living creatures
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;

	SUB_UseTargets();

	// put a tfog where the player was
	spawn_tfog(other.origin);
	//	other.velocity_z += 64;
	t = find(world, targetname, self.target);
	if (!t)
		objerror("couldn't find target");

	// spawn a tfog flash in front of the destination
	makevectors(t.angles);
	org = t.origin + 0 * v_forward;

	spawn_tfog(org);
	spawn_tdeath(t.origin, other);
	// move the player and lock him down for a little while
	if (!other.health)
	{
		other.origin = t.origin;
		other.velocity = (v_forward *other.velocity_x) + (v_forward *other.velocity_y);
		return;
	}

	stuffcmd(other, "bf 1 1 1 1 2\n");
	msg_entity = other;
	WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle(MSG_ONE, 0);
	WriteAngle(MSG_ONE, t.angles_y);
	WriteAngle(MSG_ONE, 0);
	setorigin(other, t.origin);
	other.teleport_time = time + 0.7;

	if (other.flags &FL_ONGROUND)
		other.flags = other.flags - FL_ONGROUND;
	other.velocity = v_forward * 0;
	other.teleported_time = time + 0.7;

	other.flags = other.flags - other.flags &FL_ONGROUND;
};


void() info_teleport_destination = {	// this does nothing, just serves as a target spot
	self.mangle = self.angles;
	self.angles = '0 0 0';
	self.model = string_null;
	self.origin = self.origin + '0 0 27';

	if (!self.targetname)
		objerror("no targetname");
};

void() teleport_use = 
{
	self.nextthink = time + 0.2;
	force_retouch = 2;	// make sure even still objects get hit
	self.think = SUB_Null;
};


void() trigger_teleport = 
{
	local vector o;
	InitTrigger();
	self.touch = teleport_touch;
	// find the destination 
	if (!self.target)
		objerror("no target");
	self.use = teleport_use;
	if (!(self.spawnflags &SILENT))
	{
		precache_sound("fx/portal.ogg");
		o = (self.mins + self.maxs) *0.5;
		ambientsound(o, "fx/portal.ogg", 0.5, ATTN_STATIC);
	}
};
void() teleport_touch2 = 
{
	if (other.health <= 0 || other.solid != SOLID_SLIDEBOX)
		return;
	spawn_tfog(other.origin);
};

void() teleporter_active = 
{
	self.model = "models/objects/teleporters/teleporter.md3";
	setmodel(self, self.model);	// set size and link into world
	setsize(self, '-16 -16 -32', '16 16 32');
	self.solid = SOLID_TRIGGER;
	if (self.target)
		self.touch = teleport_touch;
};

void() teleporter = 
{
	precache_model("models/objects/teleporters/teleporter.md3");
	if (self.inactive)
	{
		self.use = teleporter_active;
		return;
	}

	self.model = "models/objects/teleporters/teleporter.md3";
	setmodel(self, self.model);	// set size and link into world
	setsize(self, '-16 -16 -32', '16 16 32');
	self.solid = SOLID_TRIGGER;
	if (self.target)
		self.touch = teleport_touch;
};

//============================================================================
.float viewer_deviance;
.float timeangles3;
//type = 1: enemy should be up
//type = 2: enemy should be below
float(entity targ, vector viewerangles,vector viewerorigin,float viewerdeviance) custom_infront ;

void() trigger_monsterjump_touch = 
{ 
	if (other.flags &(FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER)
		return;


	//float(entity targ, vector viewerangles,vector viewerorigin,float viewerdeviance) custom_infront
	if (self.viewer_deviance != 0)
	{
		float activejump = custom_infront (other.enemy, self.angles,((self.absmin + self.absmax) * 0.5),self.viewer_deviance);
		if(!activejump)
			return;
	}
	if(self.type == 1)	
	{
		if((other.enemy.origin_z - other.origin_z) > 8)
		return;		
	}

	if(self.type == 2)	
	{
		if((other.origin_z - other.enemy.origin_z) > 8)
		return;		
	}
//	if (other.nojump == 1)
//		return;
	other.timeangles3 = time + 3;
	// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x *self.speed;
	other.velocity_y = self.movedir_y *self.speed;
	if (!(other.flags &FL_ONGROUND))
		return;
	other.flags = other.flags - FL_ONGROUND;
	other.velocity_z = self.height;
	if(self.cnt == 1)
	{
		self.count --;
		if (self.count <= 0)
			remove(self);
	}
};


void() trigger_monsterjump = 
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	if(self.count > 0)
	self.cnt = 1;
	InitTrigger();
	self.touch = trigger_monsterjump_touch;
};

//============================================================================

.float duration;

void() trigger_fly_touch = 
{
	if (other.classname != "player")
		return;
	if(other.radial_time > time)
	{
	other.Aegis_time = 0;  other.LifeSiphon_time = 0;  other.DrownerApp_time = 0;  other.Tether_time = 0;
	other.radial_time = 0;
	return;	
	}

	if ((other.timefly - time) < 8)
	{
		sound (other, CHAN_AUTO, "items/sigils/sigil_flight_start.ogg",1 ,1);
		te_customflash(other.origin, 256, 1, '0.3 0.7 1');
		string flash_command_a = strcat ("bf ",ftos(flash_color_x)," ",ftos(flash_color_y)," ");
		string flash_command_b = strcat (ftos(flash_color_z)," ",ftos(flash_alpha)," ",ftos(flash_fade),"\n");
		string flash_command =  strcat (flash_command_a,flash_command_b);
		stuffcmd (other, flash_command);
		other.takenflytime = self.timefly;
		other.radialactive = 20;
		other.timefly = time + self.timefly;
		other.flightflag = 1;
		Hud_message(29, other.origin, other);
	}
};

void() sigil = 
{
	if (!self.duration)
		self.duration = 10;
	self.timefly = self.duration;
	self.model = "models/objects/sigil.md3";
	setmodel(self, self.model);
	setsize(self, '-16 -48 -80', '16 48 80');
	self.solid = SOLID_TRIGGER;
	self.touch = trigger_fly_touch;
};

void() trigger_fly = 
{	
	self.noise = "objects/pylon_loop.ogg";
		precache_sound(self.noise);
	self.timefly = self.duration;
	if (!self.timefly)
		self.timefly = 10;
	self.touch = trigger_fly_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	vector center = (self.absmax + self.absmin) / 2;  
	ambientsound(center, self.noise, 1, 256/768);
	self.modelindex = 0;
	self.model = string_null;
};

//============================================================================

.entity lightson;
void() trigger_shrine_touch = 
{ 
	if (other.classname != "player")
		return;
	
	te_customflash((self.absmin + self.absmax) / 2, 256, 3, '0.3 1 0.7');

	entity oself;
	oself = self;
	self = other;
	nowater_type();
	self = oself;
	message_garbage_collector ();
	
	write_shrine(0);
	
	read_currentprofileslot();
	copy_save_maps(0);
	local string saveloc;
	saveloc = strcat("save data/profiles/", profilename, "/shrine\n");
	stuffcmd(other, "scratch1 1\n");
	stuffcmd(other, saveloc);
	stuffcmd(other, "scratch1 0\n");
	//	stuffcmd(other, "save shrine\n");
	if (!(other.savedlist &SAVED_SIGIL))
		other.savedlist += SAVED_SIGIL;
	local float savestotalnumber;
	savestotalnumber = other.savedlist;
	writeprofilesavedlist(savestotalnumber);

	if (profilename)
		strunzone(profilename);

	other.shrine = 1;
	if (other.shrine_model_client == 0)
		other.Shrine_time = time + 0.25;
	write_shrine_user(1);
	sound(other, CHAN_AUTO, "objects/shrine.ogg", 1, ATTN_NONE);
	other.health = 100;
	SUB_UseTargets();
	oself = self;
	self = self.owner;
	self.think = self.use;
	self.nextthink = time;
	self = oself;	

	remove(self);
	message_garbage_collector ();
	save_screenshot(3,1.5);
	writedates(3);
	Hud_message_delay(26, self.origin, self);
};

void() trigger_shrine = 
{ 
	self.touch = trigger_shrine_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
};

void() func_shrine_use =
{
	if(self.glowmod_x > 1)
		self.glowmod = '0.95 0.95 0.95';
	self.lightson.light_lev -= 3;
	
	self.colormod_x -= 0.0125;
	self.colormod_y -= 0.013;
	self.colormod_z -= 0.015;

	self.glowmod_x -= 0.025;
	self.glowmod_y -= 0.025;
	self.glowmod_z -= 0.025;

	if(self.glowmod_x <= 0)
	{
		self.lightson.pflags = 0;
		self.glowmod = '-1 -1 -1';
		self.think = SUB_Null;
	}
	else
		self.think = func_shrine_use;
	self.nextthink = time + 0.05;
};

void() func_shrine_preuse = 
{
	self.glowmod = '2 2 2';
	self.think = func_shrine_use;
	self.nextthink = time + 0.05;
};

void() func_shrine = 
{ 
	self.solid = SOLID_BSP;
	setmodel(self, self.model);

	self.use = func_shrine_preuse;
	self.colormod = '1 1 1';
	self.glowmod = '1 1 1';

	entity pointlight = spawn();
	pointlight.origin = (self.absmin + self.absmax) / 2;
	pointlight.color = '1 1 1';
	pointlight.light_lev = 192;
	pointlight.pflags = 129;
	pointlight.style = 0;
	self.lightson = pointlight;

	entity shrine_field = spawn();
	shrine_field.owner = self;
	setmodel(shrine_field, self.model);
	setsize (shrine_field ,self.absmin + '92 92 0', self.absmax - '92 92 0');

	shrine_field.touch = trigger_shrine_touch;
	shrine_field.solid = SOLID_TRIGGER;
	shrine_field.modelindex = 0;
	shrine_field.model = string_null;

};

//============================================================================

.float exit;
void() end_trigger_restart = 
{
	stuffcmd(self.enemy, "restart\n");
	remove(self);
};
void() end_trigger_restart2 = 
{
	stuffcmd(self.enemy, "impulse 190");
	remove(self);
};
void() remove_tether = 
{
	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tether.txt");

	local float writeparms;
	local string writethis;
	writeparms = fopen(campaignloc, FILE_WRITE);	//open what file to use in write mode
	writethis = ftos(0);	//prepare the next thing to write
	fputs(writeparms, writethis);	//line 1
	fputs(writeparms, "\n");	//and again
	fclose(writeparms);
};
void() trigger_restart_touch = 
{
	if (other.classname != "player")
		return;
	remove_tether();
	self.solid = SOLID_NOT;
	te_customflash(other.origin, 64, 3, '1 0.7 0.3');
	self.enemy = other;

	if (self.exit == 1)
	{
		other.maxspeed = 0;
		other.movetype = 0;
		other.velocity = 0;
		other.solid = 0;
		other.vhud = 2;
		self.think = end_trigger_restart2;
		other.lspeedtime = time + self.wait;
		self.nextthink = time + self.wait;
	}
	else
	{
		self.think = end_trigger_restart;
		self.nextthink = time + 0.25;
	}
};

void() trigger_restart = 
{
	if (!self.exit)
		self.exit = 1;
	if(!self.wait)
	self.wait = 16.7;

	self.touch = trigger_restart_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
};


//============================================================================

void() trigger_secret_touch = 
{
	if (other.classname != "player")
		return;
	found_secrets = found_secrets + 1;
	WriteByte(MSG_ALL, SVC_FOUNDSECRET);
	sound(other, CHAN_AUTO, "misc/secret.ogg", 1, ATTN_NONE);
	Hud_message(27, other.origin, other);
	self.secret = 0;
	self.touch = SUB_Null;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
	self.nextthink = time + 1;
	self.think = SUB_Remove;
};

void() trigger_secret = 
{
	precache_sound("misc/secret.ogg");
	precache_sound("misc/talk.ogg");
	self.touch = trigger_secret_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.secret = 1; // just to work with marks
	self.modelindex = 0;
	self.wrathflags += FL_SECRET;
	self.model = string_null;
	total_secrets++;
};

//============================================================================

.float angle_deviance;
.float minorangle;
.float subangle;
.float temp_turret;
.float trigger_angle_use;
.float turret;
.float turret_enemy_visible;
.float turret_time;
.float turretable;
.string classtype;
.vector subangles;
void() stricken_preattack1;
void() wretch_attacka1;
void()afflicted_atk1;
void()determine_subangle;
void()invader_preattack;
void()oppressor_attacka1;
			
void() trigger_turret_touch = 
{ 
	if (!(other.flags & FL_MONSTER))
		return;

	if(!other.turretable)
		return;

	if(!other.trigger_angle_use)
		return;
	
	if(other.turret_time > time)	
		return;

	if(other.warped_time > time)	
		return;	

	if(self.turret_enemy_visible)
	{
		local entity oself;
		oself = self;
		self = other;
		if (!(visible(self.enemy)))
			return;
		self = oself;	
	}	

	if((!other.takedamage) && (other.classentity == "monsters"))
		other.takedamage = DAMAGE_AIM;

	if((self.target)||(self.turret_enemy_visible))
	{
		if(self.target)
		{
			other.minorangle =( (-1 * self.angle_deviance) + 180 )* (2/360);
			determine_subangle();
			other.subangle = self.enemy.angles_y;
			other.subangles_y = other.subangle;
		}
		else
			other.minorangle = -1;
		other.temp_turret = 1;
	}	

	if (other.turret != 1)
	{
		other.turret_time = time + 2.5;	
		other.turret = 1;
		if(self.turret_enemy_visible)
			other.turret_enemy_visible = 1;
		if(other.classname == "monster_stricken")
			other.th_run = stricken_preattack1;
		if(other.classname == "monster_invader")
			other.th_run = invader_preattack;
		if(self.classname == "monster_afflicted")
			other.th_run = afflicted_atk1;
		if(self.classname == "monster_wretch")
			other.th_run = wretch_attacka1;
		if(self.classname == "monster_oppressor")
			other.th_run = oppressor_attacka1;
		other.think = other.th_missile;
		other.nextthink = time;
	}
};

void() trigger_turret = 
{
	self.touch = trigger_turret_touch;
	if(!self.angle_deviance)
	self.angle_deviance = 90;
	
	if(self.angle_deviance > 180)
		self.angle_deviance =180;
	self.angle_deviance = self.angle_deviance * 2;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
};
//============================================================================
.float kill_player;
.float only_to_player;

void() hurt_on =
{
	self.solid = SOLID_TRIGGER;
	self.nextthink = -1;
};

void() hurt_touch =
{
	if ((other.takedamage) && (self.using ==  1))
	{
		if((self.kill_player == 1) && (other.classname == "player") && (other.health >0) )
		{
			other.health = -100;
			Killed(other, self, 1);
		}

		if((self.only_to_player ==  1)&& (other.classname == "player"))
			T_Damage (other, self, self, self.dmg);
		else
			T_Damage (other, self, self, self.dmg);

		self.solid = SOLID_NOT;
		if(self.wait > 0)
		{
			self.think = hurt_on;
			self.nextthink = time + self.wait;
		}
		else
			remove(self);
	}

	return;
};

void() trigger_hurt =
{
	if(!self.wait)
		self.wait = 1;
	InitTrigger ();
	self.touch = hurt_touch;
	if (!self.dmg)
		self.dmg = 5;
	if (!self.using)
		self.using = 1;
	self.use = toggle_use;
};

//============================================================================

.string changetarget;
.string changetargetname;
void() change_target = 
{
	entity t = find(world, changetargetname, self.target);
	t.target = self.changetarget;
}

void() trigger_changetarget =
{
	setmodel(self,"");
	self.use = change_target;
}



///////////////////////////////////end of qc file
