/*

==============================================================================

incisor

==============================================================================
*/

$frame inc_pose0

$frame inc_idle1 inc_idle2 inc_idle3 inc_idle4 inc_idle5 inc_idle6 inc_idle7 inc_idle8 inc_idle9 inc_idle10

$frame inc_run1 inc_run2 inc_run3 inc_run4 inc_run5 inc_run6

$frame inc_atkr1 inc_atkr2 inc_atkr3 inc_atkr4

$frame inc_atkl1 inc_atkl2 inc_atkl3 inc_atkl4

$frame inc_paina1 inc_paina2 inc_paina3 inc_paina4 inc_paina5 inc_paina6

$frame inc_painb1 inc_painb2 inc_painb3 inc_painb4 inc_painb5 inc_painb6

$frame inc_painc1 inc_painc2 inc_painc3 inc_painc4 inc_painc5 inc_painc6 inc_painc7 inc_painc8 inc_painc9 inc_painc10

$frame inc_deatha1 inc_deatha2 inc_deatha3 inc_deatha4 inc_deatha5

$frame inc_deathb1 inc_deathb2 inc_deathb3 inc_deathb4 inc_deathb5

$frame inc_deathc1 inc_deathc2 inc_deathc3 inc_deathc4 inc_deathc5

/////////////////////////////////////////////////////////////////////////////////////////////
void() loop_incisor_soundoff;
.float resting;
void()incisor_touch =
{
	if((other.classname == "player") && (self.resting == 1))
	{
		self.angles_y = vectoyaw((self.enemy.origin) - rorigin(self));
		self.ideal_yaw = self.angles_y;
		ChangeYaw();
		self.nextthink = time + 0.05;
	}
};

.entity alpha_control;
.float alpha_fade;
void() alpha_modifier =
{
	if(self.owner.health <= 0)
	{
	self.owner.alpha_fade = -1;
	self.lifetime =  time + 1;
	}

	if((self.owner.alpha_fade == 1) ) 
	{

		if(self.owner.alpha <= 0)
		self.owner.alpha = -1;
		if (self.owner.alpha != -1)
		self.owner.alpha -= 0.05;

	}

	if(self.owner.alpha_fade == -1)
	{
		if(self.owner.alpha == -1)
		self.owner.alpha = 0.01;

		if(self.owner.alpha >= 1)
		self.owner.alpha = 1;

		if(self.owner.alpha != 1)
		self.owner.alpha += 0.05;

	}
	if((self.owner.health <= 0) && (self.lifetime < time))
	remove(self);	
	self.nextthink = time + 0.05;
	self.think = alpha_modifier;
};

void() incisor_stand1 =[$inc_idle1, incisor_stand2]
{
	ai_stand();
	loop_incisor_soundoff();
	local float r;
	r = random() *15;
	if ((r < 1) && (!(self.spawnflags &1)))
		msound(self, CHAN_VOICE, "enemies/incisor/inc_idle.ogg", 1, 0.5);
	//chattersound ("enemies/incisor/inc_idle", 1, 0.5);
};
void() incisor_stand2 =[$inc_idle2, incisor_stand3]
{
	ai_stand();
};
void() incisor_stand3 =[$inc_idle3, incisor_stand4]
{
	ai_stand();
};
void() incisor_stand4 =[$inc_idle4, incisor_stand5]
{
	ai_stand();
};
void() incisor_stand5 =[$inc_idle5, incisor_stand6]
{
	ai_stand();
};
void() incisor_stand6 =[$inc_idle6, incisor_stand7]
{
	ai_stand();
};
void() incisor_stand7 =[$inc_idle7, incisor_stand8]
{
	ai_stand();
};
void() incisor_stand8 =[$inc_idle8, incisor_stand9]
{
	ai_stand();
};
void() incisor_stand9 =[$inc_idle9, incisor_stand10]
{
	ai_stand();
};
void() incisor_stand10 =[$inc_idle10, incisor_stand1]
{
	ai_stand();
};

/////////////////////////////////////////////////////////////////////////////////////////////

void() incisor_walk1 =[$inc_run1, incisor_walk2]
{
	ai_walk(12);
};
void() incisor_walk2 =[$inc_run2, incisor_walk3]
{
	ai_walk(12);
};
void() incisor_walk3 =[$inc_run3, incisor_walk4]
{
	ai_walk(12);
	walksound("player/footsteps/mud", 3);
};
void() incisor_walk4 =[$inc_run4, incisor_walk5]
{
	ai_walk(12);
};
void() incisor_walk5 =[$inc_run5, incisor_walk6]
{
	ai_walk(12);
};
void() incisor_walk6 =[$inc_run6, incisor_walk1]
{
	ai_walk(12);
	walksound("player/footsteps/mud", 5);
};
/////////////////////////////////////////////////////////////////////////////////////////////
void() incisor_atk1;
void() incisor_atkb1;
void() incisor_run3;
void() incisor_run5;

void() incisor_jump = 
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

.float runincisortime;
.float incisorscreamingtime;
void() incisor_atk = 
{
	local float r;

	if(self.alpha < 0.5)	
	self.alpha = 0.5;
	self.alpha_fade  = -1;
	r = (random() *3);
	if (r < 3)
		string screamnoise = "enemies/widow/sight3.ogg";	
	if (r < 2)
		screamnoise = "enemies/widow/sight2.ogg";	
	if (r < 1)
		screamnoise = "enemies/widow/sight1.ogg";

	msound(self, CHAN_VOICE, screamnoise, 0.5, 0.25);
	self.incisorscreamingtime = soundlength (screamnoise);

	r = random();
	if (r < 0.5)
		self.think = incisor_atk1;
	else
		self.think = incisor_atkb1;
	self.movetype = MOVETYPE_STEP;
	self.nextthink = time;
};

.float incisorscreaming;
void() loop_incisor_sound = 
{
	
	/*if ((self.incisorscreaming != 1) && (self.incisorscreamingtime < time))
	{
		msound(self, CHAN_VOICE, "enemies/incisor/run.ogg", 0.5, 0.25);
		self.incisorscreaming = 1;
	}*/
};

void() loop_incisor_soundoff = 
{
	msound(self, CHAN_VOICE, "enemies/incisor/run.ogg", 0, 0);
	self.incisorscreaming = 0;
};

void() incisor_run1 =[$inc_run1, incisor_run2]
{
	self.resting = 0;
	self.alpha_fade  = 1;
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
	loop_incisor_sound();
};
void() incisor_run2 =[$inc_run1, incisor_run3]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() incisor_run3 =[$inc_run2, incisor_run4]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() incisor_run4 =[$inc_run2, incisor_run5]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() incisor_run5 =[$inc_run3, incisor_run6]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
	walksound("player/footsteps/mud", 3);
};
void() incisor_run6 =[$inc_run3, incisor_run7]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() incisor_run7 =[$inc_run4, incisor_run8]
{
	ai_test_monster_run(16);
	if ((visible2(self.enemy, 64, 0.3)) && (self.enemy.classname != "path_waypoint") && (self.enemy.noattack != 1) && (self.evading_time < time))
	{
		ai_face();
		self.think = incisor_atk;
	}
	self.nextthink = time + 0.05;
};
void() incisor_run8 =[$inc_run4, incisor_run9]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() incisor_run9 =[$inc_run5, incisor_run10]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
};
void() incisor_run10 =[$inc_run5, incisor_run11]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
	loop_incisor_sound();
};
void() incisor_run11 =[$inc_run6, incisor_run12]
{
	ai_test_monster_run(16);
	self.nextthink = time + 0.05;
	walksound("player/footsteps/mud", 3);
};
.float evading;

void() incisor_run12 =[$inc_run6, incisor_run1]
{
	ai_test_monster_run(16);
	if ((visible2(self.enemy, 64, 0.3)) && (self.enemy.classname != "path_waypoint") && (self.enemy.noattack != 1) && (self.evading_time < time))
	{
		ai_face();
		self.resting = 0;
		self.think = incisor_atk;
		self.nextthink = time + 0.05;
		return;
	}


	if(self.evading == 2)
	{
	self.evading = 0;
	self.resting = 1;
	self.nextthink = time + random(2,5);
	}	
	else
	self.nextthink = time + 0.05;
};
/////////////////////////////////////////////////////////////////////////////////////////////
void() incisor_atkb1;
void(float wdmg) incisor_attack = 
{
	local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);


	loop_incisor_soundoff();
	if (dist > 120)
	{
		chattersound("enemies/widow/miss", 3, 1);
		return;
	}
	else
	{
		//wdmg = wdmg + (incisordamage/120 *(120 - dist));
		//if (dist < 32)
		//	wdmg = incisordamage * 2;
		wdmg = incisordamage;
		chattersound("enemies/widow/hit_", 4, 1);
		T_Damage(self.enemy, self, self, wdmg);
	}
};

void() redirect_newangles =
{

	self.angles_y = self.angles_y + random(160, 200) ;
	self.ideal_yaw = self.angles_y;
	self.evading_time = time + random(2,5);
	self.evading = 1;
	ChangeYaw();
}

void() incisor_atk1 =[$inc_atkl1, incisor_atk2]
{
	ai_face();
	ai_charge(7);
	
	if (self.incisorscreamingtime < time)
		monstersound1("enemies/widow/attack", 3, CHAN_WEAPON);
};
void() incisor_atk2 =[$inc_atkl2, incisor_atk3]
{
	ai_face();
	ai_charge(5);
};
void() incisor_atk3 =[$inc_atkl3, incisor_atk4]
{
	ai_face();
	incisor_attack(15);
	ai_charge(10);
};
void() incisor_atk4 = 
{
	ai_charge(10);
	ai_face();
	self.frame = $inc_atkl4;
	if ((visible2(self.enemy, 64, 0.3)))
		self.think = incisor_atkb1;
	else
	{	
	redirect_newangles();
	self.think = incisor_run1;
	}
	self.nextthink = time + 0.1;
};
void() incisor_atkb1 =[$inc_atkr1, incisor_atkb2]
{
	ai_face();
	ai_charge(7);
	if (self.incisorscreamingtime < time)
		monstersound1("enemies/widow/attack", 3, CHAN_WEAPON);

};
void() incisor_atkb2 =[$inc_atkr2, incisor_atkb3]
{
	ai_face();
	ai_charge(5);
};
void() incisor_atkb3 =[$inc_atkr3, incisor_atkb4]
{
	ai_face();
	incisor_attack(15);
	ai_charge(10);
}

void() incisor_atkb4 = 
{
	ai_face();
	self.frame = $inc_atkr4;
	if ((visible2(self.enemy, 64, 0.3)))
		self.think = incisor_atk1;
	else
	{	
		redirect_newangles();
		self.think = incisor_run1;
	}
	self.nextthink = time + 0.1;
};
///////////////////////////////////////////////////////////////////////////////////////////
void() incisor_paina1 =[$inc_paina1, incisor_paina2]
{
	ai_pain(4);
	self.pain_finished = time + 1.2;
};
void() incisor_paina2 =[$inc_paina2, incisor_paina3]
{
	ai_pain(2);
};
void() incisor_paina3 =[$inc_paina3, incisor_paina4]
{
	ai_pain(2);
};
void() incisor_paina4 =[$inc_paina4, incisor_paina5]
{
	ai_pain(0);
};
void() incisor_paina5 =[$inc_paina5, incisor_paina6]
{
	ai_pain(0);
};
void() incisor_paina6 =[$inc_paina6, incisor_run1]
{
	ai_pain(0);
};

void() incisor_painb1 =[$inc_painb1, incisor_painb2]
{
	ai_pain(5);
	self.pain_finished = time + 1.2;
};
void() incisor_painb2 =[$inc_painb2, incisor_painb3]
{
	ai_pain(4);
};
void() incisor_painb3 =[$inc_painb3, incisor_painb4]
{
	ai_pain(3);
};
void() incisor_painb4 =[$inc_painb4, incisor_painb5]
{
	ai_pain(0);
};
void() incisor_painb5 =[$inc_painb5, incisor_painb6]
{
	ai_pain(0);
};
void() incisor_painb6 =[$inc_painb6, incisor_run1]
{
	ai_pain(0);
};

void() incisor_painc1 =[$inc_painc1, incisor_painc2]
{
	ai_pain(8);
	self.pain_finished = time + 2;
};
void() incisor_painc2 =[$inc_painc2, incisor_painc3]
{
	ai_pain(7);
};
void() incisor_painc3 =[$inc_painc3, incisor_painc4]
{
	ai_pain(6);
};
void() incisor_painc4 =[$inc_painc4, incisor_painc5]
{
	ai_pain(0);
};
void() incisor_painc5 =[$inc_painc5, incisor_painc6]
{
	ai_pain(1);
};
void() incisor_painc6 =[$inc_painc6, incisor_painc7]
{
	ai_pain(0);
};
void() incisor_painc7 =[$inc_painc7, incisor_painc8]
{
	ai_pain(1);
};
void() incisor_painc8 =[$inc_painc8, incisor_painc9]
{
	ai_pain(2);
};
void() incisor_painc9 =[$inc_painc9, incisor_painc10]
{
	ai_pain(0);
};
void() incisor_painc10 =[$inc_painc10, incisor_run1]
{
	ai_pain(0);
};

void() incisor_painr = 
{
	loop_incisor_soundoff();
	local float r;
	r = random();
	chattersound("enemies/incisor/pain", 3, 1);
	if (r < 0.6)
	{
		if (r < 0.3)
			incisor_painb1();
		else
			incisor_paina1();
	}
	else
		incisor_painc1();
	self.nextthink = time + 0.1;
};

void(entity attacker, float damage) incisor_pain = {

	self.alpha_fade = 0;
	self.evading_time = 0;
	self.alpha = 1;
	self.evading = 0;
	self.resting = 0;

	self.nextthink = time + 0.05;
 if (self.pain_finished > time)
		return;
	msound(self, CHAN_VOICE, "enemies/incisor/run.ogg", 0, 0);
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
	self.think = incisor_painr;
	self.nextthink = time;
}

///////////////////////////////////////////////////////////////////////////////////////////
void() incisor_diea1 =[$inc_deatha1, incisor_diea2]
{
	self.glowmod = '0.8 0.8 0.8';
};
void() incisor_diea2 =[$inc_deatha2, incisor_diea3]
{
	self.glowmod = '0.6 0.6 0.6';
};
void() incisor_diea3 =[$inc_deatha3, incisor_diea4]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() incisor_diea4 =[$inc_deatha4, incisor_diea5]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() incisor_diea5 =[$inc_deatha5, incisor_diea5]
{
	self.glowmod = '-1 -1 -1';
};

void() incisor_dieb1 =[$inc_deathb1, incisor_dieb2]
{
	self.glowmod = '0.8 0.8 0.8';
};
void() incisor_dieb2 =[$inc_deathb2, incisor_dieb3]
{
	self.glowmod = '0.6 0.6 0.6';
};
void() incisor_dieb3 =[$inc_deathb3, incisor_dieb4]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() incisor_dieb4 =[$inc_deathb4, incisor_dieb5]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() incisor_dieb5 =[$inc_deathb5, incisor_dieb5]
{
	self.glowmod = '-1 -1 -1';
};

void() incisor_diec1 =[$inc_deathc1, incisor_diec2]
{
	self.glowmod = '0.8 0.8 0.8';
};
void() incisor_diec2 =[$inc_deathc2, incisor_diec3]
{
	self.glowmod = '0.6 0.6 0.6';
};
void() incisor_diec3 =[$inc_deathc3, incisor_diec4]
{
	self.glowmod = '0.4 0.4 0.4';
};
void() incisor_diec4 =[$inc_deathc4, incisor_diec5]
{
	self.glowmod = '0.2 0.2 0.2';
};
void() incisor_diec5 =[$inc_deathc5, incisor_diec5]
{
	self.glowmod = '-1 -1 -1';
};

void() incisor_die = 
{
	loop_incisor_soundoff();
	msound(self, CHAN_ITEM, "enemies/incisor/run.ogg", 0, 0);

	drop_item(self.origin - '0 0 12', "fangs", 10, self);
	self.solid = 0;
	if ((self.health < widod) || (self.gibbable))
	{
		local vector tagorg;
		local float tagindex;
		local string tagname;
		tagname = ("tag_arm_r_a");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_arm_r_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-10 100 130', self), 0, 0);
		tagname = ("tag_arm_r_b");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_arm_r_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('10 100 120', self), 0, 0);
		tagname = ("tag_arm_l_a");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_arm_l_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('10 -120 100', self), 0, 0);
		tagname = ("tag_arm_l_b");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_arm_l_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-10 -60 90', self), 0, 0);
		tagname = ("tag_head");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('100 0 60', self), 0, 1);
		tagname = ("tag_leg_r_a");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_leg_r_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('10 120 120', self), 0, 0);
		tagname = ("tag_leg_r_b");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_leg_r_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-10 60 110', self), 0, 0);
		tagname = ("tag_leg_l_a");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_leg_l_a.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('-10 -120 110', self), 0, 0);
		tagname = ("tag_leg_l_b");
		tagindex = gettagindex(self, tagname);
		tagorg = gettaginfo(self, tagindex);
		ThrowGib2("models/enemies/incisor/gibs/gib_leg_l_b.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel('20 -60 90', self), 0, 0);

		chattersound("impact/gibs/gib_explo", 3, 1);
		explo_blood(1, self.origin + '0 0 0');
		pointparticles(particleeffectnum("gib1"), self.origin + '0 0 0', v_forward *(-550), 1);
		remove(self);
		return;
	}

	local float r;
	r = random();
	chattersound("enemies/incisor/die", 3, 1);
	if (r < 0.6)
	{
		if (r < 0.3)
			self.think = incisor_dieb1;
		else
			self.think = incisor_diea1;
	}
	else
		self.think = incisor_diec1;
	self.glowmod = '1 1 1';
	self.nextthink = time + 0.1;
};
///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_incisor (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() precache_monster_incisor = 
{
	precache_sound("enemies/incisor/attack1.ogg");
	precache_sound("enemies/incisor/attack2.ogg");
	precache_sound("enemies/incisor/attack3.ogg");
	precache_sound("enemies/incisor/die1.ogg");
	precache_sound("enemies/incisor/die2.ogg");
	precache_sound("enemies/incisor/die3.ogg");
	precache_sound("enemies/incisor/hit_1.ogg");
	precache_sound("enemies/incisor/hit_2.ogg");
	precache_sound("enemies/incisor/hit_3.ogg");
	precache_sound("enemies/incisor/hit_4.ogg");
	precache_sound("enemies/incisor/inc_idle.ogg");
	precache_sound("enemies/incisor/miss1.ogg");
	precache_sound("enemies/incisor/miss2.ogg");
	precache_sound("enemies/incisor/miss3.ogg");
	precache_sound("enemies/incisor/pain1.ogg");
	precache_sound("enemies/incisor/pain2.ogg");
	precache_sound("enemies/incisor/pain3.ogg");
	precache_sound("enemies/incisor/run.ogg");
	precache_sound("enemies/incisor/sight1.ogg");
	precache_sound("enemies/incisor/sight2.ogg");
	precache_sound("enemies/incisor/sight3.ogg");
	precache_sound("enemies/incisor/step1.ogg");
	precache_sound("enemies/incisor/step2.ogg");
	precache_sound("enemies/incisor/step3.ogg");
	precache_model("models/enemies/widow/widow.md3");
	precache_model("models/enemies/incisor/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/incisor/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/incisor/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/incisor/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/incisor/gibs/gib_head.md3");
	precache_model("models/enemies/incisor/gibs/gib_leg_r_a.md3");
	precache_model("models/enemies/incisor/gibs/gib_leg_r_b.md3");
	precache_model("models/enemies/incisor/gibs/gib_leg_l_a.md3");
	precache_model("models/enemies/incisor/gibs/gib_leg_l_b.md3");
};
void() monster_incisor = 
{
	precache_sound("enemies/incisor/attack1.ogg");
	precache_sound("enemies/incisor/attack2.ogg");
	precache_sound("enemies/incisor/attack3.ogg");
	precache_sound("enemies/incisor/die1.ogg");
	precache_sound("enemies/incisor/die2.ogg");
	precache_sound("enemies/incisor/die3.ogg");
	precache_sound("enemies/incisor/hit_1.ogg");
	precache_sound("enemies/incisor/hit_2.ogg");
	precache_sound("enemies/incisor/hit_3.ogg");
	precache_sound("enemies/incisor/hit_4.ogg");
	precache_sound("enemies/incisor/inc_idle.ogg");
	precache_sound("enemies/incisor/miss1.ogg");
	precache_sound("enemies/incisor/miss2.ogg");
	precache_sound("enemies/incisor/miss3.ogg");
	precache_sound("enemies/incisor/pain1.ogg");
	precache_sound("enemies/incisor/pain2.ogg");
	precache_sound("enemies/incisor/pain3.ogg");
	precache_sound("enemies/incisor/run.ogg");
	precache_sound("enemies/incisor/sight1.ogg");
	precache_sound("enemies/incisor/sight2.ogg");
	precache_sound("enemies/incisor/sight3.ogg");
	precache_sound("enemies/incisor/step1.ogg");
	precache_sound("enemies/incisor/step2.ogg");
	precache_sound("enemies/incisor/step3.ogg");
	precache_model("models/enemies/widow/widow.md3");
	precache_model("models/enemies/incisor/gibs/gib_arm_r_a.md3");
	precache_model("models/enemies/incisor/gibs/gib_arm_r_b.md3");
	precache_model("models/enemies/incisor/gibs/gib_arm_l_a.md3");
	precache_model("models/enemies/incisor/gibs/gib_arm_l_b.md3");
	precache_model("models/enemies/incisor/gibs/gib_head.md3");
	precache_model("models/enemies/incisor/gibs/gib_leg_r_a.md3");
	precache_model("models/enemies/incisor/gibs/gib_leg_r_b.md3");
	precache_model("models/enemies/incisor/gibs/gib_leg_l_a.md3");
	precache_model("models/enemies/incisor/gibs/gib_leg_l_b.md3");

	if (deathmatch)
	{
		remove(self);
		return;
	}
	self.onlymelee =  1;
	
	entity alphamodifier =  spawn();
	alphamodifier.owner = self;
	alphamodifier.think = alpha_modifier;
	alphamodifier.nextthink = time;

	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/widow/widow.md3");
	self.bbvv = incisorbbox;
	setsize(self, incisornbbox * 1.5, incisorbbox * 1.5);
	self.exec_push = 8;
	local float r;
	r = (random() *3);
	if (r < 3)
		self.noise = "enemies/incisor/sight3.ogg";	
	if (r < 2)
		self.noise = "enemies/incisor/sight2.ogg";	
	if (r < 1)
		self.noise = "enemies/incisor/sight1.ogg";	
	self.health = incisorhealth;
	self.touch = incisor_touch;
	self.scale = 1.5;
	self.alpha = 1;
	self.classname = "monster_incisor";
	self.max_health = incisorhealth;
	self.view_ofs_z = 60;
	self.stepheight_delta = 8;
	self.th_stand = incisor_stand1;
	self.th_walk = incisor_walk1;
	self.th_run = incisor_run1;
	self.th_melee = incisor_atk;
	self.th_pain = incisor_pain;
	self.th_die = incisor_die;
	walkmonster_start();
};

////////////////end of qc file