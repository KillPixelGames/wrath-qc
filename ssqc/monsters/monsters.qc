void() monster_use = 
{
	if (self.enemy)
		return;
	if (self.health <= 0)
		return;
	if (activator.flags &FL_NOTARGET)
		return;
	if (activator.classname != "player")
		return;
	self.enemy = activator;
	self.nextthink = time + 0.1;
	self.think = FoundTarget;
};

void() monster_death_use = 
{
	if (self.flags &FL_FLY)
		self.flags = self.flags - FL_FLY;
	if (self.flags &FL_SWIM)
		self.flags = self.flags - FL_SWIM;
/*	if (!self.target)
		return;
	activator = self.enemy;
	SUB_UseTargets();*/

	if ((!self.target) && (!self.death_target))
			return;
	if(self.target)
	{
		activator = self.enemy;
		SUB_UseTargets();
	}
	if(self.death_target)
	{
		self.target = self.death_target;
		activator = self.enemy;
		SUB_UseTargets();
	}

};
.float nodroptofloor;
.float spawned;
void() walkmonster_start_go = 
{
	self.origin_z = self.origin_z + 1;	// raise off floor a bit
	if (self.nodroptofloor != 1)
		droptofloor();
	self.oldorigin = self.origin;
	self.oldangles = self.angles;
	if (!walkmove(0, 0))
	{
		dprint("walkmonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}

	if (self.takedamage != DAMAGE_AIM)
		self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles *'0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	if(!(self.flags & FL_MONSTER))
		self.flags = self.flags | FL_MONSTER;
	if (self.target != string_null)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		if (!self.movetarget)
		{
			dprint("Monster can't find target at ");
			dprint(vtos(self.origin));
			dprint("\n");
		}

		// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk();
		else
			self.pausetime = 99999999;
		self.th_stand();
	}
	else
	{
		if ((self.grosstime > time) && (!(single_player.flags &FL_NOTARGET)))
		{
			FoundTarget();
			local entity pl;
			pl = find(world, classname, "player");
			self.enemy = pl;
			self.goalentity = pl;
			self.think = self.th_run;

			if (self.classname == "monster_stricken")
			{
				local entity head;

				head = findradius(self.origin, stricken_walkradius);	//send lightning line to anything in 250 radius
				while (head)	// while looking for head
				{
					if ((head.takedamage) && ((head.classname == "monster_fallen") || (head.classname == "breakable_urn_large") || (head.classname == "breakable_urn_medium") || (head.classname == "breakable_urn_small") || (head.classname == "func_destruct")))	// if head has health, attack it
					{
						if (head != self)
							T_Damage(head, self, self, 120);	// its damage
					}

					head = head.chain;	// go to next enemy
				}
			}

			if ((self.classname == "monster_fallen") && (self.rise != 1))
				self.think = self.th_melee;
		}
		else
		{
			self.pausetime = 99999999;
			self.th_stand();
		}
	}

	if ((self.rise == 1) || (self.grosstime > time) || (self.warped == 1) || (self.spawned == 1))
		self.nextthink = time;
	else
		self.nextthink = self.nextthink + random() *0.5;
};

void() ind_update = 
{
	if (devscreen == TRUE)
	{
		self.health = (self.owner.frame);
		setorigin(self, self.owner.origin + '0 0 64');
		self.SendFlags |= 0x2;
	}

	self.nextthink = time + 0.1;
	self.think = ind_update;
};

float() Send_Indicator = 
{
	WriteByte(MSG_ENTITY, ENT_HMMSG);
	WriteCoord(MSG_ENTITY, self.origin_x);
	WriteCoord(MSG_ENTITY, self.origin_y);
	WriteCoord(MSG_ENTITY, self.origin_z);
	WriteShort(MSG_ENTITY, self.owner.health);
	return TRUE;
};

void(entity selff) indicator = 
{
	local entity indicator;
	return;//
	indicator = spawn();
	indicator.owner = selff;
	indicator.classname = "indicator";
	setmodel(indicator, "models/dev/gizmo.md3");	// dummy model
	indicator.origin = self.owner.origin + '0 0 64';
	indicator.msg = 1;
	indicator.effects = EF_DIMLIGHT;
	indicator.think = ind_update;
	indicator.nextthink = time + 0.1;
	indicator.SendEntity = Send_Indicator;
	//	self.SendFlags |= 0x2;
	self.SendFlags = -1;
};
.float warpframe;
.float lastframewarp;

void()color_controller_think = 
{

	self.warpframe += 1;
	if(self.warpframe >= 10)
	{
		self.colormod = '1 1 1';
		self.think = SUB_Remove;
	}
	else
	{
		if (self.colormod_x > 1)
			self.colormod_x -= 0.45;
		else
			self.colormod_x -= 1;

		if (self.colormod_y < 1)
			self.colormod_y += 0.1;
		if (self.colormod_z < 1)
			self.colormod_z += 0.1;
	}
	self.owner.colormod = self.colormod;
	self.nextthink = time + 0.1;
}
void() warped_go = 
{
	self.flags = self.flags | FL_MONSTER;
	self.frame += 1;


	if(!self.warpframe)
	{
	entity color_controller = spawn();
	setmodel	 (color_controller,"");
	color_controller.owner = self;
	color_controller.warpframe = 1;
	color_controller.colormod = self.colormod;
	color_controller.think = color_controller_think;
	color_controller.nextthink = time;
	}

	self.warpframe += 1;
	if(self.warpframe < 3)
		self.takedamage = 0;
	else	
		self.takedamage = DAMAGE_AIM;

	self.warpedtime = time + 0.1;
	if (self.frame < self.lastframewarp)
	{
		self.think = warped_go;
		self.nextthink = time + 0.1;
	}
	else
	{
		self.grosstime = time + 0.2;
		self.ideal_yaw = self.angles *'0 1 0';
		if (!self.yaw_speed)
			self.yaw_speed = 20;
		self.view_ofs = '0 0 25';

		self.alpha = 1;
		self.colormod = '1 1 1';
		//self.glowmod = '1 1 1';
		if ((self.grosstime > time) && (!(single_player.flags &FL_NOTARGET)))

		{
			FoundTarget();
			local entity pl;
			pl = find(world, classname, "player");
			self.enemy = pl;
			self.goalentity = pl;
			self.think = self.th_run;

			if (self.classname == "monster_stricken")
			{
				local entity head;

				head = findradius(self.origin, stricken_walkradius);	//send lightning line to anything in 250 radius
				while (head)	// while looking for head
				{
					if ((head.takedamage) && ((head.classname == "monster_fallen") || (head.classname == "breakable_urn_large") || (head.classname == "breakable_urn_medium") || (head.classname == "breakable_urn_small") || (head.classname == "func_destruct")))	// if head has health, attack it
					{
						if (head != self)
							T_Damage(head, self, self, 120);	// its damage
					}

					head = head.chain;	// go to next enemy
				}
			}

			if ((self.classname == "monster_fallen") && (self.rise != 1))
				self.think = self.th_melee;

		}
		else
		{
			self.pausetime = 99999999;
			self.think = self.th_stand;
			
		}

		self.nextthink = time + 0.1;
		self.warped = 0;
	}
};
void(entity e) spawn_emitters;
void() walkmonster_start = {	// delay drop to floor to make sure all doors have been spawned
	// spread think times so they don't all happen at same time
	self.classentity = "monsters";
	self.oldstepheight_delta = self.stepheight_delta;

	self.flags = self.flags | FL_MONSTER;
	if(self.classname != "monster_oppressor")
	self.bloody = 1;
	else
	spawn_emitters(self);
	//indicator(self);
	if (self.warped)
		self.think = warped_go;
	else
		self.think = walkmonster_start_go;
	if ((self.rise == 1) || (self.spawned == 1) || (self.warped))
		self.nextthink = time + 0.05;
	else
		self.nextthink = self.nextthink + random() *0.25;

};

void() flymonster_start_go = 
{
	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles *'0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 20;
	self.view_ofs = '0 0 25';
	self.use = monster_use;
	self.flags = self.flags | FL_FLY;
	self.flags = self.flags | FL_MONSTER;
	if (!walkmove(0, 0))
	{
		dprint("flymonster in wall at: ");
		dprint(vtos(self.origin));
		dprint("\n");
	}

	if (self.target != string_null)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint("Monster can't find target at ");
			dprint(vtos(self.origin));
			dprint("\n");
		}

		// this used to be an objerror
		if (self.movetarget.classname == "path_corner")
			self.th_walk();
		else
			self.pausetime = 99999999;
		self.th_stand();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand();
	}
};

void() warpedfly_go = 
{
	self.flags = self.flags | FL_MONSTER;
	self.frame += 1;

	if(!self.warpframe)
	{
		entity color_controller = spawn();
		setmodel	 (color_controller,"");
		color_controller.warpframe = 1;
		color_controller.owner = self;
		color_controller.colormod = self.colormod;
		color_controller.think = color_controller_think;
		color_controller.nextthink = time;
	}
	self.warpedtime = time + 0.1;
	self.warpframe += 1;
	if(self.warpframe < 3)
		self.takedamage = 0;
	else	
		self.takedamage = DAMAGE_AIM;


	if (self.frame < self.lastframewarp)
	{
		self.think = warpedfly_go;
		self.nextthink = time + 0.1;
	}
	else
	{
		self.ideal_yaw = self.angles *'0 1 0';
		if (!self.yaw_speed)
			self.yaw_speed = 20;
		self.view_ofs = '0 0 25';

		self.alpha = 1;
		self.colormod = '1 1 1';
		self.glowmod = '1 1 1';
		if (self.classname == "monster_heretic")
			self.glowmod = '-1 -1 -1';
		if ((self.grosstime > time) && (!(single_player.flags &FL_NOTARGET)))
		{
			FoundTarget();
			local entity pl;
			pl = find(world, classname, "player");
			self.enemy = pl;
			self.think = self.th_run;
		}
		else
		{
			self.pausetime = 99999999;
			self.think = self.th_stand;
		}
		self.nextthink = time + 0.1;
		self.warped = 0;
	}
	self.sustained_damage = 0;
};

void() flymonster_start = {	// spread think times so they don't all happen at same time
	if ((self.rise == 1) || (self.warped))
		self.nextthink = time + 0.1;
	else
		self.nextthink = self.nextthink + random() *1;
	self.flags = self.flags | FL_FLY;
	self.classentity = "monsters";
	if (self.warped)
		self.think = warpedfly_go;
	else
		self.think = flymonster_start_go;
	//indicator(self);
};

void() swimmonster_start_go = 
{
	if (deathmatch)
	{
		remove(self);
		return;
	}

	self.takedamage = DAMAGE_AIM;
	self.ideal_yaw = self.angles *'0 1 0';
	if (!self.yaw_speed)
		self.yaw_speed = 50;
	self.view_ofs = '0 0 10';
	self.use = monster_use;
	self.flags = self.flags | FL_MONSTER;
	self.flags = self.flags | FL_FLY;

	if (self.target != string_null)
	{
		self.goalentity = self.movetarget = find(world, targetname, self.target);
		if (!self.movetarget)
		{
			dprint("Monster can't find target at ");
			dprint(vtos(self.origin));
			dprint("\n");
		}

		// this used to be an objerror
		self.ideal_yaw = vectoyaw(self.goalentity.origin - self.origin);
		self.th_walk();
	}
	else
	{
		self.pausetime = 99999999;
		self.th_stand();
	}

	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random() *0.5;
};

void() swimmonster_start = {	// spread think times so they don't all happen at same time
	self.nextthink = self.nextthink + random() *0.5;
	self.classentity = "monsters";
	self.think = swimmonster_start_go;
};

////////////////end of qc file
