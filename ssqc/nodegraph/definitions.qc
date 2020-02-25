// ============================================================================
float NODEGRAPH_GRAPHSET_SIZE_LIMIT = 8;

// ============================================================================
float NODEGRAPH_MOVEPROBE_TYPE_FLY_WHATEVER = 0;
float NODEGRAPH_MOVEPROBE_TYPE_FLY_AIR = 1;
float NODEGRAPH_MOVEPROBE_TYPE_FLY_WATER = 2;

// ============================================================================
float() nodegraph_graphset_clear = #700;

float() nodegraph_graphset_load = #701;
float() nodegraph_graphset_save = #702;

float(float graphid) nodegraph_graph_clear = #703;

float(float graphid) nodegraph_graph_nodes_count = #704;

float(float graphid, vector node) nodegraph_graph_add_node = #705;
float(float graphid, float nodeid) nodegraph_graph_remove_node = #706;
float(float graphid, float nodeid) nodegraph_graph_is_node_valid = #707;

vector(float graphid, float nodeid) nodegraph_graph_get_node = #708;

float(float graphid, float nodeidfrom, float nodeidto) nodegraph_graph_add_link = #709;
float(float graphid, float nodeidfrom, float nodeidto) nodegraph_graph_remove_link = #710;
float(float graphid, float nodeidfrom, float nodeidto) nodegraph_graph_does_link_exist = #711;

float(float graphid, vector position) nodegraph_graph_find_nearest_nodeid = #712;

float(float graphid, float nodeidfrom, float nodeidto) nodegraph_graph_query_path = #713;
float(float graphid, float nodeid) nodegraph_graph_query_nodes_linked = #714;
float(float graphid, vector position, float radius) nodegraph_graph_query_nodes_in_radius = #715;

float(float queryid) nodegraph_query_release = #716;
float(float queryid) nodegraph_query_entries_count = #717;
float(float queryid) nodegraph_query_is_valid = #718;
float(float queryid) nodegraph_query_get_graphid = #719;
float(float queryid, float entryid) nodegraph_query_get_nodeid = #720;

float(vector nodefrom, vector nodeto, vector mins, vector maxs, float type) nodegraph_moveprobe_fly = #721;
float(vector nodefrom, vector nodeto, vector mins, vector maxs, float stepheight, float dropheight) nodegraph_moveprobe_walk = #722;

float(float graphid, vector position, float radius, vector mins, vector maxs, float type) nodegraph_graph_query_nodes_in_radius_fly_reachable = #723;
float(float graphid, vector position, float radius, vector mins, vector maxs, float stepheight, float dropheight) nodegraph_graph_query_nodes_in_radius_walk_reachable = #724;
