float oldtotalprofileslots;

void(vector txt_pos) menu_type_main = 
{
	vector buttions_locs;
	buttions_locs_x = ((vid_x / 2) - (128 *vx_rel));
	buttions_locs_y = 196 * vy_rel;

	txt_pos_x = buttions_locs_x;
	txt_pos_y = 64 * vy_rel;
	drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '1 1 1', 1, 0);
	//drawpic('0 0 0',"gfx/menu/background_layer1.tga" ,vid_x *'1 0 0' + vid_y *'0 1 0', '1 1 1', slayeralpha, 0);

	number_load_selected = 0;
	type_load_selected = 0;

	vector imgpos, imgsize;
	imgpos_x = (vid_x / 960) *228;
	imgpos_y = (vid_y / 540) *64;
	imgsize_x = (vid_x / 960) *504;
	imgsize_y = (vid_y / 540) *136;

	drawpic(imgpos, "gfx/menu/logo.tga", imgsize, '1 1 1', 1, 0);

	buttions_locs_y += 32 * vy_rel;

	local float totalprofileslots;

	//if(oldtotalprofileslots != totalprofileslots)
	totalprofileslots = check_profileslottotal();

	if (totalprofileslots < 7)
	{
		draw_buttionwrath(buttions_locs, "New Game", 1);
		buttions_locs_y += 48 * vy_rel;
	}

	if (profileslot)
	{
		draw_buttionwrath(buttions_locs, "Resume", 2);
		oldprofileslot = 0;
		buttions_locs_y += 48 * vy_rel;
	}

	draw_buttionwrath(buttions_locs, "Options", 10);
	buttions_locs_y += 48 * vy_rel;
	//oldtotalprofileslots = totalprofileslots;
	draw_buttionwrath(buttions_locs, "Quit", 3);
};

void() menu_type_ingame = 
{
	vector buttions_locs;
	buttions_locs_x = ((vid_x / 2) - (128 *vx_rel));
	buttions_locs_y = 196 * vy_rel;

	draw_buttionwrath(buttions_locs, "Resume", 43);
	if (oldprofileslot)
		oldprofileslot = 0;
	if (oldtotalprofileslots)
		oldtotalprofileslots = 0;

	buttions_locs_y += 48 * vy_rel;
	draw_buttionwrath(buttions_locs, "Options", 10);
	buttions_locs_y += 48 * vy_rel;

	draw_buttionwrath(buttions_locs, "Quit", 42);
};

void() confirm_profile = 
{
	check_profileslot();
	
	profilesammount = check_profileslottotal();
	profilesammount++;
	profileslot = profilesammount;
	

	write_profileslot();
	check_profilenames();

	write_totalprofileslot();
	if (profileslot == 1)
		profilename1 = gah;
	if (profileslot == 2)
		profilename2 = gah;
	if (profileslot == 3)
		profilename3 = gah;
	if (profileslot == 4)
		profilename4 = gah;
	if (profileslot == 5)
		profilename5 = gah;
	if (profileslot == 6)
		profilename6 = gah;
	if (profileslot == 7)
		profilename7 = gah;
	if (profileslot == 8)
		profilename8 = gah;
	if (profileslot == 9)
		profilename9 = gah;
	if (profileslot == 10)
		profilename10 = gah;
	if (profileslot == 11)
		profilename11 = gah;
	if (profileslot == 12)
		profilename12 = gah;
	write_profilenames();

	if (pausesound)
	{
		cmd("pausedsound 0\n");
		pausesound = 0;
	}

	if (gah)
		strunzone(gah);
	gah = "";
	write_currentprofileslotfirsttime();
	write_menuversion();

};

void() menu_type_options = 
{
	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;
	if (oldprofileslot)
		oldprofileslot = 0;
	if (oldtotalprofileslots)
		oldtotalprofileslots = 0;

	buttions_locs_x = ((vid_x / 2) - (128 *vx_rel));
	buttions_locs_y = 32 * vy_rel;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	draw_fbuttion3(buttions_locs, "OPTIONS");
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "MOUSE SETUP", 11);
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "CONTROL BINDS", 19);
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "VIDEO", 12);
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "DISPLAY RESOLUTION", 18);
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "AUDIO", 14);
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "GAMEPLAY", 15);
	buttions_locs_y += 56 * vy_rel;
};

void() menu_type_difficult = 
{
	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;

	buttions_locs_x = ((vid_x / 2) - (128 *vx_rel));
	buttions_locs_y = 32 * vy_rel;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	draw_fbuttion3(buttions_locs, "SELECT DIFFICULTY");
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "EASY", 45);
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "NORMAL", 46);
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "HARD", 47);
	buttions_locs_y += 56 * vy_rel;
	draw_buttion(buttions_locs, "OUTLANDER", 48);
};

void() menu_type_options_controls = 
{
	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;


	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.25 0.25 0.3', 1, 0);

	buttions_locs_x = ((vid_x / 2) - (128 *vx_rel));
	buttions_locs_y = 32 * vy_rel;

	draw_fbuttion3(buttions_locs, "MOUSE OPTIONS");

	////////// MOUSE SENSITIVITY
	buttions_locs_x -= 222 * vx_rel;
	buttions_locs_y += 42 * vy_rel;
	float org_x	 = buttions_locs_x;
	draw_fbuttionsmall(buttions_locs, "Mouse Sensitivity",0);
	buttions_locs_x += 150 * vx_rel;
	draw_buttion(buttions_locs, "<", 101);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 102);
	buttions_locs_x -= 145 * vx_rel;
	buttions_locs_y += 16 * vy_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	senm = cvar("sensitivity");
	local vector barpos;
	barpos = buttions_locs - fixed_vector('28 0 0');
	barpos_y -= 8 * vy_rel;
	barpos_x += senm *28 * vx_rel;
	//drawfill(barpos, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0);
	drawfilldraggeable(barpos, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 2,101, 102, 256 / 100);
	string msen;msen = substring(ftos(senm),0,3);draw_fbuttion2(barpos + fixed_vector('-128.5 -24 0'), msen);
	buttions_locs_y += 36 * vy_rel;
	////////

	////////// MOUSE MOUSE SENSITIVY
	buttions_locs_x =  org_x;
	draw_fbuttionsmall(buttions_locs, "Menu Mouse Sensitivity",0);
	buttions_locs_x += 150 * vx_rel;
	draw_buttion(buttions_locs, "<", 114);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 115);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	macel = cvar("saved5");
	local vector barpos2_a;
	barpos2_a = buttions_locs - fixed_vector('28 0 0');
	barpos2_a_y -= 8 * vy_rel;
	barpos2_a_x += (macel *256 + 25.5) *vx_rel;
	drawfilldraggeable(barpos2_a, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 3,114, 115, 256 / 100);
	string smacel;smacel = substring(ftos(macel),0,3);draw_fbuttion2(barpos2_a + fixed_vector('-128.5 -24 0'), smacel);
	buttions_locs_y += 36 * vy_rel;

	////////// MOUSE ACCELERATION
	buttions_locs_x =  org_x;
	draw_fbuttionsmall(buttions_locs, "Mouse Acceleration",0);
	buttions_locs_x += 150 * vx_rel;
	draw_buttion(buttions_locs, "<", 103);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 104);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	acel = cvar("m_accelerate");
	local vector barpos2;
	barpos2 = buttions_locs - fixed_vector('28 0 0');
	barpos2_y -= 8 * vy_rel;
	barpos2_x += (acel *25.5 + 25.5) *vx_rel;
	drawfilldraggeable(barpos2, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 14,103, 104, 256 / 100);
	string macel;macel = substring(ftos(acel),0,3);draw_fbuttion2(barpos2 + fixed_vector('-128.5 -24 0'), macel);
	buttions_locs_x -= 401 * vx_rel;	// back to the x pos
	buttions_locs_y += 28 * vy_rel;
	////////// MOUSE SMOOTHING
	buttions_locs_x =  org_x;

	draw_fbuttionsmall(buttions_locs, "Mouse Smoothing",0);
	buttions_locs_x -= 156; 
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked;
	string mark;
	checked = cvar("m_filter");
	if (checked == 1)
		mark = "x";
	else
		mark = " ";
	draw_buttion(buttions_locs, mark, 105);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 28 * vy_rel;

	////////// MOUSE INVERT
	buttions_locs_y += 28 * vy_rel;
	buttions_locs_x += 156; 
	draw_fbuttionsmall(buttions_locs, "Invert Mouse",0);
	buttions_locs_x -= 156; 
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked2;
	string mark2;
	checked2 = cvar("m_pitch");
	if (checked2 <= -0.022)
		mark2 = "x";
	else
		mark2 = " ";
	draw_buttion(buttions_locs, mark2, 106);
	//	buttions_locs_x -= 320 * vx_rel;
	//	buttions_locs_y +=  28 * vy_rel;

};
void() menu_type_options_controlbinds = 
{
	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.25 0.25 0.3', 1, 0);

	buttions_locs_x = ((vid_x / 2) - (128 *vx_rel));
	buttions_locs_y = 8 * vy_rel;

	draw_fbuttion3(buttions_locs, "CONTROL OPTIONS");
	buttions_locs_x -= 322 * vx_rel;
	buttions_locs_y += 42 * vy_rel;

	////////// BIND KEYS
	buttions_locs_x = (vid_x / 2) - 128 * vx_rel;
	buttions_locs_y += 32 * vy_rel;

	draw_fbuttion3(buttions_locs, "Customize Keys");
	buttions_locs_y += 32 * vy_rel;
	buttions_locs_x -= 360 * vx_rel;

	float buttion_y = buttions_locs_y;
	float buttion_x = buttions_locs_x + (64 *vx_rel);

	////////////
	draw_fbuttionsmall(buttions_locs, "Move Forward", 500);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+forward", 0));
	if (argv(0) != "-1")
		string fw_key1 = keynumtostring(stof(argv(0)));
	else
		fw_key1 = " ";
	draw_buttion(buttions_locs, fw_key1, 500);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Move backward", 501);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+back", 0));
	if (argv(0) != "-1")
		string fw_key2 = keynumtostring(stof(argv(0)));
	else
		fw_key2 = " ";
	draw_buttion(buttions_locs, fw_key2, 501);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	////////////
	draw_fbuttionsmall(buttions_locs, "Move Left", 502);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+moveleft", 0));
	if (argv(0) != "-1")
		string fw_key3 = keynumtostring(stof(argv(0)));
	else
		fw_key3 = " ";
	draw_buttion(buttions_locs, fw_key3, 502);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	////////////
	draw_fbuttionsmall(buttions_locs, "Move Right", 503);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+moveright", 0));
	if (argv(0) != "-1")
		string fw_key4 = keynumtostring(stof(argv(0)));
	else
		fw_key4 = " ";
	draw_buttion(buttions_locs, fw_key4, 503);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	////////////
	draw_fbuttionsmall(buttions_locs, "Fire", 504);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+attack", 0));
	if (argv(0) != "-1")
		string fw_key5 = keynumtostring(stof(argv(0)));
	else
		fw_key5 = " ";
	draw_buttion(buttions_locs, fw_key5, 504);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Alt Fire", 505);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+button3", 0));
	if (argv(0) != "-1")
		string fw_key6 = keynumtostring(stof(argv(0)));
	else
		fw_key6 = " ";
	draw_buttion(buttions_locs, fw_key6, 505);
	buttions_locs += fixed_vector('-128 33 0');
	////////////

	draw_fbuttionsmall(buttions_locs, "Inventory", 506);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+button6", 0));
	if (argv(0) != "-1")
		string fw_key7 = keynumtostring(stof(argv(0)));
	else
		fw_key7 = " ";
	draw_buttion(buttions_locs, fw_key7, 506);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Jump", 507);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+jump", 0));
	if (argv(0) != "-1")
		string fw_key8 = keynumtostring(stof(argv(0)));
	else
		fw_key8 = " ";
	draw_buttion(buttions_locs, fw_key8, 507);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Crouch", 508);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+button4", 0));
	if (argv(0) != "-1")
		string fw_key9 = keynumtostring(stof(argv(0)));
	else
		fw_key9 = " ";
	draw_buttion(buttions_locs, fw_key9, 508);
	////////////

	buttions_locs_x += 170 * vx_rel;
	buttions_locs_y = buttion_y;

	draw_fbuttionsmall(buttions_locs, "Ruination Blade", 509);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 1", 0));
	if (argv(0) != "-1")
		string fw_key10 = keynumtostring(stof(argv(0)));
	else
		fw_key10 = " ";
	draw_buttion(buttions_locs, fw_key10, 509);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Coachgun", 510);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 2", 0));
	if (argv(0) != "-1")
		string fw_key11 = keynumtostring(stof(argv(0)));
	else
		fw_key11 = " ";
	draw_buttion(buttions_locs, fw_key11, 510);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Shotgun", 511);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 3", 0));
	if (argv(0) != "-1")
		string fw_key12 = keynumtostring(stof(argv(0)));
	else
		fw_key12 = " ";
	draw_buttion(buttions_locs, fw_key12, 511);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Fang Spitter", 512);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 4", 0));
	if (argv(0) != "-1")
		string fw_key14 = keynumtostring(stof(argv(0)));
	else
		fw_key14 = " ";
	draw_buttion(buttions_locs, fw_key14, 512);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Retcher", 513);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 5", 0));
	if (argv(0) != "-1")
		string fw_key15 = keynumtostring(stof(argv(0)));
	else
		fw_key15 = " ";
	draw_buttion(buttions_locs, fw_key15, 513);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Slag Cannon", 514);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 6", 0));
	if (argv(0) != "-1")
		string fw_key16 = keynumtostring(stof(argv(0)));
	else
		fw_key16 = " ";
	draw_buttion(buttions_locs, fw_key16, 514);
	buttions_locs += fixed_vector('-128 33 0');
/*	////////////
	draw_fbuttionsmall(buttions_locs, "Artifact Inventory",515);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 7",0));
	if(argv(0) != "-1")
	string fw_key17 = keynumtostring (stof(argv(0)));
	else
	fw_key17 = " ";	
	draw_buttion(buttions_locs, fw_key17, 515);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Artifact Inventory",516);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 8",0));
	if(argv(0) != "-1")
	string fw_key18 = keynumtostring (stof(argv(0)));
	else
	fw_key18 = " ";	
	draw_buttion(buttions_locs, fw_key18, 516);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Artifact Inventory",517);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 9",0));
	if(argv(0) != "-1")
	string fw_key19 = keynumtostring (stof(argv(0)));
	else
	fw_key19 = " ";	
	draw_buttion(buttions_locs, fw_key19, 517);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	*/
	draw_fbuttionsmall(buttions_locs, "Use", 518);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+button5", 0));
	if (argv(0) != "-1")
		string fw_key20 = keynumtostring(stof(argv(0)));
	else
		fw_key20 = " ";
	draw_buttion(buttions_locs, fw_key20, 518);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Journal", 519);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 35", 0));
	if (argv(0) != "-1")
		string fw_key21 = keynumtostring(stof(argv(0)));
	else
		fw_key21 = " ";
	draw_buttion(buttions_locs, fw_key21, 519);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Use Artifact", 520);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 15", 0));
	if (argv(0) != "-1")
		string fw_key22 = keynumtostring(stof(argv(0)));
	else
		fw_key22 = " ";
	draw_buttion(buttions_locs, fw_key22, 520);
		//buttions_locs += fixed_vector('-128 33 0');
	////////////	

	buttions_locs_y = buttion_y;
	buttions_locs_x += (170 *vx_rel);


	string walkrunstring;
	float checked_alwaysrun = cvar("cl_alwaysrun");
	if(checked_alwaysrun == 1)
	walkrunstring = "Walk";
	if(checked_alwaysrun != 1)
	walkrunstring = "Run";
	float checked_togglerun = cvar("cl_togglerun");
	if(checked_togglerun == 1)
	walkrunstring = "Run / Walk";


	draw_fbuttionsmall(buttions_locs, walkrunstring, 526);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+button7", 0));
	if (argv(0) != "-1")
		string fw_key30 = keynumtostring(stof(argv(0)));
	else
		fw_key30 = " ";
	draw_buttion(buttions_locs, fw_key30, 526);
	buttions_locs += fixed_vector('-128 33 0');
	////////////

	draw_fbuttionsmall(buttions_locs, "Swim Up", 521);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+moveup", 0));
	if (argv(0) != "-1")
		string fw_key23 = keynumtostring(stof(argv(0)));
	else
		fw_key23 = " ";
	draw_buttion(buttions_locs, fw_key23, 521);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Swim Down", 522);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("+movedown", 0));
	if (argv(0) != "-1")
		string fw_key24 = keynumtostring(stof(argv(0)));
	else
		fw_key24 = " ";
	draw_buttion(buttions_locs, fw_key24, 522);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Last Weapon", 523);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 57", 0));
	if (argv(0) != "-1")
		string fw_key25 = keynumtostring(stof(argv(0)));
	else
		fw_key25 = " ";
	draw_buttion(buttions_locs, fw_key25, 523);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Next Weapon", 524);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 55", 0));
	if (argv(0) != "-1")
		string fw_key26 = keynumtostring(stof(argv(0)));
	else
		fw_key26 = " ";
	draw_buttion(buttions_locs, fw_key26, 524);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Prev Weapon", 525);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 56", 0));
	if (argv(0) != "-1")
		string fw_key27 = keynumtostring(stof(argv(0)));
	else
		fw_key27 = " ";
	draw_buttion(buttions_locs, fw_key27, 525);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Use Soul Tether", 527);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 81", 0));
	if (argv(0) != "-1")
		string fw_key28 = keynumtostring(stof(argv(0)));
	else
		fw_key28 = " ";
	draw_buttion(buttions_locs, fw_key28, 527);
	buttions_locs += fixed_vector('-128 33 0');
	////////////
	draw_fbuttionsmall(buttions_locs, "Load Menu", 528);
	buttions_locs_x += 128 * vx_rel;
	tokenize(findkeysforcommand("impulse 89", 0));
	if (argv(0) != "-1")
		string fw_key29 = keynumtostring(stof(argv(0)));
	else
		fw_key29 = " ";
	draw_buttion(buttions_locs, fw_key29, 528);
	buttions_locs += fixed_vector('-128 133 0');

	draw_buttion(buttions_locs, "Reset to defaults", 120);


};

void(float alternative) menu_type_confirmbind = 
{
	local vector buttions_locs;
	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);

	buttions_locs_y = 172 * vy_rel;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	buttions_locs_x += 128 * vx_rel;
	drawfill(buttions_locs + fixed_vector('-256 -32 0'), fixed_vector('464 128 0'), '0.2 0.2 0.23', 0.7, 0);
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);
	buttions_locs_x -= 148 * vx_rel;

	string localkey;

	if (gkcommand == 1) localkey = "+forward";
	if (gkcommand == 2) localkey = "+back";
	if (gkcommand == 3) localkey = "+moveleft";
	if (gkcommand == 4) localkey = "+moveright";
	if (gkcommand == 5) localkey = "+attack";
	if (gkcommand == 6) localkey = "+button3";
	if (gkcommand == 7) localkey = "+button6";
	if (gkcommand == 8) localkey = "+jump";
	if (gkcommand == 9) localkey = "+button4";	//crouch
	if (gkcommand == 10) localkey = "select blade";
	if (gkcommand == 11) localkey = "select coachgun";
	if (gkcommand == 12) localkey = "select shotgun";
	if (gkcommand == 13) localkey = "select fang spitter";
	if (gkcommand == 14) localkey = "select retcher";
	if (gkcommand == 15) localkey = "select slagcannon";
	//	if (gkcommand == 16) localkey =  "\"impulse 7\""
	//	if (gkcommand == 17) localkey =  "\"impulse 8\""
	//	if (gkcommand == 18) localkey = "\"impulse 9\""
	if (gkcommand == 19) localkey = "use";	//use
	if (gkcommand == 20) localkey = "journal";	//journal
	if (gkcommand == 21) localkey = "use artifact";	//artifact
	if (gkcommand == 22) localkey = "+moveup";
	if (gkcommand == 23) localkey = "+movedown";
	if (gkcommand == 24) localkey = "last weapon";
	if (gkcommand == 25) localkey = "previous weapon";
	if (gkcommand == 26) localkey = "next weapon";
	if (gkcommand == 27) localkey = "walk";
	if (gkcommand == 28) localkey = "use soul tether";
	if (gkcommand == 29) localkey = "load menu";

	buttions_locs_y -= 24 * vy_rel;
	draw_fbuttion3(buttions_locs, localkey);
	buttions_locs_y += 24 * vy_rel;

	draw_fbuttion(buttions_locs, "PRESS A KEY");

	buttions_locs_x += 148 * vx_rel;
	buttions_locs_y += 48 * vy_rel;
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);

	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CANCEL", 11);

	if (gkcommand == 1) localkey = "+forward";
	if (gkcommand == 2) localkey = "+back";
	if (gkcommand == 3) localkey = "+moveleft";
	if (gkcommand == 4) localkey = "+moveright";
	if (gkcommand == 5) localkey = "+attack";
	if (gkcommand == 6) localkey = "+button3";
	if (gkcommand == 7) localkey = "+button6";
	if (gkcommand == 8) localkey = "+jump";
	if (gkcommand == 9) localkey = "+button4";	//crouch
	if (gkcommand == 10) localkey = "\"impulse 1\"";
	if (gkcommand == 11) localkey = "\"impulse 2\"";
	if (gkcommand == 12) localkey = "\"impulse 3\"";
	if (gkcommand == 13) localkey = "\"impulse 4\"";
	if (gkcommand == 14) localkey = "\"impulse 5\"";
	if (gkcommand == 15) localkey = "\"impulse 6\"";
	if (gkcommand == 16) localkey = "\"impulse 7\"";
	if (gkcommand == 17) localkey = "\"impulse 8\"";
	if (gkcommand == 18) localkey = "\"impulse 9\"";
	if (gkcommand == 19) localkey = "+button5";	//use
	if (gkcommand == 20) localkey = "\"impulse 35\"";	//journal
	if (gkcommand == 21) localkey = "\"impulse 15\"";	//artifact
	if (gkcommand == 22) localkey = "+moveup";
	if (gkcommand == 23) localkey = "+movedown";
	if (gkcommand == 24) localkey = "\"impulse 57\"";
	if (gkcommand == 25) localkey = "\"impulse 55\"";
	if (gkcommand == 26) localkey = "\"impulse 56\"";
	if (gkcommand == 27) localkey = "+button7";
	if (gkcommand == 28) localkey = "\"impulse 81\"";
	if (gkcommand == 29) localkey = "\"impulse 89\"";

	tokenize((findkeysforcommand(localkey, 0)));

	argv1 = stof(argv(0));
	argv2 = stof(argv(1));
	argv3 = stof(argv(2));
	argv4 = stof(argv(3));

};

void() menu_type_options_gameplay = 
{
	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);

	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);
	buttions_locs_y = 32 * vy_rel;

	draw_fbuttion3(buttions_locs, "GAMEPLAY OPTIONS");
	buttions_locs_x -= 322 * vx_rel;
	buttions_locs_y += 38 * vy_rel;

	////////// SRAFE TILTING
	draw_fbuttion(buttions_locs, "Strafe Tilting");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked;
	string mark;
	checked = cvar("saved7");
	if (checked == 2)
		mark = "x";
	else
		mark = " ";
	draw_buttion(buttions_locs, mark, 107);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;

	////////// VIEW BOBBING
	draw_fbuttion(buttions_locs, "View Bobbing");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked2;
	string mark2;
	checked2 = cvar("cl_bob");
	if (checked2 >= 0.005)
		mark2 = "x";
	else
		mark2 = " ";
	draw_buttion(buttions_locs, mark2, 108);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;

	////////// CROSSHAIR
	draw_fbuttion(buttions_locs, "Crosshair");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked3;
	string mark3;
	checked3 = cvar("saved1");
	if (checked3 == 0)
		mark3 = "x";
	else
		mark3 = " ";
	draw_buttion(buttions_locs, mark3, 109);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 48 * vy_rel;

	////////// CROSSHAIR SCALE
//	buttions_locs_x += 32 * vx_rel;	//
//	buttions_locs_y += 48 * vy_rel;
	draw_fbuttion(buttions_locs, "crosshair scale");

	string crosshair_scale_mark2, crosshair_scale_mark3, crosshair_scale_mark4, crosshair_scale_mark5, crosshair_scale_mark6;
	string pxelscale;

	float scale_checked = cvar("saved8");
	if (scale_checked == 1)
	{
		crosshair_scale_mark2 = "x";
		pxelscale = "1";
	}
	else
		crosshair_scale_mark2 = " ";
	if (scale_checked == 1.5)
	{
		crosshair_scale_mark3 = "x";
		pxelscale = "1.5";
	}
	else
		crosshair_scale_mark3 = " ";
	if (scale_checked == 2)
	{
		crosshair_scale_mark4 = "x";
		pxelscale = "2";
	}
	else
		crosshair_scale_mark4 = " ";
	if (scale_checked == 2.5)
	{
		crosshair_scale_mark5 = "x";
		pxelscale = "2.5";
	}
	else
		crosshair_scale_mark5 = " ";
	if (scale_checked == 3)
	{
		crosshair_scale_mark6 = "x";
		pxelscale = "3";
	}
	else
		crosshair_scale_mark6 = " ";

	buttions_locs_x += 352 * vx_rel;	//
	buttions_locs_y -= 18 * vy_rel;	//
	draw_fbuttion2(buttions_locs, pxelscale);
	buttions_locs_x -= 32 * vx_rel;
	buttions_locs_y += 18 * vy_rel;	//
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, crosshair_scale_mark2, 720);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, crosshair_scale_mark3, 721);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, crosshair_scale_mark4, 722);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, crosshair_scale_mark5, 723);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, crosshair_scale_mark6, 724);

	buttions_locs_x -= 488 * vx_rel;	// back to the x pos	
	buttions_locs_y += 34 * vy_rel;


	////////// CENTERED WEAPON
	draw_fbuttion(buttions_locs, "Centered Weapons");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked4;
	string mark4;
	checked4 = cvar("saved3");
	if (checked4 == 0)
		mark4 = " ";
	else
		mark4 = "x";
	draw_buttion(buttions_locs, mark4, 110);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;




	////////// SWITCH WEAPON WHEN EMPTY
	draw_fbuttion(buttions_locs, "Switch Empty Weapon");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked5;
	string mark5;
	checked5 = cvar("saved4");
	if (checked5 == 0)
		mark5 = " ";
	else
		mark5 = "x";
	draw_buttion(buttions_locs, mark5, 111);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;

	////////// BLOOD DECALS
	draw_fbuttion(buttions_locs, "Blood Decals");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked6;
	string mark6;
	checked6 = cvar("cl_decals");
	if (checked6 == 0)
		mark6 = " ";
	else
		mark6 = "x";
	draw_buttion(buttions_locs, mark6, 112);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;


	////////// SCREEN FLASH
	draw_fbuttion(buttions_locs, "Flash for Pickups");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked7;
	string mark7;
	checked7 = cvar("saved6");
	if (checked7 == 0)
		mark7 = " ";
	else
		mark7 = "x";
	draw_buttion(buttions_locs, mark7, 116);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;

	////////// ALWAYS RUN
	draw_fbuttion(buttions_locs, "Always Run");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked8;
	string mark8;
	checked8 = cvar("cl_alwaysrun");
	if (checked8 == 0)
		mark8 = " ";
	else
		mark8 = "x";
	draw_buttion(buttions_locs, mark8, 117);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;


	////////// TOGGLE WALK RUN
	draw_fbuttion(buttions_locs, "Toggle Run");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked9;
	string mark9;
	checked9 = cvar("cl_togglerun");
	if (checked9 == 0)
		mark9 = " ";
	else
		mark9 = "x";
	draw_buttion(buttions_locs, mark9, 118);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;
	
	////////// TOGGLE PUNCHANGLE
	draw_fbuttion(buttions_locs, "Toggle Viewpunch");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked10;
	string mark10;
	checked10 = cvar("cl_punch");
	if (checked10 == 0)
		mark10 = " ";
	else
		mark10 = "x";
	draw_buttion(buttions_locs, mark10, 121);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;

	////////// Saved Games Timestamps
	draw_fbuttion(buttions_locs, "Show Timestamps");
	buttions_locs_x += 320 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked11;
	string mark11;
	checked11 = cvar("show_dates");
	if (checked11 == 0)
		mark11 = " ";
	else
		mark11 = "x";
	draw_buttion(buttions_locs, mark11, 122);
	buttions_locs_x -= 320 * vx_rel;
	buttions_locs_y += 34 * vy_rel;
	
	};
void() menu_type_options_audio = 
{
	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);

	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);
	buttions_locs_y = 32 * vy_rel;

	draw_fbuttion3(buttions_locs, "AUDIO OPTIONS");

	////////// MASTER VOLUME
	buttions_locs_y += 32 * vy_rel;
	buttions_locs_x -= 322 * vx_rel;
	draw_fbuttion(buttions_locs, "Master Volume");
	buttions_locs_x += 256 * vx_rel;
	draw_buttion(buttions_locs, "<", 201);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 202);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	mvol = cvar("mastervolume");
	local vector barpos;
	barpos = buttions_locs - fixed_vector('0 0 0');
	barpos_y -= 8 * vy_rel;
	barpos_x += mvol *(256 *vx_rel);

	drawfilldraggeable(barpos, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 4,201, 202, 256 / 20);

//	drawfill(barpos, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0);
	////////// EFFECTS VOLUME
	buttions_locs_x -= 401 * vx_rel;	// back to the x pos
	buttions_locs_y += 28 * vy_rel;
	draw_fbuttion(buttions_locs, "Effects Volume");
	buttions_locs_x += 256 * vx_rel;
	draw_buttion(buttions_locs, "<", 203);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 204);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	effvol = cvar("volume");
	local vector barpos2;
	barpos2 = buttions_locs - fixed_vector('0 0 0');
	barpos2_y -= 8 * vy_rel;
	barpos2_x += effvol *256 * vx_rel;
	drawfilldraggeable(barpos2, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 5,203, 204, 256 / 20);
	//drawfill(barpos2, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0);
	////////// MUSIC VOLUME
	buttions_locs_x -= 401 * vx_rel;	// back to the x pos
	buttions_locs_y += 28 * vy_rel;
	draw_fbuttion(buttions_locs, "Music Volume");
	buttions_locs_x += 256 * vx_rel;
	draw_buttion(buttions_locs, "<", 205);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 206);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	bgmvol = cvar("bgmvolume");
	local vector barpos3;
	barpos3 = buttions_locs - fixed_vector('0 0 0');
	barpos3_y -= 8 * vy_rel;
	barpos3_x += bgmvol *256 * vx_rel;
	drawfilldraggeable(barpos3, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 6,205, 206, 256 / 20);
//	drawfill(barpos3, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0);
	buttions_locs_x -= 401 * vx_rel;	// back to the x pos
	buttions_locs_y += 28 * vy_rel;
};

void() menu_type_confirmresolution = 
{
	local vector buttions_locs;
	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);

	buttions_locs_y = 172 * vy_rel;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	buttions_locs_x += 128 * vx_rel;
	drawfill(buttions_locs + fixed_vector('-256 -32 0'), fixed_vector('464 128 0'), '0.2 0.2 0.23', 0.7, 0);
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);
	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CONFIRM RESOLUTION", 278);

	buttions_locs_x += 148 * vx_rel;
	buttions_locs_y += 48 * vy_rel;
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);

	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CANCEL", 279);
};

void() menu_type_confirmfullscreen = 
{
	local vector buttions_locs;
	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);

	buttions_locs_y = 172 * vy_rel;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	buttions_locs_x += 128 * vx_rel;
	drawfill(buttions_locs + fixed_vector('-256 -32 0'), fixed_vector('464 128 0'), '0.2 0.2 0.23', 0.7, 0);
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);
	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CONFIRM", 321);

	buttions_locs_x += 148 * vx_rel;
	buttions_locs_y += 48 * vy_rel;
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);

	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CANCEL", 322);
};
void() menu_type_confirmresettodefaults = 
{
	local vector buttions_locs;
	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);

	buttions_locs_y = 172 * vy_rel;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	buttions_locs_x += 128 * vx_rel;
	drawfill(buttions_locs + fixed_vector('-256 -32 0'), fixed_vector('464 128 0'), '0.2 0.2 0.23', 0.7, 0);
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);
	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "ACCEPT", 119);

	buttions_locs_x += 148 * vx_rel;
	buttions_locs_y += 48 * vy_rel;
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);

	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CANCEL", 19);
};

void() menu_type_deleteprofile = 
{
	local vector buttions_locs;
	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);

	buttions_locs_y = 172 * vy_rel;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	buttions_locs_x += 128 * vx_rel;
	drawfill(buttions_locs + fixed_vector('-256 -32 0'), fixed_vector('464 128 0'), '0.2 0.2 0.23', 0.7, 0);
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);
	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CONFIRM", 17);

	buttions_locs_x += 148 * vx_rel;
	buttions_locs_y += 48 * vy_rel;
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);

	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CANCEL", 2);
};



void() menu_type_confirmantialias = 
{
	local vector buttions_locs;
	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);

	buttions_locs_y = 172 * vy_rel;
	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	buttions_locs_x += 128 * vx_rel;
	drawfill(buttions_locs + fixed_vector('-256 -32 0'), fixed_vector('464 128 0'), '0.2 0.2 0.23', 0.7, 0);
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);
	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CONFIRM", 311);

	buttions_locs_x += 148 * vx_rel;
	buttions_locs_y += 48 * vy_rel;
	drawfill(buttions_locs + fixed_vector('-200 4 0'), fixed_vector('380 32 0'), '0.1 0.1 0.1', 0.7, 0);

	buttions_locs_x -= 148 * vx_rel;
	draw_buttion(buttions_locs, "CANCEL", 312);
};

void() menu_type_options_resolution = 
{
	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;

	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);

	buttions_locs_y = 32 * vy_rel;

	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	//	buttions_locs_x -= 180* vx_rel;

	draw_fbuttion3(buttions_locs, "DISPLAY RESOLUTION");
	buttions_locs_x -= 360 * vx_rel;

	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "4:3");
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1280 * 960", 250);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1360 * 1024", 251);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1600 * 1200", 252);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1920 * 1440", 253);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "2560 * 1920", 254);
	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "5:3");
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1280 * 768", 255);
	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "5:4");
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1280 * 1024", 256);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1600 * 1280", 257);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "2560 * 2048", 258);
	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "16:9");
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1280 * 720", 259);
	//	buttions_locs_y += 32 * vy_rel;

	buttions_locs_y = 64 * vy_rel;
	buttions_locs_x += 250 * vx_rel;
	draw_fbuttion(buttions_locs, "16:9");
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1360 * 768", 260);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1366 * 768", 261);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1600 * 900", 262);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1680 * 1050", 263);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1920 * 1080", 264);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "2560 * 1440", 265);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "3840 * 2160", 266);
	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "16:10");
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1280 * 800", 267);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1440 * 900", 268);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "1920 * 1200", 269);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "2560 * 1600", 270);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "3840 * 2400", 271);

	buttions_locs_y = 64* vy_rel;
	buttions_locs_x += 250* vx_rel;

	draw_fbuttion(buttions_locs, "21:9");

	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "2560 * 1080", 272);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "3440 * 1440", 273);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "3840 * 1600", 274);
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "5120* 2160", 275);
	buttions_locs_y += 32 * vy_rel;
	
	draw_fbuttion(buttions_locs, "1.9:1");
	buttions_locs_y += 32 * vy_rel;
	draw_buttion(buttions_locs, "4096 * 2160", 276);


	
	buttions_locs_y += 96 * vy_rel;

	buttions_locs_x -= 250* vx_rel;
	

	////////// Fullscreen
	//buttions_locs_y = 64 * vy_rel;
	buttions_locs_x += 250 * vx_rel;

	draw_fbuttion(buttions_locs, "Fullscreen");
	buttions_locs_x += 246 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked7;
	string anim_mark;
	checked7 = cvar("vid_fullscreen");
	if (checked7 == 1)
		anim_mark = "x";
	else
		anim_mark = " ";
	draw_buttion(buttions_locs, anim_mark, 320);
	buttions_locs_x -= 256 * vx_rel;

};

void() menu_type_options_video = 
{
	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;

	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);
	buttions_locs_y = 32 * vy_rel;

	if (clientstate() != CS_CONNECTED)
		drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);

	draw_fbuttion3(buttions_locs, "VIDEO OPTIONS");
	buttions_locs_x -= 390 * vx_rel;

	buttions_locs_y = 64 * vy_rel;
	////////// V_SYNC
	draw_fbuttion(buttions_locs, "V-Sync");

	buttions_locs_x += 196 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked;
	string mark;
	checked = cvar("vid_vsync");
	if (checked == 1)
		mark = "x";
	else
		mark = " ";
	draw_buttion(buttions_locs, mark, 290);
	buttions_locs_x -= 196 * vx_rel;

	////////// BRIGHTNESS
	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "Brightness");
	buttions_locs_x += 96 * vx_rel;	//
	draw_buttion(buttions_locs, "<", 291);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 292);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	brightlev = cvar("r_hdr_scenebrightness");
	local vector barpos1;
	barpos1 = buttions_locs - '0 0 0';
	barpos1_y -= 8 * vy_rel;
	barpos1_x += brightlev *128 * vx_rel;
	//drawfill(barpos1, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0);
	drawfilldraggeable(barpos1, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 7,291, 292, 256 / 40);
	//	string bbri;bbri = ftos (brightlev);draw_fbuttion2(barpos1 + '-128.5 -24 0', bbri);
	buttions_locs_x -= 241 * vx_rel;	// back to the x pos

	////////// GAMMA
	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "gamma");
	buttions_locs_x += 96 * vx_rel;	//
	draw_buttion(buttions_locs, "<", 293);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 294);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	gammalev = cvar("v_gamma");
	local vector barpos2;
	barpos2 = buttions_locs - fixed_vector('14 0 0');
	barpos2_y -= 8 * vy_rel;
	barpos2_x += gammalev *133 * vx_rel;
	//drawfill(barpos2, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0);
	drawfilldraggeable(barpos2, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 8,293, 294, 256 / 40);
	//	string bgam;bgam = ftos (gammalev);draw_fbuttion2(barpos2 + '-128.5 -24 0', bgam);
	buttions_locs_x -= 241 * vx_rel;	// back to the x pos

	////////// CONTRAST
	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "contrast");
	buttions_locs_x += 96 * vx_rel;	//
	draw_buttion(buttions_locs, "<", 295);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 296);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	contlev = cvar("v_contrast");
	local vector barpos3;
	barpos3 = buttions_locs - fixed_vector('28 0 0');
	barpos3_y -= 8 * vy_rel;
	barpos3_x += contlev *142 * vx_rel;
	//	drawfill(barpos3, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0);
	drawfilldraggeable(barpos3, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 9,295, 296, 256 / 40);
	//	string bcon;bcon = ftos (contlev);draw_fbuttion2(barpos3 + fixed_vector('-128.5 -24 0'), bcon);
	buttions_locs_x -= 241 * vx_rel;	// back to the x pos	

	////////// FOV
	buttions_locs_y += 32 * vy_rel;
	draw_fbuttion(buttions_locs, "fov");
	buttions_locs_x += 96 * vx_rel;	//
	draw_buttion(buttions_locs, "<", 297);
	buttions_locs_x += 290 * vx_rel;
	draw_buttion(buttions_locs, ">", 298);
	buttions_locs_y += 16 * vy_rel;
	buttions_locs_x -= 145 * vx_rel;
	drawfill(buttions_locs, fixed_vector('256 4 0'), '0.5 0.5 0.35', 0.7, 0);
	fovlev = cvar("fov");
	float fovlev_v;
	fovlev_v = (fovlev - 80) / 21;
	local vector barpos4;
	barpos4 = buttions_locs - fixed_vector('0 0 0');
	barpos4_y -= 8 * vy_rel;
	barpos4_x += fovlev_v *133 * vx_rel;
//	drawfill
	
	drawfilldraggeable(barpos4, fixed_vector('4 16 0'), '0.75 0.75 0.5', 1, 0, 1,297, 298, 256 / 40);
	string bdesc;bdesc = ftos(fovlev);draw_fbuttion2(barpos4 + fixed_vector('-128.5 -24 0'), bdesc);
	buttions_locs_x -= 241 * vx_rel;	// back to the x pos		

	////////// PIXEL SCALING
	buttions_locs_x += 32 * vx_rel;	//
	buttions_locs_y += 48 * vy_rel;
	draw_fbuttion(buttions_locs, "pixel scaling");

	float checked2;
	string mark2, mark3, mark4, mark5, mark6;
	string pxelscale;

	checked2 = cvar("r_viewscale");
	if (checked2 == 1)
	{
		mark2 = "x";
		pxelscale = "native";
	}
	else
		mark2 = " ";
	if (checked2 == 0.5)
	{
		mark3 = "x";
		pxelscale = "double";
	}
	else
		mark3 = " ";
	if (checked2 == 0.333)
	{
		mark4 = "x";
		pxelscale = "triple";
	}
	else
		mark4 = " ";
	if (checked2 == 0.25)
	{
		mark5 = "x";
		pxelscale = "quadruple";
	}
	else
		mark5 = " ";
	if (checked2 == 0.125)
	{
		mark6 = "x";
		pxelscale = "octuple";
	}
	else
		mark6 = " ";

	buttions_locs_x += 196 * vx_rel;	//
	buttions_locs_y -= 18 * vy_rel;	//
	draw_fbuttion2(buttions_locs, pxelscale);
	buttions_locs_x -= 32 * vx_rel;
	buttions_locs_y += 18 * vy_rel;	//
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, mark2, 700);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, mark3, 701);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, mark4, 702);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, mark5, 703);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, mark6, 704);

	buttions_locs_x -= 322 * vx_rel;	// back to the x pos	


	
	////////// MAX FPS
	buttions_locs_x -= 10 * vx_rel;	//
	buttions_locs_y += 48 * vy_rel;
	draw_fbuttion(buttions_locs, "max fps");

	float checkedfps;
	string fpsmark2, fpsmark3, fpsmark4, fpsmark5, fpsmark6, fpsmark7;
	string maxfps;

	checkedfps= cvar("cl_maxfps");
	if (checkedfps== 60)
	{
		fpsmark2 = "x";
		maxfps = "60";
	}
	else
		fpsmark2 = " ";
	if (checkedfps== 120)
	{
		fpsmark3 = "x";
		maxfps = "120";
	}
	else
		fpsmark3 = " ";
	if (checkedfps== 144)
	{
		fpsmark4 = "x";
		maxfps = "144";
	}
	else
		fpsmark4 = " ";
	if (checkedfps== 240)
	{
		fpsmark5 = "x";
		maxfps = "240";
	}
	else
		fpsmark5 = " ";
	if (checkedfps== 500)
	{
		fpsmark6 = "x";
		maxfps = "500";
	}
	else
		fpsmark6 = " ";
	if ((checkedfps== 0) ||(checkedfps> 500))
	{
		fpsmark7 = "x";
		maxfps = "unlimited";
	}
	else
		fpsmark7 = " ";
	buttions_locs_x += 196 * vx_rel;	//
	buttions_locs_y -= 18 * vy_rel;	//
	draw_fbuttion2(buttions_locs, maxfps);
	buttions_locs_x -= 32 * vx_rel;
	buttions_locs_y += 18 * vy_rel;	//
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, fpsmark2, 710);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, fpsmark3, 711);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, fpsmark4, 712);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, fpsmark5, 713);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, fpsmark6, 714);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, fpsmark7, 715);

	buttions_locs_x -= 406 * vx_rel;	// back to the x pos		
	//////// ANISOTROPY FILTERING	
	buttions_locs_x += 32 * vx_rel;	//
	buttions_locs_y += 48 * vy_rel;

	draw_fbuttion(buttions_locs, "ANISOTROPY");

	float checked3;
	string anysotrop_mark2, anysotrop_mark3, anysotrop_mark4, anysotrop_mark5;
	string anysotropicale;

	checked3 = cvar("gl_texture_anisotropy");
	if (checked3 == 2)
	{
		anysotrop_mark2 = "x";
		anysotropicale = "2X";
	}
	else
		anysotrop_mark2 = " ";
	if (checked3 == 4)
	{
		anysotrop_mark3 = "x";
		anysotropicale = "4X";
	}
	else
		anysotrop_mark3 = " ";
	if (checked3 == 8)
	{
		anysotrop_mark4 = "x";
		anysotropicale = "8X";
	}
	else
		anysotrop_mark4 = " ";
	if (checked3 == 16)
	{
		anysotrop_mark5 = "x";
		anysotropicale = "16X";
	}
	else
		anysotrop_mark5 = " ";

	buttions_locs_x += 196 * vx_rel;	//
	buttions_locs_y -= 18 * vy_rel;	//
	draw_fbuttion2(buttions_locs, anysotropicale);
	buttions_locs_x -= 32 * vx_rel;
	buttions_locs_y += 18 * vy_rel;	//
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, anysotrop_mark2, 303);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, anysotrop_mark3, 304);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, anysotrop_mark4, 305);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, anysotrop_mark5, 306);
	buttions_locs_x -= 322 * vx_rel;	// back to the x pos	

	//////// ANTI-ALIASING	
	buttions_locs_x += 32 * vx_rel;	//
	buttions_locs_y += 48 * vy_rel;

	draw_fbuttion(buttions_locs, "MSAA");
	float checked4;
	string antialias_mark2, antialias_mark3, antialias_mark4, antialias_mark5;
	string antialiasing;

	checked4 = cvar("vid_samples");
	if (checked4 < 2)
	{
		antialias_mark2 = "x";
		antialiasing = "Off";
	}
	else
		antialias_mark2 = " ";
	if (checked4 == 2)
	{
		antialias_mark3 = "x";
		antialiasing = "2X";
	}
	else
		antialias_mark3 = " ";
	if (checked4 == 4)
	{
		antialias_mark4 = "x";
		antialiasing = "4X";
	}
	else
		antialias_mark4 = " ";
	if (checked4 == 8)
	{
		antialias_mark5 = "x";
		antialiasing = "8X";
	}
	else
		antialias_mark5 = " ";

	buttions_locs_x += 196 * vx_rel;	//
	buttions_locs_y -= 18 * vy_rel;	//
	draw_fbuttion2(buttions_locs, antialiasing);
	buttions_locs_x -= 32 * vx_rel;
	buttions_locs_y += 18 * vy_rel;	//
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, antialias_mark2, 307);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, antialias_mark3, 308);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, antialias_mark4, 309);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, antialias_mark5, 310);
	buttions_locs_x -= 322 * vx_rel;	// back to the x pos	

	////////// FORCED REFRESH RATE

	buttions_locs_x = (vid_x / 2) - (128 *vx_rel);
	buttions_locs_x += 128 * vx_rel;
	buttions_locs_y = 64 * vy_rel;

	draw_fbuttion(buttions_locs, "Forced Refresh Rate");

	buttions_locs_x += 196 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checkeda;
	string markb;
	checkeda = cvar("vid_forcerefreshrate");
	if (checkeda == 1)
		markb = "x";
	else
		markb = " ";
	draw_buttion(buttions_locs, markb, 280);
	buttions_locs_x -= 226 * vx_rel;



	buttions_locs_y += 48 * vy_rel;

	////////// REFRESH RATE

	draw_fbuttion(buttions_locs, "Refresh Rate");

	float checkedrefreshrate;
	string refreshratemark2, refreshratemark3, refreshratemark4, refreshratemark5, refreshratemark6, refreshratemark7, refreshratemark8;
	string refreshrate;

	checkedrefreshrate= cvar("vid_refreshrate");
	if (checkedrefreshrate== 50)
	{
		refreshratemark2 = "x";
		refreshrate= "50";
	}
	else
		refreshratemark2 = " ";
	if (checkedrefreshrate== 59)
	{
		refreshratemark3 = "x";
		refreshrate= "59";
	}
	else
		refreshratemark3 = " ";
	if (checkedrefreshrate== 60)
	{
		refreshratemark4 = "x";
		refreshrate= "60";
	}
	else
		refreshratemark4 = " ";
	if (checkedrefreshrate== 75)
	{
		refreshratemark5 = "x";
		refreshrate= "75";
	}
	else
		refreshratemark5 = " ";
	if (checkedrefreshrate== 120)
	{
		refreshratemark6 = "x";
		refreshrate= "120";
	}
	else
		refreshratemark6 = " ";
	if (checkedrefreshrate== 144)
	{
		refreshratemark7 = "x";
		refreshrate= "144";
	}
	else
		refreshratemark7 = " ";
	if (checkedrefreshrate== 240)
	{
		refreshratemark8 = "x";
		refreshrate= "240";
	}
	else
		refreshratemark8 = " ";
	buttions_locs_x += 148 * vx_rel;	//
	buttions_locs_y -= 18 * vy_rel;	//
	draw_fbuttion2(buttions_locs, refreshrate);
	buttions_locs_x -= 32 * vx_rel;
	buttions_locs_y += 18 * vy_rel;	//
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, refreshratemark2, 281);
	buttions_locs_x += 38 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, refreshratemark3, 282);
	buttions_locs_x += 38 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, refreshratemark4, 283);
	buttions_locs_x += 38 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, refreshratemark5, 284);
	buttions_locs_x += 38 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, refreshratemark6, 285);
	buttions_locs_x += 38 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, refreshratemark7, 286);
	buttions_locs_x += 38 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, refreshratemark8, 287);

	buttions_locs_x -= 286 * vx_rel;	// back to the x pos		


	buttions_locs_y += 48 * vy_rel;
	buttions_locs_y += 48 * vy_rel;
	buttions_locs_y += 48 * vy_rel;

	////////// TEXTURE FILTER


	float texturemodef;
	string texturemode;
	string text_mark2, text_mark3, text_mark4;

	texturemodef = cvar("saved2");

	if (texturemodef == 0)
		texturemode = "None";
	if (texturemodef == 1)
		texturemode = "None + Linear Maps";
	if (texturemodef == 2)
		texturemode = "Linear";

	draw_fbuttion(buttions_locs, "Texture Filter");
	float checked5;
	checked5 = cvar("saved2");
	if (checked5 < 1)
	{
		text_mark2 = "x";
		texturemode = "None";
	}
	else
		antialias_mark2 = " ";
	if (checked5 == 1)
	{
		text_mark3 = "x";
		texturemode = " Linear Mips";
	}
	else
		antialias_mark3 = " ";
	if (checked5 == 2)
	{
		text_mark4 = "x";
		texturemode = "Linear";
	}
	else
		text_mark4 = " ";
	buttions_locs_y -= 18 * vy_rel;
	buttions_locs_x += 170 * vx_rel;
	draw_fbuttion2(buttions_locs, texturemode);
	buttions_locs_y += 18 * vy_rel;
	//	buttions_locs_x -= 128* vx_rel;

	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, text_mark2, 315);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, text_mark3, 316);
	buttions_locs_x += 42 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	draw_buttion(buttions_locs, text_mark4, 317);
	buttions_locs_x -= 254 * vx_rel;

	/*
	////////// MipMap Models 
	buttions_locs_y += 48* vy_rel;

	draw_fbuttion(buttions_locs, "MipMap Models");
	buttions_locs_x += 256* vx_rel;
	drawfill (buttions_locs +fixed_vector('118 10 0'),fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked6;
	string mipmap_mark;
	checked6 = cvar ("r_mipskins");
	if (checked6 == 1)
	mipmap_mark = "x";
	else
	mipmap_mark = " ";		
	draw_buttion(buttions_locs, mipmap_mark, 318);
	buttions_locs_x -= 256* vx_rel;
	*/
	
	////////// Anti-aliasing FXAA
	buttions_locs_y += 48 * vy_rel;
	buttions_locs_x += 10 * vx_rel;

	draw_fbuttion(buttions_locs, "Anti-aliasing FXAA");
	buttions_locs_x += 244 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checkedfxaa;
	string antialias_mark6;
	checkedfxaa = cvar("r_fxaa");
	if (checkedfxaa == 1)
		antialias_mark6 = "x";
	else
		antialias_mark6 = " ";
	draw_buttion(buttions_locs, antialias_mark6, 314);

	buttions_locs_x -= 256* vx_rel;	
	
	////////// Animation Interpolation
	buttions_locs_y += 48 * vy_rel;
	buttions_locs_x += 10 * vx_rel;

	draw_fbuttion(buttions_locs, "Anim. Interpolation");
	buttions_locs_x += 246 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked7;
	string anim_mark;
	checked7 = cvar("r_lerpmodels");
	if (checked7 == 1)
		anim_mark = "x";
	else
		anim_mark = " ";
	draw_buttion(buttions_locs, anim_mark, 319);
	buttions_locs_x -= 256 * vx_rel;
	////////// Palettized 
	buttions_locs_y += 48 * vy_rel;
	buttions_locs_x += 10 * vx_rel;

	draw_fbuttion(buttions_locs, "software palettization");
	buttions_locs_x += 246 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	//float checked7;
	string anim_markb;
	checked7 = cvar("r_glsl_postprocess");
	if (checked7 == 1)
		anim_markb = "x";
	else
		anim_markb = " ";
	draw_buttion(buttions_locs, anim_markb, 323);
	buttions_locs_x -= 256 * vx_rel;
	////////// Real Time Lights
	buttions_locs_y += 48 * vy_rel;

	draw_fbuttion(buttions_locs, "Dynamic Lights");
	buttions_locs_x += 256 * vx_rel;
	drawfill(buttions_locs + fixed_vector('118 10 0'), fixed_vector('20 20 0'), '0.35 0.35 0.35', 0.7, 0);
	float checked8;
	string mipmap_mark;
	checked8 = cvar("r_dynamic");
	if (checked8 == 1)
		mipmap_mark = "x";
	else
		mipmap_mark = " ";
	draw_buttion(buttions_locs, mipmap_mark, 324);
	buttions_locs_x -= 256 * vx_rel;
	////////// 
};
string string_null;

void(vector txt_pos) menu_type_profile = 
{
	vector buttions_locs;
	buttions_locs_x = ((vid_x / 2) - (70 *vx_rel));
	buttions_locs_y = 216 * vy_rel;

	drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);
	buttions_locs_x += 128 * vx_rel;
	drawfill(buttions_locs + fixed_vector('-256 -32 0'), fixed_vector('384 96 0'), '0.2 0.2 0.23', 0.7, 0);
	buttions_locs_x -= 100 * vx_rel;
	drawfill(buttions_locs + fixed_vector('154 4 0'), fixed_vector('48 32 0'), '0.5 0.3 0.3', 0.7, 0);
	buttions_locs_x += 100 * vx_rel;
	drawfill(buttions_locs + fixed_vector('-230 4 0'), fixed_vector('242 24 0'), '0.1 0.1 0.1', 0.7, 0);
	buttions_locs_x -= 48 * vx_rel;

	if (oldprofileslot)
		oldprofileslot = 0;
	if (oldtotalprofileslots)
		oldtotalprofileslots = 0;

	local float f, nameused;	// file handle, basically assigns a number to whatever file is open
	local string ln;	// ln = line of the file being read
	f = fopen("profiles/profilenames.txt", FILE_READ);
	if (f != -1)	// if f = -1 then the file could not be found
	{
		ln = fgets(f);	// this line sets ln to the string read from the file with the file handle of f
		while (ln != string_null)	// while there is still text to be read do the following
		{
			{
				if (ln == gah)
				{
					fclose(f);	// when the while loop is over (no lines left in file) close file with the handle f
					nameused = 1;
				}
			}

			ln = fgets(f);	// get a new line from the file
		}
	}

	fclose(f);	// when the while loop is over (no lines left in file) close file with the handle f

	if ((gah != "") && (!nameused))
	{
		draw_buttion(buttions_locs, "OK", 4);
		enterindex = 4;
	}
	else
	{
		draw_fbuttion(buttions_locs, "OK");
		enterindex = 0;
	}
	float vid_w = cvar("vid_width");
	float vid_h = cvar("vid_height");

	if ((vid_w == 2560) && (vid_h == 1440))
		txt_pos_x += 407 * vx_rel;

	else
		txt_pos_x += 312 * vx_rel;
	txt_pos_y += 199 * vy_rel;

	if (nameused == 1)
		drawstring(txt_pos, "Name Taken", fixed_vector('14 14 0'), '2 0.8 0.9', 1, 0);
	else
		drawstring(txt_pos, "Create Profile", fixed_vector('14 14 0'), '0.75 0.75 0.7', 1, 0);
	txt_pos_y += 28 * vy_rel;
	drawstring(txt_pos, gah, fixed_vector('14 14 0'), fixed_vector('4 4 2'), 1, 0);
	txt_pos_y += 64 * vy_rel;

};

void() menuprofile_next = 
{
	if (profileslotpage < 10)
		profileslotpage++;
	if (profileslotpage >= 10)
		profileslotpage = 10;
	profileslot = profileslotpage;
	write_currentprofileslot();
};
void() menuprofile_prev = 
{
	if (profileslotpage > 1)
		profileslotpage--;
	if (profileslotpage <= 1)
		profileslotpage = 1;
	profileslot = profileslotpage;
	write_currentprofileslot();
};

void() menuprofile_select = 
{
	profileslotpage = nprof;
	profileslot = profileslotpage;
	write_currentprofileslot();
};

void() menu_type_resume = 
{

	float show_dates = cvar("show_dates");



 if (oldtotalprofileslots > 0)
		oldtotalprofileslots = 0;

	local vector size, buttions_locs;
	size_x = vid_x;
	size_y = vid_y;

	buttions_locs_x = (vid_x / 2) - (512 *vx_rel);
	buttions_locs_y = 384 * vy_rel;

	drawpic('0 0 0', "gfx/menu/background.tga", vid_x *'1 0 0' + vid_y *'0 1 0', '0.65 0.65 0.65', 1, 0);

	float vid_rwidth = cvar("vid_width");
	float vid_rheight = cvar("vid_height");

	vector journalpos, sizeimage;
	journalpos = (journalpos);
	sizeimage = fixed_vector2('512 360 0');
	journalpos_x = (vid_x / 2) - (sizeimage_x / 2);
	journalpos_y = (vid_y / 2) - (sizeimage_y / 2);

	drawpic(journalpos, "gfx/menu/load_menu.tga", sizeimage, '1 1 1', 1, 0);

	string cname;
	cname = profilename;
	if (oldprofileslot != profileslot)
	{
		check_profilenames_str(profileslot);	
	}
	if(show_dates ==  1)
	{

		checkdates (profilename);
		get_timestamp_map(profilename);
		string selected_date = "autosave_date";	
		
		if (type_load_selected == 1)
		{
			string selected_date = autosave_date;	
			drawpic(journalpos, timestamp_map1, sizeimage, '1 1 1', 1, 0);
		}
		if (type_load_selected == 2)
		{
			selected_date = tether_date;	
			drawpic(journalpos, timestamp_map2, sizeimage, '1 1 1', 1, 0);
		}
		if (type_load_selected == 3)
		{
			selected_date = shrine_date;	
			drawpic(journalpos,timestamp_map3, sizeimage, '1 1 1', 1, 0);
		}
		
	}




	float emptyprofile;

	if (cname != "")
	{
		emptyprofile = 0;
		//drawstring (fixed_vector('90 354 0'),cname, fixed_vector('14 14 0'), '0.75 0.75 0.7', 1, 0);
		if (oldprofileslot != profileslot)
			check_profile_saves(cname);
	}
	else
	{
		//drawstring (fixed_vector('90 354 0'),"<empty profile>", fixed_vector('14 14 0'), '1 0.25 0.25', 1, 0);
		emptyprofile = 1;
	}

	//drawfill (fixed_vector('90 377 0'),fixed_vector('270 1 0'), '0.5 0.5 0.6', 1, 0);
	//drawfill (fixed_vector('90 378 0'),fixed_vector('270 2 0'), '0.3 0.3 0.4', 1, 0);
	vector posstring, fixedpos;
	fixedpos = fixed_vector('240 76 0');

	local float posx_modifier;
	posx_modifier = (size_x / size_y);
	if (posx_modifier >= 1.6)
		posx_modifier = 1;

	if (posx_modifier >= 1.6)
		posx_modifier = 1;
	if (ceil((posx_modifier) *100) == (134))
		posx_modifier = 1.15;
	if (ceil((posx_modifier) *100) == (125))
		posx_modifier = 1.15;
	if (ceil((posx_modifier) *100) == (160))
		posx_modifier = 1.15;
	if (ceil((posx_modifier) *100) == (167))
		posx_modifier = 1.15;
	local float txt_len;

	posstring_x = (size_x / 2) - (fixedpos_x *posx_modifier);
	local float pos_y;
	posstring_y = journalpos_y + fixedpos_y;
	pos_y = posstring_y;
	check_profilenames();
	check_profilenames_str2();

	if (c_profilename1 == "")
		c_profilename1 = "<empty profile>";
	if (c_profilename2 == "")
		c_profilename2 = "<empty profile>";
	if (c_profilename3 == "")
		c_profilename3 = "<empty profile>";
	if (c_profilename4 == "")
		c_profilename4 = "<empty profile>";
	if (c_profilename5 == "")
		c_profilename5 = "<empty profile>";
	if (c_profilename6 == "")
		c_profilename6 = "<empty profile>";
	if (c_profilename7 == "")
		c_profilename7 = "<empty profile>";

	//posstring_x += aspectratio_fix_x *(vid_rwidth / vid_rheight);
	if (c_profilename1 != "<empty profile>")
		draw_buttionprofile((posstring), c_profilename1, 1);posstring_y += 28 * vy_rel;
	if (c_profilename2 != "<empty profile>")
		draw_buttionprofile((posstring), c_profilename2, 2);posstring_y += 28 * vy_rel;
	if (c_profilename3 != "<empty profile>")
		draw_buttionprofile((posstring), c_profilename3, 3);posstring_y += 28 * vy_rel;
	if (c_profilename4 != "<empty profile>")
		draw_buttionprofile((posstring), c_profilename4, 4);posstring_y += 28 * vy_rel;
	if (c_profilename5 != "<empty profile>")
		draw_buttionprofile((posstring), c_profilename5, 5);posstring_y += 28 * vy_rel;
	if (c_profilename6 != "<empty profile>")
		draw_buttionprofile((posstring), c_profilename6, 6);posstring_y += 28 * vy_rel;
	if (c_profilename7 != "<empty profile>")
		draw_buttionprofile((posstring), c_profilename7, 7);posstring_y += 28 * vy_rel;

	if (c_profilename1 != "<empty profile>")
		strunzone(c_profilename1);
	if (c_profilename2 != "<empty profile>")
		strunzone(c_profilename2);
	if (c_profilename3 != "<empty profile>")
		strunzone(c_profilename3);
	if (c_profilename4 != "<empty profile>")
		strunzone(c_profilename4);
	if (c_profilename5 != "<empty profile>")
		strunzone(c_profilename5);
	if (c_profilename6 != "<empty profile>")
		strunzone(c_profilename6);
	if (c_profilename7 != "<empty profile>")
		strunzone(c_profilename7);

	/*	if(profileslotpage > 1)
		draw_buttion(buttions_locs, "<", 5);
		else
		draw_fbuttion(buttions_locs, "<");

		buttions_locs_x += 256* vx_rel;
		if(profileslotpage < 10)
		draw_buttion(buttions_locs, ">", 6);
		else
		draw_fbuttion(buttions_locs, ">");

	*/
	fixedpos = fixed_vector('-20 0 0');

	posx_modifier = (size_x / size_y);
	if (posx_modifier >= 1.6)
		posx_modifier = 1;

	if (posx_modifier >= 1.6)
		posx_modifier = 1;
	if (ceil((posx_modifier) *100) == (134))
		posx_modifier = 1.15;
	if (ceil((posx_modifier) *100) == (125))
		posx_modifier = 1.15;
	if (ceil((posx_modifier) *100) == (160))
		posx_modifier = 1.15;
	if (ceil((posx_modifier) *100) == (167))
		posx_modifier = 1.15;


	local vector deletebuttonpos;
	deletebuttonpos_x = posstring_x + 24 * vx_rel;

	buttions_locs_x = (size_x / 2) + (fixedpos_x *(posx_modifier));
	buttions_locs_y = pos_y;

	local string sorete;
	sorete = ftos(currentprofilessaves);
	deletebuttonpos_y = pos_y + 192 * vy_rel;

	if (!emptyprofile)
	{
		if (profilemenuversion  != menuversion)
		{
			buttions_locs_y += 24 * vy_rel;
			draw_fbuttion_warning(buttions_locs, "This profile");
			buttions_locs_y += 24 * vy_rel;
			draw_fbuttion_warning(buttions_locs, "is not compatible");
			buttions_locs_y += 24 * vy_rel;
			draw_fbuttion_warning(buttions_locs, "with this version");
			buttions_locs_y += 24 * vy_rel;
			draw_fbuttion_warning(buttions_locs, "of Wrath ");
			
			draw_buttionwrath(deletebuttonpos, "Delete", 16);

		}
		else
		{
			draw_buttionload((buttions_locs), "Autosave", 1);
			buttions_locs_y += 32 * vy_rel;
			if (currentprofilessaves & 1)
			{
				draw_buttionload((buttions_locs), " Soul Tether", 2);
				buttions_locs_y += 32 * vy_rel;
			}
			if (currentprofilessaves & 2)
			{
				draw_buttionload((buttions_locs), "Shrine", 3);
			}
			buttions_locs_y = pos_y + 192 * vy_rel;
			fixedpos = fixed_vector('20 0 0');
			buttions_locs_x += (fixedpos_x *(posx_modifier));
			local vector txt_pos;

			vector posfix, imgsize;
			posfix_x = 128 * vx_rel;
			posfix_y = 10 * vy_rel;

			txt_pos = buttions_locs + posfix;
			txt_len = stringwidth("NEWGAME GAME", true, BTT_FONT_SIZE);
			txt_pos_x -= (txt_len / 2);

			imgsize = fixed_vector2('152 40 0');

			if (type_load_selected > 0)
				draw_buttionwrath(buttions_locs, "Load", 7);
			else
				drawpic(txt_pos, "gfx/menu/load_game.tga", imgsize, '1 1 1', 1, 0);
			
			draw_buttionwrath(deletebuttonpos, "Delete", 16);
		}
		
		if(show_dates ==  1)
		{			
			txt_pos_y -= 87 * vy_rel;
			txt_pos_x += 24 * vx_rel;
			if (type_load_selected >= 1)
			{
				txt_pos_x += 0 * vx_rel;
				string selected_date_a = substring(selected_date,0,11);
				string selected_date_b = substring(	selected_date,11,10);
				txt_pos_y -= 6 * vy_rel;
				drawstring(txt_pos, selected_date_a,fixed_vector('10 10 0'), '-1 -1 -1', 0.7, 0);	
				txt_pos_x += 9 * vx_rel;
				txt_pos_y += 84 * vy_rel;
				drawstring(txt_pos, selected_date_b,fixed_vector ('10 10 0'), '-1 -1 -1', 0.7, 0);	
			}
		}
		
	}

	oldprofileslot = profileslot;
	
};

