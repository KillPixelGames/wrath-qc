.float trapstate;
.float notouch;
.float speed2;
.float wait2;
.float loop;
.float damagerate;
.float forcecrouch;



void() blade_fire = 
{
vector dir =  (self.pos1 - self.pos2)
//self.velocity = normalize(dir) * self.speed;
self.velocity_z = 128;
};


void() trap_fire;
void() trap_return;

void() trap_wait = 
{ 
	self.state = STATE_TOP;
	self.touch = self.oldtouch;
	activator = self.enemy;
	self.usable = 0;
	self.nextthink = self.ltime + self.wait;
	if(self.classname != "damage_bbox")
	sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);
	self.think = trap_return;
};
void() trap_wait2 = 
{ 
	self.state = STATE_BOTTOM;
	self.touch = self.oldtouch;
	activator = self.enemy;
	self.usable = 0;
	self.nextthink = self.ltime + self.wait2;
	if(self.classname != "damage_bbox")
	sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);
	self.think = trap_fire;
};
void() trap_fire;
void() trap_blocked = 
{ 
	if (other.classname == "monster_fallen")
		other.solid = SOLID_CORPSE;
	if((other.classname == "player") && (self.forcecrouch == 1))
		other.crushingtime = time + 0.1;
	
	if(other.damagerate < time)
	{
		T_Damage(other, self, self, self.dmg);
		other.damagerate = time + self.damagerate;
	}
};


.float kill_player;
void() trap_damageblocked = 
{ 


	if((other.classname == "player") && (self.forcecrouch == 1) && (self.damagerate > 0))
		other.crushingtime = time + 0.1;
	if(other.damagerate < time)
	{
	
		if((self.kill_player == 1)&& (other.health >0) )
		{
			other.health = -100;
			Killed(other, self, 1);
			return;
		}
		T_Damage(other, self, self, self.dmg);
		
		if(self.damagerate > 0)
			other.damagerate = time + self.damagerate;
	}
	if((other.health > 0 ) && (self.damagerate <= 0))
	{
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			trap_return();
			return;
		}
		else
			trap_fire();
	}
};
void() trap_damagetouch = 
{ 

/*
	vector fakevelocity;

	fakevelocity = self.velocity;

	other.velocity_x = self.velocity_x * -1.5;
	other.velocity_y = self.velocity_y * -1.5;
*/
	if(other.damagerate < time)
	{
	
		if((self.kill_player == 1)&& (other.health >0) )
		{
			other.health = -100;
			Killed(other, self, 1);
			return;
		}
		T_Damage(other, self, self, self.dmg);


		if(self.damagerate <= 0)
			other.damagerate = time + 0.5;

		if(self.damagerate > 0)
			other.damagerate = time + self.damagerate;
	}
	if((other.health > 0 ) && (self.damagerate <= 0))
	{		
		self.oldtouch = self.touch;
		self.touch = null;
		if (self.state == STATE_UP || self.state == STATE_TOP)
		{
			trap_return();
			return;
		}
		else
			trap_fire();
	}
};

.float fake_lighted;
void() trap_done = 
{ 
	sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);
	self.touch = self.oldtouch;
	self.state = STATE_BOTTOM;
	self.solid = SOLID_BSP;
};

void() trap_return = 
{
	self.state = STATE_DOWN;
	self.usable = 0;
	if(self.classname != "damage_bbox")
	sound(self, CHAN_VOICE, self.noise, self.volume, self.atten);

	if(self.using == 1)
	SUB_CalcMove(self.pos1, self.speed, trap_wait2);
	else
	{
	SUB_CalcMove(self.pos1, self.speed, trap_done);
	self.using = 0;
	}

};
.vector blade_offset;
.float metaltrap;

.vector fake_origin;
.string attached_model;
.float alwaysdamage;

void() trap_fire = 
{ 

    if((self.target))
    {
        local entity t;
        t = find(world,targetname,self.target);
        if(t)
        self.pos2 = t.origin;    
    }

	if (self.state == STATE_UP || self.state == STATE_TOP)
	{
		trap_return();
		return;
	}

	if(self.classname != "damage_bbox")
	sound(self, CHAN_VOICE, self.noise, 1, self.atten);
	self.state = STATE_UP;
	self.usable = 0;
	if(self.loop != 0)
		SUB_CalcMove(self.pos2, self.speed2, trap_wait);
	else
	{	
		if(self.wait == -1)
		SUB_CalcMove(self.pos2, self.speed2, trap_done);
		else
		{
		SUB_CalcMove(self.pos2, self.speed2, trap_return);
		self.using = -1;
		}
	}
};

void() trap_use = 
{
	if(self.using == 0)
	{
		self.enemy = activator;
		trap_fire();
		self.using = 1;
	}
	if(self.using == 1)
		self.using = 0;

};
void() trap_puse = 
{
	SUB_UseTargets();
	//SUB_UseTargets2();	//targetname2 for double traps
	trap_fire();
};

void() trigger_bbox_think = 
{
	self.velocity = self.owner.velocity;
	self.think = trigger_bbox_think;
	self.nextthink = time + 0.01;

}


void() func_blade = 
{ 
	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	attn = 256 / self.rad_sound;	// 200 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	self.atten = attn;
	//if(self.alwaysdamage)

	precache_sound(self.noise);
	precache_sound(self.noise2);
	SetMovedir();
	self.classname = "func_trap";
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	if (!self.speed)
		self.speed = 60;
	if (!self.speed2)
		self.speed2 = 120;
	if(!self.damagerate)
	self.damagerate = 0.1;

	self.use = trap_use;
	if (!self.dmg)
		self.dmg = 1;
	if (!self.wait2)
		self.wait2 = 1;
	if (!self.wait)
		self.wait = 1;
	if (!self.lip)
		self.lip = 0;

	self.state = STATE_BOTTOM;
	self.trapstate = 0;
	self.pos1 = self.origin;

	self.pos2 = self.pos1 + self.movedir *(fabs(self.movedir *self.size) - self.lip);


	if ((self.spawnflags &1) && (!self.target))
	{
		setorigin(self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	vector voffset;
	voffset_z= (self.absmax_z - self.absmin_z) / 2; 
	if(self.fake_lighted == 1)
	{
	self.fake_origin = 0.5 *(self.absmax + self.absmin);
	self.fake_origin_z = self.absmax_z;

	spawn_lighter(self);
	}		

	if((self.loop == 1) || ((!self.targetname)))
	{
		self.using = 1;
		self.nextthink = self.ltime + self.wait2;
		self.think = trap_fire;
	}	

	
	entity damagebbox = spawn();
	copyentity (self, damagebbox);
	damagebbox.solid =  SOLID_TRIGGER;
	damagebbox.effects = EF_NODRAW;

	if(self.target)
	setsize(damagebbox, (self.mins + self.blade_offset), (self.maxs - self.blade_offset));
	else
	setsize(damagebbox, (self.absmin + self.blade_offset), (self.absmax - self.blade_offset));
	damagebbox.classname = "damage_bbox";
	damagebbox.blocked = null;
	if(self.alwaysdamage == 1)
		damagebbox.touch = trap_damagetouch;	
	damagebbox.oldtouch = damagebbox.touch;
	damagebbox.blocked = trap_damageblocked;


};

void() func_trap = 
{ 
	if(self.alwaysdamage == 1)
		self.touch = trap_damagetouch;	
	self.oldtouch = self.touch;
	self.blocked = trap_damageblocked;

	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	attn = 256 / self.rad_sound;	// 200 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	self.atten = attn;
	//if(self.alwaysdamage)

	precache_sound(self.noise);
	precache_sound(self.noise2);
	SetMovedir();
	self.classname = "func_trap";
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	setmodel(self, self.model);
	if (!self.speed)
		self.speed = 60;
	if (!self.speed2)
		self.speed2 = 120;
	if(!self.damagerate)
	self.damagerate = 0.1;

	self.use = trap_use;
	if (!self.dmg)
		self.dmg = 1;
	if (!self.wait2)
		self.wait2 = 1;
	if (!self.wait)
		self.wait = 1;
	if (!self.lip)
		self.lip = 0;

	self.state = STATE_BOTTOM;
	self.trapstate = 0;
	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir *(fabs(self.movedir *self.size) - self.lip);
	if (self.spawnflags &1)
	{
		setorigin(self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}

	if (self.keyrequired)
		self.usable = 1;
	vector voffset;
	voffset_z= (self.absmax_z - self.absmin_z) / 2; 
	if(self.fake_lighted == 1)
	{
	self.fake_origin = 0.5 *(self.absmax + self.absmin);
	self.fake_origin_z = self.absmax_z;

	spawn_lighter(self);
	}

	if((self.loop == 1) || ((!self.targetname)))
	{
		self.using = 1;
		self.nextthink = self.ltime + self.wait2;
		self.think = trap_fire;
	}	
};

/*- open speed
- close speed
- open delay
- close delay
- damage
- damage rate
- loop flag
- loop when triggered flag*/


void() misc_cyst_die =
{
	T_SplashDamage(self, self, self.dmg, world, self.sradius);
	aoe_spawn(self);
	pointparticles(particleeffectnum("retcher"), self.origin, '0 0 0', 1);
	CyExplosionBody();
};

void() misc_cyst_wait_die =
{
	self.takedamage = 0;
	self.think  = misc_cyst_die;

	float delaytodie;

	if(self.enemy.classname != "player")
		delaytodie = 0.5 +random() * 0.5;

	self.think = misc_cyst_die;
	self.nextthink = time + delaytodie;
};

void() misc_cyst = 
{
	if(!self.type)
		self.type = 1;
	if(!self.scale)
		self.scale = 2;
	if(!self.dmg)
		self.dmg = 16;
	if(!self.sradius)
		self.sradius = 64;

	if (self.type == 1)
		setmodel(self, "models/enemies/afflicted/cyst_a.md3");
	else if (self.type == 2)
		setmodel(self, "models/enemies/afflicted/cyst_b.md3");
	else if (self.type == 3)
		setmodel(self, "models/enemies/afflicted/cyst_c.md3");
	else if (self.type == 4)
		setmodel(self, "models/enemies/afflicted/cyst_d.md3");
	else
		setmodel(self, "models/enemies/afflicted/cyst_a.md3");



	self.solid = SOLID_BBOX;	

	if(self.health > 0)
		self.takedamage = DAMAGE_AIM;

	self.use = misc_cyst_die;

	vector sizenegative, sizepositive;
	sizepositive = '8 8 8' * self.scale;
	sizenegative = '-8 -8 -8' * self.scale;
	setsize (self,sizenegative,sizepositive);

	self.th_die = misc_cyst_wait_die;
};
///////////////////////////////////end of qc file
