 void(float alternative) menu_type_confirmbind;
 void() menu_type_confirmresolution;
 void() menu_type_confirmantialias;
 void() menu_type_confirmfullscreen;
 void(vector txt_pos) menu_type_profile;
 void(vector txt_pos) menu_type_main;
 void() menu_type_resume;
 void() menu_type_options;
 void() menu_type_options_controls;
 void() menu_type_options_video;
 void() menu_type_options_resolution;
 void() menu_type_options_audio;
 void() menu_type_options_gameplay;
 void() menu_type_ingame;
 void() menu_type_difficult;

 float clframetime;
 float cltime;
 float slayeralpha;
 float slayerstate;
void()menu_type_deleteprofile;
void()menu_type_options_controlbinds;
void()menu_type_confirmresettodefaults;
void() check_vectorcolors =
{
//	local float readparms, localmenuversion;
// 	local string readtext;
// 	readparms = fopen_wrath("colordata.txt", FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
// 	readtext = fgets(readparms);	//read the text
//	vectorred = stov(readtext);	//turn the text into the float u want (by using stof: string to float)
// 	readtext = fgets(readparms);	//read the text
// 	vectorwhite = stov(readtext);	//turn the text into the float u want (by using stof: string to float)
// 	fclose_wrath(readparms);
	vectorred = '-1 -1 -1';
	vectorwhite = '8 -1 -1';
	
};
 void(float a, float b) m_draw = 
{
	time = gettime();
 
  
 	static float oldtime;
 	cltime = gettime();
 	clframetime = oldtime ? cltime - oldtime : 0.1;
 	oldtime = cltime;
	check_vectorcolors();
 	if (slayerstate != 1)
 	{
 		if (slayeralpha > 1)
 			slayerstate = 1;

 		slayeralpha += clframetime *1.5;
 	}
 	else
 	{
 		slayeralpha -= clframetime *1.5;
 		if (slayeralpha < 0.1)
 			slayerstate = 0;
 	}

 	float deadmenu;
 	deadmenu = cvar("scratch3");
 	if (deadmenu)
 	{
 		m_hide();
 		return;
 	}

 	vid_x = cvar("vid_conwidth");
 	vid_y = cvar("vid_conheight");
 	float rvid_x = cvar("vid_width");
 	float rvid_y = cvar("vid_height");

 	/*	if(vid_x / vid_y == 16/9)
 		{*/
 		vid_rx = cvar("vid_width");
 		vid_ry = cvar("vid_height");

 		if (((vid_rx == 2560) && (vid_ry == 1440))||((vid_rx == 2560) && (vid_ry == 1080))||((vid_rx == 3440) && (vid_ry == 1440))||((vid_rx == 5120) && (vid_ry == 2160)))
		{	
	 	vx_rel = ((vid_x / 1134));
		vy_rel = ((vid_y / 540));
		//smallbuttons = 0;
		}
 		else if ((vid_rx == 4096) && (vid_ry == 2160))
		{	
	 	vx_rel = ((vid_x / 1134));
		vy_rel = ((vid_y / 540));
		//smallbuttons = 0;
		}
 		else if ((vid_rx == 3840) && (vid_ry == 1600))
		{	
	 	vx_rel = ((vid_x / 1134));
		vy_rel = ((vid_y / 540));
		//smallbuttons = 0;
		}

		else
		{
		vx_rel = ((vid_x / 960));
		vy_rel = ((vid_y / 540));
		//smallbuttons = 1;
		}
		/*	}

 		if(vid_x / vid_y == 4/3)
 		{
 		vx_rel = (vid_x / 960);
 		vy_rel = (vid_y / 640);
 		}

 		if(vid_x / vid_y == 5/3)
 		{
 		vx_rel = (vid_x / 640);
 		vy_rel = (vid_y / 384);
 		}

 		if(vid_x / vid_y == 5/4)
 		{
 		vx_rel = (vid_x / 640);
 		vy_rel = (vid_y / 512);
 		}

 		if(vid_x / vid_y == 16/10)
 		{
 		vx_rel = (vid_x / 640);
 		vy_rel = (vid_y / 400);
 		}

 	*/
 	menuingame = 0;

 	float imgsizex, imgsizey, img2sizex, img2sizey, img3sizex, img3sizey;

 	imgsizex = 256 * vx_rel;
 	imgsizey = 32 * vy_rel;
 	img2sizex = 128 * vx_rel;
 	img2sizey = 32 * vy_rel;
 	img3sizex = 32 * vx_rel;
 	img3sizey = 32 * vy_rel;

 	BTT_FONT_SIZE = fixed_vector('16 16 0');
 	BTT_IMG_SIZE_x = imgsizex;
 	BTT_IMG_SIZE_y = imgsizey;
 	BTT_IMG_SIZE2_x = img2sizex;
 	BTT_IMG_SIZE2_y = img2sizey;
 	BTT_IMG_SIZE3_x = img3sizex;
 	BTT_IMG_SIZE3_y = img3sizey;

 	updateMouse();
 	local float w;
 	if (Menu_Active)
 	{
 		if (getmousetarget() != MT_MENU || getkeydest() != KEY_MENU)
 			m_hide();
 	}

 	if (!Menu_Active)
 		return;

 	local vector size, buttions_locs;
 	size_x = vid_x;
 	size_y = vid_y;
 	buttions_locs_x = ((vid_x / 2) - 128) *vx_rel;
 	buttions_locs_y = 196 * vy_rel;


 	if (clientstate() != CS_CONNECTED)
 	{
 		// Draw the background
 		drawpic('0 0 0', "gfx/conback", size, ' 1 1 1', 1, 0);
 		local vector txt_pos;
 		if (menutype == M_TYPE_SKILL) {}
 		else if (menutype == M_YNQ)
 		{
 			drawfill('0 0 0', vid_x *'1 0 0' + vid_y *'0 1 0', '0 0 0', 0.65, 0);
 			drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '1 1 1', 1, 0);
 			drawpic(fixed_vector('228 64 0'), "gfx/menu/logo.tga", fixed_vector('504 136 0'), '1 1 1', 1, 0);
 			w = stringwidth("Are you sure you want to quit?", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0' - 8 *'0 1 0', "Are you sure you want to quit?", '8 8 0', 1, 0);
 			w = stringwidth("Press ^1Y^7 to quit, ^1N^7!", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0', "Press ^1Y^7 to quit, ^1N^7!", '8 8 0', 1, 0);
 		}
 		else if (menutype == M_TYPE_CREDITS) {}
 		else if (menutype == M_TYPE_HELP) {}
 		else if (menutype == M_TYPE_OPTIONS)
 			menu_type_options();

 		else if (menutype == M_TYPE_SELECT_DIFFICULT)
 			menu_type_difficult();

 		else if (menutype == M_TYPE_AUDIO)
 			menu_type_options_audio();
 		else if (menutype == M_TYPE_CONTROLS)
 			menu_type_options_controls();
 		else if (menutype == M_TYPE_CONTROLBINDS)
 			menu_type_options_controlbinds();
 		else if (menutype == M_TYPE_GAMEPLAY)
 			menu_type_options_gameplay();
 		else if (menutype == M_TYPE_VIDEO)
 			menu_type_options_video();
 		else if (menutype == M_TYPE_RESOLUTION)
 			menu_type_options_resolution();
 		else if (menutype == M_TYPE_CONFIRMRESOLUTION)
 			menu_type_confirmresolution();
 		else if (menutype == M_TYPE_CONFIRMBIND)
 			menu_type_confirmbind(0);
 		else if (menutype == M_TYPE_CONFIRMANTIALIAS)
 			menu_type_confirmantialias();
 		else if (menutype == M_TYPE_CONFIRMFULLSCREEN)
 			menu_type_confirmfullscreen();
		else if (menutype == M_TYPE_DELETEPROFILE)
		menu_type_deleteprofile();
		else if (menutype == M_TYPE_CONTROLRESTART)
		menu_type_confirmresettodefaults();
 		else if (menutype == M_TYPE_RESUME)
 			menu_type_resume();

 		else if (menutype == M_TYPE_PROFILE)
 			menu_type_profile(txt_pos);
 		else
 			menu_type_main(txt_pos);
 	}
 	else
 	{
 		if (menutype == M_TYPE_NONE)
 			zmenuingame = 1;
 		else
 			zmenuingame = 0;

 		if (menutype == M_TYPE_NONE)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			if (!pausesound)
 				cmd("pausesound 1\n");
 			pausesound = 1;

 			menu_type_ingame();
 		}
 		else if (menutype == M_TYPE_DNONE)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			w = stringwidth("Are you sure you returnt to main menu? Not saved progress will be lost", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0' - 8 *'0 1 0', "Are you sure you want to quit2? Not saved progress will be lost", '8 8 0', 1, 0);
 			w = stringwidth("Press ^1Y^7 to quit, ^1N^7!", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0', "Press ^1Y^7 to quit, ^1N^7!", '8 8 0', 1, 0);
 		}
 		else if (menutype == M_TYPE_OPTIONS)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options();
 		}
 		else if (menutype == M_TYPE_AUDIO)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_audio();
 		}

		else if (menutype == M_TYPE_CONTROLS)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_controls();
 		}
		else if (menutype == M_TYPE_CONTROLRESTART)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
			menu_type_confirmresettodefaults();
 		}
 		else if (menutype == M_TYPE_CONTROLBINDS)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_controlbinds();
 		}
 		else if (menutype == M_TYPE_GAMEPLAY)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_gameplay();
 		}
 		else if (menutype == M_TYPE_VIDEO)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_video();
 		}
 		else if (menutype == M_TYPE_RESOLUTION)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_options_resolution();
 		}
 		else if (menutype == M_TYPE_CONFIRMRESOLUTION)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_confirmresolution();
 		}
 		else if (menutype == M_TYPE_CONFIRMBIND)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_confirmbind(0);
 		}
 		else if (menutype == M_TYPE_CONFIRMANTIALIAS)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_confirmantialias();
 		}
 		else if (menutype == M_TYPE_CONFIRMFULLSCREEN)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			menu_type_confirmfullscreen();
 		}
 		else if (menutype == M_YND)
 		{
 			drawfill('0 0 0', size, '0 0 0', 0.7, 0);
 			w = stringwidth("Are you sure you want to return to main menu? Not saved progress will be lost", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0' - 8 *'0 1 0', "Are you sure you want to quit3? Not saved progress will be lost", '8 8 0', 1, 0);
 			w = stringwidth("Press ^1Y^7 to quit, ^1N^7!", true, '8 8 0');
 			drawcolorcodedstring((vid_x - w) *'0.5 0 0' + vid_y *'0 0.5 0', "Press ^1Y^7 to quit, ^1N^7!", '8 8 0', 1, 0);
 		}
		else		
		{
		cmd("menu_restart\n");
		menutype = M_TYPE_NONE;
		}
 	}

 	drawpic(mouse_pos + fixed_vector('16 20 0'), "gfx/cursor", fixed_vector ('24 24 0'), ' 1 1 1', 1, 0);
 };

 void() m_display = 
{
	vid_x = cvar("vid_conwidth");
 	vid_y = cvar("vid_conheight");
 	Menu_Active = true;
 	setkeydest(KEY_MENU);
 	setmousetarget(MT_MENU);
 };

 void() m_hide = 
{
	if (pausesound)
 	{
 		cmd("pausesound 0\n");
		cmd("impulse 82\n");
 		pausesound = 0;
 	}

 	menutype = M_TYPE_NONE;
 	zmenuingame = 0;
 	menuingame = 1;
 	Menu_Active = false;
 	setkeydest(KEY_GAME);
 	setmousetarget(MT_CLIENT);
 };

 void(float n) m_toggle = 
{
	menutype = M_TYPE_NONE;
 	Menu_Active = n;
 	if (Menu_Active)
 		m_display();
 	else
 		m_hide();
 };

 void() m_shutdown = {};
	///