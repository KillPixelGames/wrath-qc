void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float(entity targ, entity inflictor) CanDamage;
void(entity targ, entity attacker) ClientObituary;
void() monster_death_use;
.float warped;
.float isexplosion;
.float gibbable;
.float tdsouls;
.float tdsouls_time;
.float turret;
.float oldturret;
.float warpedtime;
void() stricken_preattack1;
void()stricken_run1;
void() delete_shrine;
void() PlayerDeathThink;
.float playerdeadtime;
.float deadwaiting;
.float alreadykilled;
.entity attached_cloud;
void(string sound, float r) playersound;
void(float mtype, vector org, entity ownr) Hud_message;
void() next_enemy;


void() FoundTarget;
.float exec_push;
.float paintake;
.float randomattacked;
.float randomattack;
.float dmgscreenf;
.float dmgscreenb;
.float dmgscreenr;
.float dmgscreenl;
.float dmgbscreenf;
.float dmgbscreenb;
.float dmgbscreenr;
.float dmgbscreenl;
.float flyer;
void() mercenary_pain_think;
.float oldturret;
.float onlymelee;
.float  sustained_damage;

float(entity targ, entity inflictor) CanDamage = 
{	
	// bmodels need special checking because their origin is 0,0,0
	if (targ.movetype == MOVETYPE_PUSH)
	{
		traceline(inflictor.origin, 0.5 *(targ.absmin + targ.absmax), TRUE, self);
		if (trace_fraction == 1)
			return TRUE;
		if (trace_ent == targ)
			return TRUE;
		return FALSE;
	}

	traceline(inflictor.origin, targ.origin, TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '-15 15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	traceline(inflictor.origin, targ.origin + '15 -15 0', TRUE, self);
	if (trace_fraction == 1)
		return TRUE;
	return FALSE;
};

void() siphon_effect_think = 
{ 
	self.frame++;
	self.alpha -= 0.2;
	if (self.alpha == 0)
		self.alpha = -1;
	if (self.frame <= 9)
		self.think = siphon_effect_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.1;
};

void(vector org, entity e) life_siphon_effect = 
{ 
	float r = random();

	entity siphon_effect = spawn();
	siphon_effect.alpha = 2;
	siphon_effect.origin = org;
	setmodel(siphon_effect, "models/artifacts/effects/life_siphon_humanoid.md3");
	if (r > 0.5)
		siphon_effect.skin = 1;
	if (e.classname == "monster_lurker")
	{
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_lurker.md3");
		self.skin = 0;
	}
	if (e.classname == "monster_heretic")
	{
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_heretic.md3");
		self.skin = 0;
	}
	if (e.classname == "monster_wraith")
	{
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_wraith.md3");
		self.skin = 0;
	}
	if (e.classname == "monster_stricken")
	{
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_stricken.md3");
		self.skin = 0;
	}
	siphon_effect.think = siphon_effect_think;
	siphon_effect.nextthink = time;
};
void()null;
.entity buffer;
void(entity targ, entity attacker, float gibable) Killed = 
{ 


	
	float health_gain;
	
	if(self.buffer !=  world)
		self.buffer.goalentity = world;	

	if((attacker.flags &FL_MONSTER) && (attacker.enemy ==  targ))
	{
		attacker.enemy = world;
		entity oself = self;
		self = attacker;
		next_enemy();
		self = oself;	
	}	
	if (targ.classname == "monster_fallen")
		targ.journal_jmessagesm = JB_A;
	if (targ.classname == "monster_wraith")
		targ.journal_jmessagesm = JB_B;
	if (targ.classname == "monster_afflicted")
		targ.journal_jmessagesm = JB_C;
	if (targ.classname == "monster_widow")
		targ.journal_jmessagesm = JB_D;
	if (targ.classname == "monster_invader")
		targ.journal_jmessagesm = JB_E;
	if (targ.classname == "monster_heretic")
		targ.journal_jmessagesm = JB_F;
	if (targ.classname == "executioner")
		targ.journal_jmessagesm = JB_G;
	if (targ.classname == "monster_stricken")
		targ.journal_jmessagesm = JB_H;
	if (targ.classname == "monster_wretch")
		targ.journal_jmessagesm = JB_I;
	if (targ.classname == "monster_oppressor")
		targ.journal_jmessagesm = JB_J;
	if (targ.classname == "monster_lurker")
		targ.journal_jmessagesm = JB_K;
	entity pl = find(world, classname, "player");
	if (!(pl.journal_jmessagesm &targ.journal_jmessagesm) && (targ.flags &FL_MONSTER))
	{
		pl.journal_jmessagesm += targ.journal_jmessagesm;
		Hud_message(35, pl.origin, pl);
	}
		/*
	1 = fallen
	2 = wraith
	3 = afflicted
	4 = widow
	5 = invader
	6 = heretic
	7 = executioner
	8 = stricken
	9 = opressor
	10 = lurker

	float	JB_A					= 1;
	float	JB_B					= 2;
	float	JB_C					= 4;
	float	JB_D					= 8;
	float	JB_E					= 16;
	float	JB_F					= 32;
	float	JB_G					= 64;
	float	JB_H					= 128;
	float	JB_J					= 256;
	float	JB_k					= 512;
	*/
	oself = self;
	self = targ;
	self.classentity = "corpse";
	self.takedamage = DAMAGE_NO;
	//	if (self.health < -99)
	//		self.health = -99;		// don't let sbar look bad if a player
	self.attack_finished = time + 5;
	self.LifeSiphon_time = 0;
	self.solid = SOLID_CORPSE;
	if (self.health >= 0)
		self.health = -1;
	if (self.movetype == MOVETYPE_PUSH || self.movetype == MOVETYPE_NONE)
	{
		self.enemy = attacker;
		self.th_die();
		self = oself;
		return;
	}
	if (self.classname == "player")
	{
		self.playerdeadtime = time + 100000000;
		delete_shrine();
		if (self.health >= 0)
			self.health = -100;
		self.use = SUB_Null;
		self.solid = SOLID_CORPSE;
		self.takedamage = 0;
		self.think = PlayerDeathThink;
		self.nextthink = time;
		self.deadflag = DEAD_DEAD;
		self.deadwaiting = time + 0.1;
		remove(self.vweapon);
		if (self.waterlevel >= 3)
			playersound("player/die_underwater", 2);
		else
			playersound("player/die", 5);
		return;
	}

	if (self.flags &FL_MONSTER)
	{
		if (attacker.isexplosion)
			decal_monster_pain(rorigin(targ), attacker.angles);
		else
			decal_monster_pain(rorigin(targ), targ.enemy.angles);

		if (self.attached_cloud) 
			remove(self.attached_cloud); 
		if(!self.alreadykilled)
		{
			self.alreadykilled = 1; // prevent double kill counter
			killed_monsters = killed_monsters + 1;
			WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
		}
		if ((attacker.weapon == IT_MELEE) && (!attacker.melee_charging))
		{
			if (attacker.melee_kills < 5)
				attacker.melee_kills += 1;
			if (attacker.melee_kills == 1)
				attacker.vweaponglowmod = '0.2 0.2 0.2';
			if (attacker.melee_kills == 2)
				attacker.vweaponglowmod = '0.4 0.4 0.4';
			if (attacker.melee_kills == 3)
				attacker.vweaponglowmod = '0.6 0.6 0.6';
			if (attacker.melee_kills == 4)
				attacker.vweaponglowmod = '0.8 0.8 0.8';
			if (attacker.melee_kills == 5)
			{
				attacker.melee_kill_uber = 1;
				attacker.vweaponglowmod = '1 1 1';
				attacker.melee_kill_time = time + 7;
			}
			else
				attacker.melee_kill_time = time + 5;
		}

		self.solid = SOLID_NOT;
		if (gibable == 1)
			self.gibbable = 1;
		if (attacker.LifeSiphon_time > time)
		{
			if (floor(attacker.health) <= 99)
			{
				attacker.healthpulsetime = time + 0.5;
				if (attacker.healthpulsetime > time)
				{
					if (!(attacker.pulseicons &2))
						attacker.pulseicons += 2;
					attacker.rhealthpulsetime = time + 0.01;

				}
			}

			if (floor(attacker.health) <= 99)
				sound7(attacker, CHAN_AUTO, "player/gain_health.ogg", 1, ATTN_NORM, 100, 0);
				health_gain = 5;
			if (self.classname == "monster_fallen")
				health_gain = 5;
			if (self.classname == "monster_wraith")
				health_gain = 5;
			if (self.classname == "monster_afflicted")
				health_gain = 10;
			if (self.classname == "monster_widow")
				health_gain = 10;
			if (self.classname == "monster_invader")
				health_gain = 10;
			if (self.classname == "monster_heretic")
				health_gain = 20;
			if (self.classname == "executioner")
				health_gain = 30;
			if (self.classname == "monster_stricken")
				health_gain = 30;
			if (self.classname == "monster_wretch")
				health_gain = 15;
			if (self.classname == "monster_oppressor")
				health_gain = 20;
			if (self.classname == "monster_lurker")
				health_gain = 10;
			attacker.health += health_gain; 
			if(attacker.health > 100)
			attacker.health = 100;			
			life_siphon_effect(self.origin, self);
			self.th_stand = null;
			self.th_walk = null;
			self.th_run = null;
			self.th_missile = null;
			self.th_melee = null;
			self.th_pain = nullpain; // th_pain has two arguments 
			self.flags = 0;
		}
	}
	if (self.watertype == CONTENT_LAVA)	// do lava damage
	{
		self.effects = 0;
		self.health = -9999;
	}
	self.th_die();
	self.touch = SUB_Null;
	monster_death_use();
	self = oself;
};
.float forced_idle_time;
.float evading;
.entity temp_buffer;
.float shieldtime;
.float shieldspawned_time;
void()lance_muzzle_think;
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = 
{	 
	vector dir;
	entity oldself;
	float save;
	float take;
	float floatdmg;
	float waterdamagearmor;
	float rest_damage;
	float jdir;
	vector vec;
	float dot, dotb, doup, dmgup, dmgside;
	vector vec2, inflictorangles;

	if(attacker.forced_idle_time > time)
	{
	//attacker.enemy =  world;
	//	return;
	damage = damage * 0.25;
	}
	if (!targ.takedamage)
		return;
	if (!(targ.health))
		return;
	

	if (targ.classname == "player")
	{
		if (skill == 0)
			floatdmg = damage *0.25;
		if (skill == 1)
			floatdmg = damage *0.5;
		if (skill == 2)
			floatdmg = damage *0.75;
		if (skill == 3)
			floatdmg = damage *1;
	}

	if (damage <= 0)
		return;
	// used by buttons and triggers to set activator for target firing
	damage_attacker = attacker;
	// check for quad damage powerup on the attacker
	if ((targ.only_damage_monster == 1) && (attacker.classname == "player"))
		return;
	if (attacker.super_damage_finished > time)
		damage = damage * 4;
	// save damage based on the target's armor level
	if (attacker.classname == "badwater")
		waterdamagearmor = 1;
	else
		waterdamagearmor = 0;
	damage = floor(damage);
	if ((waterdamagearmor == 0) && (targ.Aegis_time < time))
	{
		if (targ.darmorvalue > 0)
		{
			if (targ.darmorvalue > damage)
			{
				targ.darmorvalue -= damage;
				damage = 0;
				save = 0;
			}
			else
			{
				rest_damage = (targ.darmorvalue - damage) *-1;
				targ.darmorvalue = 0;
				damage = rest_damage;
				save = rest_damage;
			}
		}
		else
			save = damage;

		if (targ.rarmorvalue > 0)
		{
			if (targ.rarmorvalue > damage)
			{
				targ.rarmorvalue -= damage *0.66;
				damage = damage *0.66;
				save = damage;
			}
			else
			{
				rest_damage = (targ.rarmorvalue - damage) *-1;
				targ.rarmorvalue = 0;
				damage = damage *0.66;
				save = rest_damage + damage;
			}
		}
		else
			save = damage;
	}
	else
		save = damage;

	take = save;
	if (targ.flags &FL_CLIENT)
	{
		targ.dmg_take = targ.dmg_take + take;
		targ.dmg_save = targ.dmg_save + save;
		targ.dmg_inflictor = inflictor;
	}

	if ((inflictor != world) && (targ.movetype == MOVETYPE_WALK) && (targ.gravity == 1))
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) *0.5;
		dir = normalize(dir);

		if (attacker.exec_push)
			jdir = attacker.exec_push;
		else
			jdir = 0;

		if (jdir > 0)
			targ.velocity = targ.velocity + dir *damage * jdir;
	}

	if ((targ.classname == "player") && ((attacker.flags &FL_MONSTER) || (attacker.classname == "aoe")))
	{
		makevectors2(targ.angles);
		vec = normalize(rorigin(attacker) - rorigin(targ));
		dot = vec * v_forward;
		dotb = vec * v_right;
		doup = vec * v_up;

		if (attacker.classname != "aoe")
		{
			if (doup >= 0.5)
			{
				targ.dmgscreenf = time + 2.5;
				if (targ.dmgscreenf > time)
				{
					targ.dmgbscreenf = time + 0.05;
					if (!(targ.damagescreen &2))
						targ.damagescreen += 2;
				}

				dmgup = 1;
			}

			if (dot < -0.5)
			{
				targ.dmgscreenb = time + 2.5;
				if (targ.dmgscreenb > time)
				{
					targ.dmgbscreenb = time + 0.05;
					if (!(targ.damagescreen &8))
						targ.damagescreen += 8;
				}
			}

			if (dmgup == 1)
			{
				if ((dot >= -0.4) && (dot < 0.6))
					dmgside = 1;
			}
			else
			{
				if ((dot >= -0.5) && (dot < 0.5))
					dmgside = 1;
			}

			if (dmgside == 1)
			{
				if (dotb < -0.5)
				{
					targ.dmgscreenl = time + 2.5;
					if (targ.dmgscreenl > time)
					{
						targ.dmgbscreenl = time + 0.05;
						if (!(targ.damagescreen &32))
							targ.damagescreen += 32;
					}
				}

				if (dotb > 0.5)
				{
					targ.dmgscreenr = time + 2.5;
					if (targ.dmgscreenr > time)
					{
						targ.dmgbscreenr = time + 0.05;
						if (!(targ.damagescreen &128))
							targ.damagescreen += 128;
					}
				}
			}
		}
		else
		{
			targ.dmgscreenb = time + 2.5;
			if (targ.dmgscreenb > time)
			{
				targ.dmgbscreenb = time + 0.05;
				if (!(targ.damagescreen &8))
					targ.damagescreen += 8;
			}
		}
	}

	vec2 = inflictor.origin - targ.origin;
	inflictorangles = vectoangles(vec);
	if((targ.shieldtime > time) )
	{

		take = take * 0.05;
		if ((targ.shieldspawned_time < time) && (attacker.classname =="player"))
		{
			string shieldmodel = "models/weapons/lance/v_flash.md3";
			entity shield = spawn();
			shield.owner = targ;
			setmodel(shield, shieldmodel);
			shield.scale = 1;
			if(targ.classname == "monster_stricken")
			shield.scale = 2.25;
			if(targ.classname == "monster_executioner")
			shield.scale = 2;
			if(targ.classname == "monster_heretic")
			shield.scale = 1.75;
			shield.origin = targ.origin;
			sound7(targ,CHAN_AUTO,"weapons/lance/fire1.ogg",1,0.25,50,0);
			targ.shieldspawned_time  = time + 0.2;
			shield.alpha = 2;
			shield.frame = 3;
			if(targ.temp_buffer.classname == "monster_buffer")
			te_lightning1(targ,targ.origin, targ.temp_buffer.origin);
			makevectors2(targ.angles);
			pointparticles(particleeffectnum("wraith_fire_impact"), targ.origin + v_forward * (10 * shield.scale), '0 0 0', 1);

			shield.think = lance_muzzle_think;
			shield.nextthink = time + 0.05;
			entity copyshield1 = spawn();
			copyentity (shield, copyshield1);
			entity copyshield2 = spawn();
			copyentity (shield, copyshield2);

			//void(vector org, float radius, float lifetime, vector color) te_customflash 
			te_customflash (targ.origin, 128,1,'0.5 0.85 1'); 
		}
	}
	if ((!(targ.flags &FL_GODMODE)) && ((targ.Aegis_time < time)))
	{
		if ((teamplay == 1) && (targ.team > 0) && (targ.team == attacker.team))
			return;
		targ.health = targ.health - take;
		if (targ.health <= 0)
		{
			targ.enemy = attacker;


			if ((attacker.weapon == IT_COACHGUN) | (attacker.weapon == IT_SPITTER))
				Killed(targ, attacker, 0);
			else
				Killed(targ, attacker, 1);
			return;
		}
	}

	//react to the damage
	oldself = self;
	self = targ;

	if((self.classname == "monster_stricken") && (attacker.flags & FL_MONSTER))
	{
		if(!self.turret)
		{
		self.turret = 1;
		self.th_run = stricken_preattack1;
		}	
	}
	
			if ((self.flags &FL_MONSTER) && (attacker != world) && (!self.warped)) 
			{
				//get mad unless of the same class (except for soldiers)
				if ((self != attacker) && (attacker != self.enemy) && (attacker.classname == "player"))
				{
				if ((self.onlymelee == 1) && (attacker.flyer == 1))	
					return;
					self.enemy = attacker;
					FoundTarget();
				}
			}


			if ((self.flags &FL_MONSTER) && (attacker.friendly_monster == 1)&&(attacker.flags &FL_MONSTER))
			{
				if ((self.onlymelee == 1) && (attacker.flyer == 1))	
				return;
				self.enemy = attacker;
				FoundTarget();
			}

		if(self.nextthink > time)
		self.nextthink = time;

		if ((self.th_pain) && (!self.warped))
		{
			self.paintake = take;
			self.randomattacked = attacker.randomattack;
			if(take > self.damagetopain)
			{
				self.th_pain(attacker, take);
				self.sustained_damage = 0;
			}
			else
				self.sustained_damage += take;

			if(self.sustained_damage > self.damagetopain)
				self.th_pain(attacker, take);		

			// nightmare mode monsters don't go into pain frames often
			if (attacker.classname == "player")
			{
				if ((self.flags &FL_MONSTER) && (self.bloody == TRUE))
				{
					if (attacker.isexplosion)
						decal_monster_pain(rorigin(self), inflictorangles);
					else
						decal_monster_pain(rorigin(self), self.enemy.angles);
				}
			}

			if (((skill == 3) || (attacker.flags & FL_MONSTER)) && (self.flags & FL_MONSTER))
				self.pain_finished = time + 5;

		}

		self = oldself;


};

void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage = 
{ 
	float points;
	entity head;
	vector org;
	inflictor.isexplosion = 1;
	head = findradius(inflictor.origin, damage + 40);
	while (head)
	{
		if (head != ignore)
		{
			if ((head.takedamage) && (head.health))
			{
				org = head.origin + (head.mins + head.maxs) *0.5;
				points = 0.5* vlen(inflictor.origin - org);

				if (points < 0)
					points = 0;

				points = damage - points;

				if (head == attacker)
					points = points *0.5;

				if (points > 0)
				{
					if (CanDamage(head, inflictor))
					{
						// shambler takes half damage from all explosions

						if ((head.classname == "player") && (inflictor.classname == "executioner"))
							points = 0;
						if ((head.classname == "executioner") && (inflictor.classname == "executioner"))
							points = 0;
						if ((head.solid != SOLID_BSP) && (inflictor.classname == "executioner"))
							points = 0;
						if ((head.classname != "monster_afflicted") && (attacker.classname != "monster_afflicted"))
							T_Damage(head, inflictor, attacker, points);
					}
				}
			}
		}

		head = head.chain;
	}
};
.vector fake_origin;
float(vector spot1, vector spot2, entity e) visibleb;

void(entity inflictor, entity attacker, float damage, entity ignore, float radius) T_SplashDamage = 
{ 	
	float points;
	entity head;
	vector org;
	inflictor.isexplosion = 1;
	
	
	head = findradius(inflictor.origin, radius);



	while (head)
	{
		if (head != ignore)
		{
			if ((head.takedamage) && (head.health))
			{
				
				org = head.origin + (head.mins + head.maxs) *0.5;
				if(head.solid == SOLID_BSP)
					radius += vlen (head.absmax - head.absmin) * 0.5;
				if((head == attacker) && (inflictor.classname == "explosion_ore"))
					damage = damage * 0.25;
				if((head == attacker) && (inflictor.classname == "explosion_oreb"))
					damage = damage * 0.25;
				if((head == attacker) && (inflictor.classname == "explosion_retcher"))
					damage = damage * 0.25;
				if((head == attacker) && (inflictor.classname == "aoe"))
					damage = damage * 0.1;


				points = damage / radius *(radius - (vlen(inflictor.origin - org)));
				if (head == attacker)
					points = points *0.5;
				if (points > 0)
				{
					if(head.solid == SOLID_BSP)
					{
						if (visibleb(head.absmin, inflictor.origin, attacker))
							T_Damage(head, inflictor, attacker, points);
						else if (visibleb(((head.absmin + head.absmax) *0.5), inflictor.origin, attacker))
							T_Damage(head, inflictor, attacker, points);
						else if (visibleb(head.absmax, inflictor.origin, attacker))
							T_Damage(head, inflictor, attacker, points);
					}
					else
					{
						if (visibleb(head.origin, inflictor.origin, attacker))
							T_Damage(head, inflictor, attacker, points);
					}
				}
			}
		}

		head = head.chain;
	}
};

.float backedtonormal;
.float oldmovetype;
.float timepushing;
.entity backtonormal_phys;
void() backtonormal = { self.movetype = self.oldmovetype;
	self.gravity = 1;
	self.backedtonormal = 1;
	self.think = self.oldthink;
	self.nextthink = time;
};
void()backtonormal_physics_think
{
	self.owner.gravity = 1;
	self.owner.movetype = self.oldmovetype;
	//self.backedtonormal = 1;
	self.think =SUB_Remove;
	self.nextthink = time;
};

void(entity inflictor, entity targ, float damage, float pushfactor) explo_physics = 
{ 
	vector dir, z_vel;
	if ((inflictor != world) && (targ.movetype == MOVETYPE_STEP) && (targ.timepushing < time)&& (targ.health > 0))
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) *0.5;
		dir = normalize(dir);
		if (!targ.oldmovetype)
			targ.oldmovetype = targ.movetype;
		targ.movetype = MOVETYPE_BOUNCE;
		targ.timepushing = time + 1;
		targ.gravity = 0.15;
		if (targ.flags &FL_ONGROUND)
			targ.flags -= FL_ONGROUND;
		targ.backedtonormal = 0;
		targ.oldthink = targ.think;
		targ.think = backtonormal;
		targ.nextthink = time + 0.1;
		z_vel_z =pushfactor * 12;
		targ.velocity = targ.velocity + dir *damage * pushfactor +z_vel;
		}
};
void(entity inflictor, entity targ, float damage, float pushfactor) explo_physics_gibs = 
{ 
	vector dir, z_vel;
	if ((inflictor != world) && (targ.timepushing < time))
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) *0.5;
		dir = normalize(dir);
		if (!targ.oldmovetype)
			targ.oldmovetype = targ.movetype;
		targ.movetype = MOVETYPE_BOUNCE;
		targ.timepushing = time + 1;
		targ.gravity = 0.15;
		if (targ.flags &FL_ONGROUND)
			targ.flags -= FL_ONGROUND;
		targ.backedtonormal = 0;
		targ.oldthink = targ.think;
		targ.think = backtonormal;
		targ.nextthink = time + 0.1;
		z_vel_z =pushfactor * 5;
		targ.velocity = targ.velocity + dir *damage * pushfactor +z_vel;
		}
};

void(entity inflictor, float damage, float damagetoplayer, entity ignore, float radius, float pushfactor) T_SplashDamageMonster = 
{ 
	float points;
	entity head;
	vector org;
	inflictor.isexplosion = 1;
	head = findradius(inflictor.origin, radius);

	while (head)
	{
		if (head != ignore)
		{
			if ((head.takedamage) && (head.health))
			{
				org = head.origin + (head.mins + head.maxs) *0.5;

				if (head.classname == "player")
					points = damagetoplayer / radius *(radius - (vlen(inflictor.origin - org)));
				else
					points = damage / radius *(radius - (vlen(inflictor.origin - org)));

				if (((!(head.flags &FL_MONSTER)) && (head.classname != "player")) && (self.classname != "spining_head_explosion"))
					points = 0;

				if ((head.classname == "monster_heretic") || (head.classname == "monster_wraith"))
					points = 0;
				if ((head.solid == SOLID_BSP) || (head.classname == "breakable_urn_large") || (head.classname == "breakable_urn_medium") || (head.classname == "breakable_urn_small"))
					points = 1000;
				
				
				if (head == inflictor)
					points = points *0.5;
				if ((points > 0) && (pushfactor >= 0))
				{
					entity oldself = self;
					self = inflictor;
					if (visibleb(head.origin, inflictor.origin, self))
					{
						T_Damage(head, inflictor, self, points);
						if ((head.classname != "player") && (!head.heavymonster))
							explo_physics(inflictor, head, points,pushfactor);
					}

					self = oldself;
				}
			}
		}

		head = head.chain;
	}
};

void(entity attacker, float damage) T_BeamDamage = 
{	
	float points;
	entity head;
	head = findradius(attacker.origin, damage + 40);
	while (head)
	{
		if ((head.takedamage) && (head.health))
		{
			points = 0.5* vlen(attacker.origin - head.origin);
			if (points < 0)
				points = 0;
			points = damage - points;
			if (head == attacker)
				points = points *0.5;
			if (points > 0)
			{
				if (CanDamage(head, attacker))
				{
					if (head.classname == "monster_shambler")
						T_Damage(head, attacker, attacker, points *0.5);

					else
						T_Damage(head, attacker, attacker, points);
				}
			}
		}

		head = head.chain;
	}
};

///////////////////////////////////end of qc file
