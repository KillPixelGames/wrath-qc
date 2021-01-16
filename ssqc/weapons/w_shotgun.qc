.float oldammo_shotgun;
.float noshells;
.float oldshotgunclip;
.float sfcg;
void() check_shotgun;
void() idle_shotgun;

.float empty_shells;

void() idle_shotgun = 
{
	if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time + 0.1;
	}

	if (self.realoding == 1)
		self.realoding = 0;
	if (self.sfcg)
		self.sfcg = 0;
	//if((self.vweaponglowmod_x != -0.1)&& (!self.button3))		
	//self.vweaponglowmod = '-0.1 -0.1 -0.1';
	if (self.timezoom > time)
		self.timezoom = 0;

	self.vweaponframe = 0;
	if (self.pick_up_time < time)
		self.vweaponstate = 0;

	if ((self.empty_shells == 1) && (self.ammo_shotgun > 0))
	{
		self.think = empty_reload_shotgun;
		self.nextthink = time + 0.1;
		return;
	}

	self.think = idle_shotgun;
	self.nextthink = time + 0.1;
};

vector() wall_velocity;
.float oldspeed;
.float nspeed;
.float checkspeedtime;
void() shot_projectile_think =
{
	if(self.solid != SOLID_BBOX)
		self.solid = SOLID_BBOX;
	if(self.cnt < 2)
	self.cnt +=1;
	if(self.cnt == 2)
	self.traileffectnum = particleeffectnum("shottrail");

	if(self.checkspeedtime < time)
	{
		float speed = vlen(self.velocity);
		if(speed <= self.nspeed)
		{
			vector dir = normalize (self.angles);
			self.velocity = dir * self.nspeed * 2;
		}
	self.checkspeedtime = time + 0.5;
	}
	if(self.velocity_z == 0)
	self.velocity_z = random(-500, 500);

	if((self.lifetime > time) && (self.count > 0))
		self.think = shot_projectile_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.05;
};
.float alreadytouched1;
.float alreadytouched2;
.float alreadytouched3;
.float alreadytouched4;
.float alreadytouched5;
.float alreadytouched6;
.float alreadytouched7;
.float alreadytouched8;
.float alreadytouched9;
.float alreadytouched10;
.float alreadytouched11;
.float alreadytouched12;
.float alreadytouched13;
.float alreadytouched14;
.float alreadytouched15;
.float alreadytouched16;
.float alreadytouched17;
.float alreadytouched18;
.float alreadytouched19;
.float alreadytouched20;
.float alreadytoucher;
.float waittime;
.float copied;
void(string locsound, float rnd, float vol, float nchannel, float iswav, float atten) randomsound2;
void() shotgun_proj_touch = 
{
	local vector org;
	//self.velocity =	self.oldvelocity;

	if (other == self.owner)
		return;
	if(self.count < 0)
		remove(self);

	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing

/*
	local float surfnum;
	local string s;
	surfnum = getsurfacenearpoint(other, self.origin);
	if (surfnum >= 0)
	{
		s = getsurfacetexture(other, surfnum);
		if((s == "textures/skies/hub1/hub1_sky_") || (s == "textures/skies/hub1/undercrofts_sky") || (s == "models/skies/hub1_cloud_ring1") || (s == "models/skies/hub1_cloud_ring2")) 
		{
			remove(self);
			return;
		}
	}
*/


	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}

	if ((other == world) || (other.solid == SOLID_BSP))
	{
		self.count -= 1;
		if(time > self.waittime)
			randomsound2  ("impact/projectiles/rico",15,0.5, CHAN_WEAPON, 0, 0.25);
		/*org = self.origin;
		pointparticles(particleeffectnum("TE_GUNSHOT"), org, '0 0 0', 1);
		local vector rvel;
		rvel_x = crandom() *50;
		rvel_y = crandom() *50;
		rvel_z = crandom() *50;
		self.angles = vectoangles(self.velocity);
		void(vector org, string locsound, float rnd, float vol)
		*/
	}
	float dm = 1;
	if((self.alreadytoucher == 1) && (other.alreadytouched1 > time))dm = 0;
	if((self.alreadytoucher == 2) && (other.alreadytouched2 > time))dm = 0;
	if((self.alreadytoucher == 3) && (other.alreadytouched3 > time))dm = 0;
	if((self.alreadytoucher == 4) && (other.alreadytouched4 > time))dm = 0;
	if((self.alreadytoucher == 5) && (other.alreadytouched5 > time))dm = 0;
	if((self.alreadytoucher == 6) && (other.alreadytouched6 > time))dm = 0;
	if((self.alreadytoucher == 7) && (other.alreadytouched7 > time))dm = 0;
	if((self.alreadytoucher == 8) && (other.alreadytouched8 > time))dm = 0;
	if((self.alreadytoucher == 9) && (other.alreadytouched9 > time))dm = 0;
	if((self.alreadytoucher == 10) && (other.alreadytouched10 > time))dm = 0;
	if((self.alreadytoucher == 11) && (other.alreadytouched11 > time))dm = 0;
	if((self.alreadytoucher == 12) && (other.alreadytouched12 > time))dm = 0;
	if((self.alreadytoucher == 13) && (other.alreadytouched13 > time))dm = 0;
	if((self.alreadytoucher == 14) && (other.alreadytouched14 > time))dm = 0;
	if((self.alreadytoucher == 15) && (other.alreadytouched15 > time))dm = 0;
	if((self.alreadytoucher == 16) && (other.alreadytouched16 > time))dm = 0;
	if((self.alreadytoucher == 17) && (other.alreadytouched17 > time))dm = 0;
	if((self.alreadytoucher == 18) && (other.alreadytouched18 > time))dm = 0;
	if((self.alreadytoucher == 19) && (other.alreadytouched19 > time))dm = 0;
	if((self.alreadytoucher == 20) && (other.alreadytouched20 > time))dm = 0;	
	if (other.takedamage) 
	{
		if(self.alreadytoucher == 1)
			other.alreadytouched1 = time + 0.1;
		if(self.alreadytoucher == 2)
			other.alreadytouched2 = time + 0.1;
		if(self.alreadytoucher == 3)
			other.alreadytouched3 = time + 0.1;
		if(self.alreadytoucher == 4)
			other.alreadytouched4 = time + 0.1;
		if(self.alreadytoucher == 5)
			other.alreadytouched5 = time + 0.1;
		if(self.alreadytoucher == 6)
			other.alreadytouched6 = time + 0.1;
		if(self.alreadytoucher == 7)
			other.alreadytouched7 = time + 0.1;
		if(self.alreadytoucher == 8)
			other.alreadytouched8 = time + 0.1;
		if(self.alreadytoucher == 9)
			other.alreadytouched9 = time + 0.1;
		if(self.alreadytoucher == 10)
			other.alreadytouched10 = time + 0.1;
		if(self.alreadytoucher == 11)
			other.alreadytouched11 = time + 0.1;
		if(self.alreadytoucher == 12)
			other.alreadytouched12 = time + 0.1;
		if(self.alreadytoucher == 13)
			other.alreadytouched13 = time + 0.1;
		if(self.alreadytoucher == 14)
			other.alreadytouched14 = time + 0.1;
		if(self.alreadytoucher == 15)
			other.alreadytouched15 = time + 0.1;
		if(self.alreadytoucher == 16)
			other.alreadytouched16 = time + 0.1;
		if(self.alreadytoucher == 17)
			other.alreadytouched17 = time + 0.1;
		if(self.alreadytoucher == 18)
			other.alreadytouched18 = time + 0.1;
		if(self.alreadytoucher == 19)
			other.alreadytouched19 = time + 0.1;
		if(self.alreadytoucher == 20)
			other.alreadytouched20 = time + 0.1;
		if (other.flags &FL_MONSTER)
		{
	
			if (other.classname == "monster_afflicted")
				spawn_touchblood2(9, 2);
			else if (other.classname == "monster_wraith")
				spawn_touchblood2(9, 4);
			else if (other.classname != "monster_oppressor")
				spawn_touchblood2(9, 1);

			local float r;
			r = random();
			if (r < 1)
			{
				if (other.classname == "monster_afflicted")
					explo_blood_sprite(3, org);
				else if (other.classname == "monster_oppressor")
					spawn_touchblood2(9, 5);
				else if (other.classname == "monster_wraith")
					explo_blood_sprite(4, org);
				else
				{
					if (r < 0.5)
						explo_blood_sprite(1, org);
					else
						explo_blood_sprite(2, org);
				}
			}
		}
		if (self.owner.weapon == IT_SHOTGUN)
			T_Damage(other, self, self.owner, 25 * dm);
		else
		{	
		if(other.classname == "player")
			T_Damage(other, self, self.owner,self.owner.coachgun_damage2_mp * dm);
		else
			T_Damage(other, self, self.owner,self.owner.coachgun_damage2 * dm);
		}
		entity bullet_clone = spawn();
		if(!self.copied)
		{
		copyentity(self,bullet_clone);
		self.copied = 1;
		}
		bullet_clone.solid = SOLID_TRIGGER;
		if (other.classname == "monster_lurker")
		{
			makevectors2(self.angles);
			vector neworg  = self.origin + v_forward * 5;
			setorigin (bullet_clone, neworg);
		}
		self.movetype = 0;
		setmodel (self,"");
		self.touch = SUB_Null;
		self.velocity = '0 0 0';
		self.solid = 0;
		self.traileffectnum = particleeffectnum("null");
		self.think = SUB_Remove;
		self.nextthink = time + 0.5;
	}			
};
void(vector org, vector dir, float order, entity ownerproj) launch_projectile_coachgun =
{
	local entity shotgun_proj;
	shotgun_proj = spawn ();
	shotgun_proj.owner = ownerproj;
	shotgun_proj.movetype = MOVETYPE_BOUNCEMISSILE;
	shotgun_proj.solid = SOLID_BBOX;
	shotgun_proj.count = 3;
	shotgun_proj.angles = vectoangles(dir);
	shotgun_proj.touch = shotgun_proj_touch;
	shotgun_proj.alreadytoucher = order;// counter of touchs
	shotgun_proj.classname = "projectile";
	shotgun_proj.lifetime = time + 5;
	shotgun_proj.think = shot_projectile_think;
	shotgun_proj.nextthink = time;
	shotgun_proj.clipgroup = 2;
	setmodel (shotgun_proj, "models/projectiles/proj_shrapnel.md3");
	setsize (shotgun_proj, '0 0 0', '0 0 0');
	if(ownerproj.classname == "player")
	makevectors(ownerproj.v_angle);
	else
	makevectors(ownerproj.angles);
	//org -=v_forward*order ;
	setorigin (shotgun_proj, org);
	local vector rvec;
	rvec_x += ownerproj.coachgun_spread2 * 0.25;
	rvec_y += ownerproj.coachgun_spread2 * 0.25;
	rvec = crandom()*(rvec_x )*v_right + crandom()*(rvec_y)*v_up;
	dir += rvec;
	shotgun_proj.velocity = dir * (coach_proj_vel +(25 * order));
	shotgun_proj.oldvelocity = shotgun_proj.velocity;
	shotgun_proj.nspeed = (coach_proj_vel +(25 * order));
};
void(vector org, vector dir, float order, entity ownerproj) launch_projectile = 
{
	local entity shotgun_proj;
	shotgun_proj = spawn();
	shotgun_proj.owner = ownerproj;
	shotgun_proj.movetype = MOVETYPE_BOUNCEMISSILE;
	shotgun_proj.solid = SOLID_BBOX;
	shotgun_proj.count = 3;
	shotgun_proj.alreadytoucher = order;// counter of touchs
	shotgun_proj.angles = vectoangles(dir);
	shotgun_proj.touch = shotgun_proj_touch;
	shotgun_proj.classname = "projectile";
	shotgun_proj.waittime =  time + 0.2;
	shotgun_proj.think = shot_projectile_think;
	shotgun_proj.lifetime = time + 5;
	shotgun_proj.nextthink = time;
	shotgun_proj.clipgroup = 2;
	setmodel(shotgun_proj, "models/projectiles/proj_shrapnel.md3");
	setsize(shotgun_proj, '0 0 0', '0 0 0');

	if (ownerproj.classname == "player")
		makevectors(ownerproj.v_angle);
	else
		makevectors(ownerproj.angles);
	//org -=v_forward*order ;
	setorigin(shotgun_proj, org);
	local vector rvec;
	rvec_x += ownerproj.shotgun_spread1;
	rvec_y += ownerproj.shotgun_spread1;
	rvec = crandom() *(rvec_x) *v_right + crandom() *(rvec_y) *v_up;
	dir += rvec;
	shotgun_proj.velocity = dir *(1000 + (2.5 *order));
	shotgun_proj.oldvelocity = shotgun_proj.velocity;
	shotgun_proj.nspeed = (1000 + (2.5 *order));
};
.float rsound_cntr;
void()launch_projectiles_explosion =
{
	local vector dir;
	local float pcount;
	pcount = 20;
	makevectors(self.angles);

	
	while(pcount > 0)
	{
		if(!self.count)
		{
			local float surfnum;
			local vector s;
			surfnum = getsurfacenearpoint(world, self.origin);
			if (surfnum >= 0)
			{
				s = getsurfacenormal(world, surfnum);
				dir = normalize (((dir + (v_up * 360 * crandom ())) + (v_right *360 * crandom ())));
				dir = (dir + (2 * s));
			}
		}
		else
		dir = normalize (((dir + (v_up * 360 *  crandom ())) + (v_right * 360* crandom ())));
		launch_projectile (self.origin, dir, pcount,self.owner);
		pcount -= 1;
	}
	remove(self);
}

void()proj_heretic_explo;
void(string locsound, float vol, float nchannel, float iswav, float atten) alreadyrandomsound2;
void()shotgun_projectile_touch = 
{
	local vector org;
	org = self.origin;
	if (other == self.owner)
		return;
	if (other.solid == SOLID_TRIGGER)
		return;	// trigger field, do nothing
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	/*local float surfnum;
	local string s;
	surfnum = getsurfacenearpoint(other, self.origin);
	if (surfnum >= 0)
	{
		s = getsurfacetexture(other, surfnum);
		if((s == "textures/skies/hub1/hub1_sky_") || (s == "textures/skies/hub1/undercrofts_sky") || (s == "models/skies/hub1_cloud_ring1") || (s == "models/skies/hub1_cloud_ring2")) 
		{
			remove(self);
			return;
		}
	}*/
	self.classname = "shotgun_projectile_explosion";
	if ((other.takedamage) && (other.solid != SOLID_BSP))
	{
			if (other.flags &FL_MONSTER)
		{
			if (other.classname == "monster_afflicted")
				spawn_touchblood2(9, 2);
			else if (other.classname == "monster_wraith")
				spawn_touchblood2(9, 4);
			else
				spawn_touchblood2(9, 1);

			local float r;
			r = random();
			if (r < 1)
			{
				if (other.classname == "monster_afflicted")
					explo_blood_sprite(3, org);
				else if (other.classname == "monster_wraith")
					explo_blood_sprite(4, org);
				else
				{
					if (r < 0.5)
						explo_blood_sprite(1, org);
					else
						explo_blood_sprite(2, org);
				}
			}
		}
		
	if(other.classname == "player")
		T_Damage(other, self, self.owner, self.owner.shotgun_proj_dmg_mp);
	else
		T_Damage(other, self, self.owner, self.owner.shotgun_proj_dmg);
	self.count = 1;
	}
	alreadyrandomsound2  ("impact/projectiles/shotgun_explo",1, CHAN_AUTO, 0, 0.25);

	self.movetype = 0;
	self.velocity = '0 0 0';	
	self.touch = SUB_Null;
	self.solid = 0;
	self.effects = EF_NODRAW;


	self.think = launch_projectiles_explosion;
	self.nextthink = time;
	
	
	local entity explosion_sprite;
	explosion_sprite = spawn();
	explosion_sprite.origin = self.origin;
	setmodel(explosion_sprite, "models/projectiles/proj_shotgun_explo.md3");
	pointparticles(particleeffectnum("shotgun_explo"), self.origin, '0 0 0', 1);
	explosion_sprite.alpha = 1;
	explosion_sprite.nextthink = time;
	explosion_sprite.think = proj_heretic_explo;
	
	
	//BecomeExplosion(1);
	//snd = strcat("impact/projectiles/slag1_explo", ftos(floor(random() *5) + 1), ".ogg");
	//pointparticles(particleeffectnum("slag"), org, v_forward *(-550), 1);
	//sound(self, CHAN_AUTO, snd, 1, 0.25);
};


void() shotgun_projectile_drunk = 
{
	self.explodcount += 1;
	self.velocity = ((self.velocity + ((v_right *proj_shotgun_drunkfactorh) *crandom())) + ((v_up *proj_shotgun_drunkfactorv) *crandom()));
	self.nextthink = time + proj_shotgun_timing;	// screw up fast
	if (self.explodcount < 50)
		self.think = shotgun_projectile_drunk;
	else
		self.think = SUB_Remove;
};


.float time_piston;

void() wfire_shotgunempty1 = 
{
	

	float centered_frames;
	if(self.centered == 1)	centered_frames = 100;	
	self.empty_shells = 1;
	self.vweaponframe += 1;
	self.shotgun_fire1 = 1;
	if (self.vweaponframe == 113 + centered_frames)
	{
		local vector dir;
		self.vweaponglowmod = '0.9 0.9 0.9';
		makevectors(self.v_angle);
		sound(self, CHAN_AUTO, "weapons/shotgun/firetoempty.ogg", 1, ATTN_NORM);
		dir = aim(self, 100000);
		FireBullets(self.buckshot_count, dir, '0.3 0.3 0', self.shotgun_damage1, self.shotgun_spread1);
		self.effects += EF_MUZZLEFLASH;
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
		self.punchangle_x = -5;
		self.ammo_shotgun -= 2;
		//muzzle_shotgun(self.vweapon, 1);
		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/shotgun/flash_small.md3";
		muzzle = spawn();
		muzzle.owner = self;
		muzzle.scale = 2;
		setmodel(muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle, self.vweapon, "tag_muzzle");
		muzzle.angles_z = random() *360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;
	}

	if ((self.vweaponframe > 114 + centered_frames) && (self.vweaponglowmod_x > 0))
	{
		self.realoding = 1;
		self.timezoomframe = time + 0.05;
		self.vweaponglowmod_x -= 0.1;
		self.vweaponglowmod_y -= 0.1;
		self.vweaponglowmod_z -= 0.1;
	}

	//		if(self.vweaponframe == 123)
	//		sound(self,CHAN_WEAPON,"misc/null.wav",1,1);

	if (self.vweaponframe >= 130 + centered_frames)
	{
		self.shotgun_fire1 = 0;
		self.think = idle_shotgun;
	}

	self.nextthink = time + 0.05;
};

void() wsfire_shotgunempty1 = 
{
	self.empty_shells = 1;

	self.vweaponframe += 1;
	float centered_frames;
	if(self.centered == 1)	centered_frames = 100;	
	
	
	if ((self.vweaponframe == 113) || ((self.centered == 1) && (self.vweaponframe == 213)))
	{
		local vector dir, tagorg;
		local float tagindex;
		sound(self, CHAN_AUTO, "weapons/shotgun/firetoempty.ogg", 1, ATTN_NORM);
		
		tagindex = gettagindex(self.vweapon, "tag_barrela");
		tagorg = gettaginfo(self.vweapon, tagindex);
		local entity sotgun_projectile;
		sotgun_projectile=  spawn();
		sotgun_projectile.movetype = MOVETYPE_FLYMISSILE;
		sotgun_projectile.solid = SOLID_TRIGGER;
		sotgun_projectile.owner =  self;
		
		dir = aim(self, 1000);
		setorigin(sotgun_projectile, tagorg);
		setmodel(sotgun_projectile, "models/projectiles/proj_shotgun1.md3");
		sotgun_projectile.cnt = 1;
		sotgun_projectile.traileffectnum = particleeffectnum("shotgun_trail");
		sotgun_projectile.velocity = normalize(self.cursor_trace_endpos - sotgun_projectile.origin) *self.shotgun_proj_speed ;
		//setsize(sotgun_projectile, '0 0 0', '0 0 0');
		setsizeitem(sotgun_projectile,  proj_shotgun_bbox);

		sotgun_projectile.angles = vectoangles(sotgun_projectile.velocity);
		sotgun_projectile.touch = shotgun_projectile_touch;
		sotgun_projectile.effects = EF_NOSHADOW;


	
	
		tagindex = gettagindex(self.vweapon, "tag_barrelb");
		tagorg = gettaginfo(self.vweapon, tagindex);
		dir = aim(self, 1000);
		local entity sotgun_projectileb;
		sotgun_projectileb=  spawn();
		sotgun_projectileb.movetype = MOVETYPE_FLYMISSILE;
		sotgun_projectileb.solid = SOLID_TRIGGER;
		sotgun_projectileb.owner =  self;
		setorigin(sotgun_projectileb, tagorg);
		setmodel(sotgun_projectileb, "models/projectiles/proj_shotgun2.md3");
		sotgun_projectileb.cnt = 1;
		sotgun_projectileb.traileffectnum = particleeffectnum("shotgun_trail");
		sotgun_projectileb.velocity = normalize(self.cursor_trace_endpos - sotgun_projectile.origin) *self.shotgun_proj_speed ;
		//setsize(sotgun_projectileb, '0 0 0', '0 0 0');
		setsizeitem(sotgun_projectileb,  proj_shotgun_bbox);
		sotgun_projectileb.angles = vectoangles(sotgun_projectileb.velocity);
		sotgun_projectileb.touch = shotgun_projectile_touch;
		sotgun_projectileb.effects = EF_NOSHADOW;

		sotgun_projectileb.think  = shotgun_projectile_drunk;
		sotgun_projectile.think  = shotgun_projectile_drunk;
		sotgun_projectileb.nextthink =  time + 0.05;
		sotgun_projectile.nextthink =  time + 0.05;
		
		local float r, r1;
		r = floor(random() *5) + 1;
		sotgun_projectile.rsound_cntr = r;
		r1 = floor(random() *5) + 1;
		if (r1 == sotgun_projectile.rsound_cntr)
			r1 += 1;
		sotgun_projectileb.rsound_cntr = r1;
		
		
		self.attack_finished = time + self.shotgun_time2;
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
		self.punchangle_x = -7;
		makevectors(self.angles);
		local float rf;
		if ((self.flags &FL_ONGROUND))
		{
			rf = 512;
			self.velocity_z += 24;
			self.flags -= FL_ONGROUND;
		}
		else
			rf = 192;
		self.velocity -= v_forward * rf;
		self.effects += EF_MUZZLEFLASH;
		self.ammo_shotgun -= 2;
		self.shotgun_clip = 0;
		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/shotgun/flash_small.md3";
		muzzle = spawn();
		muzzle.owner = self;
		muzzle.scale = 2;
		setmodel(muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle, self.vweapon, "tag_muzzle");
		muzzle.angles_z = random() *360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;

	}

	if ((self.vweaponframe > 113 + centered_frames) && (self.vweaponglowmod_x > 0))
	{
		self.realoding = 1;
		self.timezoomframe = time + 0.05;
		self.vweaponglowmod_x -= 0.1;
		self.vweaponglowmod_y -= 0.1;
		self.vweaponglowmod_z -= 0.1;
	}

	if (self.vweaponframe == 116 + centered_frames)
		self.timezoom = time + self.shotgun_time1 / 2;

	//	if(self.vweaponframe == 123)
	//		sound(self,CHAN_WEAPON,"misc/null.wav",1,1);

	if (self.vweaponframe == 130+ centered_frames)
	{
		self.time_piston = time + 0.15;
		self.shotgun_fire1 = 0;
		self.timezoomframe = time;
		self.think = idle_shotgun;
	}
	else
	self.think = wsfire_shotgunempty1;

	self.nextthink = time + 0.05;
};

void() wsfire_shotgun1 = 
{
	self.vweaponframe += 1;


	float centered_frames;


	if(self.centered == 1)	centered_frames = 131;	
	if (self.vweaponframe == 43 + centered_frames)
	{
		local vector dir, tagorg;
		local float tagindex;
		playersound2("weapons/shotgun/fire2_", 2, CHAN_WEAPON);


		tagindex = gettagindex(self.vweapon, "tag_barrela");
		tagorg = gettaginfo(self.vweapon, tagindex);
		local entity sotgun_projectile;
		sotgun_projectile=  spawn();
		sotgun_projectile.movetype = MOVETYPE_FLYMISSILE;
		sotgun_projectile.solid = SOLID_TRIGGER;
		sotgun_projectile.owner =  self;
		
		dir = aim(self, 1000);
		setorigin(sotgun_projectile, tagorg);
		setmodel(sotgun_projectile, "models/projectiles/proj_shotgun1.md3");
		sotgun_projectile.cnt = 1;
		sotgun_projectile.traileffectnum = particleeffectnum("shotgun_trail");
		sotgun_projectile.velocity = normalize(self.cursor_trace_endpos - sotgun_projectile.origin) *self.shotgun_proj_speed ;
		//setsize(sotgun_projectile, '0 0 0', '0 0 0');
		setsizeitem(sotgun_projectile,  proj_shotgun_bbox);
		sotgun_projectile.angles = vectoangles(sotgun_projectile.velocity);
		sotgun_projectile.touch = shotgun_projectile_touch;
		sotgun_projectile.effects = EF_NOSHADOW;


		tagindex = gettagindex(self.vweapon, "tag_barrelb");
		tagorg = gettaginfo(self.vweapon, tagindex);
		dir = aim(self, 1000);
		local entity sotgun_projectileb;
		sotgun_projectileb=  spawn();
		sotgun_projectileb.movetype = MOVETYPE_FLYMISSILE;
		sotgun_projectileb.solid = SOLID_TRIGGER;
		sotgun_projectileb.owner =  self;
		setorigin(sotgun_projectileb, tagorg);
		setmodel(sotgun_projectileb, "models/projectiles/proj_shotgun2.md3");
		sotgun_projectileb.cnt = 1;
		sotgun_projectileb.traileffectnum = particleeffectnum("shotgun_trail");
		sotgun_projectileb.velocity = normalize(self.cursor_trace_endpos - sotgun_projectile.origin) *self.shotgun_proj_speed ;
		setsizeitem(sotgun_projectileb,  proj_shotgun_bbox);
		//setsize(sotgun_projectileb, '0 0 0', '0 0 0');
		sotgun_projectileb.angles = vectoangles(sotgun_projectileb.velocity);
		sotgun_projectileb.touch = shotgun_projectile_touch;
		sotgun_projectileb.effects = EF_NOSHADOW;

		local float r, r1;
		r = floor(random() *5) + 1;
		sotgun_projectile.rsound_cntr = r;
		r1 = floor(random() *5) + 1;
		if (r1 == sotgun_projectile.rsound_cntr)
			r1 += 1;
		sotgun_projectileb.rsound_cntr = r1;
		
		
		sotgun_projectileb.think  = shotgun_projectile_drunk;
		sotgun_projectile.think  = shotgun_projectile_drunk;
		sotgun_projectileb.nextthink =  time + 0.05;
		sotgun_projectile.nextthink =  time + 0.05;
		
		self.attack_finished = time + self.shotgun_time2;
		self.lastweapontime = time + 1.25;
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
		self.punchangle_x = -5;
		makevectors(self.angles);
		local float rf;
		if ((self.flags &FL_ONGROUND))
		{
			rf = 512;
			self.velocity_z += 24;
			self.flags -= FL_ONGROUND;
		}
		else
			rf = 192;
		self.velocity -= v_forward * rf;
		self.effects += EF_MUZZLEFLASH;
		self.ammo_shotgun -= 2;
		self.shotgun_clip = 0;
		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/shotgun/flash_small.md3";
		muzzle = spawn();
		muzzle.owner = self;
		muzzle.scale = 2;
		setmodel(muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle, self.vweapon, "tag_muzzle");
		muzzle.angles_z = random() *360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;

	}

	if ((self.vweaponframe > 43 + centered_frames) && (self.vweaponglowmod_x > 0))
	{
		self.realoding = 1;
		self.timezoomframe = time + 0.05;
		self.vweaponglowmod_x -= 0.1;
		self.vweaponglowmod_y -= 0.1;
		self.vweaponglowmod_z -= 0.1;
	}

	if (self.vweaponframe == 56 + centered_frames)
		self.timezoom = time + self.shotgun_time1 / 2;
	if (self.vweaponframe >= 56 + centered_frames)
		self.shotgun_clip = 2;
	if (self.vweaponframe == 81 + centered_frames)
	{
		if (!self.button3)
			sound(self, CHAN_WEAPON, "weapons/shotgun/piston_out.ogg", 1, ATTN_NORM);
		else
			self.time_piston = time + 0.15;

	}

	if (self.vweaponframe >= 82 + centered_frames)
	{
		self.shotgun_fire1 = 0;
		self.timezoomframe = time;
		self.think = idle_shotgun;
		self.vweaponframe = 0;
	}
	else
		self.think = wsfire_shotgun1;
	self.nextthink = time + 0.05;

};

void() wfire_shotgun1 = 
{
	self.vweaponframe += 1;
	self.shotgun_fire1 = 1;
	
	float centered_frames;
	if(self.centered == 1)	centered_frames = 131;	
	if (self.vweaponframe == 3 + centered_frames)
	{
		local vector dir;
		self.vweaponglowmod = '0.9 0.9 0.9';
		makevectors(self.v_angle);
		playersound2("weapons/shotgun/fire1_", 2, CHAN_WEAPON);
		dir = aim(self, 100000);
		FireBullets(self.buckshot_count, dir, '0.3 0.3 0', self.shotgun_damage1, self.shotgun_spread1);
		self.effects += EF_MUZZLEFLASH;
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
		self.punchangle_x = -5;
		self.ammo_shotgun -= 2;
		//muzzle_shotgun(self.vweapon, 1);
		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/shotgun/flash_small.md3";
		muzzle = spawn();
		muzzle.owner = self;
		muzzle.scale = 2;
		setmodel(muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle, self.vweapon, "tag_muzzle");
		muzzle.angles_z = random() *360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;
	}

	if ((self.vweaponframe > 4 + centered_frames) && (self.vweaponglowmod_x > 0))
	{
		self.realoding = 1;
		self.timezoomframe = time + 0.05;
		self.vweaponglowmod_x -= 0.1;
		self.vweaponglowmod_y -= 0.1;
		self.vweaponglowmod_z -= 0.1;
	}

	///	if(self.charge_shotgun == self.charge_shotgun_count)
	//	{
	//		self.timezoom = time + self.shotgun_time1 /2;
	//	}

	if (self.vweaponframe >= 15 + centered_frames)
		self.shotgun_clip = 2;
	//	if(self.vweaponframe == 40)
	//	self.timezoomframe = time;
	if (self.vweaponframe >= 41 + centered_frames)
	{
		self.shotgun_fire1 = 0;
		self.think = idle_shotgun;
	}
	else
		self.think = wfire_shotgun1;
	self.nextthink = time + 0.05;
};

void() wsfire_shotgunwait = {
	float centered_frames,centered_framesb;
	if(self.centered == 1)	
	{
	centered_frames = 131; 
	centered_framesb = 100; 	}
	if (!self.button3)
	{
		self.think = idle_shotgun;
		sound(self, CHAN_WEAPON, "weapons/shotgun/piston_out.ogg", 1, ATTN_NORM);
		self.attack_finished = time + 0.25;
	}
	else
	{
		self.vweaponframe += 1;
		if (self.vweaponframe == 102 )
		{
			if (self.ammo_shotgun <= 2)
			{
				self.vweaponframe = 112 + centered_framesb;
				wsfire_shotgunempty1();
				return;
			}

			if (self.ammo_shotgun > 2)
			{
				self.vweaponframe = 42 + centered_frames;
				wsfire_shotgun1();
				return;
			}
		}
		else
			self.think = wsfire_shotgunwait;
	}

	self.nextthink = time + 0.05;
};
void() wsfire_shotgun = {

	float centered_frames;
	if(self.centered == 1)	centered_frames = 0;
 if (time > self.time_piston)
		sound(self, CHAN_AUTO, "weapons/shotgun/piston_in.ogg", 1, ATTN_NORM);
	sound(self, CHAN_WEAPON, "weapons/shotgun/charge.ogg", 1, ATTN_NORM);
	self.vweaponframe = 82 + centered_frames;
	self.think = wsfire_shotgunwait;
	self.nextthink = time + 0.05;
};

void() wfire_shotgun = 
{
	

	float centered_frames,centered_framesb;
	if(self.centered == 1)	
	{
	centered_frames = 131; 
	centered_framesb = 100; 	}
	if ((self.vweaponglowmod_x > 0) && (self.vweaponglowmod_x < 1))
	{
		self.attack_finished = time + 0.05;
		return;
	}

	if (self.vweaponglowmod_x < 1)
	{
		if (self.charge_shotgun != self.charge_shotgun_count)
			self.vweaponglowmod = '0.5 0.5 0.5';
		if (self.ammo_shotgun > 2)
		{
			self.vweaponframe = 2+ centered_frames ;
			self.think = wfire_shotgun1;
		}
		else
		{
			self.vweaponframe = 112+ centered_framesb;
			self.think = wfire_shotgunempty1;
		}
	}

	self.lastweapontime = time + self.shotgun_time1;
	self.attack_finished = time + self.shotgun_time1;
	self.nextthink = time + 0.05;
};

void() pick_up_shotgun2 = 
{
	self.think = idle_shotgun;
	self.pick_up_time = time + 0.5;
	self.vweaponstate = 1;
	self.nextthink = time + 0.05;
};

void() pick_up_shotgun = 
{
	self.lastweapon = IT_SHOTGUN;
	self.weapon = IT_SHOTGUN;
	self.shotgun_fire1 = 0;
	sound(self, CHAN_WEAPON, "weapons/shotgun/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponskin = self.shotgunclip;
	self.vweaponglowmod = '-0.1 -0.1 -0.1';
	self.vweaponstate = 2;

	if (self.noltime < time)
		self.lspeedtime = time + 4;
	self.vweaponframe = 1;
	self.attack_finished = time + 0.05;
	self.think = pick_up_shotgun2;
	self.nextthink = time + 4.95;
}

void() empty_reload_shotgun = 
{
	sound(self, CHAN_AUTO, "weapons/shotgun/emptytoreload.ogg", 1, ATTN_NORM);
	self.realoding = 1;
	self.empty_shells = 0;
	self.shotgun_clip = 2;
	self.vweaponframe = 132;
	self.attack_finished = time + 1.95;
	self.nextthink = time + 1.95;
	self.think = idle_shotgun;
}

void() raise_shotgun2 = 
{
	if (self.vweaponframe == 103)
		W_SetWeapon();
	self.vweaponframe += 1;
	if (self.vweaponframe >= 106)
	{
		if ((self.empty_shells == 1) && (self.ammo_shotgun > 0))
			self.think = empty_reload_shotgun;
		else
			self.think = idle_shotgun;
	}
	else
		self.think = raise_shotgun2;
	self.nextthink = time + 0.025;
};

void() raise_shotgun = 
{
	self.weapon = IT_SHOTGUN;
	self.shotgun_fire1 = 0;
	sound(self, CHAN_AUTO, "weapons/shotgun/raise.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.vweaponglowmod = '-0.1 -0.1 -0.1';
	self.vweapon.origin_z = self.dvweapon_z;
	self.draw_w = 0;
	self.vweaponskin = self.shotgunclip;
	self.vweaponframe = 102;
	self.vweaponstate = 1;
	self.attack_finished = time + 0.125;
	self.think = raise_shotgun2;
	self.nextthink = time;
};

void() lower_shotgun2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 111)
		self.think = raise_weapon;
	else
		self.think = lower_shotgun2;
	self.nextthink = time + 0.025;
};

void() zoom_shotgun = {};

void() lower_shotgun = 
{
	self.shotgun_fire1 = 0;
	sound(self, CHAN_AUTO, "weapons/shotgun/lower.ogg", 1, ATTN_NORM);
	self.vweaponframe = 107;
	self.attack_finished = time + 0.125;
	self.think = lower_shotgun2;
	self.vweaponstate = 2;
	self.nextthink = time + 0.025;
};

///////////////////////////////////end of qc file
