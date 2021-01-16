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
.float walking;
void() ClientKill = {};
void() ClientConnect = {};
void() ClientDisconnect = {};
void() WeaponFrames;
void() raise_weapon;
void(string locsound, float rnd) playersound = 
{
	local float r;
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

void(string locsound, float rnd, float nchannel) playersound2 = 
{
	local float r;
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

void() delete_shrine = 
{
	local float writeparms;
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
void(entity ownr) client_garbage_collector;
void() Player_Die = 
{
	
	delete_shrine();
	if (self.health >= 0)
		self.health = -1;
	remove(self.vweapon);
	self.use = SUB_Null;
	self.solid = SOLID_CORPSE;
	self.takedamage = 0;
	self.think = PlayerDeathThink;
	self.nextthink = time;
	self.playerdeadtime = time + 100000000;
	self.deadflag = DEAD_DEAD;
	self.deadwaiting = time + 0.1;

	if (self.waterlevel >= 3)
		playersound("player/die_underwater", 2);
	else
		playersound("player/die", 5);
};

//void(string snd, float r, float vol) playersound;

void(entity attacker, float dmg) Player_Pain = 
{
	if (self.pain_finished > time)
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

void() PlayerDeathThink = 
{
	local float forward;

	if (self.deadflag == DEAD_DEAD)
	{
		client_garbage_collector(self);
		self.deadflag = DEAD_RESPAWNABLE;
		return;
	}

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



	self.think = SUB_Null;
	self.nextthink = time;
	if (deathmatch == 1)
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
.float extraongroundtime;
.float onground_time;
.float jumptime;
void() PlayerJump = 
{
	if (self.flags &FL_WATERJUMP)
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
	self.jumptime = time + 0.2;


	if((self.view_ofs_z < player_zviewofs) && (self.view_ofs_z > 6))
	self.velocity_z = 92;
	else
	self.velocity_z += 270;

/*	if(!(self.walking))
	{	
	makevectors2 (self.angles);
	self.velocity += v_forward * 12;
	}*/

	self.onground_time = 0;
};
.float underwater_time;
.float jumpinwater;
.float jumpinwatertime;
.float fakewatertype;
void() WaterMove = 
{
	if (self.movetype == MOVETYPE_NOCLIP)
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
		self.surfacing_sound_time = time + random(0.5,1);
		self.underwaterdamaged = 0;
		self.underwater_time = 0;
	}

	if (self.DrownerApp_time > time)
	self.air_finished = time + 12;

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

	if ((self.watertype == CONTENT_LAVA) || (self.fakewatertype == CONTENT_LAVA))
	{
		// do damage
		if (self.dmgtime < time)
		{
			if (self.radsuit_finished > time)
				self.dmgtime = time + lava_damage_time * 5;
			else
				self.dmgtime = time + lava_damage_time;
			T_Damage(self, world, world, lava_damage);
		}
	}
	else if ((self.watertype == CONTENT_SLIME)|| (self.fakewatertype == CONTENT_SLIME))
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

void() CheckWaterJump = 
{
	local vector start, end;
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


float(entity targ) crouchcheck = 
{
	makevectors(self.v_angle);
	tracebox(self.origin, VEC_HULL_MIN, '16 16 0', self.origin + '0 0 48', FALSE, self);
	if (trace_fraction == 1)	//hits nothing go ahead
		{
		self.origin_z += 16; setorigin(self,self.origin);
		return TRUE;
		}
	if (!trace_ent.takedamage)	//hits world or nondamagable object
		return FALSE;
	return FALSE;
};

void() Crouch_Off = 
{
	if (self.crouch && (crouchcheck(self)))	//get up
	{
		
		if((self.groundentity.solid == SOLID_BBOX) &&  (self.flags &FL_ONGROUND))
		self.velocity_z  = 90;

		if(!(self.flags & FL_JUMPRELEASED))
		self.flags += FL_JUMPRELEASED;
		setsize(self, '-16 -16 -32', '16 16 32');	//changes the size of the player to the normal size
		self.crouch = 0;
		self.attemptcrouch = 0;
		if (self.lspeedtime < time)
			self.maxspeed = 1;	// multiplier of the velocity of the player
		return;
	}

	self.attemptcrouch = 1;
};

void() Crouch_On = 
{
	if ((!self.crouch) /*&& (!self.velocity_z)*/)	//crouch down
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
.float crushingtime;

void() UpdateViewOfs = 
{
	if (self.crouch)
	{
		if(self.crushingtime > time)
		float minviewofsz = -4;
		else
		minviewofsz = 6;


		if (self.view_ofs_z == minviewofsz)
			return;
		if (self.view_ofs_z > minviewofsz)
		{
			self.view_ofs_z = self.view_ofs_z - 1;
		}
		else
			self.view_ofs_z = minviewofsz;
	}
	else
	{
		if (self.view_ofs_z == player_zviewofs)
			return;
		if (self.view_ofs_z < player_zviewofs)
		{
			self.view_ofs_z = self.view_ofs_z + 1;
		}
		else
			self.view_ofs_z = player_zviewofs;
	}
};
.float nowatershift;
//float autocvar_invertmouse;// = 0; 
.float slowmouse;
.float noshake;

void() slowmovement = 
{
	self.slowmouse = 1;
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

void() autosave = 
{
	read_currentprofileslot();
	self.autosaved = 1;
	string saveloc;
	saveloc = strcat("save data/profiles/", profilename, "/autosave\n");
	copy_save_maps(2);
	stuffcmd(self, "scratch1 1\n");
	stuffcmd(self, saveloc);
	stuffcmd(self, "scratch1 0\n");
	if (profilename)
		strunzone(profilename);
	save_screenshot(1, 1.5);
	writedates(1);
};

.float strafetime;
.float melee_lunge;
void() wraith_side1;

.float realmaxspeed;
.float maxspeedtime;
.float stoptime;
.float stopflag;
.float onmonsterjumptime;
.float alwaysrun;
.float togglerun;
.float walkingbutton;
.float toggle_finished;
void() check_custom_cvars;
void() refresh_custom_cvars;
.float buttonrelease7;
.float lift_touch_time;
.float on_lift;
.float gameplayfix_stepdown;
.float timeviewzoom;
.float walktime;

void() PlayerPreThink = 
{ 		


	if (time > self.timeviewzoom)
	{
		if(self.lance_viewzoom_time > time)
		{	
			if (self.viewzoom > self.lance_viewzoom)
				self.viewzoom -= self.lance_viewzoom_rate / 100;
		}
		if((self.lance_viewzoom_time < time) && (self.viewzoom != 1))
		{
			if (self.viewzoom < 1)
				self.viewzoom += self.lance_viewzoom_rate  / 50;
		}
		self.timeviewzoom = time +0.01;
	}
	
	if (self.viewzoom < self.lance_viewzoom)
		self.viewzoom = self.lance_viewzoom;
	if (self.viewzoom > 1)
	self.viewzoom = 1;


	/*
	if(self.lift_touch_time > time)
	{
		if(self.on_lift == 1)
		{
			stuffcmd(self, "sv_gameplayfix_downtracesupportsongroundflag 1\n");
			self.on_lift = 2;
		}
	}
	else
	{
		if((self.on_lift != 0) && (self.velocity_z == 0))
		{
			stuffcmd(self, "sv_gameplayfix_downtracesupportsongroundflag 0\n");
			self.on_lift = 0;
		}
	}
	if((self.movement_x == 0) && (self.movement_y == 0)&& (self.gameplayfix_stepdown != 1)) 
	{
	self.gameplayfix_stepdown = 1;
	stuffcmd(self, "sv_gameplayfix_nogravityonground 1\n");
	}

	if((self.movement_x != 0) ||(self.movement_y != 0)&& (self.gameplayfix_stepdown == 1)) 
	{
	self.gameplayfix_stepdown = 0;
	stuffcmd(self, "sv_gameplayfix_nogravityonground 0\n");
	}
	*/
	//string viewxanglesfactor = strcat ((vtos (self.movement)), (" movement\n"));
	//bprint (viewxanglesfactor);


	if((self.stoptime < time) && (self.flags & FL_IGNOREINPUT))
	{
	self.flags -= FL_IGNOREINPUT;
	}

	if((self.flags & FL_IGNOREINPUT)&& (self.flags & FL_ONGROUND))
	self.flags -= FL_IGNOREINPUT;

	if ((self.autosavetime > time) && (self.impulse))
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
	
		float button7pressed;
		{
			if(self.togglerun != 1)
			{
				if(self.button7)
					button7pressed = 1;	
				else
					button7pressed = 0;		
			}
			else
			{	
				if(!self.button7)
					self.buttonrelease7 = 1;
				if ((self.button7) && (self.buttonrelease7 == 1))
				{
					if(self.walkingbutton != 1)
						self.walkingbutton= 1;
					else
						self.walkingbutton= 0;
					self.buttonrelease7 = 0;
				}
			button7pressed = self.walkingbutton;
			}
		}
	
		if (self.alwaysrun == 1)
		{
			 if (button7pressed == 1)
				self.walking = 1;
			else
				self.walking = 0;
		}
		else
		{
			 if (button7pressed == 1) 
				self.walking = 0;
			else
				self.walking = 1;
		}

		if ((self.walking == 1))
		{
			if (!(self.effects &256))
			{
				self.effects += 256;
				stuffcmd(self, "cl_bobmodel 0\n");
				stuffcmd(self, "cl_leanmodel 0\n");
				stuffcmd(self, "cl_followmodel 0\n");
				stuffcmd(self, "cl_smoothviewheight 0\n");
			}

			self.maxspeed = 0.75;
		}
		else
		{
			if((self.flags & FL_ONGROUND) && (self.maxspeed != 1))
			{
			if (self.heretic_sloweffectime > time)
				self.maxspeed = 0.75;
			else
				self.maxspeed = 1;
			}

			if (self.effects &256)
			{
				stuffcmd(self, "cl_bobmodel 1\n");
				stuffcmd(self, "cl_leanmodel 1\n");
				stuffcmd(self, "cl_followmodel 1\n");
				stuffcmd(self, "cl_smoothviewheight 0\n");
				self.effects -= 256;
			}
		}
	}

	if ((self.lspeedtime > time) && (self.slowmouse != 1) && (self.heretic_sloweffectime < time))
		slowmovement();

	if ((time > self.lspeedtime) && (self.slowmouse == 1) && (self.heretic_sloweffectime < time))
		quickmovement();
	if(self.flags & FL_ONGROUND)
	self.onground_time = time + 0.2;

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
			stuffcmd (self, "alias +button4  \"+movedown\" \n");
			stuffcmd (self, "alias -button4  \"-movedown\" \n");
			stuffcmd (self, "alias +jump  \"+moveup\" \n");
			stuffcmd (self, "alias -jump  \"-moveup\" \n");
		}
		else
		{
			if (self.movetype != MOVETYPE_WALK)
			{
				if (self.movetype != MOVETYPE_NOCLIP)
				{
				self.radialactive = 0;
				self.timefly = 0;
				self.timeflyc = 0;
				self.movetype = MOVETYPE_WALK;
				stuffcmd (self, "alias +button4  \"\" \n");
				stuffcmd (self, "alias -button4  \"\" \n");
				stuffcmd (self, "alias +jump  \"\" \n");
				stuffcmd (self, "alias -jump  \"\" \n");
				stuffcmd (self, "-jump \n");
				stuffcmd (self, "-jump \n");
				stuffcmd (self, "-moveup \n");
				stuffcmd (self, "-movedown \n");
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

	if ((self.button2) && (!self.crouch))
	{
	
		PlayerJump();
	}
	else
		self.flags = self.flags | FL_JUMPRELEASED;

	if ((self.watertype == CONTENT_LAVA) || (self.fakewatertype == CONTENT_LAVA))
	{
		self.velocity_x = self.velocity_x *self.realmaxspeed * lava_speed;
		self.velocity_y = self.velocity_y *self.realmaxspeed * lava_speed;
	}
	else
	{
		if ((time > self.melee_jump_time) && (time > self.jumptime) && (self.flags & FL_ONGROUND) ) 
		{
			self.velocity_x = self.velocity_x *self.realmaxspeed;
			self.velocity_y = self.velocity_y *self.realmaxspeed;
		}
	}


	if (((!(self.button4)) && (self.crouch))   && (self.crushingtime <= time) )
	{
	if (self.rmenu == 1)
		return;
		Crouch_Off();
	}

	if (((self.button4) && (!self.crouch)) || ((self.crushingtime > time)&& (!self.crouch)))
	{
	if (self.rmenu == 1)
		return;
		Crouch_On();
	}



	if((self.flags & FL_ONGROUND) && (self.groundentity.flags & FL_MONSTER) && (self.onmonsterjumptime < time) )
	{
		self.onmonsterjumptime = time  + 0.3;
		self.velocity_z  += random(50,70);
		self.velocity_x  += random(90, 120) * crandom2() ;
		self.velocity_y  += random(90, 120) * crandom2();
	}
	if ((self.heretic_sloweffectime > time))
	{
		if ((self.crouch == 1) && (self.flags &FL_ONGROUND) && (self.maxspeed != 0.5))
			self.maxspeed = 0.5;	// multiplier of the velocity of the player	
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

	if ((self.cursor_trace_ent.classname == "monster_buffer") && (self.cursor_trace_ent.walktime < time))
	{
		self.cursor_trace_ent.strafetime = time + random(0.25,0.75);
		self.cursor_trace_ent.walktime =  time + random(0.75,1);
		self.strafetime = 0;
	}

	if ((self.cursor_trace_ent.flags &FL_MONSTER) && (self.cursor_trace_ent.health > 0) && ((vlen(self.cursor_trace_endpos - self.cursor_trace_start)) < 4096))
	{
		if (!(self.crosshairflag &2))
			self.crosshairflag += 2;

		/*if (skill >= 1)
		{
			if ((self.cursor_trace_ent.classname == "monster_wraith") && (self.cursor_trace_ent.enemy == self) && (self.cursor_trace_ent.strafetime < time))
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

	if (time > self.maxspeedtime)
	{
		if(self.maxspeed < self.realmaxspeed)
		{
			self.realmaxspeed -= sliding_ammount_d;
		}	
		if(self.maxspeed > self.realmaxspeed)
		{
			self.realmaxspeed += sliding_ammount_i;
		}	
		self.maxspeedtime =  time + 1/sliding_fps;
	}

	if(self.shake_camera_time > time)
	{
		if(self.shake_camera_delay > time)
		return;
		if(self.shaked == 1)
		{
		self.punchangle_x =random(self.shake_camera_ammounty * -1, self.shake_camera_ammountx * -0.5);
		self.punchangle_y =random(self.shake_camera_ammountx * -1, self.shake_camera_ammountx * -0.5);
		self.shaked = 2;
		}
		else
		{
		self.punchangle_x =random(self.shake_camera_ammounty * 0.5, self.shake_camera_ammounty);
		self.punchangle_y =random(self.shake_camera_ammountx * 0.5,self.shake_camera_ammountx);
		self.shaked = 1;
		}
		self.shake_camera_delay = time + self.shake_camera_refresh_rate;
	}


//self.realmaxspeed  = self.maxspeed;

//	if(self.flags & FL_ONGROUND)
//	self.onground_time = time + self.extraongroundtime;

	//find_nearest_waypoint(self, world);
};

.float jump_flag;	// player jump flag

.float nomelee;
.float checkweaponflag;
void() nowater_type =
{
self.waterlevel = 0;
self.fakewatertype = 0;
self.zerogtime = 0;
self.fwatershifttime = 0;
self.fwatershift = 0;
}

void() check_weapons = 
{
	self.checkweaponflag = 1;
};

.float tether_model_client;
.float shrine_model_client;
.float artifact_model_client;
.float sigil_model_client;
.float v_nextthink;
.entity artifact_client2;

void() artifact_client_remove2 = 
{
	if (self.owner.shrine_model_client == 1)
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

void() artifact_client_remove3 = 
{
	if (self.owner.tether_model_client == 1)
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
void() artifact_client_remove = 
{
	if ((self.owner.radial_time > time) && (self.owner.artifact_model_client == 2))
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

void() artifact_client_think = 
{
	self.alpha += 0.1;

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

void() sigil_client_remove = 
{ 	
	if (self.owner.timefly < time)
	{
		self.alpha -= 0.1;
	}
	else
	{
		local float maxalpha;
		maxalpha = 1;
		if (self.alpha < maxalpha)
			self.alpha += 0.1;
	}
	if (self.alpha <= 0.1)
	{
		self.think = SUB_Remove;
		self.owner.sigil_model_client = 0;
	}
	else
		self.think = sigil_client_remove;

	self.nextthink = time + 0.05;
};


void() sigil_client_think = 
{ 
	self.alpha += 0.1;
	local float maxalpha;
	maxalpha = 1;

	if (self.alpha < maxalpha)
		self.think = sigil_client_think;
	else
		self.think = sigil_client_remove;
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


		local entity sigil_client;
		if((self.timefly > time) && (self.sigil_model_client == 0))
		{
			sigil_client = spawn();
			sigil_client.owner = self;
			sigil_client.effects = 256;
			sigil_client.viewmodelforclient = self;
			setorigin(sigil_client, '0 0 0');
			sigil_client.oldangles = self.angles;
			sigil_client.frame = 0;
			sigil_client.alpha = 0.01;
			self.sigil_model_client = 1;
			setmodel(sigil_client, "models/artifacts/active/sigil_flight_active.md3");
			sigil_client.think = sigil_client_think;
			sigil_client.nextthink = time;
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
					setmodel(artifact_client, "models/misc/null.md3");
				}
				artifact_client.lifetime = time + 30;
				artifact_client.think = artifact_client_think;
				artifact_client.nextthink = time;
			}
		}
	};
.float fakewatertype;
.float check_centered;
.float lungefree;
void() PlayerPostThink = 
{
	
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
	if (self.rcannonpulsetime < time)
	{
		if (self.pulseicons & 2048)
			self.pulseicons -= 2048;
	}

	if (self.cannonpulsetime > time)
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
	//////////////////////	
	if (self.rlancepulsetime < time)
	{
		if (self.pulseicons & 8192)
			self.pulseicons -= 8192;
	}

	if (self.lancepulsetime > time)
	{
		if (!(self.pulseicons &4096))
			self.pulseicons += 4096;
	}
	else
	{
		if (self.pulseicons &4096)
			self.pulseicons -= 4096;
	}


	//////////////////////		//////////////////////		//////////////////////		//////////////////////	
	if (self.rarmorpulsetime < time)
	{
		if (self.pulseicons &32768)
			self.pulseicons -= 32768;
	}

	if (self.armorpulsetime > time)
	{
		if (!(self.pulseicons &16384))
			self.pulseicons += 16384;
	}
	else
	{
		if (self.pulseicons &16384)
			self.pulseicons -= 16384;
	}

	//////////////////////	
	if (self.rdarmorpulsetime < time)
	{
		if (self.pulseicons &131072)
			self.pulseicons -= 131072;
	}

	if (self.darmorpulsetime > time)
	{
		if (!(self.pulseicons &65536))
			self.pulseicons += 65536;
	}
	else
	{
		if (self.pulseicons &65536)
			self.pulseicons -= 65536;
	}

	//////////////////////	
	if ((self.flags &FL_ONGROUND) && (self.lungefree > time))
	self.lungefree = 0;
	if ((self.flags &FL_ONGROUND) && (self.melee_released > 0) && (!self.button3) && (time > self.melee_jump_time))
		self.melee_released = 0;
	if ((self.fakewatertype) && (self.watertype_time < time))
		self.fakewatertype = 0;

	if (self.wrath_debug_screen)
		checking_enemies();
	ArtifactClientModel();
	WeaponFrames();	// do weapon stuff
	if (self.maxspeed >= 0.75)
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

	if ((!(self.flags &FL_ONGROUND)) && (self.movetype == MOVETYPE_WALK))
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
	//float speed_f = vlen(self.velocity);
	//string viewxanglesfactor = strcat ((ftos (self.v_angle_x)), (" movement\n"));
	//bprint (viewxanglesfactor);

	//local string lmessage;
	//lmessage =strcat ((self.nearestsurface),("\n")) ;
	//bprint (lmessage);
};
void() Check_FrikFile;

string nextmap;
void() monster_relocator = 
{
	local entity monster;

	monster = findradius(self.origin, 1000000);
	while (monster)
	{
		if ((monster.flags &FL_MONSTER) && (monster.health >= 0))
		{
			setorigin(monster, monster.oldorigin);
			monster.angles = monster.oldangles;
			monster.think = monster.th_stand;
			monster.nextthink = time;
			monster.enemy = 0;
		}

		monster = monster.chain;	
	}
};
void(entity ownr) client_garbage_collector = 
{
	local entity garbage;
	garbage = findradius(self.origin, 1000000);
	while (garbage)	
	{
		if ((garbage.wrathflags &FL_GARBAGE) && (garbage.owner == ownr))
		{
			remove(garbage);
		}

		garbage = garbage.chain;	
	}
	//spawn_dead_model(ownr.origin, ownr.angles); // player models
};

void() garbage_collector = 
{
	local entity garbage;
	garbage = findradius(self.origin, 1000000);
	while (garbage)	
	{
		if (garbage.wrathflags &FL_GARBAGE)
		{
			remove(garbage);
		}

		garbage = garbage.chain;	
	}
};
void() message_garbage_collector = 
{
	local entity garbage;
	garbage = findradius(self.origin, 1000000);
	while (garbage)	
	{
		if (garbage.wrathflags &FL_MESSAGE)
		{
			remove(garbage);
		}
		garbage = garbage.chain;	
	}
};

void() respawn_entities = 
{
	local entity respawneable;
	respawneable = findradius(self.origin, 1000000);
	while (respawneable)	
	{
		if (respawneable.wrathflags &FL_RESPAWN)
		{
			respawneable.think = paste_old_data;
			respawneable.nextthink = time;
		}

		respawneable = respawneable.chain;	
	}
};
void() SetChangeParms;
void() loadlevel = 
{
	stuffcmd(self, "slowmo 1\n");stuffcmd(self, "r_glsl_saturation 1\n");
	read_currentprofileslot();
	stuffcmd(self, "set cvar_restoregame 1\n");
	string cname;
	cname = strcat("load data/profiles/", profilename, "/maps/", nextmap, "\n");
	stuffcmd(self, cname);
};

void() changemap = 
{
	changelevel(nextmap);
}

void(entity e) changelevel_wait = 
{
	e.changing_level = 1;
	e.nextthink = time + 1.5;
	e.think = changemap;
};
void() ParmstoFrik;
void(entity e) loadlevel_wait = 
{
	e.changing_level = 1;
	e.nextthink = time + 1.5;
	e.think = loadlevel;
};
void(entity e) changeparms2 = 
{
	parm1 = e.items;
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
	parm28 = e.Attar;
	parm29 = e.savedlist;

};
void(entity e) GotoNextMap = 
{
	stuffcmd(e, "bf 0 0 0 2 0\n");
	local float loadingmap;
	if ((e.explored_maps &LE_HUB1) && (nextmap == "hub1"))
		loadingmap = 1;
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
	if ((e.explored_maps &LE_HUB2) && (nextmap == "hub2"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M1) && (nextmap == "e2m1"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M2) && (nextmap == "e2m2"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M3) && (nextmap == "e2m3"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M4) && (nextmap == "e2m4"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E2M5) && (nextmap == "e2m5"))
		loadingmap = 1;
	if ((e.explored_maps &LE_HUB3) && (nextmap == "hub3"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M1) && (nextmap == "e3m1"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M2) && (nextmap == "e3m2"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M3) && (nextmap == "e3m3"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M4) && (nextmap == "e3m4"))
		loadingmap = 1;
	if ((e.explored_maps &LE_E3M5) && (nextmap == "e3m5"))
		loadingmap = 1;
	//changeparms2(e);

	if (loadingmap == 1)
		loadlevel_wait(e);
	else
		changelevel_wait(e);

};
string currentmap;
void(entity e) write_exploredmap = {read_currentprofileslot();
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
	if (world.model == "maps/e1m3.bsp")
	{
		if (e.foundedrelics &RL_E1M3)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e1m4.bsp")
	{
		if (e.foundedrelics &RL_E1M4)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e1m5.bsp")
	{
		if (e.foundedrelics &RL_E1M5)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e2m1.bsp")
	{
		if (e.foundedrelics &RL_E1M1)
			hasrelic = "1";
		else
			hasrelic = "0";
	}

	if (world.model == "maps/e2m2.bsp")
	{
		if (e.foundedrelics &RL_E1M2)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e2m3.bsp")
	{
		if (e.foundedrelics &RL_E1M3)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e2m4.bsp")
	{
		if (e.foundedrelics &RL_E1M4)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e2m5.bsp")
	{
		if (e.foundedrelics &RL_E1M5)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e3m1.bsp")
	{
		if (e.foundedrelics &RL_E1M1)
			hasrelic = "1";
		else
			hasrelic = "0";
	}

	if (world.model == "maps/e3m2.bsp")
	{
		if (e.foundedrelics &RL_E1M2)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e3m3.bsp")
	{
		if (e.foundedrelics &RL_E1M3)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e3m4.bsp")
	{
		if (e.foundedrelics &RL_E1M4)
			hasrelic = "1";
		else
			hasrelic = "0";
	}
	if (world.model == "maps/e3m5.bsp")
	{
		if (e.foundedrelics &RL_E1M5)
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
.float totallungetime;
void() changelevel_touch = 
{
	if (self.wait > time)
		return;
	if (other.classname != "player")
		return;
	message_garbage_collector ();
	nowater_type();
	if (time < other.totallungetime)
		return;
	local float invrtmsb;
	if (stof(cvar_string("m_pitch")) < 0)
		invrtmsb = 1;
	else
		invrtmsb = 0;
	garbage_collector();

/*	if(invrtmsb)
	stuffcmd(other, "m_pitch -0.001\n");
	else
	stuffcmd(other, "m_pitch 0\n");
	
	stuffcmd(other, "m_yaw 0\n");
*/	
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

	other.items = other.items - (other.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
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
	if (world.model == "maps/hub2.bsp")
	{
		if (!(other.explored_maps &LE_HUB2))
			other.explored_maps += LE_HUB2;
		loadingmap = 1;
	}

	if (world.model == "maps/e2m1.bsp")
	{
		if (!(other.explored_maps &LE_E2M1))
			other.explored_maps += LE_E2M1;
		loadingmap = 1;
	}

	if (world.model == "maps/e2m2.bsp")
	{
		if (!(other.explored_maps &LE_E2M2))
			other.explored_maps += LE_E2M2;
		loadingmap = 1;
	}

	if (world.model == "maps/e2m3.bsp")
	{
		if (!(other.explored_maps &LE_E2M3))
			other.explored_maps += LE_E2M3;
		loadingmap = 1;
	}

	if (world.model == "maps/e2m4.bsp")
	{
		if (!(other.explored_maps &LE_E2M4))
			other.explored_maps += LE_E2M4;
		loadingmap = 1;
	}

	if (world.model == "maps/e2m5.bsp")
	{
		if (!(other.explored_maps &LE_E2M5))
			other.explored_maps += LE_E2M5;
		loadingmap = 1;
	}
	if (world.model == "maps/hub3.bsp")
	{
		if (!(other.explored_maps &LE_HUB3))
			other.explored_maps += LE_HUB3;
		loadingmap = 1;
	}

	if (world.model == "maps/e3m1.bsp")
	{
		if (!(other.explored_maps &LE_E3M1))
			other.explored_maps += LE_E3M1;
		loadingmap = 1;
	}

	if (world.model == "maps/e3m2.bsp")
	{
		if (!(other.explored_maps &LE_E3M2))
			other.explored_maps += LE_E3M2;
		loadingmap = 1;
	}

	if (world.model == "maps/e3m3.bsp")
	{
		if (!(other.explored_maps &LE_E3M3))
			other.explored_maps += LE_E3M3;
		loadingmap = 1;
	}

	if (world.model == "maps/e3m4.bsp")
	{
		if (!(other.explored_maps &LE_E3M4))
			other.explored_maps += LE_E3M4;
		loadingmap = 1;
	}

	if (world.model == "maps/e3m5.bsp")
	{
		if (!(other.explored_maps &LE_E3M5))
			other.explored_maps += LE_E3M5;
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

void() trigger_changelevel = 
{
	if (!self.map)
		objerror("changelevel trigger doesn't have map");
	InitTrigger();
	self.wait = 0;
	self.touch = changelevel_touch;
};

void() portal_level_active = 
{
	self.touch = changelevel_touch;
};

void() portal_level_to_hub_active = 
{
	self.frame = 1;
	self.effects = 0;
	self.think = portal_level_active;
	self.nextthink = time + 1;
};

void() portal_level_to_hub_active_wait = 
{
	self.think = portal_level_to_hub_active;
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
void() portal_level_to_hub = 
{
	precache_model("models/portals/portal_level_to_hub.md3");
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
.float angle2;
entity() SelectSpawnPoint = 
{
	local entity spot;

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
void() FriktoParms = 
{
	local float readparms;
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
	readtext = fgets(readparms);parm28 = stof(readtext);
	readtext = fgets(readparms);parm29 = stof(readtext);

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
void() ParmstoFrik = 
{
	local float writeparms;
	local string writethis, saveloc;
	read_currentprofileslot();
	self.slot_keys = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
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
	writethis = ftos(parm28);fputs(writeparms, writethis);fputs(writeparms, "\n");
	writethis = ftos(parm29);fputs(writeparms, writethis);fputs(writeparms, "\n");
	fclose(writeparms);
};

void() SetChangeParms = 
{
	if (self.health <= 0)
	{
		self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
		self.slot_keys = 0;
		SetNewParms();
		return;
	}

	// remove items
	self.slot_keys = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
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
	parm28 = self.Attar;
	parm29 = self.savedlist;
};

void() SetNewParms = 
{
	if (!self.nomelee)
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
	parm28 = 0;	//self.Attar = 0;
	parm29 = 0;

};

void() DecodeLevelParms = 
{
	self.items = parm1;
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
	self.Attar = parm28;
	self.savedlist = parm29;

};

.float oldrelics_start;
void()recount_monsters;
void() RestoreGame = {
	self.check_centered = 1;
	single_player = self;
	localcmd("v_cshift\n");
	stuffcmd(self, "slowmo 1\n");
	stuffcmd(self, "r_glsl_saturation 1\n");



	local entity garbage;
	garbage = findradius(self.origin, 1000000);
	while (garbage)
	{
		if (garbage.classname == "coffer_trap")
		{
			remove(garbage);
		}

		garbage = garbage.chain;
	}

	if (cvar("cvar_restoregame") == 2)
	{
	//message_garbage_collector ();
	//Hud_message(24, self.origin, self);
	localcmd("set cvar_restoregame 0\n");
		return;
	}
	if (cvar("cvar_restoregame") == 3)
	{
	//message_garbage_collector ();
	//Hud_message(26, self.origin, self);
	localcmd("set cvar_restoregame 0\n");
	return;
	}
				
	if (cvar("cvar_restoregame") != 1)
	{
		return;
	}
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
	if (self.timefly <= time)
	{
		self.radialactive = 0;
		self.movetype = MOVETYPE_WALK;	// Yep, I want to walk.
		stuffcmd (self, "alias +button4  \"\" \n");
		stuffcmd (self, "alias -button4  \"\" \n");
		stuffcmd (self, "alias +jump  \"\" \n");
		stuffcmd (self, "alias -jump  \"\" \n");
		stuffcmd (self, "-jump \n");
		stuffcmd (self, "-jump \n");
		stuffcmd (self, "-moveup \n");
		stuffcmd (self, "-movedown \n");
	}
	else
	{
		self.timeflyc = rint(time - self.timefly);
		if (self.movetype != MOVETYPE_FLY)
			self.movetype = MOVETYPE_FLY;
		stuffcmd (self, "alias +button4  \"+movedown\" \n");
		stuffcmd (self, "alias -button4  \"-movedown\" \n");
		stuffcmd (self, "alias +jump  \"+moveup\" \n");
		stuffcmd (self, "alias -jump  \"-moveup\" \n");
	}

	self.flags = FL_CLIENT;	// Yes, I'm a client.
	self.origin = spawn_spot.origin;	// + '0 0 10';	// Move to the spawnspot location
	self.angles = spawn_spot.angles;	// Face the angle the spawnspot indicates
	self.fixangle = TRUE;	// Turn this way immediately
	setmodel(self, "models/misc/null.md3");	// Set my player to the player model
	//setmodel(self, "models/enemies/fallen/fallen1.md3");
	setsize(self, '-16 -16 -32', '16 16 32');
	self.view_ofs_z = player_zviewofs;	// Center my view
	self.velocity = '0 0 0';	// Stop any old movement
	self.coachgunclip = 0;
	//	self.ammo_coachgun = 0;
	stuffcmd(self, "cl_forwardspeed 416\n");
	stuffcmd(self, "cl_backspeed 416\n");
	stuffcmd(self, "cl_sidespeed 416\n");
	self.air_finished = time + 12;
	self.attack_finished = time;
	self.th_pain = Player_Pain;
	self.th_die = Player_Die;
	self.maxspeed = 1;
	self.realmaxspeed = 1;
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
	self.viewzoom = 1;
	self.oldrelics_start = self.oldrelics;
	self.autosavetime = time + 0.5;
	self.autosaved = 0;
	self.menuactive = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
	self.slot_keys = 0;
	refresh_custom_cvars();
};

void() check_spotted_maps = 
{
	
	if (world.model == "maps/hub1.bsp")
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
	if (world.model == "maps/hub2.bsp")
	{
		if (!(self.spotted_maps &LE_HUB2))
			self.spotted_maps += LE_HUB2;
	}

	if (world.model == "maps/e2m1.bsp")
	{
		if (!(self.spotted_maps &LE_E2M1))
			self.spotted_maps += LE_E2M1;
	}

	if (world.model == "maps/e2m2.bsp")
	{
		if (!(self.spotted_maps &LE_E2M2))
			self.spotted_maps += LE_E2M2;
	}

	if (world.model == "maps/e2m3.bsp")
	{
		if (!(self.spotted_maps &LE_E2M3))
			self.spotted_maps += LE_E2M3;
	}

	if (world.model == "maps/e2m4.bsp")
	{
		if (!(self.spotted_maps &LE_E2M4))
			self.spotted_maps += LE_E2M4;
	}

	if (world.model == "maps/e2m5.bsp")
	{
		if (!(self.spotted_maps &LE_E2M5))
			self.spotted_maps += LE_E2M5;
	}
	if (world.model == "maps/hub3.bsp")
	{
		if (!(self.spotted_maps &LE_HUB3))
			self.spotted_maps += LE_HUB3;
	}

	if (world.model == "maps/e3m1.bsp")
	{
		if (!(self.spotted_maps &LE_E3M1))
			self.spotted_maps += LE_E3M1;
	}

	if (world.model == "maps/e3m2.bsp")
	{
		if (!(self.spotted_maps &LE_E3M2))
			self.spotted_maps += LE_E3M2;
	}

	if (world.model == "maps/e3m3.bsp")
	{
		if (!(self.spotted_maps &LE_E3M3))
			self.spotted_maps += LE_E3M3;
	}

	if (world.model == "maps/e3m4.bsp")
	{
		if (!(self.spotted_maps &LE_E3M4))
			self.spotted_maps += LE_E3M4;
	}

	if (world.model == "maps/e3m5.bsp")
	{
		if (!(self.spotted_maps &LE_E3M5))
			self.spotted_maps += LE_E3M5;
	}
};
void() object_fakecoffer;
void() PutClientInServer = 
{
	local entity spawn_spot;	// This holds where we want to spawn
	spawn_spot = SelectSpawnPoint();
	self.nomelee = spawn_spot.nomelee;


	if (deathmatch)
	{


	self.health =  100;	
	SetNewParms();
	}
	DecodeLevelParms();
	self.classname = "player";	// I'm a player!
	single_player = self;
	if (spawn_spot.health)
		self.health = spawn_spot.health;
	if (self.health < 1)
		self.health = 1;
	recount_monsters();	
	self.max_health = 100;	// My health (and my max) is 100
	self.takedamage = DAMAGE_AIM;	// I can be fired at
	self.solid = SOLID_SLIDEBOX;	// Things sort of 'slide' past me
	self.movetype = MOVETYPE_WALK;	// Yep, I want to walk.
	self.flags = FL_CLIENT;	// Yes, I'm a client.
	self.origin = spawn_spot.origin;	// + '0 0 10';	// Move to the spawnspot location
	self.angles = spawn_spot.angles;	// Face the angle the spawnspot indicates
	if(spawn_spot.angle2)
	{
		float r = random();
		if (r > 0.5)
			self.angles_y = spawn_spot.angle2;
	}
	self.fixangle = TRUE;	// Turn this way immediately
	setmodel(self, "models/misc/null.md3");	// Set my player to the player model
	//setmodel(self, "models/enemies/fallen/fallen1.md3");
	self.view_ofs_z = player_zviewofs;	// Center my view
	self.velocity = '0 0 0';	// Stop any old movement
	self.air_finished = time + 12;
	self.attack_finished = time;
	self.th_pain = Player_Pain;
	self.th_die = Player_Die;
	self.maxspeed = 1;
	self.realmaxspeed = 1;
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
	stuffcmd (self, "alias +button4  \"\" \n");
	stuffcmd (self, "alias -button4  \"\" \n");
	stuffcmd (self, "alias +jump  \"\" \n");
	stuffcmd (self, "alias -jump  \"\" \n");
	////lbeams
	self.charge_shotgun = 1;
	stuffcmd(self, "cl_forwardspeed 416\n");
	stuffcmd(self, "cl_backspeed 416\n");
	stuffcmd(self, "cl_sidespeed 416\n");
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
	self.playerdeadtime = 0;
	self.items = self.items - (self.items &(IT_KEY1 | IT_KEY2 | IT_KEY3 | IT_COFFERKEY1 | IT_COFFERKEY2| IT_COFFERKEY3));
	self.slot_keys = 0;
	if (deathmatch == 1)
	self.health =  100;	
	self.viewzoom = 1;
	//spawn_player_model(self); // player_model
	setsize(self, '-16 -16 -32', '16 16 32');
	check_custom_cvars();
	localcmd("set cvar_nodegraph 0\n");

	float forcedencounter = cvar("cl_forcedencounter");	
	float noqcprecaches = cvar("cl_noqcprecache");	

	if(forcedencounter >= 1)
	{

	if(noqcprecaches >= 1)
	string noprecaches= "playing a noqcprecached game";

	self.oldrelics = forcedencounter - 1;
	centerprint(self, strcat("Using forced encounter ", ftos (forcedencounter)," \n",noprecaches," \n"));
	}
	else
	{
	if(noqcprecaches >= 1)
	centerprint(self, ("playing a noqcprecached game\n"));
	}	
	/*
	r = random();
	if(r <= 0.01)
	{
		makevectors (self.angles);
		entity fake_coffer = spawn();
		fake_coffer.angles = self.angles;
		fake_coffer.angles_y += 180;
		fake_coffer.origin = self.origin + v_forward * 128;
		fake_coffer.think = object_fakecoffer;
		fake_coffer.nextthink = time; 
	}
	*/
    self.clipgroup = 1;    

};

void(entity targ, entity attacker) ClientObituary = 
{
	bprint(" died\n");
};

///////////////////////////////
