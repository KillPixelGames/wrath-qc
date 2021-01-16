float(float v) anglemod;

void() ai_face;

.float waypointed;
float enemy_vis, enemy_infront, enemy_range;
float enemy_yaw;

//float	current_yaw;
.float lavatime;
float() CheckAttack = 
{
	local vector spot1, spot2;
	local entity targ;
	local float chance;

	targ = self.enemy;

	// see if any entities are in the way of the shot
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = rorigin(targ) + targ.view_ofs;

	wtraceline(spot1, spot2, FALSE, self);

	if (trace_ent != targ)
		return FALSE;	// don't have a clear shot

	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	if (enemy_range == RANGE_MELEE)
	{
		// melee attack
		if (self.th_melee)
		{
			self.th_melee();

			return TRUE;
		}
	}

	// missile attack
	if (!self.th_missile)
		return FALSE;

	if (time < self.attack_finished)
		return FALSE;

	if (enemy_range == RANGE_FAR)
		return FALSE;

	if (enemy_range == RANGE_MELEE)
	{
		chance = 0.9;
		self.attack_finished = 0;
	}
	else if (enemy_range == RANGE_NEAR)
	{
		if (self.th_melee)
			chance = 0.2;

		else
			chance = 0.4;
	}
	else if (enemy_range == RANGE_MID)
	{
		if (self.th_melee)
			chance = 0.05;

		else
			chance = 0.1;
	}
	else
		chance = 0;

	if (random() < chance)
	{
		self.th_missile();
		SUB_AttackFinished(2* random());

		return TRUE;
	}

	return FALSE;
};

/*=============
ai_face

Stay facing the enemy
=============*/
void() invader_run;
void() wretch_run1;
void() oppressor_run1;
void()afflicted_run1;
.entity lasttrigger;
.float timeangles;

void()deactivate_turret =
{
	
	if(self.turret == 1)
	self.turret = 0;
	self.temp_turret = 0;
	if(self.classname == "monster_stricken")
	self.th_run = stricken_run1;
	if(self.classname == "monster_afflicted")
	self.th_run = afflicted_run1;
	if(self.classname == "monster_invader")
	self.th_run = invader_run;
	if(self.classname == "monster_wretch")
	self.th_run = wretch_run1;
	if(self.classname == "monster_oppressor")
	self.th_run = oppressor_run1;
	self.turret_enemy_visible = 0;
	self.turret_time = time + 2.5;	
	self.lasttrigger = world;
	self.timeangles = (time + 0.5);
	self.think = self.th_run;
	self.nextthink = time;

};
.float time_noturret2;
void()deactivate_turret2 =
{
	
	if(self.classname == "monster_stricken")
	self.th_run = stricken_run1;
	if(self.classname == "monster_afflicted")
	self.th_run = afflicted_run1;
	if(self.classname == "monster_invader")
	self.th_run = invader_run;
	if(self.classname == "monster_wretch")
	self.th_run = wretch_run1;
	if(self.classname == "monster_oppressor")
	self.th_run = oppressor_run1;

	self.temp_turret = 0;
	self.turret_enemy_visible = 0;
	self.turret_time = time + 2.5;	
	self.lasttrigger = world;
	self.time_noturret2 = random(2, 5);
	self.timeangles = (time + 0.5);
	self.think = self.th_run;
	self.nextthink = time;

};
.float player_temp_enemy;
.float run_time;
.vector lastplace_spoted;



void() ai_face = 
{
	


/*	if(self.forced_idle_time > time)
	{
		self.nextthink = self.nextthink + 0.1;//dist = dist * 0.25;
	}*/

	if(!self.enemy.health)
	{
	next_enemy();
	return;
	}
	if((!self.takedamage) && (self.classentity == "monsters"))
	self.takedamage = DAMAGE_AIM;

	float enemy_is_visible = visible(self.enemy);


		
	if((enemy_is_visible) && (time < self.run_time) && (self.turret != 1))
		self.lastplace_spoted = self.enemy.origin;

	self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
	
	if((self.turret ==  2) && (self.time_noturret2 < time)) 
	{
		if (!enemy_is_visible) 
		{
		self.ideal_yaw = vectoyaw(self.lastplace_spoted - rorigin(self));
		ChangeYaw();
		deactivate_turret2();
		return;	
		}
	}
	
	if((self.temp_turret ==  1))
	{
		makevectors2(self.subangles);
		vector vec = normalize((rorigin(self.enemy) - rorigin(self)));
		float dot = vec * v_forward;
		if ((dot < self.minorangle))
		{
			self.ideal_yaw = self.angles_y;
			deactivate_turret();
		}
	}
	ChangeYaw();

};

float(entity targ) oldvisible;
float(entity targ) visible;
float(entity targ) infront;
float(entity targ) range;

void(float d) ai_charge = 
{
	ai_face();
	movetogoal(d);	// done in C code...
};

void() ai_charge_side = 
{
	local vector dtemp;
	local float heading;

	// aim to the left of the enemy for a flyby
	self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
	ChangeYaw();

	makevectors2(self.angles);
	dtemp = rorigin(self.enemy) - 30 * v_right;
	heading = vectoyaw(dtemp - rorigin(self));

	walkmove(heading, 20);

};

/*=============
ai_melee

=============*/
void() ai_melee = 
{
	local vector delta;
	local float ldmg;

	if (!self.enemy)
		return;	// removed before stroke

	delta = rorigin(self.enemy) - rorigin(self);

	if (vlen(delta) > 60)
		return;

	ldmg = (random() + random() + random()) *3;
	T_Damage(self.enemy, self, self, ldmg);
};

void() ai_melee_side = 
{
	local vector delta;
	local float ldmg;

	if (!self.enemy)
		return;	// removed before stroke

	ai_charge_side();

	delta = rorigin(self.enemy) - rorigin(self);

	if (vlen(delta) > 60)
		return;

	if (!CanDamage(self.enemy, self))
		return;
	ldmg = (random() + random() + random()) *3;
	T_Damage(self.enemy, self, self, ldmg);
};

void() movetarget_f;
void() t_movetarget;

void(entity etemp, entity stemp, entity stemp, float dmg) T_Damage;

entity sight_entity;
float sight_entity_time;

void makevectors2(vector ang) = 
{
	ang_x *= -1;
	makevectors(ang);
};

float(float v) anglemod = 
{
	while (v >= 360)
		v = v - 360;
	while (v < 0)
		v = v + 360;
	return v;
};



void() movetarget_f = 
{
	if ((!self.targetname) && (self.classname != "path_corner_start"))
		objerror("monster_movetarget: no targetname");

	self.solid = SOLID_TRIGGER;
	self.touch = t_movetarget;
	setsize(self, '-8 -8 -8', '8 8 8');

};

void() path_corner = 
{
	movetarget_f();
};

void() path_corner_start = 
{
	movetarget_f();
};

.entity lastpathed;
.entity lastpathed2;
.entity lastpathed3;

void() t_movetarget = 
{
	local entity temp;

	if (other.movetarget != self)
		return;

	if (other.enemy)
		return;	// fighting, not following a path

	other.lastpathed3 = other.lastpathed2;
	other.lastpathed2 = other.lastpathed;
	other.lastpathed = self;

	temp = self;
	self = other;
	other = temp;

	//	if (self.classname == "monster_ogre")
	//		sound (self, CHAN_VOICE, "ogre/ogdrag.wav", 1, ATTN_IDLE);// play chainsaw drag sound

	//dprint ("t_movetarget\n");
	self.goalentity = self.movetarget = find(world, targetname, other.target);
	if (other.classname == "place_model")
	{
		if (self.speed)
			other.speed = self.speed;
	}

	self.ideal_yaw = vectoyaw(self.goalentity.origin - rorigin(self));
	float r = random();
	if ((self.pathed == 1) && (self.pathtime < time) && (r > 0.8))
		self.pathtime = time + 0.5;

	if (visible(self.oldenemy))
	{
		if (self.th_missile)
		{
			self.ideal_yaw = vectoyaw(self.oldenemy.origin - self.origin);
			self.enemy = self.oldenemy;
			self.goalentity = self.enemy;
			self.th_missile();
		}
	}

	if (!self.movetarget)
	{
		self.pausetime = time + 999999;
		self.th_stand();
		return;
	}
};


float(entity targ) hear_range = 
{
	local vector spot1, spot2;
	local float r;
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = rorigin(targ) + targ.view_ofs;

	r = vlen(spot1 - spot2);

	if (r < 128)
		return RANGE_MELEE;
	if (r < 512)
		return RANGE_NEAR;
	if (r < 4096)
		return RANGE_MID;

	return RANGE_FAR;
};
.float movingz;
.float noattack;
float(entity targ) range = 
{
	local vector spot1, spot2;
	local float r;
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = rorigin(targ) + targ.view_ofs;

	r = vlen(spot1 - spot2);

	if (self.trinket_touched == 1)
		return RANGE_FAR;

	if (targ.noattack == 1)
		return RANGE_FAR;

	if (!targ.health)
		return RANGE_FAR;

	if (self.classname == "monster_oppressor")
	{
		if (r < opp_near)
			return RANGE_MELEE;
		if (r < opp_mid)
			return RANGE_NEAR;
		if (r < opp_far)
			return RANGE_MID;
	}
	else if (self.classname == "heretic")
	{
		if (r < 60)
			return RANGE_MELEE;

		if (r < 1000)
			return RANGE_NEAR;
		if (r < 4096)
			return RANGE_MID;
	}
	else if (self.classname == "monster_afflicted")
	{
		if (r < 75)
			return RANGE_MELEE;
		if (r < 2048)
			return RANGE_NEAR;
		if (r < 4096)
			return RANGE_MID;
	}
	else if (self.classname == "monster_incisor")
	{
		if (r < incisor_near)
			return RANGE_MELEE;
		if (r < incisor_mid)
			return RANGE_NEAR;
		if (r < incisor_far)
			return RANGE_MID;
	}
	else if (self.classname == "monster_wretch")
	{
		if (r < wretch_near)
			return RANGE_MELEE;
		if (r < wretch_mid)
			return RANGE_NEAR;
		if (r < wretch_far)
			return RANGE_MID;
	}
	else if (self.classname == "monster_stricken")
	{
		//if((self.enemy.classname == "monster_stricken") || (self.enemy.classname == "executioner"))
		//stricken_near += 128;
		
		if (r < stricken_near)
			return RANGE_MELEE;
		if (r < stricken_mid)
			return RANGE_NEAR;
		if (r < stricken_far)
			return RANGE_MID;
	}
	else if (self.classname == "monster_invader")
	{
		if (r < invader_near)
			return RANGE_MELEE;
		if (r < invader_mid)
			return RANGE_NEAR;
		if (r < invader_far)
			return RANGE_MID;
	}

	/*
	else if (self.classname == "monster_fallen")
	{
		if (r < fallen_near)
			return RANGE_MELEE;
		if (r < fallen_mid)
			return RANGE_NEAR;
		if (r < fallen_far)
			return RANGE_MID;
	}*/
	else if (self.classname == "monster_heretic")
	{
	
		if(self.movingz == 1)
		{
			if (r < heretic_near + 16)
				return RANGE_MELEE;
		}
		else
		{
			if (r < heretic_near)
				return RANGE_MELEE;
		}
		if (r < heretic_mid)
			return RANGE_NEAR;
		if (r < heretic_far)
			return RANGE_MID;
	}
	else if (self.classname == "monster_widow")
	{
		if (r < widow_near)
			return RANGE_MELEE;
		if (r < widow_mid)
			return RANGE_NEAR;
		if (r < widow_far)
			return RANGE_MID;
	}
	else if (self.classname == "monster_wraith")
	{
		if (r < 128)
			return RANGE_MELEE;
		if (r < 1024)
			return RANGE_NEAR;
		if (r < 4096)
			return RANGE_MID;
	}
	else if (self.classname == "monster_fallen")
	{
		if (self.enemy.crouch == 1)
		{
			if (r < 256)
				return RANGE_MELEE;
		}
		else
		{
			if (r < 256)
				return RANGE_MELEE;
		}

		if (r < 1024)
			return RANGE_NEAR;
		if (r < 4096)
			return RANGE_MID;
	}
	else
	{
		if (r < 120)
			return RANGE_MELEE;
		if (r < 500)
			return RANGE_NEAR;
		if (r < 4096)
			return RANGE_MID;
	}

	return RANGE_FAR;
};



float(entity targ) rvisible = 
{
	local vector spot1, spot2;

	spot1 = rorigin(self);
	spot2 = rorigin(targ);
	traceline(spot1, spot2, TRUE, self);	// see through other monsters

	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};


float(entity targ, float forent) rvisible2 = 
{
	local vector spot1, spot2;

	spot1 = rorigin(self);
	spot2 = rorigin(targ);
	local vector step_height;
	step_height_z = self.stepheight_delta + 16;
	tracebox(spot1, self.absmin + step_height, self.absmax, spot2, FALSE, self);

	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

float(entity targ) oldvisible = 
{
	local vector spot1, spot2;

	spot1 = self.origin + '0 0 16';
	spot2 = targ.origin + '0 0 16';
	traceline(spot1, spot2, TRUE, self);	// see through other monsters
	
	if((targ.flags & FL_MONSTER) && (targ.health <= 0))
		return FALSE;	// sight line crossed contents
	
	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

float(entity targ) reachable = 
{
	if (oldvisible(targ))
		return TRUE;
	return FALSE;
}

float(entity targ, entity e) reachable2 = 
{ 
	self = e;
	if (oldvisible(targ))
		return TRUE;
	return FALSE;
}

float(entity targ) run_visible = 
{
	local vector spot1, spot2;
	if(!targ)
		return FALSE;
	spot1 = self.origin + '0 0 16';
	spot2 = targ.origin + '0 0 16';
	wtraceline(spot1, spot2, TRUE, world);	// see through other monsters
	if((targ.flags & FL_MONSTER) && (targ.health <= 0))
		return FALSE;	// sight line crossed contents
	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents
	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

float(entity targ) visible = 
{
	local vector spot1, spot2;
	if(!targ)
		return FALSE;


	spot1 = self.origin + '0 0 16';
	spot2 = targ.origin + '0 0 16';
	wtraceline(spot1, spot2, TRUE, world);	// see through other monsters

	if((targ.flags & FL_MONSTER) && (targ.health <= 0))
		return FALSE;	// sight line crossed contents
	


	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};


float(vector spot1, vector spot2, entity e) visibleb = 
{
	traceline(spot1, spot2, TRUE, e);	// see through other monsters
	
	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};



float(entity targ) visible_complex = 
{
	local vector spot1, org; // fisible
	local float thruwater, pc1, pc2;
	if(!targ)
		return FALSE;
	org = rorigin(targ);
	spot1 = rorigin(self) + self.view_ofs;

	if (targ.solid == SOLID_BSP)
	{
		wtraceline(spot1, org, TRUE, self);
		if (trace_ent == targ)
			return TRUE;
		else if (trace_fraction == 1)
			return TRUE;
		return FALSE;
	}
	else
	{
		pc1 = pointcontents(org);
		pc2 = pointcontents(spot1);
		if (targ.classname == "player")
			thruwater = FALSE;
		else if (pc1 == CONTENT_LAVA)
			return FALSE;
		else
			thruwater = TRUE;
	}

	if (pc1 < -1)	// targ's origin is in water or other liquid
	{
		if (pc2 != pc1)
		{
			// look for their head
			wtraceline(spot1, org + targ.mins, TRUE, self);
			// cross the water check
			if (trace_inopen)
				if (trace_inwater)
					if (!thruwater)
						return FALSE;
			if (trace_ent == targ)
				return TRUE;
			else if (trace_fraction == 1)
				return TRUE;
			return FALSE;
		}
	}
	else
	{
		if (pc2 != pc1)
		{
			wtraceline(spot1, org + targ.maxs, TRUE, self);
			if (trace_inopen)
				if (trace_inwater)
					if (!thruwater)
						return FALSE;
			if (trace_ent == targ)
				return TRUE;
			else if (trace_fraction == 1)
				return TRUE;
			return FALSE;
		}
	}

	wtraceline(spot1, org, TRUE, self);
	if (trace_ent == targ)
		return TRUE;
	else if (trace_fraction == 1)
		return TRUE;

	wtraceline(spot1, org + targ.maxs, TRUE, self);
	if (trace_ent == targ)
		return TRUE;
	else if (trace_fraction == 1)
		return TRUE;

	wtraceline(spot1, org + targ.mins, TRUE, self);
	if (trace_ent == targ)
		return TRUE;
	else if (trace_fraction == 1)
		return TRUE;

	return FALSE;
};

float(entity targ, float dist, float drange) visible2 = 
{
	local vector spot1, spot2;
	local float d;
	if(!targ)
		return FALSE;


	if (targ.health <= 0)
		return FALSE;
	if (!drange)
		drange = 0.3;
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = rorigin(targ) + targ.view_ofs;

	local vector vec;
	local float dot;
	
	if((self.classname == "executioner") && ((self.enemy.classname == "monster_stricken") || (self.enemy.classname == "executioner")))
	dist += 64;

	d = vlen(spot1 - spot2);
	if (d > dist)
		return FALSE;

	wtraceline(spot1, spot2, TRUE, self);	// see through other monsters

	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	makevectors2(self.angles);
	vec = normalize(spot2 - spot1);
	dot = vec * v_forward;

	if (dot < drange)
		return FALSE;

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};
float(entity targ, float dist) visibleinfrontn = 
{
	local vector vec, spot1, spot2;
	local float dot, d;

	//	spot1 = rorigin(self) + self.view_ofs;
	//	spot2 = targ.origin + targ.view_ofs;
	
	if(targ.health < 0)
		return FALSE;
	if(!targ)
		return FALSE;
	
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = rorigin(targ) + targ.view_ofs;
	d = vlen(spot1 - spot2);
	if (d < dist)
		return FALSE;

	wtraceline(spot1, spot2, TRUE, self);	// see through other monsters

	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	makevectors2(self.angles);
	//	vec = normalize (targ.origin - rorigin(self));
	vec = normalize(rorigin(targ) - rorigin(self));
	dot = vec * v_forward;

	if (dot < 0.3)
	{
		return FALSE;
	}

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;

};
float(entity targ, float dist) visibleinfront = 
{ 
	local vector vec, spot1, spot2;
	local float dot, d;

	//	spot1 = rorigin(self) + self.view_ofs;
	//	spot2 = targ.origin + targ.view_ofs;
	
	if(targ.health < 0)
		return FALSE;
	if(!targ)
		return FALSE;
	
	spot1 = rorigin(self) + self.view_ofs;
	spot2 = rorigin(targ) + targ.view_ofs;
	d = vlen(spot1 - spot2);
	if (d > dist)
		return FALSE;

	wtraceline(spot1, spot2, TRUE, self);	// see through other monsters

	if (trace_inopen && trace_inwater)
		return FALSE;	// sight line crossed contents

	makevectors2(self.angles);
	//	vec = normalize (targ.origin - rorigin(self));
	vec = normalize(rorigin(targ) - rorigin(self));
	dot = vec * v_forward;

	if (dot < 0.3)
	{
		return FALSE;
	}

	if (trace_fraction == 1)
		return TRUE;
	return FALSE;

};

float(entity targ, vector viewerangles,vector viewerorigin,float viewerdeviance) custom_infront = 
{ 
	local vector vec;
	local float dot, dotvalue;

	if(viewerdeviance < 180)
		dotvalue = 1 / viewerdeviance;
	else
		dotvalue = (1 / viewerdeviance) * -1;

	vector spot1 = rorigin(targ);
	vector spot2 = viewerorigin;

	makevectors2(viewerangles);
	vec = normalize(spot1 - spot2);
	dot = vec * v_forward;
	if (dot > dotvalue)
	{
		return TRUE;
	}
	return FALSE;
};

float(entity targ) infront = 
{ 
	local vector vec;
	local float dot;
	makevectors2(self.angles);
	vec = normalize(rorigin(targ) - rorigin(self));
	dot = vec * v_forward;

	if (dot > 0.3)
	{
		return TRUE;
	}

	return FALSE;
};

//============================================================================
.float turret;
.float likecharge;
void() executioner_chrgrandom;
void() executioner_chargesh2;

void() HuntTarget = 
{ 
	self.goalentity = self.enemy;
	float r;
	r = random();

	if (self.classname == "executioner")
	{
		if (self.likecharge == 1)
			self.think = self.th_charge;
		else
		{
			if ((visible2(self.enemy, 512, 0.5)))
				self.think = self.th_charge;
			else
				self.think = self.th_run;
		}
	}
	else
		self.think = self.th_run;
	self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
	SUB_AttackFinished(1);	// wait a while before first attack
	self.nextthink = time + 0.05;
};
.float widowsight;
.float widowscreamingtime;

.float nextenemy_time;
.float nextenemy;

void() FoundTarget = 
{ 
	if (self.enemy.classname == "player")
	{
		// let other monsters see this monster for a while
		sight_entity = self;
		sight_entity_time = time;
	}

	self.show_hostile = time + 1;	// wake up other monsters
	self.sight_time = time + 1;
		
	if(!self.nextenemy)
	{
		if (self.classname == "monster_widow")
		{
			sound(self, CHAN_ITEM, self.noise, 1, 0.25);
			self.widowscreamingtime = soundlength(self.noise) + time;
		}
		else
			sound(self, CHAN_AUTO, self.noise, 1, 0.25);
	}
	//void(vector org, float radius, float lifetime, vector color) te_customflash = #417;
	HuntTarget();
	/*if((self.classname == "executioner")||(self.classname == "monster_invader") ||(self.classname == "monster_stricken")||(self.classname == "monster_fallen"))
	return;
	else
	self.colormod = '0 1 0'; */
};

.float grosstime;

void() FindNearestPath = 
{ 
	local entity head, near;
	local float dist, low;
	low = 99999999;	
	head = find(world, classname, "path_corner_start");
	if (!head)
	{
		self.pathed = 0;
		self.th_run();
		return;
	}

	while (head)
	{
		//	if((reachable(head)) && (head !=  self.lastpathed) && (head !=  self.lastpathed2)&& (head !=  self.lastpathed3)) 
		if (reachable(head))
		{
			dist = vlen(head.origin - self.origin);
			if (dist < low)
			{
				low = dist;
				near = head;
			}
		}

		head = find(head, classname, "path_corner");
	}

	if (near)
	{
		if (!(self.pathtime < time))
			self.pathtime = time + 0.5;
		self.target = near.targetname;
		self.goalentity = self.movetarget = near;
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk();
	}
};

void() player_enemy =
{
		if((single_player.flags &FL_NOTARGET))
		return;

		local entity pl;
		pl = find(world, classname, "player");

		if(pl.health > 0)
		{
		self.enemy = pl;
		self.goalentity = pl;
		self.nextenemy = 1;
		if (self.friendly_monster == 1)
			self.player_temp_enemy = time + 1;
		FoundTarget();
		ai_face();
		}
		else
		{
		self.think= self.th_stand;
		self.nextthink = time;
		}
}

void() FindNearestEnemy = 
{ 
	local entity head, near;
	local float dist, low;
	low = 99999999;	
	head = find(world, classentity, "monsters");
	if(!head)
		{player_enemy(); return;}
	while (head)
	{
		if ((head != self) && (visible(head)))		
			if (head.health > 0)
			{
				dist = vlen(head.origin - self.origin);
				if((!(self.th_missile)) && (head.flyer == 1))
				dist = 999999999; 
				if(self.classname == head.classname)
				dist += 512;
				if(head.friendly_monster == 1)
				dist += 2048;
				if (dist < low)
				{
					low = dist;
					near = head;
				}
			}
		head = find(head, classentity, "monsters");
	}


	if (near)
	{
	self.enemy = near;
	self.nextenemy = 1;
	self.goalentity = near;
	FoundTarget();
	ai_face();
	return;
	}
	else
	{player_enemy(); return;}

};


void() next_enemy = 
{	
	self.enemy = world;	
	if (self.friendly_monster == 1)
		FindNearestEnemy();
	else
		player_enemy();
};

float() FindTarget = 
{ 
	local entity client;
	local float r;

	// if the first spawnflag bit is set, the monster will only wake up on
	// really seeing the player, not another monster getting angry

	// spawnflags &3 is a big hack, because zombie crucified used the first
	// spawn flag prior to the ambush flag, and I forgot about it, so the second
	// spawn flag works as well

	if (sight_entity_time >= time - 0.1 && !(self.spawnflags &3))
	{
		client = sight_entity;
		if (client.enemy == self.enemy)
			return TRUE;
	}
	else
	{

		if(!(single_player.flags &FL_NOTARGET))
		client = checkclient();
		if (!client)
			return FALSE;	// current check entity isn't in PVS
	}



	if (client == self.enemy)
		return FALSE;

	if (client.flags &FL_NOTARGET)
		return FALSE;

	//	if (client.items &IT_INVISIBILITY)
	//		return FALSE;

	if (self.classname == "monster_afflicted")
	{
		r = hear_range(client);
		if (r == RANGE_FAR)
			return FALSE;

		if (!visible(client))
			return FALSE;

		if (r == RANGE_NEAR)
		{
			if (client.show_hostile < time && !infront(client))
				return FALSE;
		}
		else if (r == RANGE_MID)
		{
			if (/*client.show_hostile < time || */ !infront(client))
				return FALSE;
		}
	}
	else
	{
		r = range(client);
		if (r == RANGE_FAR)
			return FALSE;

		if (!visible(client))
			return FALSE;

		if (r == RANGE_NEAR)
		{
			if (client.show_hostile < time && !infront(client))
				return FALSE;
		}
		else if (r == RANGE_MID)
		{
			if (/*client.show_hostile < time || */ !infront(client))
				return FALSE;
		}
	}

	self.enemy = client;
	if (self.enemy.classname != "player")
	{
		self.enemy = self.enemy.enemy;
		if (self.enemy.classname != "player")
		{
			self.enemy = world;
			return FALSE;
		}
	}

	FoundTarget();

	return TRUE;
};

//=============================================================================

void(float dist) ai_forward = 
{ 
	walkmove(self.angles_y, dist);
};

void(float dist) ai_back = 
{ 
	walkmove((self.angles_y + 180), dist);
};


void(float dist) ai_pain = 
{
	ai_back(dist);
};


void(float dist) ai_painforward = 
{ 
	walkmove(self.ideal_yaw, dist);
};


.float rollwalktoattack;
.float findtargettime;
.float painframe;
void(float dist) ai_walk = 
{ 

	if ((self.watertype == CONTENT_LAVA) || (self.lavatime > time))	// do lava damage
	{
	T_Damage(self, world, world, 10 *self.waterlevel);
	return;
	}
	movedist = dist;

	// check for noticing a player

	if (self.rollwalktoattack)
	{
		local float r;
		r = random() *100;
		if ((self.rollwalktoattack >= r) && (self.findtargettime > time))
		{
			if (FindTarget())
				return;
		}
	}

	if (self.pathed != 1)
	{
		if (FindTarget())
			return;
	}
	else
	{
		if (self.pathtime < time)
		{
			if (FindTarget())
				return;
		}
	}

	movetogoal(dist);
	//	movetogoal (dist);
	if (self.friendly_monster == 1 && vlen(self.origin - self.goalentity.origin) < 80)
	{
		self.pausetime = time + 1.5;
		self.th_stand();
	}
	if(self.enemy != world)
	self.th_run();
};

.float rise;

void() ai_stand = 
{
		if(self.trinket_touched == 1)
			self.trinket_touched = 0;

		self.timeangles  =  time + 0.5;
		if ((self.watertype == CONTENT_LAVA) || (self.lavatime > time))	// do lava damage
		{
			T_Damage(self, world, world, 10 *self.waterlevel);
			return;
		}

	if(self.nextenemy)
		{
		next_enemy();
		self.nextthink = time + 0.1;
		self.think = self.th_run;
		return;
		}
	if ((self.oldenemy) && (!self.enemy.health) )
	{
		self.enemy = self.oldenemy;
		if (self.enemy.health > 0)
		{
			self.th_run();
			return;
		}
	}
	
	if((self.exenemy) && (self.exenemy.health > 0) && (!self.enemy.health) && (self.friendly_monster != 1) )
	{
		self.enemy = self.exenemy;
		ai_face();
		self.exenemy = world;
		FoundTarget();
		return;
	}
	
	if ((self.grosstime > time) && (!(single_player.flags &FL_NOTARGET)))
	{
		FoundTarget();
		local entity pl;
		pl = find(world, classname, "player");
		self.enemy = pl;
		return;
	}

	if (FindTarget())
		return;

	if (time > self.pausetime)
	{
		self.th_walk();
		return;
	}

	// change angle slightly
};


void() ai_turn = 
{ 
	if (FindTarget())
		return;
	ChangeYaw();
};


void(vector dest3) ChooseTurn = 
{ 
	local vector dir, newdir;
	dir = rorigin(self) - dest3;
	newdir_x = trace_plane_normal_y;
	newdir_y = 0 - trace_plane_normal_x;
	newdir_z = 0;
	if (dir * newdir > 0)
	{
		dir_x = 0 - trace_plane_normal_y;
		dir_y = trace_plane_normal_x;
	}
	else
	{
		dir_x = trace_plane_normal_y;
		dir_y = 0 - trace_plane_normal_x;
	}

	dir_z = 0;
	self.ideal_yaw = vectoyaw(dir);
};


float() FacingIdeal = 
{ 
	local float delta;
	delta = anglemod(self.angles_y - self.ideal_yaw);
	if (delta > 45 && delta < 315)
		return FALSE;
	return TRUE;
};

float() wraithCheckAttack;

float() CheckAnyAttack = 
{ 
	if (!enemy_vis)
		return FALSE;
	if (self.classname == "monster_wraith")
		return wraithCheckAttack();
	return CheckAttack();
};


void() ai_run_melee = 
{ 
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (FacingIdeal())
	{
		self.th_melee();
		self.attack_state = AS_STRAIGHT;
	}

};


void() ai_run_missile = 
{ 
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (FacingIdeal())
	{
		self.th_missile();
		self.attack_state = AS_STRAIGHT;
	}
};

float(float righty) test_side_wall = 
{ 
	local vector source;
	local float dist;
	if (righty == 1)
		dist = 64;
	else
		dist = -64;
	makevectors(self.v_angle);
	source = self.origin;
	tracebox(source, '-1 -1 -1', '1 1 1', source + v_right *dist, FALSE, self);
	if (trace_fraction == 1)
		return FALSE;
	else
		return TRUE;
};

void() ai_run_slide = 
{ 
	local float ofs;
	self.ideal_yaw = enemy_yaw;
	ChangeYaw();
	if (self.lefty)
		ofs = 90;
	else
		ofs = -90;
	if (walkmove(self.ideal_yaw + ofs, movedist))
	{
		return;
	}

	walkmove(self.ideal_yaw + ofs, movedist);
};

void() mercenary_walktoattack;

void(float dist) ai_runwalkb = 
{ 
	movedist = dist;
	// see if the enemy is dead
	if(self.health < 0)
	{
	self.think = self.th_die;
	self.nextthink = time;
	return;
	}	
	if (!self.enemy.health)
	{
		self.enemy = world;
		// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
		}
		else
		{
			if (self.movetarget)
				self.th_walk();
			else
				self.th_stand();
			return;
		}
	}

	self.show_hostile = time + 1;	// wake up other monsters
	enemy_vis = visible(self.enemy);

	if (visible(self.enemy))
		self.search_time = time + 5;
	// look for other coop players
	if (coop && self.search_time < time)
	{
		if (FindTarget())
			return;
	}

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw((rorigin(self.enemy)) - rorigin(self));
	if (self.attack_state == AS_MISSILE)
	{
		ai_run_missile();
		return;
	}

	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee();
		return;
	}

	if (CheckAnyAttack())
		return;	// beginning an attack		
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide();
		return;
	}

	// head straight in
	self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
	ChangeYaw();
	if (!walkmove(self.angles_y, dist))
		movetogoal(dist);
};

void(float dist) ai_run = 
{ 
	movedist = dist;
	// see if the enemy is dead

	if (!self.enemy.health)
	{
		self.enemy = world;
		// FIXME: look all around for other targets
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
		}
		else
		{
			if (self.movetarget)
				self.th_walk();
			else
				self.th_stand();
			return;
		}
	}

	self.show_hostile = time + 1;	// wake up other monsters
	// check knowledge of enemy
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
		self.search_time = time + 5;
	// look for other coop players
	if (coop && self.search_time < time)
	{
		if (FindTarget())
			return;
	}

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw((rorigin(self.enemy)) - rorigin(self));
	if (self.attack_state == AS_MISSILE)
	{
		ai_run_missile();
		return;
	}

	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee();
		return;
	}

	if (CheckAnyAttack())
		return;	// beginning an attack		
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide();
		return;
	}

	// head straight in
	movetogoal(dist);
	// done in C code...
};

void(float dist) ai_runwalk2 = 
{ 
	if (dist <= 0)
	{
		self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
		ChangeYaw();
		return;
	}
	movedist = dist;
	movetogoal(dist);	// done in C code...
};

.float pathtomonstertime;
void(entity e, entity excep) changegoalentity = 
{ 
	local entity head, near;
	local float dist, low;
	low = 99999999;	

	head = find(world, classname, "path_waypoint");
	while (head)
	{
		dist = vlen(head.origin - e.origin);
		if (dist < low)
		{
			low = dist;

			if (head != excep)
			{
				self = e;
				if (visible(head) && oldvisible(head))
					near = head;
				e = self;
			}
		}

		head = find(head, classname, "path_waypoint");
	}

	if (near)
	{
		e.enemy = near;
		e.goalentity = near;
	}

	if (e.classname == "monster_widow")
		e.pathtomonstertime = time + 2.5;

};

.string classname2;

void(entity e, entity excep) changegoalentity2 = 
{ 
	local entity head, near;
	local float dist, low;
	low = 99999999;	

	head = find(world, classname2, "path_waypoint");
	while (head)
	{
		dist = vlen(head.origin - e.origin);
		if (dist < low)
		{
			low = dist;

			if (head != excep)
			{
				self = e;
				if (visible(head) && oldvisible(head))
					near = head;
				e = self;
			}
		}

		head = find(head, classname2, "path_waypoint");
	}

	if (near)
	{
		e.enemy = near;
		e.goalentity = near;
	}

	if (e.classname == "monster_widow")
		e.pathtomonstertime = time + 2.5;
};

void() path_waypointthink = 
{ 
	self.classname = "path_waypoint";
};

void() path_waypoint_touch = 
{ 
	if (!(other.flags &FL_MONSTER))
		return;
	if (other.enemy.classname == "player")
		return;
	changegoalentity(self, self);
	self.classname = "path_waypoint_waiting";
	other.enemy = self.enemy;
	self.think = path_waypointthink;
	self.nextthink = time + 2.5;
};

void() path_waypoint = 
{ 
	self.solid = SOLID_TRIGGER;
	setsize(self, '-12 -12 -12', '12 12 12');
	self.touch = path_waypoint_touch;
	self.classname2 = self.classname;
};

.float rotating_time;
.float lasttimespotted;
.vector vlasttimespotted;

void(vector org, entity e) dropwaypoint = 
{ 
	local entity head, near;
	local float dist, low;
	low = 99999999;	

	head = find(world, classname2, "path_waypoint");
	while (head)
	{
		dist = vlen(head.origin - org);
		if (dist < low)
		{
			low = dist;

			self = e;
			if (visible(head) && oldvisible(head))
				near = head;
			e = self;
		}

		head = find(head, classname2, "path_waypoint");
	}

	if (near)
	{
		e.enemy = near;
		e.goalentity = near;
	}
};

.vector oldmonsterorigin;
.float distoplayer;
.float origincounter;
.float timeroaming;
.float timestrafing;
.float heavy;
.float timeangles2;
.float movetogoal_time;
.float watching_enemy;
void()check_angles;
void()check_jump;
.float blocked_monster;

void () blocked_by_monster =
{
	vector spot1 = rorigin(self);
	vector step_height;
	float forwardcheck = self.absmax_y / 2 + 2;
	step_height_z = self.stepheight_delta + 16;
	makevectors(self.angles);
	tracebox(spot1, self.absmin + step_height, self.absmax, v_forward *forwardcheck, FALSE, self);
	if (trace_fraction == 1.0)
	{
		self.blocked_monster = 0;
	}
	else
	{
		if(trace_ent.flags & FL_MONSTER)
			self.blocked_monster = 1;
		else
			self.blocked_monster = 0;
	}
};

.float yaw_trigger_angle;
.float movetogoal_time;
.float follow_trigger_angle;
.float strafing;

void()check_angles =
{
	if(self.timeangles > time)
	return;
	
	makevectors(self.angles);
	local vector source = self.origin;
	
	float forwardcheck = self.absmax_y / 2 + 2;

	
	traceline(source,source + v_forward *forwardcheck +  v_up * -50, FALSE, self);
	makevectors(self.v_angle);

	if (trace_fraction == 1.0)
	{
		local vector best_place;
		
		traceline(source,source + v_forward * -64 +  v_right * 128 +  v_up * -50, FALSE, self);
		if (trace_fraction != 1.0)
		best_place = trace_endpos;
		else
		{
			traceline(source,source + v_forward * -64 +  v_right * -128 +  v_up * -50, FALSE, self);
			if (trace_fraction != 1.0)
				best_place = trace_endpos;
			else
			{
				traceline(source,source + v_forward * -256 + crandom() * (v_right * -128)+  v_up * -50, FALSE, self);
				best_place = trace_endpos;			
			}
		}
		self.lastplace_spoted = trace_endpos;
		self.timeangles = time+ 0.5 + random();
		self.timeangles2 = time + 2;
		return;
	}		
	
	
	tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *2 +  v_right * 128, FALSE, self);
	if (trace_fraction == 1.0)
	{
		self.lastplace_spoted = trace_endpos;
		self.timeangles = time+ 0.5 + random();
		self.timeangles2 = time + 2;
		return;
	}
	tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *2 +  v_right * -128, FALSE, self);
	if (trace_fraction == 1.0)
	{
		self.lastplace_spoted = trace_endpos;
		self.timeangles = time+ 0.5 + random();
		self.timeangles2 = time + 2;
		return;
	}
	
	
		tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *2 +  v_right * (forwardcheck * 2), FALSE, self);
	if (trace_fraction == 1.0)
	{
		self.lastplace_spoted = trace_endpos;
		self.timeangles = time+ 0.5 + random();
		self.timeangles2 = time + 2;
		return;
	}
	tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *2 +  v_right * (forwardcheck * -2), FALSE, self);
	if (trace_fraction == 1.0)
	{
		self.lastplace_spoted = trace_endpos;
		self.timeangles = time+ 0.5 + random();
		self.timeangles2 = time + 2;
		return;
	}
	
		makevectors(self.v_angle);
	source = self.origin;
	tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *(forwardcheck * -2) +  v_right * (forwardcheck * 2), FALSE, self);
	if (trace_fraction == 1.0)
	{
		self.lastplace_spoted = trace_endpos;
		self.timeangles = time+ 0.5 + random();
		self.timeangles2 = time + 2;
		return;
	}
	tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *(forwardcheck * -2)+  v_right *(forwardcheck * -2), FALSE, self);
	if (trace_fraction == 1.0)
	{
		self.lastplace_spoted = trace_endpos;
		self.timeangles = time+ 0.5 + random();
		self.timeangles2 = time + 2;		
		return;
	}
	tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *-128, FALSE, self);
	if (trace_fraction == 1.0)
	{
		self.lastplace_spoted = trace_endpos;
		self.timeangles = time+ 0.5 + random();
		self.timeangles2 = time + 2;		
		return;
	}
	
};
void() check_strafe =
{	
	if(self.classname == "monster_stricken")
		return;
	if(self.strafing >time)
		return;
	float y_size;
	y_size = movedist * 1;
	if (self.lefty)
		float ofs = 60;
	else
		ofs = -60;			
	if (walkmove (self.ideal_yaw + ofs, y_size))
	{
	self.strafing =  time + 0.5;return;
	}
	self.lefty = 1 - self.lefty;
	if (walkmove (self.ideal_yaw - ofs, y_size))
	{
		self.strafing =  time + 0.5;return;
	}
	if (walkmove (self.ideal_yaw + ofs, y_size * 0.5))
	{
		self.strafing =  time + 0.5;return;
	}
	self.lefty = 1 - self.lefty;
	if(walkmove (self.ideal_yaw - ofs, y_size * 0.5))
	{
		self.strafing =  time + 0.1;return;
	}
};
	
.float always_active;
.float always_active_time;

void(vector start, vector end) te_tei_g33 =
{
   WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST, 76);
   WriteCoord (MSG_BROADCAST, start_x);
   WriteCoord (MSG_BROADCAST, start_y);
   WriteCoord (MSG_BROADCAST, start_z);
   WriteCoord (MSG_BROADCAST, end_x);
   WriteCoord (MSG_BROADCAST, end_y);
   WriteCoord (MSG_BROADCAST, end_z);
   WriteCoord (MSG_BROADCAST, 0);
   WriteCoord (MSG_BROADCAST, 0);
   WriteCoord (MSG_BROADCAST, 0);
};

.float following_a_node;
.float following_a_node_timer;
void()spawned_ghost_think =
{
	self.alphatime = 1;
	self.nextthink = time;
	self.think = alphafade;
	self.alpha = 0.25;
};

void (entity e) spawnghost  =
{
	e.alpha = 0.5;
	entity ghost_spawned = spawn();
	ghost_spawned.origin = e.origin;
	ghost_spawned.colormod = '1 0.7 0.7';
	ghost_spawned.angles = e.angles;
	ghost_spawned.frame = e.frame;
	setmodel(ghost_spawned,e.model);
	ghost_spawned.think = spawned_ghost_think;
	ghost_spawned.nextthink = time + 0.1;
	ghost_spawned.alpha = -1;
};

.float evade;
float(entity t)run_visible;
.float evading_time;
.float runingcycle;

void(float dist) ai_runwalk = 
{
	self.run_time = time + 0.1;

	if(self.health < 0)
	{
		self.think = self.th_die;
		self.nextthink = time;
		return;
	}	

	if(self.forced_idle_time < time)
	{
		if(self.trinket_touched == 1)
		{
			self.trinket_touched = 0;
		
		}

	}
	movedist = dist;

	if((self.classname == "monster_widow") && (self.runingcycle == 1))
	{
		walkmovedist(self.angles_y, movedist);
		self.runingcycle = 0;
		return;
	}
	if((self.classname == "monster_widow") && (self.runingcycle != 1))
	{
		self.runingcycle = 1;
	}

	if(self.evading_time > time)
	{
		float walk_dist = dist;
		if(self.strafing >time)
			walk_dist = dist * 0.5;

		float walkeddist = walkmovedist(self.angles_y, walk_dist);
		
		if(walkeddist < dist * 0.5)
		{

			if(self.timeangles2 < time)
			{
				//self.ideal_yaw = vectoyaw(self.lastplace_spoted - rorigin(self));
				//self.angles_y += random(-45, 45) ;
				vector source = self.origin;
				float angle_rotate;
					angle_rotate  = random(160, 200);
				tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *2 +  v_right * 128, FALSE, self);
				if (trace_fraction == 1.0)
					angle_rotate  = random(90, 120);
				tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *2 +  v_right * -128, FALSE, self);
				if (trace_fraction == 1.0)
					angle_rotate  = random(-120, 90);
				


				self.angles_y += angle_rotate;
				self.ideal_yaw = self.angles_y;
				ChangeYaw();
				self.timeangles2 = 0;
			}
		}
	return;
	}

	if(!self.trigger_angle_use)
	self.trigger_angle_use = 1; 
	if ((self.watertype == CONTENT_LAVA) || (self.lavatime > time))	// do lava damage
	{
		T_Damage(self, world, world, 10 *self.waterlevel);
		return;
	}

	if((!self.takedamage) && (self.classentity == "monsters"))
	self.takedamage = DAMAGE_AIM;

	if (self.movetype == MOVETYPE_FLYMISSILE)
	{
		ai_face();
		return;
	}
	if (self.movetype == MOVETYPE_BOUNCE)
	{
		self.movetype = self.oldmovetype;
		self.gravity = 1;
	}		
	if ((!self.enemy) || (self.enemy.health <= 0))
		next_enemy();
		
	if ((self.friendly_monster == 1) && (self.enemy.classname == "player") && (self.player_temp_enemy < time)) 
		next_enemy();
	
	if( (self.enemy) &&((!self.enemy.health) || (self.enemy.health < 0)))
		next_enemy();	
	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw(self.enemy.origin - self.origin);

	if((self.always_active_time < time) && (self.always_active))
		self.always_active = 0;
	if(self.timeangles > time)
	{
		if(visible_complex(self.enemy))
			self.timeangles = 0;
	}

	if (self.following_a_node_timer < time)
	float enemy_is_visible = run_visible(self.enemy);
	else
	enemy_is_visible  = FALSE;



	if(enemy_is_visible)
	{	
		if (nodegraph_query_is_valid(self.nodegraph_query_id))
		{
			nodegraph_query_release(self.nodegraph_query_id);
			self.following_a_node = FALSE;
		}
		if((self.turret == 2) && (self.timeangles > time))
		self.timeangles = 0;
		if((self.follow_trigger_angle) && (!self.always_active))
			self.follow_trigger_angle =0;
		if(self.following_a_node_timer < time)	
		self.lastplace_spoted = self.enemy.origin;
	}
	if((enemy_is_visible ) && (!self.always_active)&& (self.timeangles < time)  && (self.evade != 1))
	{

		self.finding_node_time = 0;
		if (self.zigzaging == 1)
		{
			
			if (self.zigzag_time != 1)
			{	
				float zz_v, zz_v_mutiplier;
				zz_v_mutiplier = vlen(self.lastplace_spoted - rorigin(self));
				//if (zz_v_mutiplier < 256)			
				//	zz_v = self.zigzagdeviance * 5.6; 
				//else
					zz_v = self.zigzagdeviance * (zz_v_mutiplier / 256) * 5.6;
			
				makevectors (self.angles);
				self.ideal_yaw = vectoyaw((self.lastplace_spoted +v_right * zz_v) - rorigin(self));
				self.zigzag_time  = 1;
				ChangeYaw();
			}
		}
		else
		{
			self.zigzag_time  = 0;
			self.ideal_yaw = vectoyaw(self.lastplace_spoted - rorigin(self));
			ChangeYaw();
		}
	}

	else
	{
		if((!(enemy_is_visible)) && (!(self.follow_trigger_angle)) && (self.timeangles < time) )	
		{
			if(self.finding_node_time < time)
			{
				if (nodegraph_query_is_valid(self.nodegraph_query_id))
					nodegraph_query_release(self.nodegraph_query_id);	
				find_node_path();
				self.finding_node_time = time + 1.0 + random() * 3.0;
				if(self.classname == "widow")
				self.finding_node_time = self.finding_node_time * 0.5;
			}    
			local float i, threshold, currentnodeid, query_entries_count;
			local vector currentnode, nodefrom, nodeto;
			threshold = max(self.maxs[0] - self.mins[0], self.maxs[1] - self.mins[1]) * 1.4142135623730950488016887242097 * 2.0;
			if (nodegraph_query_is_valid(self.nodegraph_query_id))
			{
				query_entries_count = nodegraph_query_entries_count(self.nodegraph_query_id);
				nodefrom = nodegraph_graph_get_node(0, nodegraph_query_get_nodeid(self.nodegraph_query_id, 0));
				i = 1;
				if(test_ia == 1)
				{
					while (i < query_entries_count)
					{
						nodeto = nodegraph_graph_get_node(0, nodegraph_query_get_nodeid(self.nodegraph_query_id, i));
						te_lightning1 (world,nodefrom, nodeto);
						nodefrom = nodeto;
						i = i + 1;
					}
				}
				currentnodeid = nodegraph_query_get_nodeid(self.nodegraph_query_id, self.nodegraph_query_entry_index);
				currentnode = nodegraph_graph_get_node(0, currentnodeid);
				if (vlen(self.origin + self.mins - currentnode) < threshold)
				{
					self.nodegraph_query_entry_index = self.nodegraph_query_entry_index + 1;
					if (self.nodegraph_query_entry_index == nodegraph_query_entries_count(self.nodegraph_query_id))
					{
						nodegraph_query_release(self.nodegraph_query_id);
						find_node_path();
					}
				}
				self.lastplace_spoted = currentnode;
				self.following_a_node = TRUE;
				// te_lightning1(world, self.origin, currentnode);
			}
			else
			{
				if ((vlen(self.origin - self.lastplace_spoted ) <= 64)  && (self.following_a_node != TRUE))
					{self.lastplace_spoted = rorigin(self.enemy);self.finding_node_time = 0;}

			}
			if(self.following_a_node_timer < time)
				self.following_a_node_timer = time + 1  + random();	
		}
		self.ideal_yaw = vectoyaw((self.lastplace_spoted) - rorigin(self));	
			ChangeYaw();
	}	
	walk_dist = dist;
	if(self.strafing >time)
		walk_dist = dist * 0.5;
		
	walkeddist = walkmovedist(self.angles_y, walk_dist);
	
	if(walkeddist < dist * 0.5)
	{
		self.zigzaging = 0;
		check_strafe();	
		if((!self.follow_trigger_angle) && (self.following_a_node != TRUE))
			check_angles();

		if(self.classname == "monster_stricken")
			movetogoal (dist * 0.25);
		else
			movetogoal (dist);
	}

};

void(float dist) ai_runattack = 
{ 
	movedist = dist;
	if (!self.enemy.health)
	{
		self.enemy = world;
		if (self.oldenemy.health > 0)
		{
			self.enemy = self.oldenemy;
			HuntTarget();
		}
		else
		{
			if (self.movetarget)
				self.th_walk();
			else
				self.th_stand();
			return;
		}
	}

	self.show_hostile = time + 1;	// wake up other monsters
	enemy_vis = visible(self.enemy);
	if (enemy_vis)
		self.search_time = time + 5;
	if (coop && self.search_time < time)
	{
		if (FindTarget())
			return;
	}

	enemy_infront = infront(self.enemy);
	enemy_range = range(self.enemy);
	enemy_yaw = vectoyaw((rorigin(self.enemy)) - rorigin(self));
	if (self.attack_state == AS_MISSILE)
	{
		ai_run_missile();
		return;
	}

	if (self.attack_state == AS_MELEE)
	{
		ai_run_melee();
		return;
	}

	if (CheckAnyAttack())
		return;	// beginning an attack
	if (self.attack_state == AS_SLIDING)
	{
		ai_run_slide();
		return;
	}

	self.ideal_yaw = vectoyaw(rorigin(self.enemy) - rorigin(self));
	ChangeYaw();
	if (!walkmove(self.angles_y, dist))
		movetogoal(dist);
};


////// proto ai code

.string oldmodel;
void(entity e, entity excep) changegoalentity3 = 
{ 
	local entity head, near;
	local float dist, low;
	low = 99999999;	

	head = find(world, classname, "path_waypoint");
	while (head)
	{
		dist = vlen(head.origin - e.origin);
		if (dist < low)
		{
			low = dist;

			if (head != excep)
			{
				self = e;
				if (visible(head) && oldvisible(head))
					near = head;
				e = self;
			}
		}

		head = find(head, classname, "path_waypoint");
	}

	if (near)
		e.enemy = near;
};

.entity friend;
.entity path1;
.entity path2;
.entity path3;
.entity path4;
.entity path5;
.entity path6;
.entity path7;
.entity path8;
.entity path9;
.entity path10;
.entity path11;
.entity path12;
.float numslotpath;

void(entity plyr) waypointnextslot = 
{ 
	if (self.numslotpath == 1)
		self.enemy = plyr.path2;
	if (self.numslotpath == 2)
		self.enemy = plyr.path3;
	if (self.numslotpath == 3)
		self.enemy = plyr.path4;
	if (self.numslotpath == 4)
		self.enemy = plyr.path5;
	if (self.numslotpath == 5)
		self.enemy = plyr.path6;
	if (self.numslotpath == 6)
		self.enemy = plyr.path7;
	if (self.numslotpath == 7)
		self.enemy = plyr.path8;
	if (self.numslotpath == 8)
		self.enemy = plyr.path9;
	if (self.numslotpath == 9)
		self.enemy = plyr.path10;
	if (self.numslotpath == 10)
		self.enemy = plyr.path11;
	if (self.numslotpath == 11)
		self.enemy = plyr.path12;
	if (self.numslotpath == 12)
		self.enemy = plyr.path12;
};

void(entity path, entity plyr) check_player_slots_paths = 
{ 
	if (!plyr.path1)
	{
		path.numslotpath = 1;
		plyr.path1 = path;
		return;
	}

	if (!plyr.path2)
	{
		path.numslotpath = 2;
		plyr.path2 = path;
		return;
	}

	if (!plyr.path3)
	{
		path.numslotpath = 3;
		plyr.path3 = path;
		return;
	}

	if (!plyr.path4)
	{
		path.numslotpath = 4;
		plyr.path4 = path;
		return;
	}

	if (!plyr.path5)
	{
		path.numslotpath = 5;
		plyr.path5 = path;
		return;
	}

	if (!plyr.path6)
	{
		path.numslotpath = 6;
		plyr.path6 = path;
		return;
	}

	if (!plyr.path7)
	{
		path.numslotpath = 7;
		plyr.path7 = path;
		return;
	}

	if (!plyr.path8)
	{
		path.numslotpath = 8;
		plyr.path8 = path;
		return;
	}

	if (!plyr.path9)
	{
		path.numslotpath = 9;
		plyr.path9 = path;
		return;
	}

	if (!plyr.path10)
	{
		path.numslotpath = 10;
		plyr.path10 = path;
		return;
	}

	if (!plyr.path11)
	{
		path.numslotpath = 11;
		plyr.path11 = path;
		return;
	}

	if (!plyr.path12)
	{
		path.numslotpath = 12;
		plyr.path12 = path;
		return;
	}
};

void() path_waypoint_enemies = 
{ 
	local entity head;
	head = findradius(self.origin, 90);	// finds all entitys within 250 (2.5 meters?)
	while (head)
	{
		if ((head.flags &FL_MONSTER) && (visible(head)))
		{
			head.enemy = self.enemy;
			self.friend = head;
			te_lightning1(self, self.origin, head.origin);
		}

		head = head.chain;	// cycle to next head (entity)
	}
};

void() path_waypoint_think = 
{ 
	if (self.lifetime < time)
	{
		remove(self);
		return;
	}

	if (visible(self.oldenemy))
		self.enemy = self.oldenemy;
	else
		waypointnextslot(self.oldenemy);

	path_waypoint_enemies();

	te_lightning1(self, self.origin, self.enemy.origin);
	te_lightning3(self, self.origin, self.friend.origin);

	self.think = path_waypoint_think;
	self.nextthink = time + 0.1;
};

void() trigger_waypoint_touch = 
{ 
	if ((other.classname != "player"))
		return;
	if (self.lifetime > time)
		return;
	self.lifetime = time + 30;
	local entity pathw;
	pathw = spawn();
	setmodel(pathw, "");
	pathw.origin = self.origin + '0 0 0';
	setsize(pathw, '-24 -24 -12', '24 24 12');
	pathw.classname = "path_waypoint";
	pathw.solid = SOLID_TRIGGER;
	check_player_slots_paths(pathw, other);
	pathw.owner = other;
	pathw.classname2 = pathw.classname;
	pathw.think = path_waypoint_think;
	pathw.oldenemy = other;
	pathw.nextthink = time + 2;
	pathw.lifetime = time + 60;
	//remove(self);
};

void() trigger_waypoint = 
{ 
	self.touch = trigger_waypoint_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.origin = (self.absmin + self.absmax) *0.5;
	self.oldorigin = (self.absmin + self.absmax) *0.5;
	self.oldmodel = self.model;
	self.alpha = -1;
};

void() trigger_waypointed_touch = 
{ 
	if (!(other.flags &FL_MONSTER))
		return;
	other.waypointed = 1;
};

void() trigger_nowaypointed_touch = 
{ 
	if (!(other.flags &FL_MONSTER))
		return;
	other.waypointed = 0;
};

void() trigger_waypointed = 
{ 
	self.touch = trigger_waypointed_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
};

void() trigger_nowaypointed = 
{ 
	self.touch = trigger_nowaypointed_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
};

float(entity targ, entity eself) backtouch; 

void() info_angle=
{
};

void()determine_subangle =
{
	local entity t;
	t = find(world, targetname, self.target);
	self.enemy = t;
};

void() trigger_angle_touchs =
{
	local entity oself;
	if (!(other.flags & FL_MONSTER))
		return;	

	if (((other.lasttrigger == self) && (other.timeangles > time)))
		return;	

	self.subangle = self.enemy.angles_y;
	makevectors2(other.angles);

	if (((v_forward * self.movedir) < self.minorangle))
		return;	

	other.lasttrigger = self;
	other.timeangles = (time + TRUE);
	oself = self;
	self = other;
	self.angles_y = oself.subangle;
	self.ideal_yaw = oself.subangle;
	ChangeYaw();
	self = oself;
};

void() trigger_angle_touch =
{
	local entity oself;
		if(other.warped_time > time)	
		return;	
	if (!(other.flags & FL_MONSTER))
		return;
		
	if(other.following_a_node == TRUE)
		return;	
	if(!other.trigger_angle_use)
		return;
	
	if (((other.lasttrigger == self) && (other.timeangles > time)))
	{
		other.timeangles2 = time +0.5;
		return;
	}	
	self.subangle = self.enemy.angles_y;
	//self.colormod = '1 1 1';
	local float angle_return;
	if(self.movedir == '0 0 0')
	{
		makevectors2(self.subangles);
		vector vec = normalize (other.origin - other.enemy.origin);
		float dot = vec * v_forward;
		if (dot > self.minorangle)
			angle_return = 1;
	}
	else
	{
	makevectors2(other.angles);
	if (((v_forward * self.movedir) < self.minorangle))
		{
			other.timeangles2 = time +0.5;
			angle_return = 1;
		}
	}
	
	if(angle_return)
		return;	
	other.lasttrigger = self;
	oself = self;
	self = other;
	if((oself.always_active != 1) && (rvisible2(self.enemy, 1)))
	{
		self.timeangles3 = time + 0;
		self.timeangles2 = time + 2;
		self.timeangles = time + 0;
		return;
	}
	self.follow_trigger_angle = 1;

	if(oself.always_active == 1)
	{	
	self.always_active_time = time + 5;
	self.always_active = 1;
	}
	self.timeangles = time + 1;
	self.angles_y = oself.subangle;
	self.ideal_yaw = oself.subangle;
	ChangeYaw();
	makevectors(self.angles);
	local vector source = self.origin;
	traceline(source,source + v_forward *1024, TRUE, self);
	self.lastplace_spoted = trace_endpos;
	self = oself;
};

void() trigger_angle =
{
	InitTrigger();
	self.touch = trigger_angle_touch;
	self.think = determine_subangle;
	self.nextthink = self.ltime + 0.1;
};

.float no_fixed_angles_time;
void() trigger_no_check_angles_touch =
{
	if (!(other.flags & FL_MONSTER))
	{
		return;
	}
other.timeangles3 = (time + self.no_fixed_angles_time);
};

void() trigger_no_check_angles =
{
	InitTrigger();
	self.touch = trigger_no_check_angles_touch;
};


/////////////
