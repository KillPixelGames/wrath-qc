/*
==============================================================================
executioner CODE
==============================================================================
*/

$frame ex_pose0
$frame ex_idle1 ex_idle2 ex_idle3 ex_idle4 ex_idle5 ex_idle6 ex_idle7 ex_idle8 ex_idle9 ex_idle10
$frame ex_walk1 ex_walk2 ex_walk3 ex_walk4 ex_walk5 ex_walk6 ex_walk7 ex_walk8 ex_walk9 ex_walk10
$frame ex_attack1 ex_attack2 ex_attack3 ex_attack4 ex_attack5 ex_attack6 ex_attack7 ex_attack8 ex_attack9 ex_attack10
$frame ex_attacka1 ex_attacka2 ex_attacka3 ex_attacka4 ex_attacka5 ex_attacka6 ex_attacka7 ex_attacka8 ex_attacka9 ex_attacka10
$frame ex_attackb1 ex_attackb2 ex_attackb3 ex_attackb4 ex_attackb5 ex_attackb6 ex_attackb7 ex_attackb8 ex_attackb9 ex_attackb10
$frame ex_attackc1 ex_attackc2 ex_attackc3 ex_attackc4 ex_attackc5 ex_attackc6 ex_attackc7 ex_attackc8 ex_attackc9 ex_attackc10
$frame ex_charge1 ex_charge2 ex_charge3 ex_charge4 ex_charge5 ex_charge6
$frame ex_chargesh1 ex_chargesh2 ex_chargesh3 ex_chargesh4 ex_chargesh5 ex_chargesh6
$frame ex_rtcha
$frame ex_rtchb
$frame ex_chargeb1 ex_chargeb2 ex_chargeb3 ex_chargeb4 ex_chargeb5 ex_chargeb6
$frame ex_chargebsh1 ex_chargebsh2 ex_chargebsh3 ex_chargebsh4 ex_chargebsh5 ex_chargebsh6
$frame exec_paina1 exec_paina2 exec_paina3 exec_paina4 exec_paina5 exec_paina6 exec_paina7 exec_paina8 exec_paina9 exec_paina10
$frame exec_painb1 exec_painb2 exec_painb3 exec_painb4 exec_painb5 exec_painb6 exec_painb7 exec_painb8 exec_painb9 exec_painb10
$frame exec_paind1 exec_paind2 exec_paind3 exec_paind4 exec_paind5 exec_paind6 exec_paind7 exec_paind8 exec_paind9 exec_paind10
$frame exec_deatha1 exec_deatha2 exec_deatha3 exec_deatha4 exec_deatha5 exec_deatha6 exec_deatha7 exec_deatha8 exec_deatha9 exec_deatha10 exec_deatha11 exec_deatha12 exec_deatha13 exec_deatha14
$frame exec_deathb1 exec_deathb2 exec_deathb3 exec_deathb4 exec_deathb5 exec_deathb6 exec_deathb7 exec_deathb8 exec_deathb9 exec_deathb10 exec_deathb11 exec_deathb12 exec_deathb13 exec_deathb14 exec_deathb15
$frame exec_painf1 exec_painf2 exec_painf3 exec_painf4 exec_painf5 exec_painf6 exec_painf7 exec_painf8 exec_painf9 exec_painf10
$frame exec_paine1 exec_paine2 exec_paine3 exec_paine4 exec_paine5 exec_paine6 exec_paine7 exec_paine8 exec_paine9 exec_paine10

	.float charging;
.float mutilated;
.float timezigzaging;
.float zigzag_angle1;
.float zigzag_angle2;
.float zigzag_angle3;
.float charge_time;


void() executioner_chrgrandom;
void() executioner_chrbg1;
////////////////////////////////////////////////////////////////////////////////////
void() executioner_run1;
void() executioner_chrg1;
//void() executioner_runb1;
//void() executioner_atk1;

.float exec_idle_time;
.float exec_sight_time;

void() executioner_check = 
{
	if (self.exec_sight_time < time)
	{
		chattersound("enemies/executioner/sight", 3, 1);
		self.exec_sight_time = time + 5;
	}

	if ((self.goalentity) && (self.enemy))
	{
		if ((self.likecharge == 1) && (self.enemy.classname != "player") && (self.charge_time < time))
			self.think = executioner_chrgrandom;
		else
			self.think = executioner_run1;
		self.nextthink = time;
	}
};

void() executioner_stand1 =[$ex_idle1, executioner_stand2]
{
	ai_stand();
	local float r;
	r = random() *10;
	if ((r < 1) && (!(self.spawnflags &1)) && (self.exec_idle_time < time))
	{
		chattersound("enemies/executioner/idle", 3, 1);
		self.exec_idle_time = time + 5;
	}

	executioner_check();
};
void() executioner_stand2 =[$ex_idle2, executioner_stand3]
{
	executioner_check();
	ai_stand();
};
void() executioner_stand3 =[$ex_idle3, executioner_stand4]
{
	executioner_check();
	ai_stand();
};
void() executioner_stand4 =[$ex_idle4, executioner_stand5]
{
	executioner_check();
	ai_stand();
};
void() executioner_stand5 =[$ex_idle5, executioner_stand6]
{
	executioner_check();
	ai_stand();
};
void() executioner_stand6 =[$ex_idle6, executioner_stand7]
{
	executioner_check();
	ai_stand();
};
void() executioner_stand7 =[$ex_idle7, executioner_stand8]
{
	executioner_check();
	ai_stand();
};
void() executioner_stand8 =[$ex_idle8, executioner_stand9]
{
	executioner_check();
	ai_stand();
};
void() executioner_stand9 =[$ex_idle9, executioner_stand10]
{
	executioner_check();
	ai_stand();
};
void() executioner_stand10 = 
{
	ai_stand();
	executioner_check();

	self.frame = $ex_idle10;
	self.think = executioner_stand1;
	self.nextthink = time + 0.1;
};

//===========================================================================
void() executioner_walk1 =[$ex_walk1, executioner_walk2]
{
	ai_walk(10);
};
void() executioner_walk2 =[$ex_walk2, executioner_walk3]
{
	ai_walk(10);
};
void() executioner_walk3 =[$ex_walk3, executioner_walk4]
{
	ai_walk(10);
};
void() executioner_walk4 =[$ex_walk4, executioner_walk5]
{
	ai_walk(10);
	walksound("enemies/executioner/step", 3);
};
void() executioner_walk5 =[$ex_walk5, executioner_walk6]
{
	ai_walk(10);
};
void() executioner_walk6 =[$ex_walk6, executioner_walk7]
{
	ai_walk(10);
};
void() executioner_walk7 =[$ex_walk7, executioner_walk8]
{
	ai_walk(10);
};
void() executioner_walk8 =[$ex_walk8, executioner_walk9]
{
	ai_walk(10);
};
void() executioner_walk9 =[$ex_walk9, executioner_walk10]
{
	ai_walk(10);
	walksound("enemies/executioner/step", 3);
};
void() executioner_walk10 =[$ex_walk10, executioner_walk1]
{
	ai_walk(10);
};
//===========================================================================
void() executioner_atkr;
.float exec_type;
.float exec_jtime;

//===========================================================================

void() executioner_subattack;

void() executioner_run1 =[$ex_walk1, executioner_run2]
{
	ai_test_monster_run(exec_vwalk1);	
	self.charging = 0;
	executioner_subattack();
};
void() executioner_run2 =[$ex_walk2, executioner_run3]
{
	ai_test_monster_run(exec_vwalk1);	
	executioner_subattack();
};
void() executioner_run3 =[$ex_walk3, executioner_run4]
{
	ai_test_monster_run(exec_vwalk1);	
};
void() executioner_run4 =[$ex_walk4, executioner_run5]
{
	walksound("enemies/executioner/step", 3);
	
	executioner_subattack();
	ai_test_monster_run(exec_vwalk1);	
};
void() executioner_run5 =[$ex_walk5, executioner_run6]
{
	self.exec_type = 1;
	executioner_subattack();
	ai_test_monster_run(exec_vwalk1);	
	if (self.skin != 2)
	{
		self.oldframe = $ex_rtchb;
		if ((visible2(self.enemy, 384, 0.3)))
		{
			local float r;
			r = random();
			if ((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16)
				return;
			if (r < 0.25)
				return;
			else
				self.think = executioner_chrbg1;
		}

		if ((visible2(self.enemy, 128, 0.3)))
			self.think = executioner_atkr;
	}
};
void() executioner_run6 =[$ex_walk6, executioner_run7]
{
	ai_test_monster_run(exec_vwalk1);	
	executioner_subattack();
};
void() executioner_run7 =[$ex_walk7, executioner_run8]
{
	
	ai_test_monster_run(exec_vwalk1);	
};
void() executioner_run8 =[$ex_walk8, executioner_run9]
{
	ai_test_monster_run(exec_vwalk1);	
	executioner_subattack();	
	self.oldvelocity = self.velocity;
};
void() executioner_run9 =[$ex_walk9, executioner_run10]
{
	ai_test_monster_run(exec_vwalk1);	
	walksound("enemies/executioner/step", 3);
	
};
void() executioner_run10 =[$ex_walk10, executioner_run1]
{
	
	self.exec_type = 2;
	ai_test_monster_run(exec_vwalk1);	
	executioner_subattack();
	if (self.skin != 1)
	{
		self.oldframe = $ex_rtcha;
		if ((visible2(self.enemy, 384, 0.3)))
		{
			local float r;
			r = random();
			if ((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16)
				return;
			if(self.charge_time > time)
				return;

			if ((self.likecharge != 1) && (r < 0.25))
				return;
			else
				self.think = executioner_chrg1;
		}

		if ((visible2(self.enemy, 128, 0.3)))
			self.think = executioner_atkr;
	}
};


//===========================================================================

void() executioner_atkb1;
void() executioner_atkc1;
void() executioner_atkd1;
.float loopflag;
.float exec_damagecharge;
void(float r) executioner_attack;

void() executioner_subattack = 
{
	local entity head;

	head = findradius(rorigin(self), exec_radius);	//send lightning line to anything in 250 radius
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
//void()executioner_chargesh1 =[$ex_chargesh1,executioner_chargesh2]{ai_face();ai_test_monster_run(exec_chsh1);executioner_subattack();};
void() executioner_chargesh2 =[$ex_chargesh2, executioner_chargesh3]
{
	ai_face();
	ai_test_monster_run(exec_chsh2);
	self.exec_push = 16;
	executioner_subattack();
	executioner_attack(exec_chargedamage);
	self.charging = 1;
	chattersound("enemies/executioner/chatter_combat", 3, 1);
	chattersound("enemies/executioner/blade_swing", 3, 1);
};
void() executioner_chargesh3 =[$ex_chargesh3, executioner_chargesh4]
{
	ai_face();
	ai_test_monster_run(exec_chsh3);
	executioner_subattack();
};
void() executioner_chargesh4 =[$ex_chargesh4, executioner_chargesh5]
{
	ai_face();
	ai_test_monster_run(exec_chsh4);
	walksound("enemies/executioner/step", 3);
};
void() executioner_chargesh5 =[$ex_chargesh5, executioner_chargesh6]
{
	ai_face();
	ai_test_monster_run(exec_chsh5);
	executioner_subattack();
};
void() executioner_chargesh6 =[$ex_chargesh6, executioner_run1]
{
	ai_face();
	ai_test_monster_run(exec_chsh6);
	executioner_subattack();
};

//void()executioner_chargebsh1 =[$ex_chargebsh1,executioner_chargebsh2]{ai_face();ai_test_monster_run(exec_chsh1);executioner_subattack();};
void() executioner_chargebsh2 =[$ex_chargebsh2, executioner_chargebsh3]
{
	ai_face();
	ai_test_monster_run(exec_chsh2);
	self.exec_push = 16;
	executioner_subattack();
	executioner_attack(exec_chargedamage);
	self.charging = 1;
	chattersound("enemies/executioner/chatter_combat", 3, 1);
	chattersound("enemies/executioner/blade_swing", 3, 1);
};
void() executioner_chargebsh3 =[$ex_chargebsh3, executioner_chargebsh4]
{
	ai_face();
	ai_test_monster_run(exec_chsh3);
	executioner_subattack();
};
void() executioner_chargebsh4 =[$ex_chargebsh4, executioner_chargebsh5]
{
	ai_face();
	ai_test_monster_run(exec_chsh4);
	walksound("enemies/executioner/step", 3);
};
void() executioner_chargebsh5 =[$ex_chargebsh5, executioner_chargebsh6]
{
	ai_face();
	ai_test_monster_run(exec_chsh5);
	executioner_subattack();
};
void() executioner_chargebsh6 =[$ex_chargebsh6, executioner_run1]
{
	ai_face();
	ai_test_monster_run(exec_chsh6);
	executioner_subattack();
};

.float ty_charge;

void(float attackfloat) executioner_attack = 
{
	local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	executioner_subattack();
	delta = (self.enemy.origin) - rorigin(self);	// + '0 0 32');
	dist = vlen(delta);

	if ((attackfloat != 0) || (self.charge_time > time))
	{
		if (dist < exec_rangeattack)
		{
			local vector source, dir;
			source = rorigin(self) + '0 0 16';
			traceline(source, self.enemy.origin, FALSE, self);
			if (trace_fraction != 1.0)
			{
				if ((trace_ent.takedamage))
				{
					T_Damage(trace_ent, self, self, exec_damage);
					trace_ent.punchangle_x = 16;
					trace_ent.flags = trace_ent.flags - FL_ONGROUND;
					dir = trace_ent.origin - self.origin;
					dir = normalize(dir);
					trace_ent.velocity_z += 120;
					if (attackfloat > 0)
						trace_ent.velocity += dir * 128;
					else
						trace_ent.velocity += dir * 256;
				}
			}
		}
	}
	else
	{
		if (dist < exec_rangeattack)
		{
			if (self.ty_charge == 1)
				self.think = executioner_chargesh2;
			else
				self.think = executioner_chargebsh2;
			self.charge_time  = time + random(4,7);
			self.nextthink = time + 0.05;
		}
	}
};

void() executioner_atk1 =[$ex_attack1, executioner_atk2]
{
	ai_face();
	ai_test_monster_run(exec_atta1);
	self.charging = 1;
	chattersound("enemies/executioner/chatter_combat", 3, 1);
};
void() executioner_atk2 =[$ex_attack2, executioner_atk3]
{
	ai_face();
	ai_test_monster_run(exec_atta2);
	executioner_subattack();
};
void() executioner_atk3 =[$ex_attack3, executioner_atk4]
{
	ai_face();
	ai_test_monster_run(exec_atta3);
	walksound("enemies/executioner/step", 3);
};
void() executioner_atk4 =[$ex_attack4, executioner_atk5]
{
	ai_face();
	ai_test_monster_run(exec_atta4);
};
void() executioner_atk5 =[$ex_attack5, executioner_atk6]
{
	ai_face();
	ai_test_monster_run(exec_atta5);
	self.exec_push = 24;
	chattersound("enemies/executioner/blade_swing", 3, 1);
};
void() executioner_atk6 =[$ex_attack6, executioner_atk7]
{
	ai_face();
	executioner_attack(exec_damage);
	executioner_subattack();
	ai_test_monster_run(exec_atta6);
};
void() executioner_atk7 =[$ex_attack7, executioner_atk8]
{
	ai_face();
	ai_test_monster_run(exec_atta7);
};
void() executioner_atk8 =[$ex_attack8, executioner_atk9]
{
	ai_face();
	ai_test_monster_run(exec_atta8);
	walksound("enemies/executioner/step", 3);
};
void() executioner_atk9 =[$ex_attack9, executioner_atk10]
{
	ai_face();
	ai_test_monster_run(exec_atta9);
	executioner_subattack();
};
void() executioner_atk10 =[$ex_attack10, executioner_run1]
{
	ai_face();

	if ((visible2(self.enemy, 384, 0.3)) && (self.enemy.classname != "player") && (self.charge_time < time))
		self.think = executioner_chrgrandom;

	if ((visible2(self.enemy, 128, 0.3)))
	{
		if (self.skin == 0)
			self.think = executioner_atkb1;
		else
			self.think = executioner_atkd1;
	}

	self.nextthink = time + 0.1;
	//if(self.loopflag == 1)
	//self.think = executioner_atk1;

};

void() executioner_atkb1 =[$ex_attacka1, executioner_atkb2]
{
	ai_face();
	ai_test_monster_run(exec_attb1);
	executioner_subattack();
	self.charging = 1;
	chattersound("enemies/executioner/chatter_combat", 3, 1);
};
void() executioner_atkb2 =[$ex_attacka2, executioner_atkb3]
{
	ai_face();
	ai_test_monster_run(exec_attb2);
};
void() executioner_atkb3 =[$ex_attacka3, executioner_atkb4]
{
	ai_face();
	ai_test_monster_run(exec_attb3);
	executioner_subattack();
};
void() executioner_atkb4 =[$ex_attacka4, executioner_atkb5]
{
	ai_face();
	ai_test_monster_run(exec_attb4);
};
void() executioner_atkb5 =[$ex_attacka5, executioner_atkb6]
{
	ai_face();
	ai_test_monster_run(exec_attb5);
	walksound("enemies/executioner/step", 3);
	chattersound("enemies/executioner/blade_swing", 3, 1);
};
void() executioner_atkb6 =[$ex_attacka6, executioner_atkb7]
{
	ai_face();
	executioner_attack(exec_damage);
	executioner_subattack();
	ai_test_monster_run(exec_attb6);
};
void() executioner_atkb7 =[$ex_attacka7, executioner_atkb8]
{
	ai_face();
	ai_test_monster_run(exec_attb7);
};
void() executioner_atkb8 =[$ex_attacka8, executioner_atkb9]
{
	ai_face();
	ai_test_monster_run(exec_attb8);
	executioner_subattack();
};
void() executioner_atkb9 =[$ex_attacka9, executioner_atkb10]
{
	ai_face();
	ai_test_monster_run(exec_attb9);
};
void() executioner_atkb10 =[$ex_attacka10, executioner_run1]
{
	ai_face();
	ai_test_monster_run(exec_attb10);
	executioner_subattack();
	if ((visible2(self.enemy, 384, 0.3)) && (self.enemy.classname != "player") && (self.charge_time < time))
		self.think = executioner_chrgrandom;

	if ((visible2(self.enemy, 128, 0.3)))
		self.think = executioner_atkc1;
	self.nextthink = time + 0.1;

	//if(self.loopflag == 2)
	//self.think = executioner_atkb1;

};

void() executioner_atkc1 =[$ex_attackb1, executioner_atkc2]
{
	ai_face();
	ai_test_monster_run(exec_attc1);
	executioner_subattack();
	self.charging = 1;
	chattersound("enemies/executioner/chatter_combat", 3, 1);
};
void() executioner_atkc2 =[$ex_attackb2, executioner_atkc3]
{
	ai_face();
	ai_test_monster_run(exec_attc2);
};
void() executioner_atkc3 =[$ex_attackb3, executioner_atkc4]
{
	ai_face();
	ai_test_monster_run(exec_attc3);
	walksound("enemies/executioner/step", 3);
};
void() executioner_atkc4 =[$ex_attackb4, executioner_atkc5]
{
	ai_face();
	ai_test_monster_run(exec_attc4);
	executioner_subattack();
};
void() executioner_atkc5 =[$ex_attackb5, executioner_atkc6]
{
	ai_face();
	ai_test_monster_run(exec_attc5);
	chattersound("enemies/executioner/blade_swing", 3, 1);
};
void() executioner_atkc6 =[$ex_attackb6, executioner_atkc7]
{
	ai_face();
	executioner_attack(exec_damage);
	executioner_subattack();
	ai_test_monster_run(exec_attc6);
};
void() executioner_atkc7 =[$ex_attackb7, executioner_atkc8]
{
	ai_face();
	ai_test_monster_run(exec_attc7);
	executioner_subattack();
};
void() executioner_atkc8 =[$ex_attackb8, executioner_atkc9]
{
	ai_face();
	ai_test_monster_run(exec_attc8);
	walksound("enemies/executioner/step", 3);
};
void() executioner_atkc9 =[$ex_attackb9, executioner_atkc10]
{
	ai_face();
	ai_test_monster_run(exec_attc9);
	executioner_subattack();
};
void() executioner_atkc10 =[$ex_attackb10, executioner_run1]
{
	ai_face();
	ai_test_monster_run(exec_attc10);

	if ((visible2(self.enemy, 384, 0.3)) && (self.enemy.classname != "player") && (self.charge_time < time))
		self.think = executioner_chrgrandom;

	if ((visible2(self.enemy, 128, 0.3)))
	{
		if (self.skin == 0)
			self.think = executioner_atkd1;
		else
			self.think = executioner_atkb1;
	}

	self.nextthink = time + 0.1;

	//if(self.loopflag == 3)
	//self.think = executioner_atkc1;

};

void() executioner_atkd1 =[$ex_attackc1, executioner_atkd2]
{
	ai_face();
	ai_test_monster_run(exec_attd1);
	executioner_subattack();
	self.charging = 1;
	chattersound("enemies/executioner/chatter_combat", 3, 1);
};
void() executioner_atkd2 =[$ex_attackc2, executioner_atkd3]
{
	ai_face();
	ai_test_monster_run(exec_attd2);
};
void() executioner_atkd3 =[$ex_attackc3, executioner_atkd4]
{
	ai_face();
	ai_test_monster_run(exec_attd3);
	executioner_subattack();
};
void() executioner_atkd4 =[$ex_attackc4, executioner_atkd5]
{
	ai_face();
	ai_test_monster_run(exec_attd4);
};
void() executioner_atkd5 =[$ex_attackc5, executioner_atkd6]
{
	ai_face();
	ai_test_monster_run(exec_attd5);
	chattersound("enemies/executioner/blade_swing", 3, 1);
	walksound("enemies/executioner/step", 3);
};
void() executioner_atkd6 =[$ex_attackc6, executioner_atkd7]
{
	ai_face();
	executioner_attack(exec_damage);
	executioner_subattack();
	ai_test_monster_run(exec_attd6);
};
void() executioner_atkd7 =[$ex_attackc7, executioner_atkd8]
{
	ai_face();
	ai_test_monster_run(exec_attd7);
	executioner_subattack();
};
void() executioner_atkd8 =[$ex_attackc8, executioner_atkd9]
{
	ai_face();
	ai_test_monster_run(exec_attd8);
};
void() executioner_atkd9 =[$ex_attackc9, executioner_atkd10]
{
	ai_face();
	ai_test_monster_run(exec_attd9);
	executioner_subattack();
};
void() executioner_atkd10 =[$ex_attackc10, executioner_run1]
{
	ai_test_monster_run(exec_attd10);
	ai_face();

	if ((visible2(self.enemy, 384, 0.3)) && (self.enemy.classname != "player") && (self.charge_time < time))
		self.think = executioner_chrgrandom;

	if ((visible2(self.enemy, 128, 0.3)))
	{
		if (self.skin == 0)
			self.think = executioner_atkc1;
		else
			self.think = executioner_atk1;
	}

	self.nextthink = time + 0.1;

	//if(self.loopflag == 4)
	//self.think = executioner_atkd1;
};

void() executioner_chrgrandom = 
{
	if (self.skin == 1)
		self.think = executioner_chrbg1;

	if (self.skin == 2)
		self.think = executioner_chrg1;
	if (self.skin == 0)
	{
		local float r;
		r = random();
		if (r < 0.5)
			self.think = executioner_chrg1;
		else
			self.think = executioner_chrbg1;
	}

	self.charging = 1;
	if ((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16)
	{
		self.charging = 0;
		self.think = executioner_run1;
	}
	self.charge_time  = time + random(2,7);
	self.nextthink = time;
};

void() executioner_chrg1b;
void() executioner_chrg1 = 
{
	self.charging = 1;

	executioner_subattack();
	self.oldframe = $ex_rtcha;
	self.frame = self.oldframe;
	self.ty_charge = 1;
	ai_face();
	ai_test_monster_run(15);
	self.think = executioner_chrg1b;
	self.nextthink = time + 0.1;
};
void() executioner_chrg1b =[$ex_charge1, executioner_chrg2]
{
	ai_face();
	ai_test_monster_run(exec_charge1);
	executioner_attack(0);
	
	executioner_subattack();
};
void() executioner_chrg2 =[$ex_charge2, executioner_chrg3]
{
	ai_face();
	ai_test_monster_run(exec_charge2);
	executioner_attack(0);
	
	executioner_subattack();
};
void() executioner_chrg3 =[$ex_charge3, executioner_chrg4]
{
	ai_face();
	ai_test_monster_run(exec_charge3);
	executioner_attack(0);
	
	walksound("enemies/executioner/step", 3);
	executioner_subattack();
	executioner_subattack();
};
void() executioner_chrg4 =[$ex_charge4, executioner_chrg5]
{
	ai_face();
	ai_test_monster_run(exec_charge4);
	executioner_attack(0);
	
	executioner_subattack();
	self.oldvelocity_x = self.velocity_x;
	self.oldvelocity_y = self.velocity_y;
};
void() executioner_chrg5 =[$ex_charge5, executioner_chrg6]
{
	ai_face();
	ai_test_monster_run(exec_charge5);
	executioner_attack(0);
	
	executioner_subattack();
};
void() executioner_chrg6 =[$ex_charge6, executioner_chrg1b]
{
	ai_face();
	ai_test_monster_run(exec_charge6);
	executioner_attack(0);
	executioner_subattack();
	
	walksound("enemies/executioner/step", 3);
	self.charging = 0;
	if (!visible(self.enemy))
		self.think = executioner_run1;
	//if((self.velocity_x == 0)&& (self.velocity_y == 0) && (self.oldvelocity_x == 0)&& (self.oldvelocity_y == 0))
	//self.think = executioner_run1;
	if ((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16)
		self.think = executioner_run1;

	executioner_subattack();


		if (self.charge_time > time)
		self.think = executioner_run1;


	self.nextthink = time + 0.1;
};

void() executioner_chrbg1b;
void() executioner_chrbg1 = 
{
	self.charging = 1;
	self.oldframe = $ex_rtchb;
	self.frame = self.oldframe;
	self.ty_charge = 0;
	ai_face();
	ai_test_monster_run(20);
	executioner_subattack();
	self.think = executioner_chrbg1b;
	self.nextthink = time + 0.1;
};
void() executioner_chrbg1b =[$ex_chargeb1, executioner_chrbg2]
{
	ai_face();
	ai_test_monster_run(exec_charge1);
	executioner_attack(0);
	
	executioner_subattack();
};
void() executioner_chrbg2 =[$ex_chargeb2, executioner_chrbg3]
{
	ai_face();
	ai_test_monster_run(exec_charge2);
	executioner_attack(0);
	
	executioner_subattack();
};
void() executioner_chrbg3 =[$ex_chargeb3, executioner_chrbg4]
{
	ai_face();
	ai_test_monster_run(exec_charge3);
	executioner_attack(0);
	
	walksound("enemies/executioner/step", 3);
	executioner_subattack();
	executioner_subattack();
};
void() executioner_chrbg4 =[$ex_chargeb4, executioner_chrbg5]
{
	ai_face();
	ai_test_monster_run(exec_charge4);
	executioner_attack(0);
	
	executioner_subattack();

	self.oldvelocity_x = self.velocity_x;
	self.oldvelocity_y = self.velocity_y;

};
void() executioner_chrbg5 =[$ex_chargeb5, executioner_chrbg6]
{
	ai_face();
	ai_test_monster_run(exec_charge5);
	executioner_attack(0);
	
	executioner_subattack();
};
void() executioner_chrbg6 =[$ex_chargeb6, executioner_chrbg1b]
{
	ai_face();
	ai_test_monster_run(exec_charge6);
	executioner_attack(0);
	executioner_subattack();
	
	walksound("enemies/executioner/step", 3);
	self.charging = 0;
	if (!visible(self.enemy))
		self.think = executioner_run1;
	//if((self.velocity_x == 0)&& (self.velocity_y == 0) && (self.oldvelocity_x == 0)&& (self.oldvelocity_y == 0))
	//self.think = executioner_run1;
	if ((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16)
		self.think = executioner_run1;
	executioner_subattack();
		if(self.charge_time > time)
		self.think = executioner_run1;

	self.nextthink = time + 0.1;
};

//self.exec_damagecharge = 0;

//if((visible2(self.enemy, 384,0.3)))
//self.think = executioner_chrg1;

//if((visible2(self.enemy, 128,0.3)))
//self.think = executioner_atkr;

void() executioner_atkr = 
{
	local float r;
	r = random();

	if (self.exec_type == 1)
	{
		if (r > 0.5)
			self.think = executioner_atkd1;
		else
			self.think = executioner_atkc1;
		if (self.skin == 2)
			self.think = executioner_atkd1;
		if (self.skin == 1)
			self.think = executioner_atkc1;
	}
	else
	{
		if (r > 0.5)
			self.think = executioner_atk1;
		else
			self.think = executioner_atkb1;
		if (self.skin == 2)
			self.think = executioner_atk1;
		if (self.skin == 1)
			self.think = executioner_atkb1;
	}

	self.nextthink = time;
};

//void(float effectnum, vector org, vector vel, float howmany) pointparticles = #337;	// same as in CSQC
.float armcount;
void() bleedthink = 
{
	local entity e;
	e = self.owner;
	if (self.owner.cnt == 100)
	{
		remove(self);
		return;
	}

	if (!(self.owner.stepheight_delta)) // big hack, you need to add the attached flags to delete stuff
	{
		remove(self);
		return;
	}


	local float nparticles;
	nparticles = particleeffectnum("exectrailgib");

	local vector tagorg, dir;
	local float tagindex;
	local string tagname;

	makevectors(self.owner.v_angle);

	if (self.cnt == 1)
	{
		tagname = ("tag_arm_right");
		dir = relvel('0 150 -180', e);
	}
	else
	{
		tagname = ("tag_arm_left");
		dir = relvel('0 -150 -180', e);
	}

	tagindex = gettagindex(self.owner, tagname);
	tagorg = gettaginfo(self.owner, tagindex);

	if (!self.armcount)
	{
		local entity arm;
		arm = spawn();
		if (self.cnt == 1)
			arm.model = "models/enemies/executioner/arm_right.md3";
		else
			arm.model = "models/enemies/executioner/arm_left.md3";

		setmodel(arm, arm.model);
		arm.origin = tagorg;
		arm.angles = e.angles;
		arm.velocity = dir;
		setsize(arm, '0 0 0', '0 0 0');
		arm.movetype = MOVETYPE_BOUNCE;
		arm.solid = SOLID_TRIGGER;
		self.armcount = 1;
		chattersound("impact/gibs/gib_hit", 5, 1);
		local entity exp_blood;
		exp_blood = spawn();
		setattachment(exp_blood, self.owner, tagname);
		setmodel(exp_blood, "particles/explo/explo_blood1.md3");
		exp_blood.solid = SOLID_NOT;
		exp_blood.scale = 0.5;
		local float skinn;
		skinn = ceil(random() *4);
		if (skinn == 4)
			skinn = 0;
		exp_blood.skin = skinn * 10;
		exp_blood.think = cys_explode1b;
		exp_blood.nextthink = time + 0.05;

	}

	pointparticles(nparticles, tagorg, dir, 1);
	self.nextthink = time + 0.05;
	self.think = bleedthink;
}

void() executioner_painf1 =[$exec_painf1, executioner_painf2]
{
	self.skin = 1;
	msound(self, CHAN_AUTO, "enemies/executioner/mutilate.ogg", 1, 0.25);
	local entity bleed;
	bleed = spawn();
	bleed.owner = self;
	setmodel(bleed, "models/misc/null.md3");
	bleed.effects = EF_NODRAW;
	bleed.cnt = 1;
	setattachment(bleed, self, "tag_arm_right");
	bleed.think = bleedthink;
	bleed.nextthink = time;

};
void() executioner_painf2 =[$exec_painf2, executioner_painf3] {};
void() executioner_painf3 =[$exec_painf3, executioner_painf4] {};
void() executioner_painf4 =[$exec_painf4, executioner_painf5] {};
void() executioner_painf5 =[$exec_painf5, executioner_painf6] {};
void() executioner_painf6 =[$exec_painf6, executioner_painf7] {};
void() executioner_painf7 =[$exec_painf7, executioner_painf8] {};
void() executioner_painf8 =[$exec_painf8, executioner_painf9] {};
void() executioner_painf9 =[$exec_painf9, executioner_painf10] {};
void() executioner_painf10 =[$exec_painf10, executioner_run1]
{
	ai_pain(1);
	if (((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16) && (self.enemy.classname != "player"))
		self.think = executioner_chrgrandom;

};

void() executioner_paine1 =[$exec_paine1, executioner_paine2]
{
	self.skin = 2;
	msound(self, CHAN_AUTO, "enemies/executioner/mutilate.ogg", 1, 0.25);
	local entity bleed;
	bleed = spawn();
	bleed.owner = self;
	bleed.effects = EF_NODRAW;
	bleed.cnt = 2;
	setmodel(bleed, "models/misc/null.md3");
	setattachment(bleed, self, "tag_arm_left");
	bleed.think = bleedthink;
	bleed.nextthink = time;
};
void() executioner_paine2 =[$exec_paine2, executioner_paine3] {};
void() executioner_paine3 =[$exec_paine3, executioner_paine4] {};
void() executioner_paine4 =[$exec_paine4, executioner_paine5] {};
void() executioner_paine5 =[$exec_paine5, executioner_paine6] {};
void() executioner_paine6 =[$exec_paine6, executioner_paine7] {};
void() executioner_paine7 =[$exec_paine7, executioner_paine8] {};
void() executioner_paine8 =[$exec_paine8, executioner_paine9] {};
void() executioner_paine9 =[$exec_paine9, executioner_paine10] {};
void() executioner_paine10 =[$exec_paine10, executioner_run1]
{
	ai_pain(1);
	if (((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16) && (self.enemy.classname != "player"))
		self.think = executioner_chrgrandom;

};

void() executioner_paind1 =[$exec_paind1, executioner_paind2]
{
	painsound("enemies/executioner/pain");
};
void() executioner_paind2 =[$exec_paind2, executioner_paind3] {};
void() executioner_paind3 =[$exec_paind3, executioner_paind4] {};
void() executioner_paind4 =[$exec_paind4, executioner_paind5] {};
void() executioner_paind5 =[$exec_paind5, executioner_paind6] {};
void() executioner_paind6 =[$exec_paind6, executioner_paind7] {};
void() executioner_paind7 =[$exec_paind7, executioner_paind8] {};
void() executioner_paind8 =[$exec_paind8, executioner_paind9] {};
void() executioner_paind9 =[$exec_paind9, executioner_paind10] {};
void() executioner_paind10 =[$exec_paind10, executioner_run1]
{
	ai_pain(1);
	if (((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16) && (self.enemy.classname != "player"))
		self.think = executioner_chrgrandom;

};

void() executioner_painb1 =[$exec_painb1, executioner_painb2]
{
	painsound("enemies/executioner/pain");
};
void() executioner_painb2 =[$exec_painb2, executioner_painb3] {};
void() executioner_painb3 =[$exec_painb3, executioner_painb4] {};
void() executioner_painb4 =[$exec_painb4, executioner_painb5] {};
void() executioner_painb5 =[$exec_painb5, executioner_painb6] {};
void() executioner_painb6 =[$exec_painb6, executioner_painb7] {};
void() executioner_painb7 =[$exec_painb7, executioner_painb8] {};
void() executioner_painb8 =[$exec_painb8, executioner_painb9] {};
void() executioner_painb9 =[$exec_painb9, executioner_painb10] {};
void() executioner_painb10 =[$exec_painb10, executioner_run1]
{
	ai_pain(1);
	if (((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16) && (self.enemy.classname != "player"))
		self.think = executioner_chrgrandom;

};

void() executioner_paina1 =[$exec_paina1, executioner_paina2]
{
	painsound("enemies/executioner/pain");
};
void() executioner_paina2 =[$exec_paina2, executioner_paina3] {};
void() executioner_paina3 =[$exec_paina3, executioner_paina4] {};
void() executioner_paina4 =[$exec_paina4, executioner_paina5] {};
void() executioner_paina5 =[$exec_paina5, executioner_paina6] {};
void() executioner_paina6 =[$exec_paina6, executioner_paina7] {};
void() executioner_paina7 =[$exec_paina7, executioner_paina8] {};
void() executioner_paina8 =[$exec_paina8, executioner_paina9] {};
void() executioner_paina9 =[$exec_paina9, executioner_paina10] {};
void() executioner_paina10 =[$exec_paina10, executioner_run1]
{
	ai_pain(1);
	if (((max(self.enemy.origin_z, self.origin_z) - min(self.enemy.origin_z, self.origin_z)) > 16) && (self.enemy.classname != "player"))
		self.think = executioner_chrgrandom;
};

void() executioner_postpain = 
{
	local float r;
	r = random();

	if (r < 0.3)
		self.think = executioner_paina1;
	else if (r < 0.6)
		self.think = executioner_painb1;
	else
		self.think = executioner_paind1;
	self.charging = 1;
	self.pain_finished = time + 1;
	self.paintake = 0;
	self.nextthink = time;
};
.float mutilate;
.float arm_weak;
void() executioner_postpain2 = 
{
	if (self.arm_weak == 1)
		self.think = executioner_painf1;
	if (self.arm_weak == 2)
		self.think = executioner_paine1;

	self.nextthink = time;
}

void(entity attacker, float damage) executioner_pain = 
{
	if (self.charging == 1)
		return;
	if (self.paintake < 100)
		return;
	if (self.pain_finished > time)
		return;
	self.sustained_damage = 0;
	local float r;
	if (self.mutilate != 3)
		r = random() + 1;
	if (!self.mutilate)
		r = random();
	if (self.mutilate == 3)
		r = random();

	if (self.health > 600)
		self.think = executioner_postpain;
	else if ((self.health <= 600) && (self.health > 400))
	{
		if (r > 0.75)
			self.think = executioner_postpain2;
		else
			self.think = executioner_postpain;
	}
	else if ((self.health <= 400) && (self.health > 200))
	{
		if (r > 0.5)
			self.think = executioner_postpain2;
		else
			self.think = executioner_postpain;
	}
	else
	{
		if (r > 0.25)
			self.think = executioner_postpain2;
		else
			self.think = executioner_postpain;
	}

	if (self.skin != 0)
		self.think = executioner_postpain;

	self.nextthink = time;
};

void() executioner_diea1 = 
{
	if (self.cnt < 14)
	{
		self.frame += 1;
		self.cnt += 1;
	}
	else
	{
		self.cnt = 100;
	}

	self.nextthink = time + 0.1;
};

void() executioner_death = 
{
	if (self.skin == 1)
	{
		self.frame = $exec_deathb1;
		self.cnt = 0;
	}
	else
	{
		self.frame = $exec_deatha1;
		self.cnt = 1;
	}

	chattersound("enemies/executioner/die", 3, 1);
	decal_monster2(self.origin + '0 0 12');
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_TOSS;
	self.think = executioner_diea1;
	self.nextthink = time;

};

void() precache_monster_executioner = 
{
	precache_sound("enemies/executioner/blade_swing1.ogg");
	precache_sound("enemies/executioner/blade_swing2.ogg");
	precache_sound("enemies/executioner/blade_swing3.ogg");
	precache_sound("enemies/executioner/chatter_combat1.ogg");
	precache_sound("enemies/executioner/chatter_combat2.ogg");
	precache_sound("enemies/executioner/chatter_combat3.ogg");
	precache_sound("enemies/executioner/die1.ogg");
	precache_sound("enemies/executioner/die2.ogg");
	precache_sound("enemies/executioner/die3.ogg");
	precache_sound("enemies/executioner/idle1.ogg");
	precache_sound("enemies/executioner/idle2.ogg");
	precache_sound("enemies/executioner/idle3.ogg");
	precache_sound("enemies/executioner/mutilate.ogg");
	precache_sound("enemies/executioner/pain1.ogg");
	precache_sound("enemies/executioner/pain2.ogg");
	precache_sound("enemies/executioner/pain3.ogg");
	precache_sound("enemies/executioner/sight1.ogg");
	precache_sound("enemies/executioner/sight2.ogg");
	precache_sound("enemies/executioner/sight3.ogg");
	precache_sound("enemies/executioner/step1.ogg");
	precache_sound("enemies/executioner/step2.ogg");
	precache_sound("enemies/executioner/step3.ogg");
	precache_model("models/enemies/executioner/executioner.md3");
	precache_model("models/enemies/executioner/arm_right.md3");
	precache_model("models/enemies/executioner/arm_left.md3");
};

void() monster_executioner = 
{
	precache_sound("enemies/executioner/blade_swing1.ogg");
	precache_sound("enemies/executioner/blade_swing2.ogg");
	precache_sound("enemies/executioner/blade_swing3.ogg");
	precache_sound("enemies/executioner/chatter_combat1.ogg");
	precache_sound("enemies/executioner/chatter_combat2.ogg");
	precache_sound("enemies/executioner/chatter_combat3.ogg");
	precache_sound("enemies/executioner/die1.ogg");
	precache_sound("enemies/executioner/die2.ogg");
	precache_sound("enemies/executioner/die3.ogg");
	precache_sound("enemies/executioner/idle1.ogg");
	precache_sound("enemies/executioner/idle2.ogg");
	precache_sound("enemies/executioner/idle3.ogg");
	precache_sound("enemies/executioner/mutilate.ogg");
	precache_sound("enemies/executioner/pain1.ogg");
	precache_sound("enemies/executioner/pain2.ogg");
	precache_sound("enemies/executioner/pain3.ogg");
	precache_sound("enemies/executioner/sight1.ogg");
	precache_sound("enemies/executioner/sight2.ogg");
	precache_sound("enemies/executioner/sight3.ogg");
	precache_sound("enemies/executioner/step1.ogg");
	precache_sound("enemies/executioner/step2.ogg");
	precache_sound("enemies/executioner/step3.ogg");
	precache_model("models/enemies/executioner/executioner.md3");
	precache_model("models/enemies/executioner/arm_right.md3");
	precache_model("models/enemies/executioner/arm_left.md3");

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	self.flags = self.flags | FL_MONSTER;
	setmodel(self, "models/enemies/executioner/executioner.md3");
	self.classname = "executioner";
	self.heavymonster = 1;
	//self.damagetopain = opp_dtp;
	self.stepheight_delta = 8;
	local float r;
	r = (random() *3);
	if (r < 3)
		self.noise = "enemies/executioner/sight3.ogg";	
	if (r < 2)
		self.noise = "enemies/executioner/sight2.ogg";	
	if (r < 1)
		self.noise = "enemies/executioner/sight1.ogg";	

	setsize(self, '-32 -32 -32', '32 32 48');
	//	setsize (self, '-12 -12 -0', '12 12 64');
	self.health = exec_health;
	self.view_ofs_z = 72;
	self.th_stand = executioner_stand1;
	self.th_walk = executioner_walk1;
	local float war;
	war = random();

	if (war > 0.5)
		self.arm_weak = 1;
	else
		self.arm_weak = 2;

	if (self.mutilate)
		self.arm_weak = self.mutilate;

	if (!self.mutilate)
		self.mutilate = 3;
	self.onlymelee =  1;
	self.skin = 0;
	self.th_run = executioner_run1;
	self.classname = "executioner";
	self.th_pain = executioner_pain;
	self.th_die = executioner_death;
	self.th_melee = executioner_atkr;
	self.th_charge = executioner_chrgrandom;
	self.think = self.th_stand;
	self.nextthink = time;
	walkmonster_start();
};

////////////////end of qc file