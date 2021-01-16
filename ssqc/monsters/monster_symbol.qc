/*
==============================================================================

symbol

==============================================================================
*/

/*
float symbol_health;
float symbol_wakeupthink;
float symbol_walkspeed;
float symbol_walkthink;
float symbol_runspeed;
float symbol_runthink;
float symbol_runtime;
float symbol_damage;
float symbol_attacktime;
float symbol_attackthink;
float symbol_zzc;
float symbol_zzd;
float symbol_zzmd;
float symbol_paintime;
float symbol_painthink;	 //% roll dice, run or attack
float symbol_painchance;
float symbol_paindamageneeded;
float symbol_far;
float symbol_mid;
float symbol_near;
vector symbol_bbox;
vector symbol_bboxn;
*/

$frame symbol_pose0

$frame symbol_idle1

$frame symbol_warp1 symbol_warp2 symbol_warp3 symbol_warp4 symbol_warp5 symbol_warp6 symbol_warp7 symbol_warp8 symbol_warp9 symbol_warp10

$frame symbol_paina1 symbol_paina2 symbol_paina3 symbol_paina4 symbol_paina5 symbol_paina6 symbol_paina7 symbol_paina8 symbol_paina9 symbol_paina10

$frame symbol_painb1 symbol_painb2 symbol_painb3 symbol_painb4 symbol_painb5 symbol_painb6 symbol_painb7 symbol_painb8 symbol_painb9 symbol_painb10

$frame symbol_painc1 symbol_painc2 symbol_painc3 symbol_painc4 symbol_painc5 symbol_painc6 symbol_painc7 symbol_painc8 symbol_painc9 symbol_painc10


.float runing_time;

/////////////////////////////////////////////////////////////////////////////////////////////
void() symbol_stand1 =[$symbol_idle1, symbol_stand1]
{
	local float r;
	r = random() *100;

	//if (symbolwth <= r)
		ai_stand();
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() symbol_walk1 =[$symbol_idle1, symbol_walk1]
{
	ai_walk(symbol_walkspeed);
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() symbol_missile;

void() symbol_run1 =
{
	self.frame =  $symbol_idle1;

	local float r;
	if(self.gravity <= 0)
	{
		self.movetype = MOVETYPE_STEP;
		self.gravity = 1;
	}
	ai_runwalk(symbol_runspeed);	
	if(time > self.runing_time )
	{
		if(self.zigzaging == 0)
		{
			r = random() * 100;
			if(symbol_zzc >= r)
			{			
					local float zzmultiplier;
					zzmultiplier  = ((symbol_zzd * random()) +symbol_zzmd);
					if(zzmultiplier >symbol_zzd)
					zzmultiplier = symbol_zzd;	
					local float rr = random();
					if(rr > 0.5)
					self.zigzagdeviance = zzmultiplier;
					else
					self.zigzagdeviance = zzmultiplier * -1;
					
					self.zigzaging = 1;
			}
		}	
		else
		self.zigzaging = 0;		

		if((visible(self.enemy)))
		{
			local float rp;
			rp = random() * 100;
			if(symbol_runthink >= rp)
			{	
				enemy_range = range(self.enemy);
				if (enemy_range == RANGE_FAR)
				{
					ai_face();
					self.think = symbol_run1; 
					return;
				}
				else
					self.think = symbol_missile;
			}
		}
		self.runing_time = time + symbol_runtime;
	}
	else
	{
	self.think = symbol_run1;
	}
	self.nextthink = time + 0.1;
};

/////////////////////////////////////////////////////////////////////////////////////////////
void() projectile_symbol_touch = 
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

	damg = symbol_damage;
	if (other.health)
	{
		T_Damage(other, self, self.owner, damg);
	}

	self.touch = SUB_Null;
	self.nextthink = time;
	self.think = slag_explode1;
};

.float symbol_projectiles_total;
.float symbol_projectilea;
.float symbol_projectileb;
.float symbol_projectilec;
.float symbol_projectiled;


void(entity e, string tagname) symbol_missileattack = 
{ 
	e.effects = EF_MUZZLEFLASH;
	local entity projectile;
	projectile = spawn();
	projectile.owner = e;
	setmodel(projectile, "models/projectiles/proj_symbol.md3");

	local vector tagorg;
	tagorg = tag_origin(tagname, e);
	projectile.origin = tagorg;
	projectile.wrathflags += FL_PROJECTILE;

	projectile.solid = SOLID_CORPSE;
	projectile.movetype = MOVETYPE_FLYMISSILE;
	projectile.velocity = normalize(e.enemy.origin - self.origin);
	projectile.velocity = projectile.velocity * 1200;
	projectile.angles = vectoangles(projectile.velocity);
	projectile.touch = projectile_symbol_touch;
};



void() symbol_missile_launch = 
{
	string choosen_tag;
	float r = ceil ( random() * self.symbol_projectiles_total);
	ai_face();

	if(self.symbol_projectiles_total == 4)
	{
		switch(r)
		{
			case 1:
			choosen_tag = "tag_muzzle_a";
			break;
			case 2:
			choosen_tag = "tag_muzzle_b";
			break;
			case 3:
			choosen_tag = "tag_muzzle_c";
			break;
			case 4:
			choosen_tag = "tag_muzzle_d";
			break;
		}
	}
	if(self.symbol_projectiles_total == 3)
	{
		switch(r)
		{
			case 1:
				if(self.symbol_projectilea == 1)
					choosen_tag = "tag_muzzle_a";
				else
					choosen_tag = "tag_muzzle_b";
			break;
			case 2:
				if(self.symbol_projectileb == 1)
					choosen_tag = "tag_muzzle_b";
				else
					choosen_tag = "tag_muzzle_c";

			break;
			case 3:
				if(self.symbol_projectiled == 1)
					choosen_tag = "tag_muzzle_d";
				else
					choosen_tag = "tag_muzzle_c";
			break;
		}
	}
	if(self.symbol_projectiles_total == 2)
	{
		switch(r)
		{
			case 1:
				if(self.symbol_projectilea == 1)
					choosen_tag = "tag_muzzle_a";
				if(self.symbol_projectileb == 1)
					choosen_tag = "tag_muzzle_b";
				if(self.symbol_projectilec == 1)
					choosen_tag = "tag_muzzle_c";

			break;
			case 2:
				if(self.symbol_projectiled == 1)
					choosen_tag = "tag_muzzle_d";
				if(self.symbol_projectilec == 1)
					choosen_tag = "tag_muzzle_c";
				if(self.symbol_projectileb == 1)
					choosen_tag = "tag_muzzle_b";

			break;
		}
	}
	if(self.symbol_projectiles_total == 1)
	{
		if(self.symbol_projectilea == 1)
			choosen_tag = "tag_muzzle_a";
		if(self.symbol_projectileb == 1)
			choosen_tag = "tag_muzzle_b";
		if(self.symbol_projectilec == 1)
			choosen_tag = "tag_muzzle_c";
		if(self.symbol_projectiled == 1)
			choosen_tag = "tag_muzzle_d";
	}


	if (choosen_tag == "tag_muzzle_a")
		self.symbol_projectilea = 0;
	if (choosen_tag == "tag_muzzle_b")
		self.symbol_projectileb = 0;
	if (choosen_tag == "tag_muzzle_c")
		self.symbol_projectilec = 0;
	if (choosen_tag == "tag_muzzle_d")
		self.symbol_projectiled = 0;


	symbol_missileattack(self,choosen_tag);
	self.symbol_projectiles_total --;

	//string message = strcat(choosen_tag,"  ",ftos(r), "\n");
	//bprint (message);

	if(self.symbol_projectiles_total)
	{
		self.think = symbol_missile_launch;
	}
	else
	{
		//bprint ("---------------------------------\n");
		float r2 = random() *100;
		if (symbol_attackthink <= r2)
			self.think = symbol_run1;
		else
			self.think = symbol_missile;
	}
	self.nextthink = time + 0.5;
};

void() symbol_missile = 
{ 
	self.yaw_speed = 50;
	self.frame = $symbol_idle1;

	self.symbol_projectilea = 1;
	self.symbol_projectileb = 1;
	self.symbol_projectilec = 1;
	self.symbol_projectiled = 1;
	self.symbol_projectiles_total = 4;

	self.think = symbol_missile_launch;
	self.runing_time = time + symbol_attacktime;
	ai_face();
	self.nextthink = time + 0.1;
};

/////////////////////////////////////////////////////////////////////////////////////////////


void() symbol_postpain = 
{
	self.painframe ++;
	self.frame ++;
	if(self.painframe >= 10)
	{
		float r = random() *100;
		if (symbol_painthink <= r)
			self.think = symbol_run1;
		else
			self.think = symbol_missile;
	}
	else
	{
		self.think =  symbol_postpain;
	}
	self.nextthink = time + 0.1;
};

void(entity enemy, float dmg) symbol_paina1 = 
{ 

	float ra = random() *100;
	if (symbol_painchance >= ra)
	return;

	float r = random();

	if(r < 0.33)
		self.frame = $symbol_paina1;
	else if(r < 0.66)
		self.frame = $symbol_painb1;
	else 
		self.frame = $symbol_painc1;

	ai_pain(4);
	self.painframe = 1;
	self.pain_finished = time + symbol_paintime;

	self.think =  symbol_postpain;
	self.nextthink = time + 0.1;
};

///////////////////////////////////////////////////////////////////////////////////////////
void() symbol_diea1 = 
{
	remove(self);
};

void() precache_monster_symbol = 
{
precache_model ( "models/projectiles/proj_symbol.md3");
precache_model ( "models/enemies/symbol/symbol.md3");
}
///////////////////////////////////////////////////////////////////////////////////////////

/*WRATHED monster_symbol (1 0 0) (-16 -16 -24) (16 16 40) Ambush*/
.vector bbvv;
void() monster_symbol = 
{
	precache_model("models/enemies/symbol/symbol.md3");
	if (deathmatch)
	{
		remove(self);
		return;
	}

	if (self.waypointed != 1)
		self.waypointed = 0;
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_FLY;
	setmodel(self, "models/enemies/symbol/symbol.md3");
	setsize(self, symbol_bboxn , symbol_bbox);
	self.health = symbol_health;
	self.classname = "symbol";
	self.th_stand = symbol_stand1;
	self.th_walk = symbol_walk1;
	self.th_run = symbol_run1;
	self.th_missile = symbol_missile;
	//self.th_melee = symbol_preattack;
	self.th_pain = symbol_paina1;
	self.th_die = symbol_diea1;
	flymonster_start();
};

////////////////end of qc file