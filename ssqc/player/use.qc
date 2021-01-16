.string link;
.string linked;
void() button_fire;
void() door_puse;
.string targetname2;
.entity followner;

void() switching_following = 
{
	//self.velocity = self.followner.velocity;
	self.think = switching_following;
	self.nextthink = time;
};

void() object_switch_fire_wait = 
{
	self.skin = 0;
	self.usable = 1;
	self.think = SUB_Null;
};

void() object_switch_fire_wait2 = 
{
	self.skin = 0;
	SUB_UseTargets();
	self.think = SUB_Null;
};

void() object_switch_fire1 = 
{
	self.skin = 1;
	self.usable = 0;
	if (self.spawnflags == 1)
		self.think = SUB_Null;
	else
		self.think = object_switch_fire_wait;
	self.nextthink = time + self.wait;
};

void() object_switch_fire = 
{
	self.skin = 1;
	SUB_UseTargets();
	self.usable = 0;
	if (self.spawnflags == 1)
		self.think = SUB_Null;
	else
		self.think = object_switch_fire_wait;
	self.nextthink = time + self.wait;
};
void() object_switch = 
{
	if (!self.wait)
		self.wait = 2;
	if (self.wait < 0)
		self.spawnflags = 1;
	setmodel(self, "models/objects/switch1.md3");
	self.solid = SOLID_BSP;
	if (self.target2)
	{
		self.followner = find(world, classname, "func_door");
		self.colormod = '1 1 0';
		setattachment(self, self.followner, "");
	}

	setsize(self, '-16 -16 -24', '16 16 24');
	self.usable = 1;
	self.use = object_switch_fire;
};

.float switch_state;

void() nonsolidswitch_fire_off = 
{
	if (self.frame == 9)
		sound(self, CHAN_AUTO, self.noise2, 1, 1);
	self.frame -= 1;
	self.glowmod_x += 0.1;
	self.glowmod_y += 0.1;
	self.glowmod_z += 0.1;

	if (!self.frame)
	{
		self.think = SUB_Null;
		self.usable = 1;
	}
	else
		self.think = nonsolidswitch_fire_off;
	self.nextthink = time + 0.05;
};

void() nonsolidswitch_fire = 
{
	self.frame += 1;
	self.usable = 0;
	if (self.frame == 1)
	{
		sound(self, CHAN_AUTO, self.noise, 1, 1);
		SUB_UseTargets();
	}

	self.glowmod_x -= 0.1;
	self.glowmod_y -= 0.1;
	self.glowmod_z -= 0.1;

	if (self.frame == 9)
	{
		if (self.wait != -1)
			self.think = nonsolidswitch_fire_off;
		else
			self.think = SUB_Null;
		self.nextthink = time + self.wait;
	}
	else
	{
		self.think = nonsolidswitch_fire;
		self.nextthink = time + 0.05;
	}
};

void() switch_e1_switch1 = 
{
	precache_model("models/objects/switches/e1_switch1.md3");
	precache_sound("objects/switches/e1_switch1.ogg");
	precache_sound("objects/switches/e1_switch_reset.ogg");
	self.noise = "objects/switches/e1_switch1.ogg";
	self.noise2 = "objects/switches/e1_switch1_reset.ogg";
	setmodel(self, "models/objects/switches/e1_switch1.md3");
	self.classname = "nonsolidswitch";

	if (!self.wait)
		self.wait = -1;
	self.usable = 1;

	self.solid = SOLID_TRIGGER;
	setsize(self, '-10 -10 -16', '10 10 32');
	self.glowmod_x = 1;
	self.glowmod_y = 1;
	self.glowmod_z = 1;
};
void(entity e, vector v) SetVel = 
{
	e.velocity = v;
};
void() use_coffer;
.float buttondecal;
void() bboxbutton_think;
.float keyrequired;

void(float keynumber) quitkey = 
{
	string cent, dozen, unit, slotdigits;
	float cent_s, dozen_s, unit_s, currentslotkeyvalue, multiplier, slotkeynumber;
	slotdigits = ftos(self.slot_keys);
	cent = substring(slotdigits, 0, 1);
	dozen = substring(slotdigits, 1, 1);
	unit = substring(slotdigits, 2, 1);

	cent_s = stof(cent);
	dozen_s = stof(dozen);
	unit_s = stof(unit);
	slotkeynumber = self.slot_keys;
	if (keynumber == cent_s)
	{
		currentslotkeyvalue = (keynumber *100);
		slotkeynumber = (slotkeynumber - currentslotkeyvalue);
		slotkeynumber = slotkeynumber * 10;
	}

	if (keynumber == dozen_s)
	{
		currentslotkeyvalue = keynumber * 10;
		slotkeynumber = (slotkeynumber - (currentslotkeyvalue + unit_s)) + (unit_s *10);
	}

	if (keynumber == unit_s)
	{
		currentslotkeyvalue = keynumber * 1;
		if (slotkeynumber >= 10)
			multiplier = 0.1;
		else
			multiplier = 0;
		slotkeynumber = (slotkeynumber - (currentslotkeyvalue)) *multiplier;
	}

	self.slot_keys = slotkeynumber;
};

void(float keynumber) quitrelic = 
{
	string dthous, thous, cent, dozen, unit, slotdigits;
	float dthous_s, thous_s, cent_s, dozen_s, unit_s, currentslotkeyvalue, multiplier, slotkeynumber;
	slotdigits = ftos(self.slot_relics);
	dthous = substring(slotdigits, 0, 1);
	thous = substring(slotdigits, 1, 1);
	cent = substring(slotdigits, 2, 1);
	dozen = substring(slotdigits, 3, 1);
	unit = substring(slotdigits, 4, 1);

	dthous_s = stof(dthous);
	thous_s = stof(thous);
	cent_s = stof(cent);
	dozen_s = stof(dozen);
	unit_s = stof(unit);

	slotkeynumber = self.slot_relics;
	if (keynumber == dthous_s)
	{
		currentslotkeyvalue = (keynumber *10000);
		slotkeynumber = (slotkeynumber - currentslotkeyvalue);
		slotkeynumber = slotkeynumber * 10;
	}

	if (keynumber == thous_s)
	{
		currentslotkeyvalue = (keynumber *1000);
		slotkeynumber = (slotkeynumber - (currentslotkeyvalue + cent_s * 100 + dozen_s *10 + unit_s)) + (cent_s *1000)  + (dozen_s *100) + (unit_s *10);
	}

	if (keynumber == cent_s)
	{
		currentslotkeyvalue = (keynumber *100);
		slotkeynumber = (slotkeynumber - (currentslotkeyvalue + dozen_s *10 + unit_s)) + (dozen_s *100) + (unit_s *10);
	}

	if (keynumber == dozen_s)
	{
		currentslotkeyvalue = keynumber * 10;
		slotkeynumber = (slotkeynumber - (currentslotkeyvalue + unit_s)) + (unit_s *10);
	}

	if (keynumber == unit_s)
	{
		currentslotkeyvalue = keynumber;

		if (slotkeynumber >= 10)
			multiplier = 1;
		else
			multiplier = 0;
		slotkeynumber = (slotkeynumber - (currentslotkeyvalue)) *multiplier;
	}

	self.slot_relics = slotkeynumber;
};

.float pillar_a_activated;
.float pillar_b_activated;
.float pillar_c_activated;
.float pillar_d_activated;
.float pillar_e_activated;
.entity keyson1;
.entity keyson2;
.entity keyson3;
.entity ykeyson;
.entity bkeyson;
.entity rkeyson;

void() Use_Func = 
{
	local vector source;
	makevectors(self.v_angle);
	source = self.origin + self.view_ofs - v_forward * 4;	// 
	wtraceline(source, source + v_forward *72, FALSE, self);

	if (!(self.crosshairflag &1))
		return;

	if (self.usingnonsolidswitch)
	{
		self.nonsolidswitch.enemy = self;
		self.nonsolidswitch.think = nonsolidswitch_fire;
		self.nonsolidswitch.nextthink = self.nonsolidswitch.ltime + 0.01;
		self.use_finished = time + 0.05;
		return;
	}

	if (trace_fraction == 1.0)
		return;
	self.use_finished = time + 0.05;
	if (!trace_ent.usable)
		return;
	if (trace_ent.classname == "coffer")
	{
		if (trace_ent.keyrequired)
		{
			if (!(self.items &IT_COFFERKEY1))
			{
				Hud_message(37, self.origin, self);
				sound(trace_ent, CHAN_VOICE, trace_ent.noise2, 1, 0.5);
				return;
			}
			else
			{
			
				if(self.items & IT_COFFERKEY3)
					{self.items -= IT_COFFERKEY3;self.keyson3.wrathflags -= FL_RESPAWN;}
				else
				{
					if(self.items & IT_COFFERKEY2)
						{self.items -= IT_COFFERKEY2;self.keyson2.wrathflags -= FL_RESPAWN;}
					else
						{self.items -= IT_COFFERKEY1; self.keyson1.wrathflags -= FL_RESPAWN;}
				}	
			}
		}

		trace_ent.enemy = self;
		trace_ent.think = use_coffer;
		trace_ent.nextthink = time + 0.01;
		return;
	}

	if (trace_ent.classname == "portalhub1_a")
	{
		if (!(self.relics &RL_E1M1))
			return;
		sound(trace_ent, CHAN_AUTO, "objects/hub1_pillar.ogg", 1, 0.25);
		trace_ent.owner.pillar_a_activated = 1;
		trace_ent.usable = 0;
		self.relics -= RL_E1M1;
		quitrelic(1);
		return;
	}

	if (trace_ent.classname == "portalhub1_b")
	{
		if (!(self.relics &RL_E1M2))
			return;
		sound(trace_ent, CHAN_AUTO, "objects/hub1_pillar.ogg", 1, 0.25);
		trace_ent.owner.pillar_b_activated = 1;
		trace_ent.usable = 0;
		self.relics -= RL_E1M2;
		quitrelic(2);
		return;
	}

	if (trace_ent.classname == "portalhub1_c")
	{
		if (!(self.relics &RL_E1M3))
			return;
		sound(trace_ent, CHAN_AUTO, "objects/hub1_pillar.ogg", 1, 0.25);
		trace_ent.owner.pillar_c_activated = 1;
		trace_ent.usable = 0;
		self.relics -= RL_E1M3;
		quitrelic(3);
		return;
	}

	if (trace_ent.classname == "portalhub1_d")
	{
		if (!(self.relics &RL_E1M4))
			return;
		sound(trace_ent, CHAN_AUTO, "objects/hub1_pillar.ogg", 1, 0.25);
		trace_ent.owner.pillar_d_activated = 1;
		trace_ent.usable = 0;
		self.relics -= RL_E1M4;
		quitrelic(4);
		return;
	}

	if (trace_ent.classname == "portalhub1_e")
	{
		if (!(self.relics &RL_E1M5))
			return;
		sound(trace_ent, CHAN_AUTO, "objects/hub1_pillar.ogg", 1, 0.25);
		trace_ent.owner.pillar_e_activated = 1;
		trace_ent.usable = 0;
		self.relics -= RL_E1M5;
		quitrelic(5);		
		return;
	}

	if (trace_ent.classname == "func_button")
	{
		sound(trace_ent, CHAN_AUTO, "objects/switch1_use.ogg", 1, 1);
		trace_ent.enemy = self;
		trace_ent.think = button_fire;
		trace_ent.nextthink = trace_ent.ltime + 0.01;
		return;
	}

	if (trace_ent.buttondecal == 1)
	{
		local entity linkedbutton;
		sound(trace_ent, CHAN_AUTO, "objects/switch1_use.ogg", 1, 1);
		linkedbutton = trace_ent.owner;
		linkedbutton.enemy = self;
		linkedbutton.think = button_fire;
		linkedbutton.nextthink = trace_ent.ltime + 0.01;
		trace_ent.think = bboxbutton_think;
		trace_ent.nextthink = trace_ent.ltime + 0.01;
		return;
	}

	if (trace_ent.classname == "object_switch")
	{
		sound(trace_ent, CHAN_AUTO, "objects/switch1_use.ogg", 1, 1);
		trace_ent.enemy = self;
		trace_ent.think = object_switch_fire;
		trace_ent.nextthink = trace_ent.ltime + 0.01;
		if (trace_ent.link)
		{
			local entity t;
			t = find(world, linked, trace_ent.link);
			t.enemy = self;
			t.think = object_switch_fire1;
			t.nextthink = trace_ent.ltime + 0.01;
		}

		return;
	}

	if (trace_ent.classname == "readable")
	{
		if (self.message_time == 1)
			return;
		self.message_time = 1;
		self.journal = 2;
		self.message_number = trace_ent.message_number;
		self.message_brelease = 1;
		stuffcmd(self, "slowmo 0.1\n");
		return;
	}

	if (trace_ent.classname == "func_door")
	{
		if (trace_ent.keyrequired == 1)
		{
			if (!(self.items &IT_KEY1))// red key
			{
				//	sound (trace_ent, CHAN_VOICE,"sound/misc/Door_Locked.wav", 1, 0.5);
				Hud_message(38, self.origin, self);
				return;
			}

			self.items -= IT_KEY1;
			self.rkeyson.wrathflags -= FL_RESPAWN;
			quitkey(1);
			//sound (trace_ent, CHAN_AUTO,"sound/misc/Door_Activated_Unlock.wav", 1, 0.5);
		}

		if (trace_ent.keyrequired == 2)
		{
			if (!(self.items &IT_KEY2)) // blue key
			{
				Hud_message(36, self.origin, self);
				//	sound (trace_ent, CHAN_VOICE,"sound/misc/Door_Locked.wav", 1, 0.5);
				return;
			}

			self.items -= IT_KEY2;
			self.bkeyson.wrathflags -= FL_RESPAWN;
			quitkey(2);
			//sound (trace_ent, CHAN_AUTO,"sound/misc/Door_Activated_Unlock.wav", 1, 0.5);
		}

		if (trace_ent.keyrequired == 3)
		{
			if (!(self.items &IT_KEY3)) // yellow
			{
				Hud_message(39, self.origin, self);
				//	sound (trace_ent, CHAN_VOICE,"sound/misc/Door_Locked.wav", 1, 0.5);
				return;
			}

			self.items -= IT_KEY3;
			self.ykeyson.wrathflags -= FL_RESPAWN;
			quitkey(3);
			//sound (trace_ent, CHAN_AUTO,"sound/misc/Door_Activated_Unlock.wav", 1, 0.5);
		}

		/*if (trace_ent.keyrequired == 4)
		{
			if (!(self.items &IT_COFFERKEY1))
			{
				sound(trace_ent, CHAN_VOICE, trace_ent.noise2, 1, 0.5);
				Hud_message(37, self.origin, self);
				return;
			}
			else
				self.items -= IT_COFFERKEY1;
			self.keyson.wrathflags -= FL_RESPAWN;
		}
		*/
		trace_ent.duser = self;
		trace_ent.think = door_puse;
		trace_ent.nextthink = trace_ent.ltime + 0.01;
		return;
	}

	if (trace_ent.use)
	{
		trace_ent.enemy = self;
		trace_ent.think = trace_ent.use;
		trace_ent.nextthink = time + 0.01;
		return;
	}
};

//////////////end of qc file