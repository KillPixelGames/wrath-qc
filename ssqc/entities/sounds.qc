.float atten;
.float maxpitch;
.float minpitch;
.float pitch;
void() soundbox_think;
void() soundbox_stop = 
{
	if (self.count)
		sound7(self, CHAN_VOICE, "misc/null.wav", 1, 1, 100, 0);
	else
	{
		sound(self, CHAN_VOICE, "misc/null.wav", 1, 1);
		remove(self);
	}

	self.use = soundbox_think;
};

void() soundbox_think = 
{
	local float spitch;
	self.cnt = soundlength(self.noise);
	if ((self.pitch) || (self.minpitch && self.maxpitch))
	{
		spitch = self.pitch * 100;
		if (self.minpitch && self.maxpitch)
		{
			spitch = (self.minpitch + self.maxpitch* random()) *100;
			self.cnt = self.cnt *(100 / spitch);
		}

		self.count = 1;
		sound7(self, CHAN_VOICE, self.noise, self.volume, self.atten, spitch, 0);
	}
	else
		sound(self, CHAN_VOICE, self.noise, self.volume, self.atten);
	if (self.delay > 0)
	{
		self.think = soundbox_think;
		self.nextthink = time + self.cnt + self.wait + (random() *self.delay);
		self.use = soundbox_stop;
	}
	else
		remove(self);
};

void() soundbox = 
{
	if (self.noise)
		precache_sound(self.noise);

	if (!self.delay)
	{
		self.delay = -1;
	}

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
	self.atten = attn;
	if ((self.targetname) && (!self.using))
		self.use = soundbox_think;
	else
	{
		if (self.delay >= 0)
		{
			if (!self.wait)
				self.wait = 1;
			self.think = soundbox_think;
			self.nextthink = time + self.wait;
		}
		else
			{
			float dev = cvar("showsoundspheres");
			if (dev == 1)
			{
			local entity visible_sound = spawn();
			visible_sound.origin = self.origin;
			visible_sound.alpha = 0.25;
			visible_sound.effects = 512 + EF_ADDITIVE +  EF_DOUBLESIDED;
			setmodel(visible_sound,"models/dev/sphere.md3");
			visible_sound.colormod = '0 0.3 2';
			visible_sound.scale = self.rad_sound  / 128;
			}		
			ambientsound(self.origin, self.noise, self.volume, attn);
			}
	}
};

.float attacksoundtime;
.float attacksnd2;
.float chatter_time;
.float chattersnd2;
.float msound_cnt1;
.float msound_cnt2;
.float msound_cnt3;
.float msound_cnt4;
.float msound_cnt5;
.float msound_cnt6;
void(entity e, float chan, string samp, float vol, float attenn) msound =
{
	sound(e, chan, samp, vol, attenn);
	//sound7(e, chan, samp, vol, attenn, STAT_RADIALACTIVE, FALSE);
};

void(string locsound) painsound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * FL_SWIM)) + TRUE;
	if ((r == self.painsnd))
	{
		r = r + TRUE;
	}
	if ((r > MOVETYPE_WALK))
	{
		r = TRUE;
	}
	self.painsnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, FL_SWIM, monstersound, TRUE, 0.25);
};

void(string locsound) attacksound =
{
	local float r;
	local string monstersound;
	local string rsound;

	if ((self.attacksoundtime > time))
	{
		return;
	}
	r = floor((random() * FL_SWIM)) + TRUE;
	if ((r == self.attacksnd))
	{
		r = r + TRUE;
	}
	if ((r > MOVETYPE_WALK))
	{
		r = TRUE;
	}
	self.attacksnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, TRUE, monstersound, TRUE, 0.25);
};

void(string locsound) attacksound2 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * FL_SWIM)) + TRUE;
	if ((r == self.attacksnd2))
	{
		r = r + TRUE;
	}
	if ((r > MOVETYPE_WALK))
	{
		r = TRUE;
	}
	self.attacksnd2 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, FL_SWIM, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd) walksound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.chattersnd))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	if ((self.classname == "monster_widow"))
	{
		msound(self, 4, monstersound, 0.5, 0.5);
	}
	else
	{
		msound(self, 4, monstersound, TRUE, 0.25);
	}
};

void(string locsound, float rnd, float vol) chattersound2 =
{
	local float r;
	local string monstersound;
	local string rsound;

	if ((self.chatter_time > time))
	{
		return;
	}
	if (!vol)
	{
		vol = TRUE;
	}
	r = floor((random() * rnd)) + TRUE;
	if ((r == self.chattersnd2))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.chattersnd2 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	self.chatter_time = (time + soundlength(monstersound));
	if ((self.classname == "monster_fallen"))
	{
		self.chatter_time = (((time + soundlength(monstersound)) + MOVETYPE_FLY) + (random() * MOVETYPE_FLY));
	}
	if ((self.classname == "monster_widow"))
	{
		self.chatter_time = (((time + soundlength(monstersound)) + MOVETYPE_FLY) + (random() * MOVETYPE_FLY));
	}
	if ((vol == 0.5))
	{
		msound(self, FL_SWIM, monstersound, vol, 0.5);
	}
	else
	{
		msound(self, FL_SWIM, monstersound, vol, 0.25);
	}
};

void(string locsound, float rnd, float vol) chattersound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.chattersnd))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	if ((vol == 0.5))
	{
		msound(self, FALSE, monstersound, TRUE, 0.5);
	}
	else
	{
		msound(self, FALSE, monstersound, TRUE, 0.25);
	}
};

void(string locsound, float rnd, float vol) randomsound =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt1))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt1 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, FALSE, monstersound, vol, 0.5);
};
.float rdmsound_cnt1;
void(vector org, string locsound, float rnd, float vol) randompointsound =
{
	local float r;
	local string samplesound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.rdmsound_cnt1))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.rdmsound_cnt1 = r;
	rsound = ftos(r);
	samplesound = strcat(locsound, rsound, ".ogg");
	pointsound(org, samplesound, vol, 0.5);
};

void(string locsound, float rnd, float vol, float nchannel, float iswav, float atten) randomsound2 =
{
	local float r;
	local string soundend;
	local string lsound;
	local string rsound;

	if (iswav)
	{
		soundend = ".wav";
	}
	else
	{
		soundend = ".ogg";
	}
	r = floor((random() * rnd)) + TRUE;
	if ((r == self.rsound_cntr))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.rsound_cntr = r;
	rsound = ftos(r);
	lsound = strcat(locsound, rsound, soundend);
	sound(self, nchannel, lsound, vol, atten);
};

void(string locsound, float vol, float nchannel, float iswav, float atten) alreadyrandomsound2 =
{
	local string soundend;
	local string lsound;
	local string rsound;

	if (iswav)
	{
		soundend = ".wav";
	}
	else
	{
		soundend = ".ogg";
	}
	rsound = ftos(self.rsound_cntr);
	lsound = strcat(locsound, rsound, soundend);
	sound(self, nchannel, lsound, vol, atten);
};

void(string locsound, float rnd, float nchannel) monstersound1 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt1))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt1 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	if ((self.classname == "monster_fallen"))
	{
		msound(self, nchannel, monstersound, 0.3, 0.25);
	}
	else
	{
		msound(self, nchannel, monstersound, TRUE, 0.25);
	}
};

void(string locsound, float rnd, float nchannel) monstersound2 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt2))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt2 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound3 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt3))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt3 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound4 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt4))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt4 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound5 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt5))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt5 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

void(string locsound, float rnd, float nchannel) monstersound6 =
{
	local float r;
	local string monstersound;
	local string rsound;

	r = floor((random() * rnd)) + TRUE;
	if ((r == self.msound_cnt6))
	{
		r = r + TRUE;
	}
	if ((r > rnd))
	{
		r = TRUE;
	}
	self.msound_cnt6 = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	msound(self, nchannel, monstersound, TRUE, 0.25);
};

.float shoot_sound;
.float sound_time;
void(string locsound, float rnd) weapon_sound =
{
	float r = floor(random() * rnd) + 1;
	if (r == self.shoot_sound)
		r = r + 1;
	if (r > rnd)
		r = 1;
	self.shoot_sound = r;
	string rsound = ftos(r);
	string weapon_sound = strcat(locsound, rsound, ".ogg");
	float current_sound_time = time + soundlength(weapon_sound);
	self.sound_time = current_sound_time;
	if(self.sound_time > time)
	{
		msound(self, CHAN_AUTO, weapon_sound, TRUE, 0.25);
	//	self.sound_time = 0;
	}
	else
		msound(self, CHAN_WEAPON, weapon_sound, TRUE, 0.25);
	
};



/////////////////end of qc file