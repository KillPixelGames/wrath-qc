/*
==============================================================================

invader

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

/*
0            -    EDITOR POSE
1-20        (20)    -    IDLE
21-30        (10)    -    WARP
31-40        (10)    -    WALK/RUN
41-50        (10)    -    WALK-TO-ATTACK (end VEL on 43)
51-60        (10)    -    ATTACK (frame 1, tag_muzzle)
61-70        (10)    -    ATTACK-TO-WALK (begin VEL on 65)
71-80        (10)    -    ATTACK2 (melee) (damage on 74)
81-90        (10)    -    BLIND CHASE (skin_1 on frame 1)
91-95        (5)    -    PAINA
96-100        (5)    -    PAINB
101-105    (5)    -    PAINC
106-110    (5)    -    PAIND (change skin to skin_1 and spawn gib_head on frame1)
111-120    (10)    -    MUTILATE (lose blade arm) (spawn gib_arm, tag_arm_l)
121-130    (10)    -    DIEA (change skin to skin_1 and spawn gib_head on frame1)
131-140    (10)    -    DIEB (change skin to skin_1 and spawn gib_head on frame1)
141-150    (10)    -    DIEC (change skin to skin_1 and spawn gib_head on frame1)
151-170    (20)    -    DIED (throws head at player) NOT READY
*/

$frame pose0
$frame inv_idle1 inv_idle2 inv_idle3 inv_idle4 inv_idle5 inv_idle6 inv_idle7 inv_idle8 inv_idle9 inv_idle10 inv_idle11 inv_idle12 inv_idle13 inv_idle14 inv_idle15 inv_idle16 inv_idle17 inv_idle18 inv_idle19 inv_idle20
$frame inv_warp1 inv_warp2 inv_warp3 inv_warp4 inv_warp5 inv_warp6 inv_warp7 inv_warp8 inv_warp9 inv_warp10
$frame inv_run1 inv_run2 inv_run3 inv_run4 inv_run5 inv_run6 inv_run7 inv_run8 inv_run9 inv_run10
$frame inv_runtoattack1 inv_runtoattack2 inv_runtoattack3 inv_runtoattack4 inv_runtoattack5 inv_runtoattack6 inv_runtoattack7 inv_runtoattack8 inv_runtoattack9 inv_runtoattack10
$frame inv_attack1 inv_attack2 inv_attack3 inv_attack4 inv_attack5 inv_attack6 inv_attack7 inv_attack8 inv_attack9 inv_attack10
$frame inv_attacktorun1 inv_attacktorun2 inv_attacktorun3 inv_attacktorun4 inv_attacktorun5 inv_attacktorun6 inv_attacktorun7 inv_attacktorun8 inv_attacktorun9 inv_attacktorun10
$frame inv_sattack1 inv_sattack2 inv_sattack3 inv_sattack4 inv_sattack5 inv_sattack6 inv_sattack7 inv_sattack8 inv_sattack9 inv_sattack10
$frame inv_blindchase1 inv_blindchase2 inv_blindchase3 inv_blindchase4 inv_blindchase5 inv_blindchase6 inv_blindchase7 inv_blindchase8 inv_blindchase9 inv_blindchase10
$frame inv_paina1 inv_paina2 inv_paina3 inv_paina4 inv_paina5
$frame inv_painb1 inv_painb2 inv_painb3 inv_painb4 inv_painb5
$frame inv_painc1 inv_painc2 inv_painc3 inv_painc4 inv_painc5
$frame inv_paind1 inv_paind2 inv_paind3 inv_paind4 inv_paind5
$frame inv_mutilate1 inv_mutilate2 inv_mutilate3 inv_mutilate4 inv_mutilate5 inv_mutilate6 inv_mutilate7 inv_mutilate8 inv_mutilate9 inv_mutilate10
$frame inv_deatha1 inv_deatha2 inv_deatha3 inv_deatha4 inv_deatha5 inv_deatha6 inv_deatha7 inv_deatha8 inv_deatha9 inv_deatha10
$frame inv_deathb1 inv_deathb2 inv_deathb3 inv_deathb4 inv_deathb5 inv_deathb6 inv_deathb7 inv_deathb8 inv_deathb9 inv_deathb10
$frame inv_deathc1 inv_deathc2 inv_deathc3 inv_deathc4 inv_deathc5 inv_deathc6 inv_deathc7 inv_deathc8 inv_deathc9 inv_deathc10
$frame inv_deathd1 inv_deathd2 inv_deathd3 inv_deathd4 inv_deathd5 inv_deathd6 inv_deathd7 inv_deathd8 inv_deathd9 inv_deathd10 inv_deathd11 inv_deathd12 inv_deathd13 inv_deathd14 inv_deathd15 inv_deathd16 inv_deathd17 inv_deathd18 inv_deathd19 inv_deathd20

	.float runing_time;
.float headless;
/////////////////////////////////////////////////////////////////////////////////////////////
void() invader_stand =[$inv_idle1, invader_stand2]
{
	ai_stand();

	if (!(self.spawnflags &1))
	{
		local float r;
		r = random() *10;
		if (r < 1)
			monstersound1("enemies/invader/idle", 3, CHAN_VOICE);
	}
};

void() invader_stand2 =[$inv_idle2, invader_stand3]
{
	ai_stand();
};
void() invader_stand3 =[$inv_idle3, invader_stand4]
{
	ai_stand();
};
void() invader_stand4 =[$inv_idle4, invader_stand5]
{
	ai_stand();
};
void() invader_stand5 =[$inv_idle5, invader_stand6]
{
	ai_stand();
};
void() invader_stand6 =[$inv_idle6, invader_stand7]
{
	ai_stand();
};
void() invader_stand7 =[$inv_idle7, invader_stand8]
{
	ai_stand();
};
void() invader_stand8 =[$inv_idle8, invader_stand9]
{
	ai_stand();
};
void() invader_stand9 =[$inv_idle9, invader_stand10]
{
	ai_stand();
};
void() invader_stand10 =[$inv_idle10, invader_stand11]
{
	ai_stand();
};
void() invader_stand11 =[$inv_idle11, invader_stand12]
{
	ai_stand();
};
void() invader_stand12 =[$inv_idle12, invader_stand13]
{
	ai_stand();
};
void() invader_stand13 =[$inv_idle13, invader_stand14]
{
	ai_stand();
};
void() invader_stand14 =[$inv_idle14, invader_stand15]
{
	ai_stand();
};
void() invader_stand15 =[$inv_idle15, invader_stand16]
{
	ai_stand();
};
void() invader_stand16 =[$inv_idle16, invader_stand17]
{
	ai_stand();
};
void() invader_stand17 =[$inv_idle17, invader_stand18]
{
	ai_stand();
};
void() invader_stand18 =[$inv_idle18, invader_stand19]
{
	ai_stand();
};
void() invader_stand19 =[$inv_idle19, invader_stand20]
{
	ai_stand();
};
void() invader_stand20 =[$inv_idle20, invader_stand]
{
	ai_stand();
};

/*
void()	invader_stand1	=[	$inv_idle1,	invader_stand1	] 
{
local float r;
r = random() *100;

if(invader_wth <= r)
ai_stand();
}; 
*/
void() invader_preattack;
void() invader_sattack;
void() invader_sattack;

void() invader_waiting =[$inv_idle1, invader_waiting2]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
	monstersound1("enemies/invader/idle", 3, CHAN_VOICE);
};
void() invader_waiting2 =[$inv_idle2, invader_waiting3]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting3 =[$inv_idle3, invader_waiting4]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting4 =[$inv_idle4, invader_waiting5]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting5 =[$inv_idle5, invader_waiting6]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting6 =[$inv_idle6, invader_waiting7]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting7 =[$inv_idle7, invader_waiting8]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting8 =[$inv_idle8, invader_waiting9]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting9 =[$inv_idle9, invader_waiting10]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting10 =[$inv_idle10, invader_waiting11]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting11 =[$inv_idle11, invader_waiting12]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting12 =[$inv_idle12, invader_waiting13]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting13 =[$inv_idle13, invader_waiting14]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting14 =[$inv_idle14, invader_waiting15]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting15 =[$inv_idle15, invader_waiting16]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting16 =[$inv_idle16, invader_waiting17]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting17 =[$inv_idle17, invader_waiting18]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting18 =[$inv_idle18, invader_waiting19]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting19 =[$inv_idle19, invader_waiting20]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};
void() invader_waiting20 =[$inv_idle20, invader_waiting]
{
	if (visible(self.enemy))
	{
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
	}

	ai_face();
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() invader_walk =[$inv_run1, invader_walk2]
{
	ai_walk(invader_rs);

	local float r;
	r = random() *10;
	if (r < 1)
		monstersound5("enemies/invader/chatter", 5, CHAN_VOICE);
};
void() invader_walk2 =[$inv_run2, invader_walk3]
{
	ai_walk(invader_rs);
};
void() invader_walk3 =[$inv_run3, invader_walk4]
{
	ai_walk(invader_rs);
};
void() invader_walk4 =[$inv_run4, invader_walk5]
{
	ai_walk(invader_rs);
	monstersound3("enemies/invader/step", 5, CHAN_BODY);
};
void() invader_walk5 =[$inv_run5, invader_walk6]
{
	ai_walk(invader_rs);
};
void() invader_walk6 =[$inv_run6, invader_walk7]
{
	ai_walk(invader_rs);
};
void() invader_walk7 =[$inv_run7, invader_walk8]
{
	ai_walk(invader_rs);
};
void() invader_walk8 =[$inv_run8, invader_walk9]
{
	ai_walk(invader_rs);
};
void() invader_walk9 =[$inv_run9, invader_walk10]
{
	ai_walk(invader_rs);
	monstersound3("enemies/invader/step", 5, CHAN_BODY);
};
void() invader_walk10 =[$inv_run10, invader_walk]
{
	self.findtargettime = time + 0.1;
	ai_walk(invader_rs);
};

/*void()	invader_walk1	=[	$inv_walk1,	invader_walk1	] {ai_walk(invader_ws);
self.colormod = ' 1.25 1 1';
}; */

/////////////////////////////////////////////////////////////////////////////////////////////

void() inv_check_melee = { enemy_range = range(self.enemy);
	if (enemy_range == RANGE_MELEE)
		self.think = invader_sattack;
	self.nextthink = time + 0.1;
};
.float invader_search_time;
void() invader_run =[$inv_run1, invader_run2]
{
	ai_runwalk(invader_rs);
	inv_check_melee();
	local float r;
	r = random() *10;
	if (r < 0.5)
		monstersound5("enemies/invader/chatter", 5, CHAN_VOICE);

	if (visible(self.enemy))
		self.invader_search_time = time + 10;

};
void() invader_run2 =[$inv_run2, invader_run3]
{
	ai_runwalk(invader_rs);
	inv_check_melee();
};
void() invader_run3 =[$inv_run3, invader_run4]
{
	ai_runwalk(invader_rs);
	inv_check_melee();
};
void() invader_run4 =[$inv_run4, invader_run5]
{
	ai_runwalk(invader_rs);
	inv_check_melee();
	monstersound3("enemies/invader/step", 5, CHAN_BODY);
};
void() invader_run5 =[$inv_run5, invader_run6]
{
	ai_runwalk(invader_rs);
	inv_check_melee();

};
void() invader_run6 =[$inv_run6, invader_run7]
{
	ai_runwalk(invader_rs);
	inv_check_melee();
};
void() invader_run7 =[$inv_run7, invader_run8]
{
	ai_runwalk(invader_rs);
	inv_check_melee();
};
void() invader_run8 =[$inv_run8, invader_run9]
{
	ai_runwalk(invader_rs);
	inv_check_melee();
};
void() invader_run9 =[$inv_run9, invader_run10]
{
	ai_runwalk(invader_rs);
	inv_check_melee();
	monstersound3("enemies/invader/step", 5, CHAN_BODY);
};
void() invader_run10 =[$inv_run10, invader_run]
{
	self.findtargettime = time + 0.1;
	local float r;
	if (self.zigzaging == 0)
	{
		r = random() *100;
		if (invader_zzc >= r)
		{
			local float zzmultiplier;
			zzmultiplier = ((invader_zzd* random()) + invader_zzmd);
			if (zzmultiplier > invader_zzd)
				zzmultiplier = invader_zzd;
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

	ai_runwalk(invader_rs);

	if ((visible(self.enemy)) && (self.enemy.classname != "path_waypoint"))
	{
		enemy_range = range(self.enemy);
		if ((enemy_range == RANGE_FAR) || (enemy_range == RANGE_MID))
			return;
		if ((enemy_range == RANGE_NEAR) )
		{
			r = random() *100;
			if ((invader_rth >= r) && (self.timeangles < time))
				self.think = invader_preattack;
		}

		if (enemy_range == RANGE_MELEE)
			self.think = invader_sattack;
	}

//	if ((!(visible(self.enemy))) && (self.invader_search_time < time))
//		self.think = invader_waiting;
};

/*
void()	invader_run1	=[	$inv_run1,	invader_run1	] 
{	
	if(self.wknd != 1)
	{
		self.wknd = 1;
		local float rp;
		rp = random() *100;
		if((invader_itadr >= rp) && (self.timeangles < time))
		{	
			enemy_range = range(self.enemy);
			if ((enemy_range == RANGE_NEAR))
				self.think = invader_preattack;
			if (enemy_range == RANGE_MELEE)
			{
				ai_face();
				self.think = invader_sattack; 
			}

			return;
		}
	}

	local float r;
	if(self.gravity <= 0)
	{
		self.movetype = MOVETYPE_STEP;
		self.gravity = 1;
	}

	ai_runwalk(invader_rs);	
	self.colormod = ' 1 1 1';
	if(time > self.runing_time)
	{
		self.runing_time = time + invader_rt;	
		if(self.zigzaging == 0)
		{
			r = random() *100;
			if(invader_zzc >= r)
			{			
					local float zzmultiplier;
					zzmultiplier  = ((invader_zzd* random()) +invader_zzmd);
					if(zzmultiplier >invader_zzd)
					zzmultiplier = invader_zzd;	
					local float rr = random();
					if(rr > 0.5)
					self.zigzagdeviance = zzmultiplier;
					else
					self.zigzagdeviance = zzmultiplier *-1;

					self.zigzaging = 1;
			}
		}	
		else
		self.zigzaging = 0;

		if((visible(self.enemy)))
		{
			enemy_range = range(self.enemy);
			if ((enemy_range == RANGE_FAR) || (enemy_range == RANGE_MID))
			return; 
			if ((enemy_range == RANGE_NEAR))
			{
			r = random() *100;
			if((invader_rth >= r) && (self.timeangles < time))
			self.think = invader_preattack;
			else	
			self.runing_time = time + invader_rt;
			}

			if (enemy_range == RANGE_MELEE)
			self.think = invader_sattack; 
		}
	}
};
*/
/////////////////////////////////////////////////////////////////////////////////////////////projectile attack
void() projectile_touch_inv = { local float damg;
	if (other == self.owner)
		return;
	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = invader_ad;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}

	self.touch = SUB_Null;
	self.nextthink = time;
	self.think = slag_explode1;
};

void() shotgun_proj_touch2 = { if (other == self.owner)
		return;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if ((other == world) || (other.solid == SOLID_BSP))
	{
		local vector org;
		org = self.origin;
		pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1);
	randomsound2  ("impact/projectiles/bullet",15,0.5, CHAN_AUTO, 0, 0.25);
	
	
	//local float r;
	//r = random();
	//if (r < 0.1)
	//randomsound2  ("impact/projectiles/rico",15,0.25, CHAN_AUTO, 0, 0.25);
	}

	/*
	{
	local vector rvel;
	rvel_x = crandom() *50;
	rvel_y = crandom() *50;
	rvel_z = crandom() *50;
	self.angles = vectoangles(self.velocity);
	self.count -= 1;
	}

	*/
	if (other.health)
	{
		T_Damage(other, self, self.owner, invader_ad);
		remove(self);
	}

	if ((self.owner.classname != "monster_invader") && (other.classname != "projectile"))
		remove(self);

	if (other.classname != "projectile")
	{
		self.nextthink = time;
		self.think = SUB_Remove;
	}
};

void() shotgun_proj_touch2;

void(vector org, vector dir, float order, entity ownerproj) launch_projectile_inv = { local entity shotgun_proj;
	shotgun_proj = spawn();
	shotgun_proj.owner = ownerproj;
	shotgun_proj.movetype = MOVETYPE_FLYMISSILE;
	shotgun_proj.solid = SOLID_TRIGGER;
	shotgun_proj.count = 1;
	shotgun_proj.angles = vectoangles(dir);
	shotgun_proj.alreadytoucher = order;	// counter of touchs
	shotgun_proj.touch = shotgun_proj_touch2;
	shotgun_proj.classname = "projectile";
	shotgun_proj.traileffectnum = particleeffectnum("shottrail");
	shotgun_proj.think = SUB_Remove;
	shotgun_proj.nextthink = time + 5;
	setmodel(shotgun_proj, "models/projectiles/proj_shrapnel.md3");
	setsize(shotgun_proj, '0 0 0', '0 0 0');
	makevectors(self.angles);
	//org -=v_forward*order ;
	setorigin(shotgun_proj, org);
	local vector rvec;
	rvec_x += invader_shotgun_spread1 * 0.25;
	rvec_y += invader_shotgun_spread1 * 0.25;
	rvec = crandom() *(rvec_x) *v_right + crandom() *(rvec_y) *v_up;
	dir += rvec;
	shotgun_proj.velocity = dir *(invader_projvel + (25 *order));
	shotgun_proj.oldvelocity = shotgun_proj.velocity;
};

void() invader_attacktorun =[$inv_attacktorun1, invader_attacktorun2] {};
void() invader_attacktorun2 =[$inv_attacktorun2, invader_attacktorun3] {};
void() invader_attacktorun3 =[$inv_attacktorun3, invader_attacktorun4] {};
void() invader_attacktorun4 =[$inv_attacktorun4, invader_attacktorun5] {};
void() invader_attacktorun5 =[$inv_attacktorun5, invader_attacktorun6]
{
	ai_runwalk(invader_rs);
};
void() invader_attacktorun6 =[$inv_attacktorun6, invader_attacktorun7]
{
	ai_runwalk(invader_rs);
};
void() invader_attacktorun7 =[$inv_attacktorun7, invader_attacktorun8]
{
	ai_runwalk(invader_rs);
};
void() invader_attacktorun8 =[$inv_attacktorun8, invader_attacktorun9]
{
	ai_runwalk(invader_rs);
};
void() invader_attacktorun9 =[$inv_attacktorun9, invader_attacktorun10]
{
	ai_runwalk(invader_rs);
	monstersound3("enemies/invader/step", 5, CHAN_BODY);
};
void() invader_attacktorun10 =[$inv_attacktorun10, invader_run]
{
	ai_runwalk(invader_rs);
};

void() invader_attack =[$inv_attack1, invader_attack2]
{
	ai_face();
	local vector dir, tagorg;
	local float pcount, tagindex;

	monstersound2("enemies/invader/fire", 3, CHAN_WEAPON);
	pcount = invader_nproj;
	local entity muzzle;
	local string muzzlemodel;
	while (pcount > 0)
	{
		tagindex = gettagindex(self, "tag_muzzle");
		tagorg = gettaginfo(self, tagindex);

		muzzlemodel = "models/enemies/invader/muzzle_flash.md3";
		muzzle = spawn();
		muzzle.owner = self;
		setmodel(muzzle, muzzlemodel);
		setattachment(muzzle, self, "tag_muzzle");
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;

		dir = aim(self, 1000);
		local vector sre;
		sre = self.angles;
		makevectors2(sre);
		dir = normalize(self.enemy.origin - tagorg);
		launch_projectile_inv(tagorg, dir, pcount, self);
		pcount -= 1;
	}
};
void() invader_attack2 =[$inv_attack2, invader_attack3] {};
void() invader_attack3 =[$inv_attack3, invader_attack4] {};
void() invader_attack4 =[$inv_attack4, invader_attack5] {};
void() invader_attack5 =[$inv_attack5, invader_attack6] {};
void() invader_attack6 =[$inv_attack6, invader_attack7] {};
void() invader_attack7 =[$inv_attack7, invader_attack8]
{
	ai_face();
};
void() invader_attack8 =[$inv_attack8, invader_attack9]
{
	ai_face();
};
void() invader_attack9 =[$inv_attack9, invader_attack10]
{
	ai_face();
};
void() invader_attack10 =[$inv_attack10, invader_attack]
{
	ai_face();

	if (self.turret)
	{
		if (visible(self.enemy))
			self.think = invader_attack;
		else
			self.think = invader_run;
	}
	else
	{
		if (self.skin != 2)
		{
			if (visible(self.enemy))
			{
				enemy_range = range(self.enemy);
				if ((enemy_range == RANGE_FAR) || (enemy_range == RANGE_MID))
					self.think = invader_run;
				if ((enemy_range == RANGE_NEAR) )
				{
					local float r;
					r = random() *100;
					if (invader_ath >= r)
						self.think = invader_attack;
					else
						self.think = invader_attacktorun;
				}

				if (enemy_range == RANGE_MELEE)
					self.think = invader_sattack;
			}
			else
				self.think = invader_attacktorun;

		}
	}

	self.nextthink = time + 0.1;
};

/*
void()	invader_preattack	=[	$inv_runtoattack1,	invader_preattack3	] {ai_runwalk(invader_rs);};
void()	invader_preattack2	=[	$inv_runtoattack2,	invader_preattack3	] {ai_runwalk(invader_rs);};
void()	invader_preattack3	=[	$inv_runtoattack3,	invader_preattack5	] {ai_runwalk(invader_rs);};
void()	invader_preattack4	=[	$inv_runtoattack4,	invader_preattack5	] {ai_face();};
void()	invader_preattack5	=[	$inv_runtoattack5,	invader_preattack7	] {ai_face();};
void()	invader_preattack6	=[	$inv_runtoattack6,	invader_preattack7	] {ai_face();};
void()	invader_preattack7	=[	$inv_runtoattack7,	invader_preattack9	] {ai_face();};
void()	invader_preattack8	=[	$inv_runtoattack8,	invader_preattack9	] {ai_face();};
void()	invader_preattack9	=[	$inv_runtoattack9,	invader_preattack10	] {ai_face();};
void()	invader_preattack10	=[	$inv_runtoattack10,	invader_attack	] {ai_face();};
*/
void() invader_preattack =[$inv_runtoattack1, invader_preattack2]
{
	ai_runwalk(invader_rs);
};
void() invader_preattack2 =[$inv_runtoattack2, invader_preattack3]
{
	ai_runwalk(invader_rs);
};
void() invader_preattack3 =[$inv_runtoattack3, invader_preattack4]
{
	ai_runwalk(invader_rs);
	monstersound3("enemies/invader/step", 5, CHAN_BODY);
};
void() invader_preattack4 =[$inv_runtoattack4, invader_preattack5]
{
	ai_face();
};
void() invader_preattack5 =[$inv_runtoattack5, invader_preattack6]
{
	ai_face();
};
void() invader_preattack6 =[$inv_runtoattack6, invader_preattack7]
{
	ai_face();
};
void() invader_preattack7 =[$inv_runtoattack7, invader_preattack8]
{
	ai_face();
};
void() invader_preattack8 =[$inv_runtoattack8, invader_preattack9]
{
	ai_face();
};
void() invader_preattack9 =[$inv_runtoattack9, invader_preattack10]
{
	ai_face();
};
void() invader_preattack10 =[$inv_runtoattack10, invader_attack]
{
	ai_face();
};
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////melee attack

void(float wdmg) invader_melee_attack = { local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);
	if (dist > 120)
	{
		return;
	}
	else
	{
		T_Damage(self.enemy, self, self, wdmg);
	}
};

void() invader_blindechase =[$inv_blindchase1, invader_blindechase2]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
};
void() invader_blindechase2 =[$inv_blindchase2, invader_blindechase3]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
};
void() invader_blindechase3 =[$inv_blindchase3, invader_blindechase4]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
};
void() invader_blindechase4 =[$inv_blindchase4, invader_blindechase5]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
	monstersound3("enemies/invader/step", 5, CHAN_BODY);
};
void() invader_blindechase5 =[$inv_blindchase5, invader_blindechase6]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
};
void() invader_blindechase6 =[$inv_blindchase6, invader_blindechase7]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
};
void() invader_blindechase7 =[$inv_blindchase7, invader_blindechase8]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
};
void() invader_blindechase8 =[$inv_blindchase8, invader_blindechase9]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
	monstersound3("enemies/invader/step", 5, CHAN_BODY);
};
void() invader_blindechase9 =[$inv_blindchase9, invader_blindechase10]
{
	ai_runwalk(invader_rs);
	ai_face();
	inv_check_melee();
};
void() invader_blindechase10 =[$inv_blindchase10, invader_blindechase]
{
	ai_runwalk(invader_rs);
	ai_face();
	if ((visible(self.enemy)))
	{
		enemy_range = range(self.enemy);
		if (enemy_range == RANGE_MELEE)
			self.think = invader_sattack;
		else
			self.think = invader_blindechase;
	}
	else
		self.think = invader_blindechase;
};

void() invader_sattack =[$inv_sattack1, invader_sattack2]
{
	ai_face();
	monstersound2("enemies/invader/melee", 3, CHAN_WEAPON);
};
void() invader_sattack2 =[$inv_sattack2, invader_sattack3]
{
	ai_face();
};
void() invader_sattack3 =[$inv_sattack3, invader_sattack4]
{
	ai_face();
};
void() invader_sattack4 =[$inv_sattack4, invader_sattack5]
{
	ai_face();
	invader_melee_attack(invader_sad);
};
void() invader_sattack5 =[$inv_sattack5, invader_sattack6]
{
	ai_face();
};
void() invader_sattack6 =[$inv_sattack6, invader_sattack7] {};
void() invader_sattack7 =[$inv_sattack7, invader_sattack8] {};
void() invader_sattack8 =[$inv_sattack8, invader_sattack9]
{
	ai_face();
};
void() invader_sattack9 =[$inv_sattack9, invader_sattack10]
{
	ai_face();
};
void() invader_sattack10 =[$inv_sattack10, invader_sattack]
{
	ai_face();
	if (visible(self.enemy))
	{
		enemy_range = range(self.enemy);
		if ((enemy_range == RANGE_FAR) || (enemy_range == RANGE_MID))
		{
			if (self.skin == 1)
				self.think = invader_blindechase;
			else
				self.think = invader_run;
		}

		if ((enemy_range == RANGE_NEAR))
		{
			local float r;
			r = random() *100;
			if (invader_ath >= r)
				self.think = invader_attack;
			else
			{
				if (self.skin == 1)
					self.think = invader_blindechase;
				else
					self.think = invader_run;
			}
		}

		if (enemy_range == RANGE_MELEE)
			self.think = invader_sattack;
		else
		{
			if (self.skin == 1)
				self.think = invader_blindechase;
			else
				self.think = invader_run;
		}
	}
	else
		self.think = invader_run;//waiting;

};

/////////////////////////////////////////////////////////////////////////////////////////////
void() invader_death;

void() invader_postpain = { ai_face();
	if (self.health <= 0)
	{
		self.solid = SOLID_NOT;
		self.think = invader_death;
		self.nextthink = time;
		return;
	}

	local float r;
	if (self.skin == 1)
	{
		self.zigzaging = 0;
		self.think = invader_blindechase;
		self.nextthink = time + 0.1;
		return;
	}

	if (self.skin == 2)
	{
		ai_face();
		self.think = invader_preattack;
		self.nextthink = time + 0.1;
		return;
	}

	r = random() *100;

	if (!self.turret)
	{
		if (invader_pth >= r)
		{
			if (visible(self.enemy))
			{
				enemy_range = range(self.enemy);
				if (enemy_range == RANGE_FAR)
					self.think = invader_run;
				if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
				{
					if (invader_ath >= r)
						self.think = invader_preattack;
					else
						self.think = invader_run;
				}

				if (enemy_range == RANGE_MELEE)
					self.think = invader_sattack;
			}
			else
				self.think = invader_run;
		}
		else
			self.think = invader_run;
	}
	else
	{
		if (visible(self.enemy))
			self.think = invader_preattack;
		else
			self.think = invader_run; //waiting;
	}

	self.nextthink = time;
};
.float painanim;

void() invader_paina =[$inv_paina1, invader_paina2] {};
void() invader_paina2 =[$inv_paina2, invader_paina3] {};
void() invader_paina3 =[$inv_paina3, invader_paina4] {};
void() invader_paina4 =[$inv_paina4, invader_paina5] {};
void() invader_paina5 =[$inv_paina5, invader_postpain] {};

void() invader_painb =[$inv_painb1, invader_painb2] {};
void() invader_painb2 =[$inv_painb2, invader_painb3] {};
void() invader_painb3 =[$inv_painb3, invader_painb4] {};
void() invader_painb4 =[$inv_painb4, invader_painb5] {};
void() invader_painb5 =[$inv_painb5, invader_postpain] {};

void() invader_painc =[$inv_painc1, invader_painc2] {};
void() invader_painc2 =[$inv_painc2, invader_painc3] {};
void() invader_painc3 =[$inv_painc3, invader_painc4] {};
void() invader_painc4 =[$inv_painc4, invader_painc5] {};
void() invader_painc5 =[$inv_painc5, invader_postpain] {};

void() invader_paind =[$inv_paind1, invader_paind2] {};
void() invader_paind2 =[$inv_paind2, invader_paind3] {};
void() invader_paind3 =[$inv_paind3, invader_paind4] {};
void() invader_paind4 =[$inv_paind4, invader_paind5] {};
void() invader_paind5 =[$inv_paind5, invader_postpain] {};

void() invader_mutilated =[$inv_mutilate1, invader_mutilated2] {};
void() invader_mutilated2 =[$inv_mutilate2, invader_mutilated3] {};
void() invader_mutilated3 =[$inv_mutilate3, invader_mutilated4] {};
void() invader_mutilated4 =[$inv_mutilate4, invader_mutilated5] {};
void() invader_mutilated5 =[$inv_mutilate5, invader_mutilated6] {};
void() invader_mutilated6 =[$inv_mutilate6, invader_mutilated7] {};
void() invader_mutilated7 =[$inv_mutilate7, invader_mutilated8] {};
void() invader_mutilated8 =[$inv_mutilate8, invader_mutilated9] {};
void() invader_mutilated9 =[$inv_mutilate9, invader_mutilated10] {};
void() invader_mutilated10 =[$inv_mutilate10, invader_postpain] {};

void(entity enemy, float dmg) invader_pain = {	//if(self.pain_finished > time)
	//	return;
	if (dmg < invader_dtp)
		return;
	local float rp;
	rp = random() *100;
	if (invader_rtp <= rp)
		return;
	//	if(self.pain_finished > time)
	//		return;
	self.pain_finished = time + 0.25;	// 1.75
	local float rpf;
	rpf = floor(random() *3) + 1;
	if (rpf == self.painanim)
		rpf += 1;
	if (rpf > 3)
		rpf = 1;
	self.painanim = rpf;
	monstersound3("enemies/invader/pain", 5, CHAN_BODY);

	if ((self.health <= (invader_health *0.25)) && (!self.skin))
	{
		local float r;
		r = random();
		local string tagname;
		local float tagindex;
		local vector tagorg;
		if ((r > 0.5) && (!self.turret))
		{
			tagname = ("tag_head");
			tagindex = gettagindex(self, tagname);
			tagorg = gettaginfo(self, tagindex);
			self.frame = $inv_paind1;
			self.painanim = 4;
			self.skin = 1;
			ThrowGib3(self, "models/enemies/invader/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib1, self), 0, 1);
			self.headless = 1;
			self.think = invader_paind;
		}
		else
		{
			tagname = ("tag_arm_l");
			tagindex = gettagindex(self, tagname);
			tagorg = gettaginfo(self, tagindex);
			bleeding_point(self, "invader_bleed", "tag_arm_l");
			explo_blood(20, tagorg);
			self.frame = $inv_mutilate1;
			self.painanim = 5;
			self.skin = 2;
			ThrowGib3(self, "models/enemies/invader/gibs/gib_arm_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib2, self), 0, 1);
			self.think = invader_mutilated;
		}
	}
	else
	{
		if (rpf == 1)
		{
			self.frame = $inv_paina1;
			self.painanim = 1;
			self.think = invader_paina;
		}

		if (rpf == 2)
		{
			self.frame = $inv_painb1;
			self.painanim = 2;
			self.think = invader_painb;
		}

		if (rpf == 3)
		{
			self.frame = $inv_painc1;
			self.painanim = 3;
			self.think = invader_painc;
		}
	}

	self.nextthink = time;
};

///////////////////////////////////////////////////////////////////////////////////////////

void() invader_diea =[$inv_deatha1, invader_diea2] {};
void() invader_diea2 =[$inv_deatha2, invader_diea3] {};
void() invader_diea3 =[$inv_deatha3, invader_diea4] {};
void() invader_diea4 =[$inv_deatha4, invader_diea5]
{
	decal_monster2(self.origin + '0 0 12');
};
void() invader_diea5 =[$inv_deatha5, invader_diea6] {};
void() invader_diea6 =[$inv_deatha6, invader_diea7] {};
void() invader_diea7 =[$inv_deatha7, invader_diea8] {};
void() invader_diea8 =[$inv_deatha8, invader_diea9] {};
void() invader_diea9 =[$inv_deatha9, invader_diea10] {};
void() invader_diea10 =[$inv_deatha10, invader_diea10] {};

void() invader_dieb =[$inv_deathb1, invader_dieb2] {};
void() invader_dieb2 =[$inv_deathb2, invader_dieb3] {};
void() invader_dieb3 =[$inv_deathb3, invader_dieb4] {};
void() invader_dieb4 =[$inv_deathb4, invader_dieb5]
{
	decal_monster2(self.origin + '0 0 12');
};
void() invader_dieb5 =[$inv_deathb5, invader_dieb6] {};
void() invader_dieb6 =[$inv_deathb6, invader_dieb7] {};
void() invader_dieb7 =[$inv_deathb7, invader_dieb8] {};
void() invader_dieb8 =[$inv_deathb8, invader_dieb9] {};
void() invader_dieb9 =[$inv_deathb9, invader_dieb10] {};
void() invader_dieb10 =[$inv_deathb10, invader_dieb10] {};

void() invader_diec =[$inv_deathc1, invader_diec2] {};
void() invader_diec2 =[$inv_deathc2, invader_diec3] {};
void() invader_diec3 =[$inv_deathc3, invader_diec4] {};
void() invader_diec4 =[$inv_deathc4, invader_diec5]
{
	decal_monster2(self.origin + '0 0 12');
};
void() invader_diec5 =[$inv_deathc5, invader_diec6] {};
void() invader_diec6 =[$inv_deathc6, invader_diec7] {};
void() invader_diec7 =[$inv_deathc7, invader_diec8] {};
void() invader_diec8 =[$inv_deathc8, invader_diec9] {};
void() invader_diec9 =[$inv_deathc9, invader_diec10] {};
void() invader_diec10 =[$inv_deathc10, invader_diec10] {};

void() invader_died =[$inv_deathd1, invader_died2] {};
void() invader_died2 =[$inv_deathd2, invader_died3] {};
void() invader_died3 =[$inv_deathd3, invader_died4] {};
void() invader_died4 =[$inv_deathd4, invader_died5]
{
	decal_monster2(self.origin + '0 0 12');
};
void() invader_died5 =[$inv_deathd5, invader_died6] {};
void() invader_died6 =[$inv_deathd6, invader_died7] {};
void() invader_died7 =[$inv_deathd7, invader_died8] {};
void() invader_died8 =[$inv_deathd8, invader_died9] {};
void() invader_died9 =[$inv_deathd9, invader_died10] {};
void() invader_died10 =[$inv_deathd10, invader_died11] {};
void() invader_died11 =[$inv_deathd11, invader_died12] {};
void() invader_died12 =[$inv_deathd12, invader_died13] {};
void() invader_died13 =[$inv_deathd13, invader_died14] {};
void() invader_died14 =[$inv_deathd14, invader_died15] {};
void() invader_died15 =[$inv_deathd15, invader_died16] {};
void() invader_died16 =[$inv_deathd16, invader_died17] {};
void() invader_died17 =[$inv_deathd17, invader_died18] {};
void() invader_died18 =[$inv_deathd18, invader_died19] {};
void() invader_died19 =[$inv_deathd19, invader_died20] {};
void() invader_died20 =[$inv_deathd20, invader_died20] {};

void() invader_gibdead = { local string tagname;local float tagindex;local vector tagorg;
	if (!self.headless)
	{
		tagname = ("tag_head");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib3(self, "models/enemies/invader/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib1, self), 0, 1);
	}

	if ((self.skin != 2) || (self.skin != 3))
	{
		tagname = ("tag_arm_l");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		explo_blood(20, tagorg);
		ThrowGib3(self, "models/enemies/invader/gibs/gib_arm_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib2, self), 0, 3);
	}

	tagname = ("tag_arm_r");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	explo_blood(20, tagorg);
	explo_blood(9, self.origin);
	ThrowGib3(self, "models/enemies/invader/gibs/gib_arm_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib3, self), 0, 3);
	tagname = ("tag_body");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	ThrowGib3(self, "models/enemies/invader/gibs/gib_body_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib4, self), 0, 3);
	ThrowGib3(self, "models/enemies/invader/gibs/gib_body_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib5, self), 0, 3);
	explo_blood(2, tagorg);

	tagname = ("tag_hair_a");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	ThrowGib3(self, "models/enemies/invader/gibs/gib_hair_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib6, self), 0, 3);
	tagname = ("tag_hair_b");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	explo_blood(2, tagorg);
	ThrowGib3(self, "models/enemies/invader/gibs/gib_hair_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib7, self), 0, 3);
	tagname = ("tag_hair_c");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	ThrowGib3(self, "models/enemies/invader/gibs/gib_hair_c.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib8, self), 0, 3);
	tagname = ("tag_leg_l");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	explo_blood(2, tagorg);
	ThrowGib3(self, "models/enemies/invader/gibs/gib_leg_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib9, self), 0, 3);
	tagname = ("tag_leg_r");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	explo_blood(2, tagorg);
	ThrowGib3(self, "models/enemies/invader/gibs/gib_leg_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib10, self), 0, 3);
	ThrowGib2("models/gibs/gib_small.md3", self.health *0.25, 0.75, 1, 1, self.origin, relvel(inv_gib11, self), 0, 0);
	ThrowGib2("models/gibs/gib_small.md3", self.health *0.25, 0.75, 1, 1, self.origin, relvel(inv_gib12, self), 0, 0);
	ThrowGib2("models/gibs/gib_med.md3", self.health *0.25, 0.75, 1, 1, self.origin, relvel(inv_gib13, self), 0, 0);
	ThrowGib2("models/gibs/gib_med.md3", self.health *0.25, 0.75, 1, 1, self.origin, relvel(inv_gib14, self), 0, 0);
	remove_monster(self);
};

void() invader_death = {	//	if(self.pain_finished > time)
	//		return;

	local string tagname;
	local float tagindex;
	local vector tagorg;

	if (self.deathanim)
		return;
	self.solid = SOLID_NOT;
	local float rpf;
	drop_item(self.origin + '0 0 0', "shells_inv", 4, self);
	monstersound4("enemies/invader/die", 5, CHAN_VOICE);
	if (self.health < invader_gdv)
	{
		decal_monster(self.origin + '0 0 12');
		//void(float effectnum, vector org, vector vel, float howmany) pointparticles = #337;	// same as in CSQC

		//void(vector mincorner, vector maxcorner, float explosionspeed, float howmany) te_bloodshower = #406;

		invader_gibdead();
		return;
	}

	rpf = floor(random() *4) + 1;
	if (rpf == self.deathanim)
		rpf += 1;
	if (rpf > 4)
		rpf = 1;
	self.deathanim = rpf;
	if (rpf == 1)
	{
		self.deathanim = 1;
		self.think = invader_diea;
	}

	if (rpf == 2)
	{
		self.deathanim = 2;
		self.think = invader_dieb;
	}

	if (rpf == 3)
	{
		self.deathanim = 3;
		self.think = invader_diec;
	}

	if (rpf == 4)
	{
		self.deathanim = 4;
		ai_face();
		if (self.skin != 1)
		{
			tagname = ("tag_head");
			tagindex = gettagindex(self, tagname);
			tagorg = gettaginfo(self, tagindex);
			local vector distancedelta, nozdistancedelta, headvel;
			makevectors(self.angles);
			distancedelta = (self.enemy.origin + '0 0 8') - tagorg;	//work out distance vector  
			nozdistancedelta = distancedelta;	//copy to no height distance vector 
			nozdistancedelta_z = 0;	//remove height 
			headvel = normalize(distancedelta);	//set the velocity to the distance
			headvel = headvel * 600;	//give it more power 
			headvel_z = headvel_z + 120 + vlen(nozdistancedelta) *0.15 *(1 + (0.15));
			ThrowGib3(self, "models/enemies/invader/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, inv_gib1, 0, 1);
			self.headless = 1;
			self.skin += 1;
		}

		self.think = invader_died;
	}

	if ((self.deathanim >= 1) && (self.deathanim <= 3))
	{
		if (self.skin != 1)
		{
			tagname = ("tag_head");
			tagindex = gettagindex(self, tagname);
			tagorg = gettaginfo(self, tagindex);
			ThrowGib3(self, "models/enemies/invader/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(inv_gib1, self), 0, 1);
			self.headless = 1;
			self.skin += 1;
		}
	}

	self.nextthink = time;
};

///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_invader (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() precache_monster_invader = { precache_model("models/enemies/invader/invader.md3");
	precache_model("models/enemies/invader/gibs/gib_head.md3");
	precache_model("models/enemies/invader/gibs/gib_arm_l.md3");
	precache_model("models/enemies/invader/gibs/gib_arm_r.md3");
	precache_model("models/enemies/invader/gibs/gib_body_l.md3");
	precache_model("models/enemies/invader/gibs/gib_body_r.md3");
	precache_model("models/enemies/invader/gibs/gib_leg_l.md3");
	precache_model("models/enemies/invader/gibs/gib_leg_r.md3");
	precache_model("models/enemies/invader/gibs/gib_hair_a.md3");
	precache_model("models/enemies/invader/gibs/gib_hair_b.md3");
	precache_model("models/enemies/invader/gibs/gib_hair_c.md3");
	precache_model("models/enemies/invader/muzzle_flash.md3");
	precache_model("particles/explo/explo_invader.md3");
	precache_model("models/items/shells_drop.md3");
	precache_sound("enemies/invader/idle1.ogg");
	precache_sound("enemies/invader/idle2.ogg");
	precache_sound("enemies/invader/idle3.ogg");
	precache_sound("enemies/invader/chatter1.ogg");
	precache_sound("enemies/invader/chatter2.ogg");
	precache_sound("enemies/invader/chatter3.ogg");
	precache_sound("enemies/invader/chatter4.ogg");
	precache_sound("enemies/invader/chatter5.ogg");
	precache_sound("enemies/invader/fire1.ogg");
	precache_sound("enemies/invader/fire2.ogg");
	precache_sound("enemies/invader/fire3.ogg");
	precache_sound("enemies/invader/melee1.ogg");
	precache_sound("enemies/invader/melee2.ogg");
	precache_sound("enemies/invader/melee3.ogg");
	precache_sound("enemies/invader/pain1.ogg");
	precache_sound("enemies/invader/pain2.ogg");
	precache_sound("enemies/invader/pain3.ogg");
	precache_sound("enemies/invader/pain4.ogg");
	precache_sound("enemies/invader/pain5.ogg");
	precache_sound("enemies/invader/sight1.ogg");
	precache_sound("enemies/invader/sight2.ogg");
	precache_sound("enemies/invader/sight3.ogg");
	precache_sound("enemies/invader/die1.ogg");
	precache_sound("enemies/invader/die2.ogg");
	precache_sound("enemies/invader/die3.ogg");
	precache_sound("enemies/invader/die4.ogg");
	precache_sound("enemies/invader/die5.ogg");
	precache_sound("enemies/invader/step1.ogg");
	precache_sound("enemies/invader/step2.ogg");
	precache_sound("enemies/invader/step3.ogg");
	precache_sound("enemies/invader/step4.ogg");
	precache_sound("enemies/invader/step5.ogg");
};

void() invader_touch =
{
if(!(other.flags & FL_MONSTER))
return;
if(self.timeangles <= other.timeangles)
{
self.ideal_yaw = other.angles_y;
self.think = other.think;
ChangeYaw();
}
else
{
other.ideal_yaw = self.angles_y;
local entity oself;
oself = self;
self = other;
self.think = oself.think;
ChangeYaw();
self = oself;
}
};

void() monster_invader = { precache_model("models/enemies/invader/invader.md3");
	precache_model("models/enemies/invader/gibs/gib_head.md3");
	precache_model("models/enemies/invader/gibs/gib_arm_l.md3");
	precache_model("models/enemies/invader/gibs/gib_arm_r.md3");
	precache_model("models/enemies/invader/gibs/gib_body_l.md3");
	precache_model("models/enemies/invader/gibs/gib_body_r.md3");
	precache_model("models/enemies/invader/gibs/gib_leg_l.md3");
	precache_model("models/enemies/invader/gibs/gib_leg_r.md3");
	precache_model("models/enemies/invader/gibs/gib_hair_a.md3");
	precache_model("models/enemies/invader/gibs/gib_hair_b.md3");
	precache_model("models/enemies/invader/gibs/gib_hair_c.md3");
	precache_model("models/enemies/invader/muzzle_flash.md3");
	precache_model("particles/explo/explo_invader.md3");
	precache_model("models/items/shells_drop.md3");
	if (deathmatch)
	{
		remove(self);
		return;
	}

	local float r;
	r = (random() *3);
	if (r < 3)
		self.noise = "enemies/invader/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/invader/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/invader/sight1.ogg";

	if (self.waypointed != 1)
		self.waypointed = 0;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/invader/invader.md3");
	setsize(self, invader_bbox *-0.5, invader_bbox *0.5);
	self.health = invader_health;
	self.classname = "monster_invader";
	self.th_stand = invader_stand;
	self.th_walk = invader_walk;
	if (!self.turret)
		self.th_run = invader_run;
	else
		self.th_run = invader_preattack;
	self.th_missile = invader_preattack;
	//self.touch =invader_touch;
	self.th_melee = invader_sattack;
	self.th_pain = invader_pain;
	self.th_die = invader_death;
	walkmonster_start();
};

////////////////end of qc file