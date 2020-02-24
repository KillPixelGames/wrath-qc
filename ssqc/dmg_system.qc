void(entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float(entity targ, entity inflictor) CanDamage;
void(entity targ, entity attacker) ClientObituary;
void() monster_death_use;

float(entity targ, entity inflictor) CanDamage = {	// bmodels need special checking because their origin is 0,0,0
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
.float gibbable;
.float tdsouls;
.float tdsouls_time;

void() siphon_effect_think = { self.frame++;
	self.alpha -= 0.2;

	if (self.alpha == 0)
		self.alpha = -1;

	if (self.frame <= 9)
		self.think = siphon_effect_think;
	else
		self.think = SUB_Remove;

	self.nextthink = time + 0.1;
}

void(vector org, entity e) life_siphon_effect = { local entity siphon_effect;
	siphon_effect = spawn();
	siphon_effect.alpha = 2;
	siphon_effect.origin = org;
	setmodel(siphon_effect, "models/artifacts/effects/life_siphon_humanoid.md3");
	float r = random();
	if (r > 0.5)
		siphon_effect.skin = 1;
	if (e.classname == "monster_heretic")
	{
		setmodel(siphon_effect, "models/artifacts/effects/life_siphon_heretic.md3");
		self.skin = 0;
	}

	if (e.classname == "wraith")
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
void() delete_shrine;
void() PlayerDeathThink;
.float playerdeadtime;
.float deadwaiting;
void(string sound, float r) playersound;
void(float mtype, vector org, entity ownr) Hud_message;
void(entity targ, entity attacker, float gibable) Killed = { if (targ.classname == "fallen")
		targ.journal_jmessagesm = JB_A;
	if (targ.classname == "wraith")
		targ.journal_jmessagesm = JB_B;
	if (targ.classname == "afflicted")
		targ.journal_jmessagesm = JB_C;
	if (targ.classname == "widow")
		targ.journal_jmessagesm = JB_D;
	if (targ.classname == "monster_invader")
		targ.journal_jmessagesm = JB_E;
	if (targ.classname == "monster_heretic")
		targ.journal_jmessagesm = JB_F;
	if (targ.classname == "executioner")
		targ.journal_jmessagesm = JB_G;
	if (targ.classname == "monster_stricken")
		targ.journal_jmessagesm = JB_H;

	local entity oself;

	local entity pl;
	pl = find(world, classname, "player");

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

float	JB_A					= 1;
float	JB_B					= 2;
float	JB_C					= 4;
float	JB_D					= 8;
float	JB_E					= 16;
float	JB_F					= 32;
float	JB_G					= 64;
float	JB_H					= 128;
*/

	oself = self;
	self = targ;

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
		// doors, triggers, etc
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

	// bump the monster counter
	if (self.flags &FL_MONSTER)
	{
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
				//attacker.vweaponskin = 1;
				attacker.melee_kill_time = time + 7;
			}
			else
				attacker.melee_kill_time = time + 5;
		}

		self.solid = SOLID_NOT;
		if (gibable == 1)
			self.gibbable = 1;
		killed_monsters = killed_monsters + 1;
		WriteByte(MSG_ALL, SVC_KILLEDMONSTER);
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
				sound7(attacker, CHAN_AUTO, "player/gain_health.ogg", 1, ATTN_NORM, 100, 1);
			float health_gain;

			if (self.classname == "fallen")
				health_gain = attacker.health + 5;
			if (self.classname == "wraith")
				health_gain = attacker.health + 5;
			if (self.classname == "afflicted")
				health_gain = attacker.health + 10;
			if (self.classname == "widow")
				health_gain = attacker.health + 10;
			if (self.classname == "monster_invader")
				health_gain = attacker.health + 10;
			if (self.classname == "monster_heretic")
				health_gain = attacker.health + 20;
			if (self.classname == "executioner")
				health_gain = attacker.health + 30;
			if (self.classname == "monster_stricken")
				health_gain = attacker.health + 30;
			if(health_gain > 100)
			health_gain = 100;			
			
			attacker.health = health_gain; 
			life_siphon_effect(self.origin, self);

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
.float isexplosion;

void() mercenary_pain_think;
void(entity targ, entity inflictor, entity attacker, float damage) T_Damage = { local vector dir;
	local entity oldself;
	local float save;
	local float take;

	if (!targ.takedamage)
		return;

	if (!(targ.health))
		return;

	if (targ.classname == "player")
	{
		local float floatdmg;
		if (skill == 0)
			floatdmg = damage *0.25;
		if (skill == 1)
			floatdmg = damage *0.5;
		if (skill == 2)
			floatdmg = damage *0.75;
		if (skill == 3)
			floatdmg = damage *1;
	
		damage = floatdmg;
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

	local float waterdamagearmor;
	if (attacker.classname == "badwater")
		waterdamagearmor = 1;
	else
		waterdamagearmor = 0;
	local float rest_damage;
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
		local float jdir;

		if (attacker.exec_push)
			jdir = attacker.exec_push;
		else
			jdir = 0;

		if (jdir > 0)
			targ.velocity = targ.velocity + dir *damage * jdir;
	}

	if ((targ.classname == "player") && ((attacker.flags &FL_MONSTER) || (attacker.classname == "aoe")))
	{
		local vector vec;
		local float dot, dotb, doup, dmgup, dmgside;

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

	local vector vec2, inflictorangles;
	vec2 = inflictor.origin - targ.origin;
	inflictorangles = vectoangles(vec2);

	if ((!(targ.flags &FL_GODMODE)) && ((targ.Aegis_time < time)))
	{
		if ((teamplay == 1) && (targ.team > 0) && (targ.team == attacker.team))
			return;
		targ.health = targ.health - take;
		if (targ.health <= 0)
		{
			targ.enemy = attacker;
			if (self.flags &FL_MONSTER)
			{
				if (attacker.isexplosion)
					decal_monster_pain(rorigin(targ), inflictorangles);
				else
					decal_monster_pain(rorigin(targ), targ.enemy.angles);
			}

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
	if ((self.flags &FL_MONSTER) && attacker != world)
	{
		//get mad unless of the same class (except for soldiers)
		if (self != attacker && attacker != self.enemy && attacker.classname == "player")
		{
			self.enemy = attacker;
			FoundTarget();
		}
	}

	/*if ((self.flags &FL_MONSTER) && (attacker.flags &FL_CLIENT) && (!self.enemy))
	{
		self.enemy = attacker;
		FoundTarget ();
	}*/
	if ((self.flags &FL_MONSTER) && (attacker.friendly_monster == 1))
	{
		self.enemy = attacker;
		FoundTarget();
	}

	if (self.th_pain)
	{
		self.paintake = take;
		self.randomattacked = attacker.randomattack;
		self.th_pain(attacker, take);
		// nightmare mode monsters don't go into pain frames often
		if (attacker.classname == "player")
		{
			if (self.flags &FL_MONSTER)
			{
				if (attacker.isexplosion)
					decal_monster_pain(rorigin(self), inflictorangles);
				else
					decal_monster_pain(rorigin(self), self.enemy.angles);
			}
		}

		if (skill == 3)
			self.pain_finished = time + 5;

	}

	self = oldself;
};

void(entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage = { local float points;
	local entity head;
	local vector org;
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
						if ((head.classname != "afflicted") && (attacker.classname != "afflicted"))
							T_Damage(head, inflictor, attacker, points);
					}
				}
			}
		}

		head = head.chain;
	}
};

float(vector spot1, vector spot2, entity e) visibleb;

void(entity inflictor, entity attacker, float damage, entity ignore, float radius) T_SplashDamage = { local float points;
	local entity head;
	local vector org;
	inflictor.isexplosion = 1;
	head = findradius(inflictor.origin, radius);
	while (head)
	{
		if (head != ignore)
		{
			if ((head.takedamage) && (head.health))
			{
				org = head.origin + (head.mins + head.maxs) *0.5;
				points = damage / radius *(radius - (vlen(inflictor.origin - org)));
				if (head == attacker)
					points = points *0.5;
				if (points > 0)
				{
					if (visibleb(head.origin, inflictor.origin, attacker))
						T_Damage(head, inflictor, attacker, points);
				}
			}
		}

		head = head.chain;
	}
};

.float backedtonormal;
.float oldmovetype;
.float timepushing;

void() backtonormal = { self.movetype = self.oldmovetype;
	self.gravity = 1;
	self.backedtonormal = 1;
	self.think = self.oldthink;
	self.nextthink = time;
};

void(entity inflictor, entity targ, float damage) explo_physics = { local vector dir;
	if ((inflictor != world) && (targ.movetype == MOVETYPE_STEP) && (targ.timepushing < time))
	{
		dir = targ.origin - (inflictor.absmin + inflictor.absmax) *0.5;
		dir = normalize(dir);
		if (!targ.oldmovetype)
			targ.oldmovetype = targ.movetype;
		targ.movetype = MOVETYPE_BOUNCE;
		targ.timepushing = time + 1;
		targ.gravity = 1;
		if (targ.flags &FL_ONGROUND)
			targ.flags -= FL_ONGROUND;
		targ.backedtonormal = 0;
		targ.oldthink = targ.think;
		targ.think = backtonormal;
		targ.nextthink = time + 0.1;

		targ.velocity = targ.velocity + dir *damage *10 + '0 0 120';
	}
};

void(entity inflictor, float damage, float damagetoplayer, entity ignore, float radius) T_SplashDamageMonster = { local float points;
	local entity head;
	local vector org;
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

				if ((!(head.flags &FL_MONSTER)) && (head.classname != "player"))
					points = 0;

				if ((head.classname == "monster_heretic") || (head.classname == "wraith"))
					points = 0;
				if ((head.solid == SOLID_BSP) || (head.classname == "breakable_urn_large") || (head.classname == "breakable_urn_medium") || (head.classname == "breakable_urn_small"))
					points = 1000;

				if (head == inflictor)
					points = points *0.5;
				if (points > 0)
				{
					entity oldself = self;
					self = inflictor;
					if (visibleb(head.origin, inflictor.origin, self))
					{
						T_Damage(head, inflictor, self, points);
						if ((head.classname != "player") && (!head.heavymonster))
							explo_physics(inflictor, head, points);
					}

					self = oldself;
				}
			}
		}

		head = head.chain;
	}
};

void(entity attacker, float damage) T_BeamDamage = { local float points;
	local entity head;
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