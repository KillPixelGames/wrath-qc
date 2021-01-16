.float fvgeartime;
.float pickup_spitter;
.float multi_damage;
.float bomb_velocityfactor;
.float bombunreleased;
.float time_pickupweapon;
.float preloadcyst;
.float noammobutton;
.float noammobutton2;
.float nexteffects;
.float noltime;
void(string name, float random_number)weapon_sound;
void() wsfire_shotgun;
void() wfire_shotgun;
void() wfire_coachgun;
void() wsfire_coachgun;
void() wfire_cannon;
void() wsfire_cannon;
void() wfire_spitter;
void() wsfire_spitter;
void() wfire_retcher;
void() wsfire_retcher;
void() wfire_lance;
void() wsfire_lance;
void() wfire_boil;
void() wsfire_boil;
.float realoding;
void() pick_up_retcher;
void() pick_up_spitter;
void() pick_up_cannon;
void() pick_up_coachgun;
void() pick_up_shotgun;
void() pick_up_lance;
void() pick_up_boil;
void() raise_melee;
void() lower_melee;
void() raise_shotgun;
void() raise_coachgun;
void() raise_cannon;
void() raise_spitter;
void() raise_retcher;
void() raise_vmodel;
void() raise_lance;
void() raise_boil;
void() lower_coachgun;
void() lower_cannon;
void() lower_spitter;
void() lower_retcher;
void() lower_vmodel;
void() lower_shotgun;
void() lower_lance;
void() lower_boil;
void() reload_retcher;
//void()reloadcoachgun;
void() Use_Func;
.float gameplayfix_stepdown;

void()write_dummy_file =
{
};


void() check_custom_cvars =
{
	self.extraongroundtime= cvar("cl_extraongroundtime");
	self.alwaysrun = cvar("cl_alwaysrun");
	self.togglerun = cvar("cl_togglerun");
	self.gameplayfix_stepdown = 1;
};
void() refresh_custom_cvars =
{
	stuffcmd (self,strcat(("cl_alwaysrun "), ftos (self.alwaysrun), "\n"));
	stuffcmd (self,strcat(("cl_togglerun "), ftos (self.togglerun), "\n"));
};

void(vector org) SpawnGib = 
{
	local entity gib;
	gib = spawn();
	gib.movetype = MOVETYPE_NOCLIP;
	setmodel(gib, "models/fx/tether.spr");
	gib.alpha = -1;
	gib.traileffectnum = particleeffectnum("bloodtrail");
	gib.owner = self;
	makevectors(self.v_angle);
	gib.velocity = v_forward *10 + v_right *-200 + v_up * 50;
	gib.velocity = gib.velocity *2.5;
	setorigin(gib, org + (v_right *25));
	gib.nextthink = time + 0.125;
	gib.think = SUB_Remove;
};
void()oppressor_impact;
void(vector org, vector vel, float damage, float type, float pcount) SpawnBlood = 
{
	local float bparticle;
	//
	switch(type)
	{
		case 2:
			bparticle = particleeffectnum("GREEN_BLOOD");
		break;
		case 3:
			bparticle = particleeffectnum("NORMAL_BLOOD2");
		break;
		case 4:
			bparticle = particleeffectnum("BLUE_BLOOD");
		break;
		case 5:
			bparticle = particleeffectnum("oppressor_impact");
			local entity impact;
			impact = spawn();
			float r = random() * 5;
			if (r <= 5)
				setmodel(impact, "particles/impact/impact_oppressor1.md3");
			if (r <= 4)
				setmodel(impact, "particles/impact/impact_oppressor2.md3");
			if (r <= 3)
				setmodel(impact, "particles/impact/impact_oppressor3.md3");
			if (r <= 2)
				setmodel(impact, "particles/impact/impact_oppressor4.md3");
			if (r <= 1)
				setmodel(impact, "particles/impact/impact_oppressor5.md3");
			impact.origin = org;
			impact.alpha = 1;
			impact.think = oppressor_impact;
			impact.nextthink = time + 0.1;			
		break;	
		default:
			bparticle = particleeffectnum("NORMAL_BLOOD");
		break;	
	}
	while (pcount >= 0)
	{
		pointparticles(bparticle, org, vel *0.1, 1);
		pcount -= 1;
	}
};
float TE_LIGHTNING4NEH = 17;
void(string mdl, entity owner, vector start, vector end) te_custombeam  = {
  WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
  WriteByte(MSG_BROADCAST, TE_LIGHTNING4NEH);
  WriteString(MSG_BROADCAST, mdl);
  WriteEntity(MSG_BROADCAST, owner);
  WriteCoord(MSG_BROADCAST, start_x);
  WriteCoord(MSG_BROADCAST, start_y);
  WriteCoord(MSG_BROADCAST, start_z);
  WriteCoord(MSG_BROADCAST, end_x);
  WriteCoord(MSG_BROADCAST, end_y);
  WriteCoord(MSG_BROADCAST, end_z);
}


.float lance_secondary;
.float particle_time;
void  (entity e,vector org, vector dest) bloodparticles_beam2;
void()explogibs =
{
	entity head = findradius(self.origin, 120);
	while (head)
	{
		if (head.wrathflags & FL_GIB)
		{
		explo_physics_gibs (self,head,150,3); 	
		}
		head = head.chain;  // cycle to next head (entity)
	}
	remove(self);
};
.float explosion_gibs;
void(vector org)spawn_explosion_forgibs = 
{
entity explosion = spawn();
explosion.origin = org;
setmodel(explosion, "");
explosion.traileffectnum = particleeffectnum("boil_blood_trail");
explosion.movetype = MOVETYPE_FLY;
explosion.velocity = '0 0 300';
te_customflash(explosion.origin,256,2,'3 0 0');
decal_monster_gib (explosion.origin);
te_bloodshower (org - ('12 12 12'),org + ('12 12 12'), 512,256);
explosion.think = explogibs;
explosion.nextthink = time + 0.1;
}
void() ApplyMultiDamage = 
{
	local entity e;
	e = nextent(world);
	while (e)
	{
		if (e.multi_damage)
		{
			if(self.weapon == IT_BOIL) 
			{
			entity oself = self;
			self = e;
			self.sustained_damage = self.damagetopain + 10;
			self = oself;	

			if((e.health <= 10) && (e.health) && (e.explosion_gibs != 1))
			{	
				spawn_explosion_forgibs(e.origin);
				e.explosion_gibs = 1;	
				e.multi_damage = 10000;
			}
				{		
					entity head = findradius(e.origin, 250);
					while (head)
					{
						if ((head.takedamage) && (head.flags & FL_MONSTER))
						{
							if((head != self) && (head != e) && (visibleb(head.origin, e.origin, e) == TRUE))  // if the entity (head) is you (self), skip
							{
								bloodparticles_beam2 (e, e.origin, head.origin);
								if (e.multi_damage == 10000)
								{
									if(head.explosion_gibs != 1)
									{
									head.explosion_gibs = 1;			
									spawn_explosion_forgibs(head.origin);
									T_Damage(head, self, self, 10000);
									}
								}
								else
								T_Damage(head, self, self, 2.5);
							te_custombeam("models/projectiles/proj_boilb.md3",world, e.origin, head.origin);
								if(head.particle_time < time)
								{
								vector vel ='12 12 12';
								//te_customflash(head.origin,256,1,'0.1 0 0');
								//void(vector mincorner, vector maxcorner, float explosionspeed, float howmany) te_bloodshower = #406;

								head.particle_time = time + 0.1;
								}
							}
						}
						head = head.chain;  // cycle to next head (entity)
					}
				}
			}
			T_Damage(e, self, self, e.multi_damage);
			if(self.weapon != IT_BOIL)
			e.multi_damage = 0;
		}

		e = nextent(e);
	}
};

void(vector start, vector end) te_tei_g3 = 
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, 76);
	WriteCoord(MSG_BROADCAST, start_x);
	WriteCoord(MSG_BROADCAST, start_y);
	WriteCoord(MSG_BROADCAST, start_z);
	WriteCoord(MSG_BROADCAST, end_x);
	WriteCoord(MSG_BROADCAST, end_y);
	WriteCoord(MSG_BROADCAST, end_z);
	WriteCoord(MSG_BROADCAST, 0);
	WriteCoord(MSG_BROADCAST, 0);
	WriteCoord(MSG_BROADCAST, 0);
};

void(float damage, vector dir) TraceAttack = {

	

	if ((self.weapon == IT_BOIL) && (self.particle_time > time))
		return;
	local vector vel, org;
	vel = normalize(dir + v_up* crandom() + v_right* crandom());
	vel = vel + 2 * trace_plane_normal;
	vel = vel * 200;
	org = trace_endpos;	// - dir*4;
	local float rlooplimit, dam;
	local vector dorg, orgen;
	local entity tempen;
	rlooplimit = 3;	// only allow 3 hits
	if (self.weapon == IT_BOIL)
		rlooplimit = 1;	// only allow 1 hit



	if (self.weapon == IT_LANCE)
	{
		if(self.lance_secondary == 1)
			rlooplimit = 1;	// only allow 1 hit
		else
			rlooplimit = 21;	// only allow 21 hits
	}
	dorg = org - dir * 4;
	if (trace_ent.takedamage)
	{
		while (rlooplimit > 0)
		{
			if (trace_ent.takedamage && trace_ent != world)
			{
				orgen = org + dir * 4;
				dorg = org - dir * 4;
				dam = 1;
				local vector tracentorg;
				tracentorg = rorigin(trace_ent);
				if((trace_ent.classname == "player") && (self.classname == "player"))
				{	
					if (self.weapon == IT_SHOTGUN)
						damage = self.shotgun_damage1_mp;
					if (self.weapon == IT_COACHGUN)
						damage = self.coachgun_damage1_mp;
					if (self.weapon == IT_LANCE)
					{
						if(self.lance_secondary == 1)
							damage = self.lance_damage_mp;
						else
							damage = self.lance_damage2_mp;
					}
				}
				
				if (trace_ent.flags &FL_MONSTER)
				{
					//void(vector org, float radius, float lifetime, vector color) te_customflash = #417;
					//if (self.weapon == IT_BOIL)	
					//te_customflash(org, 256,1,'0.1 0 0');
					if (trace_endpos_z > (tracentorg_z + 24))
						trace_ent.dmg_h += 1;
					else
						trace_ent.dmg_t += 1;
					if (self.weapon == IT_BOIL)	
						te_bloodshower (trace_ent.absmin, trace_ent.absmax, 512,64);

					if (trace_ent.classname == "monster_afflicted")
						SpawnBlood(dorg, vel *0.2, damage, 2, 0);
					else if (trace_ent.classname == "monster_wraith")
						SpawnBlood(dorg, vel *0.2, damage, 4, 0);
					else if (trace_ent.classname == "monster_oppressor")
						SpawnBlood(dorg, vel *0.2, damage, 5, 0);
					else
						SpawnBlood(dorg, vel *0.2, damage, 1, 0);
					local float r;
					if (self.weapon == IT_SHOTGUN)
					{						
						r = random();
						if (r < 1)
						{
							if (trace_ent.classname == "monster_afflicted")
								explo_blood_sprite(3, org);
							else if (trace_ent.classname == "monster_wraith")
								explo_blood_sprite(4, org);
							else
							{
								if (trace_ent.bloody)
								{
									if (r < 0.5)
										explo_blood_sprite(1, org);
									else
										explo_blood_sprite(2, org);
								}
							}
						}
					}
					else
					{
						r = random();
						if (r < 1)
						{
							if (trace_ent.classname == "monster_afflicted")
								explo_blood_sprite(3, org);
							else if ((trace_ent.classname == "monster_wraith"))
							{
								if (trace_ent.health > 10)
									explo_blood_sprite(0, org);
							}
							else
							{
								if (trace_ent.bloody)
								{
									if (r < 0.5)
										explo_blood_sprite(1, org);
									else
										explo_blood_sprite(2, org);
								}	
							}
						}
					}
				}

				trace_ent.multi_damage = trace_ent.multi_damage + damage * dam;
				if (trace_ent.solid == SOLID_BSP)
					rlooplimit = 0;
			}
			else
			{
				dorg = org - dir * 4;
				rlooplimit = 0;
			}

			tempen = self;
			self = trace_ent;
			traceline(orgen, orgen + dir *1048, FALSE, self);
			self = tempen;
			rlooplimit = rlooplimit - 1;
		}
	}
	else
	{
		if ((self.weapon == IT_SHOTGUN) || (self.weapon == IT_COACHGUN))
		{
			pointparticles(particleeffectnum("TE_GUNSHOT"),org, '0 0 0', 1);
			pointparticles(particleeffectnum("TE_GUNSHOT2"),org, '0 0 0', 1);
		}
		if (self.weapon == IT_LANCE)
		{
			if(self.lance_secondary == 1)
				pointparticles(particleeffectnum("beam_impact"),org, '0 0 0', 1);
			else
				pointparticles(particleeffectnum("rail_impact"),org, '0 0 0', 1);
		}
		if (self.weapon == IT_BOIL)
		{
				pointparticles(particleeffectnum("NORMAL_BLOOD2"),org, '0 0 0', 1);
		}
	}
	if (self.weapon == IT_BOIL)
	self.particle_time = time + 0.1;
};

.float oldclipgroup;

void(float shotcount, vector dir, vector spread, float dmge, float spreadm) FireBullets = 
{
	local vector direction;
	local vector src;
	local float sv;
	
	if(self.clipgroup != 0)
	{
		self.oldclipgroup = self.clipgroup;
		self.clipgroup = 0;
	}
	makevectors(self.v_angle);
	spread_x = spread_x *self.charge_shotgun;
	spread_y = spread_y *self.charge_shotgun;
	spreadm = spreadm *self.charge_shotgun;

	src = self.origin + v_forward * 10;
	src_z = self.absmin_z + self.size_z *0.7 + 8;
	float s = self.solid;
	self.solid = SOLID_BBOX;
	while (shotcount > 0)
	{
		sv += 0.0075 * spreadm;
		if (self.weapon == IT_SHOTGUN)
		{
			sv += 0.0005 * spreadm;
			spread_x = spread_x *(spreadm);
			spread_y = spread_y *(spreadm);
		}

		direction = dir + crandom() *(spread_x + sv + sv) *v_right + crandom() *(spread_y + sv) *v_up;
		local vector maxbbox, minbbox;
		maxbbox = coachbbox;
		minbbox_x = maxbbox_x *-1;
		minbbox_y = maxbbox_y *-1;
		minbbox_z = maxbbox_z *-1;
		tracebox(src, minbbox, maxbbox, src + direction *4096, FALSE, self);
		if (trace_fraction != 1.0)
			TraceAttack(dmge, direction);
		//te_tei_g3 (self.origin, trace_endpos);	
		shotcount = shotcount - 1;
	}
	self.solid = s;

	ApplyMultiDamage();
	self.clipgroup = self.oldclipgroup;
};

void() s_explode1 =[0, s_explode2]
{
	self.effects = EF_ADDITIVE;
	self.nextthink = time + 0.05;
};
void() s_explode2 =[1, s_explode3]
{
	if (self.nexteffects)
		self.effects = self.nexteffects;
	self.nextthink = time + 0.05;
};
void() w_melee_slash;

void() s_explode3 =[2, s_explode4]
{
	self.nextthink = time + 0.05;
};
void() s_explode4 =[3, s_explode5]
{
	self.nextthink = time + 0.05;
};
void() s_explode5 =[4, s_explode6]
{
	self.nextthink = time + 0.05;
};
void() s_explode6 =[5, s_explode7]
{
	self.nextthink = time + 0.05;
};
void() s_explode7 =[6, s_explode8]
{
	self.nextthink = time + 0.05;
};
void() s_explode8 =[7, s_explode9]
{
	self.nextthink = time + 0.05;
};
void() s_explode9 =[8, s_explode10]
{
	self.nextthink = time + 0.05;
};
void() s_explode10 =[9, s_explode11]
{
	self.nextthink = time + 0.05;
};
void() s_explode11 =[10, SUB_Remove]
{
	self.nextthink = time + 0.05;
};
void() w_vmodel_slash;
.float lastweapontime;
void() nextweapon;
//.float semi;
//.float ssemi;
.entity torso_model;
.float torso_time;
void() Weapon_Fire = 
{
	
 	float checked7;
 	checked7 = cvar("saved4");

	switch (self.weapon)
	{
		case IT_MELEE:
			w_melee_slash();
			self.attack_finished = time + 0.5;
			self.torso_time = time + 0.5;
		break;

		case IT_VIEWMODEL:
			w_vmodel_slash();
			self.attack_finished = time + 0.5;
		break;

		case IT_COACHGUN:
			if (self.ammo_coachgun <= 0)
			{
				sound(self, CHAN_AUTO, "weapons/coachgun/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				//			self.attack_finished = time +  0.2;
				self.noammobutton = 1;
				return;
			}

			wfire_coachgun();
			//self.attack_finished = time +  0.25;
			self.attack_finished = time + 0.35;
			self.torso_time = time + 0.5;
		break;

		case IT_SHOTGUN:
			if (self.ammo_shotgun < 2)
			{
				sound(self, CHAN_AUTO, "weapons/coachgun/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			self.torso_time = time + 0.5;
			wfire_shotgun();
		break;
	
		case IT_CANNON:
			if (self.ammo_cannon <= 0)
			{
				//sound(self, CHAN_AUTO, "weapons/cannon/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}

			self.torso_time = time + 0.5;
			wfire_cannon();
		break;

		case IT_LANCE:
			if (self.ammo_lance <= 0)
			{
				//sound(self, CHAN_AUTO, "weapons/lance/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			self.torso_model.frame = 16;
			self.vweaponframe = 0;
			wfire_lance();
		break;

		case IT_BOIL:
			if (self.ammo_boil <= 0)
			{
				//sound(self, CHAN_AUTO, "weapons/boil/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			self.torso_model.frame = 16;
			self.vweaponframe = 0;
			wfire_boil();
			self.attack_finished = time + 0.1;
		break;

		case IT_RETCHER:
		
			if (self.ammo_retcher <= 0)
			{
				sound(self, CHAN_AUTO, "weapons/retcher/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}

			self.torso_time = time + 0.5;
			wfire_retcher();
		break;

		case IT_SPITTER:
			self.vgearrelease = 1;
			if (self.ammo_spitter <= 0)
			{
				sound(self, CHAN_AUTO, "weapons/spitter/dryfire.ogg", 1, ATTN_NORM);
				if(checked7)
				nextweapon();
				self.attack_finished = time + 0.25;
				self.noammobutton = 1;
				return;
			}
			self.fvgeartime = 0;
			self.torso_time = time + 0.5;
			wfire_spitter();
			self.attack_finished = time + self.flamethrower_time1;
		break;
	}
	if (time > 2)
		self.show_hostile = time + 1;

};
void() w_melee_charge;
.float shotgun_fire1;

void() Weapon_Sfire = 
{ 
	float checked7;
	checked7 = cvar("saved4");
	if (self.weapon == IT_MELEE)
	{
		w_melee_charge();
		self.torso_time = time + 0.5;
		self.attack_finished = time + 0.05;
	}
	else if (self.weapon == IT_COACHGUN)
	{
		//if(!self.ssemi)
		//{
		//self.ssemi = 1;		
		if (self.ammo_coachgun == 1)
		{
			wfire_coachgun();
		self.torso_time = time + 0.5;
			//self.attack_finished = time +  0.35;
			self.attack_finished = time + 0.1;	// 0.25
			return;
		}

		if (self.ammo_coachgun <= 0)
		{
			sound(self, CHAN_AUTO, "weapons/coachgun/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.1;	//0.25
			self.noammobutton2 = 1;
			return;
		}
		
		wsfire_coachgun();

		//}
	}
	else if (self.weapon == IT_RETCHER)
	{
		if (self.ammo_retcher <= 0)
		{
			sound(self, CHAN_AUTO, "weapons/retcher/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}

		self.torso_time = time + 0.5;
		wsfire_retcher();
	}
	else if (self.weapon == IT_SHOTGUN)
	{
		if (self.shotgun_fire1 == 1)
			return;

		if (self.ammo_shotgun < 2)
		{
			sound(self, CHAN_AUTO, "weapons/coachgun/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}
		self.torso_time = time + 0.5;
		wsfire_shotgun();
		self.attack_finished = time + self.shotgun_time1;
	}
	else if (self.weapon == IT_CANNON)
	{
		if (self.ammo_cannon <= 5)
		{
			//sound(self, CHAN_AUTO, "weapons/cannon/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}
		self.torso_time = time + 0.5;
		wsfire_cannon();
		self.attack_finished = time + self.slagcannon_time2;
	}
	else if (self.weapon == IT_LANCE)
	{
		if (self.ammo_lance <= 1)
		{
			//sound(self, CHAN_AUTO, "weapons/lance/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}

		self.torso_time = time + 0.5;
		wsfire_lance();		
			self.attack_finished = time + 0.5;
		
	}
	else if (self.weapon == IT_BOIL)
	{
		if (self.ammo_boil <= 1)
		{
			//sound(self, CHAN_AUTO, "weapons/lance/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}

		self.torso_time = time + 0.5;
		wsfire_boil();		
		//self.attack_finished = time + self.lance_time2;
		self.attack_finished = time + 0.5;
	}
	else if (self.weapon == IT_SPITTER)
	{
		self.vgearrelease = 1;
		if (self.ammo_spitter <= 0)
		{
			sound(self, CHAN_AUTO, "weapons/spitter/dryfire.ogg", 1, ATTN_NORM);
			if(checked7)
				nextweapon();
			self.attack_finished = time + 0.25;
			self.noammobutton2 = 1;
			return;
		}

		self.fvgeartime = 0;
		self.torso_time = time + 0.5;
		wsfire_spitter();
	}

	self.show_hostile = time + 1;
};
void()W_SetWeapon;
void() Think_Vweapon = 
{
	


	self.frame = self.owner.vweaponframe;
	self.skin = self.owner.vweaponskin;
	self.glowmod = self.owner.vweaponglowmod;
	if (self.owner.wlightning == 1)
		self.effects = EF_NOGUNBOB;
	else
		self.effects = 0;
	self.think = Think_Vweapon;
	self.nextthink = time;
};
.float rweapon;
.float centered;


void() W_SetWeapon = 
{
	local string fwmodel;

	if (self.weapon == IT_MELEE)
		fwmodel = "models/weapons/melee/v_gauntlet.md3";
	else if (self.weapon == IT_COACHGUN)
		fwmodel = "models/weapons/coachgun/v_coachgun.md3";
	else if (self.weapon == IT_SHOTGUN)
		fwmodel = "models/weapons/shotgun/v_shotgun.md3";
	else if (self.weapon == IT_RETCHER)
		fwmodel = "models/weapons/retcher/v_retcher.md3";
	else if (self.weapon == IT_SPITTER)
		fwmodel = "models/weapons/spitter/v_spitter.md3";
	else if (self.weapon == IT_CANNON)
		fwmodel = "models/weapons/cannon/v_cannon.md3";
	else if (self.weapon == IT_LANCE)
		fwmodel = "models/weapons/lance/v_lance.md3";
	else if (self.weapon == IT_BOIL)
		fwmodel = "models/weapons/lance/v_lance.md3";
	else if (self.weapon == IT_VIEWMODEL)
		fwmodel = self.vvweapon_model;
	self.weaponmodel = "models/weapons/coachgun/v_coachgun.md3";

	if (self.weapon == IT_VIEWMODEL)
	{
		self.vweapon.scale = self.vvweapon_scale;
		self.vweapon.origin_x = self.vvweapon_x;
		self.vweapon.origin_y = self.vvweapon_y;
		self.vweapon.origin_z = self.vvweapon_z;
		self.vweapon.angles = self.vvweaponangles;
	}

	if (self.weapon == IT_MELEE)
	{
		self.vweapon.scale = self.dvweapon_scale;
		self.vweapon.origin_x = self.dvweapon_x;
		self.vweapon.origin_y = self.dvweapon_y;
		self.vweapon.origin_z = self.dvweapon_z;
		self.vweapon.angles = self.vweaponangles;
	}

	if (self.weapon == IT_COACHGUN)
	{
		self.vweapon.scale = self.cgvweapon_scale;
		self.vweapon.origin_x = self.cgvweapon_x;
		self.vweapon.origin_y = self.cgvweapon_y;
		self.vweapon.origin_z = self.cgvweapon_z;
		self.vweapon.angles = self.cgweaponangles;
	}

	if (self.weapon == IT_SHOTGUN)
	{
		self.vweapon.scale = self.svweapon_scale;
		self.vweapon.origin_x = self.svweapon_x;
		self.vweapon.origin_y = self.svweapon_y;
		self.vweapon.origin_z = self.svweapon_z;
		self.vweapon.angles = self.sweaponangles;
		if(!(self.vweapon.effects & EF_DOUBLESIDED))
		self.vweapon.effects += EF_DOUBLESIDED;
	}

	if (self.weapon == IT_SPITTER)
	{
		self.vweapon.scale = self.pvweapon_scale;
		self.vweapon.origin_x = self.pvweapon_x;
		self.vweapon.origin_y = self.pvweapon_y;
		self.vweapon.origin_z = self.pvweapon_z;
		self.vweapon.angles = self.pweaponangles;
	}

	if (self.weapon == IT_RETCHER)
	{
		self.vweapon.scale = self.rvweapon_scale;
		self.vweapon.origin_x = self.rvweapon_x;
		self.vweapon.origin_y = self.rvweapon_y;
		self.vweapon.origin_z = self.rvweapon_z;
		self.vweapon.angles = self.rweaponangles;
	}

	if (self.weapon == IT_CANNON)
	{
		self.vweapon.scale = self.cvweapon_scale;
		self.vweapon.origin_x = self.cvweapon_x;
		self.vweapon.origin_y = self.cvweapon_y;
		self.vweapon.origin_z = self.cvweapon_z;
		self.vweapon.angles = self.cweaponangles;
	}
	if (self.weapon == IT_LANCE)
	{
		self.vweapon.scale = self.lvweapon_scale;
		self.vweapon.origin_x = self.lvweapon_x;
		self.vweapon.origin_y = self.lvweapon_y;
		self.vweapon.origin_z = self.lvweapon_z;
		self.vweapon.angles = self.lweaponangles;
	}
	if (self.weapon == IT_BOIL)
	{
		self.vweapon.scale = self.lvweapon_scale;
		self.vweapon.origin_x = self.lvweapon_x;
		self.vweapon.origin_y = self.lvweapon_y;
		self.vweapon.origin_z = self.lvweapon_z;
		self.vweapon.angles = self.lweaponangles;
	}

	float checked6;
 	checked6 = cvar("saved3");
 	if ((checked6 == 1) && (self.weapon != IT_MELEE))
	{
		if (self.weapon == IT_VIEWMODEL)
		{
			self.vweapon.scale = self.vvweapon_scale;
			self.vweapon.origin_x = self.vvweapon_x;
			self.vweapon.origin_y = self.vvweapon_y;
			self.vweapon.origin_z = self.vvweapon_z;
			self.vweapon.angles = self.vvweaponangles;
		}

		if (self.weapon == IT_MELEE)
		{
			self.vweapon.scale = self.dvweapon_scale;
			self.vweapon.origin_x = self.dvweapon_x;
			self.vweapon.origin_y = self.dvweapon_y;
			self.vweapon.origin_z = self.dvweapon_z;
			self.vweapon.angles = self.vweaponangles;
		}

		if (self.weapon == IT_COACHGUN)
		{
			self.vweapon.scale = self.cgvweapon_scale;
			self.vweapon.origin_x = self.centered_cgvweapon_x;
			self.vweapon.origin_y = self.centered_cgvweapon_y;
			self.vweapon.origin_z = self.centered_cgvweapon_z;
			self.vweapon.angles = self.centered_cgweaponangles;
		}

		if (self.weapon == IT_SHOTGUN)
		{
			self.vweapon.scale = self.svweapon_scale;
			self.vweapon.origin_x = self.centered_svweapon_x;
			self.vweapon.origin_y = self.centered_svweapon_y;
			self.vweapon.origin_z = self.centered_svweapon_z;
			self.vweapon.angles = self.centered_sweaponangles;
		}

		if (self.weapon == IT_SPITTER)
		{
			self.vweapon.scale = self.pvweapon_scale;
			self.vweapon.origin_x = self.centered_pvweapon_x;
			self.vweapon.origin_y = self.centered_pvweapon_y;
			self.vweapon.origin_z = self.centered_pvweapon_z;
			self.vweapon.angles = self.centered_pweaponangles;
		}

		if (self.weapon == IT_RETCHER)
		{
			self.vweapon.scale = self.rvweapon_scale;
			self.vweapon.origin_x = self.centered_rvweapon_x;
			self.vweapon.origin_y = self.centered_rvweapon_y;
			self.vweapon.origin_z = self.centered_rvweapon_z;
			self.vweapon.angles = self.centered_rweaponangles;
		}

		if (self.weapon == IT_CANNON)
		{
			self.vweapon.scale = self.cvweapon_scale;
			self.vweapon.origin_x = self.centered_cvweapon_x;
			self.vweapon.origin_y = self.centered_cvweapon_y;
			self.vweapon.origin_z = self.centered_cvweapon_z;
			self.vweapon.angles = self.centered_cweaponangles;
		}
		if (self.weapon == IT_LANCE)
		{
			self.vweapon.scale = self.lvweapon_scale;
			self.vweapon.origin_x = self.centered_lvweapon_x;
			self.vweapon.origin_y = self.centered_lvweapon_y;
			self.vweapon.origin_z = self.centered_lvweapon_z;
			self.vweapon.angles = self.centered_lweaponangles;
		}
		if (self.weapon == IT_BOIL)
		{
			self.vweapon.scale = self.lvweapon_scale;
			self.vweapon.origin_x = self.centered_lvweapon_x;
			self.vweapon.origin_y = self.centered_lvweapon_y;
			self.vweapon.origin_z = self.centered_lvweapon_z;
			self.vweapon.angles = self.centered_lweaponangles;
		}
		self.centered = 1;
	}
	else
	self.centered = 0;
	setmodel(self.vweapon, fwmodel);
};


.float rlastweapon;
void() raise_weapon = 
{
	W_SetWeapon();
	self.attack_finished = time + 0.5;

	self.lastweapon = self.weapon;
	if (self.weapon != IT_COACHGUN)
		self.vweaponglowmod = '0 0 0';
	if (self.weapon == IT_MELEE)
	{
		raise_melee();
	}

	if (self.weapon == IT_SHOTGUN)
	{
		//		self.vweaponskin = self.coachgunclip;
		//		self.vweaponglowmod = '-0.1 -0.1 -0.1';
		if (self.time_pickupweapon > time)
			pick_up_shotgun();
		else
			raise_shotgun();

	}

	if (self.weapon == IT_COACHGUN)
	{
		self.vweaponskin = self.coachgunclip;
		self.vweaponglowmod = '-0.1 -0.1 -0.1';
		if (self.time_pickupweapon > time)
			pick_up_coachgun();
		else
			raise_coachgun();

	}

	if (self.weapon == IT_CANNON)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_cannon();
		else
			raise_cannon();
	}

	if (self.weapon == IT_LANCE)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_lance();
		else
			raise_lance();
	}
	if (self.weapon == IT_BOIL)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_boil();
		else
			raise_boil();
	}
	if (self.weapon == IT_RETCHER)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_retcher();
		else
			raise_retcher();
	}

	if (self.weapon == IT_SPITTER)
	{
		self.vweaponskin = 0;
		if (self.time_pickupweapon > time)
			pick_up_spitter();
		else
			raise_spitter();
	}

	if (self.weapon == IT_VIEWMODEL)
	{
		self.vweaponskin = 0;
		raise_vmodel();
	}
};
void() pick_up_melee;
.float hasmelee;
void() W_ChangeWeapon = 
{
	Check_FrikFile();
	self.realoding = 0;
	self.randomattack = 0;
	if (self.draw_w != 0)
		return;
	self.hasmelee = 0;
	local float fl, oldweapon;
	if ((time < self.timesound))
	{
		sound(self, CHAN_WEAPON2, "weapons/spitter/fire1_release.wav", 1, ATTN_NORM);
		self.timesound = 0;
		return;
	}

	//if(time < (self.attack_finished + 0.05))
	//	return;

	//	self.lspeedtime = time + 0.05;
	if (self.impulse == 1)
	{
		fl = IT_MELEE;
	}
	else if (self.impulse == 2)
		fl = IT_COACHGUN;
	else if (self.impulse == 3)
		fl = IT_SHOTGUN;
	else if (self.impulse == 4)
		fl = IT_SPITTER;
	else if (self.impulse == 5)
		fl = IT_RETCHER;
	else if (self.impulse == 6)
		fl = IT_CANNON;
	else if (self.impulse == 7)
		fl = IT_LANCE;
	else if (self.impulse == 8)
		fl = IT_BOIL;
	else if (self.impulse == 9)
		fl = IT_VIEWMODEL;
	self.impulse = 0;
	self.noammobutton = 0;
	self.noammobutton2 = 0;
	if (!(self.items &fl))
	{
		// don't have the weapon or the ammo
		sprint(self, "no weapon.\n");
		return;
	}

	oldweapon = self.weapon;
	if (self.weapon == fl)
		return;
	//		if(self.lspeedtime > time)// nice option to speedruns
	//	self.lspeedtime = time + 0.05;

	self.weapon = fl;
	self.lastweapon = oldweapon;
	self.rlastweapon = oldweapon;

	if (oldweapon == IT_MELEE)
		lower_melee();
	if (oldweapon == IT_SHOTGUN)
		lower_shotgun();
	if (oldweapon == IT_COACHGUN)
		lower_coachgun();
	if (oldweapon == IT_RETCHER)
		lower_retcher();
	if (oldweapon == IT_CANNON)
		lower_cannon();
	if (oldweapon == IT_LANCE)
		lower_lance();
	if (oldweapon == IT_BOIL)
		lower_boil();
	if (oldweapon == IT_SPITTER)
		lower_spitter();
	if (oldweapon == IT_VIEWMODEL)
		lower_vmodel();
	self.lastweapontime = time + 0.05;
};

void() select_lastweapon =
{
	local float timpulse;
	if (self.rlastweapon == IT_MELEE)
		timpulse = 1;
	if (self.rlastweapon == IT_COACHGUN)
		timpulse = 2;
	if (self.rlastweapon == IT_SHOTGUN)
		timpulse = 3;
	if (self.rlastweapon == IT_SPITTER)
		timpulse = 4;
	if (self.rlastweapon == IT_RETCHER)
		timpulse = 5;
	if (self.rlastweapon == IT_CANNON)
		timpulse = 6;
	if (self.rlastweapon == IT_LANCE)
		timpulse = 7;
	if (self.rlastweapon == IT_BOIL)
		timpulse = 8;
	self.impulse = timpulse;
	W_ChangeWeapon();

}

void() prevweapon = 
{
	local float timpulse;
	if (self.weapon == IT_MELEE)
	{
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
	}

	if (self.weapon == IT_COACHGUN)
	{
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if (self.items &IT_MELEE)
			timpulse = 1;
	}

	if (self.weapon == IT_SHOTGUN)
	{
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
	}

	if (self.weapon == IT_SPITTER)
	{
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
	}

	if (self.weapon == IT_RETCHER)
	{
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
	}

	if (self.weapon == IT_CANNON)	//retcher
	{
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
	}
	if (self.weapon == IT_LANCE)	//lance
	{
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
	}
	if (self.weapon == IT_BOIL)	//lance
	{
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
	}

	self.impulse = timpulse;
	W_ChangeWeapon();
	self.attack_finished = time + 0.1;

};
void() nextweapon = 
{
	local float timpulse;
	if (self.weapon == IT_MELEE)
	{
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
	}

	if (self.weapon == IT_COACHGUN)
	{
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
	}

	if (self.weapon == IT_SHOTGUN)
	{
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
	}

	if (self.weapon == IT_SPITTER)
	{
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
	}

	if (self.weapon == IT_RETCHER)
	{
		if ((self.items &IT_SPITTER) && (self.ammo_spitter))
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
	}

	if (self.weapon == IT_CANNON)	//retcher
	{
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if (self.items &IT_SPITTER)
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
	}
	if (self.weapon == IT_LANCE)	//lance
	{
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if (self.items &IT_SPITTER)
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
		if ((self.items &IT_BOIL) && (self.ammo_boil))
			timpulse = 8;
	}
	if (self.weapon == IT_BOIL)	//lance
	{
		if ((self.items &IT_LANCE) && (self.ammo_lance))
			timpulse = 7;
		if ((self.items &IT_CANNON) && (self.ammo_cannon))
			timpulse = 6;
		if ((self.items &IT_RETCHER) && (self.ammo_retcher))
			timpulse = 5;
		if (self.items &IT_SPITTER)
			timpulse = 4;
		if ((self.items &IT_SHOTGUN) && (self.ammo_shotgun))
			timpulse = 3;
		if ((self.items &IT_COACHGUN) && (self.ammo_coachgun))
			timpulse = 2;
		if (self.items &IT_MELEE)
			timpulse = 1;
	}
	self.impulse = timpulse;
	W_ChangeWeapon();
	self.attack_finished = time + 0.127;

};

void() Rinventory = 
{
	if (self.radial_time > time)
	{
		sprint(self, "time to artifact\n");
		self.rmenu = 0;
		self.attack_finished = time + 0.11;
		return;
	}

	if (self.rmenu == 0)
		self.rmenu = 1;
	else
		self.rmenu = 0;
};

void() flash_update = 
{
	setorigin(self, self.owner.cursor_trace_endpos);
	self.nextthink = time + 0.001;
};

void() flash_on = 
{
	local entity myflash;

	myflash = spawn();
	myflash.movetype = MOVETYPE_NONE;
	myflash.solid = SOLID_NOT;
	setmodel(myflash, "models/dev/gizmo.md3");
	setsize(myflash, '0 0 0', '0 0 0');
	myflash.owner = self;
	myflash.alpha = 1;
	self.flash = myflash;
	myflash.classname = "flash";
	setorigin(myflash, self.cursor_trace_endpos);
	myflash.think = flash_update;
	myflash.nextthink = time + 0.01;
};

void() flash_toggle = 
{
	if (self.flash_flag == FALSE)
	{
		self.flash_flag = TRUE;
		devscreen = TRUE;
		flash_on();
	}
	else
	{
		self.flash_flag = FALSE;
		devscreen = FALSE;
		self.flash.think = SUB_Remove;
		self.flash.nextthink = time + 0.01;
	}
};


void() fmck_maker_touchs = 
{
	
		if(other.warped_time > time)
		return;
	if ((other.flags &FL_MONSTER) && (other.friendly_monster != 1))
	{
		other.friendly_monster = 1;
		
		
		
		if(other.enemy)
		other.exenemy = other.enemy; 
		other.enemy = world;
		
		if(other.classname == "monster_stricken")
		{
		other.turret = 1;
		other.th_run = stricken_preattack1;
		}
		if(other.health > 0)
		{
		if(other.classname == "monster_heretic")
		{
		if(other.movetype != MOVETYPE_STEP)
			other.movetype = MOVETYPE_STEP;
		}
		other.think = other.th_run;
		other.show_hostile = time + 1;
		other.nextthink = time + 0.1;
		}

		spawn_attar_enemy(other);
	}
	
	
		

//	remove(self);
};

void() fmck_maker_touch = 
{
	
if ((other.flags &FL_MONSTER) && (other.friendly_monster != 1))
	{
		other.friendly_monster = 1;
		if(other.enemy)
		other.exenemy = other.enemy; 

		other.enemy = 0;
		other.attar_timem = time  + 1;
		if(other.health > 0)
		{
		if(other.classname == "monster_heretic")
			{
			if(other.movetype != MOVETYPE_STEP)
				other.movetype = MOVETYPE_STEP;
			}
			if(other.classname == "monster_stricken")
			{
			other.turret = 1;
			other.th_run = stricken_preattack1;
			}
		}
		other.think = find_next_enemy;
		other.nextthink = time;
		spawn_attar_enemy(other);
		local entity oself;
		oself = self;
		self = other;
		if(self.classname != "monster_stricken")
		deactivate_turret();
		ai_face();
		self = oself;
	}		

//	remove(self);
};
float test_ia;
void() W_FireFmonster = 
{
	local vector dir, rorg;
	newmis = spawn();
	newmis.owner = self;
	newmis.movetype = MOVETYPE_FLY;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "friendlymaker";
	dir = aim(self, 1000);
	rorg = self.view_ofs - '0 0 19';
	setorigin(newmis, self.origin + '0 0 32');
	setmodel(newmis, "models/projectiles/proj_slag1.md3");
	setsizeitem(newmis, '0 0 0');
	newmis.velocity = normalize(self.cursor_trace_endpos - newmis.origin) *1024;
	newmis.angles = vectoangles(newmis.velocity);
	newmis.touch = fmck_maker_touch;
	newmis.effects = EF_NOSHADOW;
	
	float active_punchangle = cvar ("cl_punch");
	if(active_punchangle == 1)
	self.punchangle_x = -2;
	self.vweaponframe = 3;
};

void() Exit_Game = 
{
	localcmd("wmenu\n");
	localcmd("menu_cmd backtomainmenu\n");
};
void() Toggle_Journal = 
{
	if (self.journal == 1)
		self.journal = 0;
	else
		self.journal = 1;
	if (self.journal == 1)
	{
		centerprint(self, "");
		sound(self, CHAN_AUTO, "ui/journal/journal_open.ogg", 1, 0);
		stuffcmd(self, "scratch3 1\n");
	}

	if (self.journal == 0)
	{
		sound(self, CHAN_AUTO, "ui/journal/journal_close.ogg", 1, 0);
		stuffcmd(self, "scratch3 0\n");
	}
};
void() empty_reload_shotgun;
void() Toggle_HUD = 
{
	if (self.vhud == 1)
		self.vhud = 0;
	else
		self.vhud = 1;
};
//void()check_transformation;
.float spitterloop;
void() killemall = 
{
	local entity monster;

	monster = findradius(self.origin, 1000000);
	while (monster)
	{
		if (monster.flags &FL_MONSTER)
		{
				T_Damage(monster, self, self, 100000);
		}

		monster = monster.chain;
	}
};

void() nodegraph_debug_think;
void() node_debug_think = 
{
	local entity nodes;
	nodes = find(world,classname, "nodegraph_debug");
	while (nodes)	//Loops through everything put in the missile entity
	{
		{
			if(test_ia == 1)
			{	
				nodes.think = nodegraph_debug_think;
				nodes.nextthink = time + 0.1;
			}
			else
			{
				nodes.think= SUB_Null;
				nodes.nextthink = time + 1;
			}
		}
		nodes =  find(world,classname, "nodegraph_debug");
	}
};

void() node_debug = 
{
	local entity nodes;
	nodes = find(world,classname, "info_node");
	while (nodes)	//Loops through everything put in the missile entity
	{
		{
			if(test_ia == 1)
				nodes.effects = 0;
			else
				nodes.effects = EF_NODRAW;
		}
		nodes =  find(world,classname, "info_node");
	}
};
void(entity e)	spawn_bbox_collider;
void() delebboxesandrespawnthem =
{
	local entity garbage;
	garbage = findradius(self.origin, 1000000);
	while (garbage)	//Loops through everything put in the missile entit
	{
		if (garbage.classname == "bbox_touch")
		{
			remove(garbage);
		}

		garbage = garbage.chain;	//links every garbagegram found so they all go BOOM!
	}

/*
	local entity item_with_bbox;
	item_with_bbox = findradius(self.origin, 1000000);
	while (item_with_bbox)	//Loops through everything put in the missile entit
	{
		if ((item_with_bbox.classname =="health_life_vial" ))
		{
			spawn_bbox_collider(item_with_bbox);
		}

		item_with_bbox = item_with_bbox.chain;	//links every item_with_bboxgram found so they all go BOOM!
	}
*/
};




void() recount_spawner_monsters;
void() recount_spawner_items;
.float noattack;
void() trinket_spawn;	
void() giveme_relics = 
{
	self.slot_relics = 12345;
	self.relics = RL_E1M1 + RL_E1M2 + RL_E1M3 +RL_E1M4 + RL_E1M5;
};

void() ImpulseCommands = 
{ 
	if (self.lspeedtime > time)
		return;
	if (self.impulse == 155)
	{
		rmtree("profiles");
		//copy_save_maps (0);
	}
	if (self.impulse == 191)
	mark_revelation();
	if(self.impulse == 194)
	write_dummy_file();

	if(self.impulse == 195)
	{
		if (self.noattack == 1)
		{
			self.noattack = 0;
			bprint ("no attack OFF\n");
		}
		else
		{
			bprint ("no attack ON\n");
			self.noattack = 1;
		}
	}
	if(self.impulse == 196)
	{
	recount_spawner_monsters();
	recount_spawner_items();
	}
	if(self.impulse == 197)
	delebboxesandrespawnthem();
	if(self.impulse == 198)
	{
		float deletedqng = nodegraph_graphset_remove();
		if (deletedqng == 1)
		bprint ("deleted qng file\n");
		else
		bprint ("qng file not found\n");
	}
	if (self.impulse == 199)		
		killemall();
	if (self.impulse == 20)
		Toggle_Mode();
	if ((time < self.attack_finished) | (self.button3) | (self.button0))
	{
		if (self.modeeditor != 1)
		{
			self.impulse = 0;
			return;
		}
	}

	//	if (self.impulse >= 1 && self.impulse <= 9)
	//		W_ChangeWeapon (0);
	/*	if (self.impulse == 10)
		{
			if (globalfake_illumination == 1)
				{globalfake_illumination = 0; sprint (self, "fake illumination OFF.\n");}
			else
				{globalfake_illumination = 1; sprint (self, "fake illumination ON.\n");}

			self.impulse = 0;
		}*/
	if(self.impulse == 98)
		giveme_relics();
	if (self.impulse == 99)
	{
		self.rarmorvalue = 100;
		if (!(self.items &IT_COACHGUN))
			self.items += IT_COACHGUN;
		if (!(self.items &IT_SPITTER))
			self.items += IT_SPITTER;
		if (!(self.items &IT_RETCHER))
			self.items += IT_RETCHER;
		if (!(self.items &IT_SHOTGUN))
			self.items += IT_SHOTGUN;
		if (!(self.items &IT_MELEE))
			self.items += IT_MELEE;
		if (!(self.items &IT_CANNON))
			self.items += IT_CANNON;
		/*if (!(self.items &IT_LANCE))
			self.items += IT_LANCE;
		if (!(self.items &IT_BOIL))
			self.items += IT_BOIL;*/
		self.ammo_coachgun = max_ammo_coachgun;
		self.ammo_shotgun = max_ammo_shotgun;
		//self.ammo_bombs = 250;
		self.ammo_spitter = max_ammo_spitter;
		self.ammo_cannon = max_ammo_cannon;
		self.ammo_retcher = max_ammo_retcher;
		self.ammo_lance = max_ammo_lance;
		self.ammo_boil = 100;
		self.SoulTether += 1;
		self.LifeSiphon += 1;
		self.TrinketofRespite += 1;
		self.Attar += 1;
		self.Aegis += 1;
		self.DrownerApp += 1;
		self.coachgunclip = 3;
		//self.tdsouls = 7;
		//check_transformation();
		//self.bfg = 1;
	}

	if (self.impulse == 11)
	{
		flash_toggle();
			//node_debug();
			//node_debug_think();
		if (!self.wrath_debug_screen)
			{
			self.wrath_debug_screen = 1;
			test_ia = 1;
			}
		else
			{
			self.wrath_debug_screen = 0;
			test_ia = 0;
			}
	}
	if (self.wrath_debug_screen == 1)
	{
		if (self.impulse == 12)
			W_FireFmonster();
	}
	if (self.impulse == 52)
		Toggle_HUD();
	if (self.impulse == 34)
		reload_retcher();

	if (self.impulse == 80)
	{
		if (self.spitterloop == 1)
			self.spitterloop = 0;
		else
			self.spitterloop = 1;
	}
	//if(self.impulse == 83)
	//FireAttar();
	if (self.impulse == 89)
	{
	if(!self.deadmenuflag)
	self.deadmenuflag = 1;
	else
	self.deadmenuflag = 0;
	
	}
	if (self.impulse == 90)
	{
	if(self.deadmenuflag == 1)
	self.deadmenuflag = 0;	
	}


	if (self.impulse == 36)
		empty_reload_shotgun();
	if (self.modeeditor == 1)
	{
		if (self.impulse == 27)
			Check_Editor_Commands(1);
		if (self.impulse == 26)
			Check_Editor_Commands(-1);
		if (self.impulse == 208)
			Toggle_Mode();
		if (self.impulse == 209)
			Toggle_Angles();
		if (self.impulse == 210)
			Toggle_ShadowLights();
		if (self.impulse == 211)
			Toggle_NormalLights();
	}

	if ((self.rmenu != 1) && (!self.journal)  && (time > (self.attack_finished + 0.1))) 
	{
		if (self.impulse == 55)
			nextweapon();
		if (self.impulse == 56)
			prevweapon();
	}

	/*
		if(self.impulse == 60)
		{
		local string sorete;
		local float fsorete;
		fsorete = fcopy("data.sav","datacopy.sav");
		sorete = ftos (fsorete);
		sprint (self,sorete);
		bprint (sorete);
		}

		if(self.impulse == 58)
		frename("data.sav","datacopyname.sav");
		if(self.impulse == 59)
		fremove("data2.sav");
	*/
	self.impulse = 0;
};
.float itemtime;

void() WeaponSounds = 
{
	if (self.weapon == IT_SPITTER)
	{
		if (self.spitterloop == 1)
			return;
		if (self.pickup_spitter)
			return;

		if ((self.button0) && (self.ammo_spitter > 0))
		{
			if (self.timesound < time)
			{
				sound(self, CHAN_WEAPON2, "weapons/spitter/fire1_loop.wav", 1, ATTN_NORM);
				self.timesound = time + (soundlength("weapons/spitter/fire1_loop.wav"));

			}
		}
		else
		{
			if ((time < self.timesound))	//&& (self.attack_finished < time))
			{
				//sound (self, CHAN_WEAPON, "weapons/spitter/fire1_loop.wav", 0,ATTN_NORM);
				sound(self, CHAN_WEAPON2, "weapons/spitter/fire1_release.wav", 1, ATTN_NORM);
				self.timesound = 0;
				return;
			}
		}
	}

};
.float fieldcreated;
.float melee_ammount;
void() w_melee_prerelease;
void() vgearframes = 
{
	if (self.vgearframetime > time)
		return;

	if (self.vgearframe >= 15)
		self.vgearframe = 0;
	else
		self.vgearframe += 1;

	self.fvgeartime += 0.05;

	self.vgearframetime = time + self.fvgeartime;
};
void()ws_release_fire;
.float flightimesnd;
.float flightflag;
void() flight_sound = 
{ 
	if (self.timefly > time)
	{
		if (self.flightimesnd < time)
		{
			sound (self, CHAN_ITEM, "items/sigils/sigil_flight_active.ogg", 1, ATTN_NORM);
			self.flightimesnd = time + (soundlength ("items/sigils/sigil_flight_active.ogg"));
		}
	}
	else
	{
		sound (self, CHAN_ITEM, "items/sigils/sigil_flight_end.ogg", 1, ATTN_NORM);
		self.flightflag = 0;
		self.flightimesnd  = 0; 
	}
};
.float melee_lunge;

.float impulsetime;

//void() check_stunned_monsters;

void() glow_melee = 
{
	local float gd;
	if (!(self.melee_kills))
	{
		self.vweaponglowmod = '-1 -1 -1';
		return;
	}

	if (self.melee_kills == 1)
		gd = 0.002;
	if (self.melee_kills == 2)
		gd = 0.004;
	if (self.melee_kills == 3)
		gd = 0.008;
	if (self.melee_kills == 4)
		gd = 0.016;
	self.vweaponglowmod_x -= gd;
	self.vweaponglowmod_y -= gd;
	self.vweaponglowmod_z -= gd;
	self.tdsouls_time = time + 0.05;
};

void() glow_melee_uber = 
{
	local float gd;
	gd = 0.007142857;
	self.vweaponglowmod_x -= gd;
	self.vweaponglowmod_y -= gd;
	self.vweaponglowmod_z -= gd;
	self.tdsouls_time = time + 0.05;
};
.float timezoom;
.float melee_skin_time;
.float timezoomframe;
.float timezoomframesec;
.float reloadimpulse;
.float oldimpulse;
.float takenflytime;
void(float mtype, vector org, entity ownr) Hud_message_delay;
void() zoom_shotgun;

void() Fix_weapons =
{
	float hasbug; 
	self.lastweapon = self.weapon;
	if ((self.weapon == IT_MELEE)&& (self.vweapon.model != "models/weapons/melee/v_gauntlet.md3"))
	hasbug = 1;
	if ((self.weapon == IT_COACHGUN) && (self.vweapon.model != "models/weapons/coachgun/v_coachgun.md3"))
	hasbug = 1;
	if ((self.weapon == IT_SHOTGUN) && (self.vweapon.model != "models/weapons/shotgun/v_shotgun.md3"))
	hasbug = 1;
	if ((self.weapon == IT_RETCHER) && (self.vweapon.model != "models/weapons/retcher/v_retcher.md3"))
	hasbug = 1;
	if ((self.weapon == IT_SPITTER) && (self.vweapon.model != "models/weapons/spitter/v_spitter.md3"))
	hasbug = 1;
	if ((self.weapon == IT_CANNON) && (self.vweapon.model != "models/weapons/cannon/v_cannon.md3"))
	hasbug = 1;
	if ((self.weapon == IT_LANCE) && (self.vweapon.model != "models/weapons/lance/v_lance.md3"))
	hasbug = 1;
	if ((self.weapon == IT_BOIL) && (self.vweapon.model != "models/weapons/lance/v_lance.md3"))
	hasbug = 1;

	if(hasbug)
	{
		W_SetWeapon();
	}
};
void() WeaponFrames = 
{
	

	if(self.impulse == 101)
	{
		if(!(self.items &IT_MELEE))
		{
			self.items += IT_MELEE;
			self.weapon = IT_MELEE;
			W_SetWeapon();
			pick_up_melee();
			return;
		}
		self.impulse = 0;
	}
	local struct data;
	if(self.node_editor == 1)
	placing_nodes();

WeaponSounds();
	
	if(self.check_centered == 1)
	{
		Check_FrikFile();
		W_SetWeapon ();
		self.impulse = 0;
		self.check_centered = 0;
	}
	if(self.impulse == 83)
		check_custom_cvars();
	if(self.impulse == 82)
	{	
		Check_FrikFile();
		W_SetWeapon ();
		self.impulse = 0;
	}
	
	
	if (self.impulse == 190)
		Exit_Game();

	if((self.impulse == 81) && (time > self.totallungetime))
	{	
		if((self.SoulTether  >= 1) && (self.tether_global < time))
		{
			tether_org = self.origin;
			write_tether();
			message_garbage_collector ();

			if (!(self.centerprint_messages &8)) 
			{
				self.centerprint_messages += 8;
				Hud_message(261, self.origin, self);
			}
			//else
			Hud_message_delay(24, self.origin, self);

		}
		self.impulse = 0;
	}
		
	if ((!self.button6) && (self.rmenu == 1))
		self.rmenu = 0;

	if ((self.lspeedtime > time) && ((self.button0) || (self.button3)))
	{
		quickmovement();
		if (self.weapon == IT_SHOTGUN)
			sound(self, CHAN_WEAPON, "misc/null.wav", 0, ATTN_NORM);
		self.lspeedtime = 0;
	}

	if (self.impulse == 200)
	{
		if (self.pulseicons &1)
		{
			self.pulseicons -= 1;
			self.healthpulsetime = 0;
		}

		if (self.pulseicons &2)
			self.pulseicons -= 2;

		self.impulse = 0;
	}

	if (self.impulse == 201)
	{
		if (self.node_editor ==  1)
			self.node_editor = 0;
		else
			self.node_editor = 1;
		self.impulse = 0;
	}
	if (self.impulse == 202)
		place_node();
	if (self.impulse == 203)
		delete_nearest_node();
	if (self.impulse == 204)
	{	
		write_node_map();
		writed_map = 1;
	}
	if (self.impulse == 205)
	{	
		write_node_map();
		writed_map = 0;
	}

	if (self.lspeedtime > time)
		return;

	if (self.itemtime > time)
	{
		if (self.oldimpulse == 0)
			return;
		if (self.impulse)
			self.impulse = 0;
		self.maxspeed = 1;
		if (self.gravity < 0)
			self.gravity = 1;

		if (self.melee_ammount > 0)
			self.melee_ammount = 0;
		self.melee_lunge = 0;
		if (self.noshake == 1)
			self.noshake = 2;

		if (self.oldimpulse == 2)
			self.impulse = 2;
		if (self.oldimpulse == 3)
			self.impulse = 3;

		if (self.oldimpulse == 4)
			self.impulse = 4;

		if (self.oldimpulse == 5)
			self.impulse = 5;

		if (self.oldimpulse == 6)
			self.impulse = 6;
		if (self.oldimpulse == 7)
			self.impulse = 7;
		self.oldimpulse = 0;
		W_ChangeWeapon();
		return;
	}

	if (self.itemtime > time)
		return;
	if ((self.impulse == 57) && (self.lastweapontime < time))
	{
		self.melee_lunge = 0;
		if ((self.rmenu != 1) && (!self.journal))
			select_lastweapon();
	}

	//	if(self.radial_time <= 0.1)
	//	self.radialactive = 0;

	if (self.tether_global > time)
	{
			self.tethertime = 142 - (floor(((self.tether_global) - time) *6.8));
	}
	else
	{
		if (self.tethertime != 0)
		{
			//sound(self, CHAN_AUTO, "items/artifacts/artifactC_end.ogg", 1, 0.25);
			self.tethertime = 0;
		}
	}	
	
	if (self.timefly > time)
		self.artifacttime = 142 - (floor(((self.timefly) - time) * (142 / self.takenflytime)));
	else	
	{
		if (self.radial_time > time)
		{
			if (self.Aegis_time > time)
				self.artifacttime = 142 - (floor(((self.radial_time) - time) *9.466));
			else
				self.artifacttime = 142 - (floor(((self.radial_time) - time) *6.8));
		}
		else

		{
			if (self.artifacttime != 0)
			{
				if (self.radialactive == 1)
					{sound(self, CHAN_AUTO, "items/artifacts/artifactA_end.ogg", 1, 0.25);}
				if (self.radialactive == 2)
					{sound(self, CHAN_AUTO, "items/artifacts/artifactB_end.ogg", 1, 0.25); if(!self.DrownerApp)self.radialactive = 0;}
				if (self.radialactive == 3)
					{sound(self, CHAN_AUTO, "items/artifacts/artifactC_end.ogg", 1, 0.25);}
				if (self.radialactive == 4)
					{/*sound(self, CHAN_AUTO, "items/artifacts/artifactD_end.ogg", 1, 0.25);*/if(!self.Attar)self.radialactive = 0;}
				if (self.radialactive == 5)
					{sound(self, CHAN_AUTO, "items/artifacts/artifactE_end.ogg", 1, 0.25);}
				if (self.radialactive == 6)
					{sound(self, CHAN_AUTO, "items/artifacts/artifactF_end.ogg", 1, 0.25);if(!self.LifeSiphon)self.radialactive = 0;}
				if (self.radialactive == 7)
					{sound(self, CHAN_AUTO, "items/artifacts/artifactG_end.ogg", 1, 0.25);if(!self.TrinketofRespite)self.radialactive = 0;}
				if (self.radialactive == 8)
					{sound(self, CHAN_AUTO, "items/artifacts/artifactH_end.ogg", 1, 0.25);if(!self.Aegis)self.radialactive = 0;}			
				self.artifacttime = 0;
			}
		}
	}
	if (self.weapon == IT_SHOTGUN)
	{
		if ((time > self.timezoomframe) && (self.shotgun_fire1 != 1) && (self.ammo_shotgun >= 1))
		{
			if ((self.button3) && (time > self.timezoom))
			{
				if (self.charge_shotgun > self.charge_shotgun_count)
					self.charge_shotgun -= 0.004;
				if (self.charge_shotgun < self.charge_shotgun_count)
					self.charge_shotgun = self.charge_shotgun_count;
				if (self.vweaponglowmod_x <= 0)
				{
					self.vweaponglowmod_x = 0.02;
					self.vweaponglowmod_y = 0.02;
					self.vweaponglowmod_z = 0.02;
				}

				if ((self.vweaponglowmod_x <= 1) && (self.vweaponglowmod_x >= 0))
				{
					self.vweaponglowmod_x += 0.01;
					self.vweaponglowmod_y += 0.01;
					self.vweaponglowmod_z += 0.01;
				}
			}
			else
			{
				if (self.charge_shotgun < 1)
					self.charge_shotgun += 0.05;
				if (self.charge_shotgun > 1)
					self.charge_shotgun = 1;

				if (self.vweaponglowmod_x >= 0.01)
				{
					self.vweaponglowmod_x -= 0.025;
					self.vweaponglowmod_y -= 0.025;
					self.vweaponglowmod_z -= 0.025;
				}
				else
				{
					self.vweaponglowmod_x = -0.1;
					self.vweaponglowmod_y = -0.1;
					self.vweaponglowmod_z = -0.1;
				}
			}

			self.timezoomframe = time + 0.01;
		}
	}

	if ((self.weapon != IT_SHOTGUN) && (self.timezoom != 1))
		self.timezoom = 1;
	if (self.weapon != IT_MELEE)
	{
		if ((time > self.melee_skin_time) && (self.melee_skin))
			self.melee_skin = 0;

	}

	if(self.hasmelee == 1)
	{
		if ((time > self.tdsouls_time) && (self.weapon == IT_MELEE) && (!self.melee_charging) && (!self.melee_kill_uber))
			glow_melee();
		if ((self.melee_kill_uber) && (time > self.tdsouls_time) && (self.weapon == IT_MELEE))
			glow_melee_uber();
	}
	if (self.weapon == IT_MELEE)
	{
		if ((self.melee_kills) && (self.melee_kill_time < time))
		{
			self.melee_kills = 0;
			self.melee_kill_uber = 0;
			self.vweaponskin = 0;
		}
	}

	if (self.modeeditor == 1)
		ImpulseCommands();

	if (self.fall_state == TRUE)
		return;
	if((self.reloadimpulse) && (!self.realoding))
		{
			self.impulse = self.reloadimpulse;
			self.reloadimpulse = 0;
			W_ChangeWeapon();
		return;
		}

	if (self.impulse >= 1 && self.impulse <= 9)
	{
		self.maxspeed = 1;
		if (self.gravity < 0)
			self.gravity = 1;
		if((self.realoding))
		{	
			self.reloadimpulse = self.impulse;

			local string viewxanglesfactor;
			viewxanglesfactor = strcat ((ftos (self.reloadimpulse)), (" oldimpulse\n"));
			bprint (viewxanglesfactor);
		}	
		if (time < self.lastweapontime)
		{
			self.impulse = 0;
			return;
		}

		//(self.lastweapontime < time)

		if (time < self.impulsetime) 
		{
			self.impulse = 0;
			return;
		}


		if (self.melee_ammount > 0)
			self.melee_ammount = 0;
		self.melee_lunge = 0;
		
		W_ChangeWeapon();
		self.impulsetime = time + 0.25;
		if (self.noshake == 1)
			self.noshake = 2;
	}

	if (self.flightflag > 0)
		flight_sound();
	if (self.vgeartime > time)
		vgearframes();

	if ((self.bfg == 1) && (self.weapon == IT_MELEE) && (self.tdsouls <= 0))
	{
		//	check_transformation ();
		//return;	
	}

	if (time > self.use_finished)
	{
		if (self.button5)
		{
			if (self.luse)
				return;
			Use_Func();
			self.luse = 1;
		}
		else
		{
			if (self.luse)
				self.luse = 0;
		}
	}

	if (self.impulse == 35)
		Toggle_Journal();

	if ((self.realoding == 1) || (time > self.attack_finished)) 
	{

		if ((self.radial_time < time)&& (self.timefly < time))
		{
			if (self.modeeditor != 1)
			{
				if ((self.button6) && (self.rmenu != 1) && (self.journal == 0))
					Rinventory();
			}

			if (self.impulse == 15)
			{
				if (self.artifact_model_client <= 0)
				{
					if (self.radialactive == 2)
						Drowner_selected();
					if (self.radialactive == 4)
						Attar_selected();
					if (self.radialactive == 6)
						LifeSiphon_selected();
					if (self.radialactive == 7)
						TrinketofRespite_selected();
					if (self.radialactive == 8)
						Aegis_selected();
				}
			}

			if ((self.rmenu == 0) && (self.radial_time < time))
			{
				if (self.impulse == 21)
					self.radialactive = 1;
				if (self.impulse == 22)
					self.radialactive = 2;
				if (self.impulse == 23)
					self.radialactive = 3;
				if (self.impulse == 24)
					self.radialactive = 4;
				if (self.impulse == 25)
					self.radialactive = 5;
				if (self.impulse == 26)
					self.radialactive = 6;
				if (self.impulse == 27)
					self.radialactive = 7;
				if (self.impulse == 28)
					self.radialactive = 8;
				if (self.impulse == 29)
					self.radialactive = 9;
				if (self.impulse == 30)
					self.radialactive = 10;

				if ((!(self.centerprint_messages &2)) && (self.radialactive > 0))
				{
					Hud_message(257, self.origin, self);
					self.centerprint_messages += 2;
				}
			}
		}
	}
	if ((!self.button3) && (self.weapon == IT_LANCE) && (self.fieldcreated == 1))
	{
	self.fieldcreated = 0;
	ws_release_fire();
	}	

	if ((time < self.attack_finished) || (self.button6))
	{		
		if (self.impulse)
			self.impulse = 0;
		return;
	}

	if (self.deadflag)
		return;

	if (self.rmenu == 1)
		return;
	if (self.modeeditor == 1)
		return;

	if (self.button3)
	{
		//if ((self.button0)&& (self.weapon != IT_LANCE))
		//	return;

		if(self.journal == 1)
			return;
		if (self.noammobutton2 == 1)
			return;
		if(self.deadmenuflag == 1)
			return;
		Fix_weapons();
		Weapon_Sfire();
	}
	else
	{
		//if(self.lance_viewzoom_time > time)
		//self.lance_viewzoom_time = 0;
		if (self.noammobutton2 == 1)
			self.noammobutton2 = 0;
		self.wlightning = 0;
		if ((self.weapon == IT_MELEE) && (self.melee_lunge > 0))
		{
			self.melee_jump_time = time + 0.25;
			self.maxspeed = 1;
			self.attack_finished = time + 0.5;
			w_melee_prerelease();
			return;
		}

		//self.ssemi = 0;			
	}

	if (self.button0)
	{
		if (time < self.attack_finished)
			return;
		if ((self.button3) && (self.weapon != IT_LANCE))
			return;
		if (self.draw_w != 0)
			return;
		if (self.noammobutton == 1)
			return;
		if(self.deadmenuflag == 1)
			return;
		Fix_weapons();
		Weapon_Fire();
	}
	else
	{
		if (self.noammobutton == 1)
			self.noammobutton = 0;
		if ((self.vgearrelease == 1))
		{
			self.vgeartime = time + 0.35;
			self.vgearrelease = 0;
		}

		//if (time > self.attack_finished)
		//self.semi = 0;		
	}

	if ((self.impulse) && (!self.button3) && (!self.button0) && (!self.bomb_velocityfactor))
	{
		if (self.modeeditor != 1)
		{
			if (!self.button3)
				ImpulseCommands();
		}
		else
			ImpulseCommands();
	}
};

///////////////////////////////////end of qc file
