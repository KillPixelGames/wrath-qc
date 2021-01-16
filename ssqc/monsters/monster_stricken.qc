/*
==============================================================================

stricken

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

$frame str_idle1 str_idle2 str_idle3 str_idle4 str_idle5 str_idle6 str_idle7 str_idle8 str_idle9 str_idle10 str_idle11 str_idle12 str_idle13 str_idle14 str_idle15 str_idle16 str_idle17 str_idle18 str_idle19 str_idle20

$frame str_run1 str_run2 str_run3 str_run4 str_run5 str_run6 str_run7 str_run8 str_run9 str_run10

$frame str_patk1 str_patk2 str_patk3 str_patk4 str_patk5

$frame str_atk1 str_atk2 str_atk3 str_atk4 str_atk5 str_atk6 str_atk7 str_atk8 str_atk9 str_atk10

$frame str_spatk1 str_spatk2

$frame str_satk1 str_satk2 str_satk3 str_satk4 str_satk5 str_satk6 str_satk7 str_satk8 str_satk9 str_satk10

$frame str_paina1 str_paina2 str_paina3 str_paina4 str_paina5 str_paina6 str_paina7 str_paina8 str_paina9 str_paina10

$frame str_painb1 str_painb2 str_painb3 str_painb4 str_painb5 str_painb6 str_painb7 str_painb8 str_painb9 str_painb10

$frame str_painc1 str_painc2 str_painc3 str_painc4 str_painc5 str_painc6 str_painc7 str_painc8 str_painc9 str_painc10

$frame str_death1

	.float runing_time;
/////////////////////////////////////////////////////////////////////////////////////////////
void() stricken_preattack1;
void() stricken_spreattack1;
void() stricken_sattack1;
/////////////////////////////////////////////////////////////////////////////////////////////
void() stricken_stand1 =[$str_idle1, stricken_stand2]
{
	ai_stand();
	if (!(self.spawnflags &1))
		monstersound1("enemies/stricken/idle", 3, CHAN_BODY);
};
void() stricken_stand2 =[$str_idle2, stricken_stand3]
{
	ai_stand();
};
void() stricken_stand3 =[$str_idle3, stricken_stand4]
{
	ai_stand();
};
void() stricken_stand4 =[$str_idle4, stricken_stand5]
{
	ai_stand();
};
void() stricken_stand5 =[$str_idle5, stricken_stand6]
{
	ai_stand();
};
void() stricken_stand6 =[$str_idle6, stricken_stand7]
{
	ai_stand();
};
void() stricken_stand7 =[$str_idle7, stricken_stand8]
{
	ai_stand();
};
void() stricken_stand8 =[$str_idle8, stricken_stand9]
{
	ai_stand();
};
void() stricken_stand9 =[$str_idle9, stricken_stand10]
{
	ai_stand();
};
void() stricken_stand10 =[$str_idle10, stricken_stand11]
{
	ai_stand();
};
void() stricken_stand11 =[$str_idle11, stricken_stand12]
{
	ai_stand();
};
void() stricken_stand12 =[$str_idle12, stricken_stand13]
{
	ai_stand();
};
void() stricken_stand13 =[$str_idle13, stricken_stand14]
{
	ai_stand();
};
void() stricken_stand14 =[$str_idle14, stricken_stand15]
{
	ai_stand();
};
void() stricken_stand15 =[$str_idle15, stricken_stand16]
{
	ai_stand();
};
void() stricken_stand16 =[$str_idle16, stricken_stand17]
{
	ai_stand();
};
void() stricken_stand17 =[$str_idle17, stricken_stand18]
{
	ai_stand();
};
void() stricken_stand18 =[$str_idle18, stricken_stand19]
{
	ai_stand();
};
void() stricken_stand19 =[$str_idle19, stricken_stand20]
{
	ai_stand();
};
void() stricken_stand20 =[$str_idle20, stricken_stand1]
{
	ai_stand();
};

void()stricken_choose_attack =
{
	enemy_range = range(self.enemy);
	if (enemy_range == RANGE_MELEE)
		self.think = stricken_spreattack1;
	else	
		self.think = stricken_preattack1;
	self.nextthink = time;
};

void()	stricken_waiting1	=[	$str_idle1,	stricken_waiting2	] {if((!(self.enemy)) && (self.goalentity))self.enemy = self.goalentity;if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face();monstersound1("enemies/stricken/idle",3,CHAN_BODY); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting2	=[	$str_idle2,	stricken_waiting3	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting3	=[	$str_idle3,	stricken_waiting4	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting4	=[	$str_idle4,	stricken_waiting5	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting5	=[	$str_idle5,	stricken_waiting6	] {if (visible (self.enemy))  {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting6	=[	$str_idle6,	stricken_waiting7	] {if((!(self.enemy)) && (self.goalentity))self.enemy = self.goalentity;if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting7	=[	$str_idle7,	stricken_waiting8	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting8	=[	$str_idle8,	stricken_waiting9	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting9	=[	$str_idle9,	stricken_waiting10	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting10	=[	$str_idle10,	stricken_waiting11	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();		if(!self.enemy.health) 
		next_enemy();}; 
void()	stricken_waiting11	=[	$str_idle11,	stricken_waiting12	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting12	=[	$str_idle12,	stricken_waiting13	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting13	=[	$str_idle13,	stricken_waiting14	] {if((!(self.enemy)) && (self.goalentity))self.enemy = self.goalentity;if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting14	=[	$str_idle14,	stricken_waiting15	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting15	=[	$str_idle15,	stricken_waiting16	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting16	=[	$str_idle16,	stricken_waiting17	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting17	=[	$str_idle17,	stricken_waiting18	] {if((!(self.enemy)) && (self.goalentity))self.enemy = self.goalentity;if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting18	=[	$str_idle18,	stricken_waiting19	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting19	=[	$str_idle19,	stricken_waiting20	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();}; 
void()	stricken_waiting20	=[	$str_idle20,	stricken_waiting1	] {if (visible (self.enemy)) {self.think = stricken_choose_attack; self.nextthink =time + 0.1; return; }ai_face(); if(self.friendly_monster == 1) ai_stand();		if(!self.enemy.health) 
		next_enemy();
}; 

/////////////////////////////////////////////////////////////////////////////////////////////
void() stricken_walk1 =[$str_run1, stricken_walk2]
{
	ai_walk(20);
	self.rollwalktoattack = wretch_wth;
	monstersound5("enemies/stricken/chatter", 3, CHAN_VOICE);
};
void() stricken_walk2 =[$str_run2, stricken_walk3]
{
	ai_walk(20);
};
void() stricken_walk3 =[$str_run3, stricken_walk4]
{
	ai_walk(20);
};
void() stricken_walk4 =[$str_run4, stricken_walk5]
{
	ai_walk(20);
	monstersound2("enemies/stricken/step", 5, CHAN_BODY);
};
void() stricken_walk5 =[$str_run5, stricken_walk6]
{
	ai_walk(20);
};
void() stricken_walk6 =[$str_run6, stricken_walk7]
{
	ai_walk(20);
};
void() stricken_walk7 =[$str_run7, stricken_walk8]
{
	ai_walk(20);
};
void() stricken_walk8 =[$str_run8, stricken_walk9]
{
	ai_walk(20);
};
void() stricken_walk9 =[$str_run9, stricken_walk10]
{
	ai_walk(20);
	monstersound2("enemies/stricken/step", 5, CHAN_BODY);
};
void() stricken_walk10 =[$str_run10, stricken_walk1]
{
	self.findtargettime = time + 0.1;
	ai_walk(20);
};

/////////////////////////////////////////////////////////////////////////////////////////////

void(vector org) stricken_dust = 
{
	local vector org2;
	traceline(org, org + '0 0 320', TRUE, self);
	if (trace_fraction != 1)
	{
		org2 = trace_endpos;
		pointparticles(particleeffectnum("stricken_dust"), org2, '0 0 0', 1);	//(float effectnum, vector org, vector vel, float howmany) pointparticles
	}
};

void() stricken_subattack = 
{
	local entity head;

	head = findradius(self.origin + '0 0 10', stricken_walkradius);	//send lightning line to anything in 250 radius
	while (head)	// while looking for head
	{
		if ((head.takedamage) && ((head.classname == "monster_fallen") || (head.classname == "monster_wraith") || (head.classname == "breakable_urn_large") || (head.classname == "breakable_urn_medium") || (head.classname == "breakable_urn_small") || (head.classname == "func_destruct")))	// if head has health, attack it
		{
			if (visibleb(rorigin(head), rorigin(self), self))
			{
				//if(head != self)
				T_Damage(head, self, self, 220);	// its damage
			}
		}

		head = head.chain;	// go to next enemy
	}
};

void() stricken_run1 =[$str_run1, stricken_run2]
{
	self.velocity = '0 0 0';
	ai_runwalk(20);
	stricken_subattack();
	monstersound5("enemies/stricken/chatter", 3, CHAN_VOICE);
};
void() stricken_run2 =[$str_run2, stricken_run3]
{
	ai_runwalk(20);
	stricken_subattack();
};
void() stricken_run3 =[$str_run3, stricken_run4]
{
	ai_runwalk(20);
	stricken_subattack();
};
void() stricken_run4 =[$str_run4, stricken_run5]
{
	ai_runwalk(20);
	monstersound2("enemies/stricken/step", 5, CHAN_BODY);
	stricken_subattack();
};
void() stricken_run5 =[$str_run5, stricken_run6]
{
	ai_runwalk(20);
	stricken_subattack();
};
void() stricken_run6 =[$str_run6, stricken_run7]
{
	ai_runwalk(20);
	stricken_subattack();
};
void() stricken_run7 =[$str_run7, stricken_run8]
{
	ai_runwalk(20);
	stricken_subattack();
};
void() stricken_run8 =[$str_run8, stricken_run9]
{
	ai_runwalk(20);
	monstersound2("enemies/stricken/step", 5, CHAN_BODY);
	stricken_subattack();
};
void() stricken_run9 =[$str_run9, stricken_run10]
{
	ai_runwalk(20);
	stricken_subattack();
};
void() stricken_run10 =[$str_run10, stricken_run1]
{
	local float r;
	ai_runwalk(20);
	
	if( (self.enemy) &&(!self.enemy.health))
	next_enemy();

	
	stricken_subattack();

	if (self.zigzaging == 0)
	{
		r = random() *100;
		if (stricken_zzc  >= r)
		{
			float zzmultiplier = random(stricken_zzmd,stricken_zzd) * crandom3();
			self.zigzagdeviance = zzmultiplier;
			self.zigzaging = 1;
		}
	}
	else
		self.zigzaging = 0;
		
		
	if ((rvisible(self.enemy)))
	{
		enemy_range = range(self.enemy);
		if (enemy_range == RANGE_MELEE)
		{
			self.think = stricken_spreattack1;
			return;
		}
		if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
		{
			r = random() *100;
			if (stricken_rth >= r)
				self.think = stricken_preattack1;
		}

	}
};

/////////////////////////////////////////////////////////////////////////////////////////////projectile attack
void() projectile_touch_str = 
{
	local float damg;
	if (other == self.owner)
		return;
	if(other.solid == SOLID_TRIGGER)
		return;
	//	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = stricken_ad;
	if (other.health)
	{
		if (other.flags &FL_MONSTER)
			T_Damage(other, self, self.owner, stricken_damagetomonsters);
		else
			T_Damage(other, self, self.owner, damg);
		Cyxplode(self.cnt, 0);
		return;
	}

	local string snd;
	snd = strcat("impact/projectiles/cyst_bounce", ftos(floor(random() *5) + 1), ".ogg");
	sound(self, CHAN_AUTO, snd, 1, 0.25);
};
void() projectile_touch_str2 = 
{
	if(other.solid == SOLID_TRIGGER)
		return;
	//	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if (other.classname == "player")
		T_Damage(other, self, world, stricken_ad);
	else
		T_Damage(other, self, world, stricken_damagetomonsters);
	Cyxplode(0, 0);
		remove(self);
};

void() CheckCysStricken = 
{
	
	if (self.flags &FL_ONGROUND)
	{
		self.traileffectnum = particleeffectnum("null");
	}
	else
		self.traileffectnum = particleeffectnum("retchertrail");
	local float distancedelta;
	distancedelta = vlen(self.enemy.origin - self.origin);
	if (distancedelta < 24)
		self.lifetime = 0;
	if (self.lifetime < time)
		self.think = PreCyExplosion;
	else
		self.think = CheckCys;
	self.nextthink = time + 0.05;
};

void(entity ownr) strickenprojectile = 
{
	local vector org;
	local float tagindex;
	monstersound1("enemies/stricken/cyst", 3, CHAN_AUTO);
	tagindex = gettagindex(ownr, "tag_mouth");
	org = gettaginfo(ownr, tagindex);
	local vector distancedelta;
	local vector nozdistancedelta;
	local entity missile;
	ownr.effects = ownr.effects;	//| EF_MUZZLEFLASH;
	missile = spawn();
	missile.classentity = "projectiles";
	missile.owner = ownr;
	missile.wrathflags += FL_PROJECTILE;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_TRIGGER;
	makevectors(ownr.angles);
	distancedelta = ownr.enemy.origin - ownr.origin;
	nozdistancedelta = distancedelta;
	nozdistancedelta_z = 0;
	missile.velocity = normalize(distancedelta);
	missile.velocity = missile.velocity * stricken_projvel;
	if (vlen(nozdistancedelta) > 1024)
	missile.gravity = 1 - (vlen(nozdistancedelta) / 1024) * 0.1;
	missile.velocity_z = missile.velocity_z + 120 + vlen(nozdistancedelta) *0.15 *(1 + (0.15));
	missile.avelocity = '300 300 300';
	missile.enemy = missile.owner.enemy;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = projectile_touch_str;
	missile.traileffectnum = particleeffectnum("stricken_cyst_trail");
	setmodel(missile, "models/projectiles/proj_cyst.md3");
	missile.scale = 2;
	missile.lifetime = time + 5;
	missile.think = CheckCysStricken;
	missile.nextthink = time;
	setsize(missile, '0 0 0', '0 0 0');
	setorigin(missile, org);
};

void(entity ownr, float spread) strickenprojectile2 = 
{
	local vector org;
	local float tagindex;
	monstersound1("enemies/stricken/cyst", 3, CHAN_AUTO);
	tagindex = gettagindex(ownr, "tag_mouth");
	org = gettaginfo(ownr, tagindex);
	local float distance;
	local vector nozdistancedelta, distancedelta;
	local entity missile;
	ownr.effects = ownr.effects;	//| EF_MUZZLEFLASH;
	missile = spawn();
	missile.classentity = "projectiles";
	missile.owner = ownr;
	missile.wrathflags += FL_PROJECTILE;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	makevectors(ownr.angles);
	local vector morg;
	morg = v_right *stricken_spreadintensity * spread;

	distancedelta = (ownr.enemy.origin) - (ownr.origin + morg);	//work out distance vector  
	nozdistancedelta = distancedelta;	//copy to no height distance vector 
	nozdistancedelta_z = 0;	//remove height 
	missile.velocity = normalize(distancedelta);	//set the velocity to the distance
	missile.velocity = missile.velocity * stricken_projvel;	//give it more power 

	distance = vlen(ownr.enemy.origin - ownr.origin);
	if (distance > 1024)
		missile.velocity_z = missile.velocity_z + 120 + vlen(nozdistancedelta) *0.25;
	else
		missile.velocity_z = missile.velocity_z + 120 + vlen(nozdistancedelta) *0.15 *(1 + (0.18));
	missile.lifetime = time + 5;

	missile.avelocity = '300 300 300';
	missile.enemy = missile.owner.enemy;
	missile.angles = vectoangles(missile.velocity);
	missile.touch = projectile_touch_str2;
	missile.traileffectnum = particleeffectnum("stricken_cyst_trail");
	setmodel(missile, "models/projectiles/proj_cyst.md3");
	missile.scale = 2;
	missile.think = CheckCys;
	missile.nextthink = time;
	setsize(missile, '0 0 0', '0 0 18');
	setorigin(missile, org);
};

void() stricken_attack2;
void() stricken_attack1 =[$str_atk1, stricken_attack1a]
{
	ai_face();
	self.nextthink = time + 0.033;

	monstersound3("enemies/stricken/attack", 3, CHAN_WEAPON);

};
void() stricken_attack1b = 
{
	ai_face();self.think = stricken_attack2;self.nextthink = time + 0.033;
};
void() stricken_attack1a = 
{
	ai_face();self.think = stricken_attack1b;self.nextthink = time + 0.033;
};
void() stricken_attack2 =[$str_atk2, stricken_attack3]
{
	ai_face();
	if (self.health <= stricken_lowhealth)
		strickenprojectile2(self, 0);
	else
		strickenprojectile(self);
};
void() stricken_attack3 =[$str_atk3, stricken_attack4]
{
	ai_face();
	if (self.health <= stricken_lowhealth)
		strickenprojectile2(self, -1);
};
void() stricken_attack4 =[$str_atk4, stricken_attack5]
{
	ai_face();
	if (self.health <= stricken_lowhealth)
		strickenprojectile2(self, 1);
};
void() stricken_attack5 =[$str_atk5, stricken_attack6]
{
	ai_face();
};
void() stricken_attack6 =[$str_atk6, stricken_attack7]
{
	ai_face();
};
void() stricken_attack7 =[$str_atk7, stricken_attack8]
{
	ai_face();
};
void() stricken_attack8 =[$str_atk8, stricken_attack9]
{
	ai_face();
};
void() stricken_attack9 =[$str_atk9, stricken_attack10]
{
	ai_face();
};
void() stricken_attack10 =[$str_atk10, stricken_attack1]
{
	ai_face();
	self.velocity = '0 0 0';
		if( (self.enemy) &&(!self.enemy.health))
		{
		self.nextenemy_time = 0;
		next_enemy();
		self.think = stricken_run1;
		return;
		}

	if (!self.turret)
	{
	if ( (self.enemy.health > 0) && (visibleinfront(self.enemy, 4096)))
		{
			enemy_range = range(self.enemy);
			if (enemy_range == RANGE_FAR)
				self.think = stricken_run1;
			if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
			{
				local float r;
				r = random() *100;
				if (stricken_ath <= r)
					self.think = stricken_run1;
			}

			if (enemy_range == RANGE_MELEE)
				self.think = stricken_spreattack1;
		}
		else
		{
			self.think = stricken_run1;
		}
	}
	else
	{		
		if ( (self.enemy.health) && (visibleinfront(self.enemy, 4096)))
			self.think = stricken_attack1;
		else
			self.think = stricken_waiting1;
	}
};

void() stricken_preattack1 =[$str_patk1, stricken_preattack2]
{
	ai_face();
	sound(self, CHAN_AUTO, "enemies/stricken/preattack.ogg", 1, 0.25);
};
void() stricken_preattack2 =[$str_patk2, stricken_preattack3]
{
	ai_face();
};
void() stricken_preattack3 =[$str_patk3, stricken_preattack4]
{
	ai_face();
};
void() stricken_preattack4 =[$str_patk4, stricken_preattack5]
{
	ai_face();
};
void() stricken_preattack5 =[$str_patk5, stricken_attack1]
{
	ai_face();
	enemy_range = range(self.enemy);
	if (enemy_range == RANGE_MELEE)
		self.think = stricken_spreattack1;
	self.nextthink = time + 0.1;
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////melee attack

void(float wdmg) stricken_melee_attack = 
{
	local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);
	if (dist > stricken_near)
	{
		return;
	}
	else
	{
		T_Damage(self.enemy, self, self, wdmg);
	}
};

void() stricken_sattack1 =[$str_satk1, stricken_sattack2]
{
	ai_face();
	monstersound3("enemies/stricken/bite", 3, CHAN_WEAPON);
};
void() stricken_sattack2 =[$str_satk2, stricken_sattack3]
{
	ai_face();
	stricken_melee_attack(stricken_sad);
};
void() stricken_sattack3 =[$str_satk3, stricken_sattack4]
{
	ai_face();
};
void() stricken_sattack4 =[$str_satk4, stricken_sattack5]
{
	ai_face();
};
void() stricken_sattack5 =[$str_satk5, stricken_sattack6]
{
	ai_face();
};
void() stricken_sattack6 =[$str_satk6, stricken_sattack7]
{
	ai_face();
};
void() stricken_sattack7 =[$str_satk7, stricken_sattack8]
{
	ai_face();
};
void() stricken_sattack8 =[$str_satk8, stricken_sattack9]
{
	ai_face();
};
void() stricken_sattack9 =[$str_satk9, stricken_sattack10]
{
	ai_face();
};
void() stricken_sattack10 =[$str_satk10, stricken_run1]
{
	ai_face();
	enemy_range = range(self.enemy);
	if ((enemy_range == RANGE_MELEE) && (self.turret != 1))
		self.think = stricken_sattack1;
	else
		self.think = stricken_run1;
};

void() stricken_spreattack1 =[$str_spatk1, stricken_spreattack2]
{
	ai_face();
};
void() stricken_spreattack2 =[$str_spatk2, stricken_sattack1]
{
	ai_face();
};

/////////////////////////////////////////////////////////////////////////////////////////////

void() stricken_postpain = 
{
	self.painframe += 1;

	self.frame += 1;
	ai_face();
	//ai_pain(4);
	if (self.painframe >= 10)
	{
		self.painframe = 0;
		local float r;
		r = random() *100;
		if (stricken_pth >= r)
		{
			if (visibleinfront(self.enemy, 4096))
				self.think = stricken_attack1;
			else
			{
				if (self.turret >= 1)
					self.think = stricken_waiting1;
				else
					self.think = stricken_preattack1;
			}
		}
		else
			self.think = stricken_run1;
	}
	else
		self.think = stricken_postpain;

	self.nextthink = time + 0.1;

};
.float painanim;
void(entity enemy, float dmg) stricken_pain = 
{
	if (self.pain_finished > time)
		return;
	if(enemy.weapon != IT_BOIL)
	{
	local float rp;
	rp = random() *100;
	if (stricken_rtp <= rp)
		return;
	}
	if(enemy.flags & FL_MONSTER)
		{
		self.pain_finished = time + 1.75;
		if(self.turret >= 1)
		return;// prevent get stuck
		}
	else
		self.pain_finished = time + 0.25;	// 1.75
	
	self.sustained_damage = 0;
	local float rpf;
	rpf = floor(random() *3) + 1;
	if (rpf == self.painanim)
		rpf += 1;
	if (rpf > 3)
		rpf = 1;
	self.painanim = rpf;
	if (rpf == 1)
	{
		self.frame = $str_paina1;
		self.painanim = 1;
	}

	if (rpf == 2)
	{
		self.frame = $str_painb1;
		self.painanim = 2;
	}

	if (rpf == 3)
	{
		self.frame = $str_painc1;
		self.painanim = 3;
	}

	self.painframe = 1;
	monstersound4("enemies/stricken/pain", 3, CHAN_VOICE);
	self.think = stricken_postpain;
	self.nextthink = time + 0.1;

};

///////////////////////////////////////////////////////////////////////////////////////////
void() stricken_diea1 = 
{
	drop_item(self.origin + '0 0 40', "cyst", 2, self);
	decal_monster_gib(self.origin + '0 0 12');
	self.solid = 0;
	self.takedamage = 0;
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

	local vector tagorg;
	tagorg = tag_origin("tag_arm_l_a", self);
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_arm_l_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib1, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_l_b", self);
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_arm_l_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib2, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_r_a", self);
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_arm_r_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib3, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_r_b", self);
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_arm_r_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib4, self), 0, 3);	// relvel: forward, right, up

	tagorg = tag_origin("tag_head", self);
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib5, self), 1, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_jaw", self);
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_jaw.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib6, self), 0, 3);	// relvel: forward, right, up

	tagorg = tag_origin("tag_sides", self);
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_side_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib7, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_side_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib8, self), 0, 3);	// relvel: forward, right, up

	tagorg = tag_origin("tag_tail", self);
	ThrowGib3(self, "models/enemies/stricken/gibs/gib_tail.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib9, self), 0, 3);	// relvel: forward, right, up

	tagorg = tag_origin("tag_cyst_a", self);
	ThrowGib4(self, "models/projectiles/proj_cyst.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib10, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_cyst_b", self);
	ThrowGib4(self, "models/projectiles/proj_cyst.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib11, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_cyst_c", self);
	ThrowGib4(self, "models/projectiles/proj_cyst.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib12, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_cyst_d", self);
	ThrowGib4(self, "models/projectiles/proj_cyst.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib13, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_cyst_e", self);
	ThrowGib4(self, "models/projectiles/proj_cyst.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(str_gib14, self), 0, 3);	// relvel: forward, right, up

	tagorg = tag_origin("tag_cyst_explo", self);
	explo_blood(6, tagorg);
	pointparticles(particleeffectnum("stricken_cyst_explo"), tagorg, '0 0 0', 1);

	tagorg = self.origin;
	explo_blood(5, tagorg);
	pointparticles(particleeffectnum("stricken_explo"), tagorg, '0 0 0', 1);
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(str_gib15, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(str_gib16, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(str_gib17, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(str_gib18, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(str_gib19, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(str_gib20, self), 0, 3);	// relvel: forward, right, up
	sound(self, CHAN_AUTO, "enemies/stricken/die.ogg", 1, 0.25);

	sound(self, CHAN_AUTO, "enemies/stricken/explode.ogg", 1, 0.25);
	T_SplashDamageMonster(self, stricken_dexplosiondamagemonsters, stricken_dexplosiondamage, world, stricken_dexplosionradius, stricken_pushfactor);	// to player
	pointparticles(particleeffectnum("afflictedaoe"), self.origin, v_forward *(-550), 1);
	aoe_spawn(self);
	remove(self);
};

///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_stricken (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() precache_monster_stricken = 
{
	precache_model("models/enemies/stricken/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/stricken/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/stricken/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/stricken/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/stricken/gibs/gib_head.md3");
	precache_model("models/enemies/stricken/gibs/gib_jaw.md3");
	precache_model("models/enemies/stricken/gibs/gib_side_l.md3");
	precache_model("models/enemies/stricken/gibs/gib_side_r.md3");
	precache_model("models/enemies/stricken/gibs/gib_tail.md3");
	precache_model("models/enemies/stricken/stricken.md3");
	precache_model("particles/explo/explo_stricken.md3");
	precache_sound("enemies/stricken/idle1.ogg");
	precache_sound("enemies/stricken/idle2.ogg");
	precache_sound("enemies/stricken/idle3.ogg");
	precache_sound("enemies/stricken/chatter1.ogg");
	precache_sound("enemies/stricken/chatter2.ogg");
	precache_sound("enemies/stricken/chatter3.ogg");
	precache_sound("enemies/stricken/preattack.ogg");
	precache_sound("enemies/stricken/attack1.ogg");
	precache_sound("enemies/stricken/attack2.ogg");
	precache_sound("enemies/stricken/attack3.ogg");
	precache_sound("enemies/stricken/cyst1.ogg");
	precache_sound("enemies/stricken/cyst2.ogg");
	precache_sound("enemies/stricken/cyst3.ogg");
	precache_sound("enemies/stricken/bite1.ogg");
	precache_sound("enemies/stricken/bite2.ogg");
	precache_sound("enemies/stricken/bite3.ogg");
	precache_sound("enemies/stricken/pain1.ogg");
	precache_sound("enemies/stricken/pain2.ogg");
	precache_sound("enemies/stricken/pain3.ogg");
	precache_sound("enemies/stricken/sight.ogg");
	precache_sound("enemies/stricken/step1.ogg");
	precache_sound("enemies/stricken/step2.ogg");
	precache_sound("enemies/stricken/step3.ogg");
	precache_sound("enemies/stricken/step4.ogg");
	precache_sound("enemies/stricken/step5.ogg");
	precache_sound("enemies/stricken/die.ogg");
	precache_sound("enemies/stricken/explode.ogg");
};
void() monster_stricken = 
{
	precache_model("models/enemies/stricken/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/stricken/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/stricken/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/stricken/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/stricken/gibs/gib_head.md3");
	precache_model("models/enemies/stricken/gibs/gib_jaw.md3");
	precache_model("models/enemies/stricken/gibs/gib_side_l.md3");
	precache_model("models/enemies/stricken/gibs/gib_side_r.md3");
	precache_model("models/enemies/stricken/gibs/gib_tail.md3");
	precache_model("models/enemies/stricken/stricken.md3");
	precache_model("particles/explo/explo_stricken.md3");
	precache_sound("enemies/stricken/idle1.ogg");
	precache_sound("enemies/stricken/idle2.ogg");
	precache_sound("enemies/stricken/idle3.ogg");
	precache_sound("enemies/stricken/chatter1.ogg");
	precache_sound("enemies/stricken/chatter2.ogg");
	precache_sound("enemies/stricken/chatter3.ogg");
	precache_sound("enemies/stricken/preattack.ogg");
	precache_sound("enemies/stricken/attack1.ogg");
	precache_sound("enemies/stricken/attack2.ogg");
	precache_sound("enemies/stricken/attack3.ogg");
	precache_sound("enemies/stricken/cyst1.ogg");
	precache_sound("enemies/stricken/cyst2.ogg");
	precache_sound("enemies/stricken/cyst3.ogg");
	precache_sound("enemies/stricken/bite1.ogg");
	precache_sound("enemies/stricken/bite2.ogg");
	precache_sound("enemies/stricken/bite3.ogg");
	precache_sound("enemies/stricken/pain1.ogg");
	precache_sound("enemies/stricken/pain2.ogg");
	precache_sound("enemies/stricken/pain3.ogg");
	precache_sound("enemies/stricken/sight.ogg");
	precache_sound("enemies/stricken/step1.ogg");
	precache_sound("enemies/stricken/step2.ogg");
	precache_sound("enemies/stricken/step3.ogg");
	precache_sound("enemies/stricken/step4.ogg");
	precache_sound("enemies/stricken/step5.ogg");
	precache_sound("enemies/stricken/die.ogg");
	precache_sound("enemies/stricken/explode.ogg");
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.noise = "enemies/stricken/sight.ogg";
	self.damagetopain = stricken_dtp;
	if (self.waypointed != 1)
		self.waypointed = 0;
	self.stepheight_delta = stricken_heightstep;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/stricken/stricken.md3");
	setsize(self, stricken_nbbox, stricken_bbox);
	self.health = stricken_health;
	self.classname = "monster_stricken";
	self.th_stand = stricken_stand1;
	self.th_walk = stricken_walk1;
	if (!self.turret)
		self.th_run = stricken_run1;
	else
		self.th_run = stricken_preattack1;
	self.turretable = 1;
	self.oldturret  =self.turret;
	self.th_missile = stricken_preattack1;
	self.th_melee = stricken_spreattack1;
	self.th_pain = stricken_pain;
	self.th_die = stricken_diea1;
	self.heavymonster = 1;
	walkmonster_start();
};

////////////////end of qc file