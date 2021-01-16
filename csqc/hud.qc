/////// PULSES
float phicon;
float slphicon;
float shphicon;
float spphicon;
float rephicon;

float arphicon;
float drphicon;

///////

/////// DAMAGE BARS
float dml;	// damage bar left
float dmr;	// damage bar right
float dmu;	// damage bar up
float dmd;	// damage bar down
///////

float mm;
string shd;
string shd2;
float bbar;
float rndm;
float arailb;
float shrinepresent;

void() write_tether = 
{
	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tetherclient.txt");

	local float writeparms;
	local string writethis;
	writeparms = fopen(campaignloc, FILE_WRITE);	//open what file to use in write mode
	writethis = ftos(0);	//prepare the next thing to write
	fputs(writeparms, writethis);	//line 1
	fputs(writeparms, "\n");	//and again
	fclose(writeparms);
	if (profilename)
		strunzone(profilename);
};


 
void() check_tether = 
{
	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tether.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	tether = stof(readtext);
	fclose(readparms);
	//float tetherp;
	//tetherp = floor(getstatf(STAT_TETHER));
	//if (tetherp <= 0)
	//	tether = 0;
	if (profilename)
		strunzone(profilename);
};
float shrine_user;
void() check_shrine_user = 
{
	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/shrine_user.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	shrine_user = stof(readtext);
	fclose(readparms);
	if (profilename)
		strunzone(profilename);
};
float mm2;
void() Death_Menu = 
{
	vector omp;

	if (mm2 == 0)
	{
		setcursormode(1);
		mm2 = 1;
	}

	omp = getmousepos();	//;
	vector relomp;
	relomp_y = omp_y;

	drawfill('0 0 0', vid_width *'1 0 0' + vid_height *'0 1 0', '0 0 0', 0.65 *dmenualpha, 0);

	local vector dmsgpos2;
	dmsgpos2_x = dmsgpos_x + ((vid_width - 960) / 2);
	dmsgpos2_y = dmsgpos_y * vy_rel;

	if (!DMselected)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuA.tga", dmenualpha, 1, '1 0 0', '256 144 0');
	if (DMselected == 1)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuA.tga", dmenualpha, 1, '1 1 1', '256 144 0');
	if (DMselected == 2)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuB.tga", dmenualpha, 1, '1 1 1', '256 144 0');
	if (DMselected == 3)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuC.tga", dmenualpha, 1, '1 1 1', '256 144 0');
	if (DMselected == 4)
		DImageButton(dmsgpos2, "gfx/deathmenu/deathmenuD.tga", dmenualpha, 1, '1 1 1', '256 144 0');
	//drawstring(relomp, "X", '8 8 0', '3 3 3', 1);     	// Draw the "cursor"
	vector ompr;
	ompr = getmousepos();	//;
	drawpic(ompr, "gfx/cursor.tga", '20 20 0', '1 1 1', 1, 0);
};

float crosshairalpha;
float crosshairalpha2;
float crosshair_scale;
void() Crosshair = 
{
	vector pos, chcolor;
	float wch, sca, alphd;
	string image;
	crosshair_scale = cvar("saved8");

	wch = floor(getstatf(STAT_CROSSHAIR));

	if (crosshairalpha > 0)
	{
		image = "gfx/hud/crosshair1_use.tga";
		sca = crosshairalpha;
	}

	if (crosshairalpha2 > 0)
	{
		image = "gfx/hud/crosshair1_active.tga";
		sca = crosshairalpha2;
	}

	if ((crosshairalpha2 <= 0) && (crosshairalpha <= 0))
		sca = 0;

	alphd = 1 - sca;

	chcolor = '1 1 1';

	pos_x = (vid_width / 2) - (16 * vx_rel * crosshair_scale);
	pos_y = (vid_height / 2) - (16 * vx_rel * crosshair_scale);

	drawpic(pos, "gfx/hud/crosshair1.tga", '32 32 0' * vx_rel * crosshair_scale, chcolor, alphd, 0);


	if ((crosshairalpha2 > 0) || (crosshairalpha > 0))
		drawpic(pos, image, '32 32 0' * vx_rel* crosshair_scale, chcolor, sca, 0);
};

void(float orgx, float orgy, float orgz, float vx, float localvy, float vz, vector rgb) lbeam2 = 
{
	local vector v1, v2, v3, v4, muzzleangles;
	float fangles, fangles2;
	makevectors(view_angles);
	muzzleangles = v_right * 3;
	fangles = muzzleangles_x;
	v1_x = orgx + fangles;
	v1_y = orgy + fangles2;
	v1_z = orgz + fangles;
	v2_x = vx + fangles;
	v2_y = vy + fangles2;
	v2_z = vz + fangles;
	v3_x = vx - fangles;
	v3_y = vy - fangles2;
	v3_z = vz - fangles;
	v4_x = orgx - fangles;
	v4_y = orgy - fangles2;
	v4_z = orgz - 6;
	float imgs_y, imgs_y2;
	imgs_y2 = (1 - bbar *0.5) *2;
	imgs_y = vlen(v1 - v2) *0.0125 + imgs_y2;

	rgb_x = (bbar *0.25) + 0.5;
	rgb_y = (bbar *0.25) + 0.5;
	rgb_z = (bbar *0.25) + 2;
	R_BeginPolygon(shd, 2);
	R_PolygonVertex(v1, [imgs_y2, 1, 0], rgb, 1);
	R_PolygonVertex(v2, [imgs_y, 1, 0], rgb, 1);
	R_PolygonVertex(v3, [imgs_y, 0, 0], rgb, 1);
	R_PolygonVertex(v4, [imgs_y2, 0, 0], rgb, 1);
	R_EndPolygon();
};

void(float orgx, float orgy, float orgz, float vx, float local_vy, float vz, vector rgb, float dorgx, float dorgy, float dorgz) lbeam = 
{
	local vector v1, v2, v3, v4;
	v1_x = orgx;
	v1_y = orgy;
	v1_z = orgz;
	v2_x = vx;
	v2_y = vy;
	v2_z = vz;
	v3_x = vx;
	v3_y = vy;
	v3_z = vz;
	v4_x = dorgx;
	v4_y = dorgy;
	v4_z = dorgz;
	float imgs_y, imgs_y2;
	imgs_y2 = (1 - bbar *0.5) *2;
	imgs_y = vlen(v1 - v2) *0.0125 + imgs_y2;

	rgb_x = (bbar *0.25) + 0.5;
	rgb_y = (bbar *0.25) + 0.5;
	rgb_z = (bbar *0.25) + 2;
	R_BeginPolygon(shd, 1);
	R_PolygonVertex(v1, [imgs_y2, 1, 0], rgb, 1);
	R_PolygonVertex(v2, [imgs_y, 1, 0], rgb, 1);
	R_PolygonVertex(v3, [imgs_y, 0, 0], rgb, 1);
	R_PolygonVertex(v4, [imgs_y2, 0, 0], rgb, 1);
	R_EndPolygon();
};

void(float orgx, float orgy, float orgz, float vx, float local_vy, float vz, vector rgb, float dorgx, float dorgy, float dorgz) railbeam = 
{
	local vector v1, v2, v3, v4;
	v1_x = orgx;
	v1_y = orgy;
	v1_z = orgz;
	v2_x = vx;
	v2_y = vy;
	v2_z = vz;
	v3_x = vx;
	v3_y = vy;
	v3_z = vz;
	v4_x = dorgx;
	v4_y = dorgy;
	v4_z = dorgz;

	float imgs_y, imgs_y2;
	imgs_y2 = (1 - bbar *0.5) *2;
	imgs_y = vlen(v1 - v2) *0.0125 + imgs_y2;

	rgb_x = (bbar *0.25) + 5;
	rgb_y = (bbar *0.25) + 0.5;
	rgb_z = (bbar *0.25) + 5;
	R_BeginPolygon(shd, 1);
	R_PolygonVertex(v1, [imgs_y2, 1, 0], rgb, arailb);
	R_PolygonVertex(v2, [imgs_y, 1, 0], rgb, arailb);
	R_PolygonVertex(v3, [imgs_y, 0, 0], rgb, arailb);
	R_PolygonVertex(v4, [imgs_y2, 0, 0], rgb, arailb);
	R_EndPolygon();
};
vector dammo_pos;

void() Ammo_Hud = 
{
	float c_w, c_a, digits, cws;
	string c_ammo, pic4, pic3, pic2, pic1, digit1, digit2, digit3, digit4;
	c_w = floor(getstatf(STAT_LASTWEAPON));
	if (c_w == IT_COACHGUN)
		c_a = getstatf(STAT_AMMO_COACHGUN);
	else if (c_w == IT_RETCHER)
		c_a = getstatf(STAT_AMMO_BOMBS);
	else if (c_w == IT_CANNON)
		c_a = getstatf(STAT_AMMO_CANNON);
	else if (c_w == IT_SPITTER)
		c_a = getstatf(STAT_AMMO_FLAMETHROWER);
	else if (c_w == IT_SHOTGUN)
		c_a = getstatf(STAT_AMMO_SHOTGUN);
	else if (c_w == IT_LANCE)
		c_a = getstatf(STAT_AMMO_LANCE);

	c_ammo = ftos(c_a);
	if (c_a < 0)
		c_a = 0;

	if (c_a <= 0)
		digits = 0;
	if (c_a > 0)
		digits = 1;
	if (c_a >= 10)
		digits = 2;
	if (c_a >= 100)
		digits = 3;
	if (c_a >= 1000)
		digits = 4;


	cws = getstatf(STAT_VWEAPONSTATE);

	dammo_pos_y = ammo_pos_y;
	dammo_pos_z = ammo_pos_z;

	string picofnammo;
	float pulseicon, fphicon;
	picofnammo = "gfx/hud/ammo";
	pulseicon = floor(getstatf(STAT_PULSEICON));

	if (c_w == IT_SHOTGUN)
	{
		if (pulseicon & 16)
		{
			fphicon = floor(shphicon);
			if (fphicon <= 1) picofnammo = "gfx/hud/shellsp1_";
			if (fphicon == 2) picofnammo = "gfx/hud/shellsp2_";
			if (fphicon == 3) picofnammo = "gfx/hud/shellsp3_";
			if (fphicon == 4) picofnammo = "gfx/hud/shellsp4_";
			if (fphicon == 5) picofnammo = "gfx/hud/shellsp5_";
			if (fphicon == 6) picofnammo = "gfx/hud/shellsp6_";
			if (fphicon == 7) picofnammo = "gfx/hud/shellsp7_";
			if (fphicon == 8) picofnammo = "gfx/hud/shellsp8_";
			if (fphicon == 9) picofnammo = "gfx/hud/shellsp9_";
			if (fphicon >= 10) picofnammo = "gfx/hud/3_ammo";
		}
		else
			picofnammo = "gfx/hud/3_ammo";
	}

	if (c_w == IT_COACHGUN)
	{
		if (pulseicon & 4)
		{
			fphicon = floor(slphicon);
			if (fphicon <= 1) picofnammo = "gfx/hud/slugsp1_";
			if (fphicon == 2) picofnammo = "gfx/hud/slugsp2_";
			if (fphicon == 3) picofnammo = "gfx/hud/slugsp3_";
			if (fphicon == 4) picofnammo = "gfx/hud/slugsp4_";
			if (fphicon == 5) picofnammo = "gfx/hud/slugsp5_";
			if (fphicon == 6) picofnammo = "gfx/hud/slugsp6_";
			if (fphicon == 7) picofnammo = "gfx/hud/slugsp7_";
			if (fphicon == 8) picofnammo = "gfx/hud/slugsp8_";
			if (fphicon == 9) picofnammo = "gfx/hud/slugsp9_";
			if (fphicon >= 10) picofnammo = "gfx/hud/2_ammo";
		}
		else
			picofnammo = "gfx/hud/2_ammo";
	}

	if (c_w == IT_SPITTER)
	{
		if (pulseicon & 64)
		{
			fphicon = floor(spphicon);
			if (fphicon <= 1) picofnammo = "gfx/hud/fangsp1_";
			if (fphicon == 2) picofnammo = "gfx/hud/fangsp2_";
			if (fphicon == 3) picofnammo = "gfx/hud/fangsp3_";
			if (fphicon == 4) picofnammo = "gfx/hud/fangsp4_";
			if (fphicon == 5) picofnammo = "gfx/hud/fangsp5_";
			if (fphicon == 6) picofnammo = "gfx/hud/fangsp6_";
			if (fphicon == 7) picofnammo = "gfx/hud/fangsp7_";
			if (fphicon == 8) picofnammo = "gfx/hud/fangsp8_";
			if (fphicon == 9) picofnammo = "gfx/hud/fangsp9_";
			if (fphicon >= 10) picofnammo = "gfx/hud/4_ammo";
		}
		else
			picofnammo = "gfx/hud/4_ammo";
	}

	if (c_w == IT_RETCHER)
	{
		if (pulseicon & 256)
		{
			fphicon = floor(rephicon);
			if (fphicon <= 1) picofnammo = "gfx/hud/cystsp1_";
			if (fphicon == 2) picofnammo = "gfx/hud/cystsp2_";
			if (fphicon == 3) picofnammo = "gfx/hud/cystsp3_";
			if (fphicon == 4) picofnammo = "gfx/hud/cystsp4_";
			if (fphicon == 5) picofnammo = "gfx/hud/cystsp5_";
			if (fphicon == 6) picofnammo = "gfx/hud/cystsp6_";
			if (fphicon == 7) picofnammo = "gfx/hud/cystsp7_";
			if (fphicon == 8) picofnammo = "gfx/hud/cystsp8_";
			if (fphicon == 9) picofnammo = "gfx/hud/cystsp9_";
			if (fphicon >= 10) picofnammo = "gfx/hud/5_ammo";
		}
		else
			picofnammo = "gfx/hud/5_ammo";
	}

	if (c_w == IT_CANNON)
		picofnammo = "gfx/hud/6_ammo";
	if (c_w == IT_LANCE)
		picofnammo = "gfx/hud/7_ammo";

	//	float fclframetime = gettime(2);
	//	float v_sfps = 60 / ((rint (1/ (fclframetime + 0.1))));

	float fclframetime = gettime(2);
	if(!fclframetime)
	fclframetime = 0.002;
	
	float vfpsmultiplier;
	vfpsmultiplier = (1 + ((300 - (1 / fclframetime)) / 220));
	float vfps = 60 + 30 * vfpsmultiplier;
	if (1 / fclframetime > 100)
		vfps = 60;

	float v_sfps = vfps / ((rint(1 / (fclframetime + 0.1))));

	float rammo_pos_x;
	rammo_pos_x = ammo_pos_x - (960 - vid_width);

	if (cws == 1)
	{
		dammo_pos_x -= (fclframetime / 1) *(7500 / v_sfps);
		if (dammo_pos_x < rammo_pos_x)
			dammo_pos_x = rammo_pos_x;
	}
	else if (cws == 2)
	{
		dammo_pos_x += (fclframetime) *(10000 / v_sfps);	//(frametime) *200;

		if (dammo_pos_x >= rammo_pos_x + 180)
			dammo_pos_x = rammo_pos_x + 180;	//(frametime) *200;

	}
	else if (cws == 3)
	{
		dammo_pos_x = rammo_pos_x + 180;	//(frametime) *200;
	}
	else
		dammo_pos_x = rammo_pos_x;

	if ((cws != 3) &&(c_w) && (c_w != IT_MELEE))

	{
		if (digits == 0)
		{
			pic4 = strcat(picofnammo, c_ammo, ".tga");
			DImage(dammo_pos, pic4, 1, ammo_scale, '1 1 1', '28 36 0');
		}
		if (digits == 1)
		{
			pic4 = strcat(picofnammo, c_ammo, ".tga");
			DImage(dammo_pos, pic4, 1, ammo_scale, '1 1 1', '28 36 0');
			//DString (ammo_pos, c_ammo, 1, ammo_scale, '3 1 1', '36 36 0');
		}
		else if (digits == 2)
		{
			digit4 = substring(c_ammo, 1, 1);
			digit3 = substring(c_ammo, 0, 1);
			pic4 = strcat(picofnammo, digit4, ".tga");
			pic3 = strcat(picofnammo, digit3, ".tga");
			DImage(dammo_pos, pic4, 1, ammo_scale, '1 1 1', '28 36 0');
			DImage(dammo_pos + ammo_pos2, pic3, 1, ammo_scale, '1 1 1', '28 36 0');
			//DString (ammo_pos, c_ammo, 1, ammo_scale, '3 1 1', '36 36 0');
		}
		else if (digits == 3)
		{
			digit4 = substring(c_ammo, 2, 1);
			digit3 = substring(c_ammo, 1, 1);
			digit2 = substring(c_ammo, 0, 1);
			pic4 = strcat(picofnammo, digit4, ".tga");
			pic3 = strcat(picofnammo, digit3, ".tga");
			pic2 = strcat(picofnammo, digit2, ".tga");
			DImage(dammo_pos, pic4, 1, ammo_scale, '1 1 1', '28 36 0');
			DImage(dammo_pos + ammo_pos2, pic3, 1, ammo_scale, '1 1 1', '28 36 0');
			DImage(dammo_pos + ammo_pos2 + ammo_pos2, pic2, 1, ammo_scale, '1 1 1', '28 36 0');
			//
		}
		else if (digits == 4)
		{
			digit4 = substring(c_ammo, 3, 1);
			digit3 = substring(c_ammo, 2, 1);
			digit2 = substring(c_ammo, 1, 1);
			digit1 = substring(c_ammo, 0, 1);
			pic4 = strcat(picofnammo, digit4, ".tga");
			pic3 = strcat(picofnammo, digit3, ".tga");
			pic2 = strcat(picofnammo, digit2, ".tga");
			pic1 = strcat(picofnammo, digit1, ".tga");
			DImage(dammo_pos, pic4, 1, ammo_scale, '1 1 1', '28 36 0');
			DImage(dammo_pos + ammo_pos2, pic3, 1, ammo_scale, '1 1 1', '28 36 0');
			DImage(dammo_pos + ammo_pos2 + ammo_pos2, pic2, 1, ammo_scale, '1 1 1', '28 36 0');
			DImage(dammo_pos + ammo_pos2 + ammo_pos2 + ammo_pos2, pic1, 1, ammo_scale, '1 1 1', '28 36 0');
		}
	}

	/*
	float timef;
	timef = getstatf (STAT_TIMEFLY) *-1;
	string timefl;
	timefl = ftos (timef); 
	if (timef > 0)
		DString (ammo_pos + ammo_pos2 + ammo_pos2 + ammo_pos2 +  ammo_pos2, timefl, 1, ammo_scale, '1 3 2', '18 18 0');
	float timels;
	timels = getstatf (STAT_TIMELS) *-1;
	string stimels;
	stimels = ftos (timels); 
	if (timels > 0)
		DString (ammo_pos + ammo_pos2+ ammo_pos2+ ammo_pos2 + ammo_pos2 + ammo_pos2 + ammo_pos2 + ammo_pos2, stimels, 1, ammo_scale, '7 1 1', '18 18 0');
	*/
};
float blalphaflag;
float blalpha;
float stalphaflag;
float stalpha;
float bbar;
float old_artifact_count;

void() Hud_Armor =
{
	local float digits, pulsehealth, fphicona, fphiconb;
	string pic3, pic2, pic1, digit1, digit2, digit3;
	string drmr, armr, picofnarmor, picofndarmor;

	float c_armr = floor(getstatf(STAT_RARM));
	float c_drmr = floor(getstatf(STAT_DARM));
	if (c_armr > 0)
	{
		string armr = ftos(floor(c_armr));
		if (pulsehealth & 1024)
		{
			fphicona = floor(arphicon);
			if (fphicona <= 1) picofnarmor = "gfx/hud/armorp1_";
			if (fphicona == 2) picofnarmor = "gfx/hud/armorp2_";
			if (fphicona == 3) picofnarmor = "gfx/hud/armorp3_";
			if (fphicona == 4) picofnarmor = "gfx/hud/armorp4_";
			if (fphicona == 5) picofnarmor = "gfx/hud/armorp5_";
			if (fphicona == 6) picofnarmor = "gfx/hud/armorp6_";
			if (fphicona == 7) picofnarmor = "gfx/hud/armorp7_";
			if (fphicona == 8) picofnarmor = "gfx/hud/armorp8_";
			if (fphicona == 9) picofnarmor = "gfx/hud/armorp9_";
			if (fphicona >= 10) picofnarmor = "gfx/hud/armor";
		}
		else
			picofnarmor = "gfx/hud/armor";

		vector armr_realpos;

		armr_realpos = armr_pos;

		if (c_armr >= 100)
			c_armr = 100;
		if (c_armr >= 1)
			digits = 1;
		if (c_armr >= 10)
			digits = 2;
		if (c_armr >= 100)
			digits = 3;
		if (digits == 1)
		{
			pic3 = strcat(picofnarmor, armr, ".tga");
			DImage(armr_realpos + armr_pos2 + armr_pos2, pic3, 1, armr_scale, '1 1 1', '28 36 0');
		}
		else if (digits == 2)
		{
			digit3 = substring(armr, 1, 1);
			digit2 = substring(armr, 0, 1);
			pic3 = strcat(picofnarmor, digit3, ".tga");
			pic2 = strcat(picofnarmor, digit2, ".tga");
			DImage(armr_realpos + armr_pos2, pic3, 1, armr_scale, '1 1 1', '28 36 0');
			DImage(armr_realpos + armr_pos2 + armr_pos2, pic2, 1, armr_scale, '1 1 1', '28 36 0');
		}
		else if (digits == 3)
		{
			digit3 = substring(armr, 2, 1);
			digit2 = substring(armr, 1, 1);
			digit1 = substring(armr, 0, 1);
			pic3 = strcat(picofnarmor, digit3, ".tga");
			pic2 = strcat(picofnarmor, digit2, ".tga");
			pic1 = strcat(picofnarmor, digit1, ".tga");
			DImage(armr_realpos, pic3, 1, armr_scale, '1 1 1', '28 36 0');
			DImage(armr_realpos + armr_pos2, pic2, 1, armr_scale, '1 1 1', '28 36 0');
			DImage(armr_realpos + armr_pos2 + armr_pos2, pic1, 1, armr_scale, '1 1 1', '28 36 0');
			//
		}
	}

	if (c_drmr > 0)
	{
		drmr = ftos(c_drmr);
		if (pulsehealth & 4096)
		{
			fphiconb = floor(drphicon);
			if (fphiconb <= 1) picofndarmor = "gfx/hud/darmorp1_";
			if (fphiconb == 2) picofndarmor = "gfx/hud/darmorp2_";
			if (fphiconb == 3) picofndarmor = "gfx/hud/darmorp3_";
			if (fphiconb == 4) picofndarmor = "gfx/hud/darmorp4_";
			if (fphiconb == 5) picofndarmor = "gfx/hud/darmorp5_";
			if (fphiconb == 6) picofndarmor = "gfx/hud/darmorp6_";
			if (fphiconb == 7) picofndarmor = "gfx/hud/darmorp7_";
			if (fphiconb == 8) picofndarmor = "gfx/hud/darmorp8_";
			if (fphiconb == 9) picofndarmor = "gfx/hud/darmorp9_";
			if (fphiconb >= 10) picofndarmor = "gfx/hud/darmor";
		}
		else
			picofndarmor = "gfx/hud/darmor";

		//		if (c_drmr >= 100)
		//		c_drmr =100;
		if (c_drmr >= 1)
			digits = 1;
		if (c_drmr >= 10)
			digits = 2;
		if (c_drmr >= 100)
			digits = 3;
		if (digits == 1)
		{
			pic3 = strcat(picofndarmor, drmr, ".tga");
			DImage(drmr_pos + armr_pos2 + armr_pos2, pic3, 1, armr_scale, '1 1 1', '28 36 0');
		}
		else if (digits == 2)
		{
			digit3 = substring(drmr, 1, 1);
			digit2 = substring(drmr, 0, 1);
			pic3 = strcat(picofndarmor, digit3, ".tga");
			pic2 = strcat(picofndarmor, digit2, ".tga");
			DImage(drmr_pos + armr_pos2, pic3, 1, armr_scale, '1 1 1', '28 36 0');
			DImage(drmr_pos + armr_pos2 + armr_pos2, pic2, 1, armr_scale, '1 1 1', '28 36 0');
		}
		else if (digits == 3)
		{
			digit3 = substring(drmr, 2, 1);
			digit2 = substring(drmr, 1, 1);
			digit1 = substring(drmr, 0, 1);
			pic3 = strcat(picofndarmor, digit3, ".tga");
			pic2 = strcat(picofndarmor, digit2, ".tga");
			pic1 = strcat(picofndarmor, digit1, ".tga");
			DImage(drmr_pos, pic3, 1, armr_scale, '1 1 1', '28 36 0');
			DImage(drmr_pos + armr_pos2, pic2, 1, armr_scale, '1 1 1', '28 36 0');
			DImage(drmr_pos + armr_pos2 + armr_pos2, pic1, 1, armr_scale, '1 1 1', '28 36 0');
			//
		}
	}
 };
void() Hud = 
{
	vector postimage;
	string time0, time1, time2, time3, time4;
	postimage = '240 -480 0';
	
	float gettime2;
	gettime2 = gettime(2);
	if(!gettime2)
	gettime2 = 0.002;
	
	time0 = ftos(1 + ((500 - (1 / gettime2)) / 220));
	time1 = ftos(gettime(1));
	time2 = ftos(1 / gettime2);
	time3 = ftos(gettime(3));
	time4 = ftos(frametime);
	//DString (postimage,(time0), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	//DString (postimage,(time1), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	//DString (postimage,(time2), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	//DString (postimage,(time3), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	//DString (postimage,(time4), 1, 1, '1 1 1',' 14 14 0');postimage += '0 20 0';
	local float health, kitems, digits, pulsehealth, fphicon;
	health = getstati(STAT_HEALTH);

	string pic3, pic2, pic1, digit1, digit2, digit3;
	string picofnammo;

	string health_n;
	if (health > 0)
	{
		health_n = ftos(floor(health));
		pulsehealth = floor(getstatf(STAT_PULSEICON));
		if (pulsehealth & 1)
		{
			fphicon = floor(phicon);
			if (fphicon <= 1) picofnammo = "gfx/hud/healthp1_";
			if (fphicon == 2) picofnammo = "gfx/hud/healthp2_";
			if (fphicon == 3) picofnammo = "gfx/hud/healthp3_";
			if (fphicon == 4) picofnammo = "gfx/hud/healthp4_";
			if (fphicon == 5) picofnammo = "gfx/hud/healthp5_";
			if (fphicon == 6) picofnammo = "gfx/hud/healthp6_";
			if (fphicon == 7) picofnammo = "gfx/hud/healthp7_";
			if (fphicon == 8) picofnammo = "gfx/hud/healthp8_";
			if (fphicon == 9) picofnammo = "gfx/hud/healthp9_";
			if (fphicon >= 10)
			{
				picofnammo = "gfx/hud/health";
				localcmd("impulse 200\n");
			}
		}
		else
			picofnammo = "gfx/hud/health";

		vector healthrelsep, health_relpos;

		health_relpos = health_pos;
		healthrelsep = healthsep;

		if (health >= 100)
			health = 100;
		if (health >= 1)
			digits = 1;
		if (health >= 10)
			digits = 2;
		if (health >= 100)
			digits = 3;
		if (digits == 1)
		{
			pic3 = strcat(picofnammo, health_n, ".tga");

			DImage(health_relpos + healthrelsep + healthrelsep, pic3, 1, health_scale, '1 1 1', '28 36 0');
		}
		else if (digits == 2)
		{
			digit3 = substring(health_n, 1, 1);
			digit2 = substring(health_n, 0, 1);
			pic3 = strcat(picofnammo, digit3, ".tga");
			pic2 = strcat(picofnammo, digit2, ".tga");
			DImage(health_relpos + healthrelsep, pic3, 1, health_scale, '1 1 1', '28 36 0');
			DImage(health_relpos + healthrelsep + healthrelsep, pic2, 1, health_scale, '1 1 1', '28 36 0');
		}
		else if (digits == 3)
		{
			digit3 = substring(health_n, 2, 1);
			digit2 = substring(health_n, 1, 1);
			digit1 = substring(health_n, 0, 1);
			pic3 = strcat(picofnammo, digit3, ".tga");
			pic2 = strcat(picofnammo, digit2, ".tga");
			pic1 = strcat(picofnammo, digit1, ".tga");
			DImage(health_relpos, pic3, 1, health_scale, '1 1 1', '28 36 0');
			DImage(health_relpos + healthrelsep, pic2, 1, health_scale, '1 1 1', '28 36 0');
			DImage(health_relpos + healthrelsep + healthrelsep, pic1, 1, health_scale, '1 1 1', '28 36 0');
			//
		}
	}


	//	c_drmr =rint(c_drmr);
	kitems = getstati(STAT_ITEMS);
	vector vkeysep, realkeypos;
	vkeysep_x = keysep;

	realkeypos = keypos;
	realkeypos_y += (540 - vid_height);
	realkeypos_x -= (960 - vid_width);

	float sl_slotkeys;
	sl_slotkeys = rint(getstatf(STAT_SLOT_KEYS));
	realkeypos_y += 48;
	local string slotdigits, slotdigitsthous, slotdigitscent, slotdigitsdozen, slotdigitsunit;
	local float slotthous,slotcents, slotdozens, slotunits;
	if (sl_slotkeys)
	{
		vector slot_realkeypos, slot_realkeypos2, slot_realkeypos3;

		slotdigits = ftos(sl_slotkeys);
		slotdigitsdozen = substring(slotdigits, 1, 2);
		slotdigitsunit = substring(slotdigits, 2, 3);
		slotdozens = stof(slotdigitsdozen);
		slotunits = stof(slotdigitsunit);

		slot_realkeypos = realkeypos;
		if ((slotdozens) && (!slotunits))
		{
			slot_realkeypos = realkeypos;
			slot_realkeypos2 = realkeypos + vkeysep;
		}

		if ((slotdozens) && (slotunits))
		{
			slot_realkeypos = realkeypos;
			slot_realkeypos2 = realkeypos + vkeysep;
			slot_realkeypos3 = realkeypos + vkeysep + vkeysep;
		}

		if ((sl_slotkeys >= 100) && (sl_slotkeys < 200))
			DImage2(slot_realkeypos, "gfx/hud/glyph_red.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((sl_slotkeys >= 200) && (sl_slotkeys < 300))
			DImage2(slot_realkeypos, "gfx/hud/glyph_blue.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (sl_slotkeys >= 300)
			DImage2(slot_realkeypos, "gfx/hud/glyph_yellow.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotdozens >= 10) && (slotdozens < 20))
			DImage2(slot_realkeypos2, "gfx/hud/glyph_red.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotdozens >= 20) && (slotdozens < 30))
			DImage2(slot_realkeypos2, "gfx/hud/glyph_blue.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotdozens >= 30)
			DImage2(slot_realkeypos2, "gfx/hud/glyph_yellow.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotunits >= 1) && (slotunits < 2))
			DImage2(slot_realkeypos3, "gfx/hud/glyph_red.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotunits >= 2) && (slotunits < 3))
			DImage2(slot_realkeypos3, "gfx/hud/glyph_blue.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotunits >= 3)
			DImage2(slot_realkeypos3, "gfx/hud/glyph_yellow.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

	}

	//drawstring('0 0 0', ftos(sl_slotkeys), '8 8 0', '3 3 3', 1);     	// Draw the "slotkeyused"

	realkeypos_y += 48;
	if (kitems & IT_COFFERKEY1)
		DImage2(realkeypos, "gfx/hud/coffer_key.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
	if (kitems & IT_COFFERKEY2)
		DImage2(realkeypos + vkeysep, "gfx/hud/coffer_key.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
	if (kitems & IT_COFFERKEY3)
		DImage2(realkeypos + vkeysep + vkeysep, "gfx/hud/coffer_key.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

	realkeypos_y -= 96;

	float sl_slotrelics;
	sl_slotrelics = rint(getstatf(STAT_SLOT_RELICS));

	if (sl_slotrelics)
	{
		vector slot_realrelicpos, slot_realrelicpos2, slot_realrelicpos3, slot_realrelicpos4,slot_realrelicpos5;

		slotdigits = ftos(sl_slotrelics);
		slotdigitsthous = substring(slotdigits, 1, 4);
		slotdigitscent = substring(slotdigits, 2, 3);
		slotdigitsdozen = substring(slotdigits, 3, 2);
		slotdigitsunit = substring(slotdigits, 4, 1);
		slotthous = stof(slotdigitsthous);
		slotcents = stof(slotdigitscent);
		slotdozens = stof(slotdigitsdozen);
		slotunits = stof(slotdigitsunit);

		slot_realrelicpos = realkeypos;
/*		if ((slotthous) && (!slotcents) && (!slotdozens) && (!slotunits))
		{
			slot_realrelicpos = realkeypos;
		}*/
		if ((slotthous) && (!slotcents) && (!slotdozens) && (!slotunits))
		{
			slot_realrelicpos = realkeypos;
			slot_realrelicpos2 = realkeypos + vkeysep;
		}

		if ((slotthous) && (slotcents) && (!slotdozens) && (!slotunits))
		{
			slot_realrelicpos = realkeypos;
			slot_realrelicpos2 = realkeypos + vkeysep;
			slot_realrelicpos3 = realkeypos + (vkeysep *2);
		}

		if ((slotthous) && (slotcents) && (slotdozens) && (!slotunits))
		{
			slot_realrelicpos = realkeypos;
			slot_realrelicpos2 = realkeypos + vkeysep;
			slot_realrelicpos3 = realkeypos + (vkeysep *2);
			slot_realrelicpos4 = realkeypos + (vkeysep *3);
		}

		if ((slotthous) &&(slotcents) && (slotdozens) && (slotunits))
		{
			slot_realrelicpos = realkeypos;
			slot_realrelicpos2 = realkeypos + vkeysep;
			slot_realrelicpos3 = realkeypos + (vkeysep *2);
			slot_realrelicpos4 = realkeypos + (vkeysep *3);
			slot_realrelicpos5 = realkeypos + (vkeysep *4);
		}
		//drawstring('30 0 0', strcat (slotdigits," ",ftos (slotthous)," ",ftos (slotcents)," ",ftos (slotdozens)," ",ftos (slotunits)), '8 8 0', '12 12 0', 1, 0);     	// Draw the "cursor"
	

		if ((sl_slotrelics >= 10000) && (sl_slotrelics < 20000))
			DImage2(slot_realrelicpos, "gfx/hud/relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((sl_slotrelics >= 20000) && (sl_slotrelics < 30000))
			DImage2(slot_realrelicpos, "gfx/hud/relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((sl_slotrelics >= 30000) && (sl_slotrelics < 40000))
			DImage2(slot_realrelicpos, "gfx/hud/relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((sl_slotrelics >= 40000) && (sl_slotrelics < 50000))
			DImage2(slot_realrelicpos, "gfx/hud/relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (sl_slotrelics >= 50000)
			DImage2(slot_realrelicpos, "gfx/hud/relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotthous >= 1000) && (slotthous < 2000))
			DImage2(slot_realrelicpos2, "gfx/hud/relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotthous >= 2000) && (slotthous < 3000))
			DImage2(slot_realrelicpos2, "gfx/hud/relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotthous >= 3000) && (slotthous < 4000))
			DImage2(slot_realrelicpos2, "gfx/hud/relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotthous >= 4000) && (slotthous < 5000))
			DImage2(slot_realrelicpos2, "gfx/hud/relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotthous >= 5000)
			DImage2(slot_realrelicpos2, "gfx/hud/relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotcents >= 100) && (slotcents < 200))
			DImage2(slot_realrelicpos3, "gfx/hud/relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotcents >= 200) && (slotcents < 300))
			DImage2(slot_realrelicpos3, "gfx/hud/relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotcents >= 300) && (slotcents < 400))
			DImage2(slot_realrelicpos3, "gfx/hud/relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotcents >= 400) && (slotcents < 500))
			DImage2(slot_realrelicpos3, "gfx/hud/relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotcents >= 500)
			DImage2(slot_realrelicpos3, "gfx/hud/relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotdozens >= 10) && (slotdozens < 20))
			DImage2(slot_realrelicpos4, "gfx/hud/relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotdozens >= 20) && (slotdozens < 30))
			DImage2(slot_realrelicpos4, "gfx/hud/relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotdozens >= 30) && (slotdozens < 40))
			DImage2(slot_realrelicpos4, "gfx/hud/relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotdozens >= 40) && (slotdozens < 50))
			DImage2(slot_realrelicpos4, "gfx/hud/relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotdozens >= 50)
			DImage2(slot_realrelicpos4, "gfx/hud/relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

		if ((slotunits >= 1) && (slotunits < 2))
			DImage2(slot_realrelicpos5, "gfx/hud/relic_e1m1.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotunits >= 2) && (slotunits < 3))
			DImage2(slot_realrelicpos5, "gfx/hud/relic_e1m2.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotunits >= 3) && (slotunits < 4))
			DImage2(slot_realrelicpos5, "gfx/hud/relic_e1m3.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if ((slotunits >= 4) && (slotunits < 5))
			DImage2(slot_realrelicpos5, "gfx/hud/relic_e1m4.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);
		if (slotunits >= 5)
			DImage2(slot_realrelicpos5, "gfx/hud/relic_e1m5.tga", 1, keyscale, '1 1 1', '16 16 0', keyflag);

	}

	string ring_artifact, ring_artifact2, ring_artifact3, timer_artifact;
	string ring_tether, ring_tether2, ring_tether3;
	//DImage(artr1,"gfx/hud/rings.tga",1,artr2,'1 1 1','160 60 0');
	local float radialactive, radialtime, tether_time,tetheractive;
	radialactive = getstatf(STAT_RADIALACTIVE);
	tetheractive = getstatf(STAT_RD_ST);
	
	radialtime = getstatf(STAT_ARTIFACTTIME);
	tether_time = getstatf(STAT_TETHERTIME);
	vector spos;
	spos_x = artr1_x + 9 + artic_x;
	spos_y = artr1_y + 5 + artic_y;
	
	ring_tether = "gfx/hud/cooldown/soul_tether_hud.tga";
	ring_tether2 = "gfx/hud/cooldown/soul_tether_pulseA.tga";
	ring_tether3 = "gfx/hud/cooldown/soul_tether_pulseB.tga";
	DImage(spos, ring_tether, 1, artns, '1 1 1', '64 64 0');

		if(tetheractive < 10)
		{		
			string ns1 = strcat("gfx/artifactmenu/artifact_num", ftos(tetheractive), ".tga");
			DImage2(spos + artn, ns1, 1, artrns, '1 1 1', '8 8 0', radialflag);
		}
		else
		{
			string ns2 = strcat("gfx/artifactmenu/artifact_num", substring( ftos(tetheractive), 1, 1), ".tga");
			string ns3 = strcat("gfx/artifactmenu/artifact_num", substring( ftos(tetheractive), 0, 1), ".tga");

			spos -= '4 0 0';
			DImage2(spos + artn, ns3, 1, artrns, '1 1 1', '8 8 0', radialflag);
			DImage2(spos + artn + '6 0 0', ns2, 1, artrns, '1 1 1', '8 8 0', radialflag);
			spos += '4 0 0';
		}
	if(tether_time > 0)
	{
		local float stntimer, st_ralpha;
		stntimer = tether_time;
		if (stntimer == 136)
			stalphaflag = 1;
		if (stntimer >= 137)
		{
			if (stntimer == 137)
			{
				stalphaflag = 1;
				st_ralpha = 1;
			}
			if (stntimer == 138)
				st_ralpha = 1;
			if (stntimer == 139)
			{
				stalphaflag = -1;
				st_ralpha = 0;
			}
			if (stntimer == 140)
				st_ralpha = 0;
			if (stntimer == 141)
				st_ralpha = 0;
			if (stntimer == 142)
			{
				st_ralpha = 0;
				stalphaflag = 0;
			}
			DImage(spos, ring_tether, st_ralpha, artns, '1 1 1', '64 64 0');
			if ((stntimer >= 137) && (stntimer <= 138))
				DImage(spos, ring_tether2, stalpha, artns, '1 1 1', '64 64 0');
			if (stntimer >= 139)
				DImage(spos, ring_tether3, stalpha, artns, '1 1 1', '64 64 0');
			//drawstring ('0 0 0', ftos(stntimer),'12 12 0', '1 1 1', 1, 0);
		}
		else
		{
			st_ralpha = 1;
			DImage(spos, ring_tether, st_ralpha, artns, '1 1 1', '64 64 0');
		}
	}
	if (radialactive >= 1)
	{
		if (radialactive == 1) ring_artifact = "gfx/hud/cooldown/artifactA_hud.tga";
		if (radialactive == 2) ring_artifact = "gfx/hud/cooldown/artifactB_hud.tga";
		if (radialactive == 3) ring_artifact = "gfx/hud/cooldown/artifactC_hud.tga";
		if (radialactive == 4) ring_artifact = "gfx/hud/cooldown/artifactD_hud.tga";
		if (radialactive == 5) ring_artifact = "gfx/hud/cooldown/artifactE_hud.tga";
		if (radialactive == 6) ring_artifact = "gfx/hud/cooldown/artifactF_hud.tga";
		if (radialactive == 7) ring_artifact = "gfx/hud/cooldown/artifactG_hud.tga";
		if (radialactive == 8) ring_artifact = "gfx/hud/cooldown/artifactH_hud.tga";
		if (radialactive == 9) ring_artifact = "gfx/hud/cooldown/artifactI_hud.tga";
		if (radialactive == 10) ring_artifact = "gfx/hud/cooldown/artifactJ_hud.tga";
		if (radialactive == 1) ring_artifact2 = "gfx/hud/cooldown/artifactA_pulseA.tga";
		if (radialactive == 2) ring_artifact2 = "gfx/hud/cooldown/artifactB_pulseA.tga";
		if (radialactive == 3) ring_artifact2 = "gfx/hud/cooldown/artifactC_pulseA.tga";
		if (radialactive == 4) ring_artifact2 = "gfx/hud/cooldown/artifactD_pulseA.tga";
		if (radialactive == 5) ring_artifact2 = "gfx/hud/cooldown/artifactE_pulseA.tga";
		if (radialactive == 6) ring_artifact2 = "gfx/hud/cooldown/artifactF_pulseA.tga";
		if (radialactive == 7) ring_artifact2 = "gfx/hud/cooldown/artifactG_pulseA.tga";
		if (radialactive == 8) ring_artifact2 = "gfx/hud/cooldown/artifactH_pulseA.tga";
		if (radialactive == 9) ring_artifact2 = "gfx/hud/cooldown/artifactI_pulseA.tga";
		if (radialactive == 10) ring_artifact2 = "gfx/hud/cooldown/artifactJ_pulseA.tga";
		if (radialactive == 1) ring_artifact3 = "gfx/hud/cooldown/artifactA_pulseB.tga";
		if (radialactive == 2) ring_artifact3 = "gfx/hud/cooldown/artifactB_pulseB.tga";
		if (radialactive == 3) ring_artifact3 = "gfx/hud/cooldown/artifactC_pulseB.tga";
		if (radialactive == 4) ring_artifact3 = "gfx/hud/cooldown/artifactD_pulseB.tga";
		if (radialactive == 5) ring_artifact3 = "gfx/hud/cooldown/artifactE_pulseB.tga";
		if (radialactive == 6) ring_artifact3 = "gfx/hud/cooldown/artifactF_pulseB.tga";
		if (radialactive == 7) ring_artifact3 = "gfx/hud/cooldown/artifactG_pulseB.tga";
		if (radialactive == 8) ring_artifact3 = "gfx/hud/cooldown/artifactH_pulseB.tga";
		if (radialactive == 9) ring_artifact3 = "gfx/hud/cooldown/artifactI_pulseB.tga";
		if (radialactive == 10) ring_artifact3 = "gfx/hud/cooldown/artifactJ_pulseB.tga";

		if (radialactive == 20) ring_artifact = "gfx/hud/cooldown/sigil_flight_hud.tga";
		if (radialactive == 20) ring_artifact2 = "gfx/hud/cooldown/sigil_flight_pulseA.tga";
		if (radialactive == 20) ring_artifact3 = "gfx/hud/cooldown/sigil_flight_pulseB.tga";

		//spos_x = spos_x;
		spos_x = arti_pos_x + 9 + artic_x;
		spos_y = arti_pos_y + 5 + artic_y;
		float artifact_count;

		if (radialactive == 1)artifact_count  = 0;
		if (radialactive == 2)artifact_count = getstatf(STAT_RD_DA);
		if (radialactive == 3)artifact_count = 0;
		if (radialactive == 4)artifact_count = getstatf(STAT_RD_CA);
		if (radialactive == 5)artifact_count = 0;
		if (radialactive == 6)artifact_count = getstatf(STAT_RD_LS);
		if (radialactive == 7)artifact_count = getstatf(STAT_RD_TR);
		if (radialactive == 8)artifact_count = getstatf(STAT_RD_AE);
		if (radialactive == 9)artifact_count = 0;
		if (radialactive == 10)artifact_count = 0;

		if (radialtime > 0)
		{
			local float ntimer, artalpha;
			ntimer = radialtime;
			local string nametimer;
			nametimer = ftos(ntimer);
			timer_artifact = strcat("gfx/hud/cooldown/cd", nametimer, ".tga");
			local float da_alpha;
			if (ntimer <= 134)
			da_alpha = 1;
			if (ntimer == 134)
					da_alpha = 0.9;
			if (ntimer == 135)
					da_alpha = 0.8;
			if (ntimer == 136)
			{	
				blalphaflag = 1;
					da_alpha = 0.7;
			 }
			if (ntimer >= 137)
			{
				timer_artifact = "gfx/hud/cooldown/cd136.tga";
				if (ntimer == 137)
				{
					blalphaflag = 1;
					da_alpha = 0.6;
					artalpha = 1;
				}

				if (ntimer == 138)
				{
					artalpha = 0.5;
					da_alpha = 0.5;
					//blalpha = 1;
				}
				if ((ntimer >= 139)&& (artifact_count > 0))	
					DImage(spos, ring_artifact, 1, artics, '1 1 1', '64 64 0');

				if (ntimer == 139)
				{
					da_alpha = 0.4;
					blalphaflag = -1;
					artalpha = 0;
				}

				if (ntimer == 140)
				{
					da_alpha = 0.3;
					artalpha = 0;
				}

				if (ntimer == 141)
				{
					da_alpha = 0.2;
					artalpha = 0;
				}

				if (ntimer == 142)
				{
					da_alpha = 0.1;
					artalpha = 0;
					blalphaflag = 0;
				}

				DImage2(spos, timer_artifact, artalpha, artics, '1 1 1', '64 64 0', 0);
				DImage(spos, ring_artifact, artalpha, artics, '1 1 1', '64 64 0');

				if ((ntimer >= 137) && (ntimer <= 138))
				{
					DImage(spos, ring_artifact2, blalpha, artics, '1 1 1', '64 64 0');
				}

				if (ntimer >= 139)
				{
					DImage(spos, ring_artifact3, blalpha, artics, '1 1 1', '64 64 0');
					if (radialactive != 5)
					{
						DImage(spos, "gfx/hud/cooldown/cd_pulse.tga", blalpha, artics, '1 1 1', '64 64 0');
					}
				}


			}
			else
			{
				artalpha = 1;
				if (radialactive != 5)
				{
					DImage2(spos, timer_artifact, artalpha, artics, '1 1 1', '64 64 0', 0);
				}

				DImage(spos, ring_artifact, artalpha, artics, '1 1 1', '64 64 0');
			}
			if (radialactive == 2)
			drawpic('0 0 0', "models/artifacts/active/drowners_apparatus_active.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', da_alpha, 0);
		}
		else
			{
			DImage(spos, ring_artifact, 1, artics, '1 1 1', '64 64 0');
			old_artifact_count = artifact_count;
			}
		if ((radialactive  >= 1))
		{	

			if(artifact_count <= 0)
			return;
			if(artifact_count < 10)
			{		
				string rns1 = strcat("gfx/artifactmenu/artifact_num", ftos(artifact_count), ".tga");
				DImage2(spos + artin, rns1, 1, artrns, '1 1 1', '8 8 0', radialflag);
			}
			else
			{
				string rns2 = strcat("gfx/artifactmenu/artifact_num", substring( ftos(artifact_count), 1, 1), ".tga");
				string rns3 = strcat("gfx/artifactmenu/artifact_num", substring( ftos(artifact_count), 0, 1), ".tga");

				spos -= '4 0 0';
				DImage2(spos + artin, rns3, 1, artrns, '1 1 1', '8 8 0', radialflag);
				DImage2(spos + artin + '6 0 0', rns2, 1, artrns, '1 1 1', '8 8 0', radialflag);
			}
		}	

	}

};

float dmues;

//string v_sfps;
float theter_alreadychecked;
float vshift_alreadychecked;

float aspectratiomode;
void CSQC_UpdateView(float b, float c)
{
	static float oldtime;
	cltime = gettime(GETTIME_FRAMESTART);
	clframetime = oldtime ? cltime - oldtime : 0.1;
	oldtime = cltime;
	float rmenu;
	float wdscreen, vwframe, ennframe, ennhealth;
	string vframe, enemyhealth, enemyclass;
	local entity e;
	vid_width = cvar("vid_conwidth");
	vid_height = cvar("vid_conheight");
	vid_rwidth = cvar("vid_width");
	vid_rheight = cvar("vid_height");

	float vid_ratio;

	vid_ratio = vid_rwidth / vid_rheight;

	aspectratio_fix_x = (1.7777777777777777 - (vid_rwidth / vid_rheight)) *202.5;

	aspectratio_fix_y = (0.5265 - (vid_rheight / vid_rwidth)) *202.5;

	// ALWAYS Clear Current Scene First
	// Assign Standard Viewflags
	// Setup Entities to be Rendered (include all base types; normal, engine and viewmodels)

	vx_rel = ((vid_width / 960));
	vy_rel = ((vid_height / 540));
	clearscene();

	// Draw the World (and sky)
	setproperty(VF_DRAWWORLD, 1);
	// Draw the Crosshair
	setproperty(VF_DRAWCROSSHAIR, 0);
	// Draw the Engine Status Bar (the default Quake HUD)
	setproperty(VF_DRAWENGINESBAR, 0);

	addentities(MASK_NORMAL | MASK_ENGINE);
	renderscene();

	if (vid_height == 540)
		aspectratiomode = 1;
	if (vid_height == 720)
		aspectratiomode = 2;
	if (vid_height == 768)
		aspectratiomode = 3;

	bbar += (frametime) *10;
	if (bbar > 19)
		bbar = 0;
	bbar = bbar + frametime * 12;
	if ((bbar >= 0) && (bbar < 1))
		shd = ("gfx/ray");
	else if ((bbar >= 1) && (bbar < 2))
		shd = ("gfx/ray2");
	else if ((bbar >= 2) && (bbar < 3))
		shd = ("gfx/ray3");
	else if ((bbar >= 3) && (bbar < 4))
		shd = ("gfx/ray4");

	shd2 = ("gfx/light.tga");
	if (bbar >= 4)
	{
		bbar = 0;
		rndm = random() *0.5 + 1.5;
	}

	float wlightning;

	wlightning = rint(getstatf(STAT_WLIGHTNING));
	vector lorg, ldest, ldorg;

	vector lb, lbd;

	vector spos, sposd, align;
	spos_x = 300;
	spos_y = 100;
	spos_z = -60;
	sposd_x = 370;
	sposd_y = 100;
	sposd_z = -60;
	align_x = 240;
	align_y = vid_height - 27;
	spos_x = spos_x + align_x;
	spos_y = spos_y + align_y;
	spos_z = spos_z + align_z;
	sposd_x = sposd_x + align_x;
	sposd_y = sposd_y + align_y;
	sposd_z = sposd_z + align_z;

	lorg = cs_unproject(spos);

	ldorg = cs_unproject(sposd);

	ldest_x = getstatf(STAT_LDX);
	ldest_y = getstatf(STAT_LDY);
	ldest_z = getstatf(STAT_LDZ);

	lb_x = getstatf(STAT_LOX);
	lb_y = getstatf(STAT_LOY);
	lb_z = getstatf(STAT_LOZ);

	lbd_x = getstatf(STAT_LODX);
	lbd_y = getstatf(STAT_LODY);
	lbd_z = getstatf(STAT_LODZ);

	lorg = (lb + lorg) *0.5;
	ldorg = (lbd + ldorg) *0.5;

	if (wlightning == 1)
	{
		lbeam(lorg_x, lorg_y, lorg_z, ldest_x, ldest_y, ldest_z, '1 1 1', ldorg_x, ldorg_y, ldorg_z);
	}

	if (wlightning == 2)
	{
		railbeam(lorg_x, lorg_y, lorg_z, ldest_x, ldest_y, ldest_z, '1 1 1', ldorg_x, ldorg_y, ldorg_z);
		arailb = (arailb - frametime) *0.8;
	}
	else
	{
		if (arailb != 2)
			arailb = 2;
	}

	//////////////////	
	//float sorete = getproperty(VF_FOG_DENSITY);
	//drawstring('0 0 0', ftos(sorete), '20 20 0', '1 1 1', 1, 0);
	rmenu = getstatf(STAT_RMENU);
	inventory_active = rmenu;
	wdscreen = getstatf(STAT_WRATHDEBUGSCREEN);
	if (wdscreen == 1)
	{
		vwframe = getstatf(STAT_VWEAPONFRAME);
		ennhealth = getstatf(STAT_ENHEALTH);
		ennframe = getstatf(STAT_ENFRAME);
		vframe = strcat("weapon frame: ", ftos(vwframe));
		enemyhealth = strcat("enemy health: ", ftos(ennhealth));
		enemyclass = strcat("enemy frame: ", ftos(ennframe));
		DString('-150 -50 0', vframe, 1, 2, '3 1 1', '10 10 0');
		DString('-150 -90 0', enemyclass, 1, 2, '3 1 1', '10 10 0');
		DString('-150 -70 0', enemyhealth, 1, 2, '3 1 1', '10 10 0');

		vector player_org;
		player_org_x =  getstatf(STAT_X);
		player_org_y =  getstatf(STAT_Y);
		player_org_z =  getstatf(STAT_Z);

		DString('-150 10 0', vtos(player_org), 1, 2, '1 1 3', '10 10 0');
	}

	float fclframetime = gettime(2);
	if(!fclframetime)
	fclframetime = 0.002;

	float vfpsmultiplier;
	if(fclframetime > 0)
	vfpsmultiplier = (1 + ((300 - (1 / fclframetime)) / 220));
	else
	vfpsmultiplier = 1;
	float vfps = 60 + 30 * vfpsmultiplier;
	
	if(fclframetime > 0)
	{
	if (1 / fclframetime > 100)
		vfps = 60;
	}
	//	drawstring('0 0 0', ftos (fclframetime), '8 8 0', '12 12 0', 1, 0);     	// Draw the "cursor"

	float v_sfps = vfps / ((rint(1 / (fclframetime + 0.1))));

	local float shrinew;
	shrinew = floor(getstatf(STAT_SHRINE));
	
	local float f, dm;
	f = getstati(STAT_HEALTH);
	dm = floor(getstatf(STAT_DEADMENU));
	if (/*(f <= 0) && */(dm == 1))
	{
		if (theter_alreadychecked != 1)
		{
			write_tether();
			check_tether();
			check_shrine_user();
			
			if((shrinepresent <= 0) && (shrine_user >  0))
			shrinepresent = 1;
			mm2 = 0;
			setcursormode(1);
			localcmd("crosshair 0\n");
			localcmd("scratch3 1\n");
			if (tether >= 1)
				DMselected = 1;
			else if (shrinepresent >= 1)
				DMselected = 2;
			else
				DMselected = 3;
			theter_alreadychecked = 1;
		}

		if(f < 0)
		{
		if (dmenualpha < 1)
			dmenualpha += v_sfps / 1200;
		else
			dmenualpha = 1;
		}
		else
			dmenualpha = 1;
		if (vshift_alreadychecked != 1) 
		{
			if ((dmenualpha == 1) && (f < 0))
				localcmd("v_cshift\n");
			vshift_alreadychecked = 1;
		}

		Death_Menu();
	}
	else
	{
	
		if (dmenualpha > 0)
			dmenualpha = 0;
			
		if (vshift_alreadychecked == 1)
		vshift_alreadychecked = 0;
		if (theter_alreadychecked == 1)
		{
			theter_alreadychecked = 0;
			setcursormode(0);
			localcmd("crosshair 1\n");
			localcmd("scratch3 0\n");
		}
		float showjournal;
		showjournal = getstatf(STAT_JOURNAL);
		if (showjournal == 2)
		{
			if (mrmenualpha < 1)
				mrmenualpha += clframetime * 5;
		}
		else
		{
			if (mrmenualpha > 0)
				mrmenualpha -= clframetime * 5;
			else
				mrmenualpha = 0;
		}

		if ((rmenu == 1))
		{
		
			if(slot_timer > 0)
			slot_timer -= clframetime * 5;
			if (rmenualpha < 1)
				rmenualpha += clframetime * 5;
		}
		else
		{
			if (rmenualpha > 0)
				rmenualpha -= clframetime * 5;
			else
				rmenualpha = 0;
		}

		float wch;
		wch = floor(getstatf(STAT_CROSSHAIR));

		if (wch & 1)
		{
			if (crosshairalpha < 1.1)
				crosshairalpha += clframetime * 10;
		}
		else
		{
			if (crosshairalpha > -0.1)
				crosshairalpha -= clframetime * 5;
		}

		if (wch & 2)
		{
			if (crosshairalpha2 < 1.1)
				crosshairalpha2 += clframetime * 10;
		}
		else
		{
			if (crosshairalpha2 > -0.1)
				crosshairalpha2 -= clframetime * 5;
		}

		if (blalphaflag == 0)
			blalpha = 0;
		if (blalphaflag == 1)
			blalpha += clframetime * 5;
		if (blalphaflag == -1)
			blalpha -= clframetime *7.5;

		if (stalphaflag == 0)
			stalpha = 0;
		if (stalphaflag == 1)
			stalpha += clframetime * 5;
		if (stalphaflag == -1)
			stalpha -= clframetime *7.5;

		float pulseicon;
		pulseicon = floor(getstatf(STAT_PULSEICON));

		if (pulseicon & 2)
			phicon = 0;
		if (pulseicon & 1)
			phicon += clframetime * 27;
		else
			phicon = 0;

		if (pulseicon & 8)
			slphicon = 0;
		if (pulseicon & 4)
			slphicon += clframetime * 27;
		else
			slphicon = 0;

		if (pulseicon & 32)
			shphicon = 0;
		if (pulseicon & 16)
			shphicon += clframetime * 27;
		else
			shphicon = 0;

		if (pulseicon & 128)
			spphicon = 0;
		if (pulseicon & 64)
			spphicon += clframetime * 27;
		else
			spphicon = 0;

		if (pulseicon & 512)
			rephicon = 0;
		if (pulseicon & 256)
			rephicon += clframetime * 27;
		else
			rephicon = 0;

		if (pulseicon & 32768)
			arphicon = 0;
		if (pulseicon & 16384)
			arphicon += clframetime * 27;
		else
			arphicon = 0;

		if (pulseicon &131072)
			drphicon = 0;
		if (pulseicon & 65536)
			drphicon += clframetime * 27;
		else
			drphicon = 0;

		//		local string X;
		//		X = ftos (phicon);	
		//		drawstring('0 0 0', X, '8 8 0', '3 3 3', 1);

		float dmg_indicator;
		dmg_indicator = floor(getstatf(STAT_DAMAGESCREEN));

		if (dmg_indicator & 2)
			dmu = 1;
		if (dmg_indicator & 1)
		//		{dmu -= clframetime;drawpic('240 0 0',"gfx/hud/di_top.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', dmu, 0);}

		{
			dmu -= clframetime;
			drawpic('0 0 0', "gfx/hud/di_top.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmu, 0);
		}
		else
			dmu = 1;

		if (dmg_indicator & 8)
			dmd = 1;
		if (dmg_indicator & 4)
		//	{dmd -= clframetime;drawpic('240 270 0',"gfx/hud/di_bottom.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', dmd, 0);}

		{
			dmd -= clframetime;
			drawpic('0 0 0', "gfx/hud/di_bottom.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmd, 0);
		}
		else
			dmd = 1;

		if (dmg_indicator & 32)
			dml = 1;
		if (dmg_indicator & 16)
		//	{dml -= clframetime;drawpic('0 135 0',"gfx/hud/di_left.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', dml, 0);}

		{
			dml -= clframetime;
			drawpic('0 0 0', "gfx/hud/di_left.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dml, 0);
		}
		else
			dml = 1;

		if (dmg_indicator & 128)
			dmr = 1;
		if (dmg_indicator & 64)
		//	{dmr -= clframetime ;drawpic('480 135 0',"gfx/hud/di_right.tga", vid_width *'0.5 0 0' + vid_height *'0 0.5 0', '1 1 1', dmr, 0);}

		{
			dmr -= clframetime;
			drawpic('0 0 0', "gfx/hud/di_right.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmr, 0);
		}
		else
			dmr = 1;

		if (removingmessages > 0)
			removingmessages -= v_sfps / 100;
		else
			removingmessages = 0;

		float checked5;
		checked5 = cvar("saved1");
		if (checked5 != 1)
			Crosshair();

		if (showjournal == 1)
		{
			using_cursor = 1;
			setcursormode(1);
			show_journal_ui();
			if (!journal_chapter)
				journal_chapter = 1;
			if (!journal_page)
				journal_page = 1;
			if (!journal_page_maps)
			{
				journal_page_maps = 1;
				if (mapname == "maps/hub1.bsp")
					journal_page_maps = 1;
				if (mapname == "maps/e1m1.bsp")
					journal_page_maps = 2;
				if (mapname == "maps/e1m2.bsp")
					journal_page_maps = 3;
				if (mapname == "maps/e1m3.bsp")
					journal_page_maps = 4;
				if (mapname == "maps/e1m4.bsp")
					journal_page_maps = 5;
				if (mapname == "maps/e1m5.bsp") 
					journal_page_maps = 6;
			}
		}
		else if (showjournal == 2)
		{
			show_messages_ui();
			journal_page_maps = 0;
		}
		else
		{
			if (using_cursor == 1)
			{
				if (journal_chapter)
					journal_chapter = 0;
				if (journal_page)
					journal_page = 0;
				if (journal_page_maps)
					journal_page_maps = 0;
				using_cursor = 0;
				setcursormode(0);
			}
		}

		//{
		float showingmessageshud;
		showingmessageshud = getstati(STAT_TIME_HUDMESSAGE);

		if ((showingmessageshud <= 0) && (hud_messages > 0))
			hud_messages = 0;

		float hidehud;
		hidehud = floor(getstatf(STAT_THWOFG));

		if (hidehud == 0)
		{
			ArtifactMenu();
			Ammo_Hud();
			Hud_Armor();
			Hud();
			e = self;
			for (self = world;
				(self = nextent(self));)
				if (self.draw2d)
					self.draw2d();
			self = e;
			if (hud_messages >= 12)
				hud_messages = 0;

			if (dmues > 0)
			{
				dmues -= clframetime;
				drawpic('0 0 0', "gfx/splashes/endgame.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmues, 0);
			}
		}

		if (hidehud == 2)
		{
			if (dmues < 1.2)
				dmues += clframetime;
			drawpic('0 0 0', "gfx/splashes/endgame.tga", vid_width *'1 0 0' + vid_height *'0 1 0', '1 1 1', dmues, 0);
		}

		//}
	}
};

////////////////end of qc file