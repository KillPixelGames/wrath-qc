/*
==============================================================================

wraith

==============================================================================
*/

$frame base

$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8 hover9 hover10

$frame magatt1 magatt2 magatt3 magatt4 magatt5 magatt6 magatt7
$frame magatt8 magatt9 magatt10

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8 pain9 pain10

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8 paina9 paina10

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10

$frame death1 death2

$frame wfr1 wfr2 wfr3

$frame wfl1 wfl2 wfl3

/*
==============================================================================

wraith

If the player moves behind cover before the missile is launched, launch it
at the last visible spot with no velocity leading, in hopes that the player
will duck back out and catch it.
==============================================================================
*/

void() wraith_run1;
void() wraith_side1;
void() wraithAttackFinished;

void() wraith_run1b;
void() wraith_run1 = 
{
	if (self.enemy != world)
		self.think = wraithAttackFinished;
	else
		self.think = wraith_run1b;
	self.nextthink = time;
};

/*
=================
wraithCheckAttack
=================
*/
float() wraithCheckAttack = 
{
	local vector spot1, spot2;
	local entity targ;
	local float chance;

	if (time < self.attack_finished)
		return FALSE;

	if (!enemy_vis)
		return FALSE;

	if (enemy_range == RANGE_FAR)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wraith_run1();
		}
		return FALSE;
	}

	targ = self.enemy;

	// see if any entities are in the way of the shot
	spot1 = self.origin + self.view_ofs;
	spot2 = targ.origin + targ.view_ofs;

	traceline(spot1, spot2, FALSE, self);

	if (trace_ent != targ)
	{
		// don't have a clear shot, so move to a side
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wraith_run1();
		}
		return FALSE;
	}

	if (enemy_range == RANGE_MELEE)
		chance = 1;

	else if (enemy_range == RANGE_NEAR)
		chance = 1;

	else if (enemy_range == RANGE_MID)
		chance = 0;

	else
		chance = 0;

	if (chance == 1)
	{
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	if (enemy_range == RANGE_MID)
	{
		if (self.attack_state != AS_STRAIGHT)
		{
			self.attack_state = AS_STRAIGHT;
			wraith_run1();
		}
	}
	else
	{
		if (self.attack_state != AS_SLIDING)
		{
			self.attack_state = AS_SLIDING;
			wraith_side1();
		}
	}

	return FALSE;
};

/*
=================
wraithAttackFinished
=================
*/
void() wraith_fast1;

void() wraithAttackFinished = 
{
	local float renemy_range;
	local vector spot1, spot2;
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = self.enemy.origin;

	renemy_range = vlen(spot1 - spot2);

	if (renemy_range > 1024 || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = wraith_run1b;
	}
	else
	{

		local float rnd;
		rnd = random();
		if (rnd > 0.5)
		{
			self.attack_state = AS_SLIDING;
			ai_face();
			self.think = wraith_side1;
		}
		else
			self.think = wraith_fast1;
	}
	self.nextthink = time + 0.025;
};

void() wraithCheckDistance = 
{
	local float renemy_range;
	local vector spot1, spot2;
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = self.enemy.origin;
	renemy_range = vlen(spot1 - spot2);

	if (renemy_range > 1024 || !enemy_vis)
	{
		self.attack_state = AS_STRAIGHT;
		self.think = wraith_run1b;
	}
	else
	{

		local float rnd;
		rnd = random();
		if (rnd > 0.9)
		{
			self.attack_state = AS_SLIDING;
			ai_face();
			self.think = wraith_side1;
		}
		else
			self.think = wraith_fast1;
	}
	self.nextthink = time + 0.025;

};

.float righty_dir;
.float lefty_dir;

void() wraith_checkr_direction = 
{
	local vector source;

	makevectors(self.v_angle);
	source = self.origin;
	tracebox(source, '-1 -1 -1', '1 1 1', source + v_right *128, FALSE, self);
	if (trace_fraction == 1)
		self.righty_dir = 1;
	else
		self.righty_dir = 0;
};
void() wraith_checkl_direction = 
{
	local vector source;

	makevectors(self.v_angle);
	source = self.origin;
	tracebox(source, '-1 -1 -1', '1 1 1', source + v_right *-128, FALSE, self);
	if (trace_fraction == 1)
		self.lefty_dir = 1;
	else
		self.lefty_dir = 0;
};

/*
==============================================================================

FAST ATTACKS

==============================================================================
*/

void() proj_wraith_explo = 
{
	self.alpha -= 0.1;
	self.frame += 1;
	if (self.alpha < 0)
		self.think = SUB_Remove;
	else
		self.think = proj_wraith_explo;
	self.nextthink = time + 0.05;
}
void() WraithProjectileTouch = 
{
	local float damg;
	if (other == self.owner)
		return;	// don't explode on owner
	if(other.solid == SOLID_TRIGGER)
	return;

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop sound
		return;
	}
	self.solid = SOLID_NOT;
	damg = wraith_damage;
	if (other.health)
	{
		if (other.classname == "monster_oppressor")
			damg = damg *0.25;	// mostly immune
		T_Damage(other, self, self.owner, damg);
	}
	else
	{
		T_RadiusDamage(self, self.owner, damg, world);
	}
	pointparticles(particleeffectnum("wraith_fire_impact"), self.origin, v_forward *(-550), 1);
	setmodel(self, "models/projectiles/proj_wraith_explo.md3");
	sound (self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);	// stop loop sound
	randomsound2("enemies/wraith/proj_impact", 3, 1, CHAN_AUTO, 0, 0.25);
	pointparticles(particleeffectnum("proj_wraith_impact"), self.origin, '0 0 0', 1);
	self.movetype = 0;
	self.alpha = 1;
	self.touch = SUB_Null;
	self.nextthink = time;
	self.think = proj_wraith_explo;

};
void() wraith_StartFast = 
{
	local entity missile;

	self.v_angle = self.angles;
	makevectors2(self.angles);

	local vector tagorg;
	local float tagindex;
	local string tagname;
	tagname = "tag_muzzle";
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	missile = spawn();
	missile.owner = self;
	missile.classentity = "projectiles";
	missile.wrathflags += FL_PROJECTILE;

	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_CORPSE;
	missile.traileffectnum = particleeffectnum("wraithtrail2");
	local vector sre;
	sre = self.angles;
	makevectors2(sre);
	missile.velocity = normalize(self.enemy.origin - tagorg);
	missile.velocity = missile.velocity * 1200;
	missile.angles = vectoangles(missile.velocity);
	local entity oself;oself = self;self = missile;
	randomsound2("enemies/wraith/proj_loop", 3, 1, CHAN_WEAPON, 0, 0.25);
	self = oself;
	missile.touch = WraithProjectileTouch;
	missile.nextthink = time;
	missile.think = slagdrunk;
	missile.modelflags = EF_NOMODELFLAGS;	// smoke rocket dp-extension
	setmodel(missile, "models/projectiles/proj_wraith.md3");
	setsizeitem(missile, '0 0 0');

	setorigin(missile, tagorg);
};

void() wraith_idlesound = 
{
	local float wr;
	wr = random() *5;

	if (self.waitmin < time)
	{
		self.waitmin = time + 2;
		if (wr > 4.5)
			sound(self, CHAN_VOICE, "enemies/wraith/sight1.ogg", 1, ATTN_IDLE);

		if (wr < 1.5)
			sound(self, CHAN_VOICE, "enemies/wraith/sight2.ogg", 1, ATTN_IDLE);
	}
	return;
};

void() wraith_stand1 =[$hover1, wraith_stand2]
{
	ai_stand();
	self.glowmod = '0.5 0.5 0.5';

	if ((self.sight_time < time) && !(self.spawnflags &1))
	{
		local float r;
		r = random();
		if (r > 0.5)
			chattersound("enemies/wraith/chatter", 5, 1);
		self.sight_time = time + 7.5;
	}
};
void() wraith_stand2 =[$hover2, wraith_stand3]
{
	ai_stand();
};
void() wraith_stand3 =[$hover3, wraith_stand4]
{
	ai_stand();
};
void() wraith_stand4 =[$hover4, wraith_stand5]
{
	ai_stand();
};
void() wraith_stand5 =[$hover5, wraith_stand6]
{
	ai_stand();
};
void() wraith_stand6 =[$hover6, wraith_stand7]
{
	ai_stand();
};
void() wraith_stand7 =[$hover7, wraith_stand8]
{
	ai_stand();
};
void() wraith_stand8 =[$hover8, wraith_stand9]
{
	ai_stand();
};
void() wraith_stand9 =[$hover9, wraith_stand10]
{
	ai_stand();
};
void() wraith_stand10 =[$hover10, wraith_stand1]
{
	ai_stand();
};

void() wraith_walk1 =[$hover1, wraith_walk2]
{
	ai_walk(8);
	self.glowmod = '0.5 0.5 0.5';
	if (self.sight_time < time)
	{
		local float r;
		r = random();
		if (r > 0.5)
			chattersound("enemies/wraith/chatter", 5, 1);
		self.sight_time = time + 7.5;
	}
};
void() wraith_walk2 =[$hover2, wraith_walk3]
{
	ai_walk(8);
};
void() wraith_walk3 =[$hover3, wraith_walk4]
{
	ai_walk(8);
};
void() wraith_walk4 =[$hover4, wraith_walk5]
{
	ai_walk(8);
};
void() wraith_walk5 =[$hover5, wraith_walk6]
{
	ai_walk(8);
};
void() wraith_walk6 =[$hover6, wraith_walk7]
{
	ai_walk(8);
};
void() wraith_walk7 =[$hover7, wraith_walk8]
{
	ai_walk(8);
};
void() wraith_walk8 =[$hover8, wraith_walk9]
{
	ai_walk(8);
};
void() wraith_walk9 =[$hover9, wraith_walk10]
{
	ai_walk(8);
};
void() wraith_walk10 =[$hover10, wraith_walk1]
{
	ai_walk(8);
};

void() wraith_lside9;
void() wraith_rside9;

void(float f) wraith_check_sidewall = 
{
	if ((test_side_wall(f)))
	{
		self.attack_state = AS_MISSILE;
		self.think = wraith_fast1;
		self.nextthink = time;
	}
};

void() wraith_rside1 =[$wfr1, wraith_rside2]
{
	wraith_idlesound();
	self.glowmod = '0.5 0.5 0.5';
	wraith_check_sidewall(1);
	ai_run(2);
};
void() wraith_rside2 =[$wfr2, wraith_rside3]
{
	wraith_check_sidewall(1);
	ai_run(8);
};
void() wraith_rside3 =[$wfr3, wraith_rside4]
{
	wraith_check_sidewall(1);
	ai_run(16);
};
void() wraith_rside4 =[$wfr3, wraith_rside5]
{
	wraith_check_sidewall(1);
	ai_run(24);
};
void() wraith_rside5 =[$wfr3, wraith_rside8]
{
	wraith_check_sidewall(1);
	ai_run(24);
};
void() wraith_rside8 =[$wfr3, wraith_rside9]
{
	wraith_check_sidewall(1);
	ai_run(16);
};
void() wraith_rside9 =[$wfr2, wraith_rside10]
{
	wraith_check_sidewall(1);
	ai_run(8);
};
void() wraith_rside10 =[$wfr1, wraithCheckDistance]
{
	ai_run(4);
};

void() wraith_lside1 =[$wfl1, wraith_lside2]
{
	wraith_idlesound();
	self.glowmod = '0.5 0.5 0.5';
	wraith_check_sidewall(0);
	ai_run(2);
};
void() wraith_lside2 =[$wfl2, wraith_lside3]
{
	wraith_check_sidewall(0);
	ai_run(8);
};
void() wraith_lside3 =[$wfl3, wraith_lside4]
{
	wraith_check_sidewall(0);
	ai_run(16);
};
void() wraith_lside4 =[$wfl3, wraith_lside5]
{
	wraith_check_sidewall(0);
	ai_run(24);
};
void() wraith_lside5 =[$wfl3, wraith_lside8]
{
	wraith_check_sidewall(0);
	ai_run(24);
};
void() wraith_lside8 =[$wfl3, wraith_lside9]
{
	wraith_check_sidewall(0);
	ai_run(16);
};
void() wraith_lside9 =[$wfl2, wraith_lside10]
{
	wraith_check_sidewall(0);
	ai_run(8);
};
void() wraith_lside10 =[$wfl1, wraithCheckDistance]
{
	ai_run(4);
};

void() wraith_side1 = 
{
	local vector source;
	local float r;
	makevectors(self.v_angle);
	source = self.origin;
	traceline(source, source + v_right *128, FALSE, self);
	if (trace_fraction == 1)
		self.righty_dir = 1;
	traceline(source, source + v_right *-128, FALSE, self);
	if (trace_fraction == 1)
		self.lefty_dir = 1;

	if (self.strafetime > time)
		wraith_StartFast();

	if (self.righty_dir == 1)
	{

		if (self.lefty_dir == 1)
		{
			r = rint(random() *1);
			self.lefty = r;
		}
		else
			self.lefty = 0;
	}
	else
	{
		if (self.lefty_dir == 1)
			self.lefty = 1;
		else
		{
			r = random();
			if (r < 0.5)
				self.think = wraith_run1b;
			else
				self.think = wraith_fast1;
			self.nextthink = time + 0.025;
			return;
		}
	}

	r = rint(random() *1);
	self.lefty = r;

	if (self.lefty)
		self.think = wraith_lside1;
	else
		self.think = wraith_rside1;

	ai_run(1);
	self.nextthink = time + 0.025;
};

void() wraith_run1b =[$hover1, wraith_run2]
{
	ai_run(16);
	wraith_idlesound();
	self.glowmod = '0.5 0.5 0.5';
};
void() wraith_run2 =[$hover2, wraith_run3]
{
	ai_runwalk(18);
};
void() wraith_run3 =[$hover3, wraith_run4]
{
	ai_runwalk(20);
};
void() wraith_run4 =[$hover4, wraith_run5]
{
	ai_runwalk(24);
};
void() wraith_run5 =[$hover5, wraith_run6]
{
	ai_run(20);
};
void() wraith_run6 =[$hover6, wraith_run7]
{
	ai_runwalk(18);
};
void() wraith_run7 =[$hover7, wraith_run8]
{
	ai_runwalk(16);
};
void() wraith_run8 =[$hover8, wraith_run9]
{
	ai_run(12);
};
void() wraith_run9 =[$hover9, wraith_run10]
{
	ai_runwalk(16);
};
void() wraith_run10 =[$hover10, wraith_run1]
{
	ai_runwalk(16);
};

void() wraith_fast1 =[$magatt1, wraith_fast2]
{
	ai_face();
	self.glowmod = '0.6 0.6 0.6';
};
void() wraith_fast2 =[$magatt2, wraith_fast3]
{
	ai_face();
	self.glowmod = '0.7 0.7 0.7';
};
void() wraith_fast3 =[$magatt3, wraith_fast4]
{
	ai_face();
	self.glowmod = '0.8 0.8 0.8';
};
void() wraith_fast4 =[$magatt4, wraith_fast5]
{
	ai_face();
	self.glowmod = '0.9 0.9 0.9';
};
void() wraith_fast5 =[$magatt5, wraith_fast6]
{
	ai_face();
	self.glowmod = '1 1 1';
};
void() wraith_fast6 =[$magatt6, wraith_fast7]
{
	ai_face();
	self.glowmod = '1.25 1.25 1.25';
};
void() wraith_fast7 =[$magatt7, wraith_fast8]
{
	ai_face();
	self.glowmod = '1.5 1.5 1.5';
};
void() wraith_fast8 =[$magatt8, wraith_fast9]
{
	ai_face();
	//local float nparticles;
	//nparticles = particleeffectnum("wraith_fire");
	//pointparticles (nparticles, self.origin, '0 0 0', 1); 
	attacksound("enemies/wraith/attack");
	wraith_StartFast();
	self.glowmod = '1.25 1.25 1.25';
};
void() wraith_fast9 =[$magatt9, wraith_fast10]
{
	ai_face();
	
	
		if( (self.enemy) &&(self.enemy.health < 0))
		{
		self.nextenemy_time = 0;
		next_enemy();
		self.think = wraith_run1;
		return;
		}
		
	if (random() < 0.3)
		wraith_StartFast();
	self.glowmod = '0.8 0.8 0.8';
};
void() wraith_fast10 =[$magatt10, wraith_run1]
{
	ai_face();
	SUB_AttackFinished(2);


	

	self.think = wraithAttackFinished;
	self.glowmod = '0.6 0.6 0.6';

};

void() wraith_pain1 =[$pain1, wraith_pain2]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() wraith_pain2 =[$pain2, wraith_pain3]
{
	self.glowmod = '0.3 0.3 0.3';
};
void() wraith_pain3 =[$pain3, wraith_pain4]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() wraith_pain4 =[$pain4, wraith_pain5] {};
void() wraith_pain5 =[$pain5, wraith_pain6] {};
void() wraith_pain6 =[$pain6, wraith_pain7]
{
	self.glowmod = '0.25 0.25 0.25';
};
void() wraith_pain7 =[$pain7, wraith_pain8]
{
	self.glowmod = '0.3 0.3 0.3';
};
void() wraith_pain8 =[$pain8, wraith_pain9]
{
	self.glowmod = '0.35 0.35 0.35';
};
void() wraith_pain9 =[$pain9, wraith_pain10]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() wraith_pain10 =[$pain10, wraith_run1]
{
	self.glowmod = '0.45 0.45 0.45';
};

void() wraith_paina1 =[$paina1, wraith_paina2]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() wraith_paina2 =[$paina2, wraith_paina3]
{
	self.glowmod = '0.3 0.3 0.3';
};
void() wraith_paina3 =[$paina3, wraith_paina4]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() wraith_paina4 =[$paina4, wraith_paina5] {};
void() wraith_paina5 =[$paina5, wraith_paina6] {};
void() wraith_paina6 =[$paina6, wraith_paina7]
{
	self.glowmod = '0.25 0.25 0.25';
};
void() wraith_paina7 =[$paina7, wraith_paina8]
{
	self.glowmod = '0.3 0.3 0.3';
};
void() wraith_paina8 =[$paina8, wraith_paina9]
{
	self.glowmod = '0.35 0.35 0.35';
};
void() wraith_paina9 =[$paina9, wraith_paina10]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() wraith_paina10 =[$paina10, wraith_run1]
{
	self.glowmod = '0.45 0.45 0.45';
};

void() wraith_painc1 =[$painc1, wraith_painc2]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() wraith_painc2 =[$painc2, wraith_painc3]
{
	self.glowmod = '0.3 0.3 0.3';
};
void() wraith_painc3 =[$painc3, wraith_painc4]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() wraith_painc4 =[$painc4, wraith_painc5] {};
void() wraith_painc5 =[$painc5, wraith_painc6] {};
void() wraith_painc6 =[$painc6, wraith_painc7]
{
	self.glowmod = '0.25 0.25 0.25';
};
void() wraith_painc7 =[$painc7, wraith_painc8]
{
	self.glowmod = '0.3 0.3 0.3';
};
void() wraith_painc8 =[$painc8, wraith_painc9]
{
	self.glowmod = '0.35 0.35 0.35';
};
void() wraith_painc9 =[$painc9, wraith_painc10]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() wraith_painc10 =[$painc10, wraith_run1]
{
	self.glowmod = '0.45 0.45 0.45';
};

void() wraith_death1 =[$death1, wraith_death2]
{
	self.solid = SOLID_NOT;
	self.takedamage = 0;
	self.nextthink = time + 0.05;
	self.velocity_x = -200 + 400* random();
	self.velocity_y = -200 + 400* random();
	self.velocity_z = 100 + 100* random();
	self.flags = self.flags - (self.flags &FL_ONGROUND);
};

void() bloodgib_think = 
{
	self.skin += 1;

	if (self.skin >= 9)
		self.think = SUB_Remove;
	else
		self.think = bloodgib_think;
	self.nextthink = time + 0.05;
};

void() wraith_death2 =[$death2, SUB_Null]
{

	local vector tagorg;
	local float tagindex;
	local string tagname;
	tagname = ("tag_muzzle");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	local entity bloodgib;
	bloodgib = spawn();
	bloodgib.alpha = 0.7;
	//		bloodgib.skin =  (ceil (random() *4)) *5;
	bloodgib.origin = tagorg;
	setmodel(bloodgib, "particles/explo/explo_blood4.md3");
	bloodgib.think = bloodgib_think;
	bloodgib.nextthink = time + 0.05;
	local float nparticles;
	nparticles = particleeffectnum("wraith_gib");
	pointparticles(nparticles, self.origin, '0 0 0', 1);
	//sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
	tagname = ("tag_arm1");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_arm1.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('0 120 90', self), 0, 0);
	tagname = ("tag_arm2");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_arm2.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('0 -120 90', self), 0, 0);
	tagname = ("tag_arm3");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_arm3.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('0 60 70', self), 0, 0);
	tagname = ("tag_arm4");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_arm4.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('0 -60 70', self), 0, 0);
	tagname = ("tag_tail1");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_tail1.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-50 -30 0', self), 1, 0);
	tagname = ("tag_tail2");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_tail2.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 20 0', self), 1, 0);
	tagname = ("tag_head");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('220 0 0', self), 0, 1);
	tagname = ("tag_back1");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_back1.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('0 -60 170', self), 0, 0);
	tagname = ("tag_back2");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_back2.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('0 60 180', self), 0, 0);
	tagname = ("tag_back3");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/wraith/wraith_back3.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-120 0 0', self), 0, 0);
	remove(self);
};

void() wraith_die = {	// check for gib
	self.solid = SOLID_NOT;
	self.takedamage = 0;
	painsound("enemies/wraith/die");
	wraith_death1();
};

void() random_wraithpain = 
{
	local float r;
	r = random();
	self.nextthink = time;
	self.sustained_damage = 0;
	if (r < 0.33)
	{
		self.think = wraith_pain1;
		return;
	}
	else if (r < 0.66)
	{
		self.think = wraith_paina1;
		return;
	}
	else
	{
		self.think = wraith_painc1;
		return;
	}
};

void(entity attacker, float damage) wraith_pain = 
{
	
	if ((damage < 20) && (attacker.weapon != IT_BOIL))
		return;	// didn't flinch
	painsound("enemies/wraith/pain");

	self.think = random_wraithpain;
	self.nextthink = time;
};

void() wraith_Missile = 
{
	wraith_fast1();
};

/*
	WRATHED monster_wraith (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() precache_monster_wraith = 
{
	precache_model("models/enemies/wraith/wraith_tail2.md3");
	precache_model("models/enemies/wraith/wraith_tail1.md3");
	precache_model("models/enemies/wraith/wraith_head.md3");
	precache_model("models/enemies/wraith/wraith_back3.md3");
	precache_model("models/enemies/wraith/wraith_back2.md3");
	precache_model("models/enemies/wraith/wraith_back1.md3");
	precache_model("models/enemies/wraith/wraith_arm4.md3");
	precache_model("models/enemies/wraith/wraith_arm3.md3");
	precache_model("models/enemies/wraith/wraith_arm2.md3");
	precache_model("models/enemies/wraith/wraith_arm1.md3");
	precache_model("models/enemies/wraith/wraith.md3");
	precache_model("models/projectiles/proj_wraith.md3");
	precache_model("models/projectiles/proj_wraith_explo.md3");

	precache_model("models/misc/null.md3");

	precache_sound("enemies/wraith/attack1.ogg");
	precache_sound("enemies/wraith/attack2.ogg");
	precache_sound("enemies/wraith/attack3.ogg");
	precache_sound("enemies/wraith/chatter1.ogg");
	precache_sound("enemies/wraith/chatter2.ogg");
	precache_sound("enemies/wraith/chatter3.ogg");
	precache_sound("enemies/wraith/chatter4.ogg");
	precache_sound("enemies/wraith/chatter5.ogg");
	precache_sound("enemies/wraith/die1.ogg");
	precache_sound("enemies/wraith/die2.ogg");
	precache_sound("enemies/wraith/die3.ogg");
	precache_sound("enemies/wraith/pain1.ogg");
	precache_sound("enemies/wraith/pain2.ogg");
	precache_sound("enemies/wraith/pain3.ogg");
	precache_sound("enemies/wraith/proj_impact1.ogg");
	precache_sound("enemies/wraith/proj_impact2.ogg");
	precache_sound("enemies/wraith/proj_impact3.ogg");
	precache_sound("enemies/wraith/proj_loop1.ogg");
	precache_sound("enemies/wraith/proj_loop2.ogg");
	precache_sound("enemies/wraith/proj_loop3.ogg");
	precache_sound("enemies/wraith/sight1.ogg");
	precache_sound("enemies/wraith/sight2.ogg");
	precache_sound("enemies/wraith/sight3.ogg");
};

void() monster_wraith = 
{
	precache_model("models/enemies/wraith/wraith_tail2.md3");
	precache_model("models/enemies/wraith/wraith_tail1.md3");
	precache_model("models/enemies/wraith/wraith_head.md3");
	precache_model("models/enemies/wraith/wraith_back3.md3");
	precache_model("models/enemies/wraith/wraith_back2.md3");
	precache_model("models/enemies/wraith/wraith_back1.md3");
	precache_model("models/enemies/wraith/wraith_arm4.md3");
	precache_model("models/enemies/wraith/wraith_arm3.md3");
	precache_model("models/enemies/wraith/wraith_arm2.md3");
	precache_model("models/enemies/wraith/wraith_arm1.md3");
	precache_model("models/enemies/wraith/wraith.md3");
	precache_model("models/misc/null.md3");

	precache_sound("enemies/wraith/attack1.ogg");
	precache_sound("enemies/wraith/attack2.ogg");
	precache_sound("enemies/wraith/attack3.ogg");
	precache_sound("enemies/wraith/chatter1.ogg");
	precache_sound("enemies/wraith/chatter2.ogg");
	precache_sound("enemies/wraith/chatter3.ogg");
	precache_sound("enemies/wraith/chatter4.ogg");
	precache_sound("enemies/wraith/chatter5.ogg");
	precache_sound("enemies/wraith/die1.ogg");
	precache_sound("enemies/wraith/die2.ogg");
	precache_sound("enemies/wraith/die3.ogg");
	precache_sound("enemies/wraith/pain1.ogg");
	precache_sound("enemies/wraith/pain2.ogg");
	precache_sound("enemies/wraith/pain3.ogg");
	precache_sound("enemies/wraith/proj_impact1.ogg");
	precache_sound("enemies/wraith/proj_impact2.ogg");
	precache_sound("enemies/wraith/proj_impact3.ogg");
	precache_sound("enemies/wraith/proj_loop1.ogg");
	precache_sound("enemies/wraith/proj_loop2.ogg");
	precache_sound("enemies/wraith/proj_loop3.ogg");
	precache_sound("enemies/wraith/sight1.ogg");
	precache_sound("enemies/wraith/sight2.ogg");
	precache_sound("enemies/wraith/sight3.ogg");

	self.solid = SOLID_SLIDEBOX;
	self.flyer = 1;
	self.movetype = MOVETYPE_STEP;
	self.classname = "monster_wraith";
	setmodel(self, "models/enemies/wraith/wraith.md3");
	local float r;
	r = (random() *3);
	if (r < 3)
		self.noise = "enemies/wraith/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/wraith/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/wraith/sight1.ogg";
	self.gravity = -0.01;

	setsize(self, '-16 -16 -32', '16 16 32');
	self.health = wraith_health;
	self.max_health = wraith_health;
	self.glowmod = '0.5 0.5 0.5';
	self.th_stand = wraith_stand1;
	self.bloody = 1;
	self.th_walk = wraith_walk1;
	self.th_run = wraith_run1;
	self.th_missile = wraith_Missile;
	self.th_pain = wraith_pain;
	self.th_die = wraith_die;

	flymonster_start();
};