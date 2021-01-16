$frame pose0

$frame idle1 idle2 idle3 idle4 idle5 idle6 idle7 idle8 idle9 idle10

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10

$frame attacka1 attacka2

$frame attackb1 attackb2 attackb3 attackb4 attackb5 attackb6 attackb7 attackb8 attackb9 attackb10
$frame attackb11 attackb12 attackb13 attackb14 attackb15 attackb16 attackb17 attackb18 attackb19 attackb20
$frame attackb21 attackb22 attackb23 attackb24 attackb25 attackb26 attackb27

$frame paina1 paina2 paina3 paina4 paina5 paina6 paina7 paina8
$frame paina9 paina10

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8
$frame painb9 painb10

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame deatha1 deatha2 deatha3 deatha4 deatha5 deatha6 deatha7 deatha8
$frame deatha9 deatha10

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9 deathb10

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10

$frame deathd1 deathd2 deathd3 deathd4 deathd5 deathd6 deathd7 deathd8
$frame deathd9 deathd10

$frame deathe1 deathe2 deathe3 deathe4 deathe5 deathe6 deathe7 deathe8 deathe9 deathe10

//Transitions

$frame walktoattack1 walktoattack2 walktoattack3 walktoattack4 walktoattack5 walktoattack6 walktoattack7 walktoattack8 walktoattack9 walktoattack10
$frame walktoattack11 walktoattack12

$frame attacktowalk1 attacktowalk2 attacktowalk3 attacktowalk4 attacktowalk5 attacktowalk6 attacktowalk7 attacktowalk8
$frame attacktowalk9 attacktowalk10

$frame atktatk1 atktatk2 atktatk3 atktatk4 atktatk5 atktatk6

$frame reloadtowalk1 reloadtowalk2 reloadtowalk3 reloadtowalk4 reloadtowalk5 reloadtowalk6 reloadtowalk7 reloadtowalk8 reloadtowalk9 reloadtowalk10
$frame reloadtowalk11 reloadtowalk12 reloadtowalk13 reloadtowalk14 reloadtowalk15

$frame reloadtoattack1 reloadtoattack2 reloadtoattack3 reloadtoattack4 reloadtoattack5

	/*
	==============================================================================
	SOLDIER CODE
	==============================================================================
	*/
	.float paintype;
.float deathnumber;

void() mercenary_fire;
void() mercenary_attack;
/*
==============================================================================
MERCENARY IDLE
==============================================================================
*/
void() mercenary_stun;

void() mercenary_idle1 =[$idle1, mercenary_idle2]
{
	ai_stand();
	self.paintype = 1;
	self.deathnumber = 5;

};
void() mercenary_idle2 =[$idle2, mercenary_idle3]
{
	ai_stand();
};
void() mercenary_idle3 =[$idle3, mercenary_idle4]
{
	ai_stand();
};
void() mercenary_idle4 =[$idle4, mercenary_idle5]
{
	ai_stand();
};
void() mercenary_idle5 =[$idle5, mercenary_idle6]
{
	ai_stand();
};
void() mercenary_idle6 =[$idle6, mercenary_idle7]
{
	ai_stand();
};
void() mercenary_idle7 =[$idle7, mercenary_idle8]
{
	ai_stand();
};
void() mercenary_idle8 =[$idle8, mercenary_idle9]
{
	ai_stand();
};
void() mercenary_idle9 =[$idle9, mercenary_idle10]
{
	ai_stand();
};
void() mercenary_idle10 =[$idle10, mercenary_idle1]
{
	ai_stand();
};

/*
==============================================================================
MERCENARY WALK
==============================================================================
*/
void() mercenary_walk1 =[$walk1, mercenary_walk2]
{
	//if ((random() < 0.2) && (!(self.spawnflags &1)))
	//	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, 0.25);
	ai_walk(wvel1);
	self.paintype = 2;
	self.deathnumber = 2;
};
void() mercenary_walk2 =[$walk2, mercenary_walk3]
{
	ai_walk(wvel2);
	self.paintype = 1;
	self.deathnumber = 1;
};
void() mercenary_walk3 =[$walk3, mercenary_walk4]
{
	ai_walk(wvel3);
	self.paintype = 2;
	self.deathnumber = 2;
};
void() mercenary_walk4 =[$walk4, mercenary_walk5]
{
	ai_walk(wvel4);
	self.paintype = 1;
	self.deathnumber = 1;
};
void() mercenary_walk5 =[$walk5, mercenary_walk6]
{
	ai_walk(wvel5);
	self.paintype = 2;
	self.deathnumber = 2;
};
void() mercenary_walk6 =[$walk6, mercenary_walk7]
{
	ai_walk(wvel6);
	self.paintype = 1;
	self.deathnumber = 1;
};
void() mercenary_walk7 =[$walk7, mercenary_walk8]
{
	ai_walk(wvel7);
	self.paintype = 2;
	self.deathnumber = 2;
};
void() mercenary_walk8 =[$walk8, mercenary_walk9]
{
	ai_walk(wvel8);
	self.paintype = 1;
	self.deathnumber = 1;
};
void() mercenary_walk9 =[$walk9, mercenary_walk10]
{
	ai_walk(wvel9);
	self.paintype = 2;
	self.deathnumber = 2;
};
void() mercenary_walk10 =[$walk10, mercenary_walk1]
{
	ai_walk(wvel10);
	self.paintype = 1;
	self.deathnumber = 1;
};

/*
==============================================================================
MERCENARY RUN
==============================================================================
*/
void() mercenary_run1 =[$walk1, mercenary_run2]
{
	//if (random() < 0.2)
	//	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, 0.25);
	ai_runwalk(wvel1);
	self.nextthink = time + 0.1;
	ai_face();
};
void() mercenary_run2 =[$walk2, mercenary_run3]
{
	ai_runwalk(wvel2);
	self.paintype = 2;
	self.deathnumber = 2;
	self.nextthink = time + 0.1;
};
void() mercenary_run3 =[$walk3, mercenary_run4]
{
	ai_runwalk(wvel3);
	self.paintype = 1;
	self.deathnumber = 1;
	self.nextthink = time + 0.1;
};
void() mercenary_run4 =[$walk4, mercenary_run5]
{
	ai_runwalk(wvel4);
	self.paintype = 2;
	self.deathnumber = 2;
	self.nextthink = time + 0.1;
};
void() mercenary_run5 =[$walk5, mercenary_run6]
{
	ai_runwalk(wvel5);
	self.paintype = 1;
	self.deathnumber = 1;
	self.nextthink = time + 0.1;
	if (visible2(self.enemy, 768, 0.3))
		self.think = mercenary_walktoattack;
};
void() mercenary_run6 =[$walk6, mercenary_run7]
{
	ai_runwalk(wvel6);
	self.paintype = 2;
	self.deathnumber = 2;
	self.nextthink = time + 0.1;
};
void() mercenary_run7 =[$walk7, mercenary_run8]
{
	ai_runwalk(wvel7);
	self.paintype = 1;
	self.deathnumber = 1;
	self.nextthink = time + 0.1;
};
void() mercenary_run8 =[$walk8, mercenary_run9]
{
	ai_runwalk(wvel8);
	self.paintype = 2;
	self.deathnumber = 2;
	self.nextthink = time + 0.1;
};
void() mercenary_run9 =[$walk9, mercenary_run10]
{
	ai_runwalk(wvel9);
	self.paintype = 1;
	self.deathnumber = 1;
	self.nextthink = time + 0.1;
};
void() mercenary_run10 = 
{
	self.frame = $walk10;
	self.paintype = 1;self.deathnumber = 1;
	ai_runwalk(wvel10);
	if (visible(self.enemy))
		self.think = mercenary_walktoattack;
	else
		self.think = mercenary_run1;
	self.nextthink = time + 0.1;
	self.nextthink = time + 0.1;
};

/*
==============================================================================
MERCENARY ATTACK
==============================================================================
*/
void() mercenary_fire = 
{
	local vector dir;
	local entity en;
	ai_face();
	// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	dir = rorigin(en);
	local float ntag, nparticles;
	local vector shootorg;
	ntag = gettagindex(self, "tag_muzzle");
	shootorg = gettaginfo(self, ntag);
	nparticles = particleeffectnum("mercenary_fire");
	pointparticles(nparticles, shootorg, '0 0 0', 1);
	dir = normalize(dir - (shootorg));
	FireBullets(mercblts, dir, '0.005 0.005 0', mercdamage, 1);
	self.ammo_coachgun -= 1;
	chattersound("sound/enemies/mercenary/attack", 3, 1);
};

void() mercenary_atktatk1 =[$atktatk1, mercenary_atktatk2]
{
	ai_face();
	self.paintype = 3;
	self.deathnumber = 3;
	ai_face();
	self.nextthink = time + 0.1;
};
void() mercenary_atktatk2 =[$atktatk2, mercenary_atktatk3]
{
	ai_face();
	self.nextthink = time + 0.1;
};
void() mercenary_atktatk3 =[$atktatk3, mercenary_atktatk4]
{
	ai_face();
	self.nextthink = time + 0.1;
};
void() mercenary_atktatk4 =[$atktatk4, mercenary_atktatk5]
{
	ai_face();
	self.nextthink = time + 0.1;
};
void() mercenary_atktatk5 =[$atktatk5, mercenary_atktatk6]
{
	ai_face();
	self.nextthink = time + 0.1;
};
void() mercenary_atktatk6 =[$atktatk6, mercenary_attack]
{
	ai_face();
	self.nextthink = time + 0.1;
};
void() mercenary_attack1 =[$attacka1, mercenary_attack2]
{
	ai_face();
	mercenary_fire();
	self.paintype = 3;
	self.deathnumber = 3;
	self.nextthink = time + 0.1;
};
void() mercenary_attack2 =[$attacka2, mercenary_attacktowalk]
{
	ai_face();
	self.paintype = 3;
	self.deathnumber = 3;
	self.nextthink = time + 0.1;
	if (self.health < 30)
		self.think = mercenary_atktatk1;
	else
	{
		if ((visible2(self.enemy, 768, 0.3)))
			self.think = mercenary_atktatk1;
		else
			self.think = mercenary_attacktowalk;
	}

	self.nextthink = time + 0.1;
};

void() mercenary_walktoattack =[$walktoattack1, mercenary_walktoattack2]
{
	ai_runwalk(wta1);
	self.paintype = 1;
	self.deathnumber = 1;
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack2 =[$walktoattack2, mercenary_walktoattack3]
{
	ai_runwalk(wta2);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack3 =[$walktoattack3, mercenary_walktoattack4]
{
	ai_runwalk(wta3);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack4 =[$walktoattack4, mercenary_walktoattack5]
{
	ai_runwalk(wta4);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack5 =[$walktoattack5, mercenary_walktoattack6]
{
	ai_runwalk(wta5);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack6 =[$walktoattack6, mercenary_walktoattack7]
{
	ai_runwalk(wta6);
	self.paintype = 3;
	self.deathnumber = 3;
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack7 =[$walktoattack7, mercenary_walktoattack8]
{
	ai_runwalk(wta7);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack8 =[$walktoattack8, mercenary_walktoattack9]
{
	ai_runwalk(wta8);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack9 =[$walktoattack9, mercenary_walktoattack10]
{
	ai_runwalk(wta9);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack10 =[$walktoattack10, mercenary_walktoattack11]
{
	ai_runwalk(wta10);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack11 =[$walktoattack11, mercenary_walktoattack12]
{
	ai_runwalk(wta11);
	self.nextthink = time + 0.1;
};
void() mercenary_walktoattack12 =[$walktoattack12, mercenary_attack]
{
	ai_runwalk(wta12);
	self.nextthink = time + 0.1;
};

void() mercenary_attacktowalk =[$attacktowalk1, mercenary_attacktowalk2]
{
	self.paintype = 3;
	self.deathnumber = 3;
	ai_runwalk(atw1);
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk2 =[$attacktowalk2, mercenary_attacktowalk3]
{
	ai_runwalk(atw2);
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk3 =[$attacktowalk3, mercenary_attacktowalk4]
{
	ai_runwalk(atw3);
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk4 =[$attacktowalk4, mercenary_attacktowalk5]
{
	ai_runwalk(atw4);
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk5 =[$attacktowalk5, mercenary_attacktowalk6]
{
	ai_runwalk(atw5);
	self.paintype = 2;
	self.deathnumber = 2;
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk6 =[$attacktowalk6, mercenary_attacktowalk7]
{
	ai_runwalk(atw6);
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk7 =[$attacktowalk7, mercenary_attacktowalk8]
{
	ai_runwalk(atw7);
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk8 =[$attacktowalk8, mercenary_attacktowalk9]
{
	ai_runwalk(atw8);
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk9 =[$attacktowalk9, mercenary_attacktowalk10]
{
	ai_runwalk(atw9);
	self.paintype = 1;
	self.deathnumber = 1;
	self.nextthink = time + 0.1;
};
void() mercenary_attacktowalk10 =[$attacktowalk10, mercenary_run1]
{
	ai_runwalk(atw10);
	self.nextthink = time + 0.1;
};

void() mercenary_reloadtowalk =[$reloadtowalk1, mercenary_reloadtowalk2]
{
	self.paintype = 3;
	self.deathnumber = 3;
	ai_runwalk(rtw1);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk2 =[$reloadtowalk2, mercenary_reloadtowalk3]
{
	ai_runwalk(rtw2);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk3 =[$reloadtowalk3, mercenary_reloadtowalk4]
{
	ai_runwalk(rtw3);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk4 =[$reloadtowalk4, mercenary_reloadtowalk5]
{
	ai_runwalk(rtw4);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk5 =[$reloadtowalk5, mercenary_reloadtowalk6]
{
	ai_runwalk(rtw5);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk6 =[$reloadtowalk6, mercenary_reloadtowalk7]
{
	ai_runwalk(rtw6);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk7 =[$reloadtowalk7, mercenary_reloadtowalk8]
{
	ai_runwalk(rtw7);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk8 =[$reloadtowalk8, mercenary_reloadtowalk9]
{
	ai_runwalk(rtw8);
	self.paintype = 2;
	self.deathnumber = 2;
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk9 =[$reloadtowalk9, mercenary_reloadtowalk10]
{
	ai_runwalk(rtw9);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk10 =[$reloadtowalk10, mercenary_reloadtowalk11]
{
	ai_runwalk(rtw10);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk11 =[$reloadtowalk11, mercenary_reloadtowalk12]
{
	ai_runwalk(rtw11);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk12 =[$reloadtowalk12, mercenary_reloadtowalk13]
{
	ai_runwalk(rtw12);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk13 =[$reloadtowalk13, mercenary_reloadtowalk14]
{
	ai_runwalk(rtw13);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk14 =[$reloadtowalk14, mercenary_reloadtowalk15]
{
	ai_runwalk(rtw14);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtowalk15 =[$reloadtowalk15, mercenary_run1]
{
	ai_runwalk(rtw15);
	self.nextthink = time + 0.1;
};

void() mercenary_reloadtoattack =[$reloadtoattack1, mercenary_reloadtoattack2]
{
	self.paintype = 3;
	self.deathnumber = 3;
	ai_runwalk(rta1);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtoattack2 =[$reloadtoattack2, mercenary_reloadtoattack3]
{
	ai_runwalk(rta2);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtoattack3 =[$reloadtoattack3, mercenary_reloadtoattack4]
{
	ai_runwalk(rta3);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtoattack4 =[$reloadtoattack4, mercenary_reloadtoattack5]
{
	ai_runwalk(rta4);
	self.nextthink = time + 0.1;
};
void() mercenary_reloadtoattack5 =[$reloadtoattack5, mercenary_attack]
{
	ai_runwalk(rta5);
	self.nextthink = time + 0.1;
	self.think = mercenary_attack;
};

void() mercenary_attackb =[$attackb1, mercenary_attackb2]
{
	ai_face();
	mercenary_fire();
	self.paintype = 3;
	self.deathnumber = 3;
	self.nextthink = time + 0.1;
};
void() mercenary_attackb2 =[$attackb2, mercenary_attackb3]
{
	ai_face();
	self.nextthink = time + 0.1;
};
void() mercenary_attackb3 =[$attackb3, mercenary_attackb4]
{
	ai_face();
	self.nextthink = time + 0.1;
};
void() mercenary_attackb4 =[$attackb4, mercenary_attackb5]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb5 =[$attackb5, mercenary_attackb6]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb6 =[$attackb6, mercenary_attackb7]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb7 =[$attackb7, mercenary_attackb8]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb8 =[$attackb8, mercenary_attackb9]
{
	ai_face();
	self.deathnumber = 4;
	self.nextthink = time + 0.1;
};
void() mercenary_attackb9 =[$attackb9, mercenary_attackb10]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb10 =[$attackb10, mercenary_attackb11]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb11 =[$attackb11, mercenary_attackb12]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb12 =[$attackb12, mercenary_attackb13]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb13 =[$attackb13, mercenary_attackb14]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb14 =[$attackb14, mercenary_attackb15]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb15 =[$attackb15, mercenary_attackb16]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb16 =[$attackb16, mercenary_attackb17]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb17 =[$attackb17, mercenary_attackb18]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb18 =[$attackb18, mercenary_attackb19]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb19 =[$attackb19, mercenary_attackb20]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb20 =[$attackb20, mercenary_attackb21]
{
	ai_face();
	self.deathnumber = 3;
	self.nextthink = time + 0.1;
};
void() mercenary_attackb21 =[$attackb21, mercenary_attackb22]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb22 =[$attackb22, mercenary_attackb23]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb23 =[$attackb23, mercenary_attackb24]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb24 =[$attackb24, mercenary_attackb25]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb25 =[$attackb25, mercenary_attackb26]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb26 =[$attackb26, mercenary_attackb27]
{
	self.nextthink = time + 0.1;
};
void() mercenary_attackb27 = 
{
	self.frame = $attackb27;
	self.ammo_coachgun = 3;
	if (self.health < 30)
		self.think = mercenary_reloadtoattack;
	else
	{
		local float r;
		r = random();
		if (r < 0.5)
			self.think = mercenary_reloadtoattack;
		else
			self.think = mercenary_reloadtowalk;
	}

	self.nextthink = time + 0.1;
};

void() mercenary_prefire = 
{
	if (self.ammo_coachgun >= 2)
		self.think = mercenary_attack1;
	else
		self.think = mercenary_attackb;
	self.nextthink = time;
};

void() mercenary_attack = 
{
	if (self.enemy.health <= 0)
	{
		self.think = mercenary_idle1;
		self.nextthink = time;
		return;
	}

	if (self.frame == $walk10)
		self.think = mercenary_walktoattack;
	if (self.frame == $walktoattack12)
		self.think = mercenary_prefire;
	if (self.frame == $atktatk6)
		self.think = mercenary_prefire;
	if (self.frame == $reloadtoattack5)
		self.think = mercenary_prefire;
	self.nextthink = time;
};

void() mercenary_painthink = 
{
	if (visible(self.enemy))
	{
		if (self.ammo_coachgun >= 2)
			self.think = mercenary_attack1;
		if (self.ammo_coachgun == 1)
			self.think = mercenary_attackb;
		if (!self.ammo_coachgun)
			self.think = mercenary_reloadtoattack;
	}
	else
		self.think = mercenary_run1;
	self.nextthink = time;
};

void() mercenary_paina1 =[$paina1, mercenary_paina2]
{
	self.nextthink = time + 0.1;
};
void() mercenary_paina2 =[$paina2, mercenary_paina3]
{
	self.nextthink = time + 0.1;
};
void() mercenary_paina3 =[$paina3, mercenary_paina4]
{
	ai_pain(0.5);
	self.nextthink = time + 0.1;
};
void() mercenary_paina4 =[$paina4, mercenary_paina5]
{
	ai_pain(0.5);
	self.nextthink = time + 0.1;
};
void() mercenary_paina5 =[$paina5, mercenary_paina6]
{
	ai_pain(0.5);
	self.nextthink = time + 0.1;
};
void() mercenary_paina6 =[$paina6, mercenary_paina7]
{
	ai_pain(0.5);
	self.nextthink = time + 0.1;
};
void() mercenary_paina7 =[$paina7, mercenary_paina8]
{
	ai_pain(0.5);
	self.nextthink = time + 0.1;
};
void() mercenary_paina8 =[$paina8, mercenary_paina9]
{
	ai_pain(0.5);
	self.nextthink = time + 0.1;
};
void() mercenary_paina9 =[$paina9, mercenary_paina10]
{
	ai_pain(0.5);
	self.nextthink = time + 0.1;
};
void() mercenary_paina10 =[$paina10, mercenary_painthink]
{
	self.nextthink = time + 0.1;
};

void() mercenary_painb1 =[$painb1, mercenary_painb2]
{
	ai_back(2);
	self.nextthink = time + 0.1;
};
void() mercenary_painb2 =[$painb2, mercenary_painb3]
{
	ai_back(2);
	self.nextthink = time + 0.1;
};
void() mercenary_painb3 =[$painb3, mercenary_painb4]
{
	ai_back(1);
	self.nextthink = time + 0.1;
};
void() mercenary_painb4 =[$painb4, mercenary_painb5]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painb5 =[$painb5, mercenary_painb6]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painb6 =[$painb6, mercenary_painb7]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painb7 =[$painb7, mercenary_painb8]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painb8 =[$painb8, mercenary_painb9]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painb9 =[$painb9, mercenary_painb10]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painb10 =[$painb10, mercenary_painthink]
{
	self.nextthink = time + 0.1;
};

void() mercenary_painc1 =[$painc1, mercenary_painc2]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painc2 =[$painc2, mercenary_painc3]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painc3 =[$painc3, mercenary_painc4]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painc4 =[$painc4, mercenary_painc5]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painc5 =[$painc5, mercenary_painc6]
{
	ai_pain(1);
	self.nextthink = time + 0.1;
};
void() mercenary_painc6 =[$painc6, mercenary_painc7]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painc7 =[$painc7, mercenary_painc8]
{
	self.nextthink = time + 0.1;
};
void() mercenary_painc8 =[$painc8, mercenary_painthink]
{
	self.nextthink = time + 0.1;
};

void() mercenary_poststun = 
{
	self.effects = 0;
	self.colormod = '1 1 1';
	self.think = mercenary_run1;
	self.solid = SOLID_SLIDEBOX;
	self.stunned = 0;
	self.nextthink = time;
}

void() mercenary_stun = 
{
	self.frame = $painc1,
	self.effects = 512;
	self.colormod = '1 0.2 0.2';
	self.think = mercenary_poststun;
	self.nextthink = time + 195;
	self.stunned = 1;
	self.health = 1;
}

void() mercenary_pain_think = 
{
	/*
		if((!self.stunned) && (self.health < merchealth)) 
		{
		self.think  = mercenary_stun;
		self.nextthink = time + 0.05;
		return;
		}

	*/
	self.pain_finished = time + 1.2;
	if (self.paintype == 1)
	{
		self.think = mercenary_paina1;
		sound(self, CHAN_VOICE, "enemies/mercenary/pain1.ogg", 1, 0.25);
	}
	else if (self.paintype == 2)
	{
		self.think = mercenary_painb1;
		sound(self, CHAN_VOICE, "enemies/mercenary/pain2.ogg", 1, 0.25);
	}
	else if (self.paintype == 3)
	{
		self.think = mercenary_painc1;
		sound(self, CHAN_VOICE, "enemies/mercenary/pain3.ogg", 1, 0.25);
	}

	self.nextthink = time;
};

void(entity attacker, float damage) mercenary_pain = 
{
	/*
		if (self.pain_finished > time)
			return;
		local float pp, rp;
		if (damage >= mercph)
			pp = hpdmg;
		if ((damage <= mercpm) && (damage > mercpl))
			pp = mpdmg;
		if (damage <= mercpl)
			pp = lpdmg;
		rp = random();
		if (rp > pp)
			return;
	*/
	mercenary_pain_think();
};

void() mercenary_deatha1 =[$deatha1, mercenary_deatha2] {};
void() mercenary_deatha2 =[$deatha2, mercenary_deatha3]
{
	self.solid = SOLID_NOT;
};
void() mercenary_deatha3 =[$deatha3, mercenary_deatha4] {};
void() mercenary_deatha4 =[$deatha4, mercenary_deatha5] {};
void() mercenary_deatha5 =[$deatha5, mercenary_deatha6] {};
void() mercenary_deatha6 =[$deatha6, mercenary_deatha7] {};
void() mercenary_deatha7 =[$deatha7, mercenary_deatha8] {};
void() mercenary_deatha8 =[$deatha8, mercenary_deatha9] {};
void() mercenary_deatha9 =[$deatha9, mercenary_deatha10] {};
void() mercenary_deatha10 =[$deatha10, mercenary_deatha10] {};

void() mercenary_deathb1 =[$deathb1, mercenary_deathb2] {};
void() mercenary_deathb2 =[$deathb2, mercenary_deathb3]
{
	self.solid = SOLID_NOT;
};
void() mercenary_deathb3 =[$deathb3, mercenary_deathb4] {};
void() mercenary_deathb4 =[$deathb4, mercenary_deathb5] {};
void() mercenary_deathb5 =[$deathb5, mercenary_deathb6] {};
void() mercenary_deathb6 =[$deathb6, mercenary_deathb7] {};
void() mercenary_deathb7 =[$deathb7, mercenary_deathb8] {};
void() mercenary_deathb8 =[$deathb8, mercenary_deathb9] {};
void() mercenary_deathb9 =[$deathb9, mercenary_deathb10] {};
void() mercenary_deathb10 =[$deathb10, mercenary_deathb10] {};

void() mercenary_deathc1 =[$deathc1, mercenary_deathc2] {};
void() mercenary_deathc2 =[$deathc2, mercenary_deathc3]
{
	self.solid = SOLID_NOT;
};
void() mercenary_deathc3 =[$deathc3, mercenary_deathc4] {};
void() mercenary_deathc4 =[$deathc4, mercenary_deathc5] {};
void() mercenary_deathc5 =[$deathc5, mercenary_deathc6] {};
void() mercenary_deathc6 =[$deathc6, mercenary_deathc7] {};
void() mercenary_deathc7 =[$deathc7, mercenary_deathc8] {};
void() mercenary_deathc8 =[$deathc8, mercenary_deathc9] {};
void() mercenary_deathc9 =[$deathc9, mercenary_deathc10] {};
void() mercenary_deathc10 =[$deathc10, mercenary_deathc10] {};

void() mercenary_deathd1 =[$deathd1, mercenary_deathd2] {};
void() mercenary_deathd2 =[$deathd2, mercenary_deathd3]
{
	self.solid = SOLID_NOT;
};
void() mercenary_deathd3 =[$deathd3, mercenary_deathd4] {};
void() mercenary_deathd4 =[$deathd4, mercenary_deathd5] {};
void() mercenary_deathd5 =[$deathd5, mercenary_deathd6] {};
void() mercenary_deathd6 =[$deathd6, mercenary_deathd7] {};
void() mercenary_deathd7 =[$deathd7, mercenary_deathd8] {};
void() mercenary_deathd8 =[$deathd8, mercenary_deathd9] {};
void() mercenary_deathd9 =[$deathd9, mercenary_deathd10] {};
void() mercenary_deathd10 =[$deathd10, mercenary_deathd10] {};

void() mercenary_deathe1 =[$deathe1, mercenary_deathe2] {};
void() mercenary_deathe2 =[$deathe2, mercenary_deathe3]
{
	self.solid = SOLID_NOT;
};
void() mercenary_deathe3 =[$deathe3, mercenary_deathe4] {};
void() mercenary_deathe4 =[$deathe4, mercenary_deathe5] {};
void() mercenary_deathe5 =[$deathe5, mercenary_deathe6] {};
void() mercenary_deathe6 =[$deathe6, mercenary_deathe7] {};
void() mercenary_deathe7 =[$deathe7, mercenary_deathe8] {};
void() mercenary_deathe8 =[$deathe8, mercenary_deathe8] {};
void() mercenary_deathe9 =[$deathe9, mercenary_deathe9] {};
void() mercenary_deathe10 =[$deathe10, mercenary_deathe10] {};

void() mercenary_die = 
{
	drop_item(self.origin + '0 0 40', "shell", 3, self);
	// check for gib	
	if ((self.health < mercod) && (self.gibbable))
	{
		chattersound("sound/impact/gibs/gib_explo", 3, 1);
		explo_blood(1, self.origin + '0 0 40');
		pointparticles(particleeffectnum("gib1"), self.origin + '0 0 40', v_forward *(-550), 1);
		remove(self);
		return;
	}

	// regular death
	chattersound("sound/enemies/mercenary/die", 3, 1);
	if (self.deathnumber == 1)
		mercenary_deatha1();
	else if (self.deathnumber == 2)
		mercenary_deathb1();
	else if (self.deathnumber == 3)
		mercenary_deathc1();
	else if (self.deathnumber == 4)
		mercenary_deathd1();
	else if (self.deathnumber == 5)
		mercenary_deathe1();
};

void() monster_mercenary = 
{
	precache_sound("enemies/mercenary/attack1.ogg");
	precache_sound("enemies/mercenary/attack2.ogg");
	precache_sound("enemies/mercenary/attack3.ogg");
	precache_sound("enemies/mercenary/die1.ogg");
	precache_sound("enemies/mercenary/die2.ogg");
	precache_sound("enemies/mercenary/die3.ogg");
	precache_sound("enemies/mercenary/idle1.ogg");
	precache_sound("enemies/mercenary/idle2.ogg");
	precache_sound("enemies/mercenary/idle3.ogg");
	precache_sound("enemies/mercenary/pain1.ogg");
	precache_sound("enemies/mercenary/pain2.ogg");
	precache_sound("enemies/mercenary/pain3.ogg");
	precache_sound("enemies/mercenary/sight1.ogg");
	precache_sound("enemies/mercenary/sight2.ogg");
	precache_sound("enemies/mercenary/sight3.ogg");
	precache_sound("enemies/mercenary/step1.ogg");
	precache_sound("enemies/mercenary/step2.ogg");
	precache_sound("enemies/mercenary/step3.ogg");
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;
	local float r;
	r = floor(random() *3);
	if (r < 1)
		self.noise = "sound/enemies/mercenary/sight1.ogg";	
	if (r < 2)
		self.noise = "sound/enemies/mercenary/sight2.ogg";	
	else
		self.noise = "sound/enemies/mercenary/sight3.ogg";	
	setmodel(self, "models/enemies/mercenary/mercenary.md3");
	self.noise = "soldier/sight1.wav";	
	self.classname = "monster_mercenary";
	self.netname = "Mercenary";
	setsizemonster(self, mercbbox);
	self.ammo_coachgun = 3;
	self.health = merchealth;
	self.max_health = merchealth;
	self.th_stand = mercenary_idle1;
	self.th_walk = mercenary_walk1;
	self.th_run = mercenary_run1;
	self.th_missile = mercenary_attack;
	self.th_pain = mercenary_pain;
	self.th_die = mercenary_die;
	walkmonster_start();
};

////////////////end of qc file