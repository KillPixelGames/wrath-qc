.float deadwaiting;
.float melee_jump_time;
.float melee_released;
.float timefly;
.float watertype_time;
.float dmgtime;
.float underwaterdamaged;
.float location;
void() W_SetWeapon;
void() Think_Vweapon;
void() info_player_start = {	//if(!self.location)
	//self.effects = 1024 + 128;
};
void() info_player_deathmatch = {	//if(!self.location)
	//self.effects = 1024 + 128;
};
void() ClientKill = {};
void() ClientConnect = {};
void() ClientDisconnect = {};
void() WeaponFrames;
void() raise_weapon;
void(string locsound, float rnd) playersound = { local float r;
	local string monstersound, rsound;
	r = floor(random() *rnd) + 1;
	if (r == self.chattersnd)
		r += 1;
	if (r > rnd)
		r = 1;
	self.chattersnd = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	sound(self, CHAN_AUTO, monstersound, 1, 1);
};
.float psound_cnt;

void(string locsound, float rnd, float nchannel) playersound2 = { local float r;
	local string monstersound, rsound;

	r = floor(random() *rnd) + 1;
	if (r == self.psound_cnt)
		r += 1;
	if (r > rnd)
		r = 1;

	self.psound_cnt = r;
	rsound = ftos(r);
	monstersound = strcat(locsound, rsound, ".ogg");
	sound(self, nchannel, monstersound, 1, ATTN_NORM);
};

void() delete_shrine = { local float writeparms;
	local string writethis;
	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/shrine.txt");
	writeparms = fopen(campaignloc, FILE_WRITE);	//open what file to use in write mode
	writethis = ftos(0);	//prepare the next thing to write
	fputs(writeparms, writethis);	//line 1
	fputs(writeparms, "\n");	//and again
	fclose(writeparms);
};

.float playerdeadtime;
void() PlayerDeathThink;
void() Player_Die = { delete_shrine();
	if (self.health >= 0)
		self.health = -1;
	self.use = SUB_Null;
	self.solid = SOLID_CORPSE;
	self.takedamage = 0;
	self.think = PlayerDeathThink;
	self.nextthink = time + 0.1;
	self.playerdeadtime = time + 100000000;
	self.deadflag = DEAD_DEAD;
	self.deadwaiting = time + 0.1;
	remove(self.vweapon);
	if (self.waterlevel >= 3)
		playersound("player/die_underwater", 2);
	else
		playersound("player/die", 5);
};

//void(string snd, float r, float vol) playersound;

void(entity attacker, float dmg) Player_Pain = { if (self.pain_finished > time)
		return;
	self.pain_finished = time + 0.25;
	if (self.waterlevel >= 3)
	{
		self.underwaterdamaged = 1;
		playersound("player/hurt_underwater", 3);
	}
	else
		playersound("player/hurt", 5);

};

void() PlayerDeathThink = { local float forward;
	if ((self.flags &FL_ONGROUND))
	{
		forward = vlen(self.velocity);
		forward = forward - 20;
		if (forward <= 0)
			self.velocity = '0 0 0';
		else
			self.velocity = forward* normalize(self.velocity);
	}

	self.health = -100;
	if (self.waterlevel >= 3)
	{
		self.gravity = 0;
		self.velocity = '0 0 0';
	}

	// wait for all buttons released

	// wait for any button down

	if (self.deadwaiting > time)
		self.deadmenuflag = 0;
	else
		self.deadmenuflag = 1;

	if (deathmatch != 1)
		localcmd("slowmo 0.1\n");
	localcmd("r_glsl_saturation 0\n");
	localcmd("v_cshift\n");

	if (self.deadflag == DEAD_DEAD)
	{
		//if (self.button2 || self.button1 || self.button0)
		//	return;
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

	self.think = SUB_Null;
	self.nextthink = time;
	if (deathmatch)
	{
		self.deadmenuflag = 0;

		if (self.deadwaiting > time)
			return;
		if (!self.button2 && !self.button1 && !self.button0)
			return;
		self.button0 = 0;
		self.button1 = 0;
		self.button2 = 0;
		self.button3 = 0;
		self.button4 = 0;
		self.button5 = 0;
		PutClientInServer();
	}
};

void() PlayerJump = { if (self.flags &FL_WATERJUMP)
		return;
	if (self.waterlevel >= 2)
	{
		if (self.watertype == CONTENT_WATER)
			self.velocity_z = 100;
		else if (self.watertype == CONTENT_SLIME)
			self.velocity_z = 80;
		else
			self.velocity_z = 100;
		// play swiming sound
		if (self.swim_flag < time)
		{
			self.swim_flag = time + 1;
			//if (random() < 0.5)
			//	sound (self, CHAN_BODY, "misc/water1.wav", 1, ATTN_NORM);
			//else
			//	sound (self, CHAN_BODY, "misc/water2.wav", 1, ATTN_NORM);
		}

		return;
	}

	if (!(self.flags &FL_ONGROUND))
		return;
	self.melee_released = 0;
	if (!(self.flags &FL_JUMPRELEASED))
		return;	// don't pogo stick
	self.flags = self.flags - (self.flags &FL_JUMPRELEASED);
	self.flags = self.flags - FL_ONGROUND;	// don't stairwalk
	self.button2 = 0;
	local float fsnd;
	fsnd = (floor(random() *3) + 1);
	if (fsnd == self.jmpsound)
		fsnd = self.jmpsound + 1;
	if (fsnd > 3)
		fsnd = 1;
	self.jmpsound = fsnd;
	playerjumpsound();
	//	local string snd;
	//	snd = strcat ("player/jump", ftos (fsnd),".ogg");
	//	sound (self, CHAN_VOICE, snd, 1, ATTN_NORM);
	self.velocity_z += 270;
};
.float underwater_time;
.float jumpinwater;
.float jumpinwatertime;
void() WaterMove = { if (self.movetype == MOVETYPE_NOCLIP)
		return;
	if (self.health < 0)
		return;
	if ((self.waterlevel < 3) && (self.underwater_time > time))
	{
		if (self.underwaterdamaged == 1)
			playersound2("player/cough", 5, CHAN_VOICE2);
		else
			playersound2("player/breathe", 3, CHAN_VOICE2);
		playersound2("player/water_surfacing", 3, CHAN_AUTO);
		self.underwaterdamaged = 0;
		self.underwater_time = 0;
	}

	if (self.waterlevel != 3)
	{
		if (self.air_finished < time)
			playersound("player/hurt_underwater", 3);
		self.air_finished = time + 12;
		self.dmg = 2;
	}
	else if (self.air_finished < time)
	{
		// drown!
		if ((self.pain_finished < time) && (self.DrownerApp_time < time))
		{
			self.dmg = self.dmg + 2;
			if (self.dmg > 15)
				self.dmg = 10;
			local entity badwater;
			badwater = spawn();
			setmodel(badwater, "");
			badwater.classname = "badwater";
			T_Damage(self, badwater, badwater, self.dmg);
			remove(badwater);
			self.pain_finished = time + 1;
		}
	}

	if (!self.waterlevel)
	{
		if (self.flags &FL_INWATER)
		{
			// play leave water sound
			playersound2("player/water_exit", 3, CHAN_VOICE);
			self.jumpinwater = 0;
			self.jumpinwatertime = time + 1;
			self.flags = self.flags - FL_INWATER;
		}

		return;
	}

	if (self.watertype == CONTENT_LAVA)
	{
		// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + 1;
			else
				self.dmgtime = time + 0.2;
			T_Damage(self, world, world, 10 *self.waterlevel);
		}
	}
	else if (self.watertype == CONTENT_SLIME)
	{
		// do damage
		if (self.dmgtime < time && self.radsuit_finished < time)
		{
			self.dmgtime = time + 1;
			T_Damage(self, world, world, 4 *self.waterlevel);
		}
	}

	if (!(self.flags &FL_INWATER))
	{
		// player enter water sound
		/*if (self.watertype == CONTENT_LAVA)
			sound (self, CHAN_VOICE, "player/water_enter1.ogg", 1, ATTN_NORM);
		if (self.watertype == CONTENT_WATER)
			sound (self, CHAN_VOICE, "player/water_enter1.ogg", 1, ATTN_NORM);
		if (self.watertype == CONTENT_SLIME)
			sound (self, CHAN_VOICE, "player/water_enter1.ogg", 1, ATTN_NORM);
		*/
		playersound2("player/water_surfacing", 3, CHAN_AUTO);
		self.jumpinwater = 1;
		self.jumpinwatertime = time + 1;
		self.flags = self.flags + FL_INWATER;
		self.underwater_time = 0;
		self.dmgtime = 0;
	}

	if (self.waterlevel >= 3)
	{
		if (self.underwater_time < time)
		{
			sound(self, CHAN_VOICE2, "player/underwater_loop.wav", 1, ATTN_NORM);
			self.underwater_time = time + soundlength("player/underwater_loop.wav");
		}
	}

	if (!(self.flags &FL_WATERJUMP))
		self.velocity = self.velocity - 0.8 *self.waterlevel *frametime *self.velocity;
};

void() CheckWaterJump = { local vector start, end;
	// check for a jump-out-of-water
	makevectors(self.angles);
	start = self.origin;
	start_z = start_z + 8;
	v_forward_z = 0;
	normalize(v_forward);
	end = start + v_forward * 24;
	traceline(start, end, TRUE, self);
	if (trace_fraction < 1)
	{
		// solid at waist
		start_z = start_z + self.maxs_z - 8;
		end = start + v_forward * 24;
		self.movedir = trace_plane_normal *-50;
		traceline(start, end, TRUE, self);
		if (trace_fraction == 1)
		{
			// open at eye level
			self.flags = self.flags | FL_WATERJUMP;
			self.velocity_z = 225;
			self.flags = self.flags - (self.flags &FL_JUMPRELEASED);
			self.teleport_time = time + 2;	// safety net
			return;
		}
	}
};

float(entity targ) crouchcheck = { makevectors(self.v_angle);
	tracebox(self.origin, VEC_HULL_MIN, '16 16 0', self.origin + '0 0 48', FALSE, self);
	if (trace_fraction == 1)	//hits nothing go ahead
		return TRUE;
	if (!trace_ent.takedamage)	//hits world or nondamagable object
		return FALSE;
	return FALSE;
};

void() Crouch_Off = { if (self.crouch && (crouchcheck(self)))	//get up
	{
		self.flags = self.flags + FL_JUMPRELEASED;
		setsize(self, '-16 -16 -32', '16 16 32');	//changes the size of the player to the normal size
		self.crouch = 0;
		self.attemptcrouch = 0;
		if (self.lspeedtime < time)
			self.maxspeed = 1;	// multiplier of the velocity of the player
		return;
	}

	self.attemptcrouch = 1;
};

void() Crouch_On = { if ((!self.crouch) /*&& (!self.velocity_z)*/)	//crouch down
	{
		setsize(self, '-16 -16 -16', '16 16 8');	//changes the size of the player !!! 
		self.crouch = 1;
		self.attemptcrouch = 1;
		if (self.flags &FL_ONGROUND)
		{
			if (time < self.lspeedtime)
				self.maxspeed = 0.5;
			else
				self.maxspeed = 0.65;	// multiplier of the velocity of the player
		}

		return;
	}

	self.attemptcrouch = 0;
};

void() UpdateViewOfs = { if (self.crouch)
	{
		if (self.view_ofs_z == 6)
			return;
		if (self.view_ofs_z > 6)
		{
			self.view_ofs_z = self.view_ofs_z - 1;
		}
		else
			self.view_ofs_z = 6;
	}
	else
	{
		if (self.view_ofs_z == 22)
			return;
		if (self.view_ofs_z < 22)
		{
			self.view_ofs_z = self.view_ofs_z + 1;
		}
		else
			self.view_ofs_z = 22;
	}
};
.float nowatershift;
//float autocvar_invertmouse;// = 0; 
.float slowmouse;
.float noshake;

void() slowmovement = { self.slowmouse = 1;
	local float invrtms;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtms = 1;
	else
		invrtms = 0;

	/*	
		if (invrtms == 1)
		{
		stuffcmd(self, "m_pitch -0.005\n");
		stuffcmd(self, "m_yaw 0.005\n");
		}
		else
		{
		stuffcmd(self, "m_pitch 0.005\n");
		stuffcmd(self, "m_yaw 0.005\n");
		}

*/
	self.maxspeed = 0.5;
};
void() quickmovement
{
	self.slowmouse = -1;
	local float invrtmsb;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;

	/*
			if (invrtmsb == 1)
			{
			stuffcmd(self, "m_pitch -0.022\n");
			stuffcmd(self, "m_yaw 0.022\n");
			}
			else
			{
			stuffcmd(self, "m_pitch 0.022\n");
			stuffcmd(self, "m_yaw 0.022\n");
			}

	*/
	if (self.crouch)
		self.maxspeed = 0.65;
	else
		self.maxspeed = 1;
};

//void(entity e, entity world)find_nearest_waypoint;
.float releasebutton5;

.float changing_level;
.float heretic_sloweffect;
.float heretic_sloweffectime;

.float usingnonsolidswitch;
.entity nonsolidswitch;
.float splashtime;

.float autosavetime;
.float autosaved;
.float menuactive;

void() autosave = { read_currentprofileslot();
	self.autosaved = 1;
	string saveloc;
	saveloc = strcat("save data/profiles/", profilename, "/autosave\n");
	copy_save_maps(2);
	stuffcmd(self, "scratch1 1\n");
	stuffcmd(self, saveloc);
	stuffcmd(self, "scratch1 0\n");
	if (profilename)
		strunzone(profilename);
};

.float strafetime;
.float melee_lunge;
void() wraith_side1;
void() PlayerPreThink = { if ((self.autosavetime > time) && (self.impulse))
		self.impulse = 0;

	if ((self.autosavetime < time) && (!(self.menuactive)))
	{
		stuffcmd(self, "scratch3 0\n");
		if (!self.autosaved)
			autosave();
		self.menuactive = 1;
	}

	if (self.splashtime > time)
	{
		self.vhud = 2;
	}
	else
	{
		if (self.vhud == 2)
			self.vhud = 0;
	}

	if ((self.health < 1) && (!self.deadflag))
	{
		self.think = Player_Die;
		self.nextthink = time;
		self.attack_finished = time + 5;
		return;
	}

	if (self.deadflag >= DEAD_DEAD)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
		return;
	}

	if (self.deadflag == DEAD_DYING)
	{
		CheckFuncWaterDeath();	
		return;
	}

	if (self.playerdeadtime > time)
		return;

	if ((self.time_hudmessage < time) && (self.stat_time_hudmessage == 1))
		self.stat_time_hudmessage = 0;

	if (self.changing_level == 1)
		return;
	if (self.message_time == 1)
	{
		if (!self.button5)
			self.message_brelease = 0;

		if ((self.button5) && (self.message_brelease == 0))
		{
			self.message_time = 0;
			stuffcmd(self, "slowmo 1\n");
			self.use_finished = time + 0.5;
			self.journal = 0;
		}
	}

	if (!self.crouch)
	{
		if ((self.button7) && (self.flags & FL_ONGROUND))
		{
			if (!(self.effects &256))
			{
				self.effects += 256;
				stuffcmd(self, "cl_bobmodel 0\n");
				stuffcmd(self, "cl_leanmodel 0\n");
				stuffcmd(self, "cl_followmodel 0\n");
			}

			self.maxspeed = 0.75;
		}
		else
		{
			if (self.heretic_sloweffectime > time)
				self.maxspeed = 0.75;
			else
				self.maxspeed = 1;
			if (self.effects &256)
			{
				stuffcmd(self, "cl_bobmodel 1\n");
				stuffcmd(self, "cl_leanmodel 1\n");
				stuffcmd(self, "cl_followmodel 1\n");
				self.effects -= 256;
			}
		}
	}

	if ((self.lspeedtime > time) && (self.slowmouse != 1) && (self.heretic_sloweffectime < time))
		slowmovement();

	if ((time > self.lspeedtime) && (self.slowmouse == 1) && (self.heretic_sloweffectime < time))
		quickmovement();

	makevectors(self.v_angle);	// is this still used
	if ((self.fwatershifttime > time) && (self.nowatershift != 0))
	{
		self.nowatershift = 0;
	}

	if (self.fwatershifttime < time)
	{
		if (self.fwatershift)
		{
			self.dphitcontentsmask = 0;
			stuffcmd(self, "v_cshift\n");
			self.fwatershift = FALSE;
		}

		if (self.nowatershift == 0)
		{
			if (self.fwatershift == FALSE)
				stuffcmd(self, "v_cshift\n");
			self.nowatershift = 1;
		}
	}

	if (self.zerogtime < time)
		self.gravity = self.oldgravity;	// reset normal gravity
	else
		self.gravity = 0.0001;	// zero G (0 OR 1 is normal)
	if (!self.modeeditor)
	{
		if (self.timefly > time)
		{
			self.timeflyc = rint(time - self.timefly);
			if (self.movetype != MOVETYPE_FLY)
				self.movetype = MOVETYPE_FLY;
		}
		else
		{
			if (self.movetype != MOVETYPE_WALK)
			{
				if (self.movetype != MOVETYPE_NOCLIP)
				{
					self.movetype = MOVETYPE_WALK;
					self.timefly = 0;
					self.timeflyc = 0;
				}
			}
		}
	}

	if (self.LifeSiphon_time > time)
		self.timels = rint(time - self.LifeSiphon_time);
	else
		self.timels = 0;
	WaterMove();
	if (self.waterlevel == 2)
		CheckWaterJump();

	self.velocity_x = self.velocity_x *self.maxspeed;
	self.velocity_y = self.velocity_y *self.maxspeed;

	if ((!(self.button4)) && (self.crouch))
	{
		Crouch_Off();
	}

	if ((self.button4) && (!self.crouch))
	{
		Crouch_On();
	}

	if ((self.heretic_sloweffectime > time))
	{
		if ((self.crouch == 1) && (self.flags &FL_ONGROUND) && (self.maxspeed != 0.4875))
			self.maxspeed = 0.4875;	// multiplier of the velocity of the player	
	}
	else
	{
		if ((self.crouch == 1) && (self.flags &FL_ONGROUND) && (self.maxspeed != 0.65))
			self.maxspeed = 0.65;	// multiplier of the velocity of the player
	}

	if (self.noshake == 2)
	{
		stuffcmd(self, "v_kickroll 0.7\n");
		stuffcmd(self, "v_kickpitch 0.7\n");
		self.noshake = 0;
	}

	UpdateViewOfs();
	if ((self.button2) && (!self.crouch))
	{
		PlayerJump();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;
	if ((self.radial_time < time) && (self.radialruning == 1))
	{
		//self.radialactive = 0;
		self.radialruning = 0;
	}

	if ((self.cursor_trace_ent.usable >= 1) && ((vlen(self.cursor_trace_endpos - self.cursor_trace_start)) < 64))
	{
		if (!(self.crosshairflag &1))
			self.crosshairflag += 1;

		if ((self.cursor_trace_ent.classname == "readable") && (self.message_time != 1))
			self.cursor_trace_ent.effects = EF_SELECTABLE;
		if (self.cursor_trace_ent.classname == "nonsolidswitch")
		{
			self.usingnonsolidswitch = TRUE;
			self.nonsolidswitch = self.cursor_trace_ent;
		}
	}
	else
	{
		if (self.crosshairflag &1)
			self.crosshairflag -= 1;
		if (((self.cursor_trace_ent.classname == "readable") && (self.cursor_trace_ent.effects == EF_SELECTABLE)))
			self.cursor_trace_ent.effects = FALSE;
		if (self.usingnonsolidswitch)
		{
			self.usingnonsolidswitch = FALSE;
			self.nonsolidswitch = world;
		}
	}

	if ((self.cursor_trace_ent.flags &FL_MONSTER) && (self.cursor_trace_ent.health > 0) && ((vlen(self.cursor_trace_endpos - self.cursor_trace_start)) < 4096))
	{
		if (!(self.crosshairflag &2))
			self.crosshairflag += 2;

		/*if (skill >= 1)
		{
			if ((self.cursor_trace_ent.classname == "wraith") && (self.cursor_trace_ent.enemy == self) && (self.cursor_trace_ent.strafetime < time))
			{
				self.cursor_trace_ent.strafetime = time + 1;
				self.cursor_trace_ent.think = wraith_side1;
			}
		}*/
	}
	else
	{
		if (self.crosshairflag &2)
			self.crosshairflag -= 2;
	}

	//find_nearest_waypoint(self, world);
};

.float jump_flag;	// player jump flag

.float nomelee;
.float checkweaponflag;

void() check_weapons = { self.checkweaponflag = 1;
};

.float tether_model_client;
.float shrine_model_client;
.float artifact_model_client;
.float v_nextthink;
.float lifetime;
.entity artifact_client2;

void() artifact_client_remove2 = { if (self.owner.shrine_model_client == 1)
	{
		self.alpha -= 0.1;
		self.frame++;
	}

	if (self.alpha <= 0.1)
	{
		self.think = SUB_Remove;
		self.owner.shrine_model_client = 0;
	}
	else
		self.think = artifact_client_remove2;

	if (self.lifetime < time)
		self.think = SUB_Remove;
	self.nextthink = time + 0.05;
}

void() artifact_client_remove3 = { if (self.owner.tether_model_client == 1)
	{
		self.alpha -= 0.1;
		self.frame++;
	}

	if (self.alpha <= 0.1)
	{
		self.think = SUB_Remove;
		self.owner.tether_model_client = 0;
	}
	else
		self.think = artifact_client_remove3;

	if (self.lifetime < time)
		self.think = SUB_Remove;
	self.nextthink = time + 0.05;
}
void() artifact_client_remove = { if ((self.owner.radial_time > time) && (self.owner.artifact_model_client == 2))
	{
		if (self.owner.healthpulsetime > time)
			self.alpha += 0.2;

		if ((self.owner.healthpulsetime < time) && (self.alpha > 0.5))
			self.alpha -= 0.05;
	}

	if ((self.owner.radial_time < time) && ((self.owner.artifact_model_client == 1) || (self.owner.artifact_model_client == 2) || (self.owner.artifact_model_client == 4)))
		self.alpha -= 0.1;

	if ((self.owner.artifact_model_client == 3))
	{
		self.alpha -= 0.1;
		self.frame++;
	}

	if (self.alpha <= 0.1)
	{
		self.think = SUB_Remove;
		self.owner.artifact_model_client = 0;
	}
	else
		self.think = artifact_client_remove;

	if (self.lifetime < time)
		self.think = SUB_Remove;

	self.nextthink = time + 0.05;
}

void() artifact_client_think = { self.alpha += 0.1;

	local float maxalpha;
	maxalpha = 1;
	if (self.artifact_model_client == 2)
	{
		maxalpha = 0.5;
	}

	if (self.alpha < maxalpha)
		self.think = artifact_client_think;
	else
		self.think = artifact_client_remove;
	self.nextthink = time + 0.05;

};
.float Shrine_time;
void() ArtifactClientModel =	//ArtifactClientModel
	{
		local entity artifact_client2;

		if ((self.Shrine_time > time) && (self.shrine_model_client == 0))
		{
			artifact_client2 = spawn();
			artifact_client2.lifetime = time + 2;
			artifact_client2.owner = self;
			artifact_client2.effects = 256;
			artifact_client2.viewmodelforclient = self;
			setorigin(artifact_client2, '0 0 0');
			artifact_client2.oldangles = self.angles;
			artifact_client2.frame = 0;
			self.shrine_model_client = 1;
			artifact_client2.alpha = 1;
			setmodel(artifact_client2, "models/artifacts/active/soul_tether_active.md3");
			artifact_client2.think = artifact_client_remove2;
			artifact_client2.nextthink = time;
		}


		local entity artifact_client;

		if (self.radial_time > time)
		{
			if ((self.artifact_model_client == 0) && ((self.Aegis_time > time) || (self.LifeSiphon_time > time) || (self.DrownerApp_time > time) || (self.Tether_time > time)))
			{
				artifact_client = spawn();
				artifact_client.owner = self;
				artifact_client.effects = 256;
				artifact_client.viewmodelforclient = self;
				setorigin(artifact_client, '0 0 0');
				artifact_client.oldangles = self.angles;
				artifact_client.frame = 0;
				artifact_client.alpha = 0.01;

				if (self.Aegis_time > time)
				{
					self.artifact_model_client = 1;
					setmodel(artifact_client, "models/artifacts/active/cruel_aegis_active.md3");
				}

				if (self.LifeSiphon_time > time)
				{
					self.artifact_model_client = 2;
					setmodel(artifact_client, "models/artifacts/active/life_siphon_active.md3");
				}

				if (self.DrownerApp_time > time)
				{
					self.artifact_model_client = 4;
					setmodel(artifact_client, "models/artifacts/active/drowners_apparatus_active.md3");
				}
				artifact_client.lifetime = time + 30;
				artifact_client.think = artifact_client_think;
				artifact_client.nextthink = time;
			}
		}
	};
.float fakewatertype;
.float check_centered;
void() PlayerPostThink = { 
if (self.deadflag)
		return;
	if (self.playerdeadtime > time)
		return;

	if (self.changing_level == 1)
		return;

	///////
	if (self.dmgbscreenf < time)
	{
		if (self.damagescreen &2)
			self.damagescreen -= 2;
	}

	if (self.dmgscreenf > time)
	{
		if (!(self.damagescreen &1))
			self.damagescreen += 1;
	}
	else
	{
		if (self.damagescreen &1)
			self.damagescreen -= 1;
	}

	///////
	if (self.dmgbscreenb < time)
	{
		if (self.damagescreen &8)
			self.damagescreen -= 8;
	}

	if (self.dmgscreenb > time)
	{
		if (!(self.damagescreen &4))
			self.damagescreen += 4;
	}
	else
	{
		if (self.damagescreen &4)
			self.damagescreen -= 4;
	}

	///////
	if (self.dmgbscreenl < time)
	{
		if (self.damagescreen &32)
			self.damagescreen -= 32;
	}

	if (self.dmgscreenl > time)
	{
		if (!(self.damagescreen &16))
			self.damagescreen += 16;
	}
	else
	{
		if (self.damagescreen &16)
			self.damagescreen -= 16;
	}

	///////
	if (self.dmgbscreenr < time)
	{
		if (self.damagescreen &128)
			self.damagescreen -= 128;
	}

	if (self.dmgscreenr > time)
	{
		if (!(self.damagescreen &64))
			self.damagescreen += 64;
	}
	else
	{
		if (self.damagescreen &64)
			self.damagescreen -= 64;
	}

	///////

	//////////////////////	
	if (self.rhealthpulsetime < time)
	{
		if (self.pulseicons &2)
			self.pulseicons -= 2;
	}

	if (self.healthpulsetime > time)
	{
		if (!(self.pulseicons &1))
			self.pulseicons += 1;
	}
	else
	{
		if (self.pulseicons &1)
			self.pulseicons -= 1;
	}

	//////////////////////	
	if (self.rslugspulsetime < time)
	{
		if (self.pulseicons &8)
			self.pulseicons -= 8;
	}

	if (self.slugspulsetime > time)
	{
		if (!(self.pulseicons &4))
			self.pulseicons += 4;
	}
	else
	{
		if (self.pulseicons &4)
			self.pulseicons -= 4;
	}

	//////////////////////	
	if (self.rshellspulsetime < time)
	{
		if (self.pulseicons &32)
			self.pulseicons -= 32;
	}

	if (self.shellspulsetime > time)
	{
		if (!(self.pulseicons &16))
			self.pulseicons += 16;
	}
	else
	{
		if (self.pulseicons &16)
			self.pulseicons -= 16;
	}

	//////////////////////	
	if (self.rspitterpulsetime < time)
	{
		if (self.pulseicons &128)
			self.pulseicons -= 128;
	}

	if (self.spitterpulsetime > time)
	{
		if (!(self.pulseicons &64))
			self.pulseicons += 64;
	}
	else
	{
		if (self.pulseicons &64)
			self.pulseicons -= 64;
	}

	//////////////////////	
	if (self.rretcherpulsetime < time)
	{
		if (self.pulseicons &512)
			self.pulseicons -= 512;
	}

	if (self.retcherpulsetime > time)
	{
		if (!(self.pulseicons &256))
			self.pulseicons += 256;
	}
	else
	{
		if (self.pulseicons &256)
			self.pulseicons -= 256;
	}

	//////////////////////	
	//////////////////////	
	if (self.rarmorpulsetime < time)
	{
		if (self.pulseicons &2048)
			self.pulseicons -= 2048;
	}

	if (self.armorpulsetime > time)
	{
		if (!(self.pulseicons &1024))
			self.pulseicons += 1024;
	}
	else
	{
		if (self.pulseicons &1024)
			self.pulseicons -= 1024;
	}

	//////////////////////	
	if (self.rdarmorpulsetime < time)
	{
		if (self.pulseicons &8192)
			self.pulseicons -= 8192;
	}

	if (self.darmorpulsetime > time)
	{
		if (!(self.pulseicons &4096))
			self.pulseicons += 4096;
	}
	else
	{
		if (self.pulseicons &4096)
			self.pulseicons -= 4096;
	}

	//////////////////////	

	if ((self.flags &FL_ONGROUND) && (self.melee_released > 0) && (!self.button3) && (time > self.melee_jump_time))
		self.melee_released = 0;
	if ((self.fakewatertype) && (self.watertype_time < time))
		self.fakewatertype = 0;

	if (self.wrath_debug_screen)
		checking_enemies();
	ArtifactClientModel();
	WeaponFrames();	// do weapon stuff
	PlayerFootstep();
	// check to see if player landed and play landing sound	

	if ((self.jump_flag < -150) && (self.jumpinwatertime < time) && (self.watertype_time > time) && (self.jumpinwater == 0))
	{
		if ((self.fakewatertype == CONTENT_WATER) || (self.watertype == CONTENT_WATER))
		{
			self.jump_flag = 0;
			self.jumpinwater = 1;
			self.jumpinwatertime = time + 2.5;
			self.fall_state = FALSE;
			sound(self, CHAN_AUTO, "player/water_enter1.ogg", 1, ATTN_NORM);
		}
	}

	if ((self.jump_flag < -250) && (self.flags &FL_ONGROUND) && (self.health > 0))
	{
		if ((self.jump_flag < -250) && (self.jump_flag >= -650))
			playerlandsound(1);

		if (self.jump_flag < -650)
			playerlandsound(2);
		//T_Damage (self, world, world, 5); 

		self.jump_flag = 0;
	}

	if (!(self.flags &FL_ONGROUND))
	{
		if (self.flags &FL_INWATER)
			self.fall_state = FALSE;
		self.jump_flag = self.velocity_z;
		if (self.jump_flag < -1200)
			self.fall_state = TRUE;
	}
	else
	{
		if (self.fall_state == TRUE)
			self.fall_state = FALSE;
	}

	//	local string viewxanglesfactor;

	//	viewxanglesfactor = strcat ((ftos (self.v_angle_x)), (" died\n"));
	//bprint (viewxanglesfactor);

	//local string lmessage;
	//lmessage =strcat ((self.nearestsurface),("\n")) ;
	//bprint (lmessage);
};
void() Check_FrikFile;

string nextmap;
void() monster_relocator = { local entity monster;

	monster = findradius(self.origin, 1000000);
	while (monster)	//Loops through everything put in the missile entity
	{
		if ((monster.flags &FL_MONSTER) && (monster.health >= 0))
		{
			setorigin(monster, monster.oldorigin);
			monster.angles = monster.oldangles;
			monster.think = monster.th_stand;
			monster.nextthink = time;
			monster.enemy = world;
		}

		monster = monster.chain;	//links every monstergram found so they all go BOOM!
	}
};
void() garbage_collector = { local entity garbage;
	garbage = findradius(self.origin, 1000000);
	while (garbage)	//Loops through everything put in the missile entit
	{
		if (garbage.wrathflags &FL_GARBAGE)
		{
			remove(garbage);
		}

		garbage = garbage.chain;	//links every garbagegram found so they all go BOOM!
	}

	/*

	*/

};
void() respawn_entities = { local entity respawneable;
	respawneable = findradius(self.origin, 1000000);
	while (respawneable)	//Loops through everything put in the missile entit
	{
		if (respawneable.wrathflags &FL_RESPAWN)
		{
			respawneable.think = paste_old_data;
			respawneable.nextthink = time;
		}

		respawneable = respawneable.chain;	//links every garbagegram found so they all go BOOM!
	}
};
void() SetChangeParms;
void() loadlevel = { stuffcmd(self, "slowmo 1\n");stuffcmd(self, "r_glsl_saturation 1\n");
	read_currentprofileslot();
	stuffcmd(self, "set cvar_restoregame 1\n");
	string cname;
	cname = strcat("load data/profiles/", profilename, "/maps/", nextmap, "\n");
	stuffcmd(self, cname);
};

void() changemap = { changelevel(nextmap);
}

void(entity e) changelevel_wait = { e.changing_level = 1;
	e.nextthink = time + 1.5;
	e.think = changemap;
};
void() ParmstoFrik;
void(entity e) loadlevel_wait = { e.changing_level = 1;
	e.nextthink = time + 1.5;
	e.think = loadlevel;
};
void(entity e) changeparms2 = { parm1 = e.items;
	parm2 = e.health;
	parm3 = e.coachgunclip;
	parm4 = e.ammo_shotgun;
	parm5 = e.ammo_coachgun;
	parm6 = e.ammo_spitter;
	parm7 = e.ammo_retcher;
	parm8 = e.weapon;
	parm9 = e.rarmorvalue;
	parm10 = e.darmorvalue;
	parm11 = e.LifeSiphon;
	parm12 = e.SoulTether;
	parm13 = e.TrinketofRespite;
	parm14 = e.DrownerApp;
	parm15 = e.Aegis;
	parm17 = e.shotgun_clip;
	parm16 = e.location;
	parm18 = e.ammo_cannon;
	parm19 = e.explored_maps;
	parm20 = e.relics;
	parm21 = e.slot_relics;
	parm22 = e.oldrelics;
	parm23 = e.spotted_maps;
	parm24 = e.journal_jmessages;
	parm25 = e.journal_jmessagesm;
	parm26 = e.foundedrelics;
	parm27 = e.centerprint_messages;
};
void(entity e) GotoNextMap = { stuffcmd(e, "bf 0 0 0 2 0\n");
	local float loadingmap;
	if ((e.explored_maps &LE_HUB1) && (nextmap == "hub1"))
	{
		loadingmap = 1;
	}

	if ((e.explored_maps &LE_E1M1) && (nextmap == "e1m1"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M2) && (nextmap == "e1m2"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M3) && (nextmap == "e1m3"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M4) && (nextmap == "e1m4"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E1M5) && (nextmap == "e1m5"))
		loadingmap = 1;
	//changeparms2(e);

	if (loadingmap == 1)
		loadlevel_wait(e);
	else
		changelevel_wait(e);

};
string currentmap;
void(entity e) write_exploredmap = { read_currentprofileslot();
	local string saveloc, savestats;
	saveloc = strcat("save data/profiles/", profilename, "/maps/", currentmap, "\n");

	stuffcmd(e, "scratch1 1\n");
	stuffcmd(e, saveloc);
	stuffcmd(e, "scratch1 0\n");
	savestats = strcat("profiles/", profilename, "/maps/", currentmap, ".stats");
	float save_stats;
	string writethis;
	save_stats = fopen_wrath(savestats, FILE_WRITE);
	writethis = strcat(ftos(killed_monsters), "/", ftos(total_monsters));
	fputs(save_stats, writethis);fputs(save_stats, "\n");
	writethis = strcat(ftos(found_secrets), "/", ftos(total_secrets));
	fputs(save_stats, writethis);fputs(save_stats, "\n");

	string hasrelic;
	if (world.model == "maps/e1m1.bsp")
	{
		if (e.foundedrelics &RL_E1M1)
			hasrelic = "1";
		else
			hasrelic = "0";
	}

	if (world.model == "maps/e1m2.bsp")
	{
		if (e.foundedrelics &RL_E1M2)
			hasrelic = "1";
		else
			hasrelic = "0";
	}

	writethis = strcat(hasrelic, "/1");
	fputs(save_stats, writethis);fputs(save_stats, "\n");
	local string strTime;
	strTime = SG_GetFormattedTimeStringUnZoned(time);
	writethis = (strTime);
	fputs(save_stats, writethis);fputs(save_stats, "\n");
	fclose_wrath(save_stats);

	GotoNextMap(e);
	//	e.effects += 1024;
	//	stuffcmd (e, "bf 0 0 0 1 0.5\n");

	///////
};
void() changelevel_touch = { if (self.wait > time)
		return;
	if (other.classname != "player")
		return;
	local float invrtmsb;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;

	if(invrtmsb)
	stuffcmd(other, "m_pitch -0.001\n");
	else
	stuffcmd(other, "m_pitch 0\n");
	
	stuffcmd(other, "m_yaw 0\n");
	garbage_collector();
	if (!self.location)
		other.location = 0;
	else
		other.location = self.location;
	bprint(other.netname);
	bprint(" exited the level\n");
	nextmap = self.map;

	local float nLength;
	local string namewbsp, namecomplete, currentmaplocal;
	currentmaplocal = world.model;
	namecomplete = substring(currentmaplocal, 5, 100);
	nLength = strlen(namecomplete);
	namewbsp = substring(namecomplete, 0, nLength - 4);
	currentmap = namewbsp;

	other.items = other.items - (other.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_KEY4));
	other.slot_keys = 0;
	SUB_UseTargets();

	local float loadingmap;
	if (world.model == "maps/hub1.bsp")
	{
		if (!(other.explored_maps &LE_HUB1))
			other.explored_maps += LE_HUB1;
		loadingmap = 1;
	}

	if (world.model == "maps/e1m1.bsp")
	{
		if (!(other.explored_maps &LE_E1M1))
			other.explored_maps += LE_E1M1;
		loadingmap = 1;
	}

	if (world.model == "maps/e1m2.bsp")
	{
		if (!(other.explored_maps &LE_E1M2))
			other.explored_maps += LE_E1M2;
		loadingmap = 1;
	}

	if (world.model == "maps/e1m3.bsp")
	{
		if (!(other.explored_maps &LE_E1M3))
			other.explored_maps += LE_E1M3;
		loadingmap = 1;
	}

	if (world.model == "maps/e1m4.bsp")
	{
		if (!(other.explored_maps &LE_E1M4))
			other.explored_maps += LE_E1M4;
		loadingmap = 1;
	}

	if (world.model == "maps/e1m5.bsp")
	{
		if (!(other.explored_maps &LE_E1M5))
			other.explored_maps += LE_E1M5;
		loadingmap = 1;
	}

	other.solid = 0;
	other.movetype = 0;
	other.speed = 0;
	self.wait = time + 5;
	changeparms2(other);
	ParmstoFrik();
	if (loadingmap == 1)
		write_exploredmap(other);
	else
		changelevel_wait(other);
	//GotoNextMap(other);

};

void() trigger_changelevel = { if (!self.map)
		objerror("changelevel trigger doesn't have map");
	InitTrigger();
	self.wait = 0;
	self.touch = changelevel_touch;
};

void() portal_level_active = { self.touch = changelevel_touch;
};

void() portal_level_to_hub_active = { self.frame = 1;
	self.effects = 0;
	self.think = portal_level_active;
	self.nextthink = time + 1;
};

void() portal_level_to_hub_active_wait = { self.think = portal_level_to_hub_active;
	self.nextthink = time + self.wait;
};

/*
ENTITY NAME:     portal_level_to_hub         
MODEL:            models/portals/portal_level_to_hub.md3
BBOX SIZE:        '-32 -32 -64'
KEYS:
   [MAP]            <mapname to go to>
   [LOCATION]       <N>
   [CUBEMAP]       <N>
   [TARGET NAME]   <used to activate portal upon Relic pickup>
BEHAVIOR:
portal is inactive (frame 0) until triggered by Relic pickup, then plays a 1 sec animation (framegroup, 20fps, frame 0-19) then is active (frame 19) for the rest of the game
*/
void() portal_level_to_hub = { precache_model("models/portals/portal_level_to_hub.md3");
	setmodel(self, "models/portals/portal_level_to_hub.md3");
	self.solid = SOLID_TRIGGER;
	self.effects = EF_NODRAW;
	if (!self.wait)
		self.wait = 1;
	setsize(self, '-32 -32 -64', '32 32 64');

	if (self.targetname)
		self.use = portal_level_to_hub_active_wait;
	else
	{
		self.think = portal_level_to_hub_active;
		self.nextthink = time;
	}
};

entity() SelectSpawnPoint = { local entity spot;

	// testinfo_player_start is only found in regioned levels
	spot = find(world, classname, "testplayerstart");
	if (spot)
		return spot;

	// choose a info_player_deathmatch point
	if (coop)
	{
		lastspawn = find(lastspawn, classname, "info_player_coop");
		if (lastspawn == world)
			lastspawn = find(lastspawn, classname, "info_player_start");
		if (lastspawn != world)
			return lastspawn;
	}
	else if (deathmatch)
	{
		lastspawn = find(lastspawn, classname, "info_player_deathmatch");
		if (lastspawn == world)
			lastspawn = find(lastspawn, classname, "info_player_deathmatch");
		if (lastspawn != world)
			return lastspawn;
	}

	local entity bot;
	/*	if(!self.location)
		spot = find (world, classname, "info_player_start");
		else
		{*/
	bot = find(world, classname, "info_player_start");
	while (bot != world)
	{
		if (bot.location == self.location)
		{
			spot = bot;
		}

		bot = find(bot, classname, "info_player_start");
	}

	/*}*/
	if ((self.location) && (!spot))
		spot = find(world, classname, "info_player_start");
	/*
	string number_location, spotname;
	numberlocation = ftos (self.location);
	spotname = strcat ("info_player_start",numberlocation);
	spot = find (world, classname, spotname);
	*/

	if (!spot)
	{
		bot = find(world, classname, "info_player_deathmatch");
		while (bot != world)
		{
			if (bot.location == self.location)
			{
				spot = bot;
			}

			bot = find(bot, classname, "info_player_deathmatch");
		}

		if ((self.location) && (!spot))
			spot = find(world, classname, "info_player_deathmatch");
	}

	if (!spot)
		error("PutClientInServer: no info_player_start on level");

	return spot;
};
void() DecodeLevelParms;
void() FriktoParms = { local float readparms;
	local string readtext, saveloc;
	DecodeLevelParms();
	read_currentprofileslot();
	saveloc = strcat("profiles/", profilename, "/frikparms.kp1");
	readparms = fopen(saveloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);parm1 = stof(readtext);
	readtext = fgets(readparms);parm2 = stof(readtext);
	readtext = fgets(readparms);parm3 = stof(readtext);
	readtext = fgets(readparms);parm4 = stof(readtext);
	readtext = fgets(readparms);parm5 = stof(readtext);
	readtext = fgets(readparms);parm6 = stof(readtext);
	readtext = fgets(readparms);parm7 = stof(readtext);
	readtext = fgets(readparms);parm8 = stof(readtext);
	readtext = fgets(readparms);parm9 = stof(readtext);
	readtext = fgets(readparms);parm10 = stof(readtext);
	readtext = fgets(readparms);parm11 = stof(readtext);
	readtext = fgets(readparms);parm12 = stof(readtext);
	readtext = fgets(readparms);parm13 = stof(readtext);
	readtext = fgets(readparms);parm14 = stof(readtext);
	readtext = fgets(readparms);parm15 = stof(readtext);
	readtext = fgets(readparms);parm16 = stof(readtext);
	readtext = fgets(readparms);parm17 = stof(readtext);
	readtext = fgets(readparms);parm18 = stof(readtext);
	readtext = fgets(readparms);parm19 = stof(readtext);
	readtext = fgets(readparms);parm20 = stof(readtext);
	readtext = fgets(readparms);parm21 = stof(readtext);
	readtext = fgets(readparms);parm22 = stof(readtext);
	readtext = fgets(readparms);parm23 = stof(readtext);
	readtext = fgets(readparms);parm24 = stof(readtext);
	readtext = fgets(readparms);parm25 = stof(readtext);
	readtext = fgets(readparms);parm26 = stof(readtext);
	readtext = fgets(readparms);parm27 = stof(readtext);

	fclose(readparms);
	/*
	self.items = parm1;
	self.health = parm2;
	self.coachgunclip = parm3;
	self.ammo_shotgun = parm4;
	self.ammo_coachgun  = parm5;
	self.ammo_spitter = parm6;
	self.ammo_retcher = parm7;
	self.weapon = parm8;
	self.rarmorvalue = parm9;
	self.darmorvalue = parm10;
	self.LifeSiphon = parm11;
	self.SoulTether = parm12;
	self.TrinketofRespite = parm13;
	self.DrownerApp = parm14;
	self.Aegis = parm15;
	self.shotgun_clip = parm17;
	self.ammo_cannon = parm18;
	self.location = parm16;
	self.explored_maps =	parm19;
	*/
};
void() ParmstoFrik = { local float writeparms;
	local string writethis, saveloc;
	read_currentprofileslot();
	self.slot_keys = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_KEY4));
	saveloc = strcat("profiles/", profilename, "/frikparms.kp1");
	writeparms = fopen(saveloc, FILE_WRITE);	//open what file to use in write mode
	writethis = ftos(parm1);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm2);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm3);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm4);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm5);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm6);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm7);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm8);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm9);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm10);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm11);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm12);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm13);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm14);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm15);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm16);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm17);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm18);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm19);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm20);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm21);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm22);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm23);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm24);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm25);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm26);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm27);fputs(writeparms, writethis);fputs(writeparms, "\n");
	fclose(writeparms);
};

void() SetChangeParms = { if (self.health <= 0)
	{
		SetNewParms();
		return;
	}

	// remove items
	self.slot_keys = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_KEY4));
	// cap super health
	if (self.health > 100)
		self.health = 100;
	/*if (self.health < 50)
		self.health = 50; */
	parm1 = self.items;
	parm2 = self.health;
	parm3 = self.coachgunclip;
	parm4 = self.ammo_shotgun;
	parm5 = self.ammo_coachgun;
	parm6 = self.ammo_spitter;
	parm7 = self.ammo_retcher;
	parm8 = self.weapon;
	parm9 = self.rarmorvalue;
	parm10 = self.darmorvalue;
	parm11 = self.LifeSiphon;
	parm12 = self.SoulTether;
	parm13 = self.TrinketofRespite;
	parm14 = self.DrownerApp;
	parm15 = self.Aegis;
	parm17 = self.shotgun_clip;
	parm16 = self.location;
	parm18 = self.ammo_cannon;
	parm19 = self.explored_maps;
	parm20 = self.relics;
	parm21 = self.slot_relics;
	parm22 = self.oldrelics;
	parm23 = self.spotted_maps;
	parm24 = self.journal_jmessages;
	parm25 = self.journal_jmessagesm;
	parm26 = self.foundedrelics;
	parm27 = self.centerprint_messages;
};

void() SetNewParms = { if (!self.nomelee)
	{
		parm1 = IT_MELEE + IT_VIEWMODEL;	//items
		parm8 = IT_MELEE;	// weapon
	}
	else
	{
		parm1 = 0;	// items
		parm8 = 0;	// weapon
	}

	parm2 = 100;	//self health
	parm3 = 0;	// self.coachgunclip = 0;
	parm4 = 0;	//self.ammo_shotgun = 0;
	parm5 = 0;	//self.ammo_coachgun = 0;
	parm6 = 0;	//self.ammo_spitter = 0;
	parm7 = 0;	//self.ammo_retcher = 0;
	parm9 = 0;	//self.rarmorvalue = 0;
	parm10 = 0;	//self.darmorvalue = 0;
	parm11 = 0;	//self.LifeSiphon = 0;
	parm12 = 0;	//self.SoulTether = 0;
	parm13 = 0;	//self.TrinketofRespite = 0;
	parm14 = 0;	//self.DrownerApp = 0;
	parm15 = 0;	//self.Aegis = 0;
	parm17 = 2;	//self.shotgun_clip = 2;
	parm18 = 0;	//self.ammo_cannon = 0;
	parm16 = 0;
	parm19 = 0;
	parm20 = 0;
	parm21 = 0;
	parm22 = 0;
	parm23 = 0;
	parm24 = 0;
	parm25 = 0;
	parm26 = 0;
	parm27 = 0;

	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_KEY4));
	self.slot_keys = 0;
};

void() DecodeLevelParms = { self.items = parm1;
	self.health = parm2;
	self.coachgunclip = parm3;
	self.ammo_shotgun = parm4;
	self.ammo_coachgun = parm5;
	self.ammo_spitter = parm6;
	self.ammo_retcher = parm7;
	self.weapon = parm8;
	self.rarmorvalue = parm9;
	self.darmorvalue = parm10;
	self.LifeSiphon = parm11;
	self.SoulTether = parm12;
	self.TrinketofRespite = parm13;
	self.DrownerApp = parm14;
	self.Aegis = parm15;
	self.shotgun_clip = parm17;
	self.ammo_cannon = parm18;
	self.location = parm16;
	self.explored_maps = parm19;
	self.relics = parm20;
	self.slot_relics = parm21;
	self.oldrelics = parm22;
	self.spotted_maps = parm23;
	self.journal_jmessages = parm24;
	self.journal_jmessagesm = parm25;
	self.foundedrelics = parm26;
	self.centerprint_messages = parm27;

};

.float oldrelics_start;
void()recount_monsters;
void() RestoreGame = {
	self.check_centered = 1;
	if (cvar("cvar_restoregame") != 1)
		return;
	//	SetChangeParms();
	monster_relocator();
	FriktoParms();
	DecodeLevelParms();
	respawn_entities();
	recount_monsters();
	//	ParmstoFrik();
	local entity spawn_spot;	// This holds where we want to spawn
	spawn_spot = SelectSpawnPoint();

	self.changing_level = 0;
	if (self.health < 1)
		self.health = 1;
	self.max_health = 100;	// My health (and my max) is 100
	self.takedamage = DAMAGE_AIM;	// I can be fired at
	self.solid = SOLID_SLIDEBOX;	// Things sort of 'slide' past me
	self.movetype = MOVETYPE_WALK;	// Yep, I want to walk.
	self.flags = FL_CLIENT;	// Yes, I'm a client.
	self.origin = spawn_spot.origin;	// + '0 0 10';	// Move to the spawnspot location
	self.angles = spawn_spot.angles;	// Face the angle the spawnspot indicates
	self.fixangle = TRUE;	// Turn this way immediately
	setmodel(self, "");	// Set my player to the player model
	setmodel(self, "models/enemies/fallen/fallen1.md3");
	setsize(self, '-16 -16 -32', '16 16 32');
	self.view_ofs = '0 0 22';	// Center my view
	self.velocity = '0 0 0';	// Stop any old movement
	self.coachgunclip = 0;
	//	self.ammo_coachgun = 0;
	self.air_finished = time + 12;
	self.attack_finished = time;
	self.th_pain = Player_Pain;
	self.th_die = Player_Die;
	self.maxspeed = 1;
	self.fwatershift = TRUE;	// catch runaway cshifts (changlevel/respawn while in func_water)
	self.oldgravity = 0;	// use unmodified sv_gravity
	Check_FrikFile();
	self.vweapon = spawn();
	self.vweapon.classname = "player_weaponmodel";
	self.vweapon.owner = self;
	self.vweapon.wrathflags += FL_GARBAGE;
	self.vweapon.viewmodelforclient = self;
	self.vweapon.think = Think_Vweapon;
	self.vweapon.angles_y = 0;
	self.vweapon.angles_x = 0;
	self.vweapon.angles_z = 0;
	self.vweapon.nextthink = time;
	raise_weapon();
	self.effects = self.effects + EF_NOSHADOW;
	stuffcmd(self, "-attack\n");	// 
	self.vweapon.origin_z = self.dvweapon_z;
	self.holdcannon = 0.1;
	self.holdcannontime = 0.1;
	PlayerValuesEditor();
	check_retcher();
	self.nomelee = spawn_spot.nomelee;
	////lbeams
	self.charge_shotgun = 1;
	stuffcmd(self, "slowmo 1\n");
	stuffcmd(self, "scratch3 a\n");
	stuffcmd(self, "freelook 1\n");
	stuffcmd(self, "m_yaw 0.022\n");
	stuffcmd(self, "r_glsl_saturation 1\n");
	local float invrtmsb;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;
	if (invrtmsb == 1)
		stuffcmd(self, "m_pitch -0.022\n");
	else
		stuffcmd(self, "m_pitch 0.022\n");
	check_tether_inmap();
	self.deadflag = 0;
	self.artifact_model_client = 0;
	stuffcmd(self, "sv_freezenonclients 0\n");
	stuffcmd(self, "bf 0 0 0 1 0.5\n");
	if (cvar_string("cvar_restoregame") == "")
		localcmd("set cvar_restoregame 0\n");
	self.location = 0;
	self.oldrelics_start = self.oldrelics;
	self.autosavetime = time + 0.5;
	self.autosaved = 0;
	self.menuactive = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_KEY4));
	self.slot_keys = 0;
};

void() check_spotted_maps = { if (world.model == "maps/hub1.bsp")
	{
		if (!(self.spotted_maps &LE_HUB1))
			self.spotted_maps += LE_HUB1;
	}

	if (world.model == "maps/e1m1.bsp")
	{
		if (!(self.spotted_maps &LE_E1M1))
			self.spotted_maps += LE_E1M1;
	}

	if (world.model == "maps/e1m2.bsp")
	{
		if (!(self.spotted_maps &LE_E1M2))
			self.spotted_maps += LE_E1M2;
	}

	if (world.model == "maps/e1m3.bsp")
	{
		if (!(self.spotted_maps &LE_E1M3))
			self.spotted_maps += LE_E1M3;
	}

	if (world.model == "maps/e1m4.bsp")
	{
		if (!(self.spotted_maps &LE_E1M4))
			self.spotted_maps += LE_E1M4;
	}

	if (world.model == "maps/e1m5.bsp")
	{
		if (!(self.spotted_maps &LE_E1M5))
			self.spotted_maps += LE_E1M5;
	}
};

void() PutClientInServer = { local entity spawn_spot;	// This holds where we want to spawn
	spawn_spot = SelectSpawnPoint();
	self.nomelee = spawn_spot.nomelee;
	DecodeLevelParms();

	self.classname = "player";	// I'm a player!
	if (spawn_spot.health)
		self.health = spawn_spot.health;
	if (self.health < 1)
		self.health = 1;
	self.max_health = 100;	// My health (and my max) is 100
	self.takedamage = DAMAGE_AIM;	// I can be fired at
	self.solid = SOLID_SLIDEBOX;	// Things sort of 'slide' past me
	self.movetype = MOVETYPE_WALK;	// Yep, I want to walk.
	self.flags = FL_CLIENT;	// Yes, I'm a client.
	self.origin = spawn_spot.origin;	// + '0 0 10';	// Move to the spawnspot location
	self.angles = spawn_spot.angles;	// Face the angle the spawnspot indicates
	self.fixangle = TRUE;	// Turn this way immediately
	setmodel(self, "");	// Set my player to the player model
	setmodel(self, "models/enemies/fallen/fallen1.md3");
	setsize(self, '-16 -16 -32', '16 16 32');
	self.view_ofs = '0 0 22';	// Center my view
	self.velocity = '0 0 0';	// Stop any old movement
	self.air_finished = time + 12;
	self.attack_finished = time;
	self.th_pain = Player_Pain;
	self.th_die = Player_Die;
	self.maxspeed = 1;
	self.fwatershift = TRUE;	// catch runaway cshifts (changlevel/respawn while in func_water)
	self.oldgravity = 0;	// use unmodified sv_gravity
	Check_FrikFile();
	self.vweapon = spawn();
	self.vweapon.owner = self;
	self.vweapon.wrathflags += FL_GARBAGE;
	self.vweapon.viewmodelforclient = self;
	self.vweapon.classname = "player_weaponmodel";
	self.vweapon.think = Think_Vweapon;
	self.vweapon.angles_y = 0;
	self.vweapon.angles_x = 0;
	self.vweapon.angles_z = 0;
	self.vweapon.nextthink = time;
	self.effects = self.effects + EF_NOSHADOW;
	stuffcmd(self, "-attack\n");	// 
	self.vweapon.origin_z = self.dvweapon_z;
	self.holdcannon = 0.1;
	self.holdcannontime = 0.1;
	PlayerValuesEditor();
	check_retcher();
	if (!self.nomelee)
		raise_weapon();
	else
	{
		self.items -= IT_MELEE;
		self.weapon = 0;
	}

	////lbeams
	self.charge_shotgun = 1;
	stuffcmd(self, "scratch3 1\n");
	stuffcmd(self, "slowmo 1\n");
	stuffcmd(self, "freelook 1\n");
	stuffcmd(self, "m_yaw 0.022\n");
	stuffcmd(self, "r_glsl_saturation 1\n");
	local float invrtmsb;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;
	if (invrtmsb == 1)
		stuffcmd(self, "m_pitch -0.022\n");
	else
		stuffcmd(self, "m_pitch 0.022\n");
	//Kill_Tether ();
	self.deadflag = 0;
	self.artifact_model_client = 0;
	stuffcmd(self, "sv_freezenonclients 0\n");
	stuffcmd(self, "bf 0 0 0 1 0.5\n");
	if (cvar_string("cvar_restoregame") == "")
		localcmd("set cvar_restoregame 0\n");
	self.location = 0;
	check_spotted_maps();
	self.oldrelics_start = self.oldrelics;
	self.autosavetime = time + 0.5;
	self.menuactive = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_KEY4));
	self.slot_keys = 0;
};

void(entity targ, entity attacker) ClientObituary = { bprint(" died\n");
};

///////////////////////////////