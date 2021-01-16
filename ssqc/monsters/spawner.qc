//#pragma warning error Q208

void() monster_fallen;
void() monster_wraith;
void() monster_executioner;
.float rise;



void() check_spawner_counter = {

/* local entity pl;
	pl = find(world, classname, "player");
	local float m_counter = self.count;

	if (pl.oldrelics == 4)
	{
		if (self.classmonster5 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}
	if (pl.oldrelics == 3)
	{
		if (self.classmonster4 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}
	if (pl.oldrelics == 2)
	{
		if (self.classmonster3 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}
	if (pl.oldrelics == 1)
	{
		if (self.classmonster2 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}
	if (!pl.oldrelics)
	{
		if (self.classmonster1 > 0)
			total_monsters = total_monsters + m_counter;
		return;	
	}

*/

};


float() monster_counter = 
{ 
	local entity monster;
	local float monster_counter;
	monster = findradius(self.origin, 1000000);
	while (monster)
	{
		if ((monster.flags &FL_MONSTER) && (monster.health >= 0))
		{
		monster_counter ++; 
		}

		monster = monster.chain;	
	}
	return monster_counter;
};

void() recount_monsters =
{
	total_monsters = killed_monsters +  monster_counter ();
	entity pl = find(world, classname, "player");

	local entity spawner;
	spawner = findradius(self.origin, 1000000);
	while (spawner)	//Loops through everything put in the missile entit
	{
		if (spawner.wrathflags &FL_SPAWNER)
		{
		local float m_counter = spawner.count;
			if (pl.oldrelics == 4)
			{
				if (spawner.classmonster5 > 0)
					total_monsters = total_monsters + m_counter;
			}
			if (pl.oldrelics == 3)
			{
				if (spawner.classmonster4 > 0)
					total_monsters = total_monsters + m_counter;
			}
			if (pl.oldrelics == 2)
			{
				if (spawner.classmonster3 > 0)
					total_monsters = total_monsters + m_counter;
			}
			if (pl.oldrelics == 1)
			{
				if (spawner.classmonster2 > 0)
					total_monsters = total_monsters + m_counter;
			}
			if (!pl.oldrelics)
			{
				if (spawner.classmonster1 > 0)
					total_monsters = total_monsters + m_counter;
			}

		}

		spawner = spawner.chain;
	}

};


void() check_relics = 
{
	self.local_classmonster = self.classmonster1;
	local entity pl;
	pl = find(world, classname, "player");
	if (!pl.oldrelics)
		return;
	if (pl.oldrelics == 1)
		self.local_classmonster = self.classmonster2;
	if (pl.oldrelics == 2)
		self.local_classmonster = self.classmonster3;
	if (pl.oldrelics == 3)
		self.local_classmonster = self.classmonster4;
	if (pl.oldrelics >= 4)
		self.local_classmonster = self.classmonster5;
};

void() enemy_spawner_use = 
{
	if (self.warped != 1)
	{
		check_relics();
		if (self.local_classmonster <= 0)
		{
			remove(self);
			return;
		}
	}
	self.count -= 1;
	if ((self.count >= 0) && (self.local_classmonster > 0))
	{
		local entity enemy;
		enemy = spawn();
		enemy.flags = FL_MONSTER;
		setorigin(enemy, self.origin);
		enemy.angles = self.angles;
		if (self.type == 1)
			enemy.grosstime = time + 0.5;
		enemy.waypointed = self.waypointed;
		enemy.rise = self.rise;
		enemy.nojump = self.nojump;
		enemy.turret = self.turret;
		enemy.likecharge = self.likecharge;
		enemy.target = self.target;
		enemy.death_target = self.death_target;
		enemy.targetname = self.targetname;
		enemy.spawned = 1;
		enemy.spawnflags = self.spawnflags;
		enemy.nodroptofloor = self.nodroptofloor;
		enemy.oldorigin = self.origin;
		if (self.local_classmonster == 1)
		{
			if (self.type == 1)
				enemy.grosstime = time + 2.7;
			enemy.rise = self.rise;
			enemy.think = monster_fallen;
		}
		if (self.local_classmonster == 2)
			enemy.think = monster_invader;
		if (self.local_classmonster == 3)
			enemy.think = monster_wretch;
		if (self.local_classmonster == 4)
			enemy.think = monster_incisor;
		if (self.local_classmonster == 5)
			enemy.think = monster_widow;
		if (self.local_classmonster == 6)
			enemy.think = monster_wraith;
		if (self.local_classmonster == 7)
			enemy.think = monster_heretic;
		if (self.local_classmonster == 8)
			enemy.think = monster_lurker;
		if (self.local_classmonster == 9)
		{
			enemy.think = monster_oppressor;
		}
		if (self.local_classmonster == 10)
			enemy.think = monster_executioner;
		if (self.local_classmonster == 11)
			enemy.think = monster_stricken;
		if (self.local_classmonster == 12)
			enemy.think = monster_afflicted;
		if (self.warped)
		{

			if (self.type == 1)
				enemy.grosstime = time + 1.5;
			enemy.warped_time = time + 3;	
			enemy.warped = 1;
			enemy.colormod = '5 0 0';
			//enemy.glowmod = '10 2 2';
			enemy.frame = 88;
			enemy.lastframewarp = 97;
			if ((self.local_classmonster == 1) && (self.rise == 1))
			{
				enemy.frame = 116;
				enemy.lastframewarp = 123;
			}
			if (self.local_classmonster == 2)
			{
				enemy.frame = 21;
				enemy.lastframewarp = 30;
			}
			if (self.local_classmonster == 3)
			{
				enemy.frame = 21;
				enemy.lastframewarp = 30;
			}
			if (self.local_classmonster == 4)
			{
				enemy.frame = 21;
				enemy.lastframewarp = 30;
			}

			if (self.local_classmonster == 5)
			{
				enemy.frame = 63;
				enemy.lastframewarp = 72;
			}
			if (self.local_classmonster == 6)
			{
				enemy.frame = 59;
				enemy.lastframewarp = 68;
			}
			if (self.local_classmonster == 7)
			{
				enemy.frame = 21;
				enemy.lastframewarp = 30;
			}
			if (self.local_classmonster == 9)
			{
				enemy.frame = 21;
				enemy.lastframewarp = 30;
			}
			if (self.local_classmonster == 10)
			{
				enemy.frame = 166;
				enemy.lastframewarp = 175;
			}
			if (self.local_classmonster == 11)
			{
				enemy.frame = 88;
				enemy.lastframewarp = 97;
			}
			enemy.nextthink = time+ 0.05;
		}
		else
			enemy.nextthink = time + 0.05;
		self.think = enemy_spawner_use;
		self.nextthink = time + self.delay;
	}
	else
	{
		//if(self.respawnable)
		//self.wrathflags = FL_RESPAWN;
		self.think = SUB_Remove;
		self.use = null;
		self.nextthink = time + 0.1;
	}
};

void() enemy_spawner_use_wait = 
{
	self.think = enemy_spawner_use;
	self.nextthink = time + self.wait;
};

void() enemy_spawner = 
{
	self.wrathflags += FL_SPAWNER;
	self.local_classmonster = self.classmonster1;
	if (!self.classmonster2)
		self.classmonster2 = self.classmonster1;
	if (!self.classmonster3)
		self.classmonster3 = self.classmonster1;
	if (!self.classmonster4)
		self.classmonster4 = self.classmonster1;
	if (!self.classmonster5)
		self.classmonster5 = self.classmonster1;
	if (!self.count)
		self.count = 1;
	if (!self.delay)
		self.delay = 5;
	setmodel(self, "");
	if (self.wait)
		self.use = enemy_spawner_use_wait;
	else
		self.use = enemy_spawner_use;
	self.think = check_spawner_counter;
	self.nextthink = time + 0.25;
	if (!self.targetname)
	{				
		self.think = wrath_objerror;
		self.nextthink = time + random();
	}
	//if(self.respawnable)
	//copy_old_data (self);
};

.float fastwarp;
void() enemy_spawner_warp_use = 
{
	check_relics();
	if (self.local_classmonster <= 0)
	{
		remove(self);
		return;
	}
	if ((!self.fastwarp) && (!self.frame))
	{
		self.frame = 1;
		self.effects -= EF_NODRAW;
		sound(self, CHAN_AUTO, "fx/warp.ogg", 1, 0.125);
	}
	if ((self.fastwarp) && (!self.frame))
	{
		self.frame = 2;
		self.cnt = 35;
		self.effects -= EF_NODRAW;
		sound(self, CHAN_AUTO, "fx/warp_fast.ogg", 1, 0.125);
		self.alpha = 1;
	}
	self.cnt += 1;
	if ((!self.fastwarp))
	{
		if ((self.alpha < 1) && (self.cnt <= 10))
			self.alpha += 0.1;
	}

	if (self.cnt == 36)
	{
		enemy_spawner_use();
		pointparticles(particleeffectnum("warp"), self.origin, '0 0 0', 1);
	}
	if (self.cnt > 36)
		self.alpha -= 0.1;
	if (self.cnt >= 45)
		self.think = SUB_Remove;
	else
		self.think = enemy_spawner_warp_use;
	self.nextthink = time + 0.05;
};

void() enemy_spawner_warp_use_wait = 
{
	self.think = enemy_spawner_warp_use;
	self.nextthink = time + self.wait;
};
void() enemy_spawner_warp = 
{ 
	self.wrathflags += FL_SPAWNER;
	if (!self.type)
		self.type = 1;
	self.frame = 0;
	self.alpha = 0.00001;
	if (!self.nodroptofloor)
		self.nodroptofloor = 1;
	setmodel(self, "models/warp/warp.md3");
	self.effects += EF_NODRAW;
	self.warped = 1;
	if (!self.classmonster2)
		self.classmonster2 = self.classmonster1;
	if (!self.classmonster3)
		self.classmonster3 = self.classmonster1;
	if (!self.classmonster4)
		self.classmonster4 = self.classmonster1;
	if (!self.classmonster5)
		self.classmonster5 = self.classmonster1;
	self.local_classmonster = self.classmonster1;
	self.count = 1;
	if (self.wait)
		self.use = enemy_spawner_warp_use_wait;
	else
		self.use = enemy_spawner_warp_use;
	self.think = check_spawner_counter;
	self.nextthink = time + 1;
	if (!self.targetname)
	{				
		self.think = wrath_objerror;
		self.nextthink = time + random();
	}
};

void() trigger_aggro_touch = 
{
	if (other.classname != "player")
		return;
	if(single_player.flags &FL_NOTARGET)
		return;


	local entity e;
	if (self.target)
	{
		e = world;
		do { 	e = find(e, targetname, self.target);
			if (!e)
				return;
			e.grosstime = time + 0.1;
		}
		while (1);
	}
};

void() trigger_aggro = 
{
	self.touch = trigger_aggro_touch;
	self.solid = SOLID_TRIGGER;
	setmodel(self, self.model);
	self.modelindex = 0;
	self.model = string_null;
};

////////////////end of qc file