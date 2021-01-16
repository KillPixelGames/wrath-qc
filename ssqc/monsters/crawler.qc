void() ShalHome =
{
	local vector	dir, vtemp;
	vtemp = self.enemy.origin + '0 0 10';
	if (self.enemy.health < 1)
	{
		remove(self);
		return;
	}

	dir = normalize(vtemp - self.origin);
	if (skill == 3)
		self.velocity = dir * 350;

	else
		self.velocity = dir * 250;
	
	//if(self.flags & FL_ONGROUND)
	//self.velocity_z = -200;
//	else
//	{
//	self.velocity_x = 0;
//	self.velocity_y = 0;
//	}
	self.angles = vectoangles(self.velocity);
	self.nextthink = time + 0.02;
	self.think = ShalHome;	
};

void() crawler_think =
{
	local	vector	dir;
	local	float	dist, flytime;
	entity pl = find(world, classname, "player");
	dir = normalize((pl.origin + '0 0 10') - self.origin);
	dist = vlen (pl.origin - self.origin);
	flytime = dist * 0.002;
	if (flytime < 0.1)
		flytime = 0.1;
	self.enemy = pl;
	self.velocity = dir * 400;
	self.nextthink = flytime + time;
	self.think = ShalHome;
};

void() crawler =
{
	self.solid = SOLID_BBOX;
	self.movetype = MOVETYPE_WALK;
	setmodel (self, "models/enemies/widow/widow.md3");
	setsize (self, '-12 -12 -12', '12 12 12');		
	self.scale = 0.5;
	self.origin = self.origin + '0 0 10';
	self.nextthink = 1 + time;
	self.think = crawler_think;
};









