// --------------------------------------------------------------------------
// BEGIN REQUIRED CSQC FUNCTIONS

.float enttype;

void() Hud_Init;
void() rewritefriktether = {};
void() rewritefrikshrine = {};

// CSQC_Init : Called every time the CSQC code is initialized (essentially at map load)
void CSQC_Init(void)
{
	local string strCmd;
	strCmd = "";
	//	strCmd = strcat (strCmd, "vid_conwidth 960 \n");
	//	strCmd = strcat (strCmd, "vid_conheight 540 \n");
	strCmd = ("exec fonts/font.cfg \n");
	localcmd(strCmd);
	cvar_set("r_glsl_postprocess_uservec1", "0 0 0 0");
	//cvar_set("r_viewscale", "1");
	cvar_set("sv_maxvelocity", "10000");
	Hud_Init();
	check_frikfile();
	msgtime = gettime(GETTIME_UPTIME);
	float noqcprecaches = cvar("cl_noqcprecache");	
	if(noqcprecaches != 1)
	csqc_precaches();
	registercommand(CLIENTCOMMAND_GET_FOG);
	registercommand(CLIENTCOMMAND_DELETE_QNG);
	registercommand(CLIENTCOMMAND_DUMP_SPAWNERS);
	registercommand(CLIENTCOMMAND_NOATTACK);
	registercvar ("_fog_d",ftos(getproperty(VF_FOG_DENSITY)));
	registercvar("_fog_color",vtos(getpropertyvec(VF_FOG_COLOR)));
	//registercvar ("_fog_r",ftos(getproperty(VF_FOG_COLOR_R)));
	//registercvar ("_fog_g",ftos(getproperty(VF_FOG_COLOR_G)));
	//registercvar ("_fog_b",ftos(getproperty(VF_FOG_COLOR_B)));
	registercvar ("_fog_a",ftos(getproperty(VF_FOG_ALPHA)));
	registercvar ("_fog_s",ftos(getproperty(VF_FOG_START)));
	registercvar ("_fog_e",ftos(getproperty(VF_FOG_END)));
	registercvar ("_fog_h",ftos(getproperty(VF_FOG_HEIGHT)));
	registercvar ("_fog_f",ftos(getproperty(VF_FOG_FADEDEPTH)));

	float scale_crosshair = cvar ("saved8");
	if(scale_crosshair < 1)
	strCmd = ("saved8 1\n");
	localcmd(strCmd);
};

// CSQC_Shutdown : Called every time the CSQC code is shutdown (changing maps, quitting, etc)
void CSQC_Shutdown(void) {};


void()get_fog_values =
{

	/*
	#define VF_FOG_DENSITY        202 //(float)
	#define VF_FOG_COLOR        203 //(vector)
	#define VF_FOG_COLOR_R        204 //(float)
	#define VF_FOG_COLOR_G        205 //(float)
	#define VF_FOG_COLOR_B        206 //(float)
	#define VF_FOG_ALPHA        207 //(float)
	#define VF_FOG_START        208 //(float)
	#define VF_FOG_END           209 //(float)
	#define VF_FOG_HEIGHT        210 //(float)
	#define VF_FOG_FADEDEPTH    211 //(float)
	*/

	//float fog_d, fog_r, fog_g, fog_b, fog_a, fog_s, fog_e, fog_h, fog_f;

	cvar_set("_fog_d",ftos(getproperty(VF_FOG_DENSITY)));

	cvar_set ("_fog_color",vtos(getpropertyvec(VF_FOG_COLOR)));
	cvar_set ("_fog_a",ftos(getproperty(VF_FOG_ALPHA)));
	cvar_set ("_fog_s",ftos(getproperty(VF_FOG_START)));
	cvar_set ("_fog_e",ftos(getproperty(VF_FOG_END)));
	cvar_set ("_fog_h",ftos(getproperty(VF_FOG_HEIGHT)));
	cvar_set ("_fog_f",ftos(getproperty(VF_FOG_FADEDEPTH)));
}
void() dump_spawner =
{
	string strCmd = ("impulse 196\n");
	localcmd(strCmd);
};

void() delete_qng = 
{
	string strCmd = ("impulse 198\n");
	localcmd(strCmd);
};

void() noattack =
{
	string strCmd = ("impulse 195\n");
	localcmd(strCmd);
};

// CSQC_ConsoleCommand : Used to parse commands in the console that have been registered with the "registercmd" function
// Return value should be 1 if CSQC handled the command, otherwise return 0 to have the engine handle it.
float CSQC_ConsoleCommand(string strMessage)
{
	local float nReturn;
	nReturn = true;
	// Tokenize String
	tokenize(strMessage);
	// Acquire Command
	local string strCmd;
	strCmd = argv(0);
	switch (strCmd)
	{
			case CLIENTCOMMAND_GET_FOG:
			get_fog_values();
			/*
			case CLIENTCOMMAND_GRAVITYFIX:
			{strCmd = ("exec fonts/font.cfg \n");localcmd(strCmd);}
			case CLIENTCOMMAND_NOGRAVITYFIX:
			get_fog_values();
			case CLIENTCOMMAND_GLSL_SATURATION:
			get_fog_values();
			case CLIENTCOMMAND_NOGLSL_SATURATION:
			get_fog_values();
			*/
			case CLIENTCOMMAND_DELETE_QNG:
			delete_qng();
			break;
			case CLIENTCOMMAND_NOATTACK:
			noattack();
			break;
			case CLIENTCOMMAND_DUMP_SPAWNERS:
			dump_spawner();
			break;
		default:
			nReturn = false;
			break;
	}

	return nReturn;
};

// CSQC_InputEvent : Used to perform actions based on any key pressed or released by the client.
// Return value should be 1 if CSQC handled the key press, otherwise return 0 to have the key passed to the engine.

float tether;
float dmenualpha;
float lastsoundjournal;

float CSQC_InputEvent(float bKeyReleased, float nKey, float n)
{
	if ((bKeyReleased == 0) && (nKey == 27))
	{
		localcmd("impulse 90\n");
	}
	
	if ((bKeyReleased == 0) && (DMselected >= 1))
	{
		if ((nKey == 512) && (dmenualpha == 1))	// mouse1
		{
			localcmd("crosshair 2\n");
			if (DMselected == 1)
			{
				write_tether2(1);
				localcmd("stopsound\n");
				localcmd("slowmo 1\n");
				localcmd("r_glsl_saturation 1\n");
				setcursormode(0);
				load_tether();
				localcmd("scratch3 0\n");
			}

			if (DMselected == 2)
			{
				write_shrine(1);
				localcmd("slowmo 1\n");
				localcmd("stopsound\n");
				localcmd("r_glsl_saturation 1\n");
				setcursormode(0);
				load_shrine();
				localcmd("scratch3 0\n");
			}

			if (DMselected == 3)
			{
				localcmd("slowmo 1\n");
				localcmd("stopsound\n");
				localcmd("r_glsl_saturation 1\n");
				setcursormode(0);
				load_autosave();
				localcmd("scratch3 0\n");
			}

			if (DMselected == 4)
			{
				localcmd("wmenu\n");
				localcmd("stopsound\n");
				localcmd("menu_cmd backtomainmenu\n");
				localcmd("scratch3 0\n");
				setcursormode(0);
			}

			return 1;
		}

		if ((nKey == (12 + 1)) && (dmenualpha == 1))	// enter
		{
			localcmd("crosshair 2\n");
			if (DMselected == 1)
			{
				write_tether2(1);
				rewritefriktether();
				localcmd("stopsound\n");
				localcmd("slowmo 1\n");
				localcmd("r_glsl_saturation 1\n");
				load_tether();
				localcmd("scratch3 0\n");
				setcursormode(0);
			}

			if (DMselected == 2)
			{
				write_shrine(1);
				localcmd("slowmo 1\n");
				localcmd("stopsound\n");
				localcmd("r_glsl_saturation 1\n");
				load_shrine();
				localcmd("scratch3 0\n");
				setcursormode(0);
			}

			if (DMselected == 3)
			{
				localcmd("slowmo 1\n");
				localcmd("stopsound\n");
				localcmd("r_glsl_saturation 1\n");
				setcursormode(0);
				load_autosave();
				localcmd("scratch3 0\n");
			}

			if (DMselected == 4)
			{
				localcmd("wmenu\n");
				localcmd("stopsound\n");
				localcmd("menu_cmd backtomainmenu\n");
				localcmd("scratch3 0\n");
				setcursormode(0);
			}

			return 1;
		}
	}

	float showjournal;
	showjournal = getstatf(STAT_JOURNAL);
	if ((bKeyReleased == 0) && (nKey == 27) && (showjournal > 0))
	{
		localcmd("impulse 35\n");
	}
	


	if ((showjournal > 0) && (journal_chapter == 3))
	{
		float selected_journal_page_bestiary;
		float jitems_bestiary;
		jitems_bestiary = getstatf(STAT_JOURNAL_MESSAGESM);
		if ((bKeyReleased == 0) && (nKey == 515))
		{
			if (journal_page_bestiary == 2)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}

			if (journal_page_bestiary == 3)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}

			if (journal_page_bestiary == 4)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (jitems_bestiary & JB_C) selected_journal_page_bestiary = 3;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}

			if (journal_page_bestiary == 5)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (jitems_bestiary & JB_C) selected_journal_page_bestiary = 3;
				if (jitems_bestiary & JB_D) selected_journal_page_bestiary = 4;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}

			if (journal_page_bestiary == 6)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (jitems_bestiary & JB_C) selected_journal_page_bestiary = 3;
				if (jitems_bestiary & JB_D) selected_journal_page_bestiary = 4;
				if (jitems_bestiary & JB_E) selected_journal_page_bestiary = 5;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}

			if (journal_page_bestiary == 7)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (jitems_bestiary & JB_C) selected_journal_page_bestiary = 3;
				if (jitems_bestiary & JB_D) selected_journal_page_bestiary = 4;
				if (jitems_bestiary & JB_E) selected_journal_page_bestiary = 5;
				if (jitems_bestiary & JB_F) selected_journal_page_bestiary = 6;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}

			if (journal_page_bestiary == 8)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (jitems_bestiary & JB_C) selected_journal_page_bestiary = 3;
				if (jitems_bestiary & JB_D) selected_journal_page_bestiary = 4;
				if (jitems_bestiary & JB_E) selected_journal_page_bestiary = 5;
				if (jitems_bestiary & JB_F) selected_journal_page_bestiary = 6;
				if (jitems_bestiary & JB_G) selected_journal_page_bestiary = 7;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}
			if (journal_page_bestiary == 9)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (jitems_bestiary & JB_C) selected_journal_page_bestiary = 3;
				if (jitems_bestiary & JB_D) selected_journal_page_bestiary = 4;
				if (jitems_bestiary & JB_E) selected_journal_page_bestiary = 5;
				if (jitems_bestiary & JB_F) selected_journal_page_bestiary = 6;
				if (jitems_bestiary & JB_G) selected_journal_page_bestiary = 7;
				if (jitems_bestiary & JB_H) selected_journal_page_bestiary = 8;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}		
			if (journal_page_bestiary == 10)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (jitems_bestiary & JB_C) selected_journal_page_bestiary = 3;
				if (jitems_bestiary & JB_D) selected_journal_page_bestiary = 4;
				if (jitems_bestiary & JB_E) selected_journal_page_bestiary = 5;
				if (jitems_bestiary & JB_F) selected_journal_page_bestiary = 6;
				if (jitems_bestiary & JB_G) selected_journal_page_bestiary = 7;
				if (jitems_bestiary & JB_H) selected_journal_page_bestiary = 8;
				if (jitems_bestiary & JB_I) selected_journal_page_bestiary = 9;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}		
			if (journal_page_bestiary == 11)
			{
				if (jitems_bestiary & JB_A) selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B) selected_journal_page_bestiary = 2;
				if (jitems_bestiary & JB_C) selected_journal_page_bestiary = 3;
				if (jitems_bestiary & JB_D) selected_journal_page_bestiary = 4;
				if (jitems_bestiary & JB_E) selected_journal_page_bestiary = 5;
				if (jitems_bestiary & JB_F) selected_journal_page_bestiary = 6;
				if (jitems_bestiary & JB_G) selected_journal_page_bestiary = 7;
				if (jitems_bestiary & JB_H) selected_journal_page_bestiary = 8;
				if (jitems_bestiary & JB_I) selected_journal_page_bestiary = 9;
				if (jitems_bestiary & JB_J) selected_journal_page_bestiary = 10;
				if (selected_journal_page_bestiary > 0)
					journal_page_bestiary = selected_journal_page_bestiary;
			}	
			}

		if ((bKeyReleased == 0) && (nKey == 516))
		{
			selected_journal_page_bestiary = 0;
			if (journal_page_bestiary == 1)
			{
				if (jitems_bestiary & JB_A) 
				selected_journal_page_bestiary = 1;
				if (jitems_bestiary & JB_B)
					selected_journal_page_bestiary = 2;
				if ((!(jitems_bestiary & JB_B)) && (jitems_bestiary & JB_C))
					selected_journal_page_bestiary = 3;
				if ((!(jitems_bestiary & JB_B)) && (!(jitems_bestiary & JB_C)) && (jitems_bestiary & JB_D))
					selected_journal_page_bestiary = 4;
				if ((!(jitems_bestiary & JB_B)) && (!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (jitems_bestiary & JB_E))
					selected_journal_page_bestiary = 5;
				if ((!(jitems_bestiary & JB_B)) && (!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (jitems_bestiary & JB_F))
					selected_journal_page_bestiary = 6;
				if ((!(jitems_bestiary & JB_B)) && (!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (jitems_bestiary & JB_G))
					selected_journal_page_bestiary = 7;
				if ((!(jitems_bestiary & JB_B)) && (!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (jitems_bestiary & JB_H))
					selected_journal_page_bestiary = 8;
				if ((!(jitems_bestiary & JB_B)) && (!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) && (jitems_bestiary & JB_I))
					selected_journal_page_bestiary = 9;
				if ((!(jitems_bestiary & JB_B)) && (!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) &&(!(jitems_bestiary & JB_I)) && (jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;
				if ((!(jitems_bestiary & JB_B)) && (!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) &&(!(jitems_bestiary & JB_I)) && (!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;
			}

			if (journal_page_bestiary == 2)
			{
				if (jitems_bestiary & JB_C)
					selected_journal_page_bestiary = 3;
				if ((!(jitems_bestiary & JB_C)) && (jitems_bestiary & JB_D))
					selected_journal_page_bestiary = 4;
				if ((!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (jitems_bestiary & JB_E))
					selected_journal_page_bestiary = 5;
				if ((!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (jitems_bestiary & JB_F))
					selected_journal_page_bestiary = 6;
				if ((!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (jitems_bestiary & JB_G))
					selected_journal_page_bestiary = 7;
				if ((!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (jitems_bestiary & JB_H))
					selected_journal_page_bestiary = 8;
				if ((!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H))&& (jitems_bestiary & JB_I))
					selected_journal_page_bestiary = 9;
				if ((!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H))&& (!(jitems_bestiary & JB_I))&& (jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;
				if ((!(jitems_bestiary & JB_C)) && (!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) &&(!(jitems_bestiary & JB_I)) && (!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;
			}

			if (journal_page_bestiary == 3)
			{
				if ((jitems_bestiary & JB_D))
					selected_journal_page_bestiary = 4;
				if ((!(jitems_bestiary & JB_D)) && (jitems_bestiary & JB_E))
					selected_journal_page_bestiary = 5;
				if ((!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (jitems_bestiary & JB_F))
					selected_journal_page_bestiary = 6;
				if ((!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (jitems_bestiary & JB_G))
					selected_journal_page_bestiary = 7;
				if ((!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (jitems_bestiary & JB_H))
					selected_journal_page_bestiary = 8;
				if ((!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) && (jitems_bestiary & JB_I))
					selected_journal_page_bestiary = 9;			
				if ((!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) && (!(jitems_bestiary & JB_I)) && (jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;			
				if ((!(jitems_bestiary & JB_D)) && (!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) &&(!(jitems_bestiary & JB_I)) && (!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;			
				}

			if (journal_page_bestiary == 4)
			{
				if ((jitems_bestiary & JB_E))
					selected_journal_page_bestiary = 5;
				if ((!(jitems_bestiary & JB_E)) && (jitems_bestiary & JB_F))
					selected_journal_page_bestiary = 6;
				if ((!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (jitems_bestiary & JB_G))
					selected_journal_page_bestiary = 7;
				if ((!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (jitems_bestiary & JB_H))
					selected_journal_page_bestiary = 8;
				if ((!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) && (jitems_bestiary & JB_I))
					selected_journal_page_bestiary = 9;			
				if ((!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) &&  (!(jitems_bestiary & JB_I)) &&(jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;			
				if ((!(jitems_bestiary & JB_E)) && (!!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) &&(!(jitems_bestiary & JB_I)) && (!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;			
			}

			if (journal_page_bestiary == 5)
			{
				if ((jitems_bestiary & JB_F))
					selected_journal_page_bestiary = 6;
				if ((!(jitems_bestiary & JB_F)) && (jitems_bestiary & JB_G))
					selected_journal_page_bestiary = 7;
				if ((!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (jitems_bestiary & JB_H))
					selected_journal_page_bestiary = 8;
				if ((!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) && (jitems_bestiary & JB_I))
					selected_journal_page_bestiary = 9;			
				if ((!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H))  && (!(jitems_bestiary & JB_I)) && (jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;			
				if ((!(jitems_bestiary & JB_F)) && (!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) &&(!(jitems_bestiary & JB_I)) && (!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;		
			}

			if (journal_page_bestiary == 6)
			{
				if ((jitems_bestiary & JB_G))
					selected_journal_page_bestiary = 7;
				if ((!(jitems_bestiary & JB_G)) && (jitems_bestiary & JB_H))
					selected_journal_page_bestiary = 8;
				if ((!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H))&& (jitems_bestiary & JB_I))
					selected_journal_page_bestiary = 9;
				if ((!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H))&&(!(jitems_bestiary & JB_I))&&  (jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;
				if ((!(jitems_bestiary & JB_G)) && (!(jitems_bestiary & JB_H)) &&(!(jitems_bestiary & JB_I)) && (!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;		
			}

			if (journal_page_bestiary == 7)
			{
				if ((jitems_bestiary & JB_H))
					selected_journal_page_bestiary = 8;
				if ((!(jitems_bestiary & JB_H)) && (jitems_bestiary & JB_I))
					selected_journal_page_bestiary = 9;
				if ((!(jitems_bestiary & JB_H)) && (!(jitems_bestiary & JB_I)) &&(jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;
				if ((!(jitems_bestiary & JB_H)) &&(!(jitems_bestiary & JB_I)) && (!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;				
			}
			if (journal_page_bestiary == 8)
			{
				if ((jitems_bestiary & JB_I))
					selected_journal_page_bestiary = 9;
				if ((!(jitems_bestiary & JB_I)) && (jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;
				if ((!(jitems_bestiary & JB_I)) && (!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;				
			}
			if (journal_page_bestiary == 9)
			{
				if ((jitems_bestiary & JB_J))
					selected_journal_page_bestiary = 10;
				if ((!(jitems_bestiary & JB_J)) && (jitems_bestiary & JB_K))
					selected_journal_page_bestiary = 11;				
			}
			if (journal_page_bestiary == 10)
			{
				if (jitems_bestiary & JB_K)
					selected_journal_page_bestiary = 11;				
			}
			if (selected_journal_page_bestiary > 0)
				journal_page_bestiary = selected_journal_page_bestiary;
		}

		local float r;
		local string rsound;
		r = floor(random() *7) + 1;
		if (r == lastsoundjournal)
			r += 1;
		if (r > 7)
			r = 1;
		lastsoundjournal = r;
		rsound = ftos(r);
		if (selected_journal_page_bestiary > 0)
			localcmd(strcat("play2 sound/ui/journal/journal_page", rsound, ".ogg\n"));

		selected_journal_page_bestiary = 0;
	}

	if (using_cursor)
	{
		if (bKeyReleased == 0)
		{
			if (nKey == 512)
			{
				if ((journal_page_selected) && (mouse_inbutton > 0))
				{
					local float r;
					local string rsound;
					r = floor(random() *7) + 1;
					if (r == lastsoundjournal)
						r += 1;
					if (r > 7)
						r = 1;
					lastsoundjournal = r;
					rsound = ftos(r);
					localcmd(strcat("play2 sound/ui/journal/journal_page", rsound, ".ogg\n"));
				}

				//localsound ("playsound sounds/ui/journal/journal_page3.ogg\n");
				if ((journal_page_selected == 100) && (mouse_inbutton == 1))
				{
					if (journal_chapter == 2)
						journal_scroll -= 1;
					if (journal_chapter == 3)
						journal_scroll_bestiary -= 1;
					mouse_inbutton = 0;
				}

				if ((journal_page_selected == 101) && (mouse_inbutton == 1))
				{
					if (journal_chapter == 2)
					{
						if (journal_scroll >= 0)
							journal_scroll += 1;
					}

					if (journal_chapter == 3)
					{
						if (journal_scroll_bestiary >= 0)
							journal_scroll_bestiary += 1;
					}

					mouse_inbutton = 0;
				}

				if ((journal_page_selected == 200) && (mouse_inbutton == 2))
				{
					//journal_page = 1;
					//journal_scroll = 0;
					journal_chapter = 1;
					mouse_inbutton = 0;
				}

				if ((journal_page_selected == 201) && (mouse_inbutton == 2))
				{
					//journal_page = 1;
					//journal_scroll = 0;
					journal_chapter = 2;
					mouse_inbutton = 0;
				}

				if ((journal_page_selected == 202) && (mouse_inbutton == 2))
				{
					//journal_page = 1;
					//journal_scroll = 0;
					journal_chapter = 3;
					mouse_inbutton = 0;
				}

				if ((journal_page_selected == 203) && (mouse_inbutton == 2))
				{
					//journal_page = 1;
					//journal_scroll = 0;
					journal_chapter = 4;
					mouse_inbutton = 0;
				}

				if ((journal_page_selected > 300) && (mouse_inbutton == 2))
				{
					if (journal_page_selected)
					{
						if (journal_chapter == 1)
							journal_page_maps = journal_page_selected;
						if (journal_chapter == 2)
							journal_page_armory = journal_page_selected;
						if (journal_chapter == 3)
							journal_page_bestiary = journal_page_selected;
					}
				}

				if ((journal_page_selected < 100) && (mouse_inbutton == 1))
				{
					if (journal_page_selected)
					{
						if (journal_chapter == 1)
							journal_page_maps = journal_page_selected;
						if (journal_chapter == 2)
							journal_page_armory = journal_page_selected;
						if (journal_chapter == 3)
							journal_page_bestiary = journal_page_selected;
					}
				}

				firstscroll = 0;
				lastscroll = 0;
				mouse_inbutton = 0;
				journal_page_selected = 0;
				return TRUE;
			}
		}
	}

	local float bSkipKey;
	bSkipKey = false;
	return bSkipKey;
}

// END REQUIRED CSQC FUNCTIONS
// --------------------------------------------------------------------------

// --------------------------------------------------------------------------
// BEGIN OPTIONAL CSQC FUNCTIONS

//#ifdef USE_CSQC_OPTIONALFUNCTIONS
// CSQC_Ent_Update : Called every frame that the server has indicated an update to the SSQC / CSQC entity has occured.
// The only parameter reflects if the entity is "new" to the client, meaning it just came into the client's PVS.
void CSQC_Ent_Update(float bIsNewEntity)
{
	self.enttype = ReadByte();
	if (self.enttype == ENT_HUDMSG)
		Hud_Messages(bIsNewEntity);
	if (self.enttype == ENT_HUDMSG2)
		Hud_Messages2(bIsNewEntity);
	if (self.enttype == ENT_HMMSG)
		Health_Indicator(bIsNewEntity);
	/*	
	if (self.enttype == ENT_ARTIFACT)
		artifact_spawn(bIsNewEntity); */
};

// CSQC_Ent_Remove : Called when the server requests a SSQC / CSQC entity to be removed.  Essentially call remove(self) as well.
void CSQC_Ent_Remove()
{
	if (self.enttype == ENT_HUDMSG)
		Remove_Message();
	else if (self.enttype == ENT_HUDMSG2)
		Remove_Message2();
	else
		remove(self);
};

// CSQC_Parse_StuffCmd : Provides the stuffcmd string in the first parameter that the server provided.  To execute standard behavior, simply execute localcmd with the string.
void CSQC_Parse_StuffCmd(string strMessage)
{
	localcmd(strMessage);
};

// CSQC_Parse_Print : Provides the print string in the first parameter that the server provided.  To execute standard behavior, simply execute print with the string.
void CSQC_Parse_Print(string strMessage)
{
	print(strMessage);
};

// CSQC_Parse_CenterPrint : Provides the centerprint string in the first parameter that the server provided.  To execute standard behavior, simply execute cprint with the string.
void CSQC_Parse_CenterPrint(string strMessage)
{
	centerprint(strMessage);
};

// CSQC_Parse_TempEntity : Handles all temporary entity network data in the CSQC layer.
// You must ALWAYS first acquire the temporary ID, which is sent as a byte.
// Return value should be 1 if CSQC handled the temporary entity, otherwise return 0 to have the engine process the event.
float CSQC_Parse_TempEntity()
{
	local float bHandled;
	bHandled = true;
	// Acquire TE ID
	local float nTEID;
	nTEID = ReadByte();
	switch (nTEID)
	{
		//case TE_GUNSHOT:
		//	Do something cool with TE_GUNSHOT!
		//	break;
		default:
			// No special logic for this temporary entity; return 0 so the engine can handle it
			bHandled = false;
			break;
	}

	return bHandled;
};
//endif	///////////////
