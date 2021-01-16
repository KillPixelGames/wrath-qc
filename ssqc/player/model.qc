.entity player_model;
void() weapon_think =
{
	if(self.owner.weapon != self.weapon)
	{
		self.colormod = self.owner.vweapon.colormod;
		if(self.owner.weapon == IT_MELEE)
			setmodel(self, "models/weapons/melee/v_blade.md3");
		if(self.owner.weapon == IT_COACHGUN)
			setmodel(self, "models/weapons/coachgun/w_coachgun.md3");
		if(self.owner.weapon == IT_SHOTGUN)
			setmodel(self, "models/weapons/shotgun/w_shotgun.md3");
		if(self.owner.weapon == IT_SPITTER)
			setmodel(self, "models/weapons/spitter/w_spitter.md3");
		if(self.owner.weapon == IT_RETCHER)
			setmodel(self, "models/weapons/retcher/w_retcher.md3");
		if(self.owner.weapon == IT_CANNON)
			setmodel(self, "models/weapons/cannon/w_cannon.md3");
		if(self.owner.weapon == IT_LANCE)
			setmodel(self, "models/weapons/lance/w_shotgun.md3");

		self.weapon = self.owner.weapon;
	}
	self.think = weapon_think;
	self.nextthink = time + 0.05;
};

.float onground_time;
void() lower_think =
{
	//local string lmessage;
	//lmessage =strcat ((vtos(self.owner.angles)),("\n")) ;
	//bprint (lmessage);
	//setorigin (self, self.owner.origin);
//	if((self.owner.wrathflags & FL_WONGROUND))
	if(self.owner.onground_time > time)
	{
		float speed = vlen (self.owner.velocity);
		if (speed > 30)
		{
		if(self.owner.crouch)
			self.frame = 6;
		else	
			self.frame = 8;
		}
		else
		{
		if(self.owner.crouch)
			self.frame = 14;
		else	
			self.frame = 13;
		}
	}
	else
	{
			self.frame = 11;

	}

	//self.v_angle_x = self.owner.angles_x;
	self.angles_x = -self.owner.angles_x * 0.5;

	//vector selfangles= vectoangles(self.owner.velocity);
	//self.v_angle_y = 0;
	self.angles_z = 0;
	self.think = lower_think;
	self.nextthink = time + 0.025;
};
.entity torso_model;
.float torso_time;
void() torso_think =
{

	if((self.owner.button0)||(self.owner.button3))
	{
		if(self.owner.weapon == IT_MELEE)
			self.frame = 11;
		else
			self.frame = 16;
	}
	else
	{
		if(self.frame != 25)
			self.frame = 25;
	}
	/*else
	{
		if((self.owner.weapon == IT_MELEE)&& (self.frame != 11))
			self.frame =11;
		else	
		{
			if (self.frame != 16)
				self.frame =16;
		}
	}*/
	self.angles_x = self.owner.angles_x * 2;
	self.angles_y = 0;
	self.angles_z = 0;
	self.think = torso_think;
	self.nextthink = time + 0.025;
};
void(entity e) spawn_player_model =
{
	entity playermodel, torso;
	playermodel = spawn();
	e.player_model = playermodel; 
	/*playermodel.origin = e.origin;
	playermodel.movetype = MOVETYPE_FOLLOW;
	playermodel.aiment = e;*/
	playermodel.owner = e;
	
	playermodel.wrathflags = FL_GARBAGE;
	setattachment(playermodel, e,"");
	playermodel.frame = 13;
	playermodel.exteriormodeltoclient = e;
	setmodel(playermodel, "models/alpha/lower.md3");
	playermodel.think = lower_think;
	playermodel.nextthink = time + 0.05;
	torso = spawn();
	torso.owner = e;
	e.torso_model = torso;
	setmodel(torso, "models/alpha/upper.md3");
	//void(entity e, entity tagentity, string tagname) setattachment
	setattachment(torso,playermodel, "tag_torso");
	torso.frame = 25;
	torso.wrathflags = FL_GARBAGE;
	torso.think = torso_think;
	torso.nextthink = time + 0.05;
	entity head = spawn();
	head.owner = e;
	setmodel(head, "models/alpha/head.md3");
	setattachment(head,torso, "tag_head");
	head.wrathflags = FL_GARBAGE;
	head.think = torso_think;
	head.nextthink = time + 0.05;
	entity weapon = spawn();
	weapon.wrathflags = FL_GARBAGE;
	weapon.owner = e;
	setmodel(weapon, "models/weapons/shotgun/w_shotgun.md3");
	setattachment(weapon,torso, "tag_weapon");
	weapon.scale = 0.5;
	weapon.think = weapon_think;
	weapon.nextthink = time + 0.05;

};
void(entity e) spawn_player_models =
{
setmodel(e,"models/players/outlander/player.md3");
}
void()corpse_dead_think =
{
self.think = SUB_Remove;
self.nextthink = time + 30;
}

void(vector org, vector ang)spawn_dead_model =
{
	entity fakeplayer = spawn();
	setmodel(fakeplayer, "models/misc/null.md3");
	fakeplayer.origin = org;
	fakeplayer.angles_y =ang_y;
	float r = random();
	if (r < 1)
	fakeplayer.frame = 0;
	if (r < 0.65)
	fakeplayer.frame = 2;
	if (r < 0.35)
	fakeplayer.frame = 4;


	entity playermodel, torso;
	playermodel = spawn();
	playermodel.owner = fakeplayer;
	playermodel.wrathflags = EF_LOWPRECISION;
	setattachment(playermodel, fakeplayer,"");
	setmodel(playermodel, "models/alpha/lower.md3");
	playermodel.think = corpse_dead_think;
	playermodel.nextthink = time + 1.55;
	playermodel.frame = fakeplayer.frame;
	torso = spawn();
	torso.owner = fakeplayer;
	setmodel(torso, "models/alpha/upper.md3");
	setattachment(torso,playermodel, "tag_torso");
	torso.frame = fakeplayer.frame;
	torso.think = corpse_dead_think;
	torso.nextthink = time + 1.55;
	entity head = spawn();
	head.owner = fakeplayer;
	setmodel(head, "models/alpha/head.md3");
	setattachment(head,torso, "tag_head");
	head.think = corpse_dead_think;
	head.nextthink = time + 1.55;
};
