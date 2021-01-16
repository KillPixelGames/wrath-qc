// ============================================================================
float nodegraph_graphset_has_been_loaded;
float nodegraph_queue_initialize_has_already_been_called;

// ============================================================================
.string link_field_nodeidfrom;
.string link_field_nodeidto;
.float link_field_graphid;

// ============================================================================




void() nodegraph_graphset_post_initialize = 
{
	local float i, j, graph_nodes_count, queryid, query_entries_count, nodeidto;
	local vector nodefrom, nodeto;

	graph_nodes_count = nodegraph_graph_nodes_count(0);

	i = 0;

	while (i < graph_nodes_count)
	{
		nodefrom = nodegraph_graph_get_node(0, i);

		queryid = nodegraph_graph_query_nodes_in_radius(0, nodefrom, 256 + 16);

		if (nodegraph_query_is_valid(queryid))
		{
			query_entries_count = nodegraph_query_entries_count(queryid);

			j = 0;

			while (j < query_entries_count)
			{
				nodeidto = nodegraph_query_get_nodeid(queryid, j);
				nodeto = nodegraph_graph_get_node(0, nodeidto);

				if (nodegraph_moveprobe_walk(nodefrom, nodeto, '-12 -12 -32', '12 12 32', 16, 16))
				{
					nodegraph_graph_add_link(0, i, nodeidto);
				}

				j = j + 1;
			}

			nodegraph_query_release(queryid);
		}

		i = i + 1;	
	}

	nodegraph_graphset_save();

	remove(self);
};

// ============================================================================

void() nodegraph_debug_think =
{
	if	(test_ia == 1)
	{
		local float i, j, graph_nodes_count, queryid, query_entries_count, nodeidto;
		local vector nodefrom, nodeto;
		graph_nodes_count = nodegraph_graph_nodes_count(0);
		i = 0;
		while (i < graph_nodes_count)
		{
			nodefrom = nodegraph_graph_get_node(0, i);
			queryid = nodegraph_graph_query_nodes_linked(0, i);
			if (nodegraph_query_is_valid(queryid))
			{
				query_entries_count = nodegraph_query_entries_count(queryid);
				j = 0;
				while (j < query_entries_count)
				{
					nodeidto = nodegraph_query_get_nodeid(queryid, j);
					if (i != nodeidto)
					{
						nodeto = nodegraph_graph_get_node(0, nodeidto);
							 if((vlen (nodefrom - single_player.origin) < 512)  && (vlen (nodeto - single_player.origin) < 512) )
								te_tei_g3 (nodefrom, nodeto);
					}
					j = j + 1;
				}
				nodegraph_query_release(queryid);
			}
			i = i + 1;
		}
	}

	self.nextthink = time + 0.1;
};

void() nodegraph_debug_thinkscxzxc =
{
	local float i, j, graph_nodes_count, queryid, query_entries_count, nodeidto;
	local vector nodefrom, nodeto;
	if (test_ia == 1)
	{
		graph_nodes_count = nodegraph_graph_nodes_count(0);

		i = 0;

		while (i < graph_nodes_count)
		{
			nodefrom = nodegraph_graph_get_node(0, i);
			//if(test_ia == 1)
			//pointparticles(particleeffectnum("cystbody"), nodefrom + '0 0 16', '0 0 16', 1);

			queryid = nodegraph_graph_query_nodes_linked(0, i);

			if (nodegraph_query_is_valid(queryid))
			{
				query_entries_count = nodegraph_query_entries_count(queryid);

				j = 0;

				while (j < query_entries_count)
				{
					nodeidto = nodegraph_query_get_nodeid(queryid, j);

					if (i != nodeidto)
					{
					
					
						nodeto = nodegraph_graph_get_node(0, nodeidto);
						//if	(visibleb(nodefrom,nodeto,self.owner) && (test_ia == 1) && (checkpvs(self.owner.origin + self.owner.view_ofs,self)))
							//te_custombeam("models/dev/nodeline.md3", world, nodefrom, nodeto);
			
							//te_beam(world,nodefrom, nodeto);
							
							//float topl =
							
					}

					j = j + 1;
				}
	
				nodegraph_query_release(queryid);
			}

			i = i + 1;
		}
	}
	self.nextthink = time + 0.1;
};

// ============================================================================
void() nodegraph_queue_initialize =
{
	local entity nodegraph_entity;

	if (!nodegraph_queue_initialize_has_already_been_called)
	{
		nodegraph_graphset_has_been_loaded = nodegraph_graphset_load();

		if (!nodegraph_graphset_has_been_loaded)
		{
			nodegraph_graphset_clear();

			nodegraph_entity = spawn();
			nodegraph_entity.classname = "nodegraph";
			nodegraph_entity.nextthink = time + 0.5;
			nodegraph_entity.think = nodegraph_graphset_post_initialize;
		}

		float dev =  cvar("developer");
		
		
		if (dev == 1)
		{
			nodegraph_entity = spawn();
			nodegraph_entity.classname = "nodegraph_debug";
			local entity pl;
			pl = find (world,classname, "player");
			nodegraph_entity.owner = pl;

			nodegraph_entity.nextthink = time + 1.0;
			nodegraph_entity.think = nodegraph_debug_think;
		}
		
		nodegraph_queue_initialize_has_already_been_called = TRUE;
	}
};

// ============================================================================
void() node_model_think =
{
if(test_ia == 1)
self.effects = 0;
else
self.effects = EF_NODRAW;
self.nextthink = time + 1;
}
void() info_node =
{
	float dev = cvar("developer");
	nodegraph_queue_initialize();
	if (dev == 1)
	{
		local entity node_model;
		node_model = spawn();
		node_model.classname = "info_node";
		node_model.origin = self.origin;
		node_model.effects = EF_NODRAW;
		setmodel(node_model,"models/dev/node.md3");
		node_model.think = node_model_think;
		node_model.nextthink = time + 0.5;
	}
	if (nodegraph_graphset_has_been_loaded)
	{
		remove(self);
		return;
	}

	traceline(self.origin, self.origin + '0 0 -96', TRUE, world);

	if (trace_fraction == 1)
	{
		remove(self);
		return;
	}

	nodegraph_graph_add_node(0, trace_endpos);

	if (!self.targetname)
	{
		remove(self);
	}
};
// ============================================================================

.float alreadyconnected_node;
.float count;

void() info_node_link_connect_nodes =
{
	local entity nodeentity;
	local float nodeidfrom;
	local float nodeidto;

	nodeentity = find(world, targetname, self.link_field_nodeidfrom);
	nodeidfrom = nodegraph_graph_find_nearest_nodeid(self.link_field_graphid, nodeentity.origin);

	nodeentity = find(world, targetname, self.link_field_nodeidto);
	nodeidto = nodegraph_graph_find_nearest_nodeid(self.link_field_graphid, nodeentity.origin);

	nodegraph_graph_add_link(self.link_field_graphid, nodeidfrom, nodeidto);
	remove(self);
};


// ============================================================================
void() info_node_link =
{
	nodegraph_queue_initialize();
	float dev = cvar("developer");
	if (dev == 1)
	{
		local entity node_model;
		node_model = spawn();
		node_model.classname = "info_node_link";
		node_model.colormod = '0 5 0.5';
		node_model.origin = self.origin;
		node_model.effects = EF_NODRAW;
		setmodel(node_model,"models/dev/node.md3");
		node_model.think = node_model_think;
		node_model.nextthink = time + 0.5;
	}

	if (nodegraph_graphset_has_been_loaded)
	{
		remove(self);
		return;
	}

	self.nextthink = time + 0.1;
	self.think = info_node_link_connect_nodes;
};

// ============================================================================
// Find
// ============================================================================

void() find_node_path =
{
	local float queryid, nodeidfrom, nodeidto;
	local vector from, to;

	traceline(self.origin, self.origin + self.mins - '0 0 16', TRUE, world);
	from = trace_endpos;

	if(self.evade == 1)
	traceline(self.goalentity.origin, self.goalentity.origin + self.goalentity.mins - '0 0 1024', TRUE, world);
	else
	traceline(self.enemy.origin, self.enemy.origin + self.enemy.mins - '0 0 1024', TRUE, world);
	to = trace_endpos;

	nodeidfrom = -1;
	nodeidto = -1;

	queryid = nodegraph_graph_query_nodes_in_radius_walk_reachable(0, from, 256, self.mins, self.maxs, 16, 16);

	if (nodegraph_query_is_valid(queryid))
	{
		nodeidfrom = nodegraph_query_get_nodeid(queryid, 0);
		nodegraph_query_release(queryid);
	}

	queryid = nodegraph_graph_query_nodes_in_radius_walk_reachable(0, to, 256, self.mins, self.maxs, 16, 16);

	if (nodegraph_query_is_valid(queryid))
	{
		nodeidto = nodegraph_query_get_nodeid(queryid, 0);
		nodegraph_query_release(queryid);
	}

	self.nodegraph_query_id = nodegraph_graph_query_path(0, nodeidfrom, nodeidto);
	self.nodegraph_query_entry_index = 0;
};
