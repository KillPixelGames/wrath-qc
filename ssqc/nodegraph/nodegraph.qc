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
	local float i, j, graph_nodes_count, queryid, query_entries_count, nodeidto;
	local vector nodefrom, nodeto;

	graph_nodes_count = nodegraph_graph_nodes_count(0);

	i = 0;

	while (i < graph_nodes_count)
	{
		nodefrom = nodegraph_graph_get_node(0, i);

		pointparticles(particleeffectnum("cystbody"), nodefrom + '0 0 16', '0 0 16', 1);

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
					te_lightning1(world, nodefrom, nodeto);
				}

				j = j + 1;
			}

			nodegraph_query_release(queryid);
		}

		i = i + 1;
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

		/*
		nodegraph_entity = spawn();
		nodegraph_entity.classname = "nodegraph_debug";
		nodegraph_entity.nextthink = time + 1.0;
		nodegraph_entity.think = nodegraph_debug_think;
		*/

		nodegraph_queue_initialize_has_already_been_called = TRUE;
	}
};

// ============================================================================
void() info_node =
{
	nodegraph_queue_initialize();

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

	if (nodegraph_graphset_has_been_loaded)
	{
		remove(self);
		return;
	}

	self.nextthink = time + 0.1;
	self.think = info_node_link_connect_nodes;
};
