void() lower_vmodel2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 60)
		self.think = raise_weapon;
	else
		self.think = lower_vmodel2;
	self.nextthink = time + 0.05;
};

void() lower_vmodel = 
{
	self.vweaponframe = 51;
	self.attack_finished = time + 0.25;
	self.think = lower_vmodel2;
	self.nextthink = time + 0.05;
};

.float randomattack;
.float oldrandomattack;

void() v_vmodel_idle = 
{
	self.vweaponstate = 0;
	self.vweaponframe = 0;

};

void() w_vmodel_slash2 = 
{
	local float lastvweaponframe;
	self.vweaponframe += 1;

	if (self.randomattack == 1)
		lastvweaponframe = 20;
	if (self.randomattack == 2)
		lastvweaponframe = 40;
	if (self.randomattack == 3)
		lastvweaponframe = 60;
	if (self.randomattack == 4)
		lastvweaponframe = 80;

	if (self.vweaponframe >= lastvweaponframe)
	{
		self.think = v_vmodel_idle;
	}
	else
		self.think = w_vmodel_slash2;
	self.nextthink = time + 0.05;
};

void() w_vmodel_slash1 = 
{
	self.oldrandomattack = self.randomattack;

	if (self.randomattack == 1)
		self.vweaponframe = 1;
	if (self.randomattack == 2)
		self.vweaponframe = 21;
	if (self.randomattack == 3)
		self.vweaponframe = 41;
	if (self.randomattack == 4)
		self.vweaponframe = 61;
	self.think = w_vmodel_slash2;
	self.nextthink = time + 0.05;

};

void() w_vmodel_slash = 
{
	local float r;

	r = random();

	if (r > 0.75)
		self.randomattack = 1;
	else if (r > 0.5)
		self.randomattack = 2;
	else if (r > 0.25)
		self.randomattack = 3;
	else
		self.randomattack = 4;

	if (self.oldrandomattack == self.randomattack)
		self.randomattack += 1;

	if (self.randomattack > 4)
		self.randomattack = 1;

	self.think = w_vmodel_slash1;
	self.nextthink = time;
};

void() raise_vmodel = 
{
	self.weapon = IT_VIEWMODEL;
	self.vweaponskin = 0;
	self.vweaponglowmod = '0 0 0';
	setmodel(self.vweapon, self.vvweapon_model);
	self.vweapon.scale = self.vvweapon_scale;
	self.vweapon.origin_x = self.vvweapon_x;
	self.vweapon.origin_y = self.vvweapon_y;
	self.vweapon.origin_z = self.vvweapon_z;
	self.vweapon.angles = self.vvweaponangles;
	self.vweapon.origin_z = self.vvweapon_z;
	self.attack_finished = time + 0.05;
	W_SetWeapon();
};

///////////////////////////////////end of qc file