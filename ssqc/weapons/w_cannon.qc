.float explodcount;
.float gwmd;
void() wfire_cannon;

void() idle_cannon = 
{
	if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
	}

	self.realoding = 0;
	self.vweaponframe = 0;
	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	self.vweaponframe = 0;
	self.vweaponglowmod = '1 1 1';
	self.vweaponskin = 0;
};

void() prelease_cannon = {

	self.vweaponframe += 1;
	if (self.vweaponframe >= 20)
		self.think = idle_cannon;
	else
		self.think = prelease_cannon;
	self.nextthink = time + 0.05;
};

void() slag2_explode10 = 
{
	self.skin += 1;self.think = SUB_Remove;self.nextthink = time + 0.05;
};
void() slag2_explode9 = 
{
	self.skin += 1;self.think = slag2_explode10;self.nextthink = time + 0.05;
};
void() slag2_explode8 = 
{
	self.skin += 1;self.think = slag2_explode9;self.nextthink = time + 0.05;
};
void() slag2_explode7 = 
{
	self.skin += 1;self.think = slag2_explode8;self.nextthink = time + 0.05;
};
void() slag2_explode6 = 
{
	self.skin += 1;self.think = slag2_explode7;self.nextthink = time + 0.05;
};
void() slag2_explode5 = 
{
	self.skin += 1;self.think = slag2_explode6;self.nextthink = time + 0.05;
};
void() slag2_explode4 = 
{
	self.skin += 1;self.think = slag2_explode5;self.nextthink = time + 0.05;
};
void() slag2_explode3 = 
{
	self.skin += 1;self.think = slag2_explode4;self.nextthink = time + 0.05;
};
void() slag2_explode2 = 
{
	self.skin += 1;self.think = slag2_explode3;self.nextthink = time + 0.05;
};
void() slag2_explode1 = 
{
	self.skin += 0;self.think = slag2_explode2;self.nextthink = time + 0.05;
};
void() slag_explode5 = 
{
	self.skin += 1;self.think = SUB_Remove;self.nextthink = time + 0.05;
};
void() slag_explode4 = 
{
	self.skin += 1;self.think = slag_explode5;self.nextthink = time + 0.05;
};
void() slag_explode3 = 
{
	self.skin += 1;self.think = slag_explode4;self.nextthink = time + 0.05;
};
void() slag_explode2 = 
{
	self.skin += 1;self.think = slag_explode3;self.nextthink = time + 0.05;
};
void() slag_explode1 = 
{
	self.skin += 0;self.think = slag_explode2;self.nextthink = time + 0.05;
};
void() nextframe = 
{
	self.frame = 1;
	self.nextthink = time + 5;
	self.think = SUB_Remove;
};

void() slagdrunk = 
{ 
	if(!self.frame)
		self.frame = 1;
	
	self.explodcount += 1;
	self.velocity = ((self.velocity + ((v_right *20.000) *crandom())) + ((v_up *20.000) *crandom()));
	self.nextthink = time + 0.1;	// screw up fast
	
	float speed;
	speed = vlen (self.velocity);
	if (speed < 20)
	{	
		sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop
		self.think = SUB_Remove;
		return;
	}
	if (self.explodcount < 50)
		self.think = slagdrunk;
	else
	{
		sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop
		self.think = SUB_Remove;
	}
};

void() srelease_cannon2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 40)
		self.think = idle_cannon;
	else
		self.think = srelease_cannon2;
	self.nextthink = time + 0.05;
};

void() srelease_cannon = 
{
	self.vweaponframe = 31;
	self.think = srelease_cannon2;
	self.nextthink = time + 0.05;
};
void() cannon_proj_touch_fade= 
{
	self.alpha -= 0.1;
	self.frame += 1;
	if (self.alpha < 0)
		self.think = SUB_Remove;
	else
		self.think = cannon_proj_touch_fade;
	self.nextthink = time + 0.05;
};

void(float m) cannon_proj_touch_impact = 
{
	self.movetype = MOVETYPE_NONE;

	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	self.solid = SOLID_NOT;
	makevectors(self.angles);
	self.angles = '0 0 0';
	//self.origin = self.origin + v_forward *-12 + v_up *-5;
	self.frame = 0;
	if (m == 1)
		setmodel(self, "models/projectiles/proj_slag1_explo.md3");
	else
		setmodel(self, "models/projectiles/proj_slag2_explo.md3");
	self.alpha = 1;
	self.think = cannon_proj_touch_fade;
	self.nextthink  =  time + 0.05;
};


void()acelerator_think =
{
self.owner.velocity = self.velocity;
remove(self);
};
void(entity perpetrator, float value, vector exp_origin) T_RocketJump =
{

	vector org = perpetrator.origin + perpetrator.view_ofs;
	exp_origin_z -= bboxslag2_z;
	float points = 0.5*vlen (exp_origin - org);
	if (points < 0)
		points = 0;
	points = value - points;
	if (points > 0)
	{
		if((perpetrator.origin_z + perpetrator.absmin_z) >= exp_origin_z)
			perpetrator.velocity_z += points * 5;
		vector dir = perpetrator.origin - exp_origin;
		dir = normalize(dir);
		entity acelerator = spawn();
		acelerator.movetype = MOVETYPE_NOCLIP;
		acelerator.velocity = perpetrator.velocity + dir*points*8;
		acelerator.owner = perpetrator;
		acelerator.think = acelerator_think;
		acelerator.nextthink = time + 0.05;
	}
};


void() cannon_proj_touch = 
{
	local vector org;
	org = self.origin;
	local string snd;
	if(other == self.owner)
	return;

	if(other.classentity == "projectiles")
		return;
	if (other.solid == SOLID_TRIGGER)
		return;

	if (self.cnt == 1)
	{
	self.classname = "explosion_ore";
	
		if((deathmatch == 1) || (other.classname == "player"))
		{
			T_Damage(other, self, self.owner,slagcannon_damage1_mp);
			T_SplashDamage(self, self.owner,slagsplashdamage_mp, world, slagsplashradius);
		}
		else
		{
			T_Damage(other, self, self.owner,slagcannon_damage1);
			T_SplashDamage(self, self.owner,slagsplashdamage, world, slagsplashradius);
		}
		cannon_proj_touch_impact(1);
		snd = strcat("impact/projectiles/slag1_explo", ftos(floor(random() *5) + 1), ".ogg");
		pointparticles(particleeffectnum("slag"), org, v_forward *(-550), 1);
		sound(self, CHAN_AUTO, snd, 1, 0.25);
	}
	else
	{
	self.classname = "explosion_oreb";
		if((deathmatch == 1) || (other.classname == "player"))
		{
			T_Damage(other, self, self.owner,slagcannon_damage2_mp);
			T_SplashDamage(self, self.owner, slagsplashdamage2_mp, world, slagsplashradius2);
		}
		else
		{
			T_Damage(other, self, self.owner,slagcannon_damage2);
			T_SplashDamage(self, self.owner, slagsplashdamage2, world, slagsplashradius2);
		}
		
		T_RocketJump(self.owner,slagrocketjump,self.origin);
		cannon_proj_touch_impact(2);
		snd = strcat("impact/projectiles/slag2_explo", ftos(floor(random() *3) + 1), ".ogg");
		pointparticles(particleeffectnum("slag2"), org, v_forward *(-550), 1);
		sound(self, CHAN_AUTO, snd, 1, 0.125);
	}
};
void(float type, float forg) W_FireCannon = 
{
	local vector dir, rorg, tagorg;
	local float sv, tagindex;

	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "ore";
	newmis.classentity = "projectiles";
	dir = aim(self, 1000);
	rorg = self.view_ofs - '0 0 19';

	if (type == 1)
	{
		local string tagname;
		tagname = strcat("muzzle_", ftos(forg));
		tagindex = gettagindex(self.vweapon, tagname);
		tagorg = gettaginfo(self.vweapon, tagindex);
		sv += 0.0075 *self.slagcannonspread;
		setorigin(newmis, tagorg);
		setmodel(newmis, "models/projectiles/proj_slag1.md3");
		newmis.cnt = 1;
		newmis.think = slagdrunk;
		newmis.nextthink = time + 0.1;
		newmis.traileffectnum = particleeffectnum("slagtrail");
		newmis.velocity = normalize(cursor_trace_endpos_fixed (self) - newmis.origin) *slagspeed;
		setsizeitem(newmis, bboxslag);
		self.ammo_cannon -= 1;
	}
	else
	{
		newmis.classname = "ore2";
		tagindex = gettagindex(self.vweapon, "muzzle_4");
		tagorg = gettaginfo(self.vweapon, tagindex);
		newmis.scale = 1;
		setorigin(newmis, tagorg);
		setmodel(newmis, "models/projectiles/proj_slag2.md3");
		newmis.think = nextframe; 
		newmis.nextthink = time + 0.1;
		newmis.traileffectnum = particleeffectnum("slagtrail2");
		//newmis.velocity = normalize(self.cursor_trace_endpos - newmis.origin) *slagspeed2;
		newmis.velocity = normalize(cursor_trace_endpos_fixed (self) - newmis.origin) *slagspeed2;
		setsizeitem(newmis, bboxslag2);
		self.ammo_cannon -= 5;
	}

	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = cannon_proj_touch;
	newmis.effects = EF_NOSHADOW;
	//self.punchangle_x = -2;
	self.vweaponframe = 3;
};

void() wfire_cannon14 = 
{
	self.vweaponframe = 15;
	if ((self.button0) && (self.ammo_cannon >= 1))
	{
		self.think = wfire_cannon;
		self.attack_finished = time + 0.25;
	}
	else
	{
		self.think = prelease_cannon;
	}
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}
	self.nextthink = time + 0.05;
};

void() wfire_cannon13 = 
{
	self.vweaponframe = 14;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon14;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon12 = {
	//snd = strcat("weapons/cannon/fire1_", ftos(floor(random() *5) + 1), ".ogg");
	//sound(self, CHAN_AUTO, snd, 1, ATTN_NORM);
	weapon_sound("weapons/cannon/fire1_", 5);
	//self.ammo_cannon -= 1;
	W_FireCannon(1, 3);
	self.vweaponframe = 13;
	self.think = wfire_cannon13;
	if (!self.ammo_cannon)
	{
	self.vweaponframe = 16;
	self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon11 = 
{
	self.vweaponframe = 12;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon12;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon10 = 
{
	
	//snd = strcat("weapons/cannon/fire1_", ftos(floor(random() *5) + 1), ".ogg");
	//sound(self, CHAN_AUTO, snd, 1, ATTN_NORM);
	weapon_sound("weapons/cannon/fire1_", 5);
	W_FireCannon(1, 2);
	self.vweaponframe = 11;
	self.think = wfire_cannon11;
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon9 = 
{
	self.vweaponframe = 10;
	if ((self.button0) && (self.ammo_cannon >= 1))
	{
		self.think = wfire_cannon10;
		self.attack_finished = time + 0.25;
	}
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}


	self.nextthink = time + 0.05;
};

void() wfire_cannon8 = 
{
	self.vweaponframe = 9;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon9;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon7 = 
{
	
	//snd = strcat("weapons/cannon/fire1_", ftos(floor(random() *3) + 1), ".ogg");
	//sound(self, CHAN_AUTO, snd, 1, ATTN_NORM);
	//self.ammo_cannon -= 1;
	weapon_sound("weapons/cannon/fire1_", 5);
	W_FireCannon(1, 1);
	self.vweaponframe = 8;
	self.think = wfire_cannon8;
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon6 = 
{
	self.vweaponframe = 7;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon7;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon5 = 
{
	
	//snd = strcat("weapons/cannon/fire1_", ftos(floor(random() *3) + 1), ".ogg");
	//sound(self, CHAN_AUTO, snd, 1, ATTN_NORM);
	//self.ammo_cannon -= 1;
	weapon_sound("weapons/cannon/fire1_", 5);
	W_FireCannon(1, 3);
	self.vweaponframe = 6;
	self.think = wfire_cannon6;
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon4 = 
{
	self.vweaponframe = 5;
	if ((self.button0) && (self.ammo_cannon >= 1))
	{
		self.think = wfire_cannon5;
		self.attack_finished = time + 0.25;
	}
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}
	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}


	self.nextthink = time + 0.05;
};

void() wfire_cannon3 = 
{
	self.vweaponframe = 4;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon4;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon2 = 
{
	
	weapon_sound("weapons/cannon/fire1_", 5);
	W_FireCannon(1, 2);
	self.vweaponframe = 3;
	self.think = wfire_cannon3;

	if (!self.ammo_cannon)
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}


	self.nextthink = time + 0.05;
};

void() wfire_cannon1 = 
{
	self.vweaponframe = 2;
	if (self.ammo_cannon >= 1)
		self.think = wfire_cannon2;
	else
	{
		self.vweaponframe = 16;
		self.think = prelease_cannon;
	}

	self.nextthink = time + 0.05;
};

void() wfire_cannon = 
{
	if (self.ammo_cannon < 1)
		return;
	//ocal string snd;
	//snd = strcat("weapons/cannon/fire1_", ftos(floor(random() *3) + 1), ".ogg");
	//sound(self, CHAN_AUTO, snd, 1, ATTN_NORM);
	//self.ammo_cannon -= 1;
	weapon_sound("weapons/cannon/fire1_", 5);
	W_FireCannon(1, 1);
	self.vweaponframe = 1;
	self.think = wfire_cannon1;
	if (!self.ammo_cannon)
	self.think = prelease_cannon;
	self.attack_finished = time + 0.25;
	self.nextthink = time + 0.05;
};

void() wsfire_cannon1 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 30)
	{
		if ((self.button3) && (self.ammo_cannon >= 5))
			self.think = wsfire_cannon;
		else
			self.think = srelease_cannon;
	}
	else
		self.think = wsfire_cannon1;
	self.nextthink = time + 0.05;
};

void() wsfire_cannon = 
{
	if (self.ammo_cannon < 5)
		return;
	//local string snd;
	//snd = strcat("weapons/cannon/fire2_", ftos(floor(random() *2) + 1), ".ogg");
	//sound(self, CHAN_WEAPON, snd, 1, ATTN_NORM);
	weapon_sound("weapons/cannon/fire2_", 5);
	W_FireCannon(2, 1);
	//self.ammo_cannon -= 50;
	self.vweaponframe = 21;
	self.think = wsfire_cannon1;
	self.nextthink = time + 0.05;
	self.attack_finished = time + 0.5;
};

.entity pipes;
void() pipes_think =
{
	if(self.owner.weapon != IT_CANNON)
	{
		remove(self);
		return;
	}
	if(((self.owner.button0)&& (self.owner.ammo_cannon >= 1))  || ((self.owner.button3) && ( self.owner.ammo_cannon >= 5)))
	{
		if(self.glowmod_x < 1) 
		{
			self.glowmod_x += 0.0125; 
			self.glowmod_z = self.glowmod_x; 
			self.glowmod_y = self.glowmod_x; 
		}
	}
	else
	{
		if(self.glowmod_x > 0.0125) 
		{
			self.glowmod_x -= 0.0125; 
			self.glowmod_z = self.glowmod_x; 
			self.glowmod_y = self.glowmod_x; 
		}
	}
	self.nextthink = time + 0.025;
};

void(entity e, entity vweapn) spawn_pipes = 
{
	e.pipes = spawn();
	e.pipes.glowmod = '0.025 0.025 0.025';
	e.pipes.owner = e;
	e.pipes.wrathflags += FL_GARBAGE;
	setmodel(e.pipes, "models/weapons/cannon/v_pipes.md3");
	setattachment(e.pipes, vweapn, "tag_pipes");
	e.pipes.nextthink = time;
	e.pipes.think = pipes_think;
};

void() pick_up_cannon2 = 
{
 	if (time > self.attack_finished)
	{
		self.pick_up_time = time + 0.5;
		self.vweaponstate = 1;
		self.think = idle_cannon;
		self.vweaponglowmod = '1 1 1';
	}
	else
		self.think = pick_up_cannon2;
	self.nextthink = time + 0.05;
};

void() pick_up_cannon = 
{
	self.weapon = IT_CANNON;
	self.lastweapon = IT_CANNON;
	W_SetWeapon();

	sound(self, CHAN_WEAPON, "weapons/cannon/inspect.ogg", 1, ATTN_NORM);
	self.draw_w = 0;
	self.vweaponstate = 2;
	self.vweaponframe = 61;
	self.vweaponglowmod = '1 1 1';
	if (self.noltime < time)
		self.lspeedtime = time + 2;
	spawn_pipes (self, self.vweapon);
	self.attack_finished = time + 0.05;
	self.think = pick_up_cannon2;
	self.nextthink = time + 2.95;
};

void() raise_cannon2 = 
{
	if (self.vweaponframe == 42)
		W_SetWeapon();

	self.vweaponframe += 1;
	if (self.vweaponframe >= 50)
		self.think = idle_cannon;
	else
		self.think = raise_cannon2;
	self.nextthink = time + 0.0125;
};


void() raise_cannon = 
{
	self.weapon = IT_CANNON;
	W_SetWeapon();
	//sound(self, CHAN_WEAPON, "weapons/cannon/raise.ogg", 1, ATTN_NORM);
	self.vweaponglowmod = '1 1 1';
	sound(self, CHAN_AUTO, "weapons/cannon/raise.ogg", 1, ATTN_NORM);
	self.draw_w = 0;
	self.vweaponframe = 41;
	self.vweaponstate = 1;
	spawn_pipes (self, self.vweapon);
	self.attack_finished = time + 0.125;
	self.think = raise_cannon2;
	self.nextthink = time + 0.0125;
};

void() lower_cannon2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 55)
		remove(self.pipes);
	if (self.vweaponframe >= 60)
		self.think = raise_weapon;
	else
		self.think = lower_cannon2;
	self.nextthink = time + 0.0125;
};

void() lower_cannon = 
{
	
	sound(self, CHAN_AUTO, "weapons/cannon/lower.ogg", 1, ATTN_NORM);
	self.vweaponframe = 51;
	self.attack_finished = time + 0.375;
	self.think = lower_cannon2;
	self.vweaponstate = 2;
	self.nextthink = time + 0.0125;
};

///////////////////////////////////end of qc file