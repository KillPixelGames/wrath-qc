/*
==============================================================================

wretch

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
$frame wre_idle1 wre_idle2 wre_idle3 wre_idle4 wre_idle5 wre_idle6 wre_idle7 wre_idle8 wre_idle9 wre_idle10 wre_idle11 wre_idle12 wre_idle13 wre_idle14 wre_idle15 wre_idle16 wre_idle17 wre_idle18 wre_idle19 wre_idle20
$frame wre_warp1 wre_warp2 wre_warp3 wre_warp4 wre_warp5 wre_warp6 wre_warp7 wre_warp8 wre_warp9 wre_warp10
$frame wre_run1 wre_run2 wre_run3 wre_run4 wre_run5 wre_run6 wre_run7 wre_run8
$frame wre_attack1 wre_attack2 wre_attack3 wre_attack4 wre_attack5 wre_attack6 wre_attack7 wre_attack8 
$frame wre_attack9 wre_attack10 
$frame wre_attack11
$frame wre_attackb1 wre_attackb2 wre_attackb3 wre_attackb4 wre_attackb5 wre_attackb6 wre_attackb7 wre_attackb8 
$frame wre_attackb9 wre_attackb10 
$frame wre_attackb11
$frame wre_meleea1 wre_meleea2 wre_meleea3 wre_meleea4 wre_meleea5 wre_meleea6 wre_meleea7 wre_meleea8 
$frame wre_meleeb1 wre_meleeb2 wre_meleeb3 wre_meleeb4 wre_meleeb5 wre_meleeb6 wre_meleeb7 wre_meleeb8 
$frame wre_paina1 wre_paina2 wre_paina3 wre_paina4 wre_paina5
$frame wre_painb1 wre_painb2 wre_painb3 wre_painb4 wre_painb5
$frame wre_painc1 wre_painc2 wre_painc3 wre_painc4 wre_painc5
$frame wre_deatha1 wre_deatha2 wre_deatha3 wre_deatha4 wre_deatha5 wre_deatha6 wre_deatha7 wre_deatha8 wre_deatha9 wre_deatha10
$frame wre_deathb1 wre_deathb2 wre_deathb3 wre_deathb4 wre_deathb5 wre_deathb6 wre_deathb7 wre_deathb8 wre_deathb9 wre_deathb10
$frame wre_deathc1 wre_deathc2 wre_deathc3 wre_deathc4 wre_deathc5 wre_deathc6 wre_deathc7 wre_deathc8 wre_deathc9 wre_deathc10
$frame wre_deathd1 wre_deathd2 wre_deathd3 wre_deathd4 wre_deathd5 wre_deathd6 wre_deathd7 wre_deathd8 wre_deathd9 wre_deathd10
.float runing_time;

/////////////////////////////////////////////////////////////////////////////////////////////
void() wretch_stand1 =[$wre_idle1, wretch_stand2]{ai_stand();};
void() wretch_stand2 =[$wre_idle2, wretch_stand3]{ai_stand();};
void() wretch_stand3 =[$wre_idle3, wretch_stand4]{ai_stand();};
void() wretch_stand4 =[$wre_idle4, wretch_stand5]{ai_stand();};
void() wretch_stand5 =[$wre_idle5, wretch_stand6]{ai_stand();};
void() wretch_stand6 =[$wre_idle6, wretch_stand7]{ai_stand();};
void() wretch_stand7 =[$wre_idle7, wretch_stand8]{ai_stand();};
void() wretch_stand8 =[$wre_idle8, wretch_stand9]{ai_stand();};
void() wretch_stand9 =[$wre_idle9, wretch_stand10]{ai_stand();};
void() wretch_stand10 =[$wre_idle10, wretch_stand11]{ai_stand();};
void() wretch_stand11 =[$wre_idle11, wretch_stand12]{ai_stand();};
void() wretch_stand12 =[$wre_idle12, wretch_stand13]{ai_stand();};
void() wretch_stand13 =[$wre_idle13, wretch_stand14]{ai_stand();};
void() wretch_stand14 =[$wre_idle14, wretch_stand15]{ai_stand();};
void() wretch_stand15 =[$wre_idle15, wretch_stand16]{ai_stand();};
void() wretch_stand16 =[$wre_idle16, wretch_stand17]{ai_stand();};
void() wretch_stand17 =[$wre_idle17, wretch_stand18]{ai_stand();};
void() wretch_stand18 =[$wre_idle18, wretch_stand19]{ai_stand();};
void() wretch_stand19 =[$wre_idle19, wretch_stand20]{ai_stand();};
void() wretch_stand20 =[$wre_idle20, wretch_stand1]{ai_stand();
};

void()wretch_attacka1;
void() wretch_waiting1 =[$wre_idle1, wretch_waiting1]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}if((!(self.enemy)) && (self.goalentity))self.enemy = self.goalentity;

	if ((self.friendly_monster == 1) && (self.enemy.classname == "player")) 
		next_enemy();
	if(!self.enemy)
		next_enemy();

};
void() wretch_waiting2 =[$wre_idle2, wretch_waiting2]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting3 =[$wre_idle3, wretch_waiting3]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting4 =[$wre_idle4, wretch_waiting4]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting5 =[$wre_idle5, wretch_waiting5]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting6 =[$wre_idle6, wretch_waiting6]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting7 =[$wre_idle7, wretch_waiting7]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting8 =[$wre_idle8, wretch_waiting8]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting9 =[$wre_idle9, wretch_waiting9]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting10 =[$wre_idle10, wretch_waiting10]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}if((!(self.enemy)) && (self.goalentity))self.enemy = self.goalentity;

if((!self.enemy.health) || (!self.enemy)) next_enemy();
	if ((self.friendly_monster == 1) && (self.enemy.classname == "player")) 
		next_enemy();
	if(!self.enemy)
		next_enemy();
};
void() wretch_waiting11 =[$wre_idle11, wretch_waiting11]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting12 =[$wre_idle12, wretch_waiting12]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting13 =[$wre_idle13, wretch_waiting13]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting14 =[$wre_idle14, wretch_waiting14]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting15 =[$wre_idle15, wretch_waiting15]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting16 =[$wre_idle16, wretch_waiting16]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting17 =[$wre_idle17, wretch_waiting17]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting18 =[$wre_idle18, wretch_waiting18]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting19 =[$wre_idle19, wretch_waiting19]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};
void() wretch_waiting20 =[$wre_idle20, wretch_waiting1]{ai_face();if (visible(self.enemy)){self.think = wretch_attacka1;self.nextthink = time + 0.1;}};



/////////////////////////////////////////////////////////////////////////////////////////////
void() wretch_walk1 =[$wre_run1, wretch_walk2]{ai_walk(wretch_ws);};
void() wretch_walk2 =[$wre_run2, wretch_walk3]{ai_walk(wretch_ws);};
void() wretch_walk3 =[$wre_run3, wretch_walk4]{ai_walk(wretch_ws);monstersound2("enemies/wretch/step", 5, CHAN_AUTO);};
void() wretch_walk4 =[$wre_run4, wretch_walk5]{ai_walk(wretch_ws);};
void() wretch_walk5 =[$wre_run5, wretch_walk6]{ai_walk(wretch_ws);};
void() wretch_walk6 =[$wre_run6, wretch_walk7]{ai_walk(wretch_ws);};
void() wretch_walk7 =[$wre_run7, wretch_walk8]{ai_walk(wretch_ws);monstersound2("enemies/wretch/step", 5, CHAN_AUTO);};
void() wretch_walk8 =[$wre_run8, wretch_walk1]{ai_walk(wretch_ws);};

/////////////////////////////////////////////////////////////////////////////////////////////
//void() wretch_preattack;
//void() wretch_spreattack;
void() wretch_attacka1;
void() wretch_attackb1;
void() wretch_attacka9;
void() wretch_attackb9;
void()  wretch_melee1;
.float skip_attacka;
.float skip_attackb;
void() wretch_run1 =[$wre_run1, wretch_run2]{ai_runwalk(wretch_rs);
	self.glowmod = '0.5 0.5 0.5';
	if (self.zigzaging == 0)
	{
		local float r;
		r = random() *100;
		if (wretch_zzc  >= r)
		{
			float zzmultiplier = random(wretch_zzmd,wretch_zzd) * crandom3();
			self.zigzagdeviance = zzmultiplier;
			self.zigzaging = 1;
		}
	}
	else
		self.zigzaging = 0;
		
	//if(visible(self.enemy)) 	
	//	self.zigzaging = 0;
		
};
void() wretch_run2 =[$wre_run2, wretch_run3]{ai_runwalk(wretch_rs);
	if (visible(self.enemy)) 
	{
		enemy_range = range(self.enemy);
		if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID) && (!self.skip_attacka))
		{
			local float rp;
			rp = random() *100;
			if(wretch_rth >= rp)
			self.think = wretch_attacka1;
		}	
		if(enemy_range == RANGE_MELEE)
			self.think = wretch_melee1;
		self.skip_attacka = 1;
		self.nextthink = time + 0.1;
		return;
	}
};
void() wretch_run3 =[$wre_run3, wretch_run4]{ai_runwalk(wretch_rs);monstersound2("enemies/wretch/step", 5, CHAN_AUTO);};
void() wretch_run4 =[$wre_run4, wretch_run5]{ai_runwalk(wretch_rs);};
void() wretch_run5 =[$wre_run5, wretch_run6]{ai_runwalk(wretch_rs);self.glowmod = '0.5 0.5 0.5';};
void() wretch_run6 =[$wre_run6, wretch_run7]{ai_runwalk(wretch_rs);
	if (visible(self.enemy))
	{
		enemy_range = range(self.enemy);
		if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID) && (!self.skip_attackb))
		{
			local float rp;
			rp = random() *100;
			if(wretch_rth >= rp)
			self.think = wretch_attackb1;
		}	
		if(enemy_range == RANGE_MELEE)
			self.think = wretch_melee1;
		self.skip_attackb = 1;
		self.nextthink = time + 0.1;
		return;
	}
};
void() wretch_run7 =[$wre_run7, wretch_run8]{ai_runwalk(wretch_rs);monstersound2("enemies/wretch/step", 5, CHAN_AUTO);};
void() wretch_run8 =[$wre_run8, wretch_run1]{ai_runwalk(wretch_rs);
self.skip_attacka = 0;
self.skip_attackb = 0;
};


/////////////////////////////////////////////////////////////////////////////////////////////projectile attack
void() proj_wretch_explo = 
{
	

if(self.movetype != 0)
{
	sound(self, CHAN_WEAPON, "misc/null.wav", 1, 1);
	randomsound2("enemies/wretch/proj_impact", 3, 1, CHAN_WEAPON, 0, 0.25);
	setmodel(self, "models/projectiles/proj_wretch_explo.md3");
	pointparticles(particleeffectnum("proj_wretch_impact"), self.origin, '0 0 0', 1);
	self.movetype = 0;
	self.frame  = 0;
	self.solid = 0;
	self.alpha = 1;
	self.touch = SUB_Null;
}
self.alpha -= 0.1;
	self.frame += 1;
	if (self.alpha < 0)
		self.think = SUB_Remove;
	else
		self.think = proj_wretch_explo;
	self.nextthink = time + 0.05;
}
void() projectile_touch_wre = 
{
	local float damg;
	if (other == self.owner)
		return;
	if(other.solid == SOLID_TRIGGER)
	return;
	self.solid = SOLID_NOT;
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	damg = wretch_ad;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}

	self.nextthink = time;
	self.think = proj_wretch_explo;
};
.float magnetized;
void()proj_wretch_explo_think =
{
	if(self.frame < 3)
	self.frame ++;
	
	if(self.enemy.health < 0)
	self.lifetime = 0;
	if(skill >= 3)
	{
	
		if((vlen (self.origin - self.enemy.origin) > 128) && (self.magnetized == 1))
		{
			local vector	dir, vtemp;
			vtemp = self.enemy.origin + '0 0 10';
			dir = normalize(vtemp - self.origin);	
			self.velocity =dir *(wretch_projvel);
			self.angles= vectoangles(dir);
		}
		else
		self.magnetized = 0;	
	}
	if(self.origin ==  self.oldorigin)
	{
		self.think = proj_wretch_explo;
	}
	else
	{
		if(self.lifetime < time)
			self.think = proj_wretch_explo;
		else
			self.think = proj_wretch_explo_think;
	}
	self.oldorigin = self.origin;
	self.nextthink = time + 0.05;
};	


void(vector org, vector dir, entity ownerproj) launch_projectile_wre = 
{
	local entity shotgun_proj;
	monstersound3("enemies/wretch/fire", 5, CHAN_AUTO);	
	shotgun_proj = spawn();
	
//	if(random() > 0.5)
//	shotgun_proj.magnetized = 1;
	shotgun_proj.owner = ownerproj;
	shotgun_proj.movetype = MOVETYPE_FLYMISSILE;
	shotgun_proj.wrathflags += FL_PROJECTILE;
	shotgun_proj.solid = SOLID_TRIGGER;
	shotgun_proj.scale = 1;
	shotgun_proj.angles = vectoangles(dir);
	shotgun_proj.touch = projectile_touch_wre;
	shotgun_proj.classname = "projectile";
	shotgun_proj.lifetime  = time + 7.5;
	shotgun_proj.enemy = ownerproj.enemy;
	shotgun_proj.traileffectnum = particleeffectnum("proj_wretch_trail");
	local entity oself;oself = self;self = shotgun_proj;
	//void(entity e, float chan, string samp, float vol, float atten, float speed, float flags) sound7 = 
	sound7(self, CHAN_WEAPON, "enemies/wraith/proj_loop", 1, 0.25, 80 + random() *30, 0);
	self = oself;
	setmodel(shotgun_proj, "models/projectiles/proj_wretch.md3");
	setsize(shotgun_proj, '0 0 0', '0 0 0');
	makevectors(self.angles);
	//org -=v_forward*order ;
	setorigin(shotgun_proj, org);
	shotgun_proj.velocity = dir *(wretch_projvel);

	shotgun_proj.oldvelocity = shotgun_proj.velocity;
	shotgun_proj.think = proj_wretch_explo_think;
	shotgun_proj.nextthink = time + 0.1;
};
.vector enemy_predictionold;
.vector enemy_prediction;
.entity oldposition;
void() wretch_attack = 
{
	local vector dir, tagorg;
	local float tagindex;
	//playersound2("weapons/shotgun/fire2empty_", 2, CHAN_AUTO);
	ai_face();
	tagindex = gettagindex(self, "tag_proj");
	tagorg = gettaginfo(self, tagindex);
	dir = aim(self, 1000);
	local vector sre;
	sre = self.angles;
	makevectors2(sre);
//	if(test_ia == 1)
//	dir = normalize(self.oldposition.origin - tagorg);
//	else
	dir = normalize(self.enemy.origin - tagorg);
	launch_projectile_wre(tagorg, dir, self);
};


void() wretch_attacka1 =[$wre_attack1, wretch_attacka2]{ai_face();self.glowmod = '0.6 0.6 0.6';	monstersound2("enemies/wretch/step", 5, CHAN_AUTO);sound(self, CHAN_AUTO, "enemies/wretch/preattack.ogg", 1,/*80 + random() *30100*/ 0.25);};
void() wretch_attacka2 =[$wre_attack2, wretch_attacka3]{ai_face();self.glowmod = '0.7 0.7 0.7';};
void() wretch_attacka3 =[$wre_attack3, wretch_attacka4]
{
	ai_face();self.glowmod = '0.8 0.8 0.8';
};
void() wretch_attacka4 =[$wre_attack4, wretch_attacka5]{ai_face();self.glowmod = '0.9 0.9 0.9';};
void() wretch_attacka5 =[$wre_attack5, wretch_attacka6]
{
	ai_face();self.glowmod = '1 1 1';
};
void() wretch_attacka6 =[$wre_attack6, wretch_attacka7]
{
	ai_face();
	if(test_ia == 1)
		self.enemy_prediction = self.oldposition.origin;
	wretch_attack();
	self.glowmod = '0.9 0.9 0.9';
};
void() wretch_attacka7 =[$wre_attack7, wretch_attacka8]{ai_face();self.glowmod = '0.8 0.8 0.8';};
void() wretch_attacka8 =[$wre_attack8, wretch_attacka11]
{	
	ai_face();

	float enemy_is_visible = visible(self.enemy);
	if ((self.friendly_monster == 1) && (self.turret))
	{
		if(!self.enemy)
			next_enemy();
		else
		{
			if(!enemy_is_visible)
				next_enemy();
			else
			{
			if((self.enemy.classname == "player") && (self.player_temp_enemy < time)) 
				next_enemy();
			}	
		}		
	}	
	self.nextthink = time + 0.1;
	self.glowmod = '0.7 0.7 0.7';
	if(!self.turret)
	{
		local float rp;
		rp = random() *100;
		if (enemy_is_visible && (wretch_ath >= rp) )
			self.think = wretch_attacka9;
	}
	else
	{
		if (enemy_is_visible)
			self.think = wretch_attacka9;
		else
			self.think = wretch_waiting1;	
	}
};
void() wretch_attacka9 =[$wre_attack9, wretch_attacka10]{ai_face();self.glowmod = '0.8 0.8 0.8';};
void() wretch_attacka10 =[$wre_attack10, wretch_attacka6]{ai_face();self.glowmod = '0.9 0.9 0.9';};
void() wretch_attacka11 =[$wre_attack11, wretch_run5]{ai_face();ai_runwalk(wretch_rs /2);self.glowmod = '0.6 0.6 0.6';

};

void() wretch_attackb1 =[$wre_attackb1, wretch_attackb2]{ai_face();self.glowmod = '0.6 0.6 0.6';monstersound2("enemies/wretch/step", 5, CHAN_AUTO);sound(self, CHAN_AUTO, "enemies/wretch/preattack.ogg", 1, 0.25/*80 + random() *30100, 0*/);};
void() wretch_attackb2 =[$wre_attackb2, wretch_attackb3]{ai_face();self.glowmod = '0.7 0.7 0.7';};
void() wretch_attackb3 =[$wre_attackb3, wretch_attackb4]{ai_face();self.glowmod = '0.8 0.8 0.8';};
void() wretch_attackb4 =[$wre_attackb4, wretch_attackb5]{ai_face();self.glowmod = '0.9 0.9 0.9';};
void() wretch_attackb5 =[$wre_attackb5, wretch_attackb6]
{	
	ai_face();
	self.glowmod = '1 1 1';
};
void() wretch_attackb6 =[$wre_attackb6, wretch_attackb7]
{
	ai_face();
	if(test_ia == 1)
		self.enemy_prediction = self.oldposition.origin;
	wretch_attack();self.glowmod = '0.9 0.9 0.9';
};
void() wretch_attackb7 =[$wre_attackb7, wretch_attackb8]{ai_face();self.glowmod = '0.8 0.8 0.8';};
void() wretch_attackb8 =[$wre_attackb8, wretch_attackb11]{ai_face();

	self.nextthink = time + 0.1;
	self.glowmod = '0.7 0.7 0.7';
	float enemy_is_visible = visible(self.enemy);
	if ((self.friendly_monster == 1)&& (self.turret))
	{
		if(!self.enemy)
		{
			next_enemy();
		}
		else
		{
			if(!enemy_is_visible)
			{	
				next_enemy();
			}
			else
			{
			if((self.enemy.classname == "player") && (self.player_temp_enemy < time)) 
				next_enemy();
			}	
		}		
	}	
		

	if(!self.turret)
	{
		local float rp;
		rp = random() *100;
		if (enemy_is_visible && (wretch_ath >= rp) )
			self.think = wretch_attackb9;
	}
	else
	{
	if (enemy_is_visible)
		self.think = wretch_attackb9;
	else
		self.think = wretch_waiting1;	
	}

};
void() wretch_attackb9 =[$wre_attackb9, wretch_attackb10]{ai_face();	self.glowmod = '0.8 0.8 0.8';};
void() wretch_attackb10 =[$wre_attackb10, wretch_attackb6]{ai_face();self.glowmod = '0.9 0.9 0.9';};
void() wretch_attackb11 =[$wre_attackb11, wretch_run1]{ai_face();ai_runwalk(wretch_rs /2);	self.glowmod = '0.6 0.6 0.6';



};

void() wretch_melee_attack = 
{
	local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);
	if (dist > 120)
	{
		//chattersound("enemies/widow/miss", 3, 1);
		return;
	}
	else
	{
		//	chattersound("enemies/widow/hit_", 4, 1);
		T_Damage(self.enemy, self, self, wretch_sad);
	}
};


void() wretch_meleeb1;
void() wretch_melee1=[$wre_meleea1, wretch_melee2]{ai_face();};
void() wretch_melee2=[$wre_meleea2, wretch_melee3]{ai_face();};
void() wretch_melee3=[$wre_meleea3, wretch_melee4]{ai_face();randomsound2("enemies/wretch/melee", 3, 1, CHAN_WEAPON, 0, 0.25);};
void() wretch_melee4=[$wre_meleea4, wretch_melee5]{ai_face();};
void() wretch_melee5=[$wre_meleea5, wretch_melee6]{ai_face();wretch_melee_attack();};
void() wretch_melee6=[$wre_meleea6, wretch_melee7]{ai_face();};
void() wretch_melee7=[$wre_meleea7, wretch_melee8]{ai_face();};
void() wretch_melee8=[$wre_meleea8, wretch_run1]{ai_face();
	if (visible(self.enemy)&& (self.enemy.health > 0)  && (self.enemy != world))
	{
		enemy_range = range(self.enemy);
		if(enemy_range == RANGE_MELEE)
			self.think = wretch_meleeb1;
		self.nextthink = time + 0.1;
		return;
	}
};

void() wretch_meleeb1=[$wre_meleeb1, wretch_meleeb2]{ai_face();};
void() wretch_meleeb2=[$wre_meleeb2, wretch_meleeb3]{ai_face();};
void() wretch_meleeb3=[$wre_meleeb3, wretch_meleeb4]{ai_face();randomsound2("enemies/wretch/melee", 3, 1, CHAN_WEAPON, 0, 0.25);};
void() wretch_meleeb4=[$wre_meleeb4, wretch_meleeb5]{ai_face();};
void() wretch_meleeb5=[$wre_meleeb5, wretch_meleeb6]{ai_face();wretch_melee_attack();};
void() wretch_meleeb6=[$wre_meleeb6, wretch_meleeb7]{ai_face();};
void() wretch_meleeb7=[$wre_meleeb7, wretch_meleeb8]{ai_face();};
void() wretch_meleeb8=[$wre_meleeb8, wretch_run1]{ai_face();
	if (visible(self.enemy) && (self.enemy.health > 0) && (self.enemy != world))
	{
		enemy_range = range(self.enemy);
		if(enemy_range == RANGE_MELEE)
			self.think = wretch_melee1;
		self.nextthink = time + 0.1;
		return;
	}
};


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////melee attack
/*
void(float wdmg) wretch_melee_attack = 
{
	local vector delta;
	local float dist;
	if (!self.enemy)
		return;	// removed before stroke
	delta = self.enemy.origin - self.origin;
	dist = vlen(delta);
	if (dist > wretch_near)
	{
		return;
	}
	else
	{
		T_Damage(self.enemy, self, self, wdmg);
	}
};

void() wretch_sattack = 
{
	ai_face();
	self.gravity = 1;
	self.movetype = MOVETYPE_STEP;
	self.frame = $wre_satk1;
	self.runing_time = time + wretch_rt;
	enemy_range = range(self.enemy);
	wretch_melee_attack(wretch_sad);
	//self.glowmod = ' 1 0 0';
	if (enemy_range == RANGE_MELEE)
		self.think = wretch_spreattack;
	else
		self.think = wretch_run1;
	self.nextthink = time + wretch_sat;
};
*/

.float painframe;
void() wretch_postpain =
{ 
	self.frame ++; 
	self.painframe ++; 
	if (self.painframe == 5) 
	{
		enemy_range = range(self.enemy);
		if (visible(self.enemy) )
		{
			if (enemy_range == RANGE_MELEE)
			{
				self.think = wretch_melee1;
				self.nextthink = time + 0.1;
				return;
			}
			if ((enemy_range == RANGE_NEAR) || (enemy_range == RANGE_MID))
			{
				local float rp;
				rp = random() *100;	
				if (wretch_rth >= rp)
					self.think = wretch_attackb1;
				else
					self.think = wretch_run1;
				self.nextthink = time + 0.1;
				return;
			}
		}
		else
		{
			self.think = wretch_run1;
			self.nextthink = time + 0.1;
			return;
		}
	}
	self.think = wretch_postpain;
	self.nextthink = time + 0.1;	
};


/////////////////////////////////////////////////////////////////////////////////////////////
void(entity enemy, float dmg) wretch_paina1 = 
{ 
	if(enemy.weapon != IT_BOIL)
	{
	local float rp;
	rp = random() *100;	
	if (wretch_rtp <= rp)
		return;
	}
	self.glowmod = '0.5 0.5 0.5';
	self.painframe = 1;
	float r = random();
	if(r < 1)
	self.frame = $wre_paina1;
	if(r < 0.65)
	self.frame = $wre_painb1;
	if(r < 0.33)
	self.frame = $wre_painc1;
	ai_pain(4);
	monstersound4("enemies/wretch/pain", 5, CHAN_VOICE);
	self.think = wretch_postpain;
	self.sustained_damage = 0;
	self.nextthink = time + 0.1;
};

///////////////////////////////////////////////////////////////////////////////////////////

void() spining_head_attack = 
{
	local vector tagorg, tagdest,dir;
	tagorg = tag_origin("tag_proj", self);
	tagdest = tag_origin("tag_dest", self);

	dir = aim(self, 1000);
	local vector sre;
	sre = self.angles;
	makevectors2(sre);
	dir = normalize(tagdest - tagorg);
	
	launch_projectile_wre(tagorg, dir, self);
};

void() wrethc_explode_head =
{
	self.alpha = -1;
	decal_monster_gib(self.origin + '0 0 12');
	local vector tagorg;
	tagorg = tag_origin("tag_explo", self);
	msound(self, CHAN_BODY, "enemies/wretch/explode.ogg", 1, 0.1);
	pointparticles(particleeffectnum("wretch_bloodshower"), tagorg , '0 0 0', 1);
	self.classname = "spining_head_explosion";
	T_SplashDamageMonster(self, wretch_explo_damage, wretch_explo_damage_player, world, wretch_explo_radius, wretch_pushfactor);
	explo_blood(11, tagorg);
	explo_blood(9, tagorg);	
	pointparticles(particleeffectnum("wretch_explo"), tagorg, '0 0 0', 1);		
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib10, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib11, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib12, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib13, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib14, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib15, self), 0, 3);	// relvel: forward, right, up
	self.think = SUB_Remove;
	self.nextthink = time;
};
.float shotingtime;

void()wretch_postspining_head =
{

	if((self.flags & FL_ONGROUND) && (self.movetype == MOVETYPE_BOUNCE))
	{
		self.flags -= FL_ONGROUND;
		self.movetype = MOVETYPE_FLY;
		self.origin_z +=2;
		self.velocity = '0 0 0';
	}

	//if(time > self.timefly) && (self.movetype == MOVETYPE_FLY)
	self.frame = 1;
	self.avelocity_y = wretch_shv;
	spining_head_attack();
	
	if((self.count != 1) && ((self.lifetime - time) <= 1))
	{
	msound(self, CHAN_BODY, "enemies/wretch/overload.ogg", 1, 0.25);
	self.count = 1;
	}
	
	if(time > self.lifetime)
		self.think = wrethc_explode_head;
	else
		self.think = wretch_postspining_head;
	self.nextthink = time + 1/wretch_shsps;	
};

void()wretch_spining_head =
{

	if((self.flags & FL_ONGROUND) && (self.movetype == MOVETYPE_BOUNCE))
	{
		self.flags -= FL_ONGROUND;
		self.movetype = MOVETYPE_FLY;
		self.origin_z +=2;
		self.velocity = '0 0 0';
	}

	self.avelocity_y = wretch_shvb;
	spining_head_attack();
	if(self.time2 <= time)
	{
	self.health = 10;
	self.th_die = wrethc_explode_head;
	setsize (self, wretch_shbboxn,wretch_shbbox);
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_YES;
	self.think = wretch_postspining_head;
	}
	else
	self.think = wretch_spining_head;
	self.nextthink = time + 1/wretch_shsps;	
};

.float wretch_gibbing;

void() wretch_gibdead =
{
	self.alpha = -1;
	decal_monster_gib(self.origin + '0 0 12');
	local vector tagorg;
	tagorg = tag_origin("tag_arm1_r", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/wretch/gibs/gib_arm1_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib1, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm1_l", self);explo_blood(20, tagorg);
	ThrowGib3(self, "models/enemies/wretch/gibs/gib_arm1_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib2, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm2_r", self);
	ThrowGib3(self, "models/enemies/wretch/gibs/gib_arm2_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib3, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_arm2_l", self);
	ThrowGib3(self, "models/enemies/wretch/gibs/gib_arm2_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib4, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_head", self);
	if(self.wretch_gibbing != 1)
	{
	local float rp;
	rp = random() *100;
	if (wretch_rtsh <= rp)
		ThrowGib3(self, "models/enemies/wretch/gibs/gib_head.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib5, self), 1, 3);	// relvel: forward, right, up
	else
		ThrowGib3(self, "models/enemies/wretch/gibs/gib_head_spin.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib22, self), 1, 4);	// relvel: forward, right, up
	}
	tagorg = tag_origin("tag_head", self);
	pointparticles(particleeffectnum("wretch_bloodshower"), tagorg , '0 0 0', 1);
	explo_blood(2, tagorg);	
	explo_blood(9, tagorg);	
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib16, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_small.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib17, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib18, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_med.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib19, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib20, self), 0, 3);	// relvel: forward, right, up
	ThrowGib3(self, "models/gibs/gib_large.md3", 0, 0.75, 1, 2, tagorg, relvel(wre_gib21, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_leg1_r", self);explo_blood(2, tagorg);
	ThrowGib3(self, "models/enemies/wretch/gibs/gib_leg1_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib6, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_leg1_l", self);explo_blood(2, tagorg);
	ThrowGib3(self, "models/enemies/wretch/gibs/gib_leg1_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib7, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_leg2_r", self);
	ThrowGib3(self, "models/enemies/wretch/gibs/gib_leg2_r.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib8, self), 0, 3);	// relvel: forward, right, up
	tagorg = tag_origin("tag_leg2_l", self);
	ThrowGib3(self, "models/enemies/wretch/gibs/gib_leg2_l.md3", self.health *0.25, 0.75, 1, 1, tagorg, relvel(wre_gib9, self), 0, 3);	// relvel: forward, right, up
	remove(self);
}

void() wretch_postdie =
{ 
	self.frame ++; 
	self.painframe ++; 
	if(self.wretch_gibbing == 1)
	{
		spining_head_attack();
		self.glowmod_x += 0.1;
		self.glowmod_y += 0.1;
		self.glowmod_z += 0.1;
	}
	else	
	{
		self.glowmod_x -= 0.1;
		self.glowmod_y -= 0.1;
		self.glowmod_z -= 0.1;
		if(self.glowmod_z == 0)
		self.glowmod = '-1 -1 -1';
	}
	
	if((self.frame == $wre_deatha4) || (self.frame == $wre_deathb5) || (self.frame == $wre_deathc5) || (self.frame == $wre_deathd10))
	decal_monster(self.origin + '0 0 12');
	
	
	if(self.painframe == 10)
	{
		if(self.wretch_gibbing == 1)
		{
			T_SplashDamageMonster(self, wretch_explo_damage, wretch_explo_damage_player, world, wretch_explo_radius, wretch_pushfactor);
			local vector tagorg;
			tagorg = tag_origin("tag_explo", self);
			explo_blood(10, tagorg);
			msound(self, CHAN_BODY, "enemies/wretch/explode.ogg", 1, 0.1);
			pointparticles(particleeffectnum("wretch_explo"), tagorg, '0 0 0', 1);		
			wretch_gibdead ();
		}
		self.think = SUB_Null;
	}	
	else
		self.think = wretch_postdie;
	self.nextthink = time + 0.1;

};	
void() wretch_diea1 = 
{
	

	self.solid = SOLID_NOT;
	self.solid = 0;
	self.takedamage = 0;
	self.flags = 0;
	self.movetype = 0;
	self.th_stand = null;
	self.th_walk = null;
	self.th_run = null;
	self.th_missile = null;
	self.th_melee = null;
	self.th_pain = nullpain;
	//drop_item(self.origin + '0 0 0', "shells_inv", 4, self);
	self.painframe = 1;
	self.glowmod = '0.5 0.5 0.5';
	if(self.health < wretch_dtg )
	{
	//	local vector tagorg;
	//	tagorg = tag_origin("tag_explo", self);
	//	explo_blood(10, tagorg);	
		self.think = wretch_gibdead;
		self.nextthink = time + 0.1;
		return;
	}
	float r = random();
	if(r < 1)
		self.frame = $wre_deatha1;
	if(r < 0.7)
		self.frame = $wre_deathb1;
	if(r < 0.4)
		self.frame = $wre_deathc1;
	if(r < 0.10)
	{
		msound(self, CHAN_BODY, "enemies/wretch/overload.ogg", 1, 0.25);
		self.wretch_gibbing = 1;
		self.frame = $wre_deathd1;
	}	
	if(r >= 0.25)
	monstersound4("enemies/wretch/die", 5, CHAN_VOICE);

	self.think = wretch_postdie;
	self.nextthink = time + 0.1;
};

///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_wretch (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() precache_monster_wretch = 
{
	
	precache_model ("particles/explo/explo_wretch.md3");
	precache_model ("particles/explo/explo_wretch_head.md3");
	precache_model("models/enemies/wretch/wretch.md3");
	precache_model ("models/projectiles/proj_wretch.md3");
	precache_model ("models/projectiles/proj_wretch_explo.md3");
	precache_sound("enemies/wretch/die1.ogg");
	precache_sound("enemies/wretch/die2.ogg");
	precache_sound("enemies/wretch/die3.ogg");
	precache_sound("enemies/wretch/die4.ogg");
	precache_sound("enemies/wretch/die5.ogg");
	precache_sound("enemies/wretch/explode.ogg");
	precache_sound("enemies/wretch/fire1.ogg");
	precache_sound("enemies/wretch/fire2.ogg");
	precache_sound("enemies/wretch/fire3.ogg");
	precache_sound("enemies/wretch/fire4.ogg");
	precache_sound("enemies/wretch/fire5.ogg");
	precache_sound("enemies/wretch/melee1.ogg");
	precache_sound("enemies/wretch/melee2.ogg");
	precache_sound("enemies/wretch/melee3.ogg");
	precache_sound("enemies/wretch/overload.ogg");
	precache_sound("enemies/wretch/pain1.ogg");
	precache_sound("enemies/wretch/pain2.ogg");
	precache_sound("enemies/wretch/pain3.ogg");
	precache_sound("enemies/wretch/pain4.ogg");
	precache_sound("enemies/wretch/pain5.ogg");	
	precache_sound("enemies/wretch/proj_impact1.ogg");
	precache_sound("enemies/wretch/proj_impact2.ogg");
	precache_sound("enemies/wretch/proj_impact3.ogg");
	precache_sound("enemies/wretch/proj_loop.wav");
	precache_sound("enemies/wretch/preattack.ogg");
	precache_sound("enemies/wretch/sight1.ogg");
	precache_sound("enemies/wretch/sight2.ogg");
	precache_sound("enemies/wretch/sight3.ogg");
	precache_sound("enemies/wretch/step1.ogg");
	precache_sound("enemies/wretch/step2.ogg");
	precache_sound("enemies/wretch/step3.ogg");
	precache_sound("enemies/wretch/step4.ogg");
	precache_sound("enemies/wretch/step5.ogg");
	precache_model("models/enemies/wretch/gibs/gib_arm1_l.md3");
	precache_model("models/enemies/wretch/gibs/gib_arm1_r.md3");
	precache_model("models/enemies/wretch/gibs/gib_arm2_l.md3");
	precache_model("models/enemies/wretch/gibs/gib_arm2_r.md3");
	precache_model("models/enemies/wretch/gibs/gib_leg1_l.md3");
	precache_model("models/enemies/wretch/gibs/gib_leg1_r.md3");
	precache_model("models/enemies/wretch/gibs/gib_leg2_l.md3");
	precache_model("models/enemies/wretch/gibs/gib_leg2_r.md3");
	precache_model("models/enemies/wretch/gibs/gib_head_spin.md3");
	precache_model("models/enemies/wretch/gibs/gib_head.md3");
	

};

void() monster_wretch = 
{
	precache_model("models/enemies/wretch/wretch.md3");
	if (deathmatch)
	{
		remove(self);
		return;
	}

	if (self.waypointed != 1)
		self.waypointed = 0;
	self.solid = SOLID_SLIDEBOX;
	local float r;
	r = (random() *3);
	if (r <= 3)
		self.noise = "enemies/wretch/sight3.ogg";
	if (r < 2)
		self.noise = "enemies/wretch/sight2.ogg";
	if (r < 1)
		self.noise = "enemies/wretch/sight1.ogg";
	self.movetype = MOVETYPE_STEP;
	setmodel(self, "models/enemies/wretch/wretch.md3");
	setsize(self, wretch_bbox *-0.5, wretch_bbox *0.5);
	self.health = wretch_health;
	self.damagetopain = wretch_dtp;
	self.classname = "monster_wretch";
	self.th_stand = wretch_stand1;
	self.th_walk = wretch_walk1;
	self.yaw_speed =30;	
	self.glowmod = '0.5 0.5 0.5';
	if (!self.turret)
		self.th_run = wretch_run1;
	else
		self.th_run = wretch_attacka1;
	self.turretable = 1;
	self.th_missile = wretch_attacka1;
	self.th_melee = wretch_melee1;
	self.th_pain = wretch_paina1;
	self.th_die = wretch_diea1;
	walkmonster_start();
};

////////////////end of qc file
