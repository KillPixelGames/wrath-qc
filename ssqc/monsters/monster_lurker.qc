$frame lurker_swim1

$frame lurker_preattack1

$frame lurker_charge1

$frame lurker_attack1 lurker_attack2 lurker_attack3 lurker_attack4 lurker_attack5 lurker_attack6 
$frame lurker_attack7 lurker_attack8 lurker_attack9 lurker_attack10 

$frame lurker_pain1 

$frame lurker_death1 

void() swimmonster_start;
.float spinning_time;
.float infront_time;

.float dot_y;
.float framecount;
void() lurker_attack1;
.float upfloat;
.float time_float;
void(float vel, float facing) ai_swim_charge =
{
	local vector vec;
	local vector yaw;
	if((time < self.time_float) && (self.velocity_z == 0))
	{
		if(self.upfloat == 1)
		{
			self.upfloat = 0;
			self.velocity -= '0 0 4';	
		}
		else
		{
			self.upfloat = 1;
			self.velocity += '0 0 4';		
		}
		self.time_float = time + 3;
	}

	if(facing == 1)
	{
	vec = self.enemy.origin - self.origin;
	yaw = vectoyaw(vec);
	self.angles_y = yaw_y; 
	}
	self.avelocity = '0 0 0';
	self.lastplace_spoted = self.enemy.origin - rorigin(self);
	self.velocity = normalize (self.lastplace_spoted) * vel * 12;
	if(self.funcwaterlevel < 3)
	self.velocity_z = 0;
};

.float search_time;
void(float vel, float facing, float walking) ai_swim = 
{


	if((time < self.time_float) && (self.velocity_z == 0))
	{
		if(self.upfloat == 1)
		{
			self.upfloat = 0;
			self.velocity -= '0 0 4';	
		}
		else
		{
			self.upfloat = 1;
			self.velocity += '0 0 4';		
		}
		self.time_float = time + 3;
	}


	float enemy_is_visible = visible(self.enemy);
	if ((!enemy_is_visible) && (self.search_time < time))
	{
	self.enemy = 0;
	self.think = self.th_stand;
	self.nextthink = time + 0.1;
	return;
	}

	float disttoplayer  =  vlen (self.enemy.origin - self.origin);
	if((enemy_is_visible ) )
	{
		self.lastplace_spoted = self.enemy.origin - rorigin(self);
		self.search_time =  time + random (3,7);
	}

	if(walking ==  1)
	self.lastplace_spoted = self.goalentity.origin- rorigin(self);


	makevectors2 (self.angles);

	if(self.angles_y < 0)
	self.angles_y = 0;

	if(self.angles_y < 360)
	float normalized_angles = floor (self.angles_y);
	else
	normalized_angles  = floor (self.angles_y % 360);


	float view_angles_atenemy = (vectoyaw (self.enemy.origin - rorigin(self)));
	if(walking ==  1)
	view_angles_atenemy = (vectoyaw (self.goalentity.origin - rorigin(self)));
		
	float rotate_y = max(normalized_angles,view_angles_atenemy) - min(normalized_angles,view_angles_atenemy);
	if(facing == 1)
	rotate_y = 180;
	self.avelocity = '0 0 0';



	if(view_angles_atenemy > normalized_angles)
	{
		if((view_angles_atenemy >= 270) && (normalized_angles < 90))
			self.avelocity_y = rotate_y * -1;
		else		
			self.avelocity_y = rotate_y * 1;
	}
	else
	{
		if((view_angles_atenemy <= 90) && (normalized_angles > 270))
			self.avelocity_y = rotate_y * 1;
		else		
			self.avelocity_y = rotate_y * -1;
	}
	


//	string viewxanglesfactor = strcat ( ftos(self.funcwaterlevel),  (" waterlevel\n"));
//	bprint (viewxanglesfactor);

	self.velocity = normalize (self.lastplace_spoted) * vel * 12;

	if((self.funcwaterlevel < 3) && (self.liquidtouch_timing > time))
	{
		if((self.funcwaterlevel == 2))
			self.velocity_z = -10;
		else
			self.velocity_z = -120;

		if(self.surfacing_sound_time < time)
		{
		vector wsorg = self.origin + '0 0 45';
		pointparticles(particleeffectnum("water_splash"), wsorg, 0, 1);

		monstersound3("player/water_surfacing", 3, CHAN_AUTO);	
		self.surfacing_sound_time = time + random(0.5,3);
		}
	}
	self.angles_x = 0;	


};

void(float dist) ai_swim_walk = 
{
	


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

	if (self.friendly_monster == 1 && vlen(self.origin - self.goalentity.origin) < 80)
	{
		self.pausetime = time + 1.5;
		self.th_stand();
	}
	if(self.enemy != world)
	self.th_run();
	ai_swim(dist,0,1);
};





void()lurker_preattack1;
void()lurker_attack1;
void() lurker_stand1  =[$lurker_swim1, lurker_stand1] {


	
	if(time < self.time_float)
	{
		if(self.upfloat == 1)
		{
			self.upfloat = 0;
			self.velocity -= '0 0 4';	
		}
		else
		{
			self.upfloat = 1;
			self.velocity += '0 0 4';		
		}
		self.time_float = time + 3;
	}


ai_stand();


	float r = random();

	if(r < 0.03)
	{	
		if ((self.idle_time < time) && !(self.spawnflags &1))
		{
			chattersound("enemies/lurker/idle", 3, 0.5);
			self.idle_time = time + random(5,10);
		}
	}
};


void() lurker_walk1  =[$lurker_swim1, lurker_walk1] {ai_swim_walk(8);};



void() lurker_charge = [$lurker_charge1, lurker_charge] 
{
	float r = random();
	if (r < 0.25)	
		ai_swim (25,1,0);
	else
		ai_swim (25,0,0);

	if(self.framecount == 0)
	{
		if(self.zigzaging == 1)
			self.zigzaging  = 0;
		else
			self.zigzaging  = 1;
	}

	self.framecount ++;

	if(self.framecount >= 8)
	{
		float disttoplayer  =  vlen (self.enemy.origin - self.origin);
		self.framecount = 0;	
		if((disttoplayer < 92) &&  visible(self.enemy))
			self.think = lurker_attack1;
		else
			self.think = lurker_charge;
	}

};



void() lurker_preattack =
{

	if (random() < 0.05)
	sound (self, CHAN_VOICE, "enemies/lurker/sight1.ogg", 1, ATTN_NORM);
	self.frame = $lurker_preattack1;
	self.framecount = 0;
	self.think = lurker_preattack1;
	self.nextthink = time;
};
void() lurker_preattack1  =[       $lurker_preattack1, lurker_preattack1] 
{
	float disttoplayer  =  vlen (self.enemy.origin - self.origin);
	ai_swim (12,1,0);
	self.framecount ++;
	if(self.framecount >= 10)
	{
	self.framecount = 0;	
	if((disttoplayer < 92) &&  visible(self.enemy))
		self.think = lurker_attack1;
	else
		self.think = lurker_charge;
	}
};


void() lurker_melee =
{
	local vector	delta;
	local float 	ldmg;
	if (!self.enemy)
		return;		// removed before stroke
	delta = self.enemy.origin - self.origin;
	if (vlen(delta) > 120)
		return;
	ldmg = random(15,22);
	T_Damage (self.enemy, self, self, ldmg);
};

void() lurker_attack1        =[      $lurker_attack1,       lurker_attack2 ] {ai_swim_charge(10,0);monstersound3("enemies/lurker/attack", 3, CHAN_AUTO);};
void() lurker_attack2        =[      $lurker_attack2,       lurker_attack3 ] {ai_swim_charge(10,1);};
void() lurker_attack3        =[      $lurker_attack3,       lurker_attack4 ] {lurker_melee();ai_swim_charge(10,1);
	
};
void() lurker_attack4        =[      $lurker_attack4,       lurker_attack5 ] {ai_swim_charge(10,1);};
void() lurker_attack5        =[      $lurker_attack5,       lurker_attack6 ] {lurker_melee();ai_swim_charge(10,1);};
void() lurker_attack6        =[      $lurker_attack6,       lurker_attack7 ] {ai_swim_charge(10,1);};
void() lurker_attack7        =[      $lurker_attack7,       lurker_attack8 ] {lurker_melee();};
void() lurker_attack8        =[      $lurker_attack8,       lurker_attack9 ] {ai_swim_charge(10,1);};
void() lurker_attack9        =[      $lurker_attack9,       lurker_attack10 ] {ai_swim_charge(10,1);};
void() lurker_attack10        =[      $lurker_attack10,       lurker_preattack ] {ai_swim_charge(10,0);};


void() lurker_death_gib  =
{
	self.alpha = -1;
	decal_monster_gib(self.origin + '0 0 12');
	local vector tagorg;
	tagorg = tag_origin("tag_arm_a_r", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_arm_a_r.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 120 100', self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_b_r", self);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_arm_b_r.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 120 80', self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_a_l", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_arm_a_l.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -120 10', self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm_b_l", self);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_arm_b_l.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -120 90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_head_a", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_head_a.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -100 90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_head_b", self);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_head_b.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -0 -90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_head_c", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_head_c.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 40 90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_tail_a", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_tail_a.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 40 90', self), 0, 3);	// relvel: forward, right, up	remove(self);
	tagorg = tag_origin("tag_tail_b", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/lurker/gibs/gib_tail_b.md3", self.health *0.25, 0.0125, 1, 1, tagorg, relvel('120 -40 -90', self), 0, 3);	// relvel: forward, right, up	remove(self);
};

void() lurker_death1 =[      $lurker_death1,        lurker_death2        ] 
{
    self.avelocity = '0 0 0';
	self.velocity = '0 0 12';


	monstersound3("enemies/lurker/die", 3, CHAN_AUTO);	
};

void() lurker_death2 =[      $lurker_death1,        lurker_death2        ] 
{
	self.solid = SOLID_TRIGGER;
	if((self.funcwaterlevel < 3) && (self.liquidtouch_timing > time))
	{
		if((self.funcwaterlevel == 2))
			self.velocity_z = 0;
		else
			self.velocity_z = -120;
	}

};	// gb, become nonsolid faster

void()lurker_death = 
{
	
    self.velocity = '0 0 0';
	if (self.health < -50)
		self.think = lurker_death_gib;
	else
		self.think = lurker_death1;
	self.nextthink = time;
};

void() lurker_pain1  =[      $lurker_pain1, lurker_pain2 ] { 

if(self.liquidtouch_timing > time)
{
	ai_pain(7);
	self.velocity = ' 0 0 0'; 
}

if(time < self.time_float)
{
	if(self.upfloat == 1)
	{
		self.upfloat = 0;
		self.velocity -= '0 0 4';	
	}
	else
	{
		self.upfloat = 1;
		self.velocity += '0 0 4';		
	}
	self.time_float = time + 3;
}

	self.avelocity = ' 0 0 0';
monstersound3("enemies/lurker/pain", 3, CHAN_AUTO);};
void() lurker_pain2  =[      $lurker_pain1, lurker_pain3 ] {

if(self.liquidtouch_timing > time)
	ai_pain(7);

};
void() lurker_pain3  =[      $lurker_pain1, lurker_pain4 ] {};
void() lurker_pain4  =[      $lurker_pain1, lurker_pain5 ] {};
void() lurker_pain5  =[      $lurker_pain1, lurker_pain6 ] {};
void() lurker_pain6  =[      $lurker_pain1, lurker_pain7 ] {};
void() lurker_pain7  =[      $lurker_pain1, lurker_pain8 ] {};
void() lurker_pain8  =[      $lurker_pain1, lurker_pain9 ] {};
void() lurker_pain9  =[      $lurker_pain1, lurker_pain10 ] {};
void() lurker_pain10  =[      $lurker_pain1, lurker_preattack ] {};

void(entity lurker_attacker, float damage)	lurker_pain =
{
	// lurker allways do pain frames

	if(self.pain_finished > time)
	return;
	lurker_pain1 ();
	if(self.liquidtouch_timing < time)
	self.pain_finished = time + 1;
	else
	self.pain_finished = time + 1 + random();
};

void()precache_monster_lurker =
{
	precache_sound ("enemies/lurker/attack1.ogg");
	precache_sound ("enemies/lurker/attack2.ogg");
	precache_sound ("enemies/lurker/attack3.ogg");
	precache_sound ("enemies/lurker/die1.ogg");
	precache_sound ("enemies/lurker/die2.ogg");
	precache_sound ("enemies/lurker/die3.ogg");
	precache_sound ("enemies/lurker/idle1.ogg");
	precache_sound ("enemies/lurker/idle2.ogg");
	precache_sound ("enemies/lurker/idle3.ogg");
	precache_sound ("enemies/lurker/pain1.ogg");
	precache_sound ("enemies/lurker/pain2.ogg");
	precache_sound ("enemies/lurker/pain3.ogg");
	precache_sound ("enemies/lurker/sight1.ogg");
	precache_sound ("enemies/lurker/sight2.ogg");
	precache_sound ("enemies/lurker/sight3.ogg");
	precache_model ("models/enemies/lurker.md3");
	precache_model ("models/enemies/lurker/gibs/gib_arm_a_l.md3");
	precache_model ("models/enemies/lurker/gibs/gib_arm_a_r.md3");
	precache_model ("models/enemies/lurker/gibs/gib_arm_b_l.md3");
	precache_model ("models/enemies/lurker/gibs/gib_arm_b_r.md3");
	precache_model ("models/enemies/lurker/gibs/gib_head_a.md3");
	precache_model ("models/enemies/lurker/gibs/gib_head_b.md3");
	precache_model ("models/enemies/lurker/gibs/gib_head_c.md3");
	precache_model ("models/enemies/lurker/gibs/gib_tail_a.md3");
	precache_model ("models/enemies/lurker/gibs/gib_tail_b.md3");
	precache_model ("models/artifacts/effects/life_siphon_lurker.md3");
};
void() water_checker_think =
{
	if((self.owner.liquidtouch_timing < time) && (self.owner.movetype == MOVETYPE_FLY))
	{
		self.owner.velocity = '0 0 -320';
		self.owner.movetype = MOVETYPE_TOSS;
		self.owner.angles_z = 90;	
		setsize(self.owner, heretic_bbox *-0.25, heretic_bbox *0.25);
	}
	if((self.owner.liquidtouch_timing > time) && (self.owner.movetype == MOVETYPE_TOSS))
	{
		if(self.owner.angles_z == 90)
		{
			self.owner.velocity = '0 0 0';
			self.owner.movetype = MOVETYPE_FLY;
			self.owner.angles_z = 0;	
			setsize(self.owner, heretic_bbox *-0.5, heretic_bbox *0.5);
		}
		
	}

	if(self.owner.movetype == MOVETYPE_TOSS)
		T_Damage (self.owner, world, world, 1);

	self.think = water_checker_think;
	self.nextthink = time + 0.1;
};
/*QUAKED monster_lurker (1 0 0) (-16 -16 -24) (16 16 24) Ambush*/
void() monster_lurker =
{
	if (deathmatch)
	{
		remove(self);
		return;
	}
	


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	self.wrathflags += FL_SWIMMER;
	self.classname = "monster_lurker";
	setmodel(self, "models/enemies/lurker/lurker.md3");
	setsize(self, heretic_bbox *-0.5, heretic_bbox *0.5);

	//gnounc
	self.noise = "lurker/idle.wav";
	self.zigzagdeviance = 128;
	self.health = 250;
	local float r;
	r = (random() *3);
	if (r <= 3)
		self.noise = "enemies/lurker/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/lurker/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/lurker/sight1.ogg";

	self.th_stand = lurker_stand1;
	self.th_walk = lurker_walk1;
	self.th_run = lurker_preattack;
	self.th_die = lurker_death;
	self.th_pain = lurker_pain;
	self.th_melee = lurker_attack1;
	entity water_checker = spawn();
	water_checker.owner = self;
	water_checker.think = water_checker_think;
	water_checker.nextthink = time;
	swimmonster_start ();
};

