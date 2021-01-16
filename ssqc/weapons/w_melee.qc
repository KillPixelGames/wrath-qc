.float oldrandomattack;
.float pick_melee;
void() v_melee_idle = 
{
	if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
	}

	if (self.pick_melee == 1)
	{
		Hud_message(258, other.origin, other);
		self.pick_melee = 0;
	}


	if(self.totallungetime > time)
	self.totallungetime = 0;

	self.realoding = 0;
	self.melee_charging = 0;
	self.vweaponstate = 0;
	self.vweaponframe = 0;

};

void(float x_ang, float y_ang) melee_angles = 
{
	x_ang = x_ang *0.25;
	y_ang = y_ang *0.25;

	msg_entity = self;
	WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle(MSG_ONE, self.v_angle_x + x_ang);
	WriteAngle(MSG_ONE, self.v_angle_y + y_ang);
	WriteAngle(MSG_ONE, self.v_angle_z);
};
void() melee_angles_center = 
{
	msg_entity = self;
	WriteByte(MSG_ONE, SVC_SETVIEWANGLES);
	WriteAngle(MSG_ONE, 0);
	WriteAngle(MSG_ONE, self.v_angle_y);
	WriteAngle(MSG_ONE, self.v_angle_z);
};
.float oldmaxspeed;

.float fvweaponframe;

.vector neworg;

void() w_melee_release_damage = 
{
	self.lungetime = time + 0.1;
	local vector source;
	local vector org;
	if (self.execution == 2)
		return;

	makevectors(self.v_angle);
	source = self.origin + '0 0 24' - v_forward * 8;
	if (self.melee_kill_uber != 1)
		tracebox(source, '-7 -7 -7', '7 7 7', source + v_forward *96, FALSE, self);
	else
		tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *48, FALSE, self);
	if (trace_fraction == 1.0)
	{
		return;
	}

	if ((trace_ent.takedamage) && (trace_ent.only_damage_monster != 1))
	{
		org = trace_endpos - v_forward * 4;
		if ((trace_ent.flags &FL_MONSTER))
		{
			playersound("impact/gibs/gib_hit", 5);
			trace_ent.death_time_sound = time + 1;
			if (self.vweaponskin != 1)
				self.vweaponskin = 1;
			self.melee_skin = 1;

		if (trace_ent.bloody == 1)
			SpawnBlood(org, '0 0 0', 20, 1, 0);
		}
		local float lunge_damage;
		lunge_damage = (self.melee_ammount *30);

		float real_health = trace_ent.health;
		if(trace_ent.shieldtime > time)
			real_health = trace_ent.health * 0.05;

		if (lunge_damage < trace_ent.health)
		{
			if (trace_ent.heavymonster != 1)
			{

				if ((trace_ent.flags &FL_MONSTER))
				{
				if(trace_ent.flags & FL_ONGROUND)
				trace_ent.flags = trace_ent.flags - FL_ONGROUND;
				//trace_ent.movetype = MOVETYPE_BOUNCE; 
				trace_ent.velocity = v_forward *100 *(self.melee_ammount / 10);
				trace_ent.velocity_z = 20 + (random() *30);
				}
			}
		}
		else
		{
			if ((trace_ent.flags &FL_MONSTER))
			trace_ent.solid = SOLID_TRIGGER;
			lunge_damage += trace_ent.health;
		}

		if((trace_ent.only_damage_monster != 1))
		T_Damage(trace_ent, self, self, lunge_damage);
		self.melee_ammount = 1;

		//if(self.melee_kill_uber == 1)
		{
			source = trace_endpos;
			tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *96, FALSE, self);
			if (trace_fraction == 1.0)
				return;
			if ((trace_ent.takedamage) && (trace_ent.only_damage_monster != 1) )
				T_Damage(trace_ent, self, self, lunge_damage);
		}
	}
};





void() w_melee_release = 
{
	if (!self.melee_kill_uber)
	{
		self.vweaponglowmod_x -= 0.05;
		self.vweaponglowmod_y -= 0.05;
		self.vweaponglowmod_z -= 0.05;
	}

	if (self.execution != 2)
		self.vweaponframe += 1;

	if (self.vweaponframe == 27)
	{
		self.melee_lunge = 0;
		w_melee_release_damage();
		playersound("weapons/melee/attack", 8);
	}

	if ((self.vweaponframe >= 28) && (self.vweaponframe <= 34))
		w_melee_release_damage();
	if (self.vweaponframe == 35)
	{
		self.melee_ammount = 0;
		self.maxspeed = 1;
		self.melee_ammount = 0;
	}

	if (self.vweaponframe >= 45)
	{
		if (!self.melee_kill_uber)
		{
			self.vweaponglowmod_x += 0.01;
			self.vweaponglowmod_y += 0.01;
			self.vweaponglowmod_z += 0.01;
		}

		self.noshake = 2;
		self.execution = 0;
		self.gravity = 1;
		self.maxspeed = 1;
		self.think = v_melee_idle;
	}
	else
		self.think = w_melee_release;

	self.nextthink = time + 0.05;

};
.vector prejumpvelocity;
void() w_melee_postprerelease =
{
	self.totallungetime = time;
	if(self.melee_released >= 1)
		self.melee_released = 2;
	else
		self.melee_released = 1;			
	local float secondary_jump;
	self.vweaponframe = 26;
	if((!(self.flags & FL_ONGROUND)) && (self.melee_released == 2))
		secondary_jump = 1;
	else
		secondary_jump = 0;
	
	if(self.lungefree > time)
		secondary_jump = 0;


	if((self.flags & FL_ONGROUND))
	{
		self.velocity_z += 160;
		self.flags -= FL_ONGROUND;
	}
	else
		self.velocity_z += 96;
	self.onground_time = 0;
	if((self.movetype != MOVETYPE_FLY)&& ( secondary_jump == 0) )
	{
		local float modifier_melee_amount;	
		modifier_melee_amount = 1;
		if (self.v_angle_x < 45)
		{
			makevectors (self.angles);
			local float vcfactor, hightfactor;
			if(self.v_angle_x >0)
			{
				vcfactor = (90 - self.v_angle_x) / 90;
				hightfactor = 0;
			}
			else
			{
				vcfactor = ( ((90 + self.v_angle_x) / 90) );
			}
			hightfactor =  (1 - ((90 + self.v_angle_x) / 90)) * 90;
			local vector wishspeed;
			wishspeed += v_forward * (1024 * vcfactor);
			local vector dir;
			dir = aim (self, 100);
			wishspeed = (dir * (1024 * vcfactor));
			self.gravity = 0;
			self.noshake = 1;
			stuffcmd(self, "v_kickroll 0\n");
			stuffcmd(self, "v_kickpitch 0\n");
			self.velocity_x = wishspeed_x;
			self.velocity_y = wishspeed_y;
			if(wishspeed_z < 0)	
				wishspeed_z = wishspeed_z *-1;
			self.velocity_z = wishspeed_z  + hightfactor; 
			if((self.flags & FL_ONGROUND))
			{
				self.velocity_z += 160;
				self.flags -= FL_ONGROUND;
			}
			else
				self.velocity_z += 96;
		}
		else
		{
			local float vrange;
			vrange = 90 / self.v_angle_x; 
			self.velocity = normalize(self.cursor_trace_endpos - self.origin);
			self.velocity = self.velocity * 500 * vrange;
		}
	}
	self.think = w_melee_release;
	self.nextthink = time + 0.05;
};

void() w_melee_prerelease =
{
	self.think = w_melee_postprerelease;
	self.nextthink = time + 0.05;
}
/*
void() w_melee_prerelease2 = 
{ 
	if (self.melee_released >= 1)
		self.melee_released = 2;
	else
		self.melee_released = 1;
	local float secondary_jump;
	self.melee_jump_time = time + 0.2;
	self.vweaponframe = 26;

	if ((!(self.flags &FL_ONGROUND)) && (self.melee_released == 2))
		secondary_jump = 1;
	else
		secondary_jump = 0;

	if (!(self.flags &FL_ONGROUND))
		self.velocity_z += lunge_velz;
	else
		self.velocity_z += lunge_velzog;
	if (self.flags &FL_ONGROUND)
			self.flags -= FL_ONGROUND;	
	if ((self.movetype != MOVETYPE_FLY) && (secondary_jump == 0))
	{
		local float modifier_melee_amount;
		modifier_melee_amount = 1;

		if (self.v_angle_x < 45)
		{
			makevectors(self.angles);

			local float vcfactor, hightfactor;
			local vector wishspeed;

			if (self.v_angle_x > 0)
			{
				vcfactor = (90 - self.v_angle_x) / 90;
				hightfactor = (1 - ((90 + self.v_angle_x) / 90)) *90;
			}
			else
			{
				vcfactor = (((90 + self.v_angle_x) / 90));
				hightfactor = (1 - ((90 + self.v_angle_x) / 90)) *90;
			}
	
			wishspeed += v_forward *(lunge_vel *vcfactor);
			local vector dir;
			dir = aim(self, 100);
			wishspeed = (dir *(lunge_vel *vcfactor));

			self.gravity = 0;
			self.noshake = 1;
			stuffcmd(self, "v_kickroll 0\n");
			stuffcmd(self, "v_kickpitch 0\n");
			self.velocity_x = wishspeed_x;
			self.velocity_y = wishspeed_y;
			
			self.velocity_z += hightfactor;
		}
		else
		{
			local float vrange;
			vrange = 90 / self.v_angle_x;
			self.velocity = normalize(self.cursor_trace_endpos - self.origin);
			self.velocity = self.velocity *500 * vrange;

		}
	}

	self.think = w_melee_release;
	self.nextthink = time + 0.05;
};
*/
void() w_melee_charge2 = 
{ 
	if (self.button3)
	{
		if (!self.melee_lunge)
			self.melee_lunge = 1;
		self.attack_finished = time + 0.05;
		if (self.vweaponframe < 24)
		{
			if (!self.melee_kill_uber)
			{
				self.vweaponglowmod_x += 0.05;
				self.vweaponglowmod_y += 0.05;
				self.vweaponglowmod_z += 0.05;
			}

			self.vweaponframe += 1;
		}
		else
		{
			self.vweaponglowmod_x = 1;
			self.vweaponglowmod_y = 1;
			self.vweaponglowmod_z = 1;
			self.vweaponframe = 25;
		}

		if (self.melee_ammount <= 20)
			self.melee_ammount += 1;
		self.nextthink = time + 0.05;
		self.think = w_melee_charge2;
		self.melee_charging = 1;

	}
};

void() w_melee_charge = 
{ 
	if (!self.melee_kill_uber)
	{
		self.vweaponglowmod_x = 0.01;
		self.vweaponglowmod_y = 0.01;
		self.vweaponglowmod_z = 0.01;
	}

	self.vweaponframe = 5;
	self.think = w_melee_charge2;
	self.nextthink = time + 0.05;
	self.melee_charging = 1;
	self.attack_finished = time + 0.05;
};

.float melee_dmg_ammount;
void(vector org, string locsound, float rnd, float vol) randompointsound;
void(float dmg, float dir, float dirv) w_slash = 
{
	local vector source, org, orn, ornv;

	if (dir == 1)
		orn = v_right *-48;
	if (dir == 2)
		orn = v_right * 0;
	if (dir == 3)
		orn = v_right * 48;

	if (dirv == 1)
		ornv = v_up * 24;
	if (dirv == 2)
		ornv = v_up * 0;
	if (dirv == 3)
		ornv = v_up *-24;

	makevectors(self.v_angle);
	source = self.origin + '0 0 16';
	tracebox(source, '-5 -5 -5', '5 5 5', source + v_forward *64 + orn + ornv, FALSE, self);

	if (trace_fraction == 1.0)
		return;
	org = trace_endpos - v_forward * 4;

	float dmg_m;
	if (!self.melee_kills)
		dmg_m = 1;
	if (self.melee_kills == 1)
		dmg_m = 1.2;
	if (self.melee_kills == 2)
		dmg_m = 1.4;
	if (self.melee_kills == 3)
		dmg_m = 1.6;
	if (self.melee_kills == 4)
		dmg_m = 1.8;
	if (self.melee_kills == 5)
		dmg_m = 3;

	dmg = dmg * dmg_m;

	if (trace_ent.takedamage)
	{
		if (trace_ent.bloody == 1)
			SpawnBlood(org, '0 0 0', 20, 3, 3);
		if (trace_ent.flags &FL_MONSTER)
		{
			playersound("impact/gibs/gib_hit", 5);
			trace_ent.death_time_sound = time + 1;
			if (!self.melee_skin)
				self.melee_skin = 1;
		}

		T_Damage(trace_ent, self, self, dmg);
		self.melee_dmg_ammount -= 10;
	}
	else
	{
		// hit wall

		if (!trace_inwater)
		{
			randompointsound(org, "weapons/melee/impact", 3, 1);
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord(MSG_BROADCAST, org_x);
			WriteCoord(MSG_BROADCAST, org_y);
			WriteCoord(MSG_BROADCAST, org_z);
		}
	}
};

.float fakeframe;
void() w_melee_slash2 = 
{
	self.fakeframe += 1;

	if (self.fakeframe == 4)
		playersound("weapons/melee/attack", 8);

	if (self.randomattack == 1)
	{
		if (self.fakeframe == 4)
			w_slash(self.melee_dmg_ammount, 1, 2);

		if (self.fakeframe == 5)
			w_slash(self.melee_dmg_ammount + 10, 2, 2);
		if (self.fakeframe == 6)
			w_slash(self.melee_dmg_ammount, 3, 2);

	}

	if (self.randomattack == 2)
	{
		if (self.fakeframe == 4)
			w_slash(self.melee_dmg_ammount, 1, 1);
		if (self.fakeframe == 5)
			w_slash(self.melee_dmg_ammount + 10, 2, 2);
		if (self.fakeframe == 6)
			w_slash(self.melee_dmg_ammount, 3, 3);
	}

	if (self.randomattack == 3)
	{
		if (self.fakeframe == 4)
			w_slash(self.melee_dmg_ammount, 3, 1);
		if (self.fakeframe == 5)
			w_slash(self.melee_dmg_ammount + 10, 2, 2);
		if (self.fakeframe == 6)
			w_slash(self.melee_dmg_ammount, 1, 3);
	}

	if (self.randomattack == 4)
	{
		if (self.fakeframe == 4)
			w_slash(self.melee_dmg_ammount, 1, 3);
		if (self.fakeframe == 5)
			w_slash(self.melee_dmg_ammount + 10, 2, 2);
		if (self.fakeframe == 6)
			w_slash(self.melee_dmg_ammount, 3, 1);
	}

	if (self.fakeframe >= 20)
		self.think = v_melee_idle;
	else
		self.think = w_melee_slash2;

	self.nextthink = time + 0.05;
};

void() w_melee_slash1 = 
{
	self.oldrandomattack = self.randomattack;

	if (self.randomattack == 1)
		self.vweaponframe = 1;
	if (self.randomattack == 2)
		self.vweaponframe = 2;
	if (self.randomattack == 3)
		self.vweaponframe = 3;
	if (self.randomattack == 4)
		self.vweaponframe = 4;

	self.melee_dmg_ammount = 25;

	self.fakeframe = 0;
	self.think = w_melee_slash2;
	self.nextthink = time;

};

void() w_melee_slash = 
{
	local float r;

	r = random();

	if (r > 0.75)
		self.randomattack = 1;
	else if (r > 0.5)
		self.randomattack = 2;
	else if (r > 0.25)
		self.randomattack = 3;
	else
		self.randomattack = 4;

	self.melee_charging = 0;

	if (self.oldrandomattack == self.randomattack)
		self.randomattack += 1;

	if (self.randomattack > 4)
		self.randomattack = 1;

	self.think = w_melee_slash1;
	self.nextthink = time;
};

.entity vmelee;
.entity vblood;
.entity vmelee1;
.entity vmelee2;
.entity vmelee3;

void() lower_melee2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 54)
	{
		remove(self.vmelee);
		remove(self.vblood);
	}

	if (self.vweaponframe >= 55)
		self.think = raise_weapon;
	else
		self.think = lower_melee2;
	self.nextthink = time + 0.025;
};

void() lower_melee = 
{
	self.vweaponframe = 51;
	self.melee_ammount = 0;
	self.attack_finished = time + 0.25;
	self.think = lower_melee2;
	self.vweaponstate = 2;
	self.melee_skin_time = time + 30;
	self.nextthink = time + 0.025;
};
void() v_blood_think;
void() v_blood_think_fading = 
{
	self.glowmod = self.owner.vweaponglowmod;
	self.alpha -= 0.0125;
	self.owner.melee_skin = 0;
	if (self.alpha <= 0)
		self.effects = EF_NODRAW;
	else
		self.effects = 0;
	if (self.alpha > 0)
		self.think = v_blood_think_fading;
	else
	{
		self.effects = EF_NODRAW;
		self.alpha = -1;
		self.owner.melee_skin = 0;
		self.think = v_blood_think;
	}

	self.nextthink = time + 0.025;
}

void() v_blood_think = 
{
	if ((self.owner.melee_skin == 1) && (self.alpha == -1))
	{
		self.alpha = 1;
		self.effects = 0;
	}

	if ((self.owner.melee_skin != 1) || (self.alpha <= 0))
	{
		self.alpha = -1;
		self.effects = EF_NODRAW;
	}

	//	if(self.owner.weapon != IT_MELEE)
	//	self.think = SUB_Remove;

	if (self.owner.waterlevel >= 3)
		self.think = v_blood_think_fading;

	self.glowmod = self.owner.vweaponglowmod;

	self.nextthink = time + 0.025;

};

void() v_blade_think = 
{
	self.skin = self.owner.melee_skin;
	self.glowmod = self.owner.vweaponglowmod;
	self.alpha = 1;
	if(self.owner.weapon != IT_MELEE)
		self.think = SUB_Remove;
		else
	self.think = v_blade_think;
	self.nextthink = time + 0.05;

};

void() v_blade_think2 = 
{
	self.cnt += 1;

	if (self.cnt < 60)
	{
		if (self.alpha < 1)
			self.alpha += 0.05;
		else
			self.alpha = 1;
	}
	else
	{
		self.alpha -= 0.05;
	}

	if (self.alpha <= 0)
		self.effects = EF_NODRAW;
	else
		self.effects = 0;

	if ((self.cnt > 81) && (self.alpha <= 0.05))	//|| (self.owner.weapon != IT_MELEE))
		self.think = SUB_Remove;
	else
		self.think = v_blade_think2;
	self.nextthink = time + 0.05;

};
void() v_blade_think3 = 
{
	self.skin = self.owner.melee_skin;
	self.glowmod = self.owner.vweaponglowmod;
	self.cnt += 1;
	if (self.cnt >= 60)
		self.alpha = 0;
	if (self.cnt > 81)
		self.think = v_blade_think;
	else
		self.think = v_blade_think3;
	self.nextthink = time + 0.05;

};

void(entity e, entity vweapn) spawn_v_blade2 = 
{
	e.vmelee = spawn();
	e.vmelee.wrathflags += FL_GARBAGE;
	e.vmelee.owner = e;
	setmodel(e.vmelee, "models/weapons/melee/v_blade.md3");
	setattachment(e.vmelee, vweapn, "tag_blade");
	e.vmelee.think = v_blade_think3;
	e.vmelee.nextthink = time;

	e.vmelee1 = spawn();
	e.vmelee1.wrathflags += FL_GARBAGE;
	e.vmelee1.owner = e;
	setmodel(e.vmelee1, "models/weapons/melee/v_blade_runes.md3");
	setattachment(e.vmelee1, vweapn, "tag_blade");
	e.vmelee1.think = v_blade_think2;
	e.vmelee1.nextthink = time;
	e.vmelee2 = spawn();
	e.vmelee2.wrathflags += FL_GARBAGE;
	e.vmelee2.owner = e;
	setmodel(e.vmelee2, "models/weapons/melee/v_blade_energy.md3");
	setattachment(e.vmelee2, vweapn, "tag_blade");
	e.vmelee2.think = v_blade_think2;
	e.vmelee2.nextthink = time;
	e.vmelee3 = spawn();
	e.vmelee3.wrathflags += FL_GARBAGE;
	e.vmelee3.owner = e;
	e.vmelee3.count = 1;
	setmodel(e.vmelee3, "models/weapons/melee/v_blade_hot.md3");
	setattachment(e.vmelee3, vweapn, "tag_blade");
	e.vmelee3.think = v_blade_think2;
	e.vmelee3.nextthink = time;
	e.vmelee.alpha = -2.5;
	e.vmelee1.alpha = -1;
	e.vmelee2.alpha = -1.5;
	e.vmelee3.alpha = -2;

};

void(entity e, entity vweapn) spawn_v_blade = 
{
	e.vmelee = spawn();
	e.vmelee.wrathflags += FL_GARBAGE;
	e.vmelee.owner = e;
	setmodel(e.vmelee, "models/weapons/melee/v_blade.md3");
	setattachment(e.vmelee, vweapn, "tag_blade");
	e.vmelee.think = v_blade_think;
	e.vmelee.nextthink = time;
};

void(entity e, entity vweapn) spawn_v_blood = 
{
	e.vblood = spawn();
	e.vblood.wrathflags += FL_GARBAGE;
	e.vblood.owner = e;
	setmodel(e.vblood, "models/weapons/melee/v_blade_blood.md3");
	setattachment(e.vblood, vweapn, "tag_blade");
	e.vblood.think = v_blood_think;
	e.vblood.nextthink = time;
};
void() raise_melee2 = 
{
	if (self.vweaponframe == 47)
		W_SetWeapon();
	self.vweaponframe += 1;
	if (self.vweaponframe >= 50)
	{
		self.vweapon.scale = self.dvweapon_scale;
		self.vweapon.origin_x = self.dvweapon_x;
		self.vweapon.origin_y = self.dvweapon_y;
		self.vweapon.origin_z = self.dvweapon_z;
		self.vweapon.angles = self.vweaponangles;
		self.think = v_melee_idle;
		self.execution = 1;
	}
	else
		self.think = raise_melee2;
	self.nextthink = time + 0.025;
};

void() raise_melee = 
{
	self.weapon = IT_MELEE;
	W_SetWeapon();
	self.hasmelee = 1;
	self.vweaponskin = 0;
	if (!self.bfg)
		self.vweaponglowmod = '0.01 0.01 0.01';
	else
		self.vweaponglowmod = '1 1 1';
	self.melee_charging = 0;
	self.melee_kill_uber = 0;
	self.melee_kill_time = 0;
	playersound("weapons/melee/select", 2);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponstate = 1;
	self.vweaponframe = 46;
	self.attack_finished = time + 0.25;
	spawn_v_blade(self, self.vweapon);
	spawn_v_blood(self, self.vweapon);
	self.think = raise_melee2;
	self.nextthink = time + 0.025;
};

void() pick_up_melee = 
{
	self.weapon = IT_MELEE;
	W_SetWeapon();
	self.hasmelee = 1;
	self.vweaponskin = 0;
	self.vweaponglowmod = '0.01 0.01 0.01';
	sound(self, CHAN_WEAPON, "weapons/melee/inspect.ogg", 1, ATTN_NORM);
	self.draw_w = 0;
	self.vweaponframe = 56;
	self.attack_finished = time + 4.05;
	if (self.noltime < time)
		self.lspeedtime = time + 4.05;
	spawn_v_blade2(self, self.vweapon);
	spawn_v_blood(self, self.vweapon);
	self.think = v_melee_idle;
	self.pick_melee = 1;
	self.nextthink = time + 4.05;
}

void() TMelee_touch = 
{
	if (other.classname != "player")
		return;
	if (other.items &IT_MELEE)
		return;
	other.time_pickupweapon = time + 0.75;

	stuffcmd(other, "impulse 101\n");
	remove(self);
};
void() trigger_melee = 
{
	self.solid = SOLID_TRIGGER;
	self.alpha = -1;
	setmodel(self, self.model);
	self.touch = TMelee_touch;

};

///////////////////////////////////end of qc file