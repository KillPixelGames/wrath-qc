.float gibcount;

.float tre;
.string typegib;

void() air_touch = 
{
};

void() becomesolid = 
{
 self.tre += 1;
	if (self.solid != SOLID_CORPSE)
		self.solid = SOLID_CORPSE;
	self.avelocity = '0 0 0';
	if (!(self.wrathflags &FL_TOSS))
		self.wrathflags = self.wrathflags + FL_TOSS;
	if ((self.flags &FL_ONGROUND) && (!self.cnt))
	{
		if (self.angles_x < 45)
			self.angles_x = 0;
		if ((self.angles_x >= 65) && (self.angles_x < 115))
		{
			self.angles_x = 90;
			self.origin_z += 7;
		}

		if ((self.angles_x >= 115) && (self.angles_x < 245))
			self.angles_x = 180;
		if ((self.angles_x >= 245) && (self.angles_x < 295))
		{
			self.angles_x = 270;
			self.origin_z += 7;
		}

		if (self.angles_x >= 315)
			self.angles_x = 0;

		if (self.angles_z < 45)
			self.angles_z = 0;
		if ((self.angles_z >= 65) && (self.angles_z < 115))
		{
			self.angles_z = 90;
			self.origin_z += 7;
		}

		if ((self.angles_z >= 115) && (self.angles_z < 245))
			self.angles_z = 180;
		if ((self.angles_z >= 245) && (self.angles_z < 295))
		{
			self.angles_z = 270;
			self.origin_z += 7;
		}

		if (self.angles_z >= 315)
			self.angles_z = 0;
		self.cnt = 1;

	}

	//	if((!(self.flags &FL_ONGROUND)) && (self.velocity == '0 0 0')) 
	move_gibs();
	local float ctre;
	ctre = 100 *self.scale + 20;
	if ((self.tre > ctre))
		self.think = alphafade;
	else
		self.think = becomesolid;

	self.oldgroundentity = self.groundentity;
	self.nextthink = time + 0.05;
};

.float fakelight_count;
.float base_scale;
.vector fvelocity;
.string particlename;
.string namegib;
.string gibmodel1;
.string gibmodel2;
.string gibmodel3;
.string gibmodel4;
.string gibmodel5;
.string gibsound;
.vector enemyangle;
.float rfactor;
.float mass;
void() prebecomesolid = 
{
 if (!(self.flags &FL_ONGROUND))
	{
		self.think = prebecomesolid;
	}
	else
	{
		if (!self.cnt)
		{
			if (self.mass >= 3)
			{
				if (self.angles_x < 45)
					self.angles_x = 0;
				if ((self.angles_x >= 65) && (self.angles_x < 115))
				{
					self.angles_x = 90;
					self.origin_z += 7;
				}

				if ((self.angles_x >= 115) && (self.angles_x < 245))
					self.angles_x = 180;
				if ((self.angles_x >= 245) && (self.angles_x < 295))
				{
					self.angles_x = 270;
					self.origin_z += 7;
				}

				if (self.angles_x >= 315)
					self.angles_x = 0;

				if (self.angles_z < 45)
					self.angles_z = 0;
				if ((self.angles_z >= 65) && (self.angles_z < 115))
				{
					self.angles_z = 90;
					self.origin_z += 7;
				}

				if ((self.angles_z >= 115) && (self.angles_z < 245))
					self.angles_z = 180;
				if ((self.angles_z >= 245) && (self.angles_z < 295))
				{
					self.angles_z = 270;
					self.origin_z += 7;
				}

				if (self.angles_z >= 315)
					self.angles_z = 0;
			}
			else
			{
				if (self.angles_x < 90)
					self.angles_x = 0;
				if ((self.angles_x >= 90) && (self.angles_x < 270))
					self.angles_x = 180;
				if (self.angles_x >= 270)
					self.angles_x = 0;

				if (self.angles_z < 90)
					self.angles_z = 0;
				if ((self.angles_z >= 90) && (self.angles_z < 270))
					self.angles_z = 180;
				if (self.angles_z >= 270)
					self.angles_z = 0;
			}

			self.cnt = 1;
		}

		self.movetype = MOVETYPE_BOUNCE;
		self.fakelight_count += 1;
		if (self.fakelight_count > 5)
			self.think = becomesolid;
		else
			self.think = prebecomesolid;
	}

	self.nextthink = time + 0.05;
};

.float spread_vel;
void(string gibname, float dm, entity ouner, float bf) LanzarGib = 
{
 local entity new;

	new = spawn();
	new.owner = ouner;

	local vector org;
	org_x = (self.absmin_x) + (random() *self.size_x *0.75);
	org_y = (self.absmin_y) + (random() *self.size_y *0.75);
	org_z = (self.absmin_z) + (random() *self.size_z *0.75);
	if ((pointcontents(org) == CONTENT_SOLID))
	{
		remove(new);
		return;
	}

	new.type = ouner.type;
	new.mass = ouner.mass;
	new.origin = org;

	if (!(ouner.spawnflags &2))
	{
		if (ouner.particlename)
			pointparticles(particleeffectnum(ouner.particlename), org, '0 0 0', 1);
	}

	setmodel(new, gibname);
	setsize(new, '0 0 0', '0 0 0');

	new.gravity = 0.75;
	new.velocity = self.oldvelocity;	//

	//new.velocity = /*VelocityForDamage (dm *0.5) +  */ouner.fvelocity;
	new.movetype = MOVETYPE_BOUNCE;
	new.bouncefactor = bf;
	new.bouncestop = 0;
	new.angles_y = random() *360;
	new.alpha = 1;
	local float massfloat;

	massfloat = 1 / new.mass;

	new.avelocity_x = random() *massfloat *180;
	if (new.mass > 3)
		new.avelocity_y = random() *massfloat *720;
	else
		new.avelocity_y = random() *massfloat *180;
	new.avelocity_z = random() *massfloat *180;

	new.wrathflags += FL_GARBAGE;
	new.scale = ouner.base_scale *(0.25 + random() *1);
	if (ouner.base_scale <= 0)
		new.scale = 1;
	new.solid = SOLID_TRIGGER;
	new.think = prebecomesolid;
	new.nextthink = time + 0.25;
	new.touch = air_touch;
};

.entity autotrigger;

void() destruct_gibs = 
{
 local float ngibs;
	local string gibmodel, numbergib;

	local entity pl;
	pl = self.enemy;

	if (pl.classname == "executioner")
		self.mass += 0.5;

	while (self.gibcount > 0)
	{
		ngibs = floor((random() *self.rfactor) + 1);
		if (ngibs > self.rfactor)
			ngibs = 1;

		numbergib = ftos(ngibs);
		gibmodel = strcat("models/gibs/gib_", self.namegib, numbergib, ".bsp");
		//gibmodel = "maps/hacha.bsp";

		if (!self.type)
		{
			if (ngibs == 1)
				gibmodel = self.gibmodel1;
			if (ngibs == 2)
				gibmodel = self.gibmodel2;
			if (ngibs == 3)
				gibmodel = self.gibmodel3;
			if (ngibs == 4)
				gibmodel = self.gibmodel4;
			if (ngibs == 5)
				gibmodel = self.gibmodel5;

		}

		if (pl.classname == "player")
			makevectors(pl.v_angle);
		else
			makevectors(pl.angles);

		local float massfloat;
		massfloat = 1.25 / (self.mass + 1);

		if ((pl != world) && (self.spread_vel <= 0))
		{
			self.enemyangle = v_forward;
			self.oldvelocity = (v_forward *(192 *massfloat *(1 + (random() *0.5))));
			self.oldvelocity_z = (50 *massfloat) + (random() *50);
		}
		else
			self.oldvelocity = VelocityForDamage2(self.spread_vel);

		LanzarGib(gibmodel, self.health, self, self.bouncefactor);
		self.gibcount -= 1;
	}

	if(self.autotrigger)
	remove(self.autotrigger);
	self.think = SUB_Remove;
	self.nextthink = time;
};

void() destruct_die = 
{
 float nsnd, rnsnd;

	if (!self.type)
	{
		if (!self.bouncefactor)
			self.bouncefactor = 0.25;
		self.namegib = "custom";
		if (!self.mass)
			self.mass = 4;
	}
	else if (self.type == 1)
	{
		self.bouncefactor = 0.75;
		self.namegib = "stone";
		self.typegib = "stone0";
		self.rfactor = 4;
		self.mass = 0.75;
	}
	else if (self.type == 2)
	{
		self.bouncefactor = 0.25;
		self.namegib = "wood";
		self.typegib = "smash_woodbreak0";
		self.rfactor = 4;
		self.mass = 0.85;
	}
	else if (self.type == 3)
	{
		self.bouncefactor = 0.3;
		self.namegib = "tomb";
		self.typegib = "tomb";
		self.rfactor = 2;
		self.mass = 0.75;
	}
	else if (self.type == 4)
	{
		self.bouncefactor = 0.1;
		self.namegib = "glass";
		self.typegib = "glass0";
		self.rfactor = 2;
		self.mass = 0.1;
	}
	else if (self.type == 5)
	{
		self.bouncefactor = 0.5;
		self.namegib = "ice";
		self.typegib = "ice0";
		self.rfactor = 2;
		self.mass = 0.75;
	}

	local float attn;
	if (self.rad_sound == 0)
		attn = 0;
	else if (self.rad_sound == -1)
		attn = -1;
	else
		attn = 256 / self.rad_sound;	// 200 for snd_soundradius default cvar!

	if (self.noise)
	{
		if (self.noise)
			nsnd = 1;
		if (self.noise2)
			nsnd = 2;
		if (self.noise3)
			nsnd = 3;
		rnsnd = floor(random() *nsnd) + 1;

		if (rnsnd == 2)
			self.noise = self.noise2;
		if (rnsnd == 3)
			self.noise = self.noise3;

		local vector orgsound;
		orgsound = 0.5 *(self.absmax + self.absmin);
		pointsound(orgsound, self.noise, self.volume, attn);
	}

	if (self.spawnflags &2)
	{
		local vector org;
		org = 0.5 *(self.absmax + self.absmin);
		if (self.particlename)
			pointparticles(particleeffectnum(self.particlename), org, '0 0 0', 1);
	}

	SUB_UseTargets();
	self.solid = SOLID_NOT;
	self.takedamage = 0;
	self.use = SUB_Null;
	self.alpha = -1;
	self.effects = EF_NODRAW;
	self.think = destruct_gibs;
	self.nextthink = time;	// + 55;
};


.float touch_smash;
.float touch_smash_delay;

void() func_destruct_touch =
{

	if(other.classname != "player")
	return;
	self.touch_smash = 0;
	self.think = destruct_die;
	self.nextthink = time + self.touch_smash_delay;
};

void() auto_triggerhurt_touch_think =
{
		T_Damage(self.owner, other, other, 120);	// its damage
		remove(self);
}

void() auto_triggerhurt_touch =
{
	if(self.touch_smash & 2)
	{
		if (other.flags & FL_MONSTER)
		{
		self.touch_smash = 0;
		self.think = auto_triggerhurt_touch_think ;
		self.nextthink = time + self.touch_smash_delay;
		}
	}
else
	{
		if ((other.classname == "monster_stricken") || (other.classname == "executioner"))
		{
			T_Damage(self.owner, other, other, 120);	// its damage
			remove(self);
		}
	}
};

.float fakelight;
void() func_destruct = 
{
 precache_model("models/gibs/gib_stone1.bsp");
	precache_model("models/gibs/gib_stone2.bsp");
	precache_model("models/gibs/gib_stone3.bsp");
	precache_model("models/gibs/gib_stone4.bsp");
	precache_model("models/gibs/gib_tomb1.bsp");
	precache_model("models/gibs/gib_tomb2.bsp");
	precache_model("models/gibs/gib_tomb3.bsp");
	precache_model("models/gibs/gib_tomb4.bsp");
	precache_model("models/gibs/gib_wood1.bsp");
	precache_model("models/gibs/gib_wood2.bsp");
	precache_model("models/gibs/gib_wood3.bsp");
	precache_model("models/gibs/gib_wood4.bsp");

	if (self.noise)
		precache_sound(self.noise);
	if (self.noise2)
		precache_sound(self.noise2);
	if (self.noise3)
		precache_sound(self.noise3);

	if (self.type == 1)
	{
		precache_sound("impact/destruct/stone_break1.ogg");
		precache_sound("impact/destruct/stone_break2.ogg");
		self.noise = ("impact/destruct/stone_break1.ogg");
		self.noise2 = ("impact/destruct/stone_break2.ogg");
	}

	if (self.type == 2)
	{
		precache_sound("impact/destruct/wood1_break1.ogg");
		precache_sound("impact/destruct/wood1_break2.ogg");
		precache_sound("impact/destruct/wood1_break3.ogg");
		self.noise = ("impact/destruct/wood1_break1.ogg");
		self.noise2 = ("impact/destruct/wood1_break2.ogg");
		self.noise3 = ("impact/destruct/wood1_break3.ogg");
	}

	if (self.type == 4)
	{
		precache_sound("impact/destruct/glass_break1.ogg");
		precache_sound("impact/destruct/glass_break2.ogg");
		precache_sound("impact/destruct/glass_break3.ogg");
		self.noise = ("impact/destruct/glass_break1.ogg");
		self.noise2 = ("impact/destruct/glass_break2.ogg");
		self.noise3 = ("impact/destruct/glass_break3.ogg");
	}


	if (self.fakelight == 1)
	{
			vector borg = b_org(self);
			fake_light (self,borg);
	}
	if (self.gibmodel1)
	{
		precache_model(self.gibmodel1);
		self.rfactor = 1;
	}

	if (self.gibmodel2)
	{
		precache_model(self.gibmodel2);
		self.rfactor = 2;
	}

	if (self.gibmodel3)
	{
		precache_model(self.gibmodel3);
		self.rfactor = 3;
	}

	if (self.gibmodel4)
	{
		precache_model(self.gibmodel4);
		self.rfactor = 4;
	}

	if (self.gibmodel5)
	{
		precache_model(self.gibmodel5);
		self.rfactor = 5;
	}

	//self.origin = 0.5 *(self.absmax + self.absmin); 
	self.angles = '0 0 0';
	self.solid = SOLID_BSP;
	//self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	//setorigin (self, self.origin);
	if (!self.base_scale)
		self.base_scale = -1;
	if (!self.volume)
		self.volume = 1;
	if (self.volume > 1)
		self.volume = 1;
	if (!self.gibcount)
		self.gibcount = 5;
	if (self.gibcount <= 0)
		self.gibcount = 0;
	setmodel(self, self.model);
	if (!self.health)
		self.health = 5;
	if (!self.rad_sound)
		self.rad_sound = 512;
	if ((!self.targetname))
		self.takedamage = DAMAGE_YES;
	if ((self.spawnflags &1) && (self.targetname))
		self.takedamage = DAMAGE_YES;
	self.use = destruct_die;
	self.th_die = destruct_die;
	if(self.touch_smash & 1)
	self.touch = func_destruct_touch;
	 self.fake_origin = (self.absmin + self.absmax) *0.5;
	 
	if (((self.targetname) && (self.spawnflags &1)) || (self.touch_smash&2)) 
	{
		local entity auto_triggerhurt;
		auto_triggerhurt = spawn();
		self.autotrigger = auto_triggerhurt;
		auto_triggerhurt.solid = SOLID_TRIGGER;
		auto_triggerhurt.owner = self;
		auto_triggerhurt.touch_smash = self.touch_smash;
		auto_triggerhurt.touch_smash_delay = self.touch_smash_delay;
		if(self.touch_smash & 2)
		setsize(auto_triggerhurt, (self.absmin - ('4 4 2')), (self.absmax + ('4 4 2')));
		else
		setsize(auto_triggerhurt, (self.absmin - ('20 20 2')), (self.absmax + ('20 20 2')));
		auto_triggerhurt.touch = auto_triggerhurt_touch;
	}
	if(self.startnonsolid == 1)
	{
	self.oldsolid = self.solid;
	self.wrathflags += FL_STARTNONSOLID;
	self.solid = SOLID_NOT;
	self.think = turn_solid;
	self.nextthink =  self.ltime + 1;
	}
};

void() rotate_stop = 
{
 if (self.noise2)
		sound(self, CHAN_VOICE, self.noise2, self.volume, self.rad_sound);
	self.avelocity = '0 0 0';
	SUB_UseTargets();
};

.vector rot_ang;
.vector rot_ang2;
.vector rot_ang3;
.vector rot_ang4;
.vector rot_ang5;

.float wait2;
.float wait3;
.float wait4;
.float wait5;

void() rotdoor_use = 
{
 local float angvmul;
	angvmul = 1 / self.wait;
	if (self.noise)
		sound(self, CHAN_VOICE, self.noise, self.volume, self.rad_sound);

	self.avelocity_x = self.rot_ang_x * angvmul;
	self.avelocity_y = self.rot_ang_y * angvmul;
	self.avelocity_z = self.rot_ang_z * angvmul;

	self.nextthink = self.ltime + self.wait;
	self.think = rotate_stop;
};

void() func_rotate = 
{
 if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.use = rotdoor_use;
	if (!self.wait)
		self.wait = 1;
};

void() func_fan_on;

void() func_fan_off = 
{
 self.avelocity = '0 0 0';
	self.use = func_fan_on;
};

void() func_fan_on = 
{
 self.avelocity = self.rot_ang;
	self.use = func_fan_off;
	self.nextthink = 999999999999999999999999;
};

void() func_fan = 
{
 self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.use = func_fan_on;
	if (self.spawnflags != 1)
	{
		self.think = func_fan_on;
		self.nextthink = self.ltime + 0.1;
	}
};

void() func_wall = 
{
 self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);

};

void() func_brush = 
{
 setmodel(self, self.model);
};

void() func_clip = 
{
 setmodel(self, self.model);
	self.effects = EF_NODRAW;
	self.solid = SOLID_BBOX;
};

void() func_illusionary = 
{
 setmodel(self, self.model);
	if (self.type == 1)
		self.effects = EF_DOUBLESIDED;
	if (self.type == 2)
		makestatic(self);
};

.float move1_time;
.float move2_time;
.float move3_time;

.vector move1_dist;
.vector move2_dist;
.vector move3_dist;

.vector move1_speed;
.vector move2_speed;
.vector move3_speed;

.float invertfade;
.float move_state;
.vector vel_var;
.vector rot_ang_end;

.float scale_var;
.float change_vel;

void() fadewall_use = 
{
 if (self.invertfade)
		self.alpha += self.cnt;
	else
		self.alpha -= self.cnt;

	if (self.invertfade)
	{
		if (self.alpha < 1)
			self.think = fadewall_use;
		else
		{
			self.alpha = 1;
			self.move1_time = 0;
			self.velocity = '0 0 0';
			self.movetype = 0;
			self.think = null;
			if (self.rot_ang)
			{
				self.movetype = MOVETYPE_NOCLIP;
				self.nextthink = time + 999999999999999999999999;
			}
		}
	}
	else
	{
		if (self.alpha > 0)
			self.think = fadewall_use;
		else
			self.think = SUB_Remove;
	}

	if (self.move1_time > time)
		self.velocity = self.move1_speed;
	else
	{
		if (self.move2_time > time)
			self.velocity = self.move2_speed;
		else
		{
			if (self.move3_time > time)
				self.velocity = self.move3_speed;
		}
	}

	if (self.change_vel == 1)
		self.rot_ang -= self.vel_var;
	self.avelocity = self.rot_ang;
	self.scale += self.scale_var;

	self.nextthink = time + 0.05;
};

void() fadewall_preuse = 
{
 self.move3_time = time + self.move1_time + self.move2_time + self.move3_time;
	self.move2_time = time + self.move1_time + self.move2_time;
	self.move1_time = time + self.move1_time;
	if (self.invertfade == 1)
	{
		self.effects = 0;
		self.alpha = 0.01;
	}

	self.think = fadewall_use;
	self.nextthink = time;
};

/*
func_figment

move1_time how much long takes the first movement
move2_time how much long takes the second movement
move3_time how much long takes the third movement

invertfade  starts invisible?

alpha alpha intensity

delay

move1_dist first movement distance vector
move2_dist second movement distance vector
move3_dist third movement distance vector

rot_ang vector angles at start
rot_ang_end vector angles at end
*/
void() func_figment = 
{
 self.movetype = MOVETYPE_NOCLIP;
	if (!self.move1_time)
		self.move1_time = 0.35;
	if (!self.move2_time)
		self.move2_time = 0.35;
	if (!self.move3_time)
		self.move3_time = 0.35;
	if (self.invertfade == 1)
	{
		self.alpha = 0;
		self.effects = EF_NODRAW;
	}
	else
	{
		if (!self.alpha)
			self.alpha = 1;
	}

	if (!self.delay)
		self.delay = 1.05;

	self.move1_speed_x = self.move1_dist_x *(self.delay / self.move1_time);
	self.move1_speed_y = self.move1_dist_y *(self.delay / self.move1_time);
	self.move1_speed_z = self.move1_dist_z *(self.delay / self.move1_time);

	self.move2_speed_x = self.move2_dist_x *(self.delay / self.move2_time);
	self.move2_speed_y = self.move2_dist_y *(self.delay / self.move2_time);
	self.move2_speed_z = self.move2_dist_z *(self.delay / self.move2_time);

	self.move3_speed_x = self.move3_dist_x *(self.delay / self.move3_time);
	self.move3_speed_y = self.move3_dist_y *(self.delay / self.move3_time);
	self.move3_speed_z = self.move3_dist_z *(self.delay / self.move3_time);
	self.scale = 1;
	self.count = 1;
	self.cnt = 1 / (self.delay / 0.05);
	setmodel(self, self.model);
	local float nf;
	nf = 1;
	self.vel_var_x = ((self.rot_ang_x - self.rot_ang_end_x) / (20 *self.delay)) *nf;
	self.vel_var_y = ((self.rot_ang_y - self.rot_ang_end_y) / (20 *self.delay)) *nf;
	self.vel_var_z = ((self.rot_ang_z - self.rot_ang_end_z) / (20 *self.delay)) *nf;

	self.use = fadewall_preuse;
};

void() func_fakeshadowthink = 
{
 if (self.count == 1)
	{
		self.alpha += 0.0025;
		if (self.alpha >= 0.75)
			self.count = 0;
	}
	else
	{
		self.alpha -= 0.0025;
		if (self.alpha <= 0.1)
			self.count = 1;
	}

	self.nextthink = time + 0.01;
};
void() func_fakeshadow = 
{
 if (self.alpha == 0.1)
		self.count = 1;
	else
		self.count = 0;

	setmodel(self, self.model);
	self.think = func_fakeshadowthink;
	self.nextthink = time;
};

.float max_angle_y;
.float min_angle_y;
.float virtualangles_y;

float(entity bloke, entity rotate) backtouch2 = 
{
 local float result;
	local vector veca, vecb;

	makevectors(bloke.v_angle);

	veca = v_right;

	makevectors(rotate.angles);
	vecb = v_forward;

	result = ((veca_x *vecb_y) - (vecb_x *veca_y));

	if (result < 0)
		result = result *-1;

	return result;

};
float(entity targ, entity eself) backtouch = 
{
 local vector vec;
	local float dot;

	makevectors2(eself.angles);
	vec = normalize(rorigin(targ) - rorigin(eself));
	dot = vec * v_forward;

	if (dot > 0)
		return FALSE;
	else
		return TRUE;
};

.float rotate_flags;
.entity anglecalculator;
float ROTATE_STOP = 0;
float ROTATE_FORWARD = 1;
float ROTATE_REVERSE = 2;
void() rotate_fance_stop = 
{
 self.cnt = 0;
	self.avelocity = '0 0 0';
};
void() func_rotate_fence_rotates = 
{
 if (((self.skin <= -90) && (self.rotate_flags == ROTATE_REVERSE)) || ((self.skin >= 90) && (self.rotate_flags == ROTATE_FORWARD)))
	{
		self.avelocity_y = 0;
		self.think = rotate_fance_stop;
		self.rotate_flags = ROTATE_STOP;
		self.cnt = 0;
		self.nextthink = self.ltime;
		return;
	}

	if ((self.cnt > 0))
	{
		self.cnt--;
		local float avel;
		avel = self.rot_ang_y *(self.cnt / 20);
		self.virtualangles_y += avel;
		self.skin = self.virtualangles_y / 20;

		self.avelocity_y = avel;
	}
	else
	{
		self.avelocity_y = 0;
		self.think = rotate_fance_stop;
		self.rotate_flags = ROTATE_STOP;
	}

	self.think = func_rotate_fence_rotates;
	self.nextthink = self.ltime + 0.05;
};

float(entity plyr) horizontalvel = 
{
 float hor_vel;
	float x_vel = other.velocity_x;
	float y_vel = other.velocity_y;
	if (x_vel < 0)
		x_vel = x_vel *-1;
	if (y_vel < 0)
		y_vel = y_vel *-1;
	hor_vel = ((x_vel + y_vel) *0.2) + 10;
	bprint(ftos(hor_vel), "\n");
	return hor_vel;
};
void() func_rotate_fence_touch = 
{
 if (other.classname != "player")
		return;
	if (backtouch(other, self))
	{
		self.rot_ang_y = -45;
		self.rotate_flags = ROTATE_REVERSE;
	}
	else
	{
		self.rot_ang_y = 45;
		self.rotate_flags = ROTATE_FORWARD;
	}

	float anglemultiplier = (backtouch2(other, self));

	float touchervel;
	touchervel = horizontalvel(other);
	if (self.cnt <= 20)
		self.cnt = touchervel *anglemultiplier *0.5;
	else
		return;

	self.think = func_rotate_fence_rotates;
	self.nextthink = self.ltime + 0.05;
};

void() func_rotate_fence = 
{
 self.movetype = MOVETYPE_PUSH;
	self.rotate_flags = ROTATE_STOP;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.touch = func_rotate_fence_touch;
	self.virtualangles_y = 0;
	if (!self.wait)
		self.wait = 1;
};

void() func_monsterclip = 
{
 self.solid = SOLID_BSP;
	setmodel(self, self.model);
	self.dphitcontentsmask = DPCONTENTS_SOLID;
}


void(vector inflictor_origin, entity targ, float damage, float pushfactor) explo_physics_bmodels = 
{ 
		vector dir, z_vel;

		vector borg = b_org(targ);
		dir = borg - inflictor_origin;
		dir = normalize(dir);
		targ.movetype = MOVETYPE_BOUNCE;
		if (targ.flags &FL_ONGROUND)
			targ.flags -= FL_ONGROUND;

		z_vel_z =pushfactor * 12;
		targ.velocity = targ.velocity + dir *damage * pushfactor +z_vel;
		targ.avelocity_x = random(90, 180);
		targ.avelocity_y = random(90, 180);
		targ.avelocity_z = random(90, 180);
};



void() use_debris =
{
self.solid = SOLID_CORPSE;	
self.effects = EF_DYNAMICMODELLIGHT;
explo_physics_bmodels(self.oldorigin, self, 130, 1);
};

void()debris_think = 
{

	if(!self.oldorigin) 
	{
		entity t = find(world, target, self.targetname);
		self.oldorigin = b_org(t);
	}
	if(self.flags & FL_ONGROUND)
	{
		self.avelocity = '0 0 0';
		self.velocity = '0 0 0';
		self.think = SUB_Null;
		self.nextthink = time + 10;
	}
	else 
	{
		self.think = debris_think;
		self.nextthink = time + 0.05;
	}
}

void() func_debris  = 
{
	setmodel(self, self.model);
	self.effects = EF_NODRAW;
	self.solid = SOLID_NOT;
	self.use = use_debris;
	self.think = debris_think;
	self.nextthink = time + 0.1;
}
.vector intensity;
.float sradius;
.float sattenuation;
void()trigger_shake_use = 
{

	if(self.sradius)
	{
		float distancetoplayer = vlen (self.origin - single_player.origin);
		if (distancetoplayer >= self.sradius)
		{
			remove(self); 
			return;
		}
		else
		{	
		if(self.sattenuation == 1)
		float modifier = 1 / (self.sradius / (self.sradius - distancetoplayer ));
		else
		modifier = 1;
		self.intensity_x = self.intensity_x * modifier;  
		self.intensity_y = self.intensity_y * modifier;
		}


	}

	single_player.shaked = 1;
	single_player.shake_camera_time = time + self.wait;
	single_player.shake_camera_ammountx = self.intensity_x * 0.1;


	float r = random();
	if (r > 0.5)
		single_player.shake_camera_ammounty = self.intensity_y * 0.1;
	else
		single_player.shake_camera_ammounty = self.intensity_y *-1 * 0.1;

	single_player.shake_camera_refresh_rate = self.shake_camera_refresh_rate;

	remove(self);
}

void() trigger_shake = 
{
if(!self.wait)
self.wait = 1;
if(!self.intensity_x)
self.intensity_x = 10;
if(!self.intensity_y)
self.intensity_y = 10;
if(!self.shake_camera_refresh_rate)
self.shake_camera_refresh_rate = 0.05;

self.use = trigger_shake_use;
};
.float stepheighttime;
.float stepheight;

.float oldstepheight_delta;

void() restore_oldstepheight =
{
self.owner.stepheight_delta = self.owner.oldstepheight_delta;
self.owner.colormod = '1 1 1';
remove(self);
}
void() trigger_stepheight_touch =
{

	if((other.flags & FL_MONSTER) && (other.stepheighttime < time))
	{
	local float dev = cvar ("developer");
	if(dev == 1)
	other.colormod = '1 1 0';

	other.stepheight_delta = self.stepheight + 1;
	other.stepheighttime = time + self.wait;
	entity stepheight_restorer = spawn();
	stepheight_restorer.owner = other;
	stepheight_restorer.think = restore_oldstepheight;
	stepheight_restorer.nextthink = time + self.wait;
	}

};
void() trigger_stepheight =
{
setmodel (self, self.model);
self.effects = EF_NODRAW;
self.solid = SOLID_TRIGGER;
if(!self.wait)
self.wait = 3;
if(!self.stepheight)
self.stepheight = 16;
self.touch = trigger_stepheight_touch;
}

//////////////////////////////////end of qc file/