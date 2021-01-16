//============================================================================
float EASEUNDERCURRENT = 16;

.float fakewatertype;
.float water_movflag;
void() CheckFuncWaterDeath = {};

.float height_water1;
.float height_water2;
.float height_water3;

.vector pos3;
.vector pos4;
.vector pos5;
.float height_water;

void() func_water_use = 
{ 

	if(self.height_water1)
	{
		if((self.height_water3)&& (self.height_water == 2))
		{
			SUB_CalcMove(self.pos5, self.speed, SUB_Null);
			self.height_water = 3;
		}
		if((self.height_water2)&& (self.height_water == 1))
		{
			SUB_CalcMove(self.pos4, self.speed, SUB_Null);
			self.height_water = 2;
		}
		if((!self.height_water))
		{
			SUB_CalcMove(self.pos3, self.speed, SUB_Null);
			self.height_water = 1;
		}
	}
	else
	{	
		if (self.water_movflag == 1)
		{
			SUB_CalcMove(self.pos1, self.speed, SUB_Null);
			self.water_movflag = 0;
		}
		else
		{
			SUB_CalcMove(self.pos2, self.speed, SUB_Null);
			self.water_movflag = 1;
		}
	}
};

//============================================================================
.float deep;

.float lavatime;
.float funcwaterlevel;
void() liquid_touch = 
{
	local float test;
	local float c;
	if((other.flags & FL_MONSTER) || (self.classentity == "corpse"))
	{
		test = other.origin_z - other.maxs_z;
		if(test <= self.absmax_z)
		other.funcwaterlevel = 1;

		test = other.origin_z + other.maxs_z;
		if(test <= self.absmax_z)
		other.funcwaterlevel = 2;

		test = other.origin_z + other.maxs_z + 8;	
		if(test <= self.absmax_z)
		other.funcwaterlevel = 3;

		other.liquidtouch_timing = time + 0.5;
		return;
	}
	if((other.classname != "player"))
	{
		if((other.wrathflags & FL_GIB))
		{
		    other.time_toalpha = 0;
		    if((other.velocity_z != -5)&&(other.classname != "watergib"))
		    {
		        other.velocity_z = 0;
		        other.velocity_y = other.velocity_y * 0.25;
		        other.velocity_x = other.velocity_x * 0.25;
		    }
		    other.liquidtouch_timing = time + 0.1;
		    other.glowmod = '0 0 0';
		    return;
		}

		if(time < other.liquidtouch_timing )	
		return;
		if (other.classname == "decal")
			remove(other);

		if (other.health <= 0)
			return;



		if ((self.flags & FL_MONSTER) && (self.fakewatertype == CONTENT_LAVA))
		{
			/*if (other.movetype == MOVETYPE_NONE ||
				other.movetype == MOVETYPE_PUSH ||
				other.movetype == MOVETYPE_NOCLIP)	// MOVETYPE_WALK is always FL_CLIENT so don't worry about it
				return;

			if (other.fwatershifttime < time && other.watertype)
			{
				other.watertype = self.fakewatertype;
				other.waterlevel = 1;
			}
				other.liquidtouch_timing = time + 0.2;

			// C code will go nuts with the splash sound if we don't time out while in func_water*/
			other.fwatershifttime = time + 0.1;
			other.lavatime = time + 0.1;
			return;
		}
		if (!(other.flags &FL_CLIENT))
			return;
	}	
	if((other.classname == "player"))
	{
	other.watertype_time = time + 0.05;
	test = other.origin_z + other.mins_z + 1;
	if ((test <= self.absmax_z && test >= self.absmin_z) || (other.zerogtime > time))
	{
		other.fakewatertype = self.fakewatertype;
		other.waterlevel = 1;
		//if (other.watertype != other.fakewatertype)
		//	other.watertype = other.fakewatertype;

		// Test Torso
		test = other.origin_z + (other.mins_z + other.maxs_z) *0.5;
		if (test <= self.absmax_z)
		{
			other.waterlevel = 2;
			other.zerogtime = time + 0.05;	// remove gravity in PreThink
		}

		// Test Eyes
		test = other.origin_z + other.view_ofs_z;
		if ((test <= self.absmax_z) || (self.deep == 1))
		{
			other.waterlevel = 3;

			// Do the color shift
			stuffcmd(other, "v_cshift ");
			stuffcmd(other, self.cshift);
			stuffcmd(other, "\n");

			// Tell PreThink to clear the cshift when the player is out
			other.fwatershifttime = time + frametime;
			other.fwatershift = TRUE;
		}

		// Add drag and/or current
		if (self.spawnflags &EASEUNDERCURRENT) c = 4 - other.waterlevel;
		else c = other.waterlevel;
		if (self.drag) other.velocity = other.velocity + self.velocity *(self.drag *frametime) *c;
		if (self.mangle != '0 0 0') other.velocity = other.velocity + self.mangle *frametime *(c / 3);
	}
	}
	
};


void(vector org, string noise, float vol, float attn) ambientsound2 =
{

/*local entity sor;
sor = spawn();
setmodel (sor, "erwr");
sor. origin = org;*/
ambientsound(org, noise, vol, attn);

}

void(entity e) spawn_lava_sounds = 
{
	self.noise = "env/liquids/lava_loop.ogg";
	self.volume = 1;
	precache_sound (self.noise);

	float x_res = self.absmax_x - self.absmin_x;
	float y_res = self.absmax_y - self.absmin_y;

	vector center = (self.absmax + self.absmin) / 2;  
	float attn = 256 / ((y_res + x_res) / 3);
	ambientsound2(center, self.noise, self.volume, attn);

	vector center_xa = center; center_xa_x +=  (x_res) / 3;
	attn = 256 / ((x_res) / 4);
	ambientsound2(center_xa, self.noise, self.volume, attn);

	vector center_xb = center; center_xb_x -=  (x_res) / 3;
	attn = 256 / ((x_res) / 4);
	ambientsound2(center_xb, self.noise, self.volume, attn);

	vector center_ya = center; center_ya_y +=  (y_res) / 3;
	attn = 256 / ((y_res) / 4);
	ambientsound2(center_ya, self.noise, self.volume, attn);

	vector center_yb = center; center_yb_y -=  (y_res) / 3;
	attn = 256 / ((y_res) / 4);
	ambientsound2(center_yb, self.noise, self.volume, attn);

};

void() func_water = 
{ 
	if (self.noise != string_null)
		precache_sound(self.noise);
	if (self.noise1 != string_null)
		precache_sound(self.noise1);
	if (self.noise2 != string_null)
		precache_sound(self.noise2);
		
	if(!self.watertype)	
	self.watertype = -3;
	self.clipgroup = 2;
	self.solid = SOLID_TRIGGER;
	self.movetype = MOVETYPE_NOCLIP;
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	self.rel_origin = self.origin;

	self.classname = "fliquid";
	self.touch = liquid_touch;

	if (self.watertype < -5 || self.watertype > -3)
		self.watertype = CONTENT_WATER;
	if (self.watertype == CONTENT_LAVA)
	spawn_lava_sounds(self);

	self.fakewatertype = self.watertype;
		if (self.fakewatertype == CONTENT_WATER)
		self.dphitcontentsmask =DPCONTENTS_WATER; 
		if (self.fakewatertype == CONTENT_SLIME)
		self.dphitcontentsmask = DPCONTENTS_SLIME;
		if (self.fakewatertype == CONTENT_LAVA)
		self.dphitcontentsmask = DPCONTENTS_LAVA; 
	if (self.cshift == string_null)
	{
		if (self.fakewatertype == CONTENT_WATER)
		{
			self.cshift = "130 80 50 128";
		}
		else if (self.fakewatertype == CONTENT_SLIME)
			self.cshift = "0 25 5 150";
		else if (self.fakewatertype == CONTENT_LAVA)
			self.cshift = "255 80 0 150";
	}

	if (self.targetname)
		self.movetype = MOVETYPE_PUSH;

	SetMovedir();
	if (!self.lip)
		self.lip = 8;
	if (!self.speed)
		self.speed = 100;

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir *(fabs(self.movedir *self.size) - self.lip);

	if (self.spawnflags &1)
	{
		// start moved
		setorigin(self, self.pos2);
		self.water_movflag = 1;
	}

	if(self.height_water1)
	self.pos3 = self.pos1 + self.movedir *(self.height_water1);
	if(self.height_water2)
	self.pos4 = self.pos1 + self.movedir *(self.height_water2);
	if(self.height_water3)
	self.pos5 = self.pos1 + self.movedir *(self.height_water3);
	self.use = func_water_use;

	// Cap drag force
	if (self.drag > 100) self.drag = 100;
	if (self.drag < 0) self.drag = 0;

	if (self.mangle != '0 0 0')
		self.mangle = self.mangle * 50;

};
///////////////////////////
