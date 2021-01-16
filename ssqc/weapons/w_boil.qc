
.float randomattack;
.float oldrandomattack;

void() idle_boil = 
{ 
	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	self.vweaponstate = 0;
	self.vweaponframe = 0;

};
.float spawnedboil;
.float beam_lenght;

.entity lastbeam;
.float beam_counter;

.entity lastbeam_view;
.float beam_counter_view;

void(entity e)sub_beam2;
void() beam_update2;

void(entity e)sub_beam2 =
{

};
.void()oldth_stand;
.void()oldth_walk;
.void()oldth_run;
.void()oldth_missile;
.void()oldth_melee;
.void()oldth_pain;
.float oldflags;
.float old2movetype;
.string oldclassname;
.string oldclassentity;




void() beam_update2_view =
{
	if(self == self.owner.lastbeam_view)
	{
		if(self.owner.beam_counter_view > ((self.owner.beam_lenght / 2) + 1))
		{
			self.owner.beam_counter_view --;
			self.owner.lastbeam_view = self.lastbeam_view;
			remove(self);
			return;
		}
		if(self.owner.beam_counter_view < (self.owner.beam_lenght / 2))
		{
			self.owner.beam_counter_view ++;
			local entity beam;
			beam = spawn();
			beam.classname = "boilbeam_view";
			beam.owner = self.owner;
			beam.colormod = '0.5 0.5 0.5';
			setmodel (beam,"models/projectiles/proj_boil.md3");
			beam.traileffectnum = particleeffectnum("NORMAL_BLOOD2");
			beam.lastbeam_view = self.owner.lastbeam_view;
			self.owner.lastbeam_view = beam;
			setattachment (beam,self,"tag_nextbeam");
			beam.nextthink = time; 
			beam.alpha = 1;
			beam.think = beam_update2_view;
		}
		
	}		
	if(!self.owner.spawnedboil)
		self.think = alphafade3;
	else
		self.think = beam_update2_view;	
	self.nextthink = time + 0.0125; 
};


//self.cursor_trace_endpos

void(entity e) te_boil2 =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam_view = beam;
	//self.beam_counter = -1;
	setmodel (beam,"models/weapons/boil/v_beam.md3");
	setattachment (beam,e.vweapon,"tag_muzzle");
	beam.nextthink = time;
	beam.traileffectnum = particleeffectnum("NORMAL_BLOOD2");
	beam.colormod = '0.5 0.5 0.5';
	beam.alpha = 1;
	beam.think = beam_update2_view;

};
void() beam_update2 =
{
	if(self == self.owner.lastbeam)
	{
		if(self.owner.beam_counter > (self.owner.beam_lenght + 1))
		{
			self.owner.beam_counter --;
			self.owner.lastbeam = self.lastbeam;
			remove(self);
			return;
		}
		if(self.owner.beam_counter < self.owner.beam_lenght)
		{
			self.owner.beam_counter ++;
			local entity beam;
			beam = spawn();
			beam.colormod = '0.5 0.5 0.5';
			beam.classname = "boilbeam";
			beam.exteriormodeltoclient = self.owner;
			beam.owner = self.owner;
			setmodel (beam,"models/projectiles/proj_boil.md3");
			beam.traileffectnum = particleeffectnum("NORMAL_BLOOD2");
			beam.lastbeam = self.owner.lastbeam;
			self.owner.lastbeam = beam;
			setattachment (beam,self,"tag_nextbeam");
			beam.nextthink = time; 
			beam.alpha = 1;
			beam.think = beam_update2;
		}
		
	}		
	if(!self.owner.spawnedboil)
		self.think = alphafade3;
	else
		self.think = beam_update2;	
	self.nextthink = time + 0.0125; 
};


//self.cursor_trace_endpos

void(entity e) te_boil =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam = beam;
	//self.beam_counter = -1;
	setmodel (beam,"models/projectiles/proj_boil.md3");
	setattachment (beam,e,"tag_muzzle");
	beam.traileffectnum = particleeffectnum("NORMAL_BLOOD2");
	beam.nextthink = time;
	beam.colormod = '0.5 0.5 0.5';
	beam.exteriormodeltoclient = beam.owner;
	beam.alpha = 1;
	beam.think = beam_update2;

};

.float beamtime;
.float boil_secondary;
void() boil_muzzle_think =
{

	self.frame ++;
	self.alpha -= 0.1;
	if(self.alpha == 0)
	self.alpha = -1;
	if(self.alpha > 0) 
		self.think = boil_muzzle_think;
	else
		self.think = SUB_Remove;
	self.nextthink = time + 0.033333;
};

void()trail_remove2;
void()check_owner_button =
{
	if(!(self.owner.button0))
	remove(self);
	if(self.oldorigin != self.owner.origin)
	remove(self);
	if(self.owner.v_angle != self.angles)
	remove(self);
	if(self.lifetime < time)
	self.think = SUB_Remove;
	else	
	self.think = check_owner_button;
	self.nextthink = time + 0.05;
}

void  (entity e,vector tagorg) bloodparticles_beam =
{
//void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlesnow = #410;
//org = self.origin;	
	makevectors(e.v_angle);
	vector t_dest = tagorg + v_forward *4096;
	traceline(tagorg, t_dest, MOVE_WORLDONLY, self);
	vector dir = normalize(trace_endpos - tagorg);
	vector teangles = vectoangles(dir);	
	entity trail = spawn();
	trail.movetype = MOVETYPE_FLY;
	setorigin(trail, tagorg);
	setmodel(trail, "models/misc/null.md3");
	trail.velocity = dir *2500;
	trail.solid = SOLID_CORPSE;
	trail.traileffectnum = particleeffectnum("boil_blood_trail");
	trail.owner = e;
	trail.angles = e.v_angle;
	trail.oldorigin = e.origin;
	trail.touch = trail_remove2;
	trail.think = check_owner_button;
	trail.nextthink = time + 0.05;
	trail.lifetime = time + 1;
}


void  (entity e,vector org, vector dest) bloodparticles_beam2 =
{
//void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlesnow = #410;

	vector dir = normalize(dest - org);
	entity trail = spawn();
	trail.movetype = MOVETYPE_FLY;
	setorigin(trail, org);
	setmodel(trail, "models/misc/null.md3");
	trail.velocity = dir *2500;
	trail.solid = SOLID_CORPSE;
	trail.traileffectnum = particleeffectnum("boil_blood_trail");
	trail.owner = e;
	trail.angles = e.v_angle;
	trail.oldorigin = e.origin;
	trail.touch = trail_remove2;
	trail.think = SUB_Remove;
	trail.lifetime = time + 1;
}


void() wfire_boil =
{
	if((self.button0))
	{
		if(self.beamtime < time)
		{
			vector tagorg = tag_origin("tag_muzzle",self.vweapon);
			bloodparticles_beam(self,tagorg);
			makevectors(self.v_angle);
			vector t_dest = self.origin + self.view_ofs + v_forward *2048;
			wtraceline(tagorg, t_dest, FALSE, self);
			vector direction = aim(self, 100000);
			self.boil_secondary = 1;
			if (trace_fraction != 1.0)
			TraceAttack(5, direction);
				ApplyMultiDamage();
			traceline(tagorg, t_dest, MOVE_WORLDONLY, self);	
			self.beam_lenght = vlen (tagorg - trace_endpos) / 64;
			if(self.beam_lenght > 64)
				self.beam_lenght = 64;					
			self.beamtime = time + 0.1;
				//void(vector mincorner, vector maxcorner, vector vel, float howmany, float color) te_particlesnow = #410;

			
			if(!self.spawnedboil)
			{	
				self.beam_counter = 0;
				self.beam_counter_view = 0;
				te_boil(self);
				te_boil2(self);
				self.spawnedboil = 1;
			}
			
		}
		self.think = wfire_boil;
	//self.boil_viewzoom_time = time +0.1;
	}
	else
	{	
		self.spawnedboil = 0;	
		self.think = idle_boil;
	}
	self.nextthink = time + 0.01;
};

/*
void(entity e) beamboil_spawner =
{
	local entity beam;
	beam = spawn();
	beam.classname = "boilbeam_view";
	beam.owner = e;
	setmodel (beam,"models/weapons/boil/railb.md3");
	setattachment (beam,e.lastbeam,"tag_nextbeam");
	e.lastbeam = beam;
	beam.alpha = 1;
	beam.think = alphafade3;
	beam.nextthink = time + 1; 
}
void(entity e) te_beamboil =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam = beam;
	if(self.owner.beam_lenght <= 1)
		setmodel (beam,"models/weapons/boil/raila.md3");
	else
		setmodel (beam,"models/weapons/boil/railb.md3");
	setattachment (beam,e.vweapon,"tag_muzzle");
	beam.alpha = 1;
	beam.think = alphafade3;
	beam.nextthink = time + 1;
	float loop_lenght;
	loop_lenght = self.owner.beam_lenght;
	while(loop_lenght > 1)
	{
		beamboil_spawner(e);
		loop_lenght --;
	}
};
*/
void(entity e, float beamlenght) sub_beam2boil =
{
	local entity beam;

	beam = spawn();
	//if( beamlenght > 0)
		setmodel(beam, "models/projectiles/proj_boilb.md3");
	//else
	//	setmodel(beam, "models/projectiles/proj_raila.md3");
	beam.traileffectnum = particleeffectnum("NORMAL_BLOOD2");
	setattachment(beam, e.lastbeam, "tag_nextbeam");
	beam.nextthink = (time + 0.05);
	beam.alpha = 1;
	beam.alphatime = 1;
	e.lastbeam = beam;
	beam.think = alphafade;
};

void(entity e, vector tagorg, vector tangles) te_beamboil =
{
	local entity beam;
	local float beamlenght;

	beam = spawn();
	self.owner = e;
	e.lastbeam = beam;
	//if(self.owner.beam_lenght <= 1)
		setmodel (beam,"models/projectiles/proj_boila.md3");
	//else
	//	setmodel (models/projectiles/proj_railb.md3");
	beam.origin = tagorg;
	beam.angles = tangles;
	//beam.effects = EF_NODEPTHTEST;
	//setattachment(beam, e.vweapon, "tag_muzzle");
	beam.beam_lenght = (e.beam_lenght - TRUE);
	beam.nextthink = (time + 0.05);
	beam.alpha = 1;
	beam.traileffectnum = particleeffectnum("NORMAL_BLOOD2");
	beam.alphatime = 1;
	beam.think = alphafade;
	beamlenght = beam.beam_lenght;
	while ((beamlenght > 0))
	{
		beamlenght --;
		sub_beam2boil(e, beamlenght);
	}
};
void()trail_remove2 =
{
	if(other == self.owner)
		return;
	else 
		remove(self);
}

void() fade_mark =
{
setmodel (self, "models/warp/warp.md3");
self.alpha -= 0.025;

if(self.alpha <= 0)
{
self.alpha = -1;
remove(self);
}
self.think = fade_mark;
self.nextthink = time + 0.05;

}
void()flamedissapear =
{
self.light_lev -= 0.48;

if(self.light_lev < 1)
{
self.scale = 0.25;
self.think = fade_mark;
self.alpha = 1;
}
else
self.think = flamedissapear;
self.nextthink = time + 0.05;

}


void()telefrag_touch =
{
if(other.classname == "player")
T_Damage (self, other, other, 50000);
if(other.flags & FL_MONSTER)
T_Damage (other, self, self, 50000);


}

void() monster_appear =
{
		self.movetype = self.old2movetype;

		self.solid = self.oldsolid;
		self.classentity = self.oldclassentity;
		self.th_stand = self.oldth_stand;
		self.th_walk = self.oldth_walk;
		self.th_run = self.oldth_run;
		self.th_missile = self.oldth_missile;
		self.th_melee = self.oldth_melee;
		self.th_pain = self.oldth_pain;

		self.touch = self.oldtouch;
		self.nextthink = time + 0.1;
		self.think = self.oldthink;
};

void() monster_preappear =
{
self.flags = self.oldflags;
self.alpha = 1;
self.classentity = self.oldclassentity;
self.classname = self.oldclassname;
self.takedamage = DAMAGE_YES;
self.solid = SOLID_TRIGGER;
self.oldtouch = self.touch;
self.touch = telefrag_touch;
self.think = monster_appear;
self.nextthink = time;
}


void() monster_goodbye = 
{
	self.alpha += 0.0045;
	if(self.alpha >= 1)
	{
		self.alpha = 1;
		self.think = monster_preappear;
	}
	else
		self.think = monster_goodbye;
	self.nextthink = time + 0.05;
};

void() wsfire_boil =
{

	vector tagorg = tag_origin("tag_muzzle",self.vweapon);
	makevectors(self.v_angle);
	vector t_dest = self.origin + self.view_ofs + v_forward *4096;
	wtraceline(tagorg, t_dest, FALSE, self);
	vector direction = aim(self, 100000);
	self.boil_secondary = 0;
	//		TraceAttack(10, direction);
	//	ApplyMultiDamage();
	if ((trace_fraction != 1.0) && (trace_ent.flags & FL_MONSTER) && (trace_ent.takedamage))
	{
		entity oself = self;
		self =trace_ent;
		self.oldth_stand = self.th_stand;
		self.oldth_walk = self.th_walk;
		self.oldth_run = self.th_run;
		self.oldth_missile = self.th_missile;
		self.oldth_melee = self.th_melee;
		self.oldth_pain = self.th_pain;
		self.oldsolid = self.solid;
		self.oldclassname = self.classname;
		self.old2movetype = self.movetype; // dont change oldmovetype!!
		self.oldflags = self.flags;
		self.classentity = self.classentity;
		self.classname = "secondplane";
		self.movetype = 0;
		self.oldthink = self.think;
		self.takedamage = 0;
		self.solid = 0;
		self.flags = 0;
		self.classentity = "corpse";
		self.th_stand = null;
		self.th_walk = null;
		self.th_run = null;
		self.th_missile = null;
		self.th_melee = null;
		self.th_pain = nullpain; // th_pain has two arguments 
		self.alpha = 0.1;
		self.think = monster_goodbye;
		self.nextthink = time;
		entity flame = spawn();
		flame.origin = self.origin;
		flame.scale = 0.75;
//		setmodel(flame,"models/artifacts/soul_marker.md3");
		setmodel(flame,"");
		flame.colormod = '1 0 0';
		flame.color = '2 0 0';
		flame.pflags = 129;
		flame.light_lev = 96;
		flame.traileffectnum = particleeffectnum("boil_blood_trail");
		flame.think = flamedissapear;
		flame.nextthink = time;
		self = oself;
	}
	self.beam_lenght = vlen (tagorg - trace_endpos) / 64;
	if(self.beam_lenght > 64)
		self.beam_lenght = 64;		
	self.vweaponframe = 2;
	self.beam_counter = 0;
	self.beam_counter_view = 0;

	traceline(tagorg, t_dest, MOVE_WORLDONLY, self);
	sound(self,CHAN_WEAPON,"weapons/boil/fire1.ogg",1,0.25);
	vector dir = normalize(trace_endpos - tagorg);
	vector teangles = vectoangles(dir);	
	te_beamboil(self, tagorg, teangles);
	//te_beamboil2(self);
	self.think = idle_boil;
	self.nextthink = time + 1;
	self.attack_finished = time + 0.05;
	self.ammo_boil --;
	entity trail = spawn();
	trail.movetype = MOVETYPE_FLY;
	setorigin(trail, tagorg);
	setmodel(trail, "models/misc/null.md3");
	trail.velocity = dir *12000;
	trail.solid = SOLID_CORPSE;
	trail.traileffectnum = particleeffectnum("rail_trail");
	trail.touch = trail_remove2;
	trail.think = SUB_Remove;
	trail.nextthink = time + 1;
	string muzzlemodel = "models/weapons/lance/v_flash.md3";
	entity muzzle = spawn();
	muzzle.owner = self;
	setmodel(muzzle, muzzlemodel);
	muzzle.viewmodelforclient = self;
	muzzle.alpha = 1;
	muzzle.colormod = '1 0 0';
	muzzle.scale = 0.5;
	setattachment(muzzle, self.vweapon, "tag_muzzle2");
	muzzle.think = boil_muzzle_think;
	muzzle.nextthink = time + 0.05;

};


void() lower_boil2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 12)
		self.think = raise_weapon;
	else
		self.think = lower_boil2;
	self.nextthink = time + 0.025;
};

void() lower_boil = 
{
	self.vweaponframe = 8;
	self.attack_finished = time + 0.25;
	self.think = lower_boil2;
	self.nextthink = time + 0.025;
};

void() raise_boil2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 5)
		W_SetWeapon();

	if (self.vweaponframe >= 7)
	{
		self.think = idle_boil;
	}
	else
		self.think = raise_boil2;
	self.nextthink = time + 0.025;
};

void() raise_boil = 
{
	self.weapon = IT_BOIL;
	W_SetWeapon();
	sound(self, CHAN_AUTO, "weapons/boil/raise.ogg", 1, ATTN_NORM);
	self.vweaponglowmod = '1 1 1';
	self.draw_w = 0;
	self.vweaponglowmod = '1 1 1';
	self.vweaponframe = 3;
	self.vweaponstate = 1;
	self.attack_finished = time + 0.125;
	self.think = raise_boil2;
	self.nextthink = time;
};
void() pick_up_boil2 = 
{
	self.think = idle_boil;
	self.pick_up_time = time + 0.5;
	self.vweaponstate = 1;
	self.nextthink = time + 0.05;
};

void() pick_up_boil = 
{
	self.lastweapon = IT_BOIL;
	self.weapon = IT_BOIL;
	sound(self, CHAN_WEAPON, "weapons/boil/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponglowmod = '1 1 1';
	self.vweaponstate = 2; // hud state
	if (self.noltime < time)
		self.lspeedtime = time + 5;
	self.vweaponframe = 1;
	self.attack_finished = time + 0.05;
	self.think = pick_up_boil2;
	self.nextthink = time + 5.95;
}

///////////////////////////////////end of qc file


///////////////////////////////////end of qc file