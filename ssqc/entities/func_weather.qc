.float fcolor;

.float density;
void() lightning_think;

void() weather_think = 
{
	if (self.using == 1)
	{
		if (self.type == 1)
			te_particlesnow(self.absmin, self.absmax, self.dest, self.count, self.fcolor);
		else
			te_particlerain(self.absmin, self.absmax, self.dest, self.count, self.fcolor);
	}

	self.nextthink = time + self.delay;
};

void() func_weather = 
{
	if (!self.using)
		self.using = 1;
	if (!self.delay)
		self.delay = 0.1;
	if ((self.type == 1) && (!(self.dest)))
		self.dest = '0 0 -100';
	if ((self.type != 1) && (!(self.dest)))
		self.dest = '0 0 -700';
	if (!self.fcolor)
		self.fcolor = 12;
	if (!self.density)
		self.density = 1;
	setmodel(self, self.model);
	if (!self.count)
		self.count = ((self.absmax_x - self.absmin_x) *(self.absmax_y - self.absmin_y) / 32768) *self.density;
	self.model = "";
	self.use = toggle_use;
	self.think = weather_think;
	self.nextthink = time + 0.1;
};

void() pspawner_think = 
{
	if (self.owner.using == 1)
		pointparticles(particleeffectnum(self.owner.particlename), self.origin, '0 0 0', 1);
	self.nextthink = time + (self.owner.delay);
	self.think = pspawner_think;
};


void(entity powner) spawn_particle_emitter = 
{
	local entity pspawner;
	pspawner = spawn();
	pspawner.owner = powner;
	pspawner.origin_x = self.absmin_x + (random() *powner.size_x);
	pspawner.origin_y = self.absmin_y + (random() *powner.size_y);
	if (self.spawnflags == 1)
		pspawner.origin_z = self.absmin_z + (powner.size_z);
	else
		pspawner.origin_z = self.absmin_z + (random() *powner.size_z);
	setmodel(pspawner, "");
	pspawner.think = pspawner_think;
	pspawner.nextthink = time + random();
};

void() func_particles_think = 
{
	while (self.count > -1)
	{
		spawn_particle_emitter(self);
		self.count -= 1;
	}
};

void() func_particles = 
{
	if (!self.using)
		self.using = 1;
	if (!self.delay)
		self.delay = 0.5;
	if (!self.wait)
		self.wait = 0.5;
	if (!self.particlename)
		self.particlename = "fakerain";
	setmodel(self, self.model);
	if (!self.density)
		self.density = 1;
	self.count = ((self.absmax_x - self.absmin_x) *(self.absmax_y - self.absmin_y) / 4096) *self.density;
	self.model = "";
	self.use = toggle_use;
	self.think = func_particles_think;
	self.nextthink = time + 0.1;
};
void() pspawner_think2 = 
{
	if (self.using == 1)
	pointparticles(particleeffectnum(self.particlename), self.origin, '0 0 0', 1);

	if ((self.minpitch && self.maxpitch) && (self.noise))
	{
	
		if (self.minpitch && self.maxpitch)
			float spitch = (self.minpitch + self.maxpitch* random()) *100;
		sound7(self, CHAN_VOICE, self.noise, self.volume, self.atten, spitch, 0);
	}

	self.nextthink = time + (self.delay * random()) + self.wait;
	self.think = pspawner_think2;
};
void() point_particles = 
{
	if (!self.using)
		self.using = 1;
	if (!self.delay)
		self.delay = 0.5;
	if (!self.wait)
		self.wait = 0.5;
	if (!self.particlename)
		self.particlename = "lavapoint";
	setmodel(self, "models/misc/null.md3");
	self.use = toggle_use;
	
	if(self.noise)
	{
	local float attn;
	if (!self.volume)
		self.volume = 1;
	if (!self.rad_sound)
		self.rad_sound = 512;
	attn = 256 / self.rad_sound;	// 200 for snd_soundradius default cvar!
	if (self.rad_sound <= 0)
		attn = 0;
	if (self.spawnflags &1)
		attn = 0;
	if (self.minpitch <= 0)
		self.minpitch = 0.1;
	if(self.maxpitch < self.minpitch) 
		self.maxpitch = self.minpitch * 2;
		
	self.atten = attn;
	}
	
	self.think = pspawner_think2;
	self.nextthink = time + self.wait;
};
void() lightninwait = 
{
	if (self.style == 12)
		lightstyle(12, "a");
	if (self.style == 13)
		lightstyle(13, "a");
	if (self.style == 14)
		lightstyle(14, "a");
	self.think = lightning_think;
	self.nextthink = time + self.delay + self.wait* random();
};

void() lightning_think = 
{
	local float rn, rls;
	local string tnoise;
	rls = random();
	if (rls < 0.33333)
		tnoise = self.noise;
	else if (rls < 0.66666)
		tnoise = self.noise1;
	else
		tnoise = self.noise2;
	rn = random();
	if (self.style == 12)
	{
		if (rn < 0.33333)
			lightstyle(12, "zzzzxxyzxktcxvcxjddbbccaaaaaaaaaaa");
		else if (rn < 0.66666)
			lightstyle(12, "zzxzzxaxxafgfgddxvcxjdkilaaaaaaaaaa");
		else
			lightstyle(12, "zzxxcybvbxbzxcyvnbbbccaaaaaaaaaaa");
		pointsound(self.origin, tnoise, 1, 0.001);
	}

	if (self.style == 13)
	{
		if (rn < 0.33333)
			lightstyle(13, "zkcxzvczxcnmncxvcxjddbbccaaaaaaaaa");
		else if (rn < 0.66666)
			lightstyle(13, "zzxzzxmxcxzkillpbbccaaaaaaaa");
		else
			lightstyle(13, "zzxxcgfasdawcnbbjsdddbbccaaaaa");
		pointsound(self.origin, tnoise, 1, 0.001);
	}

	if (self.style == 13)
	{
		if (rn < 0.33333)
			lightstyle(14, "zktcvxzczccxzvvgncxvcxjddbbccaaaaaaaa");
		else if (rn < 0.66666)
			lightstyle(14, "zzxzxxzzmxcxzfgfgddddbbckillpizxelcaaaaaaaaa");
		else
			lightstyle(14, "zzxxcybvbxbzxcyvnbbjsdddbbccaaaaaaaaaa");
		pointsound(self.origin, tnoise, 1, 0.001);
	}

	self.nextthink = time + 2.5;
	self.think = lightninwait;
};

void() misc_lightning = 
{
	if (!self.style)
		self.style = 12;
	if (self.style < 12)
		self.style = 12;
	if (self.style > 14)
		self.style = 14;
	if (!self.delay)
		self.delay = 10;
	if (!self.wait)
		self.wait = 10;
	if (!self.noise)
		self.noise = "env/thunder_clap1.ogg";
	if (!self.noise1)
		self.noise1 = "env/thunder_clap2.ogg";
	if (!self.noise2)
		self.noise2 = "env/thunder_clap3.ogg";
	precache_sound(self.noise1);
	precache_sound(self.noise2);
	precache_sound(self.noise3);
	if (!(self.targetname))
	{
		self.think = lightning_think;
		self.nextthink = time + self.delay;
	}
	else
		self.use = lightning_think;
};


void() lightningt_think =
{

	if(self.cnt)
	{
		if(self.cnt == 1)
		{
			lightstyle(0, "prsmzoprsmnspwrsprqnsnqn");
			self.nextthink = time + 1;
		}
		else
		{
			lightstyle(0, "zxyzrstzxzywtuvzuvyxzzmnzznzmzznnxz");
			self.nextthink = time +random(1.5,2.5);
		}
		self.cnt --;
		self.think = lightningt_think;
	}
	else
	{
		lightstyle(0, "m");
		self.think = SUB_Null;
		self.nextthink = time;
	}

};
.float lightning_time;
void() trigger_lightning_touch =
{	
	if (other.classname != "player")
	return;
	if(self.using == 0)
	return;
	if ((self.lightning_time < time) && (other.lightning_time < time))
	{	
		if(self.wait != -1)
		self.lightning_time = time + self.wait + (self.delay * random());
		else
		self.using = 0;

		other.lightning_time =  self.lightning_time;
		float rls = rint (random(1,3));
		if (rls == 1)
			string tnoise = self.noise;
		if (rls == 2)
			tnoise = self.noise1;
		if (rls == 3)
			tnoise = self.noise2;
		sound7(self, CHAN_AUTO,tnoise, random(0.75,1), 0.001, random(80,120),0);

		self.cnt = 2;
		self.think = lightningt_think;
		self.nextthink = time;
	}

};
void() trigger_lightning =
{
	if (!self.noise)
		self.noise = "env/amb/thunder1.ogg";
	if (!self.noise1)
		self.noise1 = "env/amb/thunder2.ogg";
	if (!self.noise2)
		self.noise2 = "env/amb/thunder3.ogg";

	precache_sound (self.noise1);
	precache_sound (self.noise2);
	precache_sound (self.noise3);

	if(!self.delay)
	self.delay = 10;
	if(!self.wait)
	self.wait = 10;

	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
	self.touch = trigger_lightning_touch;
	if(!self.using)
	self.using = 1;
	self.use = toggle_use;
};

.float time_fog;
.float falpha;
.float fade_control;
void() fogmodel_think =
{
	
	if (!self.cnt)
	{
	self.falpha += 0.005 / self.owner.fade_control;
	if(self.falpha >= 1)
	self.cnt = 1;
	}
	else
	{
	self.falpha -= 0.005 / self.owner.fade_control;
	if(self.falpha <= 0)
	remove(self);
	}

if(self.frame == 31)
	self.frame =0;
self.frame ++;

self.alpha = self.falpha * 0.25; 
/*	vector glight;
	glight = getlight (self.origin);
	self.colormod_x = glight_x - 0.05;
	self.colormod_y = glight_y - 0.05;
	self.colormod_z = glight_z - 0.05;
*/	
self.think = fogmodel_think;
self.nextthink = time + 0.025;
/*
if(self.origin_x > self.owner.absmax_x)
{remove(self);}

if(self.origin_x < self.owner.absmin_x)
{remove(self);}

if(self.origin_y > self.owner.absmax_y)
{remove(self);}

if(self.origin_y < self.owner.absmin_y)
{remove(self);}
*/
};
/*.float minv_z;
.float maxv_z;
void(entity powner) spawn_fog_emitter =
{
	local entity fogmodel;
	fogmodel = spawn ();
	fogmodel.owner = powner;
	fogmodel.origin_x = self.absmin_x + (random() *powner.size_x);
	fogmodel.origin_y = self.absmin_y + (random() *powner.size_y);
	fogmodel.origin_z = self.absmin_z;
	
	float r = random() * 8;
	
	if (r >= 7)
	setmodel (fogmodel, "particles/smoke_1.md3");
	if (r < 7)
	setmodel (fogmodel, "particles/smoke_2.md3");
	if (r < 6)
	setmodel (fogmodel, "particles/smoke_3.md3");
	if (r < 5)
	setmodel (fogmodel, "particles/smoke_4.md3");
	if (r < 4)
	setmodel (fogmodel, "particles/smoke_5.md3");
	if (r < 3)
	setmodel (fogmodel, "particles/smoke_6.md3");
	if (r < 2)
	setmodel (fogmodel, "particles/smoke_7.md3");
	if (r <= 1)
	setmodel (fogmodel, "particles/smoke_8.md3");
	fogmodel.movetype = MOVETYPE_NOCLIP;
	//fogmodel.effects = EF_ADDITIVE;// + EF_NODEPTHTEST;
	fogmodel.velocity_z = powner.minv_z + random() *(powner.maxv_z - powner.minv_z);
	fogmodel.scale = 0.75 + random() *0.5;
	fogmodel.falpha = random() * 0.1;
	fogmodel.alpha = fogmodel.falpha * 0.25;	
//	fogmodel.time_fog = random() *0.025;
	fogmodel.think = fogmodel_think;
	fogmodel.nextthink = time + 0.1; 
};
void()  func_fog_think;
.float oldcount;
.float spawnrate;

void()  func_fog_reset =
{
self.density = self.oldcount;
self.think = func_fog_think;
self.nextthink = time + (0.35 / self.count);
}

void()  func_fog_think =
{
//while (self.density > -1) 
//{
spawn_fog_emitter(self);
//self.density -= 1;
//}

self.think = func_fog_think; 
self.nextthink = time + ((random() *0.25) / self.count);
};

void()func_fog =
{
	setmodel(self, self.model);
//	if (!self.density)
//	self.density = 1;
	if(!self.minv_z)
	self.minv_z = 15;
	if(!self.maxv_z)
	self.maxv_z = 30;

	if(!self.fade_control)
	self.fade_control = 1;
	if(!self.count)
	self.count = 1; //((self.absmax_x - self.absmin_x)*(self.absmax_y - self.absmin_y)/8192) *self.density *0.5;
	self.oldcount = self.density;
	self.solid = SOLID_TRIGGER;
	//self.model = "";		
	self.think = func_fog_think;
	self.nextthink =time + 0.1;
};
*/
.vector valpha; //<min_alpha> <max_alpha> <fade_rate> (phade starts when lifetime is 0)
//.float count 
//.float gravity
.vector originjitter;
.vector originoffset;
.vector velocityjitter;
.vector velocityoffset;
.float min_time; //(lifetime random min limit)
.float max_time; //(lifetime random max limit)
.float min_size;
.float max_size;
.float model_ammount;
.string model1;
.string model2;
.string model3;
.string model4;
.string model5;
.string model6;
.string model7;
.string model8;
.float particle_movetype;
.float particle_modelflags;



void() spawned_model_alphafade =
{
	self.alpha -= self.owner.valpha_z / 20;
	if (self.alpha < self.owner.valpha_x)
		self.think = SUB_Remove;
	else
		self.think = spawned_model_alphafade;
	self.nextthink = time + 0.05;
};

void(entity powner) spawn_model_emitter =
{
	local entity spawned_model;
	spawned_model = spawn ();
	spawned_model.owner = powner;
	spawned_model.origin_x = spawned_model.owner.origin_x + (crandom() *spawned_model.owner.originjitter_x);
	spawned_model.origin_y = spawned_model.owner.origin_y +  (crandom() *spawned_model.owner.originjitter_y);
	spawned_model.origin_z = spawned_model.owner.origin_z +  (crandom() *spawned_model.owner.originjitter_z);
	
	spawned_model.origin += spawned_model.owner.originoffset;
	
	if(spawned_model.owner.model_ammount > 1)
	{
		float r = random() * spawned_model.owner.model_ammount;
		if (r >= 7)
			setmodel (spawned_model, spawned_model.owner.model8);
		if (r < 7)
			setmodel (spawned_model, spawned_model.owner.model7);
		if (r < 6)
			setmodel (spawned_model, spawned_model.owner.model6);
		if (r < 5)
			setmodel (spawned_model, spawned_model.owner.model5);
		if (r < 4)
			setmodel (spawned_model, spawned_model.owner.model4);
		if (r < 3)
			setmodel (spawned_model, spawned_model.owner.model3);
		if (r < 2)
			setmodel (spawned_model, spawned_model.owner.model2);
		if (r <= 1)
			setmodel (spawned_model, spawned_model.owner.model1);
	}
	else
		setmodel (spawned_model, spawned_model.owner.model1);
	
	
	spawned_model.movetype = powner.particle_movetype;
	
	spawned_model.modelflags = spawned_model.owner.particle_modelflags;
	if(spawned_model.owner.particlename)
	spawned_model.traileffectnum = particleeffectnum (spawned_model.owner.particlename);	
	spawned_model.gravity = spawned_model.owner.gravity;
	
	spawned_model.velocity += spawned_model.owner.velocityoffset;
	spawned_model.velocity_x += spawned_model.owner.velocityjitter_x * crandom();
	spawned_model.velocity_y += spawned_model.owner.velocityjitter_y * crandom();
	spawned_model.velocity_z += spawned_model.owner.velocityjitter_z * crandom();
	
	if(spawned_model.owner.max_size)
		spawned_model.scale = random(spawned_model.owner.min_size, spawned_model.owner.max_size);
	else
		spawned_model.scale = spawned_model.owner.min_size;

	if(spawned_model.owner.max_time)
		spawned_model.lifetime = random(spawned_model.owner.min_time, spawned_model.owner.max_time);
	else
		spawned_model.lifetime = spawned_model.owner.min_time;
	
	spawned_model.alpha = spawned_model.owner.valpha_y;

	spawned_model.think = spawned_model_alphafade;
	spawned_model.nextthink = time + spawned_model.lifetime; 
	
};

void()model_emitter_think =
{
	float localcount = self.count;
	if (self.using == 1)
	{
		while (localcount) 
		{
			//self.effects = EF_MUZZLEFLASH;
			spawn_model_emitter(self);
			localcount --;
		}
	}
	self.nextthink = time + self.delay;
	self.think = model_emitter_think;
};
void() model_emitter =
{
	setmodel(self,"models/misc/null.md3");
	if(!self.valpha)
		self.valpha = '0 1 1';
	if(!self.gravity)
		self.gravity = -0.1;
	if(!self.count)
		self.count = 1;	
	if(!self.min_time)
		self.min_time = 0.1;
	if(!self.max_time)
		self.max_time = self.min_time;
	if(!self.min_size)
		self.min_size = 1;
	if(!self.max_size)
		self.max_size = self.min_size ;
	if(!self.delay)
		self.delay = 0.5;
	if(!self.model1)
		self.model1 = "models/misc/null.md3";
	self.movetype = 0;	
	if(!self.particle_movetype)
		self.particle_movetype =MOVETYPE_NOCLIP;
	if(self.model1)
		self.model_ammount = 1;
	self.alpha = 0.25;	
	precache_model(self.model1);	
	if((self.model2) && (self.model_ammount == 1))
		{self.model_ammount = 2; precache_model(self.model2);}	
	if((self.model3) && (self.model_ammount == 2))
		{self.model_ammount = 3; precache_model(self.model3);}
	if((self.model4) && (self.model_ammount == 3))
		{self.model_ammount = 4; precache_model(self.model4);}
	if((self.model5) && (self.model_ammount == 4))
		{self.model_ammount = 5; precache_model(self.model5);}
	if((self.model6) && (self.model_ammount == 5))
		{self.model_ammount = 6; precache_model(self.model6);}
	if((self.model7) && (self.model_ammount == 6))
		{self.model_ammount = 7; precache_model(self.model7);}
	if((self.model8) && (self.model_ammount == 7))
		{self.model_ammount = 8; precache_model(self.model8);}
	if(!self.using)
		self.using = 1;
	self.use = toggle_use;
	self.think = model_emitter_think;
	self.nextthink = time;	
};


/*
#define VF_FOG_DENSITY        202 //(float)
#define VF_FOG_COLOR        203 //(vector)
#define VF_FOG_COLOR_R        204 //(float)
#define VF_FOG_COLOR_G        205 //(float)
#define VF_FOG_COLOR_B        206 //(float)
#define VF_FOG_ALPHA        207 //(float)
#define VF_FOG_START        208 //(float)
#define VF_FOG_END           209 //(float)
#define VF_FOG_HEIGHT        210 //(float)
#define VF_FOG_FADEDEPTH    211 //(float)
*/

float timing_fog;


float(float a, float b) always_pos_substract =
{
local float result;
result = max(a, b) - min (a, b);
return result;
}

.float n_fog_d;
.float n_fog_r;
.float n_fog_g;
.float n_fog_b;
.float n_fog_a;
.float n_fog_s;
.float n_fog_e;
.float n_fog_h;
.float n_fog_f;

.float tmp_fog_d;
.float tmp_fog_r;
.float tmp_fog_g;
.float tmp_fog_b;
.float tmp_fog_a;
.float tmp_fog_s;
.float tmp_fog_e;
.float tmp_fog_h;
.float tmp_fog_f;

.float r_fog_d;
.float r_fog_r;
.float r_fog_g;
.float r_fog_b;
.float r_fog_a;
.float r_fog_s;
.float r_fog_e;
.float r_fog_h;
.float r_fog_f;

void()trigger_fog_touch;

void() trigger_fog_think =
{
	self.count ++;
	if(self.count >= self.cnt)
	{
		self.think = SUB_Null;	
		self.touch = self.oldtouch;
		return;
	} 
	else
	{
		timing_fog = time + 0.1; 
		self.tmp_fog_d += self.r_fog_d;
		self.tmp_fog_r += self.r_fog_r;
		self.tmp_fog_g += self.r_fog_g;
		self.tmp_fog_b += self.r_fog_b;
		self.tmp_fog_a += self.r_fog_a;
		self.tmp_fog_s += self.r_fog_s;
		self.tmp_fog_e += self.r_fog_e;
		self.tmp_fog_h += self.r_fog_h;
		self.tmp_fog_f += self.r_fog_f;
		string strfog_a = strcat ("fog ",ftos(self.tmp_fog_d)," ",ftos(self.tmp_fog_r)," ", ftos(self.tmp_fog_g)," ",ftos(self.tmp_fog_b));
		string strfog_b = strcat (" ",ftos(self.tmp_fog_a)," ",ftos(self.tmp_fog_s)," ", ftos(self.tmp_fog_e)," ", ftos(self.tmp_fog_h));
		string strfog_c = strcat (" ",ftos(self.tmp_fog_f), "\n");
//		string strfog_b ="strcat (ftos(self.tmp_fog_a)";
//		string strfog_c ="\n";
	
		string strfog = strcat (strfog_a,strfog_b, strfog_c);
		//bprint (strfog);
		stuffcmd (self.enemy, strfog);
		self.think = trigger_fog_think;
	}
	vector fog_color = stov (cvar_string("_fog_color"));
	//local string lmessage;
	//lmessage =strcat ((ftos(fog_color_x)),("\n")) ;
	//bprint (lmessage);
	self.nextthink = time + 0.025;
};

void() trigger_fog_prethink =
{
	self.tmp_fog_d = stof(cvar_string ("_fog_d"));
	vector fog_color = stov (cvar_string("_fog_color"));
	self.tmp_fog_r = fog_color_x;
	self.tmp_fog_g = fog_color_y;
	self.tmp_fog_b = fog_color_z;
	self.tmp_fog_a = stof(cvar_string ("_fog_a"));
	self.tmp_fog_s = stof(cvar_string ("_fog_s"));
	self.tmp_fog_e = stof(cvar_string ("_fog_e"));
	self.tmp_fog_h = stof(cvar_string ("_fog_h"));
	self.tmp_fog_f = stof(cvar_string ("_fog_f"));


//	local string lmessage;
//	lmessage =strcat ((ftos(self.n_fog_a)),("\n")) ;
//	bprint (lmessage);

	self.cnt = self.wait / 0.025; 
 	self.count = -1;
	self.r_fog_d = (self.n_fog_d - self.tmp_fog_d) / (self.cnt);
	self.r_fog_r = (self.n_fog_r - self.tmp_fog_r) / (self.cnt);
	self.r_fog_g = (self.n_fog_g - self.tmp_fog_g) / (self.cnt);
	self.r_fog_b = (self.n_fog_b - self.tmp_fog_b) / (self.cnt);
	self.r_fog_a = (self.n_fog_a - self.tmp_fog_a) / (self.cnt);
	self.r_fog_s = (self.n_fog_s - self.tmp_fog_s) / (self.cnt);
	self.r_fog_e = (self.n_fog_e - self.tmp_fog_e) / (self.cnt);
	self.r_fog_h = (self.n_fog_h - self.tmp_fog_h) / (self.cnt);
	self.r_fog_f = (self.n_fog_f - self.tmp_fog_f) / (self.cnt);


	self.think = trigger_fog_think;
	self.nextthink = time +0.025;
};
	
.entity fog_trigger;
void() trigger_fog_touch =
{
	if (other.classname != "player")
		return;
	if(other.fog_trigger == self)
		return;
	if(timing_fog > time)
		return;
	other.fog_trigger = self;	
	self.enemy = other;
	stuffcmd (self.enemy,"get_fog\n");
	//stuffcmd (self.enemy,"impulse 99\n");
	self.touch = SUB_Null;


	self.think = trigger_fog_prethink;
	self.nextthink = time + 0.05;
};	

void() trigger_fog =
{	
	setmodel(self, self.model);
	self.solid = SOLID_TRIGGER;
	if(!self.wait)
		self.wait = 1;
	if(!self.n_fog_a)
		self.n_fog_a = 1;
	if(!self.n_fog_e)
		self.n_fog_e = 16384;
	if(!self.n_fog_h)
		self.n_fog_h = 1073741824;
	if(!self.n_fog_f)
		self.n_fog_f = 128;
	

	self.modelindex = 0;
	self.model = string_null;
	self.touch = trigger_fog_touch;
	self.oldtouch = self.touch;
};

//////////////////////end of qc file
