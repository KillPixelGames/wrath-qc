/*
==============================================================================

dummy

==============================================================================
*/

/*
1. health
2. walk speed
3. walk think % chance to attack, else keep walking
4. run speed
5. run time
6. attack damage
7. attack time
8. attack type (melee or projectile)
9. pre-attack time
10. damage needed to pain
11. pain time
12. pain think % chance to attack or walk
13. bbox
*/

$frame pose0

$frame idle1

$frame run1

$frame walk1

$frame patk1

$frame atk1

$frame paina1

$frame death1

	.float runing_time;
void() setsizemonster2 = 
{
	local vector rbbox, nrbbox;
	rbbox_x = dummybbox_x / 2;
	rbbox_y = dummybbox_y / 2;
	rbbox_z = dummybbox_z / 2;
	nrbbox_x = dummybbox_x / -2;
	nrbbox_y = dummybbox_y / -2;
	nrbbox_z = dummybbox_z / -2;
	setsize(self, nrbbox, rbbox);
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() dummy_stand1 =[$idle1, dummy_stand1]
{
	local float r;
	r = random() *100;

	if (dummywth <= r)
		ai_stand();
	self.colormod = ' 0 1 0';
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() dummy_walk1 =[$walk1, dummy_walk1]
{
	ai_walk(dummyws);
	self.colormod = ' 1.25 1 1';
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() dummy_preattack;
void() dummy_run1 =[$run1, dummy_run1]
{
	ai_runwalk(dummyrs);
	self.colormod = ' 1 1 1';

	if (dummyattp == 1)
	{
		if ((visible2(self.enemy, 64, 0.3)) && (self.runing_time < time))
		{
			ai_face();
			self.think = dummy_preattack;
		}
	}
	else
	{
		if (self.runing_time < time)
		{
			ai_face();
			self.think = dummy_preattack;
		}
	}

	self.nextthink = time + 0.1;
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() projectile_touch = 
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

	damg = dummyad;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}

	self.touch = SUB_Null;
	self.nextthink = time;
	self.think = slag_explode1;
};

void(float wdmg) dummy_melee_attack = 
{
	local vector delta;
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

void(entity e) missileattack = 
{
	e.effects = EF_MUZZLEFLASH;
	local entity projectile;
	projectile = spawn();
	projectile.owner = e;
	setmodel(projectile, "models/projectiles/proj_slag1.md3");
	projectile.origin = self.origin;
	projectile.solid = SOLID_CORPSE;
	projectile.movetype = MOVETYPE_FLYMISSILE;
	projectile.velocity = normalize(e.enemy.origin - self.origin);
	projectile.velocity = projectile.velocity * 1200;
	projectile.angles = vectoangles(projectile.velocity);
	projectile.touch = projectile_touch;
};

void() dummy_attack = 
{
	self.frame = $atk1;
	self.think = dummy_run1;
	self.runing_time = time + dummyrt;
	ai_face();
	dummy_melee_attack(dummyad);
	self.colormod = ' 1 0 0';
	self.nextthink = time + dummyat;
};

void() dummy_attack2 = 
{
	self.frame = $atk1;
	self.think = dummy_run1;
	self.runing_time = time + dummyrt;
	self.colormod = ' 1 0 0';
	ai_face();
	missileattack(self);
	self.nextthink = time + dummyat;
};

void() dummy_preattack = 
{
	self.colormod = ' 0 0 1';
	self.frame = $patk1;
	if (dummyattp == 1)
		self.think = dummy_attack;
	else
	{
		self.think = dummy_attack2;
		ai_face();
	}

	self.nextthink = time + dummypat;
};

/////////////////////////////////////////////////////////////////////////////////////////////
void(entity enemy, float dmg) dummy_paina1 = 
{
	self.frame = $paina1;
	ai_pain(4);

	local float r;
	r = random() *100;
	if (dummypth <= r)
		self.think = dummy_run1;
	else
		self.think = dummy_preattack;

	self.pain_finished = time + dummypt;
	self.nextthink = time + dummypt;
};

///////////////////////////////////////////////////////////////////////////////////////////
void() dummy_diea1 = 
{
	remove(self);
};

///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_dummy (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() monster_dummy = 
{
	precache_model("models/enemies/dummy/dummy.md3");
	if (deathmatch)
	{
		remove(self);
		return;
	}

	if (self.waypointed != 1)
		self.waypointed = 0;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/dummy/dummy.md3");
	setsize(self, dummybbox *-0.5, dummybbox *0.5);
	self.health = dummyhealth;
	self.classname = "dummy";
	self.th_stand = dummy_stand1;
	self.th_walk = dummy_walk1;
	self.th_run = dummy_run1;
	self.th_missile = dummy_preattack;
	self.th_melee = dummy_preattack;
	self.th_pain = dummy_paina1;
	self.th_die = dummy_diea1;
	walkmonster_start();
};

////////////////end of qc file