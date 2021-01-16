


float smallbuttons;

 void() m_display;
 float pausesound;
 float nprof;
 float type_load_selected;
 float number_load_selected;
float profilemenuversion;

void() precache_menu_files =
{
	precache_pic("gfx/cursor.tga");
	precache_pic("gfx/menu/background.tga");
	precache_pic("gfx/menu/begin_active.tga");
	precache_pic("gfx/menu/begin.tga");
	precache_pic("gfx/menu/delete_profile_active.tga");
	precache_pic("gfx/menu/delete_profile.tga");
	precache_pic("gfx/menu/depart_active.tga");
	precache_pic("gfx/menu/depart.tga");
	precache_pic("gfx/menu/end_splash.tga");
	precache_pic("gfx/menu/load_game_active2.tga");
	precache_pic("gfx/menu/load_game_active.tga");
	precache_pic("gfx/menu/load_game.tga");
	precache_pic("gfx/menu/load_menud.tga");
	precache_pic("gfx/menu/load_menu_e1m1.tga");
	precache_pic("gfx/menu/load_menu_e1m2.tga");
	precache_pic("gfx/menu/load_menu_e1m3.tga");
	precache_pic("gfx/menu/load_menu_e1m4.tga");
	precache_pic("gfx/menu/load_menu_e1m5.tga");
	precache_pic("gfx/menu/load_menu_hub1.tga");
	precache_pic("gfx/menu/load_menu.tga");
	precache_pic("gfx/menu/logo.tga");
	precache_pic("gfx/menu/options_active.tga");
	precache_pic("gfx/menu/options.tga");
	precache_pic("gfx/menu/resume_active.tga");
	precache_pic("gfx/menu/resume.tga");
	precache_pic("gfx/splashes/arrow.tga");
	precache_pic("gfx/splashes/_blank.tga");
	precache_pic("gfx/splashes/e1m1_16-9.tga");
	precache_pic("gfx/splashes/e1m2_16-9.tga");
	precache_pic("gfx/splashes/e1m3_16-9.tga");
	precache_pic("gfx/splashes/e1m4_16-9.tga");
	precache_pic("gfx/splashes/e1m5_16-9.tga");
	precache_pic("gfx/splashes/endgame.tga");
	precache_pic("gfx/splashes/hub1_16-9.tga");
	precache_pic("gfx/splashes/loading_ring.tga");
};


 void(string txttoclear) writeempty = 
{
	local float writeparms;
 	writeparms = fopen_wrath(txttoclear, FILE_WRITE);	//open what file to use in write mode
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fputs(writeparms, "\n");	//and again
 	fclose_wrath(writeparms);
 }


 
 void() delete_profiles = 
{
	writeempty("profiles/currentprofileslot.txt");
 	writeempty("profiles/profilenames.txt");
 	writeempty("profiles/profileslot.txt");
 	writeempty("profiles/totalfileslot.txt");

 	local float writeparms;
 	local string writethis;
 	writeparms = fopen_wrath("menuversion.txt", FILE_WRITE);	//open what file to use in write mode
 	writethis = ftos(menuversion);	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	fclose_wrath(writeparms);
 	//rmtree("profiles");	
 };
void()deleteallprofiles;
void()write_totalprofileslot_updatedversion;
 void() check_menuversion = 
{
	local float readparms, localmenuversion;
 	local string readtext;
 	readparms = fopen_wrath("menuversion.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
 	readtext = fgets(readparms);	//read the text
 	localmenuversion = stof(readtext);	//turn the text into the float u want (by using stof: string to float)
 	fclose_wrath(readparms);

 	if (localmenuversion != menuversion)
	{
	write_totalprofileslot_updatedversion();
	cmd("unbind f2\n");
	cmd("unbind f3\n");
	cmd("unbind f4\n");
	cmd("unbind f5\n");
	cmd("unbind f6\n");
	cmd("unbind f7\n");
	cmd("unbind f8\n");
	cmd("unbind f9\n");
	cmd("unbind f10\n");
	cmd("unbindall\n");
	cmd("exec gamebuttons.cfg\n");
	}
 	local float writeparms;
 	local string writethis;
 	writeparms = fopen_wrath("menuversion.txt", FILE_WRITE);	//open what file to use in write mode
 	writethis = ftos(menuversion);	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	fclose_wrath(writeparms);
	
	float maxfps = cvar ("cl_maxfps");
	if((maxfps <= 0) || (maxfps > 1000))	
	cmd("cl_maxfps 1000\n");
	
 	//	deleteallprofiles();
 }


 
 
 void() refresh_mouse = {	//cvar_set("vid_conheight", ftos(cvar("vid_conwidth")*cvar("vid_height")/cvar("vid_width")));
 	//cmd("vid_conwidth 960\n");
 	//cmd("vid_conheight 540\n");
 	vid_rx = cvar("vid_conwidth");
 	vid_ry = cvar("vid_conheight");
 	mouse_pos_x = vid_rx / 2;
 	mouse_pos_y = vid_ry / 2;
 };

 void() updateMouse = 
{
	vid_rx = cvar("vid_conwidth");
 	vid_ry = cvar("vid_conheight");
 	vector raw_mouse;
 	raw_mouse = getmousepos();
 	// add some mouse acceleration 

 	local float mousesen;
 	mousesen = cvar("saved5") + 0.1;
 	raw_mouse_x = raw_mouse_x *mousesen *5;	//pow(vlen(raw_mouse), mousesen);
 	raw_mouse_y = raw_mouse_y *mousesen *5;
 	mouse_pos += raw_mouse;
 	if (mouse_pos_x < 0)
 		mouse_pos_x = 0;

 	if (mouse_pos_x > vid_rx)
 		mouse_pos_x = vid_rx;

 	if (mouse_pos_y < 0)
 		mouse_pos_y = 0;

 	if (mouse_pos_y > vid_ry)
 		mouse_pos_y = vid_ry;
 };
 string(float kn) keynumtostring_wrath;
 string(float kn) keynumtostring_wrath_f = 
{
	if (kn == 127)
 		return "space bar";
 	else
 	{
 		string n = keynumtostring_wrath(kn);
 		return n;
 	}
 };
 void() check_save = 
{
	local float readparms;
 	local string readtext;
 	readparms = fopen_wrath("adpsav.dll", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
 	if (readparms != -1)
 	{
 		readtext = fgets(readparms);	//read the text
 		checksaves = stof(readtext);	//turn the text into the float u want (by using stof: string to float)
 		fclose_wrath(readparms);
 	}
 };

 void(string nameprofile) check_profile_saves = 
{
	local float readparms;
 	local string readtext, profilename_svs;
 	profilename_svs = strcat("profiles/", nameprofile, ".frk");
 	readparms = fopen_wrath(profilename_svs, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
 	if (readparms != -1)
 	{
 		readtext = fgets(readparms);	//read the text
 		currentprofilessaves = stof(readtext);	//turn the text into the float u want (by using stof: string to float)
 		fclose_wrath(readparms);
 	}
 };

 void() check_profileslot = 
{
	local float readparms;
 	local string readtext;
 	readparms = fopen_wrath("profiles/profileslot.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
 	if (readparms != -1)
 	{
 		readtext = fgets(readparms);	//read the text
 		profileslot = stof(readtext);	//turn the text into the float u want (by using stof: string to float)
 		fclose_wrath(readparms);
 	}
 };

 float() check_profileslottotal = 
{
	local float readparms;
 	local string readtext;
 	readparms = fopen_wrath("profiles/totalfileslot.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
 	if (readparms != -1)
 	{
 		readtext = fgets(readparms);	//read the text
 		local float localprofilesammount;
 		localprofilesammount = stof(readtext);	//turn the text into the float u want (by using stof: string to float)
 		fclose_wrath(readparms);
 		return localprofilesammount;
 	}
 	else
 		return 0;
 };
 void() check_profilenames = 
{
	local float readparms;
 	local string readtext;
 	readparms = fopen_wrath("profiles/profilenames.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
 	if (readparms != -1)
 	{
 		readtext = fgets(readparms);	//read the text
 		profilename1 = (readtext);	//turn the text into the float u want (by using stof: string to float)
 		readtext = fgets(readparms);
 		profilename2 = (readtext);
 		readtext = fgets(readparms);
 		profilename3 = (readtext);
 		readtext = fgets(readparms);
 		profilename4 = (readtext);
 		readtext = fgets(readparms);
 		profilename5 = (readtext);
 		readtext = fgets(readparms);
 		profilename6 = (readtext);
 		readtext = fgets(readparms);
 		profilename7 = (readtext);
 		readtext = fgets(readparms);
 		profilename8 = (readtext);
 		readtext = fgets(readparms);
 		profilename9 = (readtext);
 		readtext = fgets(readparms);
 		profilename10 = (readtext);
 		readtext = fgets(readparms);
 		profilename11 = (readtext);
 		readtext = fgets(readparms);
 		profilename12 = (readtext);
 		fclose_wrath(readparms);
 	}
 };

 void(float nprofile) check_profilenames_str = 
{
	check_profilenames();
 	if (nprofile == 1) profilename = strzone(profilename1);
 	if (nprofile == 2) profilename = strzone(profilename2);
 	if (nprofile == 3) profilename = strzone(profilename3);
 	if (nprofile == 4) profilename = strzone(profilename4);
 	if (nprofile == 5) profilename = strzone(profilename5);
 	if (nprofile == 6) profilename = strzone(profilename6);
 	if (nprofile == 7) profilename = strzone(profilename7);
 	if (nprofile == 8) profilename = strzone(profilename8);
 	if (nprofile == 9) profilename = strzone(profilename9);
 	if (nprofile == 10) profilename = strzone(profilename10);
 	if (nprofile == 11) profilename = strzone(profilename11);
 	if (nprofile == 12) profilename = strzone(profilename12);
 };

 string c_profilename1;
 string c_profilename2;
 string c_profilename3;
 string c_profilename4;
 string c_profilename5;
 string c_profilename6;
 string c_profilename7;

 void() check_profilenames_str2 = 
{
	check_profilenames();
 	c_profilename1 = strzone(profilename1);
 	c_profilename2 = strzone(profilename2);
 	c_profilename3 = strzone(profilename3);
 	c_profilename4 = strzone(profilename4);
 	c_profilename5 = strzone(profilename5);
 	c_profilename6 = strzone(profilename6);
 	c_profilename7 = strzone(profilename7);
 };

 void() write_save = 
{
	local float writeparms;
 	local string writethis;
 	writeparms = fopen_wrath("adpsav.dll", FILE_WRITE);	//open what file to use in write mode
 	writethis = ftos(1);	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	fclose_wrath(writeparms);
 };

 void() write_currentprofileslot = 
{
	check_profilenames_str(profileslot);
 	local float writeparms;
 	local string writethis;
 	writeparms = fopen_wrath("profiles/currentprofileslot.txt", FILE_WRITE);	//open what file to use in write mode
 	writethis = ftos(profileslot);	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	writethis = profilename;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename;
 	fclose_wrath(writeparms);
 	if (profilename != "")
 		strunzone(profilename);
 };

 void() write_totalprofileslot = 
{
	local float writeparms;
 	local string writethis;
 	writeparms = fopen_wrath("profiles/totalfileslot.txt", FILE_WRITE);	//open what file to use in write mode
 	writethis = ftos(profilesammount);	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	fclose_wrath(writeparms);
 };

 void() write_totalprofileslot_updatedversion = 
{
	local float writeparms;
 	check_profileslot();
	local string writethis;
 	writeparms = fopen_wrath("profiles/totalfileslot.txt", FILE_WRITE);	//open what file to use in write mode
 	writethis = ftos(profileslot);	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	fclose_wrath(writeparms);
 };


 void() write_currentprofileslotfirsttime = 
{
	check_profilenames_str(profileslot);
 	local float profilenamef;
 	local string profilenamestring;
 	profilenamestring = strcat("profiles/", profilename, ".frk");
 	profilenamef = fopen_wrath(profilenamestring, FILE_WRITE);	//open what file to use in write mode
 	fputs(profilenamef, "0\n");	//and again
 	fclose_wrath(profilenamef);
 	if (profilename != "")
 		strunzone(profilename);
 	write_currentprofileslot();
 };
 
 void() write_menuversion = 
{
	check_profilenames_str(profileslot);
 	local float profilenamef;
 	local string profilenamestring;
 	profilenamestring = strcat("profiles/", profilename,"/menu.version");
 	profilenamef = fopen_wrath(profilenamestring, FILE_WRITE);	//open what file to use in write mode
	local float writeparms;
 	local string writethis; 	
 	writethis = ftos (menuversion);
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	if (profilename != "")
 		strunzone(profilename);
 };
 
 void() write_profileslot = 
{
	local float writeparms;
 	local string writethis;
 	writeparms = fopen_wrath("profiles/profileslot.txt", FILE_WRITE);	//open what file to use in write mode
 	writethis = ftos(profileslot);	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	fclose_wrath(writeparms);
 };

 void() write_profilenames = 
{
	local float writeparms;
 	local string writethis;
 	writeparms = fopen_wrath("profiles/profilenames.txt", FILE_WRITE);	//open what file to use in write mode
 	writethis = profilename1;	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	writethis = profilename2;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename3;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename4;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename5;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename6;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename7;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename8;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename9;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename10;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename11;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	writethis = profilename12;
 	fputs(writeparms, writethis);
 	fputs(writeparms, "\n");
 	fclose_wrath(writeparms);
 };

 void() check_profilemenuversion = 
 { 
	check_profilenames_str(profileslot);
 	local float profilenamef;
 	local string profilenamestring;
 	profilenamestring = strcat("profiles/", profilename,"/menu.version");
 	profilenamef = fopen_wrath(profilenamestring, FILE_READ);	//open what file to use in write mode
 	local string readtext;
 	local float readparms;
 	readtext = fgets(readparms);	//read the text
 	profilemenuversion = stof(readtext);	//turn the text into the float u want (by using stof: string to float)
 	fclose_wrath(readparms);
 	if (profilename != "")
 		strunzone(profilename);
 };
 
 void() m_init = 
{
	
 

	precache_menu_files();

	check_menuversion();
 	cmd("exec start.cfg\n");
 	vid_wres = cvar("vid_width");
 	vid_hres = cvar("vid_height");
 	string consize_w, consize_h;
 	consize_w = ftos(vid_wres / 2);
 	consize_h = ftos(vid_hres / 2);
 	cmd(strcat("vid_conheight ", consize_h, " \n"));
 	cmd(strcat("vid_conwidth ", consize_w, " \n"));

	float checked1;
 	checked1 = cvar("saved2");
 	if(!checked1)
 		cmd("gl_texturemode gl_nearest\n");
 	if(checked1 == 1)
 		cmd("gl_texturemode gl_nearest_mipmap_linear\n");
 	if(checked1 == 2)
 		cmd("gl_texturemode gl_linear_mipmap_linear\n");		
	float checked2;
 	checked2 = cvar("saved7");
 	if (checked2 == 2)
 		cmd("cl_rollangle 2\n");
 	else
 		cmd("cl_rollangle 0\n");
			
 	cmd("set cvar_restoregame 0\n");
 	cmd("scratch3 0\n");
 	refresh_mouse();
 	Menu_Active = false;
 	cmd("play2 cdtracks/track006\n");
 	precache_file("gfx/help");
 	precache_file("gfx/credits");
 	precache_sound("musica/menu.ogg");
 	precache_sound("menu1.wav");
 	//	check_save();
 	check_profileslot();
 	//	check_profilenames();
 };

 void() remove_tether = 
{
	local float writeparms;
 	local string writethis;
 	read_currentprofileslot();
 	local string campaignloc;
 	campaignloc = strcat("profiles/", profilename, "/tether.txt");

 	writeparms = fopen_wrath(campaignloc, FILE_WRITE);	//open what file to use in write mode
 	writethis = ftos(0);	//prepare the next thing to write
 	fputs(writeparms, writethis);	//line 1
 	fputs(writeparms, "\n");	//and again
 	fclose_wrath(writeparms);
 };

 void() m_init2 = 
{
	refresh_mouse();
 	time = gettime();
 	cmd("play2 cdtracks/track006\n");
 	check_save();
 }

 void() m_main = 
{
	cmd("\n disconnect \n");
 	menutype = M_TYPE_NONE;
 	m_toggle(1);
 	m_init2();
 	selected_option = 0;
 }

 void(string s) GameCommand = 
{
	if (s == "backtomainmenu")
 		callfunction("m_main");
 };

 float releasedmouse;
 float mousereleased;
float mouse1_held;
 void(float key, float ascii) m_keyup = 
{
	float deadmenu;
 	deadmenu = cvar("scratch3");

 	if (key == K_MOUSE1)
 		{
		releasedmouse = 1;
		mouse1_held = 0;
		}
 };

 string gah;
 float menuingame;
 float zmenuingame;

 void() restart_consize = 
{
	vid_wres = cvar("vid_width");
 	vid_hres = cvar("vid_height");
 	string consize_w, consize_h;
 	consize_w = ftos(vid_wres / 2);
 	consize_h = ftos(vid_hres / 2);
 	cmd(strcat("vid_conheight ", consize_h, " \n"));
 	cmd(strcat("vid_conwidth ", consize_w, " \n"));
 	refresh_mouse();
 };


vector mystringpos;
vector fill_vector;
 
string(float keynum) keynumtostring_wrath =
{
	local string key;
	key = keynumtostring(keynum);
	return key;
};


 float last_selected_option;
 float mouseactive;
 void(float key, float ascii) m_keydown = 
{
	float deadmenu;
 	deadmenu = cvar("scratch3");
 	if (deadmenu)
	 {
	 if (key == K_ESCAPE)
  		string bindcmd = ("impulse 90\n");
 		cmd(bindcmd);
		return;
	}
 	if (key >= K_MOUSE1)
 	{
	mouse1_held = 1;
	}	
		
 	if (key == K_ESCAPE)
 	{
 		localsound("sounds/menu.wav");

 		if (menutype == M_TYPE_PROFILE)
 		{
 			menutype = M_TYPE_NONE;
 			if (gah != "")
 				strunzone(gah);
 			gah = "";
 		}

 		if ((isserver() || (clientstate() == CS_CONNECTED)) && (zmenuingame == 1))	// don't back out to console only
 			m_hide();
 		if ((menutype == M_TYPE_OPTIONS) || (menutype == M_TYPE_RESUME))
 		{
 			menutype = M_TYPE_NONE;
 			zmenuingame = 1;
 		}

 		if ((menutype == M_TYPE_AUDIO) || (menutype == M_TYPE_VIDEO) || (menutype == M_TYPE_CONTROLS) || (menutype == M_TYPE_CONTROLBINDS) || (menutype == M_TYPE_GAMEPLAY))
 			menutype = M_TYPE_OPTIONS;
 		if (menutype == M_TYPE_RESOLUTION)
 		{
 			menutype = M_TYPE_OPTIONS;
 			restart_consize();
 		}

 		if (menutype == M_TYPE_CONFIRMBIND)
 			menutype = M_TYPE_CONTROLS;
 		//if((menutype == M_TYPE_HELP) || (menutype == M_TYPE_CREDITS) || (menutype == M_TYPE_PROFILE) ||)
 		enterindex = 0;
 	}

 	if (menutype == M_YNQ)
 	{
 		if (ascii == 'y' || ascii == 'Y')
 			cmd("\nquit\n");
 		if ((ascii == 'n' || ascii == 'N') || (key == K_ESCAPE))
 			menutype = M_TYPE_NONE;
 	}

 	/*
 		if(menutype == M_TYPE_NONE)
 		{
 			if(ascii == 'y' || ascii == 'Y')
 			{
 				menutype = M_TYPE_NONE;
 				cmd("\n disconnect \n");
 				m_init2();
 			}

 			if((ascii == 'n' || ascii == 'N') || (key == K_ESCAPE))
 				menutype = M_TYPE_NONE;
 		}		
 	*/
 	if (menutype == M_YND)
 	{
 		if (ascii == 'y' || ascii == 'Y')
 		{
 			menutype = M_TYPE_NONE;
 			cmd("\n disconnect \n");
 			m_init2();
 		}

 		if ((ascii == 'n' || ascii == 'N') || (key == K_ESCAPE))
 			menutype = M_TYPE_NONE;
 	}

 	if (key == K_MOUSE1)
 	{
 		
	if(menutype == M_TYPE_CONFIRMBIND)
	{
		last_selected_option = 0;
		mouseactive = 0;
		selected_option = 0;
	}

		if ((clientstate() == CS_CONNECTED) && (menuingame == 1))
 			return;
 		time = gettime();

		
 		check_keys(selected_option, 0);

 		if (mousereleased == 0)
 		{
 			mousereleased = 1;
 			releasedmouse = 0;
 		}
 	}

 	if ((key == K_KP_ENTER) || (key == K_ENTER))
 	{
 		if ((clientstate() == CS_CONNECTED) && (menuingame == 1))
 			return;
 		time = gettime();
 		if (enterindex)
 			check_keys(enterindex, 1);

 	}

 	if (menutype == M_TYPE_PROFILE)
 	{
 		string theline;
 		theline = gah;
 		if ((ascii >= 48) && (ascii <= 57) || (ascii >= 65) && (ascii <= 90) || (ascii >= 97) && (ascii <= 122))
 		{
 			if (strlen(theline) < 16)
 				theline = strzone(strcat(theline, chr2str(ascii)));
 		}

 		if (key == K_BACKSPACE)
 		{
 			float theline_len, theline_end;
 			theline_len = strlen(theline) *-1;
 			theline_end = strlen(theline) - 1;
 			if (strlen(theline) > 0)
 				theline = strzone(substring(theline, theline_len, theline_end));
 			else
 				theline = "";
 		}

 		selected_option = 0;
 		gah = theline;
 	}

 	if (menutype == M_TYPE_CONFIRMBIND)
 	{
 		string localkey;
 		if (gkcommand == 1) localkey = "+forward";
 		if (gkcommand == 2) localkey = "+back";
 		if (gkcommand == 3) localkey = "+moveleft";
 		if (gkcommand == 4) localkey = "+moveright";
 		if (gkcommand == 5) localkey = "+attack";
 		if (gkcommand == 6) localkey = "+button3";
 		if (gkcommand == 7) localkey = "+button6";
 		if (gkcommand == 8) localkey = "+jump";
 		if (gkcommand == 9) localkey = "+button4";	//crouch  508
 		if (gkcommand == 10) localkey = "impulse 1";
 		if (gkcommand == 11) localkey = "impulse 2";
 		if (gkcommand == 12) localkey = "impulse 3";
 		if (gkcommand == 13) localkey = "impulse 4";	// 512
 		if (gkcommand == 14) localkey = "impulse 5";
 		if (gkcommand == 15) localkey = "impulse 6";
 		if (gkcommand == 16) localkey = "impulse 7";
 		if (gkcommand == 17) localkey = "impulse 8";	// 516
 		if (gkcommand == 18) localkey = "impulse 9";
 		if (gkcommand == 19) localkey = "+button5";	//use
 		if (gkcommand == 20) localkey = "impulse 35";	//journal
 		if (gkcommand == 21) localkey = "impulse 15";	//artifact
 		if (gkcommand == 22) localkey = "+moveup";	// 521
 		if (gkcommand == 23) localkey = "+movedown";
 		if (gkcommand == 24) localkey = "impulse 57";	// last weapon
 		if (gkcommand == 25) localkey = "impulse 55";
 		if (gkcommand == 26) localkey = "impulse 56";	// 525
 		if (gkcommand == 27) localkey = "+button7";	// 527
 		if (gkcommand == 28) localkey = "impulse 81";	// 527
 		if (gkcommand == 29) localkey = "impulse 89";	// 528

 		if (!releasedmouse)
 			return;

 		if (key == K_ESCAPE)
 			return;

 		//		keybind = ascii;	

 		//		if(key == K_MOUSE1)
 		keybind = key;
 		tokenize(findkeysforcommand(localkey, 0));
 	if (stof(argv(0)) == keybind)
 		{
 			menutype = M_TYPE_CONTROLBINDS;
 			return;
		}
		
			if(stof(argv(0)) != -1)
 			cmd(strcat("unbind ", keynumtostring_wrath(stof(argv(0))), "\n"));
			if(stof(argv(1)) != -1)
 			cmd(strcat("unbind ", keynumtostring_wrath(stof(argv(1))), "\n"));
			if(stof(argv(2)) != -1)
 			cmd(strcat("unbind ", keynumtostring_wrath(stof(argv(2))), "\n"));
			if(stof(argv(3)) != -1)
 			cmd(strcat("unbind ", keynumtostring_wrath(stof(argv(3))), "\n"));
			if(stof(argv(4)) != -1)
 			cmd(strcat("unbind ", keynumtostring_wrath(stof(argv(4))), "\n"));
 
			cmd(strcat("unbind ",keynumtostring_wrath(keybind), "\n"));
			cmd(strcat("in_unbind 1 ",keynumtostring_wrath(keybind), "\n"));
			cmd(strcat("in_unbind 2 ",keynumtostring_wrath(keybind), "\n"));
			cmd(strcat("in_unbind 3 ",keynumtostring_wrath(keybind), "\n"));
			cmd(strcat("in_unbind 4 ",keynumtostring_wrath(keybind), "\n"));
		
 		if (gkcommand == 10) localkey = "\"impulse 1\"";
 		if (gkcommand == 11) localkey = "\"impulse 2\"";
 		if (gkcommand == 12) localkey = "\"impulse 3\"";
 		if (gkcommand == 13) localkey = "\"impulse 4\"";	// 512
 		if (gkcommand == 14) localkey = "\"impulse 5\"";
 		if (gkcommand == 15) localkey = "\"impulse 6\"";
 		if (gkcommand == 16) localkey = "\"impulse 7\"";
 		if (gkcommand == 17) localkey = "\"impulse 8\"";	// 516
 		if (gkcommand == 18) localkey = "\"impulse 9\"";
 		if (gkcommand == 20) localkey = "\"impulse 35\"";	//journal
 		if (gkcommand == 21) localkey = "\"impulse 15\"";	//artifact
 		if (gkcommand == 24) localkey = "\"impulse 57\"";	// last weapon
 		if (gkcommand == 25) localkey = "\"impulse 55\"";
 		if (gkcommand == 26) localkey = "\"impulse 56\"";	// 525
 		if (gkcommand == 28) localkey = "\"impulse 81\"";	// 527
 		if (gkcommand == 29) localkey = "\"impulse 89\"";	// 528

		setkeybind_bindmap(keybind, localkey, 0);
		bindcmd = strcat("in_bind 0 ", keynumtostring_wrath(keybind), " ", localkey, "\n");
 		cmd(bindcmd);
 		if (keybind)
 			menutype = M_TYPE_CONTROLBINDS;
 		return;
 	}

 	//if (gah) 
 	//	strunzone(gah);
 };

 float mouseactive;

 float check_mouse(vector pos)
 {
 	local vector mins, max;
 	mins = pos;
 	max = pos + BTT_IMG_SIZE;
 	if (mouse_pos_x > mins_x && mouse_pos_x < max_x)
 	{
 		if (mouse_pos_y > mins_y && mouse_pos_y < max_y)
 		{
 			return 1;
 		}
 	}

 	return 0;
 };

 float check_mouse2(vector pos)
 {
 	local vector mins, max;
 	mins = pos;
 	max = pos + BTT_IMG_SIZE2;
 	if (mouse_pos_x > mins_x && mouse_pos_x < max_x)
 	{
 		if (mouse_pos_y > mins_y && mouse_pos_y < max_y)
 		{
 			return 1;
 		}
 	}

 	return 0;
 };

 float last_selected_option;
 float mouseactive;

 void(vector pos, string txt, float index) draw_buttionwrath = 
{
	local float txt_len;
 	local vector txt_pos;
 	local string picimage;

 	vector posfix, imgsize;
 	posfix_x = 128 * vx_rel;
 	posfix_y = 10 * vy_rel;

 	txt_pos = pos + posfix;
 	txt_len = stringwidth("NEWGAME GAME", true, BTT_FONT_SIZE);
 	txt_pos_x -= (txt_len / 2);

 	vector colorm;
 	colorm = '1 1 1';

 	if (check_mouse(pos))
 	{
 		selected_option = index;
 		last_selected_option = selected_option;
 		mouseactive = 1;
 		if (txt == "New Game")
 			picimage = "gfx/menu/begin_active.tga";
 		if (txt == "Resume")
 			picimage = "gfx/menu/resume_active.tga";
 		if (txt == "Options")
 			picimage = "gfx/menu/options_active.tga";
 		if (txt == "Quit")
 			picimage = "gfx/menu/depart_active.tga";
 		if ((txt == "Load"))
 		{
 			picimage = "gfx/menu/load_game_active2.tga";
 			//colorm = '1.25 0.5 0.5';
 		}
 		if ((txt == "Delete"))
 		{
 			picimage = "gfx/menu/delete_profile_active.tga";
 		}
 	}
 	else
 	{
 		if ((last_selected_option == index) && (mouseactive == 1))
 		{
 			last_selected_option = 0;
 			mouseactive = 0;
 			selected_option = 0;
 		}

 		if (txt == "New Game")
 			picimage = "gfx/menu/begin.tga";
 		if (txt == "Resume")
 			picimage = "gfx/menu/resume.tga";
 		if (txt == "Options")
 			picimage = "gfx/menu/options.tga";
 		if (txt == "Quit")
 			picimage = "gfx/menu/depart.tga";
 		if (txt == "Load")
 			picimage = "gfx/menu/load_game_active.tga";
 		if (txt == "Delete")
 			picimage = "gfx/menu/delete_profile.tga";
 	}

 	imgsize_x = rint(192 *vx_rel);
 	imgsize_y = rint(48 *vx_rel);

 	vector local_imgsize;
 	if ((index == 7) || (index == 16))
 		local_imgsize = fixed_vector2('152 40 0');
 	else
 		local_imgsize = imgsize;

 	drawpic(txt_pos, picimage, local_imgsize, colorm, 1, 0);
 };

 float check_mouse_f(vector pos, vector pos2)
 {
 	vector mins, max;
 	mins = pos;
 	max = pos2;
 	mins -= fixed_vector('32 16 0');
 	max += fixed_vector('0 8 0');

 	if (mouse_pos_x > mins_x && mouse_pos_x < max_x)
 	{
 		if ((mouse_pos_y > mins_y) && (mouse_pos_y < max_y))
 			return 1;
 	}

 	return 0;
 };
 
 float check_mouse_c(vector pos, vector pos2)
 {
 	local vector mins, max;
 	mins = pos;
 	max = pos2;
 	mins -= fixed_vector('24 24 0');
 	max += fixed_vector('8 -16 0');

 	if (mouse_pos_x > mins_x && mouse_pos_x < max_x)
 	{
 		if ((mouse_pos_y > mins_y) && (mouse_pos_y < max_y))
 			return 1;
 	}

 	return 0;
 };

 float check_mouse_d(vector pos, vector pos2)
 {
 	local vector mins, max;
 	mins = pos;
 	max = pos2;

 	mins -= fixed_vector('12 16 0');
 	max += fixed_vector('12 0 0');

 	if (mouse_pos_x > mins_x && mouse_pos_x < max_x)
 	{
 		if ((mouse_pos_y > mins_y) && (mouse_pos_y < max_y))
 			return 1;
 	}

 	return 0;
 };

 float check_mouse_e(vector pos, vector pos2)
 {
 	local vector mins, max;
 	mins = pos;
 	max = pos2;

 	mins -= fixed_vector('24 20 0');
 	max += fixed_vector('0 -8 0');

 	if (mouse_pos_x > mins_x && mouse_pos_x < max_x)
 	{
 		if ((mouse_pos_y > mins_y) && (mouse_pos_y < max_y))
 			return 1;
 	}

 	return 0;
 };

 float last_selected_option2;
 void draw_buttionprofile(vector pos, string txt, float nprof_local)
 {
 	local float txt_len, alpha;
 	local vector txt_pos, pos2;
 	txt_pos = pos + fixed_vector('128 10 0');
 	txt_len = stringwidth(txt, true, fixed_vector('12 12 0'));
 	txt_pos_x -= (txt_len / 2);
 	local vector cb, bfont;
 	pos = txt_pos;
 	pos2 = pos + fixed_vector('12 12 0');
 	pos2_x = pos_x + txt_len;
 	vector filllip;

 	if ((check_mouse_e(pos, pos2)) && (profileslotpage != nprof_local))
 	{
 		selected_option = 5;
 		nprof = nprof_local;
 		last_selected_option2 = nprof_local;
 		mouseactive = 1;

 	}
 	else
 	{
 		if (last_selected_option2 == nprof_local)
 		{
 			last_selected_option2 = 0;
 			mouseactive = 0;
 			selected_option = 0;
 		}
 	}

 	if ((last_selected_option2 == nprof_local) && (mouseactive == 1))
 	{
 		cb = '4 4 0.5';
 		bfont = fixed_vector('12 12 0');
 		//txt_pos_x -= txt_len *0.125;
 		alpha = 1;
 		filllip = fixed_vector('0 0 0');
 	}
 	else
 	{
 		bfont = fixed_vector('12 12 0');
 		cb = '-1 -1 -1';
 		alpha = 0.75;
 		filllip = '0 0 0';
 	}

 	if (profileslotpage == nprof_local)
 	{
 		bfont = fixed_vector('12 12 0');
 		cb = '2 2 2';
 		alpha = 1;
 		filllip = '0 0 0';
 	}

 	drawstring(txt_pos, txt, bfont, cb, alpha, 0);

 };
 float last_selected_option3;
 void draw_buttionload(vector pos, string txt, float nprof_local)
 {
 	local float txt_len, alpha;
 	local vector txt_pos, pos2;
 	txt_pos = pos + fixed_vector('128 10 0');
 	txt_len = stringwidth(txt, true, fixed_vector('12 12 0'));
 	txt_pos_x -= (txt_len / 2);
 	local vector cb, bfont;
 	pos = txt_pos;
 	pos2 = pos + fixed_vector('12 12 0');
 	pos2_x = pos_x + txt_len;
 	vector filllip;

 	if ((check_mouse_c(pos, pos2)) && (type_load_selected != nprof_local))
 	{
 		selected_option = 6;
 		number_load_selected = nprof_local;
 		last_selected_option3 = nprof_local;
 		mouseactive = 1;

 	}
 	else
 	{
 		if (last_selected_option3 == nprof_local)
 		{
 			last_selected_option3 = 0;
 			mouseactive = 0;
 			selected_option = 0;
 		}
 	}

 	if ((last_selected_option3 == nprof_local) && (mouseactive == 1))
 	{
 		cb = '4 4 0.5';
 		bfont = fixed_vector('12 12 0');
 		//txt_pos_x -= txt_len *0.125;
 		alpha = 1;
 		filllip = fixed_vector('0 0 0');
 	}
 	else
 	{
 		bfont = fixed_vector('12 12 0');
 		cb = '-1 -1 -1';
 		alpha = 0.75;
 		filllip = '0 0 0';
 	}

 	if (type_load_selected == nprof_local)
 	{
 		bfont = fixed_vector('12 12 0');
 		cb = '2 2 2';
 		alpha = 1;
 		filllip = '0 0 0';
 	}

 	drawstring(txt_pos, txt, bfont, cb, alpha, 0);

 };
 void draw_buttion(vector pos, string txt, float index)
 {
 	local float txt_len, alpha;
 	local vector txt_pos, pos2;
 	txt_pos = pos + fixed_vector('128 10 0');

 	vector FONT_SIZE;

 	if ((index >= 7) && (index <= 9))
	{
	if (smallbuttons == 1)
 	FONT_SIZE = ('10 10 0');
	else
 	FONT_SIZE = ('16 16 0');
	}

 	else
 		FONT_SIZE = BTT_FONT_SIZE;

 	if ((index >= 500) && (index <= 528))
	{
		if (smallbuttons == 1)
			FONT_SIZE= fixed_vector('10 10 0');
		else
		{
		 if (menutype == M_TYPE_CONTROLS)
			FONT_SIZE = fixed_vector('12.7 12.7 0');
		else
			FONT_SIZE = fixed_vector('16 16 0');
		}
	}

 	txt_len = stringwidth(txt, true, FONT_SIZE);
 	txt_pos_x -= (txt_len / 2);
 	local vector cb, bfont;

 	pos = txt_pos;
 	pos2 = pos + FONT_SIZE;
 	pos2_x = pos_x + txt_len;

 	if ((index >= 250) && (index <= 277))
 	{
 		float selectedres;
 		vid_rx = cvar("vid_width");
 		vid_ry = cvar("vid_height");
 		if ((vid_rx == 1280) && (vid_ry == 960)) selectedres = 250;
 		if ((vid_rx == 1360) && (vid_ry == 1024)) selectedres = 251;
 		if ((vid_rx == 1600) && (vid_ry == 1200)) selectedres = 252;
 		if ((vid_rx == 1920) && (vid_ry == 1440)) selectedres = 253;
 		if ((vid_rx == 2560) && (vid_ry == 1920)) selectedres = 254;
 		if ((vid_rx == 1280) && (vid_ry == 768)) selectedres = 255;
 		if ((vid_rx == 1280) && (vid_ry == 1024)) selectedres = 256;
 		if ((vid_rx == 1600) && (vid_ry == 1280)) selectedres = 257;
 		if ((vid_rx == 2560) && (vid_ry == 2048)) selectedres = 258;
 		if ((vid_rx == 1280) && (vid_ry == 720)) selectedres = 259;
 		if ((vid_rx == 1360) && (vid_ry == 768)) selectedres = 260;
 		if ((vid_rx == 1366) && (vid_ry == 768)) selectedres = 261;
 		if ((vid_rx == 1600) && (vid_ry == 900)) selectedres = 262;
 		if ((vid_rx == 1680) && (vid_ry == 1050)) selectedres = 263;
 		if ((vid_rx == 1920) && (vid_ry == 1080)) selectedres = 264;
 		if ((vid_rx == 2560) && (vid_ry == 1440)) selectedres = 265;
 		if ((vid_rx == 3840) && (vid_ry == 2160)) selectedres = 266;
 		if ((vid_rx == 1280) && (vid_ry == 800)) selectedres = 267;
 		if ((vid_rx == 1440) && (vid_ry == 900)) selectedres = 268;
 		if ((vid_rx == 1920) && (vid_ry == 1200)) selectedres = 269;
 		if ((vid_rx == 2560) && (vid_ry == 1600)) selectedres = 270;
 		if ((vid_rx == 3840) && (vid_ry == 2400)) selectedres = 271;
 		if ((vid_rx == 2560) && (vid_ry == 1080)) selectedres = 272;
 		if ((vid_rx == 3440) && (vid_ry == 1440)) selectedres = 273;
 		if ((vid_rx == 5120) && (vid_ry == 2160)) selectedres = 274;
 		if ((vid_rx == 4096) && (vid_ry == 2160)) selectedres = 275;

 		if (index == selectedres)
 		{
 			bfont = FONT_SIZE;
 			cb = '3 0 0';
 			alpha = 1;
 			drawstring(txt_pos, txt, bfont, cb, alpha, 0);
 			return;
 		}

 		pos2_y = pos2_y - 4;
 	}

 	vector text_lenght, filllip;

 	if ((index >= 250) && (index <= 277))
 	{
 		if (check_mouse_d(pos, pos2))
 		{
 			selected_option = index;
 			last_selected_option = selected_option;
 			mouseactive = 1;

 		}
 		else
 		{
 			if (last_selected_option == index)
 			{
 				last_selected_option = 0;
 				mouseactive = 0;
 				selected_option = 0;
 			}
 		}
 	}
 	else if (((index >= 105) && (index <= 109)) || ((index == 320) || (index == 290)))
 	{
 		if (check_mouse_e(pos, pos2))
 		{
 			selected_option = index;
 			last_selected_option = selected_option;
 			mouseactive = 1;

 		}
 		else
 		{
 			if (last_selected_option == index)
 			{
 				last_selected_option = 0;
 				mouseactive = 0;
 				selected_option = 0;
 			}
 		}
 	}
 	else
 	{
 		if (check_mouse_c(pos, pos2))
 		{
 			selected_option = index;
 			last_selected_option = selected_option;
 			mouseactive = 1;

 		}
 		else
 		{
 			if (last_selected_option == index)
 			{
 				last_selected_option = 0;
 				mouseactive = 0;
 				selected_option = 0;
 			}
 		}
 	}

 	if ((selected_option == index) && (mouseactive == 1))
 	{
 		if ((index >= 500) && (index <= 528))
 			cb = '7 7 7';
 		else
 			cb = '4 4 2';
 		if ((index < 7) && (index > 9))
 		{
 			bfont = FONT_SIZE + fixed_vector('2 2 0');
 			filllip = fixed_vector('10 0 0');
 		}
 		else
 		{
 			bfont = FONT_SIZE;
 			filllip = '0 0 0';
 		}

 		//txt_pos_x -= txt_len *0.125;
 		alpha = 1;
 	}
 	else
 	{
 		bfont = FONT_SIZE;
 		if ((index >= 500) && (index <= 528))
 			cb = '1 1 1';
 		else
 			cb = '2 1.5 1.5';
 		alpha = 0.7;
 		filllip = '0 0 0';
 	}

 	if ((index >= 250) && (index <= 277))
 	{
 		text_lenght_x = txt_len;
 		text_lenght_y = bfont_y;
 		drawfill(txt_pos + '0 0 0', text_lenght + filllip, '0.5 0.5 0.5', 0.25, 0);
 	}

 	if ((index >= 500) && (index <= 528))
 	{
 		text_lenght_x = txt_len;
 		text_lenght_y = 12;
 		drawfill(txt_pos + '0 -2 0', text_lenght + filllip, '0.75 0.7 0.5', alpha *0.25, 0);
 		text_lenght_y = 1;
 		drawfill(txt_pos + '0 -2 0', text_lenght + filllip, '1 0.9 0.75', alpha *0.35, 0);
 		text_lenght_y = 1;
 		drawfill(txt_pos + '0 10 0', text_lenght + filllip, '0.35 0.35 0.35', alpha *0.35, 0);
 	}

 	drawstring(txt_pos, txt, bfont, cb, alpha, 0);

 };

 void draw_fbuttion(vector pos, string txt)
 {
 	local float txt_len, alpha;
 	local vector txt_pos, bfont, cb;
 	txt_pos = pos + fixed_vector ('128 10 0');

	vector localfontsize;
	if (menutype != M_TYPE_VIDEO)
		localfontsize = BTT_FONT_SIZE; 
	else
		localfontsize = fixed_vector('12 12 0');	

 	txt_len = stringwidth(txt, true, localfontsize);
 	txt_pos_x -= (txt_len / 2);

 	bfont = (localfontsize);
 	cb = '0.5 0.5 0.25';
 	alpha = 0.75;
 	drawstring(txt_pos, txt, bfont, cb, alpha, 0);

 };
  float slayeralpha;
  vector vectorwhite;
  vector vectorred;
  void draw_fbuttion_warning(vector pos, string txt)
 {
 	local float txt_len, alpha;
 	local vector txt_pos, bfont, cb;
 	txt_pos = pos + fixed_vector('128 10 0');
	vector LOC_FONT_SIZE = fixed_vector('12 12 0');
 	txt_len = stringwidth(txt, true, LOC_FONT_SIZE);
 	txt_pos_x -= (txt_len / 2);

 	bfont = LOC_FONT_SIZE;
 	cb = vectorwhite;
	if(slayeralpha > 0.5)
 	cb = vectorred;
	//cb = '8 4 4';

 	alpha = 1;
 	drawstring(txt_pos, txt, bfont, cb, alpha, 0);

 };
 void draw_fbuttionsmall(vector pos, string txt, float index)
 {
 	local float txt_len, alpha;
 	local vector txt_pos, bfont, cb;
 	txt_pos = pos + fixed_vector('128 10 0');
	if (smallbuttons == 1)
 	bfont = fixed_vector('10 10 0');
	else
	{
	 if (menutype == M_TYPE_CONTROLS)
 	bfont = fixed_vector('12.7 12.7 0');
	else
 	bfont = fixed_vector('16 16 0');
	}

 	txt_len = stringwidth(txt, true,bfont);
 	txt_pos_x -= (txt_len / 2);


 	if ((selected_option == index) && (index > 0))
 	{
 		cb = '9 9 0.9';
 		alpha = 1;
 	}
 	else
 	{
 		cb = '0.5 0.5 0.5';

 		alpha = 0.75;
 	}

 	drawstring(txt_pos, txt, bfont, cb, alpha, 0);

 };

 void(float commandnumber)order_fill;
void drawfilldraggeable (vector pos, vector size, vector col, float alph, float rflag, float draggable_index, float order_a, float order_b, float fixed_x)
{ 
	 vector lmouse_pos;

	lmouse_pos	= mouse_pos + fixed_vector ('10 0 0');
	if (check_mouse_f (pos, pos))
	{
		col = '4 4 3';
		draggable_select = draggable_index;
		olddraggable_select = draggable_select;
		draggable_select_vector = fixed_vector(pos);
	}
	else
	{
		if(olddraggable_select == draggable_select)
		{
			if(!mouse1_held)
			draggable_select = 0;
		}	
	}
	 
	 fixed_x = fixed_x * vx_rel;

	 
	if(draggable_select == draggable_index) 
	{
		if(mouse1_held)
		{
			if((lmouse_pos_x > pos_x + fixed_x )) 
			{	
				order_fill(order_b);
			}	
			if((lmouse_pos_x < pos_x - fixed_x)) 
			{
				if (lmouse_pos_x ) 
				{	
					order_fill (order_a);
				}
			}
		}
		col = '4 4 3';
	}	 
	drawfill(pos, size, col,alph, rflag);
}; 
 void draw_fbuttion3(vector pos, string txt)
 {
 	local float txt_len, alpha;
 	local vector txt_pos, bfont, cb, text_lenght;
 	txt_pos = pos + fixed_vector('128 10 0');
 	txt_len = stringwidth(txt, true, (BTT_FONT_SIZE));
 	txt_pos_x -= (txt_len / 2);

 	bfont =  (BTT_FONT_SIZE);
 	cb = '1 1 0.5';
 	alpha = 1;
 	drawstring(txt_pos, txt, bfont, cb, alpha, 0);
 	cb = '0.5 0.5 0.25';
 	text_lenght_x = txt_len;
 	text_lenght_y = 2;
 	alpha = 0.5;
 	drawfill(txt_pos + fixed_vector('0 16 0'), text_lenght, cb, alpha, 0);
 	//	drawfill (buttions_locs ,'256 4 0', '0.5 0.5 0.35', 0.7, 0);

 };

 void draw_fbuttion2(vector pos, string txt)
 {
 	local float txt_len, alpha;
 	local vector txt_pos, bfont, cb;
 	txt_pos = pos + fixed_vector('128 10 0');
 	txt_len = stringwidth(txt, true,  fixed_vector('8 8 8'));
 	txt_pos_x -= (txt_len / 2);

 	bfont =  fixed_vector('12 12 0');
 	cb = '0.5 0.5 0.25';
 	alpha = 0.75;
 	drawstring(txt_pos, txt, bfont, cb, alpha, 0);

 };
void (string filename)wrath_fremove =
{

if (fexists(strcat ("data/",filename)))
{
fremove(filename);
dprint(strcat(filename, " DELETED \n"));
}
else
dprint(strcat(filename, " notfound \n"));
} 


void(string repeatedprofilename) remove_all_repeated_data = {
	string frk = strcat("profiles/", repeatedprofilename, ".frk");
	wrath_fremove(frk);

	string versionfile = strcat("profiles/", repeatedprofilename, "/menu.version");
	string frikparmskp1 = strcat("profiles/", repeatedprofilename, "/frikparms.kp1");
	string shrinetxt = strcat("profiles/", repeatedprofilename, "/shrine.txt");
	string tethertxt = strcat("profiles/", repeatedprofilename, "/tether.txt");
	string tetherclienttxt = strcat("profiles/", repeatedprofilename, "/tetherclient.txt");
	wrath_fremove(versionfile);
	wrath_fremove(frikparmskp1);
	wrath_fremove(shrinetxt);
	wrath_fremove(tethertxt);
	wrath_fremove(tetherclienttxt);

	local string auto_sav, tether_sav, shrine_sav;
	auto_sav = strcat("profiles/", repeatedprofilename, "/autosave.sav");
	tether_sav = strcat("profiles/", repeatedprofilename, "/tether.sav");
	shrine_sav = strcat("profiles/", repeatedprofilename, "/shrine.sav");
	wrath_fremove(auto_sav);
	wrath_fremove(tether_sav);
	wrath_fremove(shrine_sav);


	string autosave_screenshot = strcat("profiles/", repeatedprofilename, "/autosave.png");
	string tether_screenshot = strcat("profiles/", repeatedprofilename, "/tether.png");
	string shrine_screenshot = strcat("profiles/", repeatedprofilename, "/shrine.png");

	wrath_fremove(autosave_screenshot);
	wrath_fremove(tether_screenshot);
	wrath_fremove(shrine_screenshot);

	string profile_dates = strcat("profiles/", repeatedprofilename, "/dates.txt");

	local string hub1map, e1m1map, e1m2map, e1m3map, e1m4map, e1m5map;
	hub1map = strcat("profiles/", repeatedprofilename, "/maps/hub1.sav");
	e1m1map = strcat("profiles/", repeatedprofilename, "/maps/e1m1.sav");
	e1m2map = strcat("profiles/", repeatedprofilename, "/maps/e1m2.sav");
	e1m3map = strcat("profiles/", repeatedprofilename, "/maps/e1m3.sav");
	e1m4map = strcat("profiles/", repeatedprofilename, "/maps/e1m4.sav");
	e1m5map = strcat("profiles/", repeatedprofilename, "/maps/e1m5.sav");
	wrath_fremove(hub1map);
	wrath_fremove(e1m1map);
	wrath_fremove(e1m2map);
	wrath_fremove(e1m3map);
	wrath_fremove(e1m4map);
	wrath_fremove(e1m5map);

	local string hub1stat, e1m1stat, e1m2stat, e1m3stat, e1m4stat, e1m5stat;
	hub1stat = strcat("profiles/", repeatedprofilename, "/maps/hub1.stats");
	e1m1stat = strcat("profiles/", repeatedprofilename, "/maps/e1m1.stats");
	e1m2stat = strcat("profiles/", repeatedprofilename, "/maps/e1m2.stats");
	e1m3stat = strcat("profiles/", repeatedprofilename, "/maps/e1m3.stats");
	e1m4stat = strcat("profiles/", repeatedprofilename, "/maps/e1m4.stats");
	e1m5stat = strcat("profiles/", repeatedprofilename, "/maps/e1m5.stats");
	wrath_fremove(hub1stat);
	wrath_fremove(e1m1stat);
	wrath_fremove(e1m2stat);
	wrath_fremove(e1m3stat);
	wrath_fremove(e1m4stat);
	wrath_fremove(e1m5stat);

	local string hub1map_shrine, e1m1map_shrine, e1m2map_shrine,e1m3map_shrine, e1m4map_shrine, e1m5map_shrine;
	hub1map_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/hub1.sav");
	e1m1map_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m1.sav");
	e1m2map_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m2.sav");
	e1m3map_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m3.sav");
	e1m4map_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m4.sav");
	e1m5map_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m5.sav");
	wrath_fremove(hub1map_shrine);
	wrath_fremove(e1m1map_shrine);
	wrath_fremove(e1m2map_shrine);
	wrath_fremove(e1m3map_shrine);
	wrath_fremove(e1m4map_shrine);
	wrath_fremove(e1m5map_shrine);

	local string hub1stat_shrine, e1m1stat_shrine, e1m2stat_shrine, e1m3stat_shrine, e1m4stat_shrine, e1m5stat_shrine;
	hub1stat_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/hub1.stats");
	e1m1stat_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m1.stats");
	e1m2stat_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m2.stats");
	e1m3stat_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m3.stats");
	e1m4stat_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m4.stats");
	e1m5stat_shrine = strcat("profiles/", repeatedprofilename, "/shrine/maps/e1m5.stats");
	wrath_fremove(hub1stat_shrine);
	wrath_fremove(e1m1stat_shrine);
	wrath_fremove(e1m2stat_shrine);
	wrath_fremove(e1m3stat_shrine);
	wrath_fremove(e1m4stat_shrine);
	wrath_fremove(e1m5stat_shrine);

	local string hub1map_autosave, e1m1map_autosave, e1m2map_autosave, e1m3map_autosave, e1m4map_autosave, e1m5map_autosave;
	hub1map_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/hub1.sav");
	e1m1map_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m1.sav");
	e1m2map_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m2.sav");
	e1m3map_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m3.sav");
	e1m4map_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m4.sav");
	e1m5map_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m5.sav");
	wrath_fremove(hub1map_autosave);
	wrath_fremove(e1m1map_autosave);
	wrath_fremove(e1m2map_autosave);
	wrath_fremove(e1m3map_autosave);
	wrath_fremove(e1m4map_autosave);
	wrath_fremove(e1m5map_autosave);

	local string hub1stat_autosave, e1m1stat_autosave, e1m2stat_autosave, e1m3stat_autosave, e1m4stat_autosave, e1m5stat_autosave;
	hub1stat_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/hub1.stats");
	e1m1stat_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m1.stats");
	e1m2stat_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m2.stats");
	e1m3stat_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m3.stats");
	e1m4stat_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m4.stats");
	e1m5stat_autosave = strcat("profiles/", repeatedprofilename, "/autosave/maps/e1m5.stats");
	wrath_fremove(hub1stat_autosave);
	wrath_fremove(e1m1stat_autosave);
	wrath_fremove(e1m2stat_autosave);
	wrath_fremove(e1m3stat_autosave);
	wrath_fremove(e1m4stat_autosave);
	wrath_fremove(e1m5stat_autosave);

	local string hub1map_tether, e1m1map_tether, e1m2map_tether, e1m3map_tether, e1m4map_tether, e1m5map_tether;
	hub1map_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/hub1.sav");
	e1m1map_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m1.sav");
	e1m2map_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m2.sav");
	e1m3map_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m3.sav");
	e1m4map_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m4.sav");
	e1m5map_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m5.sav");
	wrath_fremove(hub1map_tether);
	wrath_fremove(e1m1map_tether);
	wrath_fremove(e1m2map_tether);
	wrath_fremove(e1m3map_tether);
	wrath_fremove(e1m4map_tether);
	wrath_fremove(e1m5map_tether);

	local string hub1stat_tether, e1m1stat_tether, e1m2stat_tether, e1m3stat_tether, e1m4stat_tether, e1m5stat_tether;
	hub1stat_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/hub1.stats");
	e1m1stat_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m1.stats");
	e1m2stat_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m2.stats");
	e1m3stat_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m3.stats");
	e1m4stat_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m4.stats");
	e1m5stat_tether = strcat("profiles/", repeatedprofilename, "/tether/maps/e1m5.stats");
	wrath_fremove(hub1stat_tether);
	wrath_fremove(e1m1stat_tether);
	wrath_fremove(e1m2stat_tether);
	wrath_fremove(e1m3stat_tether);
	wrath_fremove(e1m4stat_tether);
	wrath_fremove(e1m5stat_tether);

	local string cprofiledir;
	cprofiledir = strcat("profiles/", repeatedprofilename);
	rmtree(cprofiledir);
	
};
void() remove_all_data = 
{
	read_currentprofileslot();

	string frk = strcat("profiles/", profilename, ".frk");
	wrath_fremove(frk);

	string versionfile = strcat("profiles/", profilename, "/menu.version");
	string frikparmskp1 = strcat("profiles/", profilename, "/frikparms.kp1");
	string shrinetxt = strcat("profiles/", profilename, "/shrine.txt");
	string tethertxt = strcat("profiles/", profilename, "/tether.txt");
	string tetherclienttxt = strcat("profiles/", profilename, "/tetherclient.txt");
	wrath_fremove(versionfile);
	wrath_fremove(frikparmskp1);
	wrath_fremove(shrinetxt);
	wrath_fremove(tethertxt);
	wrath_fremove(tetherclienttxt);

	local string auto_sav, tether_sav, shrine_sav;
	auto_sav = strcat("profiles/", profilename, "/autosave.sav");
	tether_sav = strcat("profiles/", profilename, "/tether.sav");
	shrine_sav = strcat("profiles/", profilename, "/shrine.sav");
	wrath_fremove(auto_sav);
	wrath_fremove(tether_sav);
	wrath_fremove(shrine_sav);

	string autosave_screenshot = strcat("profiles/", profilename, "/autosave.png");
	string tether_screenshot = strcat("profiles/", profilename, "/tether.png");
	string shrine_screenshot = strcat("profiles/", profilename, "/shrine.png");

	wrath_fremove(autosave_screenshot);
	wrath_fremove(tether_screenshot);
	wrath_fremove(shrine_screenshot);

	string profile_dates = strcat("profiles/",profilename, "/dates.txt");


	local string hub1map, e1m1map, e1m2map, e1m3map, e1m4map, e1m5map;
	hub1map = strcat("profiles/", profilename, "/maps/hub1.sav");
	e1m1map = strcat("profiles/", profilename, "/maps/e1m1.sav");
	e1m2map = strcat("profiles/", profilename, "/maps/e1m2.sav");
	e1m3map = strcat("profiles/", profilename, "/maps/e1m3.sav");
	e1m4map = strcat("profiles/", profilename, "/maps/e1m4.sav");
	e1m5map = strcat("profiles/", profilename, "/maps/e1m5.sav");
	wrath_fremove(hub1map);
	wrath_fremove(e1m1map);
	wrath_fremove(e1m2map);
	wrath_fremove(e1m3map);
	wrath_fremove(e1m4map);
	wrath_fremove(e1m5map);

	local string hub1stat, e1m1stat, e1m2stat, e1m3stat, e1m4stat, e1m5stat;
	hub1stat = strcat("profiles/", profilename, "/maps/hub1.stats");
	e1m1stat = strcat("profiles/", profilename, "/maps/e1m1.stats");
	e1m2stat = strcat("profiles/", profilename, "/maps/e1m2.stats");
	e1m3stat = strcat("profiles/", profilename, "/maps/e1m3.stats");
	e1m4stat = strcat("profiles/", profilename, "/maps/e1m4.stats");
	e1m5stat = strcat("profiles/", profilename, "/maps/e1m5.stats");
	wrath_fremove(hub1stat);
	wrath_fremove(e1m1stat);
	wrath_fremove(e1m2stat);
	wrath_fremove(e1m3stat);
	wrath_fremove(e1m4stat);
	wrath_fremove(e1m5stat);

	local string hub1map_shrine, e1m1map_shrine, e1m2map_shrine,e1m3map_shrine, e1m4map_shrine, e1m5map_shrine;
	hub1map_shrine = strcat("profiles/", profilename, "/shrine/maps/hub1.sav");
	e1m1map_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m1.sav");
	e1m2map_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m2.sav");
	e1m3map_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m3.sav");
	e1m4map_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m4.sav");
	e1m5map_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m5.sav");
	wrath_fremove(hub1map_shrine);
	wrath_fremove(e1m1map_shrine);
	wrath_fremove(e1m2map_shrine);
	wrath_fremove(e1m3map_shrine);
	wrath_fremove(e1m4map_shrine);
	wrath_fremove(e1m5map_shrine);

	local string hub1stat_shrine, e1m1stat_shrine, e1m2stat_shrine, e1m3stat_shrine, e1m4stat_shrine, e1m5stat_shrine;
	hub1stat_shrine = strcat("profiles/", profilename, "/shrine/maps/hub1.stats");
	e1m1stat_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m1.stats");
	e1m2stat_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m2.stats");
	e1m3stat_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m3.stats");
	e1m4stat_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m4.stats");
	e1m5stat_shrine = strcat("profiles/", profilename, "/shrine/maps/e1m5.stats");
	wrath_fremove(hub1stat_shrine);
	wrath_fremove(e1m1stat_shrine);
	wrath_fremove(e1m2stat_shrine);
	wrath_fremove(e1m3stat_shrine);
	wrath_fremove(e1m4stat_shrine);
	wrath_fremove(e1m5stat_shrine);

	local string hub1map_autosave, e1m1map_autosave, e1m2map_autosave, e1m3map_autosave, e1m4map_autosave, e1m5map_autosave;
	hub1map_autosave = strcat("profiles/", profilename, "/autosave/maps/hub1.sav");
	e1m1map_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m1.sav");
	e1m2map_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m2.sav");
	e1m3map_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m3.sav");
	e1m4map_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m4.sav");
	e1m5map_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m5.sav");
	wrath_fremove(hub1map_autosave);
	wrath_fremove(e1m1map_autosave);
	wrath_fremove(e1m2map_autosave);
	wrath_fremove(e1m3map_autosave);
	wrath_fremove(e1m4map_autosave);
	wrath_fremove(e1m5map_autosave);

	local string hub1stat_autosave, e1m1stat_autosave, e1m2stat_autosave, e1m3stat_autosave, e1m4stat_autosave, e1m5stat_autosave;
	hub1stat_autosave = strcat("profiles/", profilename, "/autosave/maps/hub1.stats");
	e1m1stat_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m1.stats");
	e1m2stat_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m2.stats");
	e1m3stat_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m3.stats");
	e1m4stat_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m4.stats");
	e1m5stat_autosave = strcat("profiles/", profilename, "/autosave/maps/e1m5.stats");
	wrath_fremove(hub1stat_autosave);
	wrath_fremove(e1m1stat_autosave);
	wrath_fremove(e1m2stat_autosave);
	wrath_fremove(e1m3stat_autosave);
	wrath_fremove(e1m4stat_autosave);
	wrath_fremove(e1m5stat_autosave);

	local string hub1map_tether, e1m1map_tether, e1m2map_tether, e1m3map_tether, e1m4map_tether, e1m5map_tether;
	hub1map_tether = strcat("profiles/", profilename, "/tether/maps/hub1.sav");
	e1m1map_tether = strcat("profiles/", profilename, "/tether/maps/e1m1.sav");
	e1m2map_tether = strcat("profiles/", profilename, "/tether/maps/e1m2.sav");
	e1m3map_tether = strcat("profiles/", profilename, "/tether/maps/e1m3.sav");
	e1m4map_tether = strcat("profiles/", profilename, "/tether/maps/e1m4.sav");
	e1m5map_tether = strcat("profiles/", profilename, "/tether/maps/e1m5.sav");
	wrath_fremove(hub1map_tether);
	wrath_fremove(e1m1map_tether);
	wrath_fremove(e1m2map_tether);
	wrath_fremove(e1m3map_tether);
	wrath_fremove(e1m4map_tether);
	wrath_fremove(e1m5map_tether);

	local string hub1stat_tether, e1m1stat_tether, e1m2stat_tether, e1m3stat_tether, e1m4stat_tether, e1m5stat_tether;
	hub1stat_tether = strcat("profiles/", profilename, "/tether/maps/hub1.stats");
	e1m1stat_tether = strcat("profiles/", profilename, "/tether/maps/e1m1.stats");
	e1m2stat_tether = strcat("profiles/", profilename, "/tether/maps/e1m2.stats");
	e1m3stat_tether = strcat("profiles/", profilename, "/tether/maps/e1m3.stats");
	e1m4stat_tether = strcat("profiles/", profilename, "/tether/maps/e1m4.stats");
	e1m5stat_tether = strcat("profiles/", profilename, "/tether/maps/e1m5.stats");
	wrath_fremove(hub1stat_tether);
	wrath_fremove(e1m1stat_tether);
	wrath_fremove(e1m2stat_tether);
	wrath_fremove(e1m3stat_tether);
	wrath_fremove(e1m4stat_tether);
	wrath_fremove(e1m5stat_tether);

	local string cprofiledir;
	cprofiledir = strcat("profiles/", profilename);
	rmtree(cprofiledir);
	
};

void() deleteallprofiles =
{
profileslot = 1;
write_currentprofileslot();
remove_all_data();
profileslot = 2;
write_currentprofileslot();
remove_all_data();
profileslot = 3;
write_currentprofileslot();
remove_all_data();
profileslot = 4;
write_currentprofileslot();
remove_all_data();
profileslot = 5;
write_currentprofileslot();
remove_all_data();
profileslot = 6;
write_currentprofileslot();
remove_all_data();
profileslot = 7;
write_currentprofileslot();
remove_all_data();

delete_profiles();
};
void()menu_type_resume;



float() current_local_profilenames = 
{
	float total_profile_counter;
	local float readparms;
 	local string readtext;
 	readparms = fopen_wrath("profiles/profilenames.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
 	if (readparms != -1)
 	{
 		readtext = fgets(readparms);	//read the text
 		string local_profilename1 = (readtext);	//turn the text into the float u want (by using stof: string to float)
 		readtext = fgets(readparms);
 		string local_profilename2 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename3 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename4 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename5 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename6 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename7 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename8 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename9 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename10 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename11 = (readtext);
 		readtext = fgets(readparms);
 		string local_profilename12 = (readtext);
 		fclose_wrath(readparms);
 	}
	total_profile_counter = 0;
	if (local_profilename1 != "")
	total_profile_counter ++;
	if (local_profilename2 != "")
	total_profile_counter ++;
	if (local_profilename3 != "")
	total_profile_counter ++;
	if (local_profilename4 != "")
	total_profile_counter ++;
	if (local_profilename5 != "")
	total_profile_counter ++;
	if (local_profilename6 != "")
	total_profile_counter ++;
	if (local_profilename7 != "")
	total_profile_counter ++;
	if (local_profilename8 != "")
	total_profile_counter ++;
	if (local_profilename9 != "")
	total_profile_counter ++;
	if (local_profilename10 != "")
	total_profile_counter ++;
	if (local_profilename11 != "")
	total_profile_counter ++;
	if (local_profilename12 != "")
	total_profile_counter ++;
	
	return total_profile_counter ;
 };
 
 void() deleteprofile = 
 { 
	remove_save_maps();
	remove_all_data();
	local float readparms;
 	local string readtext, local_profilename1,local_profilename2,local_profilename3,local_profilename4,local_profilename5,local_profilename6,local_profilename7;
	readparms = fopen_wrath("profiles/profilenames.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
 	if (readparms != -1)
 	{
 		readtext = fgets(readparms);	//read the text
 		local_profilename1 = (readtext);	//turn the text into the float u want (by using stof: string to float)
 		readtext = fgets(readparms);
 		local_profilename2 = (readtext);
 		readtext = fgets(readparms);
 		local_profilename3 = (readtext);
 		readtext = fgets(readparms);
 		local_profilename4 = (readtext);
 		readtext = fgets(readparms);
 		local_profilename5 = (readtext);
 		readtext = fgets(readparms);
 		local_profilename6 = (readtext);
 		readtext = fgets(readparms);
 		local_profilename7 = (readtext);
 		readtext = fgets(readparms);
		fclose_wrath(readparms);
 	}
	check_profileslot();
	
	local float writeparms;
 	local string writethis;
 	writeparms = fopen_wrath("profiles/profilenames.txt", FILE_WRITE);	//open what file to use in write mode
	if (profileslot != 1)
 	{writethis = local_profilename1;fputs(writeparms, writethis);fputs(writeparms, "\n");}
	if (profileslot != 2)
 	{writethis = local_profilename2;fputs(writeparms, writethis);fputs(writeparms, "\n");}
	if (profileslot != 3)
 	{writethis = local_profilename3;fputs(writeparms, writethis);fputs(writeparms, "\n");}
	if (profileslot != 4)
 	{writethis = local_profilename4;fputs(writeparms, writethis);fputs(writeparms, "\n");}
	if (profileslot != 5)
 	{writethis = local_profilename5;fputs(writeparms, writethis);fputs(writeparms, "\n");}
	if (profileslot != 6)
 	{writethis = local_profilename6;fputs(writeparms, writethis);fputs(writeparms, "\n");}
	if (profileslot != 7)
 	{writethis = local_profilename7;fputs(writeparms, writethis);fputs(writeparms, "\n");}
 	fclose_wrath(writeparms);
	

	
	profilesammount = current_local_profilenames();
	write_currentprofileslot();	


/*	if(profileslot > 1) 
	{
	profileslot --;
	write_profileslot();
	}
	else
	{
	profileslot = 2;
	profileslotpage = 2;
	write_profileslot();
	}
*/
	if (profilesammount < 1)
	{
	profileslot = 0;
	write_profileslot();
	}
	write_totalprofileslot();
 };





