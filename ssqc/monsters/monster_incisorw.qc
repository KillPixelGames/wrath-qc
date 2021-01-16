/*
==============================================================================

incisor

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

$frame pel_idle1

$frame pel_run1

$frame pel_walk1

$frame pel_patk1

$frame pel_atk1

$frame pel_spatk1

$frame pel_satk1

$frame pel_paina1

$frame pel_death1


void() FindNearestSafeNode = 
{
	local entity head, near;
	local float dist, low, disttoenemy;
	low = 99999999;	
	head = find(world, classname, "info_node");
	if (!head)
	{
	//	self.pathed = 0;
	//	self.th_run();
	//	return;
	}

	while (head)
	{
		if (visible(head))
		{
			dist = vlen(head.origin - self.origin);
			disttoenemy = vlen(head.origin - self.enemy.origin);
			if(disttoenemy < 128)
			dist += 2048;

			if (dist < low)
			{
				low = dist;
				near = head;
			}
		}
		head = find(head, classname, "info_node");
	}

	if (near)
	{
	//	if (!(self.pathtime < time))
	//		self.pathtime = time + 0.5;
	//	self.target = near.targetname;
		self.goalentity = self.movetarget = near;
		self.evade = 1;
		self.goalentity.effects = 1024;
	//	self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
	//	self.th_walk();
	}
else
{
remove (self);
}
};


	.float runing_time;

/////////////////////////////////////////////////////////////////////////////////////////////
void() incisor_stand1 =[$pel_idle1, incisor_stand1]
{
	local float r;
	r = random() *100;

	if (incisor_wth <= r)
		ai_stand();
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() incisor_walk1 =[$pel_walk1, incisor_walk1]
{
	ai_walk(incisor_ws);
	self.colormod = ' 1.25 1 1';
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() incisor_preattack;
void() incisor_spreattack;
void() incisor_sattack;
void() incisor_evade1;
void() incisor_run1;
void() incisor_puke ={
FindNearestSafeNode(); 
self.think = incisor_evade1;
self.nextthink = time + 0.1;
};

void() incisor_evade1 = [$pel_run1, incisor_evade1]{

ai_runwalk(incisor_rs);
	if(vlen(self.goalentity.origin - self.origin) < 64)
	{
	self.evade = 0;
	self.goalentity = self.movetarget = self.enemy;
	self.think = incisor_preattack;
	self.nextthink = time + 0.1;
	}
};

void()incisor_evade =
{
ai_face();
FindNearestSafeNode(); 
self.think = incisor_evade1;
self.nextthink = time + 0.1;
};

void() incisor_run1 =[$pel_run1, incisor_run1]
{
	local float r;
	if (self.gravity <= 0)
	{
		self.movetype = MOVETYPE_STEP;
		self.gravity = 1;
	}

	ai_runwalk(incisor_rs);
	self.colormod = ' 1 1 1';
	if (time > self.runing_time)
	{
		self.runing_time = time + incisor_rt;
		if (self.zigzaging == 0)
		{
			r = random() *100;
			if (incisor_zzc >= r)
			{
				local float zzmultiplier;
				zzmultiplier = ((incisor_zzd* random()) + incisor_zzmd);
				if (zzmultiplier > incisor_zzd)
					zzmultiplier = incisor_zzd;
				local float rr = random();
				if (rr > 0.5)
					self.zigzagdeviance = zzmultiplier;
				else
					self.zigzagdeviance = zzmultiplier *-1;

				self.zigzaging = 1;
			}
		}
		else
			self.zigzaging = 0;

		if ((visible(self.enemy)))
		{
			enemy_range = range(self.enemy);
			if (enemy_range == RANGE_FAR)
				return;
			if (enemy_range == RANGE_MID)
					self.think = incisor_preattack;
			if (enemy_range == RANGE_NEAR) 
					self.think = incisor_evade;
			if (enemy_range == RANGE_MELEE)
				self.think = incisor_evade;

		}
	}
};

/////////////////////////////////////////////////////////////////////////////////////////////projectile attack
void() projectile_touch_pel = 
{
	local float damg;
	if (other == self.owner)
		return;
	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = incisor_ad;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}

	self.touch = SUB_Null;
	self.nextthink = time;
	self.think = slag_explode1;
};

void(vector org, vector dir, entity ownerproj) launch_projectile_pel = 
{
	local entity shotgun_proj;
	ownerproj.effects = EF_MUZZLEFLASH;
	shotgun_proj = spawn();
	shotgun_proj.owner = ownerproj;
	shotgun_proj.movetype = MOVETYPE_FLYMISSILE;
	shotgun_proj.solid = SOLID_TRIGGER;
	shotgun_proj.scale = 2;
	shotgun_proj.angles = vectoangles(dir);
	shotgun_proj.touch = projectile_touch_pel;
	shotgun_proj.classname = "projectile";
	setmodel(shotgun_proj, "models/projectiles/proj_fang1.md3");
	setsize(shotgun_proj, '0 0 0', '0 0 0');
	makevectors(self.angles);
	//org -=v_forward*order ;
	setorigin(shotgun_proj, org);
	shotgun_proj.velocity = dir *(incisor_projvel);

	shotgun_proj.oldvelocity = shotgun_proj.velocity;
};

.float projammount;
/*
void() incisor_attack2 = {	//		local float dist;
	self.frame = $pel_atk1;
	self.runing_time = time + incisor_rt + incisor_at;
	ai_face();
	local vector dir, tagorg;
	local float tagindex;
	playersound2("weapons/shotgun/fire2empty_", 2, CHAN_AUTO);
	tagindex = gettagindex(self.vweapon, "tag_proj");
	tagorg = self.origin;	// gettaginfo(self.vweapon, tagindex);
	dir = aim(self, 1000);
	local vector sre;
	sre = self.angles;
	makevectors2(sre);
	//			dist = 1+ (vlen (self.enemy.origin - tagorg) / 512);
	dir = normalize(self.enemy.origin - tagorg);
	launch_projectile_pel(tagorg, dir, self);
	self.colormod = ' 1 0 0';
	self.projammount--;

	if (self.projammount <= 0)
	{
		if (visible(self.enemy))
		{
			enemy_range = range(self.enemy);
			if (enemy_range == RANGE_FAR)
				self.think = incisor_run1;
			if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
			{
				local float r;
				r = random() *100;
				if (incisor_ath >= r)
					self.think = incisor_preattack;
				else
					self.think = incisor_run1;
			}

			if (enemy_range == RANGE_MELEE)
				self.think = incisor_spreattack;
			else
				self.think = incisor_run1;

		}

		if (!(visible(self.enemy)))
			self.think = incisor_run1;
		self.nextthink = time + incisor_at;
	}
	else
	{
		if (!(visible(self.enemy)))
			self.think = incisor_run1;
		else
			self.think = incisor_attack;
		self.nextthink = time + incisor_firerate;
	}
};
*/

void() spike_touch =
{
	vector org;
	if (other.takedamage)
	{
		if ((other.flags &FL_MONSTER) || (other.classname == "player"))
		{
	
			if (other.classname == "monster_afflicted")
				spawn_touchblood2(9, 2);
			else if (other.classname == "monster_wraith")
				spawn_touchblood2(9, 4);
			else if (other.classname != "monster_oppressor")
				spawn_touchblood2(9, 1);

			local float r;
			r = random();
			if (r < 1)
			{
				if (other.classname == "monster_afflicted")
					explo_blood_sprite(3, org);
				else if (other.classname == "monster_oppressor")
					spawn_touchblood2(9, 5);
				else if (other.classname == "monster_wraith")
					explo_blood_sprite(4, org);
				else
				{
					if (r < 0.5)
						explo_blood_sprite(1, org);
					else
						explo_blood_sprite(2, org);
				}
			}
		T_Damage(other, self, self.owner, incisor_ad);
		}
	self.solid = SOLID_NOT;
	}
};


void()spike_damage =
{
	if(self.solid != SOLID_TRIGGER)
	{
		self.owner.projammount --;		
		self.solid = SOLID_TRIGGER;
	}
	else
		self.solid = SOLID_NOT;
	self.touch = spike_touch;
	if(self.frame == 1)
		self.frame = 0;
	else
		self.frame = 1;

	if(self.owner.projammount > 0)	
		self.think = spike_damage;
	else
		self.think = SUB_Remove;
	self.nextthink = time + incisor_firerate;
}

.float spike_spawned;
void(entity attacked, entity attacker) incisor_attack_spike =
{
	entity spike = spawn();
	attacker.spike_spawned = 1;
	vector origin_spike = attacked.origin; 
	setorigin (spike, origin_spike);
	spike.owner = attacker;
	setmodel (spike, "models/enemies/incisor/incisor_spike.md3");
	spike.think = spike_damage;
	spike.nextthink = time;
};


.float enemy_incisortime;
void() trigger_incisor_noattack_touch =
{
	if(!other.health)
		return;
	if((other.classname == "player") || (other.classentity == "monsters"))
	{
		if(other.enemy_incisortime < time)
			other.enemy_incisortime = time + 0.05;
	}
};

void ()  trigger_incisor_noattack=
{
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
	self.touch = trigger_incisor_noattack_touch; 
};


void() incisor_attack = {	//		local float dist;
	self.frame = $pel_atk1;
	self.runing_time = time + incisor_rt + incisor_at;
	ai_face();
	self.colormod = ' 1 0 0';
	if ((visible(self.enemy)) && (self.projammount > 0) && (!self.spike_spawned))
	{	
		enemy_range = range(self.enemy);
		if ((enemy_range == RANGE_FAR) || ((self.enemy.enemy_incisortime + 0.05) > time))
			self.think = incisor_run1;
		else
		{
			if(self.enemy.flags & FL_ONGROUND) 	
			{	
				incisor_attack_spike(self.enemy, self);
			}	
				self.think = incisor_attack;	
		}
	}	

	self.nextthink = time + 0.1;
};

void() incisor_preattack = 
{
	self.projammount = incisor_projcount;
	self.colormod = ' 0 0 1';
	self.spike_spawned = 0;
	self.frame = $pel_patk1;
	self.think = incisor_attack;
	ai_face();
	self.nextthink = time + incisor_pat;
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////melee attack

void(float wdmg) incisor_melee_attack = 
{
	local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);
	if (dist > incisor_near)
	{
		return;
	}
	else
	{
		T_Damage(self.enemy, self, self, wdmg);
	}
};

void() incisor_sattack = 
{
	ai_face();
	self.gravity = 1;
	self.movetype = MOVETYPE_STEP;
	self.frame = $pel_satk1;
	self.runing_time = time + incisor_rt;
	enemy_range = range(self.enemy);
	incisor_melee_attack(incisor_sad);
	self.colormod = ' 1 0 0';
	if (enemy_range == RANGE_MELEE)
		self.think = incisor_spreattack;
	else
		self.think = incisor_run1;
	self.nextthink = time + incisor_sat;
};

void() incisor_spreattack = 
{
	self.colormod = ' 0 0 1';
	self.frame = $pel_spatk1;
	self.think = incisor_sattack;
	ai_face();
	self.nextthink = time + incisor_spat;
};

/////////////////////////////////////////////////////////////////////////////////////////////
void(entity enemy, float dmg) incisor_paina1 = 
{ 
	local float rp;
	rp = random() *100;
	if (incisor_rtp <= rp)
		return;

	self.runing_time = time + incisor_rt;
	self.frame = $pel_paina1;
	ai_pain(4);
	self.colormod = ' 1 1 0';

	local float r;
	r = random() *100;
	if (incisor_pth >= r)
		self.think = incisor_run1;
	else
		self.think = incisor_preattack;
	self.sustained_damage = 0;
	self.pain_finished = time + incisor_pt;
	self.nextthink = time + incisor_pt;
};

///////////////////////////////////////////////////////////////////////////////////////////
void() incisor_diea1 = 
{
	drop_item(self.origin + '0 0 40', "fangs", 10, self);
	decal_monster(self.origin + '0 0 12');

	remove(self);
};

///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_incisor (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() precache_monster_incisor = 
{
	precache_model("models/enemies/incisor/incisor.md3");
};

void() monster_incisor = 
{
	precache_model("models/enemies/incisor/incisor.md3");
	if (deathmatch)
	{
		remove(self);
		return;
	}

	if (self.waypointed != 1)
		self.waypointed = 0;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/incisor/incisor.md3");
	setsize(self, incisor_bbox *-0.5, incisor_bbox *0.5);
	self.health = incisor_health;
	self.damagetopain = incisor_dtp;
	self.classname = "monster_incisor";
	self.th_stand = incisor_stand1;
	self.th_walk = incisor_walk1;
	self.th_run = incisor_run1;
	self.th_missile = incisor_preattack;
	self.th_melee = incisor_spreattack;
	self.th_pain = incisor_paina1;
	self.th_die = incisor_diea1;
	walkmonster_start();
};

////////////////end of qc file
