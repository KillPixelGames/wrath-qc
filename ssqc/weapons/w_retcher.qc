.float oldcnt;
void(float cdmg, float aoe) Cyxplode;
void() reload_retcher;

float() somecustomizefunction = 
{
	local entity pl;
	pl = find(world, classname, "player");	//find the client
	traceline(pl.origin + pl.view_ofs, self.origin, TRUE, other);
	if (trace_fraction == 1)
	{
		local float d;
		d = vlen(pl.origin - self.origin);
		if ((self.flags &FL_ONGROUND) || (d > 250))
			self.effects = 0;
		else
			self.effects = EF_NODEPTHTEST;
		return TRUE;
	}
	else
	{
		self.effects = 0;
		return TRUE;
	}
};
void() explo_model_retcher = 
{
	self.frame += 1;
	self.alpha -= 0.2;
	if (self.frame < 5)
		self.think = explo_model_retcher;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.05;
};

void(vector org) explo_retcher = 
{
	local entity giblood;
	giblood = spawn();
	giblood.alpha = 1;
	giblood.origin = org;
	setmodel(giblood, "particles/explo/explo_retcher.md3");
	giblood.think = explo_model_retcher;
	giblood.nextthink = time;
};

void() cys_explode10 = 
{
	self.skin += 1;self.think = SUB_Remove;self.nextthink = time + 0.05;
};
void() cys_explode9 = 
{
	self.skin += 1;self.think = cys_explode10;self.nextthink = time + 0.05;
};
void() cys_explode8 = 
{
	self.skin += 1;self.think = cys_explode9;self.nextthink = time + 0.05;
};
void() cys_explode7 = 
{
	self.skin += 1;self.think = cys_explode8;self.nextthink = time + 0.05;
};
void() cys_explode6 = 
{
	self.skin += 1;self.think = cys_explode7;self.nextthink = time + 0.05;
};
void() cys_explode5 = 
{
	self.skin += 1;self.think = cys_explode6;self.nextthink = time + 0.05;
};
void() cys_explode4 = 
{
	self.skin += 1;self.think = cys_explode5;self.nextthink = time + 0.05;
};
void() cys_explode3 = 
{
	self.skin += 1;self.think = cys_explode4;self.nextthink = time + 0.05;
};
void() cys_explode2 = 
{
	self.skin += 1;self.think = cys_explode3;self.nextthink = time + 0.05;
};
void() cys_explode1 = 
{
	self.skin += 0;self.think = cys_explode2;self.nextthink = time + 0.05;explo_retcher(self.origin);
};
void() cys_explode1b = 
{
	self.skin += 0;self.think = cys_explode2;self.nextthink = time + 0.05;
};

.float aoe_big;
void() aoe_think = 
{
	local float vcnt, rdamage, radiusretcher;
	vcnt = self.cnt / self.oldcnt;

	if (self.aoe_big == 1)
	{
		rdamage = vcnt *retcheraoedamage *1.5 + 10;
		radiusretcher = vcnt *retcheraoeradius *1.5 + 10;
		T_SplashDamage(self, self.owner, rdamage *1.25, world, radiusretcher);
		self.cnt -= 0.5;
	}
	else
	{
		rdamage = vcnt *retcheraoedamage + 10;
		radiusretcher = vcnt *retcheraoeradius + 10;
		T_SplashDamage(self, self.owner, rdamage, world, radiusretcher);
		self.cnt -= 1;
	}

	self.light_lev = self.light_lev *vcnt + 10;
	if (self.cnt > 0)
		self.think = aoe_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + retcheraoeframetime;
};

void() aoep_think = 
{
	if (self.owner.cnt > 0)
		self.think = aoep_think;
	else
		self.think = SUB_Remove;
	self.origin = self.owner.origin;

	if (self.aoe_big == 1)
	{
		if ((self.owner.cnt) < (self.cnt / 5))
			pointparticles(particleeffectnum("retcheraoebig5"), self.origin, v_forward *(-550), (3));
		else if ((self.owner.cnt) < (self.cnt / 4))
			pointparticles(particleeffectnum("retcheraoebig4"), self.origin, v_forward *(-550), (3));
		else if ((self.owner.cnt) < (self.cnt / 3))
			pointparticles(particleeffectnum("retcheraoebig3"), self.origin, v_forward *(-550), (3));
		else if ((self.owner.cnt) < (self.cnt / 2))
			pointparticles(particleeffectnum("retcheraoebig2"), self.origin, v_forward *(-550), (3));
		else
			pointparticles(particleeffectnum("retcheraoebig1"), self.origin, v_forward *(-550), (3));

	}
	else
		pointparticles(particleeffectnum("retcheraoe"), self.origin, v_forward *(-550), (1));
	self.nextthink = time + 0.1;
}

void(entity e) aoe_spawn = 
{
	local entity aoe, aoep;
	aoe = spawn();
	aoep = spawn();
	aoe.wrathflags += FL_GARBAGE;
	aoep.wrathflags += FL_GARBAGE;
	aoe.owner = e.owner;
	aoe.origin = e.origin;
	aoep.origin = e.origin;
	aoe.classname = "aoe";
	aoep.classname = "aoep";
	//aoe.movetype = MOVETYPE_TOSS;
	aoe.gravity = 0;	//.25;

	aoe.cnt = retcheraoetime / retcheraoeframetime;
	aoe.oldcnt = aoe.cnt;
	aoep.cnt = aoe.cnt;
	aoep.oldcnt = aoe.cnt;
	aoep.owner = aoe;
	if (e.classname == "afflicted")
	{
		aoep.aoe_big = 1;
		aoe.origin = e.origin - '0 0 32';
		aoep.origin = e.origin - '0 0 32';
	}

	if (e.classname == "stricken")
		aoep.aoe_big = 1;
	if (e.classname == "misc_cyst")
		aoep.aoe_big = 1;

	aoe.nextthink = time;
	aoep.nextthink = time;
	local string snd;
	snd = strcat("impact/projectiles/cyst_aoe", ftos(floor(random() *5) + 1), ".ogg");
	sound(aoe, CHAN_WEAPON, snd, 1, 0.5);
	aoe.think = aoe_think;
	aoep.think = aoep_think;
};

void() check_retcher_skin = 
{
	if (self.ammo_retcher >= 1)
		self.vweaponskin = 0;
	else
		self.vweaponskin = 1;
};

void() idle_retcher = 
{
	if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
	}

	self.realoding = 0;
	check_retcher_skin();
	self.vweaponframe = 0;
	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	//	self.think = idle_retcher;
	//	self.nextthink = time + 0.1;
};

void() release_retcher2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 20)
		self.think = idle_retcher;
	else
		self.think = release_retcher2;
	self.nextthink = time + 0.05;
};

void() release_retcher = 
{
	check_retcher_skin();
	self.vweaponframe = 16;
	self.think = release_retcher2;
	self.nextthink = time + 0.05;
};

void() CyExplosion1 = 
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel(self, "particles/explo/explo_cyst.md3");
	self.solid = SOLID_NOT;
	T_SplashDamage(self, self.owner, damageexplosionafflicted, world, damageexplosionafflicted);
	local float skinn;
	skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	self.skin = skinn * 10;
	local string snd;
	snd = strcat("impact/projectiles/cyst_explo", ftos(floor(random() *5) + 1), ".ogg");
	sound(self, CHAN_AUTO, snd, 1, 0.25);
	pointparticles(particleeffectnum("retcher"), self.origin, v_forward *(-550), 1);
	cys_explode1();
};

void() CyExplosion = 
{
	self.movetype = MOVETYPE_NONE;

	self.classname = "explosion_retcher";
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel(self, "particles/explo/explo_cyst.md3");
	self.solid = SOLID_NOT;
/*	if (self.owner.classname == "monster_stricken")
	{
		T_SplashDamage(self, self.owner, stricken_splashdmg, world, stricken_splashradius);
		self.scale = 1;
	}
	else
		T_SplashDamage(self, self.owner, retchersplashdamage, world, retchersplashradius);*/
	local float skinn;
	skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	self.skin = skinn * 10;
	local string snd;
	snd = strcat("impact/projectiles/cyst_explo", ftos(floor(random() *5) + 1), ".ogg");
	sound(self, CHAN_AUTO, snd, 1, 0.25);
	pointparticles(particleeffectnum("retcher"), self.origin, v_forward *(-550), 1);
	cys_explode1();
};

void() PreCyExplosion = 
{
	Cyxplode(self.cnt, 1); self.lifetime = 0;
};
void() CheckCys = {
	if (self.flags &FL_ONGROUND)
	{
		//if(self.movetype == MOVETYPE_BOUNCE)
		//self.flags = self.flags - (self.flags & FL_ONGROUND);
		//self.velocity = self.oldvelocity;
		self.traileffectnum = particleeffectnum("null");
	}
	else
	{
		self.oldvelocity = self.velocity;
		if (self.owner.classname != "monster_stricken")
			self.traileffectnum = particleeffectnum("retchertrail");
	}

	if (self.lifetime < time)
		self.think = PreCyExplosion;
	else
		self.think = CheckCys;
	self.nextthink = time + 0.1;
};

void(float cdmg, float aoe) Cyxplode = 
{
	self.classname = "explosion_retcher";
	local float damg;
	if (cdmg == 1)
		damg = retcherdamg2;
	else
		damg = retcherdamg;
	if (self.owner.classname == "monster_stricken")
		T_SplashDamage(self, self.owner, stricken_splashdmg, world, stricken_splashradius);
	else
		T_SplashDamage(self, self.owner, retchersplashdamage, world, retchersplashradius);
	local vector org;
	org = self.origin;
	CyExplosion();
	if (aoe == 1)
		aoe_spawn(self);
	self.traileffectnum = particleeffectnum("null");
};
void() cyst_field_think =
{
	setorigin (self, self.owner.origin);
	if(self.owner.lifetime < time)
		self.think = SUB_Remove;
	else
		self.think = cyst_field_think;
	self.nextthink = time + 0.1;
};

void() cyst_field_touch =
{
	if((other.health) &&(other.flags & FL_MONSTER))
		self.owner.lifetime =  0;
};

void() cyst_field_die =
{
		self.owner.lifetime =  0;
};


void() cyst_touch = 
{ 
	pointparticles(particleeffectnum("retcherdecal"), self.origin, '0 0 0', 1);
	if (other == self.owner)
		return;	// don't explode on owner
	if(other.solid == SOLID_TRIGGER)
		return;
	if (self.cnt == 2)
	{
		if (other.takedamage > 0)
		{
			T_Damage(other, self, self.owner, retcherdamg);
			Cyxplode(self.cnt, 0);
			return;
		}
		local string snd;
		
		self.bouncefactor -= 0.05;
		self.velocity_x = self.velocity_x + random (-120,120);
		self.velocity_y = self.velocity_y + random (-120,120);
		self.velocity_z = self.velocity_z + random (0,120);
		snd = strcat("impact/projectiles/cyst_bounce", ftos(floor(random() *5) + 1), ".ogg");
		sound(self, CHAN_AUTO, snd, 1, 0.25);
	}
	if (self.cnt == 1)
	{
		if ((other.takedamage > 0) && (other.classname != "cystfield"))
		{
			T_Damage(other, self, self.owner, retcherdamg2);
			Cyxplode(self.cnt, 0);
			return;
		}
		else
		{

			entity cyst_field = spawn();
			cyst_field.owner = self;
			cyst_field.origin = self.origin;
			setsize (cyst_field, '-32 -32 -32', '32 32 32');
			cyst_field.solid = SOLID_TRIGGER;
			cyst_field.takedamage = DAMAGE_AIM;
			cyst_field.health = 5;
			cyst_field.th_die = cyst_field_die; 
			cyst_field.touch = cyst_field_touch; 
			cyst_field.think = cyst_field_think;
			cyst_field.nextthink = time + 0.1;
			entity cyst_solid_field = spawn();
			cyst_solid_field.owner = self;
			cyst_solid_field.origin = self.origin;
			setsize (cyst_solid_field, '-16 -16 -16', '16 16 16');
			cyst_solid_field.solid = SOLID_BBOX;
			cyst_solid_field.clipgroup = 1;
			cyst_solid_field.classname = "cystfield";
			cyst_solid_field.takedamage = DAMAGE_AIM;
			cyst_solid_field.health = 5;
			cyst_solid_field.th_die = cyst_field_die; 
			force_retouch = 2;

			if(other !=  world)
			{
				self.movetype = MOVETYPE_FOLLOW;
				self.solid = SOLID_NOT;
				self.aiment = other;
				self.punchangle = other.angles;
				self.view_ofs = self.origin - other.origin; 
				self.v_angle = self.angles - other.angles;
			}
			else
			{
				self.movetype = 0;
				self.velocity = '0 0 0';
			}
		}
	}
};

void(float rtag) W_Fireretcher = 
{
	local vector dir, rorg, tagorg;
	local float sv, tagindex;
	newmis = spawn();
	newmis.owner = self;
	newmis.solid = SOLID_BBOX;
	newmis.think = CheckCys;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.nextthink = time;
	newmis.traileffectnum = particleeffectnum("retchertrail");
	dir = aim(self, 1000);
	rorg = self.view_ofs - '0 0 19';
	local string tagname;
	tagname = strcat("tag_muzzle_", ftos(rtag));
	tagindex = gettagindex(self.vweapon, tagname);
	tagorg = gettaginfo(self.vweapon, tagindex);
	sv += 0.0075 *self.slagcannonspread;
	setorigin(newmis, tagorg);
	setmodel(newmis, "models/projectiles/proj_cyst.md3");
	newmis.classname = "spleet";
	newmis.velocity = normalize(cursor_trace_endpos_fixed (self) - newmis.origin) *retcher_proj_vel;
	newmis.velocity_z += retcher_proj_velz;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = cyst_touch;
	newmis.gravity = retcher_proj_grav;
	newmis.modelflags = 0;
	newmis.effects = EF_NOSHADOW;
	self.ammo_retcher -= 1;

	if (rtag == 1)
	{
		//snd = strcat("weapons/retcher/fire1_", ftos(floor(random() *5) + 1), ".ogg");
		//sound(self, CHAN_WEAPON, snd, 1, ATTN_NORM);
		
		weapon_sound("weapons/retcher/fire1_", 5);
		newmis.cnt = 1;
		newmis.clipgroup = 1;
		newmis.lifetime = time + 15;
		//setsize (newmis, '0 0 0', '0 0 0');
	}
	else
	{
		//snd = strcat("weapons/retcher/fire2_", ftos(floor(random() *5) + 1), ".ogg");
		//sound(self, CHAN_WEAPON, snd, 1, ATTN_NORM);
		weapon_sound("weapons/retcher/fire2_", 5);
		newmis.bouncefactor = random( 0.75, 1);
		newmis.lifetime = time + 5;
		newmis.cnt = 2;
	}
	setsizeitem(newmis, retcher_proj_size);
	float active_punchangle = cvar ("cl_punch");
	if(active_punchangle == 1)
	self.punchangle_x = -2;
};

void() wfire_retcher2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 2)
		self.vweaponskin = 1;
	if (self.vweaponframe == 3)
		check_retcher_skin();
	if (self.vweaponframe >= 15)
		self.think = release_retcher;
	else
		self.think = wfire_retcher2;
	self.nextthink = time + 0.05;
};

void() wfire_retcher = 
{
	if (!self.ammo_retcher)
		return;
	self.vweaponframe = 1;	// empty
	self.think = wfire_retcher2;
	W_Fireretcher(1);
	self.attack_finished = time + 0.75;
	self.nextthink = time + 0.05;
};

void() wsfire_retcher3 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 28)
		self.vweaponskin = 1;
	if ((self.vweaponframe == 29) && (self.ammo_retcher >= 1))
		self.vweaponskin = 0;

	if (self.vweaponframe >= 40)
		self.think = idle_retcher;
	else
		self.think = wsfire_retcher3;
	self.nextthink = time + 0.05;
};

void() wsfire_retcher2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 25)
		self.vweaponskin = 1;
	if ((self.vweaponframe == 26) && (self.ammo_retcher >= 1))
		self.vweaponskin = 0;
	if (self.vweaponframe >= 27)
	{
		self.think = wsfire_retcher3;
		W_Fireretcher(2);
	}
	else
		self.think = wsfire_retcher2;
	self.nextthink = time + 0.05;
};

void() wsfire_retcher1 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 22)
		self.vweaponskin = 1;

	if ((self.vweaponframe == 23) && (self.ammo_retcher >= 1))
		self.vweaponskin = 0;
	if (self.vweaponframe >= 24)
	{
		W_Fireretcher(2);
		self.think = wsfire_retcher2;
	}
	else
		self.think = wsfire_retcher1;
	self.nextthink = time + 0.05;
};

void() wsfire_retcher = 
{
	if (!self.ammo_retcher)
		return;
	if (self.ammo_retcher == 1)
	{
		W_Fireretcher(2);
		self.vweaponframe = 27;
		self.think = wsfire_retcher3;
	}
	else if (self.ammo_retcher == 2)
	{
		W_Fireretcher(2);
		self.vweaponframe = 24;
		self.think = wsfire_retcher2;
	}
	else
	{
		W_Fireretcher(2);
		self.vweaponframe = 21;
		self.think = wsfire_retcher1;
	}
	
	/*W_Fireretcher(2);
	self.vweaponframe = 27;
	self.think = wsfire_retcher3;
	*/
	self.attack_finished = time + 1;
	self.nextthink = time + 0.05;
};

void() pre_idle_retcher = 
{
	self.pick_up_time = time + 0.5;
	self.vweaponstate = 1;
	self.think = idle_retcher;
	self.nextthink = time;
}

void() pick_up_retcher = {	//check_retcher_skin();
	self.vweaponskin = 0;
	self.weapon = IT_RETCHER;
	self.lastweapon = IT_RETCHER;
	sound(self, CHAN_WEAPON, "weapons/retcher/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponstate = 2;
	self.vweaponframe = 61;
	if (self.noltime < time)
		self.lspeedtime = time + 7;
	self.attack_finished = time + 0.05;
	self.nextthink = time + 8;
	self.think = pre_idle_retcher;
};

void() raise_retcher2 = 
{
	if (self.vweaponframe == 42)
		W_SetWeapon();

	self.vweaponframe += 1;
	if (self.vweaponframe >= 45)
	{
		if (self.preloadcyst == 1)
			self.think = reload_retcher;
		else
			self.think = idle_retcher;
	}
	else
		self.think = raise_retcher2;
	self.nextthink = time + 0.025;
};

void() raise_retcher = 
{
	check_retcher_skin();
	self.weapon = IT_RETCHER;
	W_SetWeapon();
	self.vweaponglowmod = '1 1 1';
	sound(self, CHAN_AUTO, "weapons/retcher/raise.ogg", 1, ATTN_NORM);
	self.draw_w = 0;
	self.vweaponframe = 41;
	self.attack_finished = time + 0.25;
	self.think = raise_retcher2;
	self.nextthink = time + 0.025;
	self.vweaponstate = 1;

};

void() lower_retcher2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 50)
		self.think = raise_weapon;
	else
		self.think = lower_retcher2;
	self.nextthink = time + 0.025;

};

void() lower_retcher = 
{
	sound(self, CHAN_AUTO, "weapons/retcher/lower.ogg", 1, ATTN_NORM);
	self.vweaponframe = 46;
	self.attack_finished = time + 0.25;
	self.think = lower_retcher2;
	self.nextthink = time + 0.025;
	self.vweaponstate = 2;
};

void() reload_retcher2 = 
{
	self.vweaponframe += 1;
	self.vweaponskin = 0;
	if (self.vweaponframe >= 60)
		self.think = idle_retcher;
	else
		self.think = reload_retcher2;
	self.nextthink = time + 0.025;
};

void() reload_retcher = 
{
	self.realoding = 1;
	self.preloadcyst = 0;
	self.vweaponframe = 51;
	self.think = reload_retcher2;
	self.attack_finished = time + 0.5;
	self.nextthink = time + 0.025;
};

///////////////////////////////////end of qc file