.float oldammo_coachgun;
.float noshells;
.float oldcoachgunclip;
.float sfcg;
void() check_coachgun;
void() idle_coachgun;

void() idle_coachgun = 
{
	if (self.playerdeadtime > time)
	{
		self.think = PlayerDeathThink;
		self.nextthink = time;
	}

	if (self.sfcg)
		self.sfcg = 0;
	self.realoding = 0;
	if (self.vweaponglowmod_x != -0.1)
		self.vweaponglowmod = '-0.1 -0.1 -0.1';
	self.vweaponframe = 1;
	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	self.think = idle_coachgun;
	self.nextthink = time + 0.1;
};
void(vector org, vector dir, float order, entity ownerproj) launch_projectile_coachgun;
void() wsfire_coachgun1 =
{
	self.vweaponframe += 1;
	if(self.vweaponframe == 18)
	{
		self.vweaponglowmod = '1 1 1';	
		vector dir;
		string snd;
		makevectors (self.v_angle);
		snd = strcat ("weapons/coachgun/fire2_", ftos (floor(random() * 2) + 1),".ogg");
		sound (self, CHAN_WEAPON, snd, 1, ATTN_NORM);
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
		self.punchangle_x = -2;
		dir = aim (self, 100000);
		vector tagorg;
		if (self.ammo_coachgun == 1)
		{
			tagorg = tag_origin("tag_proja",self.vweapon);
			launch_projectile_coachgun (tagorg, dir, 1,self);	
			self.ammo_coachgun -= 1;
		}
		if (self.ammo_coachgun == 2)
		{
			tagorg = tag_origin("tag_proja",self.vweapon);
			launch_projectile_coachgun (tagorg, dir, 1,self);	
			tagorg = tag_origin("tag_projb",self.vweapon);
			launch_projectile_coachgun (tagorg, dir, 2,self);	
			self.ammo_coachgun -= 2;
		}
		if (self.ammo_coachgun > 2)
		{
			tagorg = tag_origin("tag_proja",self.vweapon);
			launch_projectile_coachgun (tagorg, dir, 1,self);	
			tagorg = tag_origin("tag_projb",self.vweapon);
			launch_projectile_coachgun (tagorg, dir, 2,self);	
			tagorg = tag_origin("tag_projc",self.vweapon);
			launch_projectile_coachgun (tagorg, dir, 3,self);	
			self.ammo_coachgun -= 3;
		}
		self.effects += EF_MUZZLEFLASH;
		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/coachgun/flash_big.md3";
		muzzle = spawn();
		muzzle.owner = self;
		setmodel (muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle,self.vweapon,"tag_muzzle2");
		muzzle.angles_z = random() * 360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;
	}	
	if((self.vweaponframe > 18) && (self.vweaponglowmod_x > 0))
	{
		self.vweaponglowmod_x -= 0.05; 
		self.vweaponglowmod_y -= 0.05; 
		self.vweaponglowmod_z -= 0.05;
	}
	if(self.vweaponframe >= 41)
		self.think = idle_coachgun;
	else
	self.think = wsfire_coachgun1;		
	self.nextthink = time +  0.05;	
};
/*void() wsfire_coachgun1bac = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 18)
	{
		self.vweaponglowmod = '1 1 1';
		local vector dir;
		local string snd;
		makevectors(self.v_angle);
		snd = strcat("weapons/coachgun/fire2_", ftos(floor(random() *2) + 1), ".ogg");
		sound(self, CHAN_WEAPON, snd, 1, ATTN_NORM);
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
		self.punchangle_x = -2;
		dir = aim(self, 100000);
		if (self.ammo_coachgun == 2)
		{
			FireBullets(2, dir, '0.01 0.02 0', self.coachgun_damage2, self.coachgun_spread2);
			self.ammo_coachgun -= 2;
		}
		else
		{
			FireBullets(3, dir, '0.01 0.02 0', self.coachgun_damage2, self.coachgun_spread2);
			self.ammo_coachgun -= 3;
		}

		self.effects += EF_MUZZLEFLASH;

		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/coachgun/flash_big.md3";
		muzzle = spawn();
		muzzle.owner = self;
		setmodel(muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle, self.vweapon, "tag_muzzle2");
		muzzle.angles_z = random() *360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;
	}

	if ((self.vweaponframe > 18) && (self.vweaponglowmod_x > 0))
	{
		self.vweaponglowmod_x -= 0.05;
		self.vweaponglowmod_y -= 0.05;
		self.vweaponglowmod_z -= 0.05;
	}

	if (self.vweaponframe >= 41)
		self.think = idle_coachgun;
	else
		self.think = wsfire_coachgun1;
	self.nextthink = time + 0.05;
};
*/
void() wsfire_coachgun = 
{
	self.vweaponglowmod = '0.5 0.5 0.5';
	self.vweaponframe = 17;
	self.think = wsfire_coachgun1;
	self.nextthink = time + 0.05;
	self.attack_finished = time + 0.9;
};

void() wfire_coachgun1 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 3)
	{
		self.vweaponglowmod = '1 1 1';
		local vector dir;
		local string snd;
		makevectors(self.v_angle);
		snd = strcat("weapons/coachgun/fire1_", ftos(floor(random() *3) + 1), ".ogg");
		sound(self, CHAN_WEAPON, snd, 1, ATTN_NORM);
		float active_punchangle = cvar ("cl_punch");
		if(active_punchangle == 1)
		self.punchangle_x = -2;
		dir = aim(self, 100000);
		FireBullets(1, dir, '0.01 0.02 0', self.coachgun_damage1, self.coachgun_spread1);
		self.effects += EF_MUZZLEFLASH;
		self.ammo_coachgun -= 1;
		//muzzle_coachgun(self.vweapon, 1);
		local entity muzzle;
		local string muzzlemodel;
		muzzlemodel = "models/weapons/coachgun/flash_small.md3";
		muzzle = spawn();
		muzzle.owner = self;
		setmodel(muzzle, muzzlemodel);
		muzzle.viewmodelforclient = self;
		setattachment(muzzle, self.vweapon, "tag_muzzle");
		muzzle.angles_z = random() *360;
		muzzle.think = SUB_Remove;
		muzzle.nextthink = time + 0.05;
	}

	if ((self.vweaponframe > 4) && (self.vweaponglowmod_x > 0))
	{
		self.vweaponglowmod_x -= 0.1;
		self.vweaponglowmod_y -= 0.1;
		self.vweaponglowmod_z -= 0.1;
	}

	if (self.vweaponframe >= 15)
		self.think = idle_coachgun;
	else
		self.think = wfire_coachgun1;
	self.nextthink = time + 0.05;
};

void() wfire_coachgun = 
{
	self.vweaponglowmod = '0.5 0.5 0.5';
	self.vweaponframe = 2;
	self.think = wfire_coachgun1;
	self.nextthink = time + 0.05;
};

void() pick_up_coachgun2 = 
{
	self.think = idle_coachgun;
	self.pick_up_time = time + 0.5;
	self.vweaponstate = 1;
	self.nextthink = time + 0.05;
};

void() pick_up_coachgun = 
{
	self.lastweapon = IT_COACHGUN;
	self.weapon = IT_COACHGUN;
	sound(self, CHAN_WEAPON, "weapons/coachgun/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponskin = self.coachgunclip;
	self.vweaponglowmod = '-0.1 -0.1 -0.1';
	self.vweaponstate = 2;
	if (self.noltime < time)
		self.lspeedtime = time + 5;
	self.vweaponframe = 0;
	self.attack_finished = time + 0.05;
	self.think = pick_up_coachgun2;
	self.nextthink = time + 5.95;
}

void() raise_coachgun2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 45)
		W_SetWeapon();

	if (self.vweaponframe >= 47)
	{
		self.think = idle_coachgun;
	}
	else
		self.think = raise_coachgun2;
	self.nextthink = time + 0.025;
};

void() raise_coachgun = 
{
	self.weapon = IT_COACHGUN;
	W_SetWeapon();
	sound(self, CHAN_AUTO, "weapons/coachgun/raise.ogg", 1, ATTN_NORM);
	self.vweaponglowmod = '-0.1 -0.1 -0.1';
	self.draw_w = 0;
	self.vweaponskin = self.coachgunclip;
	self.vweaponframe = 43;
	self.vweaponstate = 1;
	self.attack_finished = time + 0.125;
	self.think = raise_coachgun2;
	self.nextthink = time;
};

void() lower_coachgun2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 51)
		self.think = raise_weapon;
	else
		self.think = lower_coachgun2;
	self.nextthink = time + 0.025;
};

void() lower_coachgun = 
{
	sound(self, CHAN_AUTO, "weapons/coachgun/lower.ogg", 1, ATTN_NORM);
	self.vweaponframe = 48;
	self.attack_finished = time + 0.125;
	self.think = lower_coachgun2;
	self.vweaponstate = 2;
	self.nextthink = time + 0.025;
};

///////////////////////////////////end of qc file