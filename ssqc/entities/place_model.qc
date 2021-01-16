void() train_next;
void() func_train_find;
void() mercenary_test_think;
void(entity e, vector r) setsizeitem;

void() train_blocked = 
{
	if (time < self.attack_finished)
		return;
	self.attack_finished = time + 0.5;
	T_Damage(other, self, self, self.dmg);
};

void() train_use = 
{
	if ((self.think == train_next) && (self.wait == -1))
	{
		train_next();
		return;
	}

	if ((self.think != func_train_find) && (self.wait != -1))
		return;	// already activated
	train_next();
};

void() train_wait = 
{
	if (self.wait)
	{
		self.nextthink = self.ltime + self.wait;
		sound(self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	}
	else
		self.nextthink = self.ltime + 0.1;
	self.think = train_next;
};

void() train_next = 
{
	local vector fang;
	local entity targ;
	targ = find(world, targetname, self.target);
	self.target = targ.target;
	if (!self.target)
		objerror("train_next: no next target");
	if (targ.wait)
		self.wait = targ.wait;
	else
		self.wait = 0;
	sound(self, CHAN_VOICE, self.noise1, 1, ATTN_NORM);
	SUB_CalcMove(targ.origin - self.mins, self.speed, train_wait);
	if ((self.classname == "place_model") || (self.classname == "test_afflicted"))
	{
		fang = normalize(targ.origin - self.origin);
		makevectors(self.angles);
		self.angles = vectoangles(fang);
	}
};

void() func_train_find = 
{
	local entity targ;
	targ = find(world, targetname, self.target);
	self.target = targ.target;
	setorigin(self, targ.origin - self.mins);
	if (!self.targetname)
	{
		// not triggered, so start immediately
		self.nextthink = self.ltime + 0.1;
		self.think = train_next;
	}
};

void() func_train = 
{
	if (!self.speed)
		self.speed = 100;
	if (!self.target)
		objerror("func_train without a target");
	if (!self.dmg)
		self.dmg = 2;
	if (self.sounds == 0)
	{
		self.noise = ("misc/null.wav");
		precache_sound("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound("misc/null.wav");
	}

	if (self.sounds == 1)
	{
		self.noise = ("plats/train2.wav");
		precache_sound("plats/train2.wav");
		self.noise1 = ("plats/train1.wav");
		precache_sound("plats/train1.wav");
	}

	self.cnt = 1;
	self.solid = SOLID_BSP;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.classname = "train";
	setmodel(self, self.model);
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);
	// start trains on the second frame, to make sure their targets have had
	// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

void() misc_teleporttrain = 
{
	if (!self.speed)
		self.speed = 100;

	if (!self.target)
		objerror("func_train without a target");

	self.cnt = 1;
	self.solid = SOLID_NOT;
	self.movetype = MOVETYPE_PUSH;
	self.blocked = train_blocked;
	self.use = train_use;
	self.avelocity = '100 200 300';

	self.noise = ("misc/null.wav");
	precache_sound("misc/null.wav");
	self.noise1 = ("misc/null.wav");
	precache_sound("misc/null.wav");

	precache_model2("progs/teleport.mdl");
	setmodel(self, "progs/teleport.mdl");
	setsize(self, self.mins, self.maxs);
	setorigin(self, self.origin);

	// start trains on the second frame, to make sure their targets have had
	// a chance to spawn
	self.nextthink = self.ltime + 0.1;
	self.think = func_train_find;
};

void() null = {};

void() mercenaryanim = 
{
	self.frame += 1;
	if (self.frame >= 98)
		self.frame = 1;
	if (self.frame == 32)
	{
		local float ntag, nparticles;
		local vector shootorg;
		ntag = gettagindex(self, "tag_muzzle");
		shootorg = gettaginfo(self, ntag);
		sound(self, CHAN_WEAPON, "weapons/coachgun/fire1_1.ogg", 1, ATTN_NORM);
		nparticles = particleeffectnum("mercenary_fire");
		pointparticles(nparticles, shootorg, '0 0 0', 10);
	}

	self.think = mercenaryanim;
	self.nextthink = time + 0.1;
};

void() place_model = 
{
	precache_model(self.model);
	setmodel(self, self.model);
	if (self.model == "models/enemies/mercenary/mercenary.md3")
		mercenaryanim();
	if (self.target)
	{
		if (!self.speed)
			self.speed = 100;
		self.cnt = 1;
		self.movetype = MOVETYPE_PUSH;
		self.blocked = train_blocked;
		self.use = train_use;
		self.bloody = 1;
		self.solid = SOLID_SLIDEBOX;
		self.takedamage = DAMAGE_YES;
		self.noise = ("misc/null.wav");
		precache_sound("misc/null.wav");
		self.noise1 = ("misc/null.wav");
		precache_sound("misc/null.wav");
		self.health = 1000000000000000000;
		self.th_die = null;
		setsize(self, '-24 -24 0', '24 24 96');
		setorigin(self, self.origin);
		self.nextthink = self.ltime + 0.1;
		self.think = func_train_find;
	}
};

void() mercenary_test_think2 = 
{
	self.colormod = '0 0 3';
	local float acframe;
	acframe = self.frame + 1;
	if (acframe >= 155)
	{
		self.think = mercenary_test_think;
		self.frame = 11;
	}
	else
	{
		self.think = mercenary_test_think2;
		self.frame = acframe;
	}

	self.nextthink = time + 0.1;
};

void() mercenary_test_think = 
{
	self.colormod = '0 3 0';
	local float acframe;
	acframe = self.frame + 1;
	if (acframe >= 25)
	{
		self.think = mercenary_test_think2;
		self.frame = 140;
	}
	else
	{
		self.think = mercenary_test_think;
		self.frame = acframe;
	}

	self.nextthink = time + 0.1;
};

void() mercenary_test = 
{
	self.frame = 11;
	precache_model("models/enemies/mercenary/mercenary.md3");
	setmodel(self, "models/enemies/mercenary/mercenary.md3");
	self.think = mercenary_test_think;
	self.nextthink = time + 0.1;
}

string testmodel;
void() test_model_frik = 
{
	local float readparms;
	readparms = fopen("map/test_model.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	testmodel = strzone(fgets(readparms));
	fclose(readparms);
};

void() test_model = 
{
	test_model_frik();
	self.model = testmodel;
	precache_model(testmodel);
	setmodel(self, testmodel);
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_YES;
	if (!self.health)
		self.health = 100;
	self.th_die = SUB_Remove;

	if (self.target)
	{
		if (!self.speed)
			self.speed = 100;
		self.cnt = 1;
		self.movetype = MOVETYPE_PUSH;
		self.blocked = train_blocked;
		self.use = train_use;
		self.solid = SOLID_SLIDEBOX;
		setorigin(self, self.origin);
		self.nextthink = self.ltime + 0.1;
		self.think = func_train_find;
	}
};
.entity cyst1;
.entity cyst2;
.entity cyst3;
.entity cyst4;
void() cys_explode1b;

void() CyExplosionBody = 
{
	local entity newcyst;


	vector tagorg;
	if(self.owner.flags & FL_MONSTER)
		tagorg = gettaginfo(self.tag_entity, self.tag_index);
	else
		tagorg = self.origin;
	remove(self);
	
	newcyst = spawn();
	setorigin(newcyst, tagorg);
	newcyst.scale = 0.25;
	setmodel(newcyst, "particles/explo/explo_cyst.md3");
	local float skinn;
	skinn = ceil(random() *4);
	if (skinn == 4)
		skinn = 0;
	newcyst.skin = skinn * 10;
	local string snd;
	snd = strcat("impact/projectiles/cyst_explo", ftos(floor(random() *5) + 1), ".ogg");
	sound(newcyst, CHAN_AUTO, snd, 1, 0.25);


	if(self.owner.flags & FL_MONSTER)
	{
		makevectors(self.owner.angles);
		if (self.owner.health > 0)
			pointparticles(particleeffectnum("cystbody"), tagorg, (v_forward *16), 1);
	}
	newcyst.think = cys_explode1b;
	newcyst.nextthink = time + 0.1;
};

.float cyst_flag;
.float cyst_rate_scale;
.float cyst_rate_glowmod;

void() cyst_think = 
{
	if (self.cyst_flag)
	{
		self.scale -= self.cyst_rate_glowmod / 2;
		self.glowmod_x -= self.cyst_rate_glowmod;
		self.glowmod_y -= self.cyst_rate_glowmod;
		self.glowmod_z -= self.cyst_rate_glowmod;

		if (self.glowmod_x <= 0.5)
			self.cyst_flag = 0;
	}
	else
	{
		self.scale += self.cyst_rate_glowmod / 2;

		self.glowmod_x += self.cyst_rate_glowmod;
		self.glowmod_y += self.cyst_rate_glowmod;
		self.glowmod_z += self.cyst_rate_glowmod;

		if (self.glowmod_x >= 1)
			self.cyst_flag = 1;
	}

	if (self.cnt == 1)
	{
		if (self.owner.health < (afflictedhealth - (afflictedhealth / 100) *20))
			self.think = CyExplosionBody;
		else
			self.think = cyst_think;
	}

	if (self.cnt == 2)
	{
		if (self.owner.health < (afflictedhealth - (afflictedhealth / 100) *40))
			self.think = CyExplosionBody;
		else
			self.think = cyst_think;
	}

	if (self.cnt == 3)
	{
		if (self.owner.health < (afflictedhealth - (afflictedhealth / 100) *60))
			self.think = CyExplosionBody;
		else
			self.think = cyst_think;
	}

	if (self.cnt == 4)
	{
		if (self.owner.health < (afflictedhealth - (afflictedhealth / 100) *80))
			self.think = CyExplosionBody;
		else
			self.think = cyst_think;
	}

	self.nextthink = time + 0.05;
};

void(entity e) spawn_cysts = 
{
	local entity cst1, cst2, cst3, cst4;

	cst1 = spawn();
	cst2 = spawn();
	cst3 = spawn();
	cst4 = spawn();

	cst1.owner = e;
	cst2.owner = e;
	cst3.owner = e;
	cst4.owner = e;

	cst1.cyst_rate_glowmod = 0.025 + (0.025* random());
	cst2.cyst_rate_glowmod = 0.025 + (0.025* random());
	cst3.cyst_rate_glowmod = 0.025 + (0.025* random());
	cst4.cyst_rate_glowmod = 0.025 + (0.025* random());

	cst1.cyst_rate_scale = 0.025;
	cst2.cyst_rate_scale = 0.025;
	cst3.cyst_rate_scale = 0.025;
	cst4.cyst_rate_scale = 0.025;

	cst1.count = 1;
	cst2.count = 2;
	cst3.count = 3;
	cst4.count = 4;

	setmodel(cst1, "models/enemies/afflicted/cyst_a.md3");
	setmodel(cst2, "models/enemies/afflicted/cyst_b.md3");
	setmodel(cst3, "models/enemies/afflicted/cyst_c.md3");
	setmodel(cst4, "models/enemies/afflicted/cyst_d.md3");

	setattachment(cst1, e, "tag_a");
	setattachment(cst2, e, "tag_b");
	setattachment(cst3, e, "tag_c");
	setattachment(cst4, e, "tag_d");

	local float pos;

	pos = ceil((random() *5) + 1);
	if (pos > 5)
		pos = 5;

	if (pos == 1)
	{
		cst1.cnt = 4;
		cst2.cnt = 3;
		cst3.cnt = 2;
		cst4.cnt = 1;
	}

	if (pos == 2)
	{
		cst1.cnt = 3;
		cst2.cnt = 4;
		cst3.cnt = 2;
		cst4.cnt = 1;
	}

	if (pos == 3)
	{
		cst1.cnt = 2;
		cst2.cnt = 3;
		cst3.cnt = 4;
		cst4.cnt = 1;
	}

	if (pos == 4)
	{
		cst1.cnt = 1;
		cst2.cnt = 2;
		cst3.cnt = 4;
		cst4.cnt = 3;
	}

	if (pos == 5)
	{
		cst1.cnt = 1;
		cst2.cnt = 2;
		cst3.cnt = 3;
		cst4.cnt = 4;
	}

	cst1.think = cyst_think;
	cst2.think = cyst_think;
	cst3.think = cyst_think;
	cst4.think = cyst_think;

	cst1.scale = 0.75;
	cst2.scale = 0.75;
	cst3.scale = 0.75;
	cst4.scale = 0.75;

	cst1.glowmod = '0.5 0.5 0.5';
	cst2.glowmod = '0.5 0.5 0.5';
	cst3.glowmod = '0.5 0.5 0.5';
	cst4.glowmod = '0.5 0.5 0.5';

	cst1.nextthink = time + random();
	cst2.nextthink = time + random();
	cst3.nextthink = time + random();
	cst4.nextthink = time + random();
};

void() test_afflicted = 
{
	precache_model("models/enemies/afflicted/afflicted_animtest.md3");
	setmodel(self, "models/enemies/afflicted/afflicted_animtest.md3");
	self.solid = SOLID_SLIDEBOX;
	self.takedamage = DAMAGE_YES;
	self.health = 100;
	self.th_die = null;
	setsize(self, '-16 -16 0', '16 16 64');
	if (!self.style)
		spawn_cysts(self);
	self.classname = "test_afflicted";
	if (self.target)
	{
		if (!self.speed)
			self.speed = 100;
		self.cnt = 1;
		self.movetype = MOVETYPE_PUSH;
		self.blocked = train_blocked;
		self.use = train_use;
		self.solid = SOLID_SLIDEBOX;
		setorigin(self, self.origin);
		self.nextthink = self.ltime + 0.1;
		self.think = func_train_find;
	}
};
void() TorchAmbient = 
{
	ambientsound(self.origin, self.noise, 1, 0.5);
};
void() object_torch1 = 
{
	precache_model("models/objects/fixtures/torch1.md3");
	precache_sound("fx/fire1.ogg");
	precache_sound("fx/fire2.ogg");
	setmodel(self, "models/objects/fixtures/torch1.md3");
	setsize(self, '-4 -4 -8', '4 4 8');
	if (!self.skin)
		self.noise = "fx/fire1.ogg";
	else
		self.noise = "fx/fire2.ogg";
	TorchAmbient();

}

void() object_fire1 = 
{
	precache_model("models/objects/fixtures/fire1.md3");
		precache_sound("fx/fire1.ogg");
		precache_sound("fx/fire2.ogg");
		setmodel(self, "models/objects/fixtures/fire1.md3");
		setsize(self, '-4 -4 -8', '4 4 8');
		if (!self.skin)
			self.noise = "fx/fire1.ogg";
		else
			self.noise = "fx/fire2.ogg";
		TorchAmbient();

	}

	.float sizeflag;
.string dmodel;
.string gibmodel1;
.string gibmodel2;
.string gibmodel3;
.string gibmodel4;

.vector tagorigin;
void(string tagname, entity e) setoriginbytag = 
{
	local vector tagorg;
	local float tagindex;
	tagindex = gettagindex(e, tagname);
	tagorg = gettaginfo(e, tagindex);
	e.tagorigin = tagorg;
};
vector(vector rvel, entity ent) relvel;

void(string gibtagname, string gibmodel, entity ownr, vector gvel) spawngibs = 
{
	local entity gib;
	gib = spawn();
	gib.owner = ownr;
	setmodel(gib, gibmodel);
	gib.solid = SOLID_TRIGGER;
	gib.movetype = MOVETYPE_BOUNCE;
	gib.bouncefactor = 0.35;
	setoriginbytag(gibtagname, ownr);
	setsize(gib, '-0 -0 -0', '0 0 0');
	gib.origin = ownr.tagorigin;
	gib.velocity = gvel;
	gib.alpha = 1;
	gib.think = gibalphafade;
	gib.nextthink = time + 10 + (random() *10);
};

void(string locsound, float rndl, float vol) randomsound;

void(vector org, string class, float ammount, entity ownr) drop_item;

.float urn_armor;
.float urn_health;
.float urn_ammo;
.float urn_artifacts;
void() urn_die = 
{
	local vector tagorg;
	local float tagindex;
	local string tagname;
	tagname = ("tag_item");tagindex = gettagindex(self, tagname);tagorg = gettaginfo(self, tagindex);
	if (self.classname == "breakable_urn_small")
	{
		pointparticles(particleeffectnum("urn1"), tagorg, '0 0 0', 1);
		spawngibs("tag_giba", self.gibmodel1, self, relvel('-15 15  0', self));
		spawngibs("tag_gibb", self.gibmodel2, self, relvel('20 10  0', self));
		spawngibs("tag_gibc", self.gibmodel3, self, relvel('-15 -15  0', self));
		spawngibs("tag_gibc", self.gibmodel4, self, relvel('20 -20  0', self));
	}

	if (self.classname == "breakable_urn_medium")
	{
		pointparticles(particleeffectnum("urn2"), tagorg, '0 0 0', 1);
		spawngibs("tag_giba", self.gibmodel1, self, relvel('-20 20  0', self));
		spawngibs("tag_gibb", self.gibmodel2, self, relvel('20 -20  0', self));
		spawngibs("tag_gibc", self.gibmodel3, self, relvel('-20 -20  0', self));
		spawngibs("tag_gibd", self.gibmodel4, self, relvel('20 20  0', self));
	}

	if (self.classname == "breakable_urn_large")
	{
		pointparticles(particleeffectnum("urn3"), tagorg, '0 0 0', 1);
		spawngibs("tag_giba", self.gibmodel1, self, relvel('-30 30  0', self));
		spawngibs("tag_gibb", self.gibmodel2, self, relvel('0 -60  0', self));
		spawngibs("tag_gibc", self.gibmodel3, self, relvel('30 30  0', self));
		spawngibs("tag_gibd", self.gibmodel4, self, relvel('30 -30  0', self));
	}

	randomsound("impact/destruct/urn_break", 5, 1);

	if (self.urn_health == 1)
		drop_item(tagorg, "vial", 1, self);
	if (self.urn_health == 2)
		drop_item(tagorg, "beaker", 1, self);

	if (self.urn_armor == 1)
		drop_item(tagorg, "armor", 1, self);
	if (self.urn_armor == 2)
		drop_item(tagorg, "shard", 1, self);
	if (self.urn_armor == 3)
		drop_item(tagorg, "helm", 1, self);

	if (self.urn_ammo == 1)
		drop_item(tagorg, "slugs", 17, self);
	if (self.urn_ammo == 2)
		drop_item(tagorg, "shells", 20, self);
	if (self.urn_ammo == 3)
		drop_item(tagorg, "fangs", 1, self);
	if (self.urn_ammo == 4)
		drop_item(tagorg, "cyst", 9, self);

	if (self.urn_artifacts == 2)
		drop_item(tagorg, "apparatus", 1, self);
	if (self.urn_artifacts == 4)
		drop_item(tagorg, "attar", 1, self);
	if (self.urn_artifacts == 5)
		drop_item(tagorg, "theter", 1, self);
	if (self.urn_artifacts == 6)
		drop_item(tagorg, "siphon", 1, self);
	if (self.urn_artifacts == 8)
		drop_item(tagorg, "aegis", 1, self);

	setmodel(self, self.dmodel);
	self.solid = SOLID_NOT;
	setsize(self, '0 0 0', '0 0 0');
};
void() breakable_urn_small = 
{
	precache_model("models/destruct/urns/urn32.md3");
	precache_model("models/destruct/urns/urn32_destroyed.md3");
	precache_sound("impact/destruct/urn_break1.ogg");
	precache_sound("impact/destruct/urn_break2.ogg");
	precache_sound("impact/destruct/urn_break3.ogg");
	precache_sound("impact/destruct/urn_break4.ogg");
	precache_sound("impact/destruct/urn_break5.ogg");

	self.gibmodel1 = ("models/destruct/urns/urn32_gibs/urn32_giba.md3");
	self.gibmodel2 = ("models/destruct/urns/urn32_gibs/urn32_gibb.md3");
	self.gibmodel3 = ("models/destruct/urns/urn32_gibs/urn32_gibc.md3");
	self.gibmodel4 = ("models/destruct/urns/urn32_gibs/urn32_gibd.md3");
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);

	if (!self.health)
		self.health = 10;
	setmodel(self, "models/destruct/urns/urn32.md3");
	setsize(self, '-12 -12 0', '12 12 32');
	self.dmodel = "models/destruct/urns/urn32_destroyed.md3";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	self.th_die = urn_die;
	self.takedamage = DAMAGE_YES;
};
void() breakable_urn_medium = 
{
	self.gibmodel1 = ("models/destruct/urns/urn48_gibs/urn48_giba.md3");
	self.gibmodel2 = ("models/destruct/urns/urn48_gibs/urn48_gibb.md3");
	self.gibmodel3 = ("models/destruct/urns/urn48_gibs/urn48_gibc.md3");
	self.gibmodel4 = ("models/destruct/urns/urn48_gibs/urn48_gibd.md3");
	precache_sound("impact/destruct/urn_break1.ogg");
	precache_sound("impact/destruct/urn_break2.ogg");
	precache_sound("impact/destruct/urn_break3.ogg");
	precache_sound("impact/destruct/urn_break4.ogg");
	precache_sound("impact/destruct/urn_break5.ogg");
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);

	precache_model("models/destruct/urns/urn48.md3");
	precache_model("models/destruct/urns/urn48_destroyed.md3");
	if (!self.health)
		self.health = 10;
	setmodel(self, "models/destruct/urns/urn48.md3");
	setsize(self, '-16 -16 0', '16 16 48');
	self.dmodel = "models/destruct/urns/urn48_destroyed.md3";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	self.th_die = urn_die;
	self.takedamage = DAMAGE_YES;
};
void() breakable_urn_large = 
{
	self.gibmodel1 = ("models/destruct/urns/urn64_gibs/urn64_giba.md3");
	self.gibmodel2 = ("models/destruct/urns/urn64_gibs/urn64_gibb.md3");
	self.gibmodel3 = ("models/destruct/urns/urn64_gibs/urn64_gibc.md3");
	self.gibmodel4 = ("models/destruct/urns/urn64_gibs/urn64_gibd.md3");
	precache_sound("impact/destruct/urn_break1.ogg");
	precache_sound("impact/destruct/urn_break2.ogg");
	precache_sound("impact/destruct/urn_break3.ogg");
	precache_sound("impact/destruct/urn_break4.ogg");
	precache_sound("impact/destruct/urn_break5.ogg");
	precache_model(self.gibmodel1);
	precache_model(self.gibmodel2);
	precache_model(self.gibmodel3);
	precache_model(self.gibmodel4);
	precache_model("models/destruct/urns/urn64.md3");
	precache_model("models/destruct/urns/urn64_destroyed.md3");
	if (!self.health)
		self.health = 10;
	setmodel(self, "models/destruct/urns/urn64.md3");
	setsize(self, '-16 -16 0', '16 16 64');
	self.dmodel = "models/destruct/urns/urn64_destroyed.md3";
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_TOSS;
	self.th_die = urn_die;
	self.takedamage = DAMAGE_YES;
};

.entity lastchain;
.float degrees_chain_constant;
.float degrees_chain;
.float hard_degrees;
.float distancetotarget;
.float fixed_angles;
void()create_chain =
{
	self.count ++;
	self.degrees_chain += self.degrees_chain_constant;
	local entity chain;
	chain = spawn();
	setmodel (chain, "models/chain.md3");
	chain.scale = 2;
	chain.effects = EF_NODEPTHTEST;
	chain.angles = self.lastchain.angles + '0 0 90';
	chain.angles_x = self.hard_degrees - self.degrees_chain;
	chain.origin = tag_origin("tag_chain", self.lastchain);
	self.lastchain = chain;

	if(self.count < self.cnt)
		self.think = create_chain;
	else
		self.think = SUB_Null;
	self.nextthink = time + 0.005;
};
void() info_chain_spot =
{
	setmodel (self, "models/chain.md3");
}
void() info_chain_think =
{
	entity t = find(world, targetname, self.target);
	self.height = 34;
	setsize (self, '0 0 0', '0 0 0');
	self.distancetotarget =  vlen (self.origin - t.origin);
	self.scale = 2;
	self.angles = vectoangles (normalize(self.origin - t.origin));
	//self.angles_y += 180;
	self.lastchain = self;
	self.cnt = vlen (self.origin - t.origin);

	float rel = vlen(self.origin - t.origin) / (self.height);
	self.hard_degrees = (self.height  / self.distancetotarget) *  180 + self.angles_x;
	float a = self.height;
	float b = self.cnt /2;
	float radio= ((pow(a,2)) + (pow(b,2))) / (2*a); 
	float circunferencia = 2 * PI * radio;
	float angulos = (acos(((self.cnt * self.cnt) - (radio*radio)- (radio*radio)) / (-2*radio*radio)) )* RAD2DEG;
	float arco=  (2* PI * radio * angulos) / 360;
	self.cnt = (arco / 5.2) - 1;
	self.degrees_chain_constant =  angulos /self.cnt;
	self.think = create_chain;
	self.nextthink = time + 0.5;
}
void() info_chain =
{
	precache_model ("models/chain.md3");
	setmodel (self, "models/chain.md3");
	self.solid = SOLID_TRIGGER;
	self.think = info_chain_think;
	self.nextthink = time + 0.5;
};


/////////////////end of qc file