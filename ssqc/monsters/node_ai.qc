

.entity follow_path;
.float followingapath;
.vector nextnode;
.float node_touch;

void() spawn_follow_path_remove =
{
	if (nodegraph_query_is_valid(self.owner.nodegraph_query_id))
		nodegraph_query_release(self.owner.nodegraph_query_id);	
	self.owner.followingapath = 0;
	remove(self);
}
void() spawn_follow_path_touch =
{
	if(other != self.owner)
	return;
	if (nodegraph_query_is_valid(other.nodegraph_query_id))
		nodegraph_query_release(other.nodegraph_query_id);	
	other.followingapath = 0;
	remove(self);
};
void(vector path_org, entity ownr) spawn_follow_path =
{
	entity local_follow_path = spawn();
	ownr.follow_path = local_follow_path;
	local_follow_path.owner = ownr;
	local_follow_path.origin = path_org;
	local_follow_path.node_touch = 1;
	setmodel (local_follow_path, "models/misc/null.md3");
	local_follow_path.solid = SOLID_TRIGGER;
	setsize (local_follow_path, '-12 -12 -32', ' 12 12 32');
	local_follow_path.touch = spawn_follow_path_touch;
	local_follow_path.think = spawn_follow_path_remove;
	local_follow_path.nextthink = time  + 0.75;
	ownr.followingapath = 1;
};


.float charging;
.float walktime;
.float follownodetime;
.float evading;
void(float dist)ai_test_monster_run = 
{
	//if(self.movetype != MOVETYPE_WALK)
	//	self.movetype = MOVETYPE_WALK;

	if((self.evading_time > time ) || (self.timeangles > time))
	{
	ai_runwalk(dist);
	return;
	}

	if(self.classname == "executioner")
	if(self.charging != 1)
	self.yaw_speed = 20;
	else
	self.yaw_speed = 7;

	if(self.evading == 1)
	self.evading = 2;
	float threshold = 182;	

	if((vlen(self.enemy.origin - self.origin) < threshold) && (visible(self.enemy))  && (self.follownodetime < time))
	{
		if (nodegraph_query_is_valid(self.nodegraph_query_id))
			nodegraph_query_release(self.nodegraph_query_id);	
		self.followingapath = 0;
		if(self.follow_path !=  world)
			remove(self.follow_path);
		
	}
	else
	{
		if(!self.followingapath)
			find_node_path();
	}
	if (nodegraph_query_is_valid(self.nodegraph_query_id)) 
	{
		if(self.followingapath != 1)
		{
			float currentnodeid = nodegraph_query_get_nodeid(self.nodegraph_query_id, self.nodegraph_query_entry_index);
			vector currentnode = nodegraph_graph_get_node(0, currentnodeid);
			if(vlen(self.origin - currentnode) < threshold)
			{
				currentnodeid = nodegraph_query_get_nodeid(self.nodegraph_query_id, self.nodegraph_query_entry_index + 1);
				currentnode = nodegraph_graph_get_node(0, currentnodeid);
			}
			spawn_follow_path (currentnode, self);
			self.follownodetime = time  + random() * 0.5;
			self.ideal_yaw = vectoyaw(currentnode - self.origin);	
		}
		else
			self.ideal_yaw = vectoyaw(self.follow_path.origin - self.origin);	
			ChangeYaw();
	}
	else
	{
		self.followingapath = 0;
		self.ideal_yaw = vectoyaw(self.enemy.origin - self.origin);	
		ChangeYaw();
	}

	/*
	*/
	
	if((self.walktime > time) && (self.movetype == MOVETYPE_STEP))
	self.movetype = MOVETYPE_WALK;


	if((self.walktime < time) && (self.movetype != MOVETYPE_STEP))
	self.movetype = MOVETYPE_STEP;

	if(self.movetype == MOVETYPE_STEP)
	{
	if(self.classname == "executioner")
	dist = dist * 2.33;

		float walkeddist = walkmovedist(self.angles_y,dist);
		if(walkeddist <= 0)
		{
			if(self.strafing >time)
			check_angles();
			else
			{
				float r = random();
				if (r < 0.5)
					check_strafe();
				else
				{
				self.follownodetime = time  + random() * 2.5;
					self.walktime = time  + 2.5;
				}
			}
		}
	}
	else
	{

		float speed = vlen (self.velocity);
		if(speed < (dist * 0.5))
		check_angles();

		makevectors(self.angles);
		if(self.flags & FL_ONGROUND)
			self.velocity = v_forward *dist * 24;
		else
		{
			self.velocity = v_forward *dist * 6;
			self.velocity_z = -370;
		}
	}

};	

void() test_monster_run
{
	if(!self.enemy)
		self.enemy = single_player;
	ai_test_monster_run(16);
	self.think = test_monster_run;
	self.nextthink =  time + 0.1;
};


void()test_monster_start = 
{
	self.yaw_speed = 30;
	self.think = test_monster_run;
	self.nextthink =  time + 0.1;
};	

void() test_monster =
{
	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_WALK;
	setmodel(self, "models/enemies/fallen/fallen1.md3");
	self.colormod ='1 1 0';
	setsize(self, '-12 -12 -32', '12 12 32');
	self.think = test_monster_start;
	self.nextthink =  time + 0.1;
};