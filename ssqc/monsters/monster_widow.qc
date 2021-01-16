/*

==============================================================================

widow

==============================================================================
*/

$frame pose0

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10

$frame run1 run2 run3 run4 run5 run6

$frame atkr1 atkr2 atkr3 atkr4

$frame atkl1 atkl2 atkl3 atkl4

$frame paina1 paina2 paina3 paina4 paina5 paina6

$frame painb1 painb2 painb3 painb4 painb5 painb6

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10

$frame deatha1 deatha2 deatha3 deatha4 deatha5

$frame deathb1 deathb2 deathb3 deathb4 deathb5

$frame deathc1 deathc2 deathc3 deathc4 deathc5

/////////////////////////////////////////////////////////////////////////////////////////////
void() loop_widow_soundoff;
void() widow_stand1 =[$idle1, widow_stand2]
{
	ai_stand();
	loop_widow_soundoff();
	local float r;
	r = random() *15;
	if ((r < 1) && (!(self.spawnflags &1)))
		msound(self, CHAN_VOICE, "enemies/widow/idle.ogg", 1, 0.5);
	//chattersound ("enemies/widow/idle", 1, 0.5);
};
void() widow_stand2 =[$idle2, widow_stand3]
{
	ai_stand();
};
void() widow_stand3 =[$idle3, widow_stand4]
{
	ai_stand();
};
void() widow_stand4 =[$idle4, widow_stand5]
{
	ai_stand();
};
void() widow_stand5 =[$idle5, widow_stand6]
{
	ai_stand();
};
void() widow_stand6 =[$idle6, widow_stand7]
{
	ai_stand();
};
void() widow_stand7 =[$idle7, widow_stand8]
{
	ai_stand();
};
void() widow_stand8 =[$idle8, widow_stand9]
{
	ai_stand();
};
void() widow_stand9 =[$idle9, widow_stand10]
{
	ai_stand();
};
void() widow_stand10 =[$idle10, widow_stand1]
{
	ai_stand();
};

/////////////////////////////////////////////////////////////////////////////////////////////

void() widow_walk1 =[$run1, widow_walk2]
{
	ai_walk(12);
};
void() widow_walk2 =[$run2, widow_walk3]
{
	ai_walk(12);
};
void() widow_walk3 =[$run3, widow_walk4]
{
	ai_walk(12);
	walksound("enemies/widow/step", 3);
};
void() widow_walk4 =[$run4, widow_walk5]
{
	ai_walk(12);
};
void() widow_walk5 =[$run5, widow_walk6]
{
	ai_walk(12);
};
void() widow_walk6 =[$run6, widow_walk1]
{
	ai_walk(12);
	walksound("enemies/widow/step", 3);
};
/////////////////////////////////////////////////////////////////////////////////////////////
void() widow_atk1;
void() widow_atkb1;
void() widow_run3;
void() widow_run5;

void() widow_jump = 
{
	if ((vlen(self.velocity) < 30) && (self.flags &FL_ONGROUND) && (self.enemy.health > 0))
	{
		self.effects = 128;
		makevectors(self.angles);
		self.origin_z = self.origin_z + 1;
		self.velocity = v_forward *250 + '0 0 150';
		if (self.flags &FL_ONGROUND)
			self.flags = self.flags - FL_ONGROUND;
	}
};

.float runwidowtime;
void() widow_atk = 
{
	local float r;
	r = random();
	if (r < 0.5)
		self.think = widow_atk1;
	else
		self.think = widow_atkb1;
	self.movetype = MOVETYPE_STEP;
	self.nextthink = time;
};

.float widowscreaming;
void() loop_widow_sound = 
{
	if ((self.widowscreaming != 1) && (self.widowscreamingtime < time))
	{
		msound(self, CHAN_VOICE, "enemies/widow/run.ogg", 0.5, 0.25);
		self.widowscreaming = 1;
	}
};

void() loop_widow_soundoff = 
{
	msound(self, CHAN_VOICE, "enemies/widow/run.ogg", 0, 0);
	self.widowscreaming = 0;
};

void() widow_run1 =[$run1, widow_run2]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
	loop_widow_sound();
};
void() widow_run2 =[$run1, widow_run3]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() widow_run3 =[$run2, widow_run4]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() widow_run4 =[$run2, widow_run5]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() widow_run5 =[$run3, widow_run6]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
	walksound("enemies/widow/step", 3);
};
void() widow_run6 =[$run3, widow_run7]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() widow_run7 =[$run4, widow_run8]
{
	ai_test_monster_run(16);
	if ((visible2(self.enemy, 64, 0.3)) && (self.enemy.classname != "path_waypoint") && (self.enemy.noattack != 1))
	{
		ai_face();
		self.think = widow_atk;
	}
	self.nextthink = time + 0.05;
};
void() widow_run8 =[$run4, widow_run9]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() widow_run9 =[$run5, widow_run10]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() widow_run10 =[$run5, widow_run11]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
	loop_widow_sound();
};
void() widow_run11 =[$run6, widow_run12]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
	walksound("enemies/widow/step", 3);
};
void() widow_run12 =[$run6, widow_run1]
{
	ai_test_monster_run(16);
	if ((visible2(self.enemy, 64, 0.3)) && (self.enemy.classname != "path_waypoint") && (self.enemy.noattack != 1))
	{
		ai_face();
		self.think = widow_atk;
	}

	self.nextthink = time + 0.05;
};
/////////////////////////////////////////////////////////////////////////////////////////////
void() widow_atkb1;
void(float wdmg) widow_attack = 
{
	local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);
	loop_widow_soundoff();
	if (dist > 120)
	{
		chattersound("enemies/widow/miss", 3, 1);
		return;
	}
	else
	{
		//wdmg = wdmg + (widowdamage/120 *(120 - dist));
		//if (dist < 32)
		//	wdmg = widowdamage * 2;
		wdmg = widowdamage;
		chattersound("enemies/widow/hit_", 4, 1);
		T_Damage(self.enemy, self, self, wdmg);
	}
};

void() widow_atk1 =[$atkl1, widow_atk2]
{
	ai_face();
	ai_charge(7);

	if (self.widowscreamingtime < time)
		monstersound1("enemies/widow/attack", 3, CHAN_WEAPON);
};
void() widow_atk2 =[$atkl2, widow_atk3]
{
	ai_face();
	ai_charge(5);
};
void() widow_atk3 =[$atkl3, widow_atk4]
{
	ai_face();
	widow_attack(15);
	ai_charge(10);
};
void() widow_atk4 = 
{
	ai_charge(10);
	ai_face();
	self.frame = $atkl4;
	if ((visible2(self.enemy, 64, 0.3)))
		self.think = widow_atkb1;
	else
		self.think = widow_run1;
	self.nextthink = time + 0.1;
};
void() widow_atkb1 =[$atkr1, widow_atkb2]
{
	ai_face();
	ai_charge(7);
	if (self.widowscreamingtime < time)
		chattersound("enemies/widow/attack", 3, CHAN_WEAPON);
};
void() widow_atkb2 =[$atkr2, widow_atkb3]
{
	ai_face();
	ai_charge(5);
};
void() widow_atkb3 =[$atkr3, widow_atkb4]
{
	ai_face();
	widow_attack(15);
	ai_charge(10);
}

void() widow_atkb4 = 
{
	ai_face();
	self.frame = $atkr4;
	if ((visible2(self.enemy, 64, 0.3)))
		self.think = widow_atk1;
	else
		self.think = widow_run1;
	self.nextthink = time + 0.1;
};
///////////////////////////////////////////////////////////////////////////////////////////
void() widow_paina1 =[$paina1, widow_paina2]
{
	ai_pain(4);
	self.pain_finished = time + 1.2;
};
void() widow_paina2 =[$paina2, widow_paina3]
{
	ai_pain(2);
};
void() widow_paina3 =[$paina3, widow_paina4]
{
	ai_pain(2);
};
void() widow_paina4 =[$paina4, widow_paina5]
{
	ai_pain(0);
};
void() widow_paina5 =[$paina5, widow_paina6]
{
	ai_pain(0);
};
void() widow_paina6 =[$paina6, widow_run1]
{
	ai_pain(0);
};

void() widow_painb1 =[$painb1, widow_painb2]
{
	ai_pain(5);
	self.pain_finished = time + 1.2;
};
void() widow_painb2 =[$painb2, widow_painb3]
{
	ai_pain(4);
};
void() widow_painb3 =[$painb3, widow_painb4]
{
	ai_pain(3);
};
void() widow_painb4 =[$painb4, widow_painb5]
{
	ai_pain(0);
};
void() widow_painb5 =[$painb5, widow_painb6]
{
	ai_pain(0);
};
void() widow_painb6 =[$painb6, widow_run1]
{
	ai_pain(0);
};

void() widow_painc1 =[$painc1, widow_painc2]
{
	ai_pain(8);
	self.pain_finished = time + 2;
};
void() widow_painc2 =[$painc2, widow_painc3]
{
	ai_pain(7);
};
void() widow_painc3 =[$painc3, widow_painc4]
{
	ai_pain(6);
};
void() widow_painc4 =[$painc4, widow_painc5]
{
	ai_pain(0);
};
void() widow_painc5 =[$painc5, widow_painc6]
{
	ai_pain(1);
};
void() widow_painc6 =[$painc6, widow_painc7]
{
	ai_pain(0);
};
void() widow_painc7 =[$painc7, widow_painc8]
{
	ai_pain(1);
};
void() widow_painc8 =[$painc8, widow_painc9]
{
	ai_pain(2);
};
void() widow_painc9 =[$painc9, widow_painc10]
{
	ai_pain(0);
};
void() widow_painc10 =[$painc10, widow_run1]
{
	ai_pain(0);
};

void() widow_painr = 
{
	loop_widow_soundoff();
	local float r;
	r = random();
	chattersound("enemies/widow/pain", 3, 1);
	if (r < 0.6)
	{
		if (r < 0.3)
			widow_painb1();
		else
			widow_paina1();
	}
	else
		widow_painc1();
};

void(entity attacker, float damage) widow_pain = 
{
	if (self.pain_finished > time)
		return;
	msound(self, CHAN_VOICE, "enemies/widow/run.ogg", 0, 0);
	self.sustained_damage = 0;
	self.movetype = MOVETYPE_STEP;

	local float pp, rp;
	if (damage >= widph)
	{
		pp = hpdmg;
	}

	if ((damage <= widpm) && (damage > widpl))
	{
		pp = mpdmg;
	}

	if (damage <= widpl)
	{
		pp = lpdmg;
	}
	if(self.enemy.weapon != IT_BOIL)
	{
	rp = random();
	if (rp > pp)
		return;
	}
	widow_painr();
}

///////////////////////////////////////////////////////////////////////////////////////////
void() widow_diea1 =[$deatha1, widow_diea2]
{
	self.glowmod = '0.8 0.8 0.8';
};
void() widow_diea2 =[$deatha2, widow_diea3]
{
	self.glowmod = '0.6 0.6 0.6';
};
void() widow_diea3 =[$deatha3, widow_diea4]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() widow_diea4 =[$deatha4, widow_diea5]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() widow_diea5 =[$deatha5, widow_diea5]
{
	self.glowmod = '-1 -1 -1';
};

void() widow_dieb1 =[$deathb1, widow_dieb2]
{
	self.glowmod = '0.8 0.8 0.8';
};
void() widow_dieb2 =[$deathb2, widow_dieb3]
{
	self.glowmod = '0.6 0.6 0.6';
};
void() widow_dieb3 =[$deathb3, widow_dieb4]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() widow_dieb4 =[$deathb4, widow_dieb5]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() widow_dieb5 =[$deathb5, widow_dieb5]
{
	self.glowmod = '-1 -1 -1';
};

void() widow_diec1 =[$deathc1, widow_diec2]
{
	self.glowmod = '0.8 0.8 0.8';
};
void() widow_diec2 =[$deathc2, widow_diec3]
{
	self.glowmod = '0.6 0.6 0.6';
};
void() widow_diec3 =[$deathc3, widow_diec4]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() widow_diec4 =[$deathc4, widow_diec5]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() widow_diec5 =[$deathc5, widow_diec5]
{
	self.glowmod = '-1 -1 -1';
};

void() widow_die = 
{
	loop_widow_soundoff();
	msound(self, CHAN_ITEM, "enemies/widow/run.ogg", 0, 0);

	drop_item(self.origin - '0 0 12', "fangs", 10, self);
	self.solid = 0;
    self.velocity = '0 0 0';
	self.movetype = MOVETYPE_TOSS;
	if ((self.health < widod) || (self.gibbable))
	{
		local vector tagorg;
		local float tagindex;
		local string tagname;
		tagname = ("tag_arm_r_a");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_arm_r_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-10 100 130', self), 0, 0);
		tagname = ("tag_arm_r_b");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_arm_r_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('10 100 120', self), 0, 0);
		tagname = ("tag_arm_l_a");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_arm_l_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('10 -120 100', self), 0, 0);
		tagname = ("tag_arm_l_b");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_arm_l_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-10 -60 90', self), 0, 0);
		tagname = ("tag_head");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('100 0 60', self), 0, 1);
		tagname = ("tag_leg_r_a");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_leg_r_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('10 120 120', self), 0, 0);
		tagname = ("tag_leg_r_b");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_leg_r_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-10 60 110', self), 0, 0);
		tagname = ("tag_leg_l_a");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_leg_l_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-10 -120 110', self), 0, 0);
		tagname = ("tag_leg_l_b");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/widow/gibs/gib_leg_l_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('20 -60 90', self), 0, 0);

		chattersound("impact/gibs/gib_explo", 3, 1);
		explo_blood(1, self.origin + '0 0 0');
		pointparticles(particleeffectnum("gib1"), self.origin + '0 0 0', v_forward *(-550), 1);
		remove(self);
		return;
	}

	local float r;
	r = random();
	chattersound("enemies/widow/die", 3, 1);
	if (r < 0.6)
	{
		if (r < 0.3)
			self.think = widow_dieb1;
		else
			self.think = widow_diea1;
	}
	else
		self.think = widow_diec1;
	self.glowmod = '1 1 1';
	self.nextthink = time + 0.1;
};
///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_widow (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() precache_monster_widow = 
{
	precache_sound("enemies/widow/attack1.ogg");
	precache_sound("enemies/widow/attack2.ogg");
	precache_sound("enemies/widow/attack3.ogg");
	precache_sound("enemies/widow/die1.ogg");
	precache_sound("enemies/widow/die2.ogg");
	precache_sound("enemies/widow/die3.ogg");
	precache_sound("enemies/widow/hit_1.ogg");
	precache_sound("enemies/widow/hit_2.ogg");
	precache_sound("enemies/widow/hit_3.ogg");
	precache_sound("enemies/widow/hit_4.ogg");
	precache_sound("enemies/widow/idle.ogg");
	precache_sound("enemies/widow/miss1.ogg");
	precache_sound("enemies/widow/miss2.ogg");
	precache_sound("enemies/widow/miss3.ogg");
	precache_sound("enemies/widow/pain1.ogg");
	precache_sound("enemies/widow/pain2.ogg");
	precache_sound("enemies/widow/pain3.ogg");
	precache_sound("enemies/widow/run.ogg");
	precache_sound("enemies/widow/sight1.ogg");
	precache_sound("enemies/widow/sight2.ogg");
	precache_sound("enemies/widow/sight3.ogg");
	precache_sound("enemies/widow/step1.ogg");
	precache_sound("enemies/widow/step2.ogg");
	precache_sound("enemies/widow/step3.ogg");
	precache_model("models/enemies/widow/widow.md3");
	precache_model("models/enemies/widow/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/widow/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/widow/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/widow/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/widow/gibs/gib_head.md3");
	precache_model("models/enemies/widow/gibs/gib_leg_r_a.md3");
	precache_model("models/enemies/widow/gibs/gib_leg_r_b.md3");
	precache_model("models/enemies/widow/gibs/gib_leg_l_a.md3");
	precache_model("models/enemies/widow/gibs/gib_leg_l_b.md3");
};
void() monster_widow = 
{
	precache_sound("enemies/widow/attack1.ogg");
	precache_sound("enemies/widow/attack2.ogg");
	precache_sound("enemies/widow/attack3.ogg");
	precache_sound("enemies/widow/die1.ogg");
	precache_sound("enemies/widow/die2.ogg");
	precache_sound("enemies/widow/die3.ogg");
	precache_sound("enemies/widow/hit_1.ogg");
	precache_sound("enemies/widow/hit_2.ogg");
	precache_sound("enemies/widow/hit_3.ogg");
	precache_sound("enemies/widow/hit_4.ogg");
	precache_sound("enemies/widow/idle.ogg");
	precache_sound("enemies/widow/miss1.ogg");
	precache_sound("enemies/widow/miss2.ogg");
	precache_sound("enemies/widow/miss3.ogg");
	precache_sound("enemies/widow/pain1.ogg");
	precache_sound("enemies/widow/pain2.ogg");
	precache_sound("enemies/widow/pain3.ogg");
	precache_sound("enemies/widow/run.ogg");
	precache_sound("enemies/widow/sight1.ogg");
	precache_sound("enemies/widow/sight2.ogg");
	precache_sound("enemies/widow/sight3.ogg");
	precache_sound("enemies/widow/step1.ogg");
	precache_sound("enemies/widow/step2.ogg");
	precache_sound("enemies/widow/step3.ogg");
	precache_model("models/enemies/widow/widow.md3");
	precache_model("models/enemies/widow/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/widow/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/widow/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/widow/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/widow/gibs/gib_head.md3");
	precache_model("models/enemies/widow/gibs/gib_leg_r_a.md3");
	precache_model("models/enemies/widow/gibs/gib_leg_r_b.md3");
	precache_model("models/enemies/widow/gibs/gib_leg_l_a.md3");
	precache_model("models/enemies/widow/gibs/gib_leg_l_b.md3");

	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.onlymelee =  1;

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/widow/widow.md3");
	self.bbvv = widowbbox;
	setsize(self, widownbbox, widowbbox);
	self.exec_push = 8;
	local float r;
	r = (random() *3);
	if (r < 3)
		self.noise = "enemies/widow/sight3.ogg";	
	if (r < 2)
		self.noise = "enemies/widow/sight2.ogg";	
	if (r < 1)
		self.noise = "enemies/widow/sight1.ogg";	
	self.health = widowhealth;
	self.classname = "monster_widow";
	self.max_health = widowhealth;
	self.view_ofs_z = 60;
	self.stepheight_delta = 8;
	self.th_stand = widow_stand1;
	self.th_walk = widow_walk1;
	self.th_run = widow_run1;
	self.th_melee = widow_atk;
	self.th_pain = widow_pain;
	self.th_die = widow_die;
	walkmonster_start();
};

////////////////end of qc file
