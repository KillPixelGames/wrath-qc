.float doorstate;
.float notouch;
void() door_return;

void() door_wait = 
{
	self.state = STATE_TOP;
	activator = self.enemy;
	self.usable = 0;
	self.nextthink = self.ltime + self.wait;
	sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);

	self.think = door_return;
};
void() door_fire;
void() door_blocked = 
{
	if (other.classname == "monster_fallen")
		other.solid = SOLID_CORPSE;
	T_Damage(other, self, self, self.dmg);

	/*
	if (self.state == STATE_UP || self.state == STATE_TOP)
	{
		door_return();
		return;
	}
	else
	door_fire(); */
};
.float fake_lighted;
void() door_done = 
{
	sound(self, CHAN_VOICE, self.noise2, self.volume, self.atten);
	self.state = STATE_BOTTOM;
	if (!self.notouch)
		self.usable = 1;
	self.solid = SOLID_BSP;
	/*if(self.fake_lighted != 1)
	{
	self.colormod = '0 0 0';
	self.effects = 0;
	}*/
};

void() door_return = 
{
	self.state = STATE_DOWN;
	self.usable = 0;
	sound(self, CHAN_VOICE, self.noise, self.volume, self.atten);
	SUB_CalcMove(self.pos1, self.speed, door_done);
};

void() door_fire = 
{
	if (self.state == STATE_UP || self.state == STATE_TOP)
	{
		door_return();
		return;
	}

	sound(self, CHAN_VOICE, self.noise, 1, self.atten);
	self.state = STATE_UP;
	self.usable = 0;
	SUB_CalcMove(self.pos2, self.speed, door_wait);
};

void() door_use = 
{
	self.enemy = activator;
	door_fire();
};
void() door_puse = 
{
	SUB_UseTargets();
	//SUB_UseTargets2();	//targetname2 for double doors
	door_fire();
};
.float metaldoor;

void() lighter_think =
{
	if( (self.owner.velocity != '0 0 0'))
		fake_light(self.owner, self.origin + '0 0 0');
	self.think = lighter_think;
	self.nextthink = time + 0.05;
}
.vector fake_origin;
.string attached_model;
void(entity ownr) spawn_lighter =
{
	local entity lighter;
	lighter = spawn();
	setmodel (lighter, "models/misc/null.md3");
	lighter.solid = SOLID_TRIGGER;
	setsize (self,'0 0 0', '3 3 3');
	lighter.owner = ownr;
	lighter.origin = lighter.owner.fake_origin+ '0 0 8';
	lighter.movetype = MOVETYPE_FOLLOW;
	lighter.aiment = lighter.owner;
	lighter.view_ofs = lighter.origin - lighter.owner.origin; // relative origin
	//hole.v_angle = hole.angles - bmodel.angles; // relative angles
	fake_light(lighter.owner, lighter.origin + '0 0 0');
	lighter.think = lighter_think;
	lighter.nextthink = time + 0.025;

};

void() attached_think =
{
	self.think = lighter_think;
	self.nextthink = time + 0.025;
};

void(entity ownr) spawn_attached_model =
{
	local entity attachedmodel;
	attachedmodel = spawn();
	setmodel (attachedmodel, self.owner.attached_model);
	attachedmodel.solid = SOLID_NOT;
	setsize (self,'0 0 0', '3 3 3');
	attachedmodel.owner = ownr;
	attachedmodel.origin = attachedmodel.owner.fake_origin ;
	attachedmodel.movetype = MOVETYPE_FOLLOW;
	attachedmodel.aiment = attachedmodel.owner;
	attachedmodel.view_ofs = attachedmodel.origin - attachedmodel.owner.origin; // relative origin
	attachedmodel.think = attached_think;
	attachedmodel.nextthink = time + 0.025;
};
void() func_door = 
{ 
	if (self.keyrequired == 4)
	{
		if (!self.noise)
			self.noise = "doors/coffer_open.ogg";
		self.noise2 = "doors/coffer_locked.ogg";
	}

	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	attn = 256 / self.rad_sound;	// 200 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	self.atten = attn;
	precache_sound(self.noise);
	precache_sound(self.noise2);
	SetMovedir();
	self.classname = "func_door";
	self.movetype = MOVETYPE_PUSH;
	self.solid = SOLID_BSP;
	if(self.startnonsolid == 1)
	{
		self.oldsolid = self.solid;
		self.wrathflags += FL_STARTNONSOLID;
		self.solid = SOLID_NOT;
		self.think = turn_solid;
		self.nextthink =  self.ltime + 1;
	}

	setmodel(self, self.model);
	if (!self.speed)
		self.speed = 60;
	self.use = door_use;
	if (!self.wait)
		self.wait = 1;
	if (self.keyrequired)
		self.wait = -1;
	if (!self.lip)
		self.lip = 0;
	if (!self.notouch)
			self.usable = 1;

	self.blocked = door_blocked;
	self.state = STATE_BOTTOM;
	self.doorstate = 0;
	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir *(fabs(self.movedir *self.size) - self.lip);
	if (self.spawnflags &1)
	{
		setorigin(self, self.pos2);
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}
	//self.effects = EF_DYNAMICMODELLIGHT;
	if (self.keyrequired)
		self.usable = 1;
	vector voffset;
	voffset_z= (self.absmax_z - self.absmin_z) / 2; 
	if(self.fake_lighted == 1)
	{
		self.effects += EF_DYNAMICMODELLIGHT;
	}
	if(self.attached_model != string_null)
	{
		self.fake_origin = 0.5 *(self.absmax + self.absmin);
		self.fake_origin_z = self.absmax_z;
		spawn_attached_model (self);
	}

};

///////////////////////////////////end of qc file
