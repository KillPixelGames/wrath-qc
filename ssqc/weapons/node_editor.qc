.float node_editor;
.float node_editor_timing;
.entity nearest_node;
.entity nearest_node;
.float node_account;
void() editor_node_touch =
{
//if(other.classname == "player")

}



void() FindNearestNode = 
{ 
	local float dist, lower_dist;
	lower_dist = 99999999;	
	local entity info_node, local_nearest_info_node;

	info_node = findradius(self.origin, 512);
	while (info_node)	//Loops through everything put in the missile entity
	{
		if ((info_node.classname == "editor_node") && (visible(info_node)))
		{
				dist = vlen(info_node.origin - self.origin);
				if (dist < lower_dist)
				{
					lower_dist = dist;
					local_nearest_info_node = info_node;
				}
		}

		info_node = info_node.chain;	//links every info_nodegram found so they all go BOOM!
	}

	if(local_nearest_info_node)
	self.nearest_node = local_nearest_info_node;
};

void() place_node =
{
	vector org;
	if(self.flags & FL_ONGROUND)
	{
		traceline(self.origin, self.origin - '0 0 128',FALSE,self);
		if (trace_fraction != 1)
			org = trace_endpos + '0 0 16';
	}
	else
	return;
	vector oldorg = org;


	org_x = ceil(org_x);
	org_y = ceil(org_y);
	
	if(self.node_account)
	{
		//if ((max (self.nearest_node.origin_y , org_y) - min(self.nearest_node.origin_y , org_y) ) < 127)
		//org_y = self.nearest_node.origin_y;
		
		//if ((max (self.nearest_node.origin_x , org_x) - min(self.nearest_node.origin_x , org_x) ) < 127)
		//org_x = self.nearest_node.origin_x;
			
	//	org_y = (floor(org_y / 64)) *  64;
	//	org_x = (floor(org_x / 64)) *  64;

	}

	if(vlen (org - oldorg) > 92)
	return;

	entity node =  spawn();
	node.origin = org;
	setmodel(node, "models/dev/node.md3");
	node.classname = "editor_node";

	self.node_account ++;
	//self.nearest_node = node;
	setsize(node,'-127.5 -127.5 -127.5','127.5 127.5 127.5');
	node.solid = SOLID_TRIGGER;
	node.touch = editor_node_touch;
	//self.nearest_node = node;
	self.node_editor_timing =  time + 0.25;

};
void() delete_nearest_node =
{
	FindNearestNode();
	remove(self.nearest_node);
};

void() placing_nodes =
{
	if(time > self.node_editor_timing)
	{
		FindNearestNode();
		float dist = vlen(self.origin - self.nearest_node.origin);
		if (dist > 127.5)
			place_node();
	}
};
float writed_map;
void () write_node_in_map =
{
      
	local float    writeparms, as;
	local string    writethis, s1, s2, s3, s4, s5, s6, s7 ,s8 , s9 , s10; 


	local float nLength;
	local string namewbsp, namecomplete, currentmaplocal;
	currentmaplocal = world.model;
	namecomplete = substring(currentmaplocal, 5, 100);
	nLength = strlen(namecomplete);
	namewbsp = substring(namecomplete, 0, nLength - 4);
	currentmap = strcat(namewbsp, ".map");



	if (writed_map != 1)
	{
		writeparms = fopen (currentmap, FILE_WRITE);    //open what file to use in write mode

		fputs (writeparms, "{");
		fputs (writeparms, "\n");
		fputs (writeparms, "\"classname\" \"worldspawn\"");
		fputs (writeparms, "\n");
		fputs (writeparms, "}");
					

		fputs (writeparms, "\n");                    //dont forget this
		fclose (writeparms);
		writed_map = 1;
	}


	else
	{
		writeparms = fopen (currentmap, FILE_APPEND);    //open what file to use in write mode


		s3 = "\"";
		s1 =  "classname";
		s2 = "info_node";
		s4 = " ";
		s5 =  "origin";
		s6 = strcat (ftos (self.origin_x), s4,ftos (self.origin_y), s4, ftos (self.origin_z + 1) )  ;

		fputs (writeparms, "{");
		fputs (writeparms, "\n");                 
		fputs (writeparms, s3);                
		fputs (writeparms, s1);                
		fputs (writeparms, s3);                
		fputs (writeparms, s4);////
		fputs (writeparms, s3);                                
		fputs (writeparms, s2);            
		fputs (writeparms, s3);                    
		fputs (writeparms, "\n");                    

					   
		fputs (writeparms, s3);                
		fputs (writeparms, s5);                
		fputs (writeparms, s3);                
		fputs (writeparms, s4);//////
		fputs (writeparms, s3);                                
		fputs (writeparms, s6);            
		fputs (writeparms, s3);                   
		fputs (writeparms, "}"); 
		fputs (writeparms, "\n");  

		fclose (writeparms);
	}
	self.think = SUB_Null;
	self.nextthink = time + 0.1;
};

void() write_node_map =
{
local entity info_node;

	info_node = findradius(self.origin, 1000000);
	while (info_node)	//Loops through everything put in the missile entity
	{
		if ((info_node.classname == "editor_node"))
		{
			info_node.think = write_node_in_map;
			info_node.nextthink = time;
		}

		info_node = info_node.chain;	//links every info_nodegram found so they all go BOOM!
	}


};

