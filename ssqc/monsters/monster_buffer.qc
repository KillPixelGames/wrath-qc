
void()height_controller_think =
{
	setorigin (self, self.owner.origin);
	vector xy_selforigin, xy_targetorigin;

	xy_selforigin = self.origin;
	xy_targetorigin = self.goalentity.origin;
	xy_selforigin_z = 0;
	xy_targetorigin_z = 0;
	

	if((vlen(xy_targetorigin - xy_selforigin) < 128) && (xy_targetorigin_z > xy_selforigin_z)) 
	{
	self.owner.velocity_z = random (254,274); 
	return;
	}	
	else
		self.owner.velocity_z = 0; 
	makevectors(self.owner.angles);
	vector t_dest = self.owner.origin + v_up * -256;
	traceline((self.origin), t_dest, MOVE_WORLDONLY, self);
	
	float distance_to_floor = vlen (self.origin - trace_endpos);

	float nextthink_time =  random( 0.1, 0.5);

	if (trace_fraction != 1.0)
	{
		if(distance_to_floor < 192)
			self.owner.velocity_z = distance_to_floor / (1/nextthink_time); // random (distance_to_floor / (1/nextthink_time)); 
		else
			self.owner.velocity_z = 0; 
	}
	else
	{
		if(distance_to_floor > 192)
			self.owner.velocity_z =-1 * distance_to_floor / (1/nextthink_time); // random (154,174); 
		else
			self.owner.velocity_z = 0; 
	}
	self.think = height_controller_think;
	self.nextthink = time + 	nextthink_time ; 	
};

.float spawned_shield;

void() scale_shield =
{
	if(self.alpha < 1)
	{
	self.light_lev += 12.8;
	self.alpha += 0.05;
	self.scale += 0.5;
	self.owner.glowmod_x += 0.05;
	self.owner.glowmod_y += 0.075;
	self.owner.glowmod_z += 0.1;
	}

	if(self.owner.spawned_shield == 0)
	{
		self.glowmod = '0.05 0.05 0.05';
		self.think = lance_muzzle_think;
	}
	else
		self.think = scale_shield;
	self.nextthink = time + 0.05;
};
.float dodging;
.float buffered;

void() buffer_think =
{

	if((self.goalentity.classentity != "monsters")  && (!(self.goalentity.flags & FL_MONSTER)) )
	{
		entity monster= findradius(self.origin, 10000);
		entity powerful_monster;	
		while (monster)
		{
			if ((monster.flags & FL_MONSTER) && (visible(monster)) && (!(monster.buffer)))
			{
				if(monster.health > powerful_monster.health)
					powerful_monster = monster;
			}
			monster= monster.chain;  // cycle to next monster(entity)
		}

		self.goalentity = powerful_monster;
		self.goalentity.buffer = self;
	}


	if((self.goalentity.classentity != "monsters") && (self.spawned_shield == 1))
	{
		self.spawned_shield = 0;
		self.goalentity = 0;
	}


	if (self.goalentity.classentity == "monsters")
	{
		vector dir = normalize((self.goalentity.origin + '0 0 64') - self.origin);	
		vector rangles = vectoangles(dir);
		self.angles_y = rangles_y;
		float dist =  vlen (self.origin - (self.goalentity.origin + '0 0 128'));

		if(dist > 256)
			 vector nvel = dir * 512;	
		if(dist <= 256)
			nvel = dir * 256;	

		if(dist < 120)
		{
			if(self.spawned_shield != 1) 
			{
				string shieldmodel = "models/weapons/lance/v_flash.md3";
				entity shield = spawn();
				shield.owner = self;
				shield.frame = 2;
				shield.alpha = 0.05;
				shield.pflags = 129;
				shield.color = '0.5 0.85 1';
				shield.think = scale_shield;
				shield.nextthink = time + 0.05;
				setmodel(shield, shieldmodel);
				setattachment(shield, self, "");
				self.spawned_shield = 1;
			}
			//nvel = dir * dist;	
		}

		if((self.strafetime > time) && (self.dodging == 0))
		{
			if(self.dodging == 0)
			makevectors(single_player.v_angle);
			float r = random();
			if(r > 0.5)
				self.velocity = v_right *random(-512,-256);
			else
				self.velocity = v_right *random(256,512);
			float r2 = random();
				self.velocity += v_up  *random(64,128);

			self.dodging = 1;
		}

		if(self.strafetime < time) 
		{
			if(self.dodging == 1)
				self.dodging = 0;
			self.velocity_x = nvel_x;
			self.velocity_y = nvel_y;
			self.velocity_z = nvel_z;
		}
	}
	self.shieldtime = time + 1;
	self.think = buffer_think;
	self.nextthink = time +  random( 0.1, 0.5);
};
void() shieldtimer_shield =
{
	if(self.owner.spawned_shield == 1) 
	{
		entity monster= findradius(self.owner.origin, 200);
		while (monster)
		{
			if ((monster.flags & FL_MONSTER) && ( visibleb(monster.origin, self.owner.origin, self.owner)))
			{
				monster.shieldtime = time + 1; 	
				monster.temp_buffer = self.owner;
			}
			monster= monster.chain; 
		}
	}
	self.think = shieldtimer_shield;
	self.nextthink = time + 0.9;
}; 

void() monster_buffer =
{	
	
	setmodel(self, "models/enemies/wraith/wraith.md3");
	setsize(self, '-16 -16 -32', '16 16 32');
	self.movetype = MOVETYPE_FLY;
	self.th_die = wraith_death1;
	self.solid = SOLID_SLIDEBOX;
	self.enemy = single_player;
	self.health = 100;
	self.takedamage = DAMAGE_AIM;
	setsize(self, '-16 -16 -32', '16 16 32');
	self.glowmod = '0.05 0.05 0.05';
/*	entity height_controller = spawn();
	height_controller.owner =self;
	height_controller.think = height_controller_think;
	height_controller.nextthink = time;*/
	entity shieldtimer = spawn();
	shieldtimer.owner = self;
	shieldtimer.think = shieldtimer_shield;
	shieldtimer.nextthink = time + 0.05;

	self.think = buffer_think;
	self.nextthink = time + 0.5; 	
};