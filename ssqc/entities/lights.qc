float START_OFF = 1;

void() info_null = 
{
	remove(self);
};

void() info_notnull = {};

void() light_use = 
{
	if (self.spawnflags &START_OFF)
	{
		lightstyle(self.style, "m");
		self.spawnflags = self.spawnflags - START_OFF;
	}
	else
	{
		lightstyle(self.style, "a");
		self.spawnflags = self.spawnflags + START_OFF;
	}
};

void() fade_light = 
{
	/*
	if(self.count == 12)
	{
	lightstyle(self.style, "l");
	self.think = SUB_Null;
	self.nextthink = time + 10;
	}

	*/

	if (self.count == 25)
	{
		lightstyle(self.style, "z");
		self.think = SUB_Null;
		self.nextthink = time + 10;
	}

	if (self.count == 24)
		lightstyle(self.style, "y");
	if (self.count == 23)
		lightstyle(self.style, "x");
	if (self.count == 22)
		lightstyle(self.style, "w");
	if (self.count == 21)
		lightstyle(self.style, "v");
	if (self.count == 20)
		lightstyle(self.style, "u");
	if (self.count == 19)
		lightstyle(self.style, "t");
	if (self.count == 18)
		lightstyle(self.style, "s");
	if (self.count == 17)
		lightstyle(self.style, "r");
	if (self.count == 16)
		lightstyle(self.style, "q");
	if (self.count == 15)
		lightstyle(self.style, "p");
	if (self.count == 14)
		lightstyle(self.style, "o");
	if (self.count == 13)
		lightstyle(self.style, "n");
	if (self.count == 12)
		lightstyle(self.style, "m");

	if (self.count == 11)
		lightstyle(self.style, "k");
	if (self.count == 10)
		lightstyle(self.style, "j");
	if (self.count == 9)
		lightstyle(self.style, "i");
	if (self.count == 8)
		lightstyle(self.style, "h");
	if (self.count == 7)
		lightstyle(self.style, "g");
	if (self.count == 6)
		lightstyle(self.style, "f");
	if (self.count == 5)
		lightstyle(self.style, "e");
	if (self.count == 4)
		lightstyle(self.style, "d");
	if (self.count == 3)
		lightstyle(self.style, "c");
	if (self.count == 2)
		lightstyle(self.style, "b");
	if (self.count == 1)
		lightstyle(self.style, "a");

	self.count += 1;
	self.think = fade_light;
	self.nextthink = time + (self.time_fade / 12);
};

.string targetfade;
void() light = 
{
	if (!self.time_fade)
		self.time_fade = 0.5;
	if (self.style == 16)
	{
		self.targetname = self.targetfade;
		self.use = fade_light;
		self.count = 1;
	}

	if (!self.targetname)
	{
		// inert light
		remove(self);
		return;
	}

	if (self.style >= 32)
	{
		self.use = light_use;

		if (self.spawnflags &START_OFF)
			lightstyle(self.style, "a");

		else
			lightstyle(self.style, "m");
	}
};

void() light_fluoro = 
{
	if (self.style >= 32)
	{
		self.use = light_use;

		if (self.spawnflags &START_OFF)
			lightstyle(self.style, "a");

		else
			lightstyle(self.style, "m");
	}

	precache_sound("ambience/fl_hum1.wav");
	ambientsound(self.origin, "ambience/fl_hum1.wav", 0.5, ATTN_STATIC);
};

void() light_fluorospark = 
{
	if (!self.style)
		self.style = 10;
	precache_sound("ambience/buzz1.wav");
	ambientsound(self.origin, "ambience/buzz1.wav", 0.5, ATTN_STATIC);
};

void() light_globe = 
{
	precache_model("progs/s_light.spr");
	setmodel(self, "progs/s_light.spr");
	makestatic(self);
};

void() FireAmbient = 
{
	precache_sound("ambience/fire1.wav");
	ambientsound(self.origin, "ambience/fire1.wav", 0.5, ATTN_STATIC);
};

void() light_torch_small_walltorch = 
{
	precache_model("progs/flame.mdl");
	setmodel(self, "progs/flame.mdl");
	FireAmbient();
	makestatic(self);
};

void() light_flame_large_yellow = 
{
	precache_model("progs/flame2.mdl");
	setmodel(self, "");
	self.frame = 1;
	FireAmbient();
};

void() light_flame_small_yellow = 
{
	precache_model("progs/flame2.mdl");
	setmodel(self, "");
	FireAmbient();
};

void() light_flame_small_white = 
{
	precache_model("progs/flame2.mdl");
	setmodel(self, "");
	FireAmbient();
};

/////////////////end of qc file