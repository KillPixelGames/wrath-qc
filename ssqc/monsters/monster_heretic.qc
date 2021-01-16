/*
==============================================================================

heretic

==============================================================================
*/

/*
1. health
2. walk speed
3. walk think % chance to attack, else keep walking
4. run speed
5. run time
8. attack type (melee or projectile)
6. attack damage
7. attack time
9. pre-attack time
10. secondary attack damage
11. secondaryattack time
12. secondary pre-attack time
13. damage needed to pain
14. pain time
15. pain think % chance to attack or walk
16. bbox

secondary attack is always melee
*/

$frame pose0

$frame her_idle1 her_idle2 her_idle3 her_idle4 her_idle5 her_idle6 her_idle7 her_idle8 her_idle9 her_idle10
$frame her_idle11 her_idle12 her_idle13 her_idle14 her_idle15 her_idle16 her_idle17 her_idle18 her_idle19 her_idle20

$frame her_warp1 her_warp2 her_warp3 her_warp4 her_warp5 her_warp6 her_warp7 her_warp8 her_warp9 her_warp10

$frame her_run1 her_run2 her_run3 her_run4 her_run5 her_run6 her_run7 her_run8 her_run9 her_run10
$frame her_run11 her_run12 her_run13 her_run14 her_run15 her_run16 her_run17 her_run18 her_run19 her_run20

$frame her_schase1 her_schase2

$frame her_chase1 her_chase2 her_chase3 her_chase4 her_chase5 her_chase6 her_chase7 her_chase8

$frame her_echase1 her_echase2 her_echase3 her_echase4 her_echase5

$frame her_batk1 her_batk2 her_batk3 her_batk4 her_batk5

$frame her_atk1 her_atk2 her_atk3 her_atk4 her_atk5

$frame her_paina1 her_paina2 her_paina3 her_paina4 her_paina5

$frame her_painb1 her_painb2 her_painb3 her_painb4 her_painb5

$frame her_painc1 her_painc2 her_painc3 her_painc4 her_painc5

$frame her_paind1 her_paind2 her_paind3 her_paind4 her_paind5

	.float runing_time;

/////////////////////////////////////////////////////////////////////////////////////////////
void() heretic_checkidle = 
{
	local float r;
	r = random() *100;
	if (heretic_ith >= r)
		ai_stand();
};
void() heretic_idle =[$her_idle1, heretic_idle2]
{
	heretic_checkidle();
	local float r;
	r = random() *10;
	if ((r < 1) && (!(self.spawnflags &1)))
		monstersound1("enemies/heretic/idle", 3, CHAN_VOICE);
};
void() heretic_idle2 =[$her_idle2, heretic_idle3]
{
	heretic_checkidle();
};
void() heretic_idle3 =[$her_idle3, heretic_idle4]
{
	heretic_checkidle();
};
void() heretic_idle4 =[$her_idle4, heretic_idle5]
{
	heretic_checkidle();
};
void() heretic_idle5 =[$her_idle5, heretic_idle6]
{
	heretic_checkidle();
};
void() heretic_idle6 =[$her_idle6, heretic_idle7]
{
	heretic_checkidle();
};
void() heretic_idle7 =[$her_idle7, heretic_idle8]
{
	heretic_checkidle();
};
void() heretic_idle8 =[$her_idle8, heretic_idle9]
{
	heretic_checkidle();
};
void() heretic_idle9 =[$her_idle9, heretic_idle10]
{
	heretic_checkidle();
};
void() heretic_idle10 =[$her_idle10, heretic_idle11]
{
	heretic_checkidle();
};
void() heretic_idle11 =[$her_idle11, heretic_idle12]
{
	heretic_checkidle();
};
void() heretic_idle12 =[$her_idle12, heretic_idle13]
{
	heretic_checkidle();
};
void() heretic_idle13 =[$her_idle13, heretic_idle14]
{
	heretic_checkidle();
};
void() heretic_idle14 =[$her_idle14, heretic_idle15]
{
	heretic_checkidle();
};
void() heretic_idle15 =[$her_idle15, heretic_idle16]
{
	heretic_checkidle();
};
void() heretic_idle16 =[$her_idle16, heretic_idle17]
{
	heretic_checkidle();
};
void() heretic_idle17 =[$her_idle17, heretic_idle18]
{
	heretic_checkidle();
};
void() heretic_idle18 =[$her_idle18, heretic_idle19]
{
	heretic_checkidle();
};
void() heretic_idle19 =[$her_idle19, heretic_idle20]
{
	heretic_checkidle();
};
void() heretic_idle20 =[$her_idle20, heretic_idle]
{
	heretic_checkidle();
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() heretic_walk =[$her_run1, heretic_walk2]
{
	self.movetype = MOVETYPE_STEP;
	ai_walk(heretic_ws);
};
void() heretic_walk2 =[$her_run2, heretic_walk3]
{
	ai_walk(heretic_ws);
};
void() heretic_walk3 =[$her_run3, heretic_walk4]
{
	ai_walk(heretic_ws);
};
void() heretic_walk4 =[$her_run4, heretic_walk5]
{
	ai_walk(heretic_ws);
};
void() heretic_walk5 =[$her_run5, heretic_walk6]
{
	ai_walk(heretic_ws);
};
void() heretic_walk6 =[$her_run6, heretic_walk7]
{
	ai_walk(heretic_ws);
};
void() heretic_walk7 =[$her_run7, heretic_walk8]
{
	ai_walk(heretic_ws);
};
void() heretic_walk8 =[$her_run8, heretic_walk9]
{
	ai_walk(heretic_ws);
};
void() heretic_walk9 =[$her_run9, heretic_walk10]
{
	ai_walk(heretic_ws);
};
void() heretic_walk10 =[$her_run10, heretic_walk11]
{
	ai_walk(heretic_ws);
};
void() heretic_walk11 =[$her_run11, heretic_walk12]
{
	ai_walk(heretic_ws);
};
void() heretic_walk12 =[$her_run12, heretic_walk13]
{
	ai_walk(heretic_ws);
};
void() heretic_walk13 =[$her_run13, heretic_walk14]
{
	ai_walk(heretic_ws);
};
void() heretic_walk14 =[$her_run14, heretic_walk15]
{
	ai_walk(heretic_ws);
};
void() heretic_walk15 =[$her_run15, heretic_walk16]
{
	ai_walk(heretic_ws);
};
void() heretic_walk16 =[$her_run16, heretic_walk17]
{
	ai_walk(heretic_ws);
};
void() heretic_walk17 =[$her_run17, heretic_walk18]
{
	ai_walk(heretic_ws);
};
void() heretic_walk18 =[$her_run18, heretic_walk19]
{
	ai_walk(heretic_ws);
};
void() heretic_walk19 =[$her_run19, heretic_walk20]
{
	ai_walk(heretic_ws);
};
void() heretic_walk20 =[$her_run20, heretic_walk]
{
	ai_walk(heretic_ws);
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() heretic_sattack;
void() heretic_run;
void() heretic_attack;
void() heretic_srun;
void() heretic_endchase;

.float chasing;
void() heretic_subattack = 
{
	local entity head;

	head = findradius(rorigin(self), her_radius);	//send lightning line to anything in 250 radius
	while (head)	// while looking for head
	{
		if ((head.takedamage) && ((head.classname == "monster_fallen") || (head.classname == "monster_wraith") || (head.classname == "breakable_urn_large") || (head.classname == "breakable_urn_medium") || (head.classname == "breakable_urn_small") || (head.classname == "func_destruct")))	// if head has health, attack it
		{
			if (visibleb(rorigin(head), rorigin(self), self))
			{
				if (head != self)
					T_Damage(head, self, self, 220);	// its damage
			}
		}
		head = head.chain;	// go to next enemy
	}
};
.entity chase_enemy;

void(void() thinkst) heretic_checkchase = 
{
	

	if(self.enemy != self.chase_enemy)
	{
		self.velocity_z = 0;
		self.movingz = 0;
		self.movetype = self.oldmovetype;
		self.gravity = 1;
		self.think = heretic_endchase;
		self.nextthink = time + 0.1;
		return;
	}
	local vector	dir, vtemp;
	
	
	
	if((!self.enemy) && ((self.friendly_monster != 1)))
	{
	local entity pl;
	pl = find (world,classname, "player");
	if (self.enemy != pl)
		self.enemy = pl;
	}
	
	enemy_range = range(self.enemy);
	vtemp = self.enemy.origin + '0 0 38';


	if(self.timeangles2 < time)
	ai_face();
	float speed = vlen (self.velocity);
	if (speed < 20)
	check_angles();	
	
	if(self.flags & FL_ONGROUND)
		self.flags -= FL_ONGROUND;
	if (self.chasing == 1)
	{
		ai_face();
		local float heretic_runvel;
		heretic_runvel = heretic_rsr;
	}
	self.movingz = 1;
	self.movetype = MOVETYPE_FLYMISSILE;
	dir = normalize(vtemp - self.origin);
	self.velocity = dir * heretic_rsr;
	
	if(time > self.charge_time)
		self.think = heretic_endchase;
	else
	{	
		if (visible(self.enemy))
		{
			if (enemy_range == RANGE_FAR)
				self.think = heretic_endchase;
			if ((enemy_range == RANGE_MID) || (enemy_range == RANGE_NEAR))
			{
				self.think = thinkst;
			}
			if (enemy_range == RANGE_MELEE)
				self.think = heretic_sattack;
		}
		else
			self.think = heretic_endchase;
	}
	self.nextthink = time + 0.1;
}

void() heretic_srun8
{
	self.frame = $her_chase8;
	heretic_checkchase(heretic_srun);
	heretic_subattack();
};
void() heretic_srun7
{
	self.frame = $her_chase7;
	heretic_checkchase(heretic_srun8);
};
void() heretic_srun6
{
	self.frame = $her_chase6;
	heretic_checkchase(heretic_srun7);
};
void() heretic_srun5
{
	self.frame = $her_chase5;
	heretic_checkchase(heretic_srun6);
	heretic_subattack();
};
void() heretic_srun4
{
	self.frame = $her_chase4;
	heretic_checkchase(heretic_srun5);
};
void() heretic_srun3
{
	self.frame = $her_chase3;
	heretic_checkchase(heretic_srun4);
};
void() heretic_srun2
{
	self.frame = $her_chase2;
	heretic_checkchase(heretic_srun3);
	heretic_subattack();
};
void() heretic_srun
{
	heretic_checkchase(heretic_srun2);
	self.frame = $her_chase1;
	self.glowmod = '-1 -1 -1';
	self.chasing = 1;
	if (self.zigzaging != 0)
		self.zigzaging = 0;
	if (self.yaw_speed != 50)
		self.yaw_speed = 50;
};

void() heretic_endchase =[$her_echase1, heretic_endchase2]
{
	sound(self, CHAN_VOICE2, "enemies/heretic/end_chase.ogg", 1, 0.25);
	if (self.movingz)
	{
		self.velocity_z = 0;
		self.movingz = 0;
		self.movetype = self.oldmovetype;
		self.gravity = 1;
	}
};
void() heretic_endchase2 =[$her_echase2, heretic_endchase3] {};
void() heretic_endchase3 =[$her_echase3, heretic_endchase4] {};
void() heretic_endchase4 =[$her_echase4, heretic_endchase5] {};
void() heretic_endchase5 =[$her_echase5, heretic_run] {};

void() heretic_prechase =[$her_schase1, heretic_prechase2]
{
	self.chase_enemy = self.enemy;
	self.charge_time = time + her_chargetime;	
	monstersound6("enemies/heretic/chase_start", 5, CHAN_AUTO);
};
void() heretic_prechase2 =[$her_schase2, heretic_srun]
{
	sound(self, CHAN_VOICE2, "enemies/heretic/chase_loop.ogg", 1, 0.25);
};


void() heretic_checkrun = 
{
	if (self.runing_time > time)
		return;
	local float r;
	if (visible(self.enemy))
	{
		enemy_range = range(self.enemy);
		if (enemy_range == RANGE_FAR)
			return;
		if (enemy_range == RANGE_MID)
		{
			r = random() *100;
			if (heretic_rth >= r)
				self.think = heretic_attack;
		}
		if (enemy_range == RANGE_NEAR)
		{
			//local float r;
			//r = random() *100;
			//if(heretic_rth >= r)
			self.think = heretic_prechase;
		}
		if (enemy_range == RANGE_MELEE)
			self.think = heretic_sattack;
	}


	if (self.zigzaging == 0)
	{
		r = random() *100;
		if (heretic_zzc  >= r)
		{
			float zzmultiplier = random(heretic_zzmd,heretic_zzd) * crandom3();
			self.zigzagdeviance = zzmultiplier;
			self.zigzaging = 1;
		}
	}
	else
		self.zigzaging = 0;
		
	self.runing_time = time + heretic_rt;

};

void() heretic_run =[$her_run1, heretic_run2]
{

	self.glowmod = '-1 -1 -1';
	self.chasing = 0;
	if (self.gravity <= 0)
	{
		self.movetype = MOVETYPE_STEP;
		self.gravity = 1;
	}
	monstersound2("enemies/heretic/chatter", 5, CHAN_VOICE);
	ai_runwalk(heretic_rs);
	if (self.yaw_speed != 25)
		self.yaw_speed = 25;
	heretic_checkrun();
	heretic_subattack();
};
void() heretic_run2 =[$her_run2, heretic_run3]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run3 =[$her_run3, heretic_run4]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run4 =[$her_run4, heretic_run5]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
	heretic_subattack();
};
void() heretic_run5 =[$her_run5, heretic_run6]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run6 =[$her_run6, heretic_run7]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run7 =[$her_run7, heretic_run8]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
	heretic_subattack();
};
void() heretic_run8 =[$her_run8, heretic_run9]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run9 =[$her_run9, heretic_run10]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run10 =[$her_run10, heretic_run11]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
	heretic_subattack();
};
void() heretic_run11 =[$her_run11, heretic_run12]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run12 =[$her_run12, heretic_run13]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run13 =[$her_run13, heretic_run14]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
	heretic_subattack();
};
void() heretic_run14 =[$her_run14, heretic_run15]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run15 =[$her_run15, heretic_run16]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run16 =[$her_run16, heretic_run17]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
	heretic_subattack();
};
void() heretic_run17 =[$her_run17, heretic_run18]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run18 =[$her_run18, heretic_run19]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
	heretic_subattack();
};
void() heretic_run19 =[$her_run19, heretic_run20]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};
void() heretic_run20 =[$her_run20, heretic_run]
{
	ai_runwalk(heretic_rs);
	heretic_checkrun();
};

/*
void()	heretic_run1	=[	$her_run1,	heretic_run1	] 
{	

	ai_runwalk(heretic_rs);	
	self.colormod = ' 1 1 1';
	if(time > self.runing_time)
	{
		if((visible(self.enemy)))
		{
			enemy_range = range(self.enemy);
			if (enemy_range == RANGE_FAR)
			return; 
			if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
			{
				local float r;
			r = random() *100;
			if(heretic_rth >= r)
			self.think = heretic_preattack;
			else	
			self.runing_time = time + heretic_rt;
			}
			if (enemy_range == RANGE_MELEE)
			self.think = heretic_spreattack; 
			else
			self.runing_time = time + heretic_rt;
		}
	}
};
*/
/////////////////////////////////////////////////////////////////////////////////////////////projectile attack
.float chasetime;
void() proj_heretic_explo = 
{
	self.alpha -= 0.1;
	self.frame += 1;
	if (self.alpha < 0)
		self.think = SUB_Remove;
	else
		self.think = proj_heretic_explo;
	self.nextthink = time + 0.05;
}
void() projectile_touch_her = 
{
	local float damg;
	if (other == self.owner)
		return;
	if(other.solid == SOLID_TRIGGER)
		return;
	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	damg = heretic_ad;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}
	if ((other.classname == "player") && (other == self.owner.enemy) && (self.owner.health > 0))
	{
		if (self.owner.chasing != 1)
		{
			local entity oself;
			oself = self;
			self = self.owner;
			monstersound6("enemies/heretic/chase_start", 5, CHAN_AUTO);
			self = oself;
			sound(self.owner, CHAN_VOICE2, "enemies/heretic/chase_loop.ogg", 1, 0.25);
			self.owner.think = heretic_prechase;
			self.owner.nextthink = time;
		}
		//self = oself;
		//other.heretic_sloweffectime = time + 1;
	}
	sound(self, CHAN_WEAPON, "misc/null.wav", 1, 1);
	//void(string locsound, float rnd, float vol, float nchannel, float iswav, float atten) randomsound2
	randomsound2("enemies/heretic/proj_impact", 3, 1, CHAN_WEAPON, 0, 0.25);
	setmodel(self, "models/projectiles/proj_heretic_explo.md3");
	pointparticles(particleeffectnum("proj_heretic_impact"), self.origin, '0 0 0', 1);
	self.movetype = 0;
	self.alpha = 1;
	self.touch = SUB_Null;
	self.nextthink = time;
	self.think = proj_heretic_explo;
};


void()proj_heretic_explo_think =
{
	if(self.origin ==  self.oldorigin)
	{
		self.think = proj_heretic_explo;
	}
	else
	{
		if(self.lifetime < time)
			self.think = proj_heretic_explo;
		else
			self.think = proj_heretic_explo_think;
	}
	self.oldorigin = self.origin;
	self.nextthink = time + 0.1;
};	


void(vector org, vector dir, entity ownerproj) launch_projectile_her = 
{
	local entity projectile;
	projectile = spawn();
	projectile.owner = ownerproj;
	projectile.movetype = MOVETYPE_FLYMISSILE;
	projectile.solid = SOLID_TRIGGER;
	projectile.scale = 1;
	projectile.angles = vectoangles(dir);
	projectile.touch = projectile_touch_her;
	projectile.traileffectnum = particleeffectnum("proj_heretic_trail");
	projectile.classname = "projectile";
	projectile.think = proj_heretic_explo_think;
	projectile.nextthink = time + 0.1;
	projectile.lifetime = time + 12;
	projectile.classentity = "projectiles";
	projectile.wrathflags += FL_PROJECTILE;
	local entity oself;oself = self;self = projectile;
	randomsound2("enemies/heretic/proj_loop", 3, 1, CHAN_WEAPON, 0, 0.25);
	self = oself;
	setmodel(projectile, "models/projectiles/proj_heretic.md3");
	setsize(projectile, '-6 -6 -6', '6 6 6');
	makevectors(self.angles);
	//org -=v_forward*order ;
	setorigin(projectile, org);
	projectile.velocity = dir *(heretic_projvel);
	projectile.oldvelocity = projectile.velocity;
};

void() heretic_attack =[$her_atk1, heretic_attack2]
{
	monstersound3("enemies/heretic/attack", 3, CHAN_AUTO);
	ai_face();
	self.yaw_speed = 50;
	self.chasing = 0;
	self.glowmod = '0.25 0.25 0.25';
};
void() heretic_attack2 =[$her_atk2, heretic_attack3]
{
	ai_face();
	self.glowmod = '0.5 0.5 0.5';
};
void() heretic_attack3 =[$her_atk3, heretic_attack4]
{
	ai_face();
	self.glowmod = '0.75 0.75 0.75';
};
void() heretic_attack4 =[$her_atk4, heretic_attack5]
{
	if (self.health > 200)
		ai_face();
	self.glowmod = '1 1 1';

	if (visibleinfront(self.enemy, 4096))
	{
		local vector dir, tagorg;
		local float tagindex;
		tagindex = gettagindex(self, "tag_muzzle");
		tagorg = self.origin;	// gettaginfo(self.vweapon, tagindex);
		dir = aim(self, 1000);
		local vector sre;
		sre = self.angles;
		makevectors2(sre);
		dir = normalize(self.enemy.origin - tagorg);
		launch_projectile_her(tagorg, dir, self);
	}
};
void() heretic_attack5 = 
{
	self.frame = $her_atk5;
	self.glowmod = '0.5 0.5 0.5';

	if (visibleinfront(self.enemy, 4096))
	{
		enemy_range = range(self.enemy);
		if (enemy_range == RANGE_FAR)
			self.think = heretic_run;
		if (enemy_range == RANGE_MID)
		{
			local float r;
			r = random() *100;
			if (heretic_ath >= r)
				self.think = heretic_attack;
			else
				self.think = heretic_run;
		}

		if (enemy_range == RANGE_NEAR)
			self.think = heretic_prechase;

		if (enemy_range == RANGE_MELEE)
			self.think = heretic_attack;
	}
	else
		self.think = heretic_run;
	self.nextthink = time + 0.1;
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////melee attack

void(float wdmg) heretic_melee_attack = 
{
	local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);
	if (dist > (heretic_near + 16))
	{
		return;
	}
	else
	{
		
		local vector tagorg;
		local float tagindex;		
		tagindex = gettagindex(self, "tag_tongues");
		tagorg = gettaginfo(self, tagindex) + '0 0 0';
		T_Damage(self.enemy, self, self, wdmg);
		local vector bloodvel;
		bloodvel_x = crandom() * 64;
		bloodvel_y = crandom() * 64;
		bloodvel_z = random() * 128 + 64;
		
		SpawnBlood(tagorg, bloodvel, 0, 0, wdmg);
		if (random() < 0.2)
		decal_monster2(self.enemy.origin);
	}
	heretic_subattack();
};

void() heretic_sattack =[$her_batk1, heretic_sattack2]
{
	ai_face();
	monstersound4("enemies/heretic/bite", 3, CHAN_BODY);
	if(self.enemy.classname == "player")
	self.origin_z = self.enemy.origin_z + 22 + 16;
	if (self.movingz)
	{
		self.velocity_z = 0;
		self.movingz = 0;
		self.movetype = self.oldmovetype;
		self.gravity = 1;
	}
};
void() heretic_sattack2 =[$her_batk2, heretic_sattack3]
{
	ai_face();
	heretic_melee_attack(heretic_sad);
};
void() heretic_sattack3 =[$her_batk3, heretic_sattack4]
{
	ai_face();
};
void() heretic_sattack4 =[$her_batk4, heretic_sattack5]
{
	ai_face();
};
void() heretic_sattack5 =[$her_batk5, heretic_run]
{
	enemy_range = range(self.enemy);
	if (enemy_range == RANGE_MELEE)
		self.think = heretic_sattack;
	else
		self.think = heretic_run;
	ai_face();
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() heretic_postpain = 
{
	ai_pain(4);
	local float r;
	r = random() *100;
	if (heretic_pth <= r)
		self.think = heretic_run;
	else
		self.think = heretic_attack;

	self.pain_finished = time + heretic_pt;
	self.nextthink = time + 0.1;
};

void() heretic_paina =[$her_paina1, heretic_paina2] {};
void() heretic_paina2 =[$her_paina2, heretic_paina3] {};
void() heretic_paina3 =[$her_paina3, heretic_paina4] {};
void() heretic_paina4 =[$her_paina4, heretic_paina5] {};
void() heretic_paina5 =[$her_paina5, heretic_postpain]
{
	self.nextthink = time;
};

void() heretic_painb =[$her_painb1, heretic_painb2] {};
void() heretic_painb2 =[$her_painb2, heretic_painb3] {};
void() heretic_painb3 =[$her_painb3, heretic_painb4] {};
void() heretic_painb4 =[$her_painb4, heretic_painb5] {};
void() heretic_painb5 =[$her_painb5, heretic_postpain]
{
	self.nextthink = time;
};

void() heretic_painc =[$her_painc1, heretic_painc2] {};
void() heretic_painc2 =[$her_painc2, heretic_painc3] {};
void() heretic_painc3 =[$her_painc3, heretic_painc4] {};
void() heretic_painc4 =[$her_painc4, heretic_painc5] {};
void() heretic_painc5 =[$her_painc5, heretic_postpain]
{
	self.nextthink = time;
};

void() heretic_paind =[$her_paind1, heretic_paind2] {};
void() heretic_paind2 =[$her_paind2, heretic_paind3] {};
void() heretic_paind3 =[$her_paind3, heretic_paind4] {};
void() heretic_paind4 =[$her_paind4, heretic_paind5] {};
void() heretic_paind5 =[$her_paind5, heretic_postpain]
{
	self.nextthink = time;
};

void(entity enemy, float dmg) heretic_pain = 
{ 

	if(self.warped == 1)
	return;
	if (self.movingz)
	{
		self.velocity_z = 0;
		self.movingz = 0;
		self.movetype = self.oldmovetype;
		self.gravity = 1;
	}		
	self.glowmod = '-1 -1 -1';
	local float rp;
	rp = random() *100;
	if (heretic_rtp <= rp)
		return;
	self.sustained_damage = 0;
	local float rpf;
	rpf = floor(random() *4) + 1;
	if (rpf == self.painanim)
		rpf += 1;
	if (rpf > 4)
		rpf = 1;
	self.painanim = rpf;
	if (self.painanim == 1)
		self.think = heretic_paina;
	if (self.painanim == 2)
		self.think = heretic_painb;
	if (self.painanim == 3)
		self.think = heretic_painc;
	if (self.painanim == 4)
		self.think = heretic_paind;
	self.nextthink = time + 0.1;
	sound(self, CHAN_VOICE2, "misc/null.wav", 1, 1);
	monstersound4("enemies/heretic/pain", 5, CHAN_BODY);
};

///////////////////////////////////////////////////////////////////////////////////////////
void() tonge_think = 
{
	if (self.owner.classname != "monster_heretic")
		remove(self);

	if (self.owner.health < 0)
		remove(self);

	self.think = tonge_think;
	self.nextthink = time + 0.025;
}

void() heretic_diea1 = 
{
	self.solid = 0;
	self.takedamage = 0;
	drop_item(self.origin + '0 0 40', "fangs", 10, self);
	decal_monster_gib(self.origin);
	self.alpha = -1;
	self.flags = 0;
	self.movetype = 0;
	self.th_stand = null;
	self.th_walk = null;
	self.th_run = null;
	self.th_missile = null;
	self.th_melee = null;
	self.th_pain = nullpain;
	self.th_die = null;
	setsize(self, '0 0 0', '0 0 0');
	/*
	tag_backa        gib_backa                    (right vel)
	tag_backb        gib_backb                    (left vel)
	tag_heada        gib_heada                    (forward vel)
	tag_headb        gib_headb                    (right vel)    
	tag_headc        gib_headc                    (left vel)
	tag_jawa        gib_jawa                    (forward vel)
	tag_jawb        gib_jawb                    (right vel)
	tag_jawc        gib_jawc                    (left vel)
	tag_muzzle        proj_heretic                    
	tag_tongues        gib_tongue_left, gib_tongue_right    (left and right vel)
	*/
	local vector tagorg;
	tagorg = tag_origin("tag_backa", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_backa.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib1, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_backb", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_backb.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib2, self), 0, 3);	// relvel: forward, right, up

	tagorg = tag_origin("tag_heada", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_heada.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib3, self), 1, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_headb", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_headb.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib4, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_headc", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_headc.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib5, self), 0, 3);	// relvel: forward, right, up

	tagorg = tag_origin("tag_jawa", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_jawa.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib6, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_jawb", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_jawb.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib7, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_jawc", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_jawc.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib8, self), 0, 3);	// relvel: forward, right, up

	tagorg = tag_origin("tag_tonges", self);
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_tongue_left.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib9, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/enemies/heretic/gibs/gib_tongue_right.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(her_gib10, self), 0, 3);	// relvel: forward, right, up

	//void(string gibname, float dm, float gravitygib, float bstop, float scalegib) ThrowGib 

	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib11, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib12, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib13, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib14, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib15, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(her_gib16, self), 0, 3);	// relvel: forward, right, up
	sound(self, CHAN_VOICE2, "misc/null.wav", 1, 1);
	monstersound5("enemies/heretic/die", 3, CHAN_VOICE);
	explo_blood(3, tagorg);
	explo_blood(7, tagorg);
	pointparticles(particleeffectnum("heretic_bloodshower"), self.origin + '0 0 12', '0 0 0', 1);
	self.think = SUB_Remove;
	self.nextthink = time + 1;
};

///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_heretic (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() precache_monster_heretic = 
{
	precache_model("models/enemies/heretic/heretic.md3");
	precache_model("models/enemies/heretic/tongues.md3");
	precache_model("models/projectiles/proj_heretic_explo.md3");
	precache_model("models/enemies/heretic/gibs/gib_backa.md3");
	precache_model("models/enemies/heretic/gibs/gib_backb.md3");
	precache_model("models/enemies/heretic/gibs/gib_heada.md3");
	precache_model("models/enemies/heretic/gibs/gib_headb.md3");
	precache_model("models/enemies/heretic/gibs/gib_headc.md3");
	precache_model("models/enemies/heretic/gibs/gib_jawa.md3");
	precache_model("models/enemies/heretic/gibs/gib_jawb.md3");
	precache_model("models/enemies/heretic/gibs/gib_jawc.md3");
	precache_model("models/enemies/heretic/gibs/gib_tongue_left.md3");
	precache_model("models/enemies/heretic/gibs/gib_tongue_right.md3");
	precache_model("particles/explo/explo_heretic.md3");
	precache_model("models/projectiles/proj_heretic.md3");
	precache_sound("enemies/heretic/idle1.ogg");
	precache_sound("enemies/heretic/idle2.ogg");
	precache_sound("enemies/heretic/idle3.ogg");
	precache_sound("enemies/heretic/chatter1.ogg");
	precache_sound("enemies/heretic/chatter2.ogg");
	precache_sound("enemies/heretic/chatter3.ogg");
	precache_sound("enemies/heretic/chatter4.ogg");
	precache_sound("enemies/heretic/chatter5.ogg");
	precache_sound("enemies/heretic/attack1.ogg");
	precache_sound("enemies/heretic/attack2.ogg");
	precache_sound("enemies/heretic/attack3.ogg");
	precache_sound("enemies/heretic/bite1.ogg");
	precache_sound("enemies/heretic/bite2.ogg");
	precache_sound("enemies/heretic/bite3.ogg");
	precache_sound("enemies/heretic/pain1.ogg");
	precache_sound("enemies/heretic/pain2.ogg");
	precache_sound("enemies/heretic/pain3.ogg");
	precache_sound("enemies/heretic/pain4.ogg");
	precache_sound("enemies/heretic/pain5.ogg");
	precache_sound("enemies/heretic/sight1.ogg");
	precache_sound("enemies/heretic/sight2.ogg");
	precache_sound("enemies/heretic/sight3.ogg");
	precache_sound("enemies/heretic/die1.ogg");
	precache_sound("enemies/heretic/die2.ogg");
	precache_sound("enemies/heretic/die3.ogg");
	precache_sound("enemies/heretic/proj_impact1.ogg");
	precache_sound("enemies/heretic/proj_impact2.ogg");
	precache_sound("enemies/heretic/proj_impact3.ogg");
	precache_sound("enemies/heretic/proj_loop1.ogg");
	precache_sound("enemies/heretic/proj_loop2.ogg");
	precache_sound("enemies/heretic/proj_loop3.ogg");
	precache_sound("enemies/heretic/chase_start1.ogg");
	precache_sound("enemies/heretic/chase_start2.ogg");
	precache_sound("enemies/heretic/chase_start3.ogg");
	precache_sound("enemies/heretic/chase_start4.ogg");
	precache_sound("enemies/heretic/chase_start5.ogg");
	precache_sound("enemies/heretic/chase_loop.ogg");
	precache_sound("enemies/heretic/end_chase.ogg");
};

void() monster_heretic = 
{
	precache_model("models/projectiles/proj_heretic.md3");
	precache_model("models/enemies/heretic/heretic.md3");
	precache_model("models/enemies/heretic/tongues.md3");
	precache_model("models/projectiles/proj_heretic_explo.md3");
	precache_model("models/enemies/heretic/gibs/gib_backa.md3");
	precache_model("models/enemies/heretic/gibs/gib_backb.md3");
	precache_model("models/enemies/heretic/gibs/gib_heada.md3");
	precache_model("models/enemies/heretic/gibs/gib_headb.md3");
	precache_model("models/enemies/heretic/gibs/gib_headc.md3");
	precache_model("models/enemies/heretic/gibs/gib_jawa.md3");
	precache_model("models/enemies/heretic/gibs/gib_jawb.md3");
	precache_model("models/enemies/heretic/gibs/gib_jawc.md3");
	precache_model("models/enemies/heretic/gibs/gib_tongue_left.md3");
	precache_model("models/enemies/heretic/gibs/gib_tongue_right.md3");
	precache_model("particles/explo/explo_heretic.md3");
	local float r;
	r = (random() *3);
	if (r <= 3)
		self.noise = "enemies/heretic/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/heretic/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/heretic/sight1.ogg";
	if (deathmatch)
	{
		remove(self);
		return;
	}
	if (self.waypointed != 1)
		self.waypointed = 0;
	self.flyer = 1;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	self.oldmovetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/heretic/heretic.md3");
	setsize(self, heretic_bbox *-0.5, heretic_bbox *0.5);
	self.health = heretic_health;
	self.damagetopain = heretic_dtp;
	self.classname = "monster_heretic";
	self.th_stand = heretic_idle;
	self.th_walk = heretic_walk;
	self.th_run = heretic_run;
	self.th_missile = heretic_attack;
	self.th_melee = heretic_sattack;
	self.gravity = -0.01;
	self.th_pain = heretic_pain;
	self.th_die = heretic_diea1;
	self.yaw_speed =50;	
	self.glowmod = '-1 -1 -1';
	self.bloody = 1;
	self.yaw_speed = 5;
	local entity tonge;
	tonge = spawn();
	tonge.owner = self;
	setmodel(tonge, "models/enemies/heretic/tongues.md3");
	setattachment(tonge, self, "tag_tongues");
	tonge.think = tonge_think;
	tonge.nextthink = time;
	self.think = flymonster_start;
	self.nextthink = time + 0.05;
};

////////////////end of qc file