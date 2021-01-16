/*
==============================================================================
fallen CODE
==============================================================================
*/

$frame fn_pose
$frame fn_idle1 fn_idle2 fn_idle3 fn_idle4 fn_idle5 fn_idle6 fn_idle7 fn_idle8 fn_idle9 fn_idle10
$frame fn_walk1 fn_walk2 fn_walk3 fn_walk4 fn_walk5 fn_walk6 fn_walk7 fn_walk8 fn_walk9 fn_walk10
$frame fn_walk11 fn_walk12 fn_walk13 fn_walk14 fn_walk15 fn_walk16 fn_walk17 fn_walk18 fn_walk19 fn_walk20
$frame fn_attacka1 fn_attacka2 fn_attacka3 fn_attacka4 fn_attacka5 fn_attacka6 fn_attacka7 fn_attacka8 fn_attacka9 fn_attacka10
$frame fn_attackb1 fn_attackb2 fn_attackb3 fn_attackb4 fn_attackb5 fn_attackb6 fn_attackb7 fn_attackb8 fn_attackb9 fn_attackb10
$frame fn_mutilatea1 fn_mutilatea2 fn_mutilatea3 fn_mutilatea4 fn_mutilatea5 fn_mutilatea6 fn_mutilatea7 fn_mutilatea8 fn_mutilatea9 fn_mutilatea10
$frame fn_mutilateb1 fn_mutilateb2 fn_mutilateb3 fn_mutilateb4 fn_mutilateb5 fn_mutilateb6 fn_mutilateb7 fn_mutilateb8 fn_mutilateb9 fn_mutilateb10
$frame fn_mutilatec1 fn_mutilatec2 fn_mutilatec3 fn_mutilatec4 fn_mutilatec5 fn_mutilatec6 fn_mutilatec7 fn_mutilatec8 fn_mutilatec9 fn_mutilatec10
$frame fn_mutilated1 fn_mutilated2 fn_mutilated3 fn_mutilated4 fn_mutilated5 fn_mutilated6 fn_mutilated7 fn_mutilated8 fn_mutilated9 fn_mutilated10
$frame fn_mutilated11 fn_mutilated12 fn_mutilated13 fn_mutilated14 fn_mutilated15 fn_mutilated16 fn_mutilated17 fn_mutilated18 fn_mutilated19 fn_mutilated20
$frame fn_paina1 fn_paina2 fn_paina3 fn_paina4 fn_paina5
$frame fn_painb1 fn_painb2 fn_painb3 fn_painb4 fn_painb5
$frame fn_painc1 fn_painc2 fn_painc3 fn_painc4 fn_painc5
$frame cr_walk1 cr_walk2 cr_walk3 cr_walk4 cr_walk5 cr_walk6 cr_walk7 cr_walk8
$frame cr_fall1 cr_fall2 cr_fall3 cr_fall4 cr_fall5 cr_fall6 cr_fall7 cr_fall9 cr_fall10 cr_fall11 cr_fall12 cr_fall14

void() fallen_run1;
void() fallen_run;
void() fallen_check = 
{
	ai_stand();
	//if (visibleinfront(self.enemy, 768))
	//self.think = fallen_run1;
};

void() fallen_touch = 
{
	if (other.classname != "monster_fallen")
		return;

	self.timeroaming = time + 5;
	other.timeroaming = time + 5;

}

void() fallen_stand1 =[$fn_idle1, fallen_stand2]
{
	ai_stand();

	if ((self.idle_time < time) && !(self.spawnflags &1))
	{
		chattersound("enemies/fallen/idle", 3, 0.5);
		self.idle_time = time + 4;
	}
};
void() fallen_stand2 =[$fn_idle2, fallen_stand3]
{
	fallen_check();
};
void() fallen_stand3 =[$fn_idle3, fallen_stand4]
{
	fallen_check();
};
void() fallen_stand4 =[$fn_idle4, fallen_stand5]
{
	fallen_check();
};
void() fallen_stand5 =[$fn_idle5, fallen_stand6]
{
	fallen_check();
};
void() fallen_stand6 =[$fn_idle6, fallen_stand7]
{
	fallen_check();
};
void() fallen_stand7 =[$fn_idle7, fallen_stand8]
{
	fallen_check();
};
void() fallen_stand8 =[$fn_idle8, fallen_stand9]
{
	fallen_check();
};
void() fallen_stand9 =[$fn_idle9, fallen_stand10]
{
	fallen_check();
};
void() fallen_stand10 =[$fn_idle10, fallen_stand1]
{
	fallen_check();
};

void(float exdmg, float range) fallen_attack = 
{
	local vector delta;
	local float dist;
	if (self.enemy.crouch == 1)
		range += 32;

	if (!self.enemy)
		return;	// removed before stroke
	delta = (self.enemy.origin) - rorigin(self);	// + '0 0 32');
	dist = vlen(delta);

	if (exdmg != 0)
	{
		if (dist < range)
		{
			makevectors(self.v_angle);
			local vector source, org;
			source = rorigin(self) + '0 0 16';
			traceline(source, self.enemy.origin, FALSE, self);
			if (trace_fraction != 1.0)
			{
				org = trace_endpos - v_forward * 4;
				if ((trace_ent.takedamage))
				{
					//				trace_ent.axhitme = 1;
					T_Damage(trace_ent, self, self, exdmg);
				}
			}
		}
	}
};

.float headless_time;
void() fallen_attack_melee;

void() fallen_run1 =[$fn_walk11, fallen_run2]
{
	ai_runwalk(fn_vwalk1);
	self.randomattacked = 0;
	if (self.skin != 1)
	{
		local float r;
		r = random();
		if ((self.idle_time < time) && (r < 0.25))
		{
			monstersound5("enemies/fallen/chatter", 5, CHAN_VOICE);
			self.idle_time = time + 5 + 5* random();
		}
	}
	else
	{
		if ((self.headless_time < time) && (self.skin == 1))
		{
			sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
			self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
		}
	}
};
void() fallen_run2 =[$fn_walk12, fallen_run3]
{
	ai_runwalk(fn_vwalk2);
};
void() fallen_run3 =[$fn_walk13, fallen_run4]
{
	ai_runwalk(fn_vwalk3);
	monstersound1("enemies/fallen/step", 3, CHAN_BODY);
};
void() fallen_run4 =[$fn_walk14, fallen_run5]
{
	ai_runwalk(fn_vwalk4);
	if ((visible2(self.enemy, 64, 0.3)) && (self.enemy.classname != "path_waypoint")&& (self.enemy.noattack != 1))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};
void() fallen_run5 =[$fn_walk15, fallen_run6]
{
	ai_runwalk(fn_vwalk5);
	if ((self.headless_time < time) && (self.skin == 1))
	{
		sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
		self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
	}
};
void() fallen_run6 =[$fn_walk16, fallen_run7]
{
	ai_runwalk(fn_vwalk6);
};
void() fallen_run7 =[$fn_walk17, fallen_run8]
{
	ai_runwalk(fn_vwalk7);
};
void() fallen_run8 =[$fn_walk18, fallen_run9]
{
	ai_runwalk(fn_vwalk8);
	monstersound1("enemies/fallen/step", 3, CHAN_BODY);
};
void() fallen_run9 =[$fn_walk19, fallen_run10]
{
	ai_runwalk(fn_vwalk9);
};
void() fallen_run10 =[$fn_walk20, fallen_run1]
{
	ai_runwalk(fn_vwalk10);
	if ((visible2(self.enemy, 64, 0.3)) && (self.enemy.classname != "path_waypoint")&& (self.enemy.noattack != 1))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_runb1 =[$fn_walk1, fallen_runb2]
{
	ai_runwalk(fn_vwalk1);

	if ((self.headless_time < time) && (self.skin == 1))
	{
		sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
		self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
	}
};
void() fallen_runb2 =[$fn_walk2, fallen_runb3]
{
	ai_runwalk(fn_vwalk2);
};
void() fallen_runb3 =[$fn_walk3, fallen_runb4]
{
	ai_runwalk(fn_vwalk3);
	monstersound1("enemies/fallen/step", 3, CHAN_BODY);
};
void() fallen_runb4 =[$fn_walk4, fallen_runb5]
{
	ai_runwalk(fn_vwalk4);
	if ((visible2(self.enemy, 64, 0.3)) && (self.enemy.classname != "path_waypoint")&& (self.enemy.noattack != 1))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};
void() fallen_runb5 =[$fn_walk5, fallen_runb6]
{
	ai_runwalk(fn_vwalk5);

	if ((self.headless_time < time) && (self.skin == 1))
	{
		sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
		self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
	}
};
void() fallen_runb6 =[$fn_walk6, fallen_runb7]
{
	ai_runwalk(fn_vwalk6);
};
void() fallen_runb7 =[$fn_walk7, fallen_runb8]
{
	ai_runwalk(fn_vwalk7);
};
void() fallen_runb8 =[$fn_walk8, fallen_runb9]
{
	ai_runwalk(fn_vwalk8);
	monstersound1("enemies/fallen/step", 3, CHAN_BODY);
};
void() fallen_runb9 =[$fn_walk9, fallen_runb10]
{
	ai_runwalk(fn_vwalk9);
};
void() fallen_runb10 =[$fn_walk10, fallen_runb1]
{
	ai_runwalk(fn_vwalk10);
	if ((visible2(self.enemy, 64, 0.3)) && (self.enemy.classname != "path_waypoint")&& (self.enemy.noattack != 1))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};



void() fallen_run =
{
	float rrun = random();
	if (rrun > 0.5)
		self.think = fallen_runb1;
	else
		self.think = fallen_run1;
	self.nextthink = time;
}

.float mutilated;

void() fallen_attacka1 =[$fn_attacka1, fallen_attacka2]
{
	ai_face();

	if ((self.headless_time < time) && (self.skin == 1))
	{
		sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
		self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
	}
	else
		monstersound2("enemies/fallen/attack", 3, CHAN_VOICE);
};
void() fallen_attacka2 =[$fn_attacka2, fallen_attacka3]
{
	ai_face();
};
void() fallen_attacka3 =[$fn_attacka3, fallen_attacka4]
{
	ai_face();
	monstersound4("enemies/fallen/swing", 3, CHAN_WEAPON);
};
void() fallen_attacka4 =[$fn_attacka4, fallen_attacka5]
{
	ai_face();
	fallen_attack(10, 64);
};
void() fallen_attacka5 =[$fn_attacka5, fallen_attacka6]
{
	ai_face();
};
void() fallen_attacka6 =[$fn_attacka6, fallen_attacka7]
{
	ai_face();

	if ((self.headless_time < time) && (self.skin == 1))
	{
		sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
		self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
	}
};
void() fallen_attacka7 =[$fn_attacka7, fallen_attacka8]
{
	ai_face();
};
void() fallen_attacka8 =[$fn_attacka8, fallen_attacka9]
{
	ai_face();
};
void() fallen_attacka9 =[$fn_attacka9, fallen_attacka10]
{
	ai_face();
};
void() fallen_attacka10 =[$fn_attacka10, fallen_run]
{
	ai_face();
	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_attackb1 =[$fn_attackb1, fallen_attackb2]
{
	ai_face();
	self.randomattacked = 0;
	if ((self.headless_time < time) && (self.skin == 1))
	{
		sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
		self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
	}
	else
		monstersound2("enemies/fallen/attack", 3, CHAN_VOICE);
};
void() fallen_attackb2 =[$fn_attackb2, fallen_attackb3]
{
	ai_face();
};
void() fallen_attackb3 =[$fn_attackb3, fallen_attackb4]
{
	ai_face();
	monstersound4("enemies/fallen/swing", 3, CHAN_WEAPON);
};
void() fallen_attackb4 =[$fn_attackb4, fallen_attackb5]
{
	ai_face();
	fallen_attack(10, 64);
};
void() fallen_attackb5 =[$fn_attackb5, fallen_attackb6]
{
	ai_face();
};
void() fallen_attackb6 =[$fn_attackb6, fallen_attackb7]
{
	ai_face();
	if ((self.headless_time < time) && (self.skin == 1))
	{
		sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
		self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
	}
};
void() fallen_attackb7 =[$fn_attackb7, fallen_attackb8]
{
	ai_face();
};
void() fallen_attackb8 =[$fn_attackb8, fallen_attackb9]
{
	ai_face();
};
void() fallen_attackb9 =[$fn_attackb9, fallen_attackb10]
{
	ai_face();
};
void() fallen_attackb10 =[$fn_attackb10, fallen_run]
{
	ai_face();
	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_attack_melee = 
{
	ai_face();
	local float r;
	r = random();
	if (r < 0.5)
		self.think = fallen_attacka1;
	else
		self.think = fallen_attackb1;

	if (self.mutilated == 2)
		self.think = fallen_attackb1;

	if (self.mutilated == 3)
		self.think = fallen_attacka1;

	self.nextthink = time;
};

.float f_walk;

void() fallen_walk;

void() fallen_walk1 =[$fn_walk1, fallen_walk2]
{
	ai_walk(fn_vwalk1);
};
void() fallen_walk2 =[$fn_walk2, fallen_walk3]
{
	ai_walk(fn_vwalk2);
};
void() fallen_walk3 =[$fn_walk3, fallen_walk4]
{
	ai_walk(fn_vwalk3);
	monstersound1("enemies/fallen/step", 3, CHAN_BODY);
};
void() fallen_walk4 =[$fn_walk4, fallen_walk5]
{
	ai_walk(fn_vwalk4);
};
void() fallen_walk5 =[$fn_walk5, fallen_walk6]
{
	ai_walk(fn_vwalk5);

	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};
void() fallen_walk6 =[$fn_walk6, fallen_walk7]
{
	ai_walk(fn_vwalk6);
};
void() fallen_walk7 =[$fn_walk7, fallen_walk8]
{
	ai_walk(fn_vwalk7);
};
void() fallen_walk8 =[$fn_walk8, fallen_walk9]
{
	ai_walk(fn_vwalk8);
	monstersound1("enemies/fallen/step", 3, CHAN_BODY);
};
void() fallen_walk9 =[$fn_walk9, fallen_walk10]
{
	ai_walk(fn_vwalk9);
};
void() fallen_walk10 =[$fn_walk10, fallen_walk1]
{
	ai_walk(fn_vwalk10);

	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_walk = 
{
	local float r;
	r = random();

	self.think = fallen_walk1;
	self.nextthink = time;
};

.string particleffect2;
.float gibtimer;
void() gib_prefade =	// avoid gib levitation
	{
		self.gibtimer -= 0.1;

		if (self.velocity == '0 0 0')
		{
			self.velocity_x = random() *5;
			self.velocity_y = random() *5;
			if (self.count != 1)
				self.velocity_z = random() *5;
		}

		if (self.glowmod_x > 1)
			self.think = gibalphafade3;
		else
		{
			if (self.gibtimer <= 0)
			{
				self.velocity = '0 0 0';
				self.think = gibalphafade2;
				self.nextthink = time;
			}
			else
				self.think = gib_prefade;
		}

		self.nextthink = time + 0.1;
	};
void() bleedzthink = 
{
	local float nparticles;
	nparticles = particleeffectnum(self.particleffect2);

	local vector tagorg, dir;
	local float tagindex;
	local string tagname;

	makevectors(self.owner.v_angle);
	tagname = self.tagorg2;
	tagindex = gettagindex(self.owner, tagname);
	tagorg = gettaginfo(self.owner, tagindex);
	pointparticles(nparticles, tagorg, '0 0 0', 1);

	if (!self.armcount)
	{
		local entity arm;
		arm = spawn();
		arm.glowmod = self.glowmod;
		arm.model = self.model2;
		setmodel(arm, arm.model);
		arm.wrathflags += FL_GIB;	
		arm.origin = tagorg;
		arm.angles = self.owner.angles;
		arm.alpha = 1;
		dir = relvel(self.oldvelocity, self.owner);
		local float vel_h;
		arm.glowmod = '1 1 1';
		vel_h = 1;	//(self.owner.health *-0.015) + 0.25;

		arm.velocity_x = dir_x * vel_h;
		arm.velocity_y = dir_y * vel_h;
		arm.velocity_z = dir_z *(vel_h);
		local entity pl;
		pl = self.owner.enemy;
		if ((pl.classname == "player") && (pl.lungetime > time))
		{
			makevectors(pl.v_angle);
			arm.velocity_x = arm.velocity_x *0.25;
			arm.velocity_y = arm.velocity_y *0.25;
			arm.velocity_z = arm.velocity_z *1.25;
			arm.velocity += pl.velocity *0.5;

		}

		arm.traileffectnum = particleeffectnum("generictrailgib");
		if (self.oldvelocity_z != 50)
			arm.avelocity_y = random() *arm.velocity_y *5 + arm.velocity_y* crandom();

		setsize(arm, '0 0 0', '0 0 0');
		arm.movetype = MOVETYPE_BOUNCE;
		arm.solid = SOLID_CORPSE;
		arm.gibtimer = 10 + floor(random() *10);
		arm.touch = gib_touch;
		//arm.think = gib_prefade;
		//arm.nextthink = time + random() *0.5;

		arm.think = checking_ground;
		arm.nextthink = time + 0.1;
		self.armcount = 1;
		//chattersound("impact/gibs/gib_hit",5,1);
	}

	if (self.owner.cnt >= 100)
		self.think = SUB_Remove;
	else
		self.think = bleedzthink;
	self.nextthink = time + 0.05;
};

void(string location, string gibmodel, string bleffect, vector vel, entity gwner, float bscale, string addeffect) spawn_gib_stuff = 
{
	if (!(vel == '0 0 0'))
	{
		local entity bleed;
		bleed = spawn();
		bleed.owner = gwner;
		setmodel(bleed, "models/misc/null.md3");
		bleed.model2 = gibmodel;
		if (bscale == 0.55)
		{
			bscale = 0.5;
			bleed.glowmod = '1.1 1.1 1.1';
		}

		bleed.particleffect = bleffect;
		bleed.particleffect2 = addeffect;
		bleed.effects = EF_NODRAW;
		bleed.tagorg2 = location;
		bleed.oldvelocity = vel;
		setsize(bleed, '0 0 0', '0 0 0');
		bleed.cnt = 1;
		setattachment(bleed, gwner, location);
		bleed.think = bleedzthink;
		bleed.nextthink = time;
	}

	if (bscale > 0)
	{
		local entity exp_blood;
		exp_blood = spawn();
		local vector tagorg;
		local float tagindex;
		local string tagname;
		tagname = location;
		tagindex = gettagindex(gwner, tagname);
		tagorg = gettaginfo(gwner, tagindex);
		setorigin(exp_blood, tagorg);
		//exp_blood.origin = tagorg;
		exp_blood.scale = bscale;
		/*if(bscale == 1)
		self.frame = 0;
		if(bscale == 0.5)
		self.frame = 1;
		if(bscale == 0.25)
		self.frame = 2;
		*/

		setmodel(exp_blood, "particles/explo/explo_blood1.md3");
		exp_blood.solid = SOLID_NOT;
		local float skinn;
		skinn = ceil(random() *4);
		if (skinn == 4)
			skinn = 0;
		exp_blood.skin = skinn * 10;
		setsize(exp_blood, '0 0 0', '0 0 0');
		exp_blood.think = cys_explode1b;
		//exp_blood.scale = bscale;
		exp_blood.nextthink = time + 0.05;
		local float nparticles;
		nparticles = particleeffectnum(bleffect);
		pointparticles(nparticles, tagorg, '0 0 0', 12);

	}
};

void() fallen_remove = 
{
	self.cnt = 100;
	self.think = SUB_Remove;
	self.nextthink = time + 0.5;
};
.float oldmutilated;
void() fallen_deathb =[$fn_mutilated1, fallen_deathb2]
{
	self.oldmutilated = self.mutilated;
	self.mutilated = 4;
	self.skin = 4;
	self.count = 1;
	self.cnt = 100;
	//setsize (self, '0 0 0', '0 0 0');
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;

	sound(self, CHAN_VOICE, "enemies/fallen/collapse.ogg", 1, 0.25);
	{
		self.frame = $fn_mutilated1;
		self.skin = 4;
		spawn_gib_stuff("tag_torso", "models/enemies/fallen/gibs/gib_torso_a.md3", "fallen_blood_shower_large", '-40 50 10', self, 0.5, "null");
		spawn_gib_stuff("tag_torso", "models/enemies/fallen/gibs/gib_torso_b.md3", "fallen_blood_shower_large", '40 -50 10', self, 0.5, "null");	//0.5
		local vector tagorg;
		local float tagindex;
		local string tagname;
		tagname = ("tag_head");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);

		if (!self.oldmutilated)
		{
			spawn_gib_stuff("tag_head", "models/misc/null.md3", "fallen_blood_shower_small", '50 0 100', self, 0.55, "null");	//0.5
			ThrowGib2("models/enemies/fallen/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 0 100', self), 0, 1);

			spawn_gib_stuff("tag_arm_a_r", "models/enemies/fallen/gibs/gib_arm_a_r.md3", "fallen_blood_shower_small", '-60 80 40', self, 0.25, "null");	//0.25
			spawn_gib_stuff("tag_arm_b_r", "models/enemies/fallen/gibs/gib_arm_b_r.md3", "fallen_blood_shower_small", '80 60 40', self, 0.25, "null");	//0.25
			spawn_gib_stuff("tag_arm_a_l", "models/enemies/fallen/gibs/gib_arm_a_l.md3", "fallen_blood_shower_small", '60 -80 40', self, 0.25, "null");	//0.25
			spawn_gib_stuff("tag_arm_b_l", "models/enemies/fallen/gibs/gib_arm_b_l.md3", "fallen_blood_shower_small", '-80 -60 40', self, 0.25, "null");	//0.25
		}

		if (self.oldmutilated == 1)
		{
			spawn_gib_stuff("tag_arm_a_r", "models/enemies/fallen/gibs/gib_arm_a_r.md3", "fallen_blood_shower_small", '-60 80 40', self, 0.25, "null");	//0.25
			spawn_gib_stuff("tag_arm_b_r", "models/enemies/fallen/gibs/gib_arm_b_r.md3", "fallen_blood_shower_small", '80 60 40', self, 0.25, "null");	//0.25
			spawn_gib_stuff("tag_arm_a_l", "models/enemies/fallen/gibs/gib_arm_a_l.md3", "fallen_blood_shower_small", '60 -80 40', self, 0.25, "null");	//0.25
			spawn_gib_stuff("tag_arm_b_l", "models/enemies/fallen/gibs/gib_arm_b_l.md3", "fallen_blood_shower_small", '-80 -60 40', self, 0.25, "null");	//0.25
		}

		if (self.oldmutilated == 2)
		{
			spawn_gib_stuff("tag_head", "models/misc/null.md3", "fallen_blood_shower_small", '50 0 100', self, 0.55, "null");	//0.5
			ThrowGib2("models/enemies/fallen/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 0 100', self), 0, 1);

			spawn_gib_stuff("tag_arm_a_l", "models/enemies/fallen/gibs/gib_arm_a_l.md3", "fallen_blood_shower_small", '60 -80 40', self, 0.25, "null");	//0.25
			spawn_gib_stuff("tag_arm_b_l", "models/enemies/fallen/gibs/gib_arm_b_l.md3", "fallen_blood_shower_small", '-80 -60 40', self, 0.25, "null");	//0.25
		}

		if (self.oldmutilated == 3)
		{
			spawn_gib_stuff("tag_head", "models/misc/null.md3", "fallen_blood_shower_small", '50 0 100', self, 0.55, "null");	//0.5
			ThrowGib2("models/enemies/fallen/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 0 100', self), 0, 1);

			spawn_gib_stuff("tag_arm_a_r", "models/enemies/fallen/gibs/gib_arm_a_r.md3", "fallen_blood_shower_small", '-60 80 40', self, 0.25, "null");	//0.25
			spawn_gib_stuff("tag_arm_b_r", "models/enemies/fallen/gibs/gib_arm_b_r.md3", "fallen_blood_shower_small", '80 60 40', self, 0.25, "null");	//0.25
		}
	}
};
void() fallen_deathb2 =[$fn_mutilated2, fallen_deathb3]
{
	self.cnt = 1;
	spawn_gib_stuff("tag_waist", "", "fallen_blood_shower_small", '10 0 0', self, 0.25, "fallen_blood_spurt_waist");	//0.25

};
void() fallen_deathb3 =[$fn_mutilated3, fallen_deathb4] {};
void() fallen_deathb4 =[$fn_mutilated4, fallen_deathb5] {};
void() fallen_deathb5 =[$fn_mutilated5, fallen_deathb6] {};
void() fallen_deathb6 =[$fn_mutilated6, fallen_deathb7] {};
void() fallen_deathb7 =[$fn_mutilated7, fallen_deathb8] {};
void() fallen_deathb8 =[$fn_mutilated8, fallen_deathb9] {};
void() fallen_deathb9 =[$fn_mutilated9, fallen_deathb10] {};
void() fallen_deathb10 =[$fn_mutilated10, fallen_deathb11] {};
void() fallen_deathb11 =[$fn_mutilated11, fallen_deathb12] {};
void() fallen_deathb12 =[$fn_mutilated12, fallen_deathb13] {};
void() fallen_deathb13 =[$fn_mutilated13, fallen_deathb14] {};
void() fallen_deathb14 =[$fn_mutilated14, fallen_deathb15] {};
void() fallen_deathb15 =[$fn_mutilated15, fallen_deathb16] {};
void() fallen_deathb16 =[$fn_mutilated16, fallen_deathb17] {};
void() fallen_deathb17 =[$fn_mutilated17, fallen_deathb18] {};
void() fallen_deathb18 =[$fn_mutilated18, fallen_deathb19] {};
void() fallen_deathb19 =[$fn_mutilated19, fallen_deathb20] {};
void() fallen_deathb20 =
{
	self.alpha = 1;
	self.frame = $fn_mutilated20;
	self.cnt = 100;
	self.flags = 0;
	self.health = 0;
	self.think = gibalphafade2;
	self.nextthink = time + 10 + (random() *10);
};

void() fallen_deatha = 
{
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;

	spawn_gib_stuff("tag_torso", "models/enemies/fallen/gibs/gib_torso_a.md3", "fallen_blood_shower_large", '-40 50 10', self, 0.5, "null");
	spawn_gib_stuff("tag_torso", "models/enemies/fallen/gibs/gib_torso_b.md3", "fallen_blood_shower_large", '40 -50 10', self, 0.5, "null");	//0.5
	spawn_gib_stuff("tag_waist", "models/enemies/fallen/gibs/gib_leg_a_r.md3", "fallen_blood_shower_small", '60 80 -20', self, 0.25, "null");	//0.25
	spawn_gib_stuff("tag_waist", "models/enemies/fallen/gibs/gib_leg_a_l.md3", "fallen_blood_shower_small", '-60 -80 -20', self, 0.25, "null");	//0.25
	spawn_gib_stuff("tag_leg_b_r", "models/enemies/fallen/gibs/gib_leg_b_r.md3", "null", '20 30 50', self, 0, "null");
	spawn_gib_stuff("tag_leg_b_l", "models/enemies/fallen/gibs/gib_leg_b_l.md3", "null", '20 -30 50', self, 0, "null");
	spawn_gib_stuff("tag_knee_r", "", "fallen_blood_shower_small", '0 0 0', self, 0.25, "null");	//0.25
	spawn_gib_stuff("tag_knee_l", "", "fallen_blood_shower_small", '0 0 0', self, 0.25, "null");	//0.25
	local vector tagorg;local float tagindex;local string tagname;
	tagname = ("tag_head");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	if (!self.mutilated)
	{
		ThrowGib2("models/enemies/fallen/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 0 100', self), 0, 1);
		spawn_gib_stuff("tag_head", "models/misc/null.md3", "fallen_blood_shower_small", '50 0 100', self, 0.55, "null");	//0.5
		spawn_gib_stuff("tag_arm_a_r", "models/enemies/fallen/gibs/gib_arm_a_r.md3", "fallen_blood_shower_small", '-60 80 40', self, 0.25, "null");	//0.25
		spawn_gib_stuff("tag_arm_b_r", "models/enemies/fallen/gibs/gib_arm_b_r.md3", "fallen_blood_shower_small", '80 60 40', self, 0.25, "null");	//0.25
		spawn_gib_stuff("tag_arm_a_l", "models/enemies/fallen/gibs/gib_arm_a_l.md3", "fallen_blood_shower_small", '60 -80 40', self, 0.25, "null");	//0.25
		spawn_gib_stuff("tag_arm_b_l", "models/enemies/fallen/gibs/gib_arm_b_l.md3", "fallen_blood_shower_small", '-80 -60 40', self, 0.25, "null");	//0.25
	}

	if (self.mutilated == 1)
	{
		spawn_gib_stuff("tag_arm_a_r", "models/enemies/fallen/gibs/gib_arm_a_r.md3", "fallen_blood_shower_small", '-60 80 40', self, 0.25, "null");	//0.25
		spawn_gib_stuff("tag_arm_b_r", "models/enemies/fallen/gibs/gib_arm_b_r.md3", "fallen_blood_shower_small", '80 60 40', self, 0.25, "null");	//0.25
		spawn_gib_stuff("tag_arm_a_l", "models/enemies/fallen/gibs/gib_arm_a_l.md3", "fallen_blood_shower_small", '60 -80 40', self, 0.25, "null");	//0.25
		spawn_gib_stuff("tag_arm_b_l", "models/enemies/fallen/gibs/gib_arm_b_l.md3", "fallen_blood_shower_small", '-80 -60 40', self, 0.25, "null");	//0.25
	}

	if (self.mutilated == 2)
	{
		ThrowGib2("models/enemies/fallen/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 0 100', self), 0, 1);
		spawn_gib_stuff("tag_head", "models/misc/null.md3", "fallen_blood_shower_small", '50 0 100', self, 0.55, "null");	//0.5
		spawn_gib_stuff("tag_arm_a_l", "models/enemies/fallen/gibs/gib_arm_a_l.md3", "fallen_blood_shower_small", '60 -80 40', self, 0.25, "null");	//0.25
		spawn_gib_stuff("tag_arm_b_l", "models/enemies/fallen/gibs/gib_arm_b_l.md3", "fallen_blood_shower_small", '-80 -60 40', self, 0.25, "null");	//0.25
	}

	if (self.mutilated == 3)
	{
		ThrowGib2("models/enemies/fallen/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 0 100', self), 0, 1);
		spawn_gib_stuff("tag_head", "models/misc/null.md3", "fallen_blood_shower_small", '50 0 100', self, 0.55, "null");	//0.5
		spawn_gib_stuff("tag_arm_a_r", "models/enemies/fallen/gibs/gib_arm_a_r.md3", "fallen_blood_shower_small", '-60 80 40', self, 0.25, "null");	//0.25
		spawn_gib_stuff("tag_arm_b_r", "models/enemies/fallen/gibs/gib_arm_b_r.md3", "fallen_blood_shower_small", '80 60 40', self, 0.25, "null");	//0.25
	}

	self.effects = EF_NODRAW;
	self.think = fallen_remove;
	self.nextthink = time + 0.1;
};

.float death_legs;
void() fallen_death = 
{
	local float r;
	r = random();
	monstersound5("enemies/fallen/die", 3, CHAN_VOICE);

	if (time > self.death_time_sound)
		monstersound4("impact/gibs/gib_hit", 5, CHAN_AUTO);

	self.chatter_time = 0;
	if (r > 0.2)
		self.think = fallen_deatha;
	else
	{
		self.cnt = 100;
		self.think = fallen_deathb;
		self.frame = 80;
	}

	if (self.death_legs >= 1)
	{
		self.cnt = 100;
		self.think = fallen_deathb;
		self.frame = 80;
	}

	self.nextthink = time + 0.05;

};
.float lastpain;
void() fallen_paina1 =[$fn_mutilatea1, fallen_paina2]
{
	self.mutilated = 1;
	self.skin = 1;
	self.lastpain = 3;

	spawn_gib_stuff("tag_head", "models/misc/null.md3", "fallen_blood_spurt_neck", '50 0 100', self, 0.55, "fallen_blood_spurt_neck");
	local vector tagorg;
	local float tagindex;
	local string tagname;
	tagname = ("tag_head");
	tagindex = gettagindex(self, tagname);
	tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/fallen/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 0 100', self), 0, 1);

};
void() fallen_paina2 =[$fn_mutilatea2, fallen_paina3] {};
void() fallen_paina3 =[$fn_mutilatea3, fallen_paina4] {};
void() fallen_paina4 =[$fn_mutilatea4, fallen_paina5] {};
void() fallen_paina5 =[$fn_mutilatea5, fallen_paina6] {};
void() fallen_paina6 =[$fn_mutilatea6, fallen_paina7] {};
void() fallen_paina7 =[$fn_mutilatea7, fallen_paina8] {};
void() fallen_paina8 =[$fn_mutilatea8, fallen_paina9] {};
void() fallen_paina9 =[$fn_mutilatea9, fallen_paina10] {};
void() fallen_paina10 =[$fn_mutilatea10, fallen_run]
{
	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_painb1 =[$fn_mutilateb1, fallen_painb2]
{
	self.mutilated = 2;
	self.skin = 2;
	self.lastpain = 2;
	spawn_gib_stuff("tag_arm_a_r", "models/enemies/fallen/gibs/gib_arm_a_r.md3", "fallen_blood_shower_small", '-60 80 40', self, 0.25, "fallen_bleed");
	spawn_gib_stuff("tag_arm_b_r", "models/enemies/fallen/gibs/gib_arm_b_r.md3", "fallen_blood_shower_small", '80 60 40', self, 0, "null");
};
void() fallen_painb2 =[$fn_mutilateb2, fallen_painb3] {};
void() fallen_painb3 =[$fn_mutilateb3, fallen_painb4] {};
void() fallen_painb4 =[$fn_mutilateb4, fallen_painb5] {};
void() fallen_painb5 =[$fn_mutilateb5, fallen_painb6] {};
void() fallen_painb6 =[$fn_mutilateb6, fallen_painb7] {};
void() fallen_painb7 =[$fn_mutilateb7, fallen_painb8] {};
void() fallen_painb8 =[$fn_mutilateb8, fallen_painb9] {};
void() fallen_painb9 =[$fn_mutilateb9, fallen_painb10] {};
void() fallen_painb10 =[$fn_mutilateb10, fallen_run]
{
	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_painc1 =[$fn_mutilatec1, fallen_painc2]
{
	self.mutilated = 3;
	self.skin = 3;
	self.lastpain = 1;

	spawn_gib_stuff("tag_arm_a_l", "models/enemies/fallen/gibs/gib_arm_a_l.md3", "fallen_blood_shower_small", '60 -80 40', self, 0.25, "fallen_bleed");
	spawn_gib_stuff("tag_arm_b_l", "models/enemies/fallen/gibs/gib_arm_b_l.md3", "fallen_blood_shower_small", '-80 -60 40', self, 0, "null");

};
void() fallen_painc2 =[$fn_mutilatec2, fallen_painc3] {};
void() fallen_painc3 =[$fn_mutilatec3, fallen_painc4] {};
void() fallen_painc4 =[$fn_mutilatec4, fallen_painc5] {};
void() fallen_painc5 =[$fn_mutilatec5, fallen_painc6] {};
void() fallen_painc6 =[$fn_mutilatec6, fallen_painc7] {};
void() fallen_painc7 =[$fn_mutilatec7, fallen_painc8] {};
void() fallen_painc8 =[$fn_mutilatec8, fallen_painc9] {};
void() fallen_painc9 =[$fn_mutilatec9, fallen_painc10] {};
void() fallen_painc10 =[$fn_mutilatec10, fallen_run]
{
	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_prepaina1 =[$fn_paina1, fallen_prepaina2]
{
	self.lastpain = 3;
};
void() fallen_prepaina2 =[$fn_paina2, fallen_prepaina3] {};
void() fallen_prepaina3 =[$fn_paina3, fallen_prepaina4] {};
void() fallen_prepaina4 =[$fn_paina4, fallen_prepaina5] {};
void() fallen_prepaina5 =[$fn_paina5, fallen_run]
{
	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_prepainb1 =[$fn_painb1, fallen_prepainb2]
{
	self.lastpain = 2;
};
void() fallen_prepainb2 =[$fn_painb2, fallen_prepainb3] {};
void() fallen_prepainb3 =[$fn_painb3, fallen_prepainb4] {};
void() fallen_prepainb4 =[$fn_painb4, fallen_prepainb5] {};
void() fallen_prepainb5 =[$fn_painb5, fallen_run]
{
	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

void() fallen_prepainc1 =[$fn_painc1, fallen_prepainc2]
{
	self.lastpain = 1;
};
void() fallen_prepainc2 =[$fn_painc2, fallen_prepainc3] {};
void() fallen_prepainc3 =[$fn_painc3, fallen_prepainc4] {};
void() fallen_prepainc4 =[$fn_painc4, fallen_prepainc5] {};
void() fallen_prepainc5 =[$fn_painc5, fallen_run]
{
	if ((visible2(self.enemy, 64, 0.3)))
	{
		ai_face();
		self.think = fallen_attack_melee;
		self.nextthink = time + 0.1;
	}
};

//void() crawler_run1 
void() crawler_death = 
{
	chattersound("enemies/fallen/die", 3, 1);
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	spawn_gib_stuff("tag_head", "models/misc/null.md3", "fallen_blood_shower_small", '50 0 100', self, 0.55, "null");
	local vector tagorg;local float tagindex;local string tagname;
	tagname = ("tag_head");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	ThrowGib2("models/enemies/fallen/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('50 0 100', self), 0, 1);

	spawn_gib_stuff("tag_torso", "models/enemies/fallen/gibs/gib_torso_a.md3", "fallen_blood_shower_large", '-40 50 10', self, 0.5, "null");
	spawn_gib_stuff("tag_torso", "models/enemies/fallen/gibs/gib_torso_b.md3", "fallen_blood_shower_large", '40 -50 10', self, 0.5, "null");
	spawn_gib_stuff("tag_arm_a_r", "models/enemies/fallen/gibs/gib_arm_a_r.md3", "fallen_blood_shower_small", '-60 80 40', self, 0.25, "null");
	spawn_gib_stuff("tag_arm_b_r", "models/enemies/fallen/gibs/gib_arm_b_r.md3", "fallen_blood_shower_small", '80 60 40', self, 0.25, "null");
	spawn_gib_stuff("tag_arm_a_l", "models/enemies/fallen/gibs/gib_arm_a_l.md3", "fallen_blood_shower_small", '60 -80 40', self, 0.25, "null");
	spawn_gib_stuff("tag_arm_b_l", "models/enemies/fallen/gibs/gib_arm_b_l.md3", "fallen_blood_shower_small", '-80 -60 40', self, 0.25, "null");
	self.effects = EF_NODRAW;
	self.think = fallen_remove;
	self.nextthink = time + 0.1;
};

void() ai_crawler_face = 
{
	/*
	local entity pl;
	pl = find(world, classname, "player"); 
	*/

	local vector vec;
	local float yaw;
	vec = self.enemy.origin - self.origin;
	yaw = vectoyaw(vec);
	self.angles_y = yaw;
};

void() blood_frames = 
{
	if (self.frame <= 12)
	{
		self.frame += 1;
		self.think = blood_frames;
		self.nextthink = time + (0.3* random());
	}
	else
	{
		self.think = alphafade;
		self.nextthink = time + random() *10;
	}
};

void(vector org, entity e) drop_blood = 
{
	return;
	/*
	local entity blood;
	blood = spawn();
	blood.solid = SOLID_NOT;
	blood.movetype = MOVETYPE_TOSS;
	blood.colormod = '1 0.3 0';

	local float r;

	traceline (org, org - '0 0 256', TRUE, blood);
	if(trace_fraction != 1)
	{
	local vector ang, coplanar,tpn;
	ang = blood.angles;
	tpn = trace_plane_normal;
	ang = blood.angles;
	ang_x = ang_x *-1;
	makevectors(ang);
	coplanar = v_forward-(v_forward*tpn)*tpn;
	blood.angles = vectoangles2(coplanar, tpn);
	}

	local vector org2;
	org2 = trace_endpos;
	setorigin(blood, org2);
	blood.alpha =  1;

	setmodel (blood, "models/misc/null.md3");

	r = random();
	if(r < 0.25)
	{
	blood.angles_y  = random()*360;
	blood.think = blood_frames;
	blood.nextthink = time + 0.1;
	}
	else
	{
	blood.angles_y  = e.angles_y;
	blood.skin = 1;
	blood.scale = 0.5* random() + 0.5;
	blood.frame = 12;
	blood.think = alphafade;
	blood.nextthink = time + 10 + random () *10;
	}

	*/
};

void() crawler_run1 =[$cr_walk1, crawler_run2]
{
	ai_runwalk(16);
	self.solid = SOLID_SLIDEBOX;
};
void() crawler_run2 =[$cr_walk2, crawler_run3]
{
	ai_runwalk(16);
};
void() crawler_run3 =[$cr_walk3, crawler_run4]
{
	ai_runwalk(16);
	ai_crawler_face();
};
void() crawler_run4 =[$cr_walk4, crawler_run5]
{
	ai_runwalk(16);
};
void() crawler_run5 =[$cr_walk5, crawler_run6]
{
	ai_runwalk(16);
	ai_crawler_face();
};
void() crawler_run6 =[$cr_walk6, crawler_run7]
{
	ai_runwalk(16);
};
void() crawler_run7 =[$cr_walk7, crawler_run8]
{
	ai_runwalk(16);
};
void() crawler_run8 =[$cr_walk8, crawler_run1]
{
	ai_runwalk(16);
	ai_crawler_face();
	local vector org;
	org = rorigin(self);
	local float r;
	r = random();
	if (r > 0.25)
		drop_blood(org, self);
};

void() crawler_start = 
{
	self.frame += 1;	//

	if (self.frame >= 115)
	{
		local entity pl;
		pl = find(world, classname, "player");
		local vector vec;
		local float yaw;
		vec = pl.origin - self.origin;
		yaw = vectoyaw(vec);
		self.angles_y = yaw;
		setsize(self, '-12 -12 -0', '12 12 32');
		self.enemy = pl;
		self.goalentity = self.enemy;
		self.think = crawler_run1;
	}
	else
		self.think = crawler_start;

	self.nextthink = time + 0.1;
};
void(entity attacker, float damage) null_pain = {};

void(entity e) fallen_crawler = 
{
	local entity crawler;
	crawler = spawn();
	crawler.owner = e;
	crawler.solid = SOLID_SLIDEBOX;
	crawler.movetype = MOVETYPE_STEP;
	crawler.takedamage = DAMAGE_YES;
	crawler.cnt = 1;
	setmodel(crawler, "models/enemies/fallen/fallen1.md3");
	crawler.classname = "crawler";
	setsize(crawler, '-12 -12 -0', '12 12 12');

	local vector tagorg;
	local float tagindex;
	local string tagname;

	makevectors(crawler.owner.angles);
	tagname = "tag_waist";
	tagindex = gettagindex(crawler.owner, tagname);
	tagorg = gettaginfo(crawler.owner, tagindex);
	crawler.frame = 109;

	crawler.origin = self.owner.origin + '0 0 12';
	setorigin(crawler, tagorg);
	crawler.angles = e.angles;
	crawler.health = 100;

	//	self.view_ofs_z = 40; 
	crawler.skin = 5;
	crawler.th_pain = null_pain;
	crawler.th_die = crawler_death;
	crawler.think = crawler_start;
	crawler.nextthink = time + 0.1;

};
void() fallen_paind1 =[$fn_mutilated1, fallen_paind2]
{
	self.mutilated = 4;
	self.skin = 4;
	self.cnt = 0;

	fallen_crawler(self);
	//setsize (self, '0 0 0', '0 0 0');
	self.solid = SOLID_CORPSE;

	spawn_gib_stuff("tag_waist", "", "fallen_blood_shower_small", '10 0 0', self, 0.25, "fallen_blood_spurt_waist");
};
void() fallen_paind2 =[$fn_mutilated2, fallen_paind3] {};
void() fallen_paind3 =[$fn_mutilated3, fallen_paind4] {};
void() fallen_paind4 =[$fn_mutilated4, fallen_paind5] {};
void() fallen_paind5 =[$fn_mutilated5, fallen_paind6] {};
void() fallen_paind6 =[$fn_mutilated6, fallen_paind7] {};
void() fallen_paind7 =[$fn_mutilated7, fallen_paind8] {};
void() fallen_paind8 =[$fn_mutilated8, fallen_paind9] {};
void() fallen_paind9 =[$fn_mutilated9, fallen_paind10] {};
void() fallen_paind10 =[$fn_mutilated10, fallen_paind11] {};
void() fallen_paind11 =[$fn_mutilated11, fallen_paind12] {};
void() fallen_paind12 =[$fn_mutilated12, fallen_paind13] {};
void() fallen_paind13 =[$fn_mutilated13, fallen_paind14] {};
void() fallen_paind14 =[$fn_mutilated14, fallen_paind15] {};
void() fallen_paind15 =[$fn_mutilated15, fallen_paind16] {};
void() fallen_paind16 =[$fn_mutilated16, fallen_paind17] {};
void() fallen_paind17 =[$fn_mutilated17, fallen_paind18] {};
void() fallen_paind18 =[$fn_mutilated18, fallen_paind19] {};
void() fallen_paind19 =[$fn_mutilated19, fallen_paind20] {};
void() fallen_paind20 =[$fn_mutilated20, fallen_paind20]
{
	self.cnt = 100;
	self.flags = 0;
	self.health = 0;
	monster_death_use();

	self.nextthink = time + 99999999999999999;
	self.think = fallen_paind20;
};

.float type_mutilated;

void(entity attacker, float damage) fallen_pain = 
{
	if ((time < self.pain_finished) && (self.enemy.weapon != IT_COACHGUN))
		return;
	if ((self.health <= 75) && (!self.mutilated))
	{
		self.pain_finished = time + 0.4;
		local float r;
		r = random();

		if (r > 0.66)
			self.think = fallen_paina1;
		else
		{
			if (self.randomattacked == 3)
				self.think = fallen_painb1;
			else
				self.think = fallen_painc1;
		}

		//else
		//self.think = fallen_paind1;

		if ((self.randomattacked <= 0) && (self.enemy.randomattack <= 0))
		{
			if (self.type_mutilated == 1)
				self.think = fallen_paina1;
			if (self.type_mutilated == 2)
				self.think = fallen_painb1;
			if (self.type_mutilated == 3)
				self.think = fallen_painc1;
		}

		//if(self.type_mutilated == 4)
		//self.think = fallen_paind1;

		if ((self.headless_time < time) && (self.skin == 1))
		{
			sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
			self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
		}
		else
			monstersound3("enemies/fallen/pain", 3, CHAN_VOICE);
	}
	else
	{
		self.pain_finished = time + 0.5;
		r = random();
		if (r > 0.66)
			self.think = fallen_prepaina1;
		else
		{
			if (self.randomattacked == 3)
				self.think = fallen_prepainb1;
			else
				self.think = fallen_prepainc1;
		}

		if (self.lastpain == 1)
			self.think = fallen_prepaina1;
		if (self.lastpain == 2)
			self.think = fallen_prepainb1;
		if (self.lastpain == 3)
			self.think = fallen_prepainc1;

		if ((self.headless_time < time) && (self.skin == 1))
		{
			sound(self, CHAN_VOICE, "enemies/fallen/headless.ogg", 1, 0.25);
			self.headless_time = soundlength("enemies/fallen/headless.ogg") + time;
		}
		else
			monstersound3("enemies/fallen/pain", 3, CHAN_VOICE);
	}
	self.sustained_damage = 0;
	self.nextthink = time;
};

.float risenframe;
void() fallen_rise = 
{
	self.risenframe += 1;
	self.frame += 1;

	if (self.risenframe == 2)
		self.takedamage = DAMAGE_AIM;

	if (self.risenframe >= 18)
	{
		self.th_stand = fallen_stand1;
		self.think = self.th_stand;
	}
	else
		self.think = fallen_rise;
	self.nextthink = time + 0.1;
};
.float timejump;
void()check_jump =
{
	makevectors(self.angles);
	local vector source =rorigin(self);
	float jump_height;
	jump_height = (((self.absmin_z* -1) + self.absmax_z) *-2) - self.absmax_z;
	traceline(source,source + v_forward *128 +  v_up * jump_height , FALSE, self);
	vector org = trace_endpos - v_forward * 4;
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord(MSG_BROADCAST, org_x);
			WriteCoord(MSG_BROADCAST, org_y);
			WriteCoord(MSG_BROADCAST, org_z);

	if (trace_fraction == 1.0)
	return;
	if ((self.flags &FL_ONGROUND) && (self.timejump < time))
	{
	self.flags = self.flags - FL_ONGROUND;
	float dist = 120;
	self.movetype = MOVETYPE_BOUNCE;
	self.velocity += v_forward *dist + '0 0 270';
	self.timejump = time + 1;
	}
};

void() precache_monster_fallen = 
{
	precache_model("models/enemies/fallen/gibs/gib_torso_b.md3");
	precache_model("models/enemies/fallen/gibs/gib_torso_a.md3");
	precache_model("models/enemies/fallen/gibs/gib_leg_b_r.md3");
	precache_model("models/enemies/fallen/gibs/gib_leg_b_l.md3");
	precache_model("models/enemies/fallen/gibs/gib_leg_a_r.md3");
	precache_model("models/enemies/fallen/gibs/gib_leg_a_l.md3");
	precache_model("models/enemies/fallen/gibs/gib_head.md3");
	precache_model("models/enemies/fallen/gibs/gib_arm_b_r.md3");
	precache_model("models/enemies/fallen/gibs/gib_arm_b_l.md3");
	precache_model("models/enemies/fallen/gibs/gib_arm_a_r.md3");
	precache_model("models/enemies/fallen/gibs/gib_arm_a_l.md3");
	precache_model("models/enemies/fallen/fallen1.md3");
	precache_model("models/enemies/fallen/fallen1.md3");
	precache_sound("enemies/fallen/attack1.ogg");
	precache_sound("enemies/fallen/attack2.ogg");
	precache_sound("enemies/fallen/attack3.ogg");
	precache_sound("enemies/fallen/attack4.ogg");
	precache_sound("enemies/fallen/attack5.ogg");
	precache_sound("enemies/fallen/chatter1.ogg");
	precache_sound("enemies/fallen/chatter2.ogg");
	precache_sound("enemies/fallen/chatter3.ogg");
	precache_sound("enemies/fallen/chatter4.ogg");
	precache_sound("enemies/fallen/chatter5.ogg");
	precache_sound("enemies/fallen/collapse.ogg");
	precache_sound("enemies/fallen/collapse.ogg");
	precache_sound("enemies/fallen/die1.ogg");
	precache_sound("enemies/fallen/die2.ogg");
	precache_sound("enemies/fallen/die3.ogg");
	precache_sound("enemies/fallen/headless.ogg");
	precache_sound("enemies/fallen/idle1.ogg");
	precache_sound("enemies/fallen/idle2.ogg");
	precache_sound("enemies/fallen/idle3.ogg");
	precache_sound("enemies/fallen/idle4.ogg");
	precache_sound("enemies/fallen/idle5.ogg");
	precache_sound("enemies/fallen/pain1.ogg");
	precache_sound("enemies/fallen/pain2.ogg");
	precache_sound("enemies/fallen/pain3.ogg");
	precache_sound("enemies/fallen/pain4.ogg");
	precache_sound("enemies/fallen/pain5.ogg");
	precache_sound("enemies/fallen/sight1.ogg");
	precache_sound("enemies/fallen/sight2.ogg");
	precache_sound("enemies/fallen/sight3.ogg");
	precache_sound("enemies/fallen/sight4.ogg");
	precache_sound("enemies/fallen/sight5.ogg");
	precache_sound("enemies/fallen/step1.ogg");
	precache_sound("enemies/fallen/step2.ogg");
	precache_sound("enemies/fallen/step3.ogg");
	precache_sound("enemies/fallen/step4.ogg");
	precache_sound("enemies/fallen/step5.ogg");
	precache_sound("enemies/fallen/swing1.ogg");
	precache_sound("enemies/fallen/swing2.ogg");
	precache_sound("enemies/fallen/swing3.ogg");
};
void() monster_fallen = 
{
	precache_model("models/enemies/fallen/gibs/gib_torso_b.md3");
	precache_model("models/enemies/fallen/gibs/gib_torso_a.md3");
	precache_model("models/enemies/fallen/gibs/gib_leg_b_r.md3");
	precache_model("models/enemies/fallen/gibs/gib_leg_b_l.md3");
	precache_model("models/enemies/fallen/gibs/gib_leg_a_r.md3");
	precache_model("models/enemies/fallen/gibs/gib_leg_a_l.md3");
	precache_model("models/enemies/fallen/gibs/gib_head.md3");
	precache_model("models/enemies/fallen/gibs/gib_arm_b_r.md3");
	precache_model("models/enemies/fallen/gibs/gib_arm_b_l.md3");
	precache_model("models/enemies/fallen/gibs/gib_arm_a_r.md3");
	precache_model("models/enemies/fallen/gibs/gib_arm_a_l.md3");
	precache_model("models/enemies/fallen/fallen1.md3");
	precache_model("models/enemies/fallen/fallen1.md3");
	precache_sound("enemies/fallen/attack1.ogg");
	precache_sound("enemies/fallen/attack2.ogg");
	precache_sound("enemies/fallen/attack3.ogg");
	precache_sound("enemies/fallen/attack4.ogg");
	precache_sound("enemies/fallen/attack5.ogg");
	precache_sound("enemies/fallen/chatter1.ogg");
	precache_sound("enemies/fallen/chatter2.ogg");
	precache_sound("enemies/fallen/chatter3.ogg");
	precache_sound("enemies/fallen/chatter4.ogg");
	precache_sound("enemies/fallen/chatter5.ogg");
	precache_sound("enemies/fallen/collapse.ogg");
	precache_sound("enemies/fallen/collapse.ogg");
	precache_sound("enemies/fallen/die1.ogg");
	precache_sound("enemies/fallen/die2.ogg");
	precache_sound("enemies/fallen/die3.ogg");
	precache_sound("enemies/fallen/headless.ogg");
	precache_sound("enemies/fallen/idle1.ogg");
	precache_sound("enemies/fallen/idle2.ogg");
	precache_sound("enemies/fallen/idle3.ogg");
	precache_sound("enemies/fallen/idle4.ogg");
	precache_sound("enemies/fallen/idle5.ogg");
	precache_sound("enemies/fallen/pain1.ogg");
	precache_sound("enemies/fallen/pain2.ogg");
	precache_sound("enemies/fallen/pain3.ogg");
	precache_sound("enemies/fallen/pain4.ogg");
	precache_sound("enemies/fallen/pain5.ogg");
	precache_sound("enemies/fallen/sight1.ogg");
	precache_sound("enemies/fallen/sight2.ogg");
	precache_sound("enemies/fallen/sight3.ogg");
	precache_sound("enemies/fallen/sight4.ogg");
	precache_sound("enemies/fallen/sight5.ogg");
	precache_sound("enemies/fallen/step1.ogg");
	precache_sound("enemies/fallen/step2.ogg");
	precache_sound("enemies/fallen/step3.ogg");
	precache_sound("enemies/fallen/step4.ogg");
	precache_sound("enemies/fallen/step5.ogg");
	precache_sound("enemies/fallen/swing1.ogg");
	precache_sound("enemies/fallen/swing2.ogg");
	precache_sound("enemies/fallen/swing3.ogg");

	self.flags = self.flags | FL_MONSTER;
	//setmodel (self, "models/enemies/fallen/fallen1out.mdl");
	setmodel(self, "models/enemies/fallen/fallen1.md3");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.classname = "monster_fallen";
	setsize(self, '-12 -12 -32', '12 12 32');
	//self.damagetopain = fallen_dtp;
	self.health = 100;
	//	self.view_ofs_z = 40; 
	if ((self.rise != 1) || ((self.rise == 1) && (self.warped == 1)))
		self.th_stand = fallen_stand1;
	else
		self.th_stand = fallen_rise;
	self.th_walk = fallen_walk1;
	self.skin = 0;

	local float r, rgib;
	r = (random() *5);
	if (r <= 5)
		self.noise = "enemies/fallen/sight5.ogg";
	if (r < 4)
		self.noise = "enemies/fallen/sight4.ogg";
	if (r < 3)
		self.noise = "enemies/fallen/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/fallen/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/fallen/sight1.ogg";
		
	self.th_run =  fallen_run;

	if (!(self.type_mutilated))
	{
		rgib = floor(random() *3);
		if (rgib < 1)
			self.type_mutilated = 1;
		if (rgib < 2)
			self.type_mutilated = 2;
		else
			self.type_mutilated = 3;
	}

	if (self.type_mutilated > 3)
		self.type_mutilated = 3;
	if (self.type_mutilated < 1)
		self.type_mutilated = 1;

	self.exec_push = 8;
	self.onlymelee =  1;
	self.classname = "monster_fallen";
	self.th_pain = fallen_pain;
	self.th_die = fallen_death;
	self.th_melee = fallen_attack_melee;
	self.touch = fallen_touch;
	if ((self.rise != 1) || ((self.rise == 1) && (self.warped == 1)))
	{
		self.origin_z += 12;
		self.frame = 1;
		self.think = self.th_stand;
		self.nextthink = time + 0.1;
		walkmonster_start();
	}
	else
	{
		self.frame = $cr_walk1;
		self.pain_finished = time + 2.05;
		self.think = walkmonster_start;
		self.nextthink = time + 0.05;
	}
};

////////////////end of qc file
