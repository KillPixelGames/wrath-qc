
.float randomattack;
.float oldrandomattack;

void() idle_lance = 
{ 
	if (self.pick_up_time < time)
		self.vweaponstate = 0;
	self.vweaponstate = 0;
	self.vweaponframe = 0;

};
.float spawnedlance;
.float beam_lenght;

.entity lastbeam;
.float beam_counter;

.entity lastbeam_view;
.float beam_counter_view;

void(entity e)sub_beam;
void() beam_update;

void(entity e)sub_beam =
{

};

void() beam_update_view =
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
			beam.classname = "lancebeam_view";
			beam.owner = self.owner;
			setmodel (beam,"models/projectiles/proj_beam.md3");
			beam.lastbeam_view = self.owner.lastbeam_view;
			self.owner.lastbeam_view = beam;
			setattachment (beam,self,"tag_nextbeam");
			beam.nextthink = time; 
			beam.alpha = 1;
			beam.think = beam_update_view;
		}
		
	}		
	if(!self.owner.spawnedlance)
		self.think = alphafade3;
	else
		self.think = beam_update_view;	
	self.nextthink = time + 0.0125; 
};


//self.cursor_trace_endpos

void(entity e) te_lance2 =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam_view = beam;
	//self.beam_counter = -1;
	setmodel (beam,"models/weapons/lance/v_beam.md3");
	setattachment (beam,e.vweapon,"tag_muzzle");
	beam.nextthink = time;
	beam.alpha = 1;
	beam.think = beam_update_view;

};
void() beam_update =
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
			beam.classname = "lancebeam";
			beam.exteriormodeltoclient = self.owner;
			beam.owner = self.owner;
			setmodel (beam,"models/projectiles/proj_beam.md3");
			beam.lastbeam = self.owner.lastbeam;
			self.owner.lastbeam = beam;
			setattachment (beam,self,"tag_nextbeam");
			beam.nextthink = time; 
			beam.alpha = 1;
			beam.think = beam_update;
		}
		
	}		
	if(!self.owner.spawnedlance)
		self.think = alphafade3;
	else
		self.think = beam_update;	
	self.nextthink = time + 0.0125; 
};


//self.cursor_trace_endpos

void(entity e) te_lance =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam = beam;
	//self.beam_counter = -1;
	setmodel (beam,"models/projectiles/proj_beam.md3");
	setattachment (beam,e,"tag_muzzle");
	beam.nextthink = time;
	beam.exteriormodeltoclient = beam.owner;
	beam.alpha = 1;
	beam.think = beam_update;

};
float(entity targ, float dist) visibleinfront;
float(entity targ, float dist, float drange) visible2;
.float oldspeed;

.float beamtime;
.float lance_secondary;
.float oldlifetime;


void() lance_muzzle_think =
{

	self.frame ++;
	self.alpha -= 0.1;
	if(self.alpha <= 0)
	{
	self.alpha = -1;
	remove(self);
	return;
	}
	self.think = lance_muzzle_think;
	self.nextthink = time + 0.033333;
};


void()prebacktonormal =
{
self.nextthink = time + 0.1;
self.solid = SOLID_SLIDEBOX;
self.think = backtonormal;
}
void() field_shockwave_touch = 
{
if( (other.classname == "breakable_urn_large") || (other.classname == "breakable_urn_medium") || (other.classname == "breakable_urn_small") || (other.classname == "func_destruct"))
{
T_Damage(other, self, self, 220);	// its damage
T_Damage(self.owner, self, self, 2);	// its damage
}
}
void()follow_head = 
{
	if(vlen(self.origin - self.owner.origin) > 16)
	setorigin (self, self.owner.origin);

	if(self.lifetime > time)
	self.think = follow_head;
	else
	self.think = SUB_Remove;
	
	self.nextthink = time + 0.05;

}
.entity field_point;


void() projectile_fix_angles =
{

	self.think = self.oldthink;
	self.nextthink = time + 0.05;
}
void() projectile_redirect =
{

	self.viewmodelforclient = world;
	self.effects -= EF_NODRAW;
	makevectors (self.owner.v_angle);
	self.lifetime = time + self.oldlifetime;	
	self.movetype = self.oldmovetype;
	self.solid = self.oldsolid;
	vector dir = normalize(cursor_trace_endpos_forced (self.owner) - self.origin);
	self.velocity = dir * self.oldspeed;	
	self.v_angle = '0 0 0';
	self.angles = '0 0 0';
	self.angles = self.owner.v_angle;
	self.think = self.oldthink;
	self.nextthink = time + 0.05;

};
.float x_relativeorigin;
.float x_relativeoriginold;

void() check_newprojectile =
{
//self.movetype = MOVETYPE_FOLLOW;


if(self.owner.button3)
	self.think = check_newprojectile;
else
{	
	self.think = projectile_redirect;
}
self.nextthink = time + 0.05;
}


void() check_button3 =
{
//self.movetype = MOVETYPE_FOLLOW;


if(self.owner.fieldcreated != 1)
	self.think = SUB_Remove;
else
	self.think = check_button3;

self.nextthink = time + 0.05;
}
void()projectile_touch_str2;
void() projectile_field_touch =
{


		if((other.owner!= self.owner) && (other.wrathflags & FL_PROJECTILE))
		{

		makevectors2(self.owner.angles);
		vector vec = normalize(other.origin - self.owner.origin + self.owner.view_ofs);
		float dot = vec * v_forward;
		if (dot < 0.39)
		{
			other.wrathflags -=FL_PROJECTILE;
			return;
		}


		if(other.owner.classname == "monster_stricken")
		{
		other.touch = cyst_touch;
		other.enemy = world;
		other.scale = 1;
		other.oldsolid = SOLID_BBOX;
		other.think = SUB_Null;
		}
		other.owner = self.owner;
		float speed = vlen(other.velocity);
		other.oldspeed = speed;
		other.velocity = '0 0 0';
		other.oldmovetype = other.movetype;
		other.oldsolid = other.solid;
		other.oldlifetime = time - other.lifetime;
		other.oldorigin = other.origin;

		other.movetype = MOVETYPE_FOLLOW;
		other.aiment = self.owner;

		other.lifetime = self.lifetime;
		//other.movetype = MOVETYPE_FOLLOW; // make the other follow
		other.solid = SOLID_NOT; // MOVETYPE_FOLLOW is always non-solid
		other.aiment = self.owner; // make the other follow self.owner
		
		other.punchangle = self.owner.angles; // the original angles of self.owner
		other.view_ofs = other.origin - self.owner.origin; // relative origin
		other.v_angle = other.angles - self.owner.angles; // relative angles
//		other.x_relativeoriginold = self.owner.v_angle_x;


		other.oldthink = other.think;
		other.effects += EF_NODRAW;
		other.think = check_newprojectile;
		other.nextthink = time + 0.05;
		entity onscreencopy = spawn();
		copyentity(other,onscreencopy);
		onscreencopy.effects -= EF_NODRAW;
		onscreencopy.aiment = self.owner.field_point; // make the other follow self.owner
		onscreencopy.viewmodelforclient = self.owner;	
		onscreencopy.origin_x =onscreencopy.origin_x * 1.25;
		onscreencopy.origin_y =onscreencopy.origin_y * 1.25;
		onscreencopy.origin_z =onscreencopy.origin_z * 1.25;		
		onscreencopy.alpha = 0.5;
		onscreencopy.solid = SOLID_NOT;
		onscreencopy.touch = SUB_Null;
		onscreencopy.nextthink = time + 0.05;
		onscreencopy.think = check_button3;
		//other.velocity = normalize(cursor_trace_endpos_fixed (self.owner) - other.origin) *speed;	
		/*other.velocity = other.velocity * -1; 	
		other.velocity_x += random(-25,25); 
		other.velocity_y += random(-25,25);
		other.velocity_z += random(-25,25);*/
		}
}

void()check_projectile_field =
{
	setorigin (self, self.owner.origin);
	if(self.owner.button3)
	self.think = check_projectile_field;
	else
	self.think = SUB_Remove;
	
	self.nextthink = time + 0.05;

}
void()lance_premuzzle_think =
{
	if(self.owner.button3)
	self.think = lance_premuzzle_think;
	else
	self.think = lance_muzzle_think;
	
	self.nextthink = time + 0.05;

}

.float fieldcreated;
void() wsfire_lance =
{
if((self.button3) && (self.fieldcreated != 1))
{
	self.fieldcreated = 1;
	string muzzlemodel = "models/weapons/lance/v_flash.md3";
	entity muzzle = spawn();
	muzzle.owner = self;
	setmodel(muzzle, muzzlemodel);
	muzzle.viewmodelforclient = self;
	muzzle.alpha = 1;
	setattachment(muzzle, self.vweapon, "tag_muzzle2");
	muzzle.think = lance_premuzzle_think;
	muzzle.nextthink = time + 0.05;
	muzzle.alpha = 0.5;
	makevectors(self.v_angle);
	entity fieldpoint =spawn();
	fieldpoint.effects = 128;
	fieldpoint.viewmodelforclient = self;
	self.field_point =fieldpoint;
	setmodel(fieldpoint,"");
	setorigin(fieldpoint, '32 0 -20');


	entity projectile_field = spawn();
	setsize (projectile_field, '-128 -128 -32','128 128 32');
	projectile_field.owner = self;		
	projectile_field.solid =SOLID_TRIGGER;		
	projectile_field.origin = self.origin;
	projectile_field.touch = projectile_field_touch;
	projectile_field.think = check_projectile_field;
	projectile_field.nextthink = time; 
}
	


};

void() ws_release_fire =
{
	sound7(self,CHAN_WEAPON,"weapons/lance/fire1.ogg",1,0.25,50,0);
	self.attack_finished = time + 0.25;
	entity head = findradius(self.origin, 512);
	remove(self.field_point);
	while (head)
	{

/*	//checkpvs(vector viewpos, entity viewee) 
		if((head.owner!= self) && (head.wrathflags & FL_PROJECTILE)&&(checkpvs(self.view_ofs,head)))
		{
		head.owner = self;
		head.velocity = head.velocity * -1; 	
		}*/


		if (head.wrathflags & FL_GIB)
		{
		explo_physics_gibs (self,head,150,3); 	
		}
		if ((head.flags & FL_MONSTER) && (head.health > 0)&& (head.timepushing < time)&&(visible2(head,256, 0.5))) 
		{
		if (!head.oldmovetype)
			head.oldmovetype = head.movetype;
		head.movetype = MOVETYPE_TOSS;
		head.timepushing = time + 0.7;
		head.gravity = 0.15;
		if (head.flags &FL_ONGROUND)
			head.flags -= FL_ONGROUND;
		head.solid = SOLID_CORPSE;
		head.backedtonormal = 0;
		vector z_vel;
		if(head.velocity_z <0)
		z_vel_z =130;
		else
		z_vel_z =90;
		head.velocity = v_forward * 512 + z_vel;
		head.oldthink = head.think;

		entity field = spawn();
		entity oself = self;
		self = head;
		setsize (field, self.mins - '8 8 8', self.maxs + '8 8 8'); 
		self =  oself;
		field.origin = head.origin;
		field.touch = field_shockwave_touch;	
		field.owner = head;
		field.solid =SOLID_TRIGGER;
		field.movetype = MOVETYPE_TOSS;
		field.velocity = head.velocity;
		field.think = follow_head;
		field.lifetime = time + 0.5;
		field.nextthink = time + 0.05;
		head.think = prebacktonormal;
		head.nextthink = time + 0.05;



		}
		head = head.chain;  // cycle to next head (entity)
	}
}
void() wsfire_lance2 =
{
	if((self.button3))
	{
		if(self.beamtime < time)
		{
			vector tagorg = tag_origin("tag_muzzle",self.vweapon);
			makevectors(self.v_angle);
			vector t_dest = self.origin + self.view_ofs + v_forward *2048;
			wtraceline(tagorg, t_dest, FALSE, self);
			vector direction = aim(self, 100000);
			self.lance_secondary = 1;
			if (trace_fraction != 1.0)
			TraceAttack(self.lance_damage2, direction);
				ApplyMultiDamage();
			traceline(tagorg, t_dest, MOVE_WORLDONLY, self);	
			self.beam_lenght = vlen (tagorg - trace_endpos) / 64;
			if(self.beam_lenght > 64)
				self.beam_lenght = 64;					
			self.beamtime = time +self.lance_time2;
			if(!self.spawnedlance)
			{	
				self.beam_counter = 0;
				self.beam_counter_view = 0;
				te_lance(self);
				te_lance2(self);
				self.spawnedlance = 1;
			}
		}
		self.think = wsfire_lance;
	self.lance_viewzoom_time = time +0.1;
	}
	else
	{	
		self.spawnedlance = 0;	
		self.think = idle_lance;
	}
	self.nextthink = time + 0.01;
};

/*
void(entity e) railgun_spawner =
{
	local entity beam;
	beam = spawn();
	beam.classname = "lancebeam_view";
	beam.owner = e;
	setmodel (beam,"models/weapons/lance/railb.md3");
	setattachment (beam,e.lastbeam,"tag_nextbeam");
	e.lastbeam = beam;
	beam.alpha = 1;
	beam.think = alphafade3;
	beam.nextthink = time + 1; 
}
void(entity e) te_railgun =
{
	local entity beam;
	beam = spawn();
	beam.owner = e;
	e.lastbeam = beam;
	if(self.owner.beam_lenght <= 1)
		setmodel (beam,"models/weapons/lance/raila.md3");
	else
		setmodel (beam,"models/weapons/lance/railb.md3");
	setattachment (beam,e.vweapon,"tag_muzzle");
	beam.alpha = 1;
	beam.think = alphafade3;
	beam.nextthink = time + 1;
	float loop_lenght;
	loop_lenght = self.owner.beam_lenght;
	while(loop_lenght > 1)
	{
		railgun_spawner(e);
		loop_lenght --;
	}
};
*/

void(entity e, float beamlenght) sub_railgun =
{
	local entity beam;

	beam = spawn();
	//if( beamlenght > 0)
		setmodel(beam, "models/projectiles/proj_railb.md3");
	//else
	//	setmodel(beam, "models/projectiles/proj_raila.md3");
	setattachment(beam, e.lastbeam, "tag_nextbeam");
	beam.nextthink = (time + 0.05);
	beam.alpha = 1;
	beam.alphatime = e.lance_alpha_time;
	e.lastbeam = beam;
	beam.think = alphafade;
};

void(entity e, vector tagorg, vector tangles) te_railgun =
{
	local entity beam;
	local float beamlenght;

	beam = spawn();
	self.owner = e;
	e.lastbeam = beam;
	//if(self.owner.beam_lenght <= 1)
		setmodel (beam,"models/projectiles/proj_raila.md3");
	//else
	//	setmodel (models/projectiles/proj_railb.md3");
	beam.origin = tagorg;
	beam.angles = tangles;
	//beam.effects = EF_NODEPTHTEST;
	//setattachment(beam, e.vweapon, "tag_muzzle");
	beam.beam_lenght = (e.beam_lenght - TRUE);
	beam.nextthink = (time + 0.05);
	beam.alpha = 1;
	beam.alphatime = e.lance_alpha_time;
	beam.think = alphafade;
	beamlenght = beam.beam_lenght;
	while ((beamlenght > 0))
	{
		beamlenght --;
		sub_railgun(e, beamlenght);
	}
};
void()trail_remove =
{
	if(other != world)
		return;
	else 
		remove(self);
}
void() wfire_lance =
{
	vector tagorg = tag_origin("tag_muzzle",self.vweapon);
	makevectors(self.v_angle);
	vector t_dest = self.origin + self.view_ofs + v_forward *8192;
	if(self.clipgroup != 0)
	{
		self.oldclipgroup = self.clipgroup;
		self.clipgroup = 0;
	}
	wtraceline(tagorg, t_dest, FALSE, self);
	vector direction = aim(self, 100000);
	self.lance_secondary = 0;
	if (trace_fraction != 1.0)
		TraceAttack(self.lance_damage, direction);
	ApplyMultiDamage();
	self.beam_lenght = vlen (tagorg - trace_endpos) / 64;
	if(self.beam_lenght > 64)
		self.beam_lenght = 64;		
	self.vweaponframe = 2;
	self.beam_counter = 0;
	self.beam_counter_view = 0;

	traceline(tagorg, t_dest, MOVE_WORLDONLY, self);
	sound(self,CHAN_WEAPON,"weapons/lance/fire1.ogg",1,0.25);
	vector dir = normalize(trace_endpos - tagorg);
	vector teangles = vectoangles(dir);	
	te_railgun(self, tagorg, teangles);
	//te_railgun2(self);
	self.think = idle_lance;
	self.nextthink = time + 1;
	self.attack_finished = time + self.lance_time + 0.05;
	self.ammo_lance --;
	entity trail = spawn();
	trail.movetype = MOVETYPE_FLY;
	setorigin(trail, tagorg);
	setmodel(trail, "models/misc/null.md3");
	trail.velocity = dir *12000;
	trail.solid = SOLID_CORPSE;
	trail.traileffectnum = particleeffectnum("rail_trail");
	trail.touch = trail_remove;
	trail.think = SUB_Remove;
	trail.nextthink = time + 1;
	string muzzlemodel = "models/weapons/lance/v_flash.md3";
	entity muzzle = spawn();
	muzzle.owner = self;
	setmodel(muzzle, muzzlemodel);
	muzzle.viewmodelforclient = self;
	muzzle.alpha = 1;
	setattachment(muzzle, self.vweapon, "tag_muzzle2");
	muzzle.think = lance_muzzle_think;
	muzzle.nextthink = time + 0.05;
	self.clipgroup = self.oldclipgroup;
};


void() lower_lance2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe >= 12)
		self.think = raise_weapon;
	else
		self.think = lower_lance2;
	self.nextthink = time + 0.025;
};

void() lower_lance = 
{
	self.vweaponframe = 8;
	self.attack_finished = time + 0.25;
	self.think = lower_lance2;
	self.nextthink = time + 0.025;
};

void() raise_lance2 = 
{
	self.vweaponframe += 1;
	if (self.vweaponframe == 5)
		W_SetWeapon();

	if (self.vweaponframe >= 7)
	{
		self.think = idle_lance;
	}
	else
		self.think = raise_lance2;
	self.nextthink = time + 0.025;
};

void() raise_lance = 
{
	self.weapon = IT_LANCE;
	W_SetWeapon();
	sound(self, CHAN_AUTO, "weapons/lance/raise.ogg", 1, ATTN_NORM);
	self.vweaponglowmod = '1 1 1';
	self.draw_w = 0;
	self.vweaponglowmod = '1 1 1';
	self.vweaponframe = 3;
	self.vweaponstate = 1;
	self.attack_finished = time + 0.125;
	self.think = raise_lance2;
	self.nextthink = time;
};
void() pick_up_lance2 = 
{
	self.think = idle_lance;
	self.pick_up_time = time + 0.5;
	self.vweaponstate = 1;
	self.nextthink = time + 0.05;
};

void() pick_up_lance = 
{
	self.lastweapon = IT_LANCE;
	self.weapon = IT_LANCE;
	sound(self, CHAN_WEAPON, "weapons/lance/inspect.ogg", 1, ATTN_NORM);
	W_SetWeapon();
	self.draw_w = 0;
	self.vweaponglowmod = '1 1 1';
	self.vweaponstate = 2; // hud state
	if (self.noltime < time)
		self.lspeedtime = time + 5;
	self.vweaponframe = 1;
	self.attack_finished = time + 0.05;
	self.think = pick_up_lance2;
	self.nextthink = time + 5.95;
}

///////////////////////////////////end of qc file
