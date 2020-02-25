.float fscnt;	//not repeat sounds
.float sscnt;	//not repeat sounds
.float jscnt;	//not repeat sounds
.float jsscnt;	//not repeat sounds

.float crouchlooptime;

//gwalk, gravel, mud, snow, soft, stone, water and wood
enum
{
	MAT_GENERIC,
	MAT_GRASS,
	MAT_DIRT,
	MAT_GRAVEL,
	MAT_GRATE,
	MAT_METAL,
	MAT_MUD,
	MAT_PUDDLE,
	MAT_SNOW,
	MAT_SOFT,
	MAT_STONE,
	MAT_WOOD
};

void(string friktxt) check_volume = { local float readparms;
	local string readtext;
	readparms = fopen(friktxt, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	self.footstepvol = stof(readtext);	//turn the text into the float u want (by using stof: string to float) 
	readtext = fgets(readparms);	//read the text
	self.footstepcrouchvol = stof(readtext);
	fclose(readparms);
};
.string nearestsurface;

void(vector org) spawnfootstep = { local entity fs;
	fs = spawn();
	setmodel(fs, "models/player/footstep.md3");
	fs.scale = 3;
	fs.origin = org;
	fs.angles_x = -90;
	fs.alpha = 0.5;
	fs.effects = EF_ADDITIVE;
	fs.angles_y = self.angles_y;
};
float(entity e) GetFootMaterial = { local float surfnum;
	local string s;
	makevectors(e.v_angle);

	local vector org2;
	traceline(e.origin, e.origin - '0 0 64', TRUE, e);
	if (trace_fraction != 1)
		org2 = trace_endpos + ' 0 0 0.5';
	else
		return MAT_GENERIC;
	surfnum = getsurfacenearpoint2(self.groundentity, org2, 16384);

	//	surfnum = getsurfacenearpoint(world, e.origin - '0 0 31.4');
	if (surfnum >= 0)
	{
		s = getsurfacetexture(self.groundentity, surfnum);

		//bprint (s);
		//bprint (" \n");
		local float f;	// file handle, basically assigns a number to whatever file is open
		local string ln;	// ln = line of the file being read
		f = fopen("materials/dirt.txt", FILE_READ);
		if (f != -1)	// if f = -1 then the file could not be found
		{
			ln = fgets(f);	// this line sets ln to the string read from the file with the file handle of f
			while (ln != string_null)	// while there is still text to be read do the following
			{
				{
					if (ln == s)
					{
						fclose(f);	// when the while loop is over (no lines left in file) close file with the handle f
						return MAT_DIRT;
					}
				}

				ln = fgets(f);	// get a new line from the file
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/gravel.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_GRAVEL;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/grass.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_GRASS;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/grate.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_GRATE;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/metal.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_METAL;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/mud.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_MUD;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);
		f = fopen("materials/puddle.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_PUDDLE;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/snow.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						//spawnfootstep (org2);
						return MAT_SNOW;

					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/soft.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_SOFT;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/stone.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_STONE;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);

		f = fopen("materials/wood.txt", FILE_READ);
		if (f != -1)
		{
			ln = fgets(f);
			while (ln != string_null)
			{
				{
					if (ln == s)
					{
						fclose(f);
						return MAT_WOOD;
					}
				}

				ln = fgets(f);
			}
		}

		if (f >= 0) fclose(f);
		return MAT_GENERIC;
	}
	else
		return MAT_GENERIC;
};

void() checking_enemies = { if ((self.cursor_trace_ent.takedamage) && (self.cursor_trace_ent.flags &FL_MONSTER))
	{
		self.enhealth = self.cursor_trace_ent.health;
		self.enframe = self.cursor_trace_ent.frame;
		self.flash.effects = 512 + EF_NODEPTHTEST;
		self.flash.colormod = '5 1 1';
		self.flash.alpha = 1;
	}
	else
	{
		self.flash.alpha = 0.5;
		self.flash.effects = 0;
		self.flash.colormod = '0.2 0.2 0.2';
		self.enhealth = 0;
	}
};

.float landsoundtime;
void(float isheavy) playerlandsound = { if (self.landsoundtime > time)
		return;
	local string r;
	local string landingsound;
	if (isheavy == 1)
	{
		local float mat, material;
		mat = floor(random() *4 + 1);
		r = ftos(floor(mat));
		material = GetFootMaterial(self);
		self.landsoundtime = time + 1;
		if (material == MAT_GENERIC)
		{
			landingsound = strcat("player/landings/land_stone", r, ".ogg");
		}
		else if (material == MAT_DIRT)
		{
			landingsound = strcat("player/landings/land_dirt", r, ".ogg");
		}
		else if (material == MAT_GRATE)
		{
			landingsound = strcat("player/landings/land_grate", r, ".ogg");
		}
		else if (material == MAT_GRAVEL)
		{
			landingsound = strcat("player/landings/land_gravel", r, ".ogg");
		}
		else if (material == MAT_GRASS)
		{
			landingsound = strcat("player/landings/land_grass", r, ".ogg");
		}
		else if (material == MAT_METAL)
		{
			landingsound = strcat("player/landings/land_metal", r, ".ogg");
		}
		else if (material == MAT_MUD)
		{
			landingsound = strcat("player/landings/land_dirt", r, ".ogg");
		}
		else if (material == MAT_SNOW)
		{
			landingsound = strcat("player/landings/land_snow", r, ".ogg");
		}
		else if (material == MAT_SOFT)
		{
			landingsound = strcat("player/landings/land_stone", r, ".ogg");
		}
		else if (material == MAT_STONE)
		{
			landingsound = strcat("player/landings/land_stone", r, ".ogg");
		}
		else if (material == MAT_WOOD)
		{
			landingsound = strcat("player/landings/land_wood", r, ".ogg");
		}
		else if (material == MAT_GRASS)
		{
			landingsound = strcat("player/landings/land_grass", r, ".ogg");
		}
	}

	if (isheavy == 2)
	{
		local float mat;
		mat = floor(random() *2 + 1);
		r = ftos(floor(mat));
		landingsound = strcat("player/landings/heavy_land", r, ".ogg");
	}

	//pointsound(self.origin, landingsound, 1, 1);

	sound(self, CHAN_AUTO, landingsound, 1, ATTN_NORM);
};
.float water_splash_origin;

void() playerfootstepsound = { local string r;
	local float mat, material, pvol;
	mat = floor(random() *4 + 1);
	if (mat == self.fscnt)
	{
		mat = self.fscnt + 1;
		if (mat > 5)
			mat = 1;
		if (mat == self.sscnt)
			mat = mat + 1;
		if (mat > 5)
			mat = 1;
	}

	if (mat == self.sscnt)
	{
		mat = self.sscnt + 1;
		if (mat > 5)
			mat = 1;
		if (mat == self.fscnt)
			mat = mat + 1;
		if (mat > 5)
			mat = 1;
	}

	self.sscnt = self.fscnt;
	self.fscnt = mat;
	r = ftos(floor(mat));
	material = GetFootMaterial(self);
	local string footstepsound;
	if (material == MAT_GENERIC)
	{
		check_volume("materials/generic.txt");
		footstepsound = strcat("player/footsteps/dirt", r, ".ogg");
	}
	else if (material == MAT_DIRT)
	{
		check_volume("materials/dirt.txt");
		footstepsound = strcat("player/footsteps/dirt", r, ".ogg");
	}
	else if (material == MAT_GRAVEL)
	{
		check_volume("materials/gravel.txt");
		footstepsound = strcat("player/footsteps/gravel", r, ".ogg");
	}
	else if (material == MAT_GRASS)
	{
		check_volume("materials/grass.txt");
		footstepsound = strcat("player/footsteps/grass", r, ".ogg");
	}
	else if (material == MAT_GRATE)
	{
		check_volume("materials/grate.txt");
		footstepsound = strcat("player/footsteps/grate", r, ".ogg");
	}
	else if (material == MAT_METAL)
	{
		check_volume("materials/metal.txt");
		footstepsound = strcat("player/footsteps/metal", r, ".ogg");
	}
	else if (material == MAT_MUD)
	{
		check_volume("materials/mud.txt");
		footstepsound = strcat("player/footsteps/mud", r, ".ogg");
	}
	else if (material == MAT_SNOW)
	{
		check_volume("materials/snow.txt");
		footstepsound = strcat("player/footsteps/snow", r, ".ogg");
	}
	else if (material == MAT_PUDDLE)
	{
		check_volume("materials/puddle.txt");
		footstepsound = strcat("player/footsteps/puddle", r, ".ogg");
	}
	else if (material == MAT_SOFT)
	{
		check_volume("materials/soft.txt");
		footstepsound = strcat("player/footsteps/stone", r, ".ogg");
	}
	else if (material == MAT_STONE)
	{
		check_volume("materials/stone.txt");
		footstepsound = strcat("player/footsteps/stone", r, ".ogg");
	}
	else if (material == MAT_WOOD)
	{
		check_volume("materials/wood.txt");
		footstepsound = strcat("player/footsteps/wood", r, ".ogg");
	}

	pvol = self.footstepvol;
	if (pvol > 1)
		pvol = 1;
	if (self.waterlevel < 1)
		sound7(self, CHAN_AUTO, footstepsound, pvol, ATTN_NORM, 80 + random() *30, 1);
	if (self.waterlevel)
	{
		footstepsound = strcat("player/footsteps/puddle", r, ".ogg");
		if (self.waterlevel < 2)
			sound7(self, CHAN_AUTO, footstepsound, pvol, ATTN_NORM, 80 + random() *30, 1);
		makevectors(self.angles);
		local vector wsorg;
		if (!self.water_splash_origin)
		{
			wsorg = self.origin + '0 0 -9' + v_right * 12;
			self.water_splash_origin = 1;
		}
		else
		{
			wsorg = self.origin + '0 0 -9' + v_right *-12;
			self.water_splash_origin = 0;
		}

		if (self.waterlevel == 2)
			wsorg = wsorg + '0 0 16';
		//pointparticles(particleeffectnum("water_splash"), wsorg, 0, 1);
	}
};
void() playerjumpsound = { local string jumpsound, r;
	local float ft;
	ft = floor(random() *4 + 1);
	r = ftos(floor(ft));
	jumpsound = strcat("player/jumps/jump", r, ".ogg");
	sound7(self, CHAN_AUTO, jumpsound, 1, ATTN_NORM, 80 + random() *30, 1);
};
void() PlayerFootstep = { if (!(self.flags &FL_ONGROUND))
	{
		if (self.crouchlooptime > 0)
		{
			//sound (self, CHAN_FOOT, "player/crawl.ogg", 0, ATTN_NORM);
			self.crouchlooptime = 0;
		}

		return;
	}

	if (self.crouch)
	{
		if (self.velocity_x || self.velocity_y)
		{
			if (self.crouchlooptime < time)
			{
				//sound (self, CHAN_FOOT, "player/crawl.ogg", 1, ATTN_NORM);
				self.crouchlooptime = time + 5;	//(soundlength ("player/crawl.ogg"));
			}
		}
		else
		{
			//sound (self, CHAN_FOOT, "player/crawl.ogg", 0, ATTN_NORM);
			self.crouchlooptime = 0;
		}
	}
	else
	{
		if (self.crouchlooptime > 0)
		{
			//sound (self, CHAN_FOOT, "player/crawl.ogg", 0, ATTN_NORM);
			self.crouchlooptime = 0;
		}

		if (time < self.timefootstep)
			return;

		local float vf;
		local vector vp;
		vp = self.velocity;
		vp_z = 0;
		if ((vp_x > 0) || (vp_y > 0))	// vp > 0
			vf = 77 / (vlen(vp));
		if (vf > 1)
			vf = 1;
		if (vf < 0.3)
			vf = 0.3;
		self.timefootstep = time + vf;
		if (vlen(vp) >= 30)
			playerfootstepsound();
	}
};

/////////////////////////////////i