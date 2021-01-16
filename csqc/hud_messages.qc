float hud_messages;
float oldhud_messages;
.vector imagepos;
.float msgalpha;
.float removing;
.float iflag;
.vector icolor;
float msgtime;
float removingmessages;
void() SUB_Remove = {remove(self);};
float savingtether;
void() check_tether2 = 
{
	read_currentprofileslot();

	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tetherclient.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	savingtether = stof(readtext);
	fclose(readparms);

	if (profilename)
		strunzone(profilename);

};

void() check_shrine = 
{
	read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/shrine.txt");
	local float readparms;
	local string readtext;
	readparms = fopen(campaignloc, FILE_READ);	//open what file to use (THIS TIME IN READ MODE)
	readtext = fgets(readparms);	//read the text
	savingtether = stof(readtext);
	fclose(readparms);
	if (profilename)
		strunzone(profilename);

};

void() Remove_Message = 
{
	self.removing = 1;

};

void() Remove_Message2 = 
{
	self.removing = 1;
};

.float deleted;
void() MessageThink2 = 
{
	if (self.removing == 1)
	{
		self.iflag = 0;
		self.msgalpha -= ap;
		self.imagepos_y -= yp;
		self.icolor_x -= 0.005;
		self.icolor_y -= 0.006;
		self.icolor_z -= 0.007;
		if (self.msgalpha < 0.5)
		{
			if (!self.deleted)
			{
				oldhud_messages -= 1;
				if (oldhud_messages <= 0)
					hud_messages = 0;
				self.deleted = 1;
			}

			remove(self);
		}
	}
	else
	{
		if (self.msgalpha < 1)
			self.msgalpha += api;
	}
};

void() Hud_Messages_Draw2 = 
{
	local string image;
	if (self.msg == 17)
		image = "gfx/hud/msg_shells.tga";
	string str;
	DImage2(self.imagepos, image, self.msgalpha, 1, self.icolor, '256 32 0', 0);
	str = strcat("X ", ftos(self.item_cnt));
	DString(self.imagepos + '130 8 0', str, self.msgalpha, 1, '1 1 1', '12 12 12');	//void(vector pos, string str, float alph, float escala, vector coloracion, vector siz) 
};

void() MessageThink = 
{
	local float alphaincreaser, alphafading, yfading;

	if (clframetime < 0.05)
		alphaincreaser = api + 0.025;
	if (clframetime < 0.033)
		alphaincreaser = api + 0.017;
	if (clframetime < 0.016)
		alphaincreaser = api + 0.015;
	if (clframetime < 0.01)
		alphaincreaser = api + 0.010;
	if (clframetime < 0.005)
		alphaincreaser = api;

	if (clframetime < 0.05)
		alphafading = ap + 0.1;
	if (clframetime < 0.033)
		alphafading = ap + 0.05;
	if (clframetime < 0.016)
		alphafading = ap + 0.025;
	if (clframetime < 0.01)
		alphafading = ap + 0.001;
	if (clframetime < 0.005)
		alphafading = ap;

	if (clframetime < 0.05)
		yfading = yp + 1.5;
	if (clframetime < 0.033)
		yfading = yp + 0.8;
	if (clframetime < 0.016)
		yfading = yp + 0.4;
	if (clframetime < 0.01)
		yfading = yp + 0.2;
	if (clframetime < 0.005)
		yfading = yp;

	if (self.removing == 1)
	{
		self.iflag = 0;
		self.msgalpha -= alphafading;
		self.imagepos_y -= yfading;
		self.icolor_x -= 0.005;
		self.icolor_y -= 0.006;
		self.icolor_z -= 0.007;
		if ((self.msgalpha < 0.75) && (!self.deleted))
		{
			oldhud_messages -= 1;
			if (oldhud_messages <= 0)
				hud_messages = 0;

			self.deleted = 1;
		}

		if (self.msgalpha <= 0)
			remove(self);
	}
	else
	{
		if (self.msgalpha < 1)
			self.msgalpha += alphaincreaser;
		else
			self.msgalpha = 1;
	}
};

void() Hud_Messages_Draw = 
{
	local string image;
	oldhud_messages = hud_messages;

	if (self.msg == 1)
		image = "gfx/hud/msg_aegis.tga";
	if (self.msg == 2)
		image = "gfx/hud/msg_armor.tga";
	if (self.msg == 4)
		image = "gfx/hud/msg_dark_armor.tga";
	if (self.msg == 5)
		image = "gfx/hud/msg_dark_helm.tga";
	if (self.msg == 6)
		image = "gfx/hud/msg_dark_shard.tga";
	if (self.msg == 9)
		image = "gfx/hud/msg_helm.tga";
	if (self.msg == 10)
		image = "gfx/hud/msg_lifeblood_beaker.tga";
	if (self.msg == 11)
		image = "gfx/hud/msg_lifeblood_vial.tga";
	if (self.msg == 12)
		image = "gfx/hud/msg_lifesiphon.tga";
	if (self.msg == 13)
		image = "gfx/hud/msg_shard.tga";
	if (self.msg == 15)
		image = "gfx/hud/msg_soultether.tga";
	if (self.msg == 16)
		image = "gfx/hud/msg_trinketofrespite.tga";
	if (self.msg == 17)
		image = "gfx/hud/msg_slugs.tga";
	if (self.msg == 18)
		image = "gfx/hud/msg_slugs.tga";
	if (self.msg == 19)
		image = "gfx/hud/msg_ore.tga";
	if (self.msg == 20)
		image = "gfx/hud/msg_shells.tga";
	if (self.msg == 21)
		image = "gfx/hud/msg_fangs.tga";
	if (self.msg == 22)
		image = "gfx/hud/msg_lances.tga";
	if (self.msg == 23)
		image = "gfx/hud/msg_coffer_key.tga";
	if (self.msg == 24)
	{
		check_tether2();
		if (savingtether == 1)
			image = "gfx/hud/msg_load.tga";
		else
			image = "gfx/hud/msg_saved.tga";
	}



	if (self.msg == 26)
	{
		check_shrine();
		if (savingtether == 1)
			image = "gfx/hud/msg_load.tga";
		else
			image = "gfx/hud/msg_saved.tga";
	}

	if (self.msg == 27)
		image = "gfx/hud/msg_secret.tga";
	if (self.msg == 28)
		image = "gfx/hud/msg_glyph_blue.tga";
	if (self.msg == 29)
		image = "gfx/hud/msg_sigil_flight.tga";
	if (self.msg == 30)
		image = "gfx/hud/msg_cysts.tga";
	if (self.msg == 31)
		image = "gfx/hud/msg_glyph_red.tga";
	if (self.msg == 32)
		image = "gfx/hud/msg_glyph_yellow.tga";
	if (self.msg == 35)
		image = "gfx/hud/msg_journal_update.tga";
	if (self.msg == 36)
		image = "gfx/hud/msg_locked_blue.tga";
	if (self.msg == 37)
		image = "gfx/hud/msg_locked_coffer.tga";
	if (self.msg == 38)
		image = "gfx/hud/msg_locked_red.tga";
	if (self.msg == 39)
		image = "gfx/hud/msg_locked_yellow.tga";

	if (self.msg == 50)
		image = "gfx/hud/msg_relic_e1m1.tga";
	if (self.msg == 51)
		image = "gfx/hud/msg_relic_e1m2.tga";
	if (self.msg == 52)
		image = "gfx/hud/msg_relic_e1m3.tga";
	if (self.msg == 53)
		image = "gfx/hud/msg_relic_e1m4.tga";
	if (self.msg == 54)
		image = "gfx/hud/msg_relic_e1m5.tga";


	if (self.msg == 90)
		image = "gfx/hud/msg_coachgun.tga";
	if (self.msg == 91)
		image = "gfx/hud/msg_shotgun.tga";
	if (self.msg == 92)
		image = "gfx/hud/msg_spitter.tga";
	if (self.msg == 93)
		image = "gfx/hud/msg_retcher.tga";
	if (self.msg == 94)
		image = "gfx/hud/msg_slagcannon.tga";
	if (self.msg == 95)
		image = "gfx/hud/msg_retcher.tga";


	if (self.msg == 101)
		image = "gfx/hud/msg_artifactA.tga";
	if (self.msg == 102)
		image = "gfx/hud/msg_artifactB.tga";
	if (self.msg == 103)
		image = "gfx/hud/msg_artifactC.tga";
	if (self.msg == 104)
		image = "gfx/hud/msg_artifactD.tga";
	if (self.msg == 105)
		image = "gfx/hud/msg_artifactE.tga";
	if (self.msg == 106)
		image = "gfx/hud/msg_artifactF.tga";
	if (self.msg == 107)
		image = "gfx/hud/msg_artifactG.tga";
	if (self.msg == 108)
		image = "gfx/hud/msg_artifactH.tga";
	if (self.msg == 109)
		image = "gfx/hud/msg_full.tga";
	if (self.msg == 110)
		image = "gfx/hud/msg_soul_tether.tga";
	float hidehud;
	hidehud = getstatf(STAT_THWOFG);
	local vector msgsize;

	if ((self.msg >= 50) && (self.msg <= 54))
		msgsize = '512 32 0';
	else
		msgsize = '256 32 0';

	if (hidehud != 1)
		DImage2(self.imagepos, image, self.msgalpha, 1, self.icolor, msgsize, 0);
};

void(float newent) Hud_Messages = 
{
	self.msg = ReadShort();
	if (newent)
	{
		local vector ar;
		ar_x = hmsgpos_x;
		vid_height = cvar("vid_conheight");
		ar_y = hmsgpos_y + (hud_messages *hms) + (540 - vid_height);
		self.imagepos = ar;
		if (self.msg < 255)
		hud_messages += 1;
		self.msgalpha = 0;
		self.iflag = 0;
		self.icolor = '1 1 1';
		if (self.msg == 255)
		{
			///////////// Key "Journal");
			tokenize(findkeysforcommand("impulse 35", 0));
			if (argv(0) != "-1")
				string fw_key21 = keynumtostring(stof(argv(0)));
			else
				fw_key21 = " ";
			centerprint(strcat("Press ", case_fixed(fw_key21), " to open Journal"));
			return;
		}

		if (self.msg == 256)
		{
			///////////// Key "Inventory");
			tokenize(findkeysforcommand("+button6", 0));
			if (argv(0) != "-1")
				string fw_key7 = keynumtostring(stof(argv(0)));
			else
				fw_key7 = " ";
			centerprint(strcat("Press and hold ", case_fixed(fw_key7), " to open Artifact Inventory"));
			return;
		}

		if (self.msg == 257)
		{
			///////////// Key "Artifact");
			tokenize(findkeysforcommand("impulse 15", 0));
			if (argv(0) != "-1")
				string fw_key22 = keynumtostring(stof(argv(0)));
			else
				fw_key22 = " ";
			centerprint(strcat("Press ", case_fixed(fw_key22), " to Use Artifact"));
			return;
		}

		if ((self.msg == 258) || (self.msg == 259))
		{
			tokenize(findkeysforcommand("+button3", 0));
			if (argv(0) != "-1")
				string fw_key6 = keynumtostring(stof(argv(0)));
			else
				fw_key6 = " ";
		}

		if (self.msg == 258)
		{
			///////////// Key "Artifact");
			tokenize(findkeysforcommand("+attack", 0));
			if (argv(0) != "-1")
				string fw_key5 = keynumtostring(stof(argv(0)));
			else
				fw_key5 = " ";
			centerprint(strcat(case_fixed(fw_key5), " Primary Attack \n\n\n",
				case_fixed(fw_key6), " Secondary Attack"));
			return;
		}
		if (self.msg == 259)
		{
			centerprint(strcat("Hold ", case_fixed(fw_key6), " then release at the top of your jump"));
			return;
		}
		if (self.msg == 260)
		{
			tokenize(findkeysforcommand("impulse 81", 0));
			if (argv(0) != "-1")
				string fw_key28 = keynumtostring(stof(argv(0)));
			else
				fw_key28 = " ";
			centerprint(strcat("Press ", case_fixed(fw_key28), " to Use Soul Tether (save game) "));
			return;
		}
		
		if (self.msg == 261)
		{
			tokenize(findkeysforcommand("impulse 89", 0));
			if (argv(0) != "-1")
				string fw_key29 = keynumtostring(stof(argv(0)));
			else
				fw_key29 = " ";
			centerprint(strcat("Press ", case_fixed(fw_key29), " to Return to Soul Tether (load game)"));
			return;
		}



		else
		{
			self.draw2d = Hud_Messages_Draw;
			self.predraw = MessageThink;
		}


	}
};

void(float newent) Hud_Messages2 = 
{
	self.msg = ReadShort();
	self.item_cnt = ReadShort();
	if (newent)
	{
		local vector ar;
		ar_x = hmsgpos_x;
		ar_y = hmsgpos_y + (hud_messages *hms) + (540 - vid_height);
		self.imagepos = ar;
		hud_messages += 1;
		oldhud_messages += 1;
		self.msgalpha = 0;
		self.iflag = 0;
		self.icolor = '1 1 1';
		self.draw2d = Hud_Messages_Draw2;
		self.predraw = MessageThink2;
		//self.nextthink = time + 0.03;
	}
};

.vector rorg;
.float cnt;

void() Health_Messages_Draw = 
{
	float menudbg;
	menudbg = getstatf(STAT_WRATHDEBUGSCREEN);
	if (menudbg == 1)
	{
		string thetext = ftos(self.cnt);
		vector charsize = '10 10';
		vector screenpos = cs_project(self.origin);
		if (screenpos_z >= 0)
		{
			screenpos_x -= stringwidth(thetext, TRUE, charsize) *0.5;	//align horizontally to centre
			screenpos_y -= charsize_y *0.5;	//align vertically again
			screenpos_z = 0;	//shut up dp.
			drawstring(screenpos, thetext, charsize, '3 3 3', 1, 0);
		}
	}
};

void(float newent) Health_Indicator = 
{
	self.origin_x = ReadCoord();
	self.origin_y = ReadCoord();
	self.origin_z = ReadCoord();
	self.cnt = ReadShort();
	if (newent)
	{
		self.classname = "missile";
		//self.drawmask = MASK_NORMAL;	// makes the entity visible
		//setmodel(self, "models/dev/gizmo.md3");
		self.draw2d = Health_Messages_Draw;
	}
};
/*
.float alpha;
void() Artifact_Think =
{
if(self.frame == 1)
self.alpha = 0.1;
if(self.frame == 2)
self.alpha = 0.2;
if(self.frame == 3)
self.alpha = 0.4;
if(self.frame == 4)
self.alpha = 0.6;
if(self.frame == 5)
self.alpha = 0.8;
if(self.frame == 6)
self.alpha = 1;

setorigin (self,VF_ORIGIN);

};

void(float newent)artifact_spawn =
{
	self.origin_x = ReadCoord();
	self.origin_y = ReadCoord();
	self.origin_z = ReadCoord();
	self.frame = ReadShort();
	if (newent)
	{
		self.classname = "artifact";
		self.drawmask = MASK_NORMAL;	// makes the entity visible
		setmodel(self, "models/artifacts/active/cruel_aegis_active.md3");
		self.think = Artifact_Think;
		self.nextthink = time;
		}
};
*/

float mrmenualpha;

void() show_messages_ui = 
{
	string ui_image;
	vector posimage, posimage2, posimage3;
	ui_image = "gfx/journal/journal.tga";
	posimage = '-80 -480 0';

	drawfill('0 0 0', vid_width *'1 0 0' + vid_height *'0 1 0', '0 0 0', 0.65 *mrmenualpha, 0);

	DImage2(posimage, ui_image, 1, 1, '1 1 1', '640 480 0', 0);
	//void(vector pos, string str, float alph, float escala, vector coloracion, vector siz) DString =

	posimage3 = '120 -480 0' + '0 300 0';

	local vector scroll_variation;
	scroll_variation_x = 64;	// 40 0';
	scroll_variation_y += 40 - 280 * journal_scroll;

	posimage += scroll_variation;

	vector colorimg;
	colorimg = '1 1 1';

	posimage2 = '-40 -480 0';
	posimage2 += '0 40 0';
	DString(posimage2, _("Message Text 1 file 1"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 2"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 3"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 4"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 5"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 6"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 7"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 8"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 9"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 10"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 11"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 12"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 13"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 14"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 15"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 16"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 17"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';
	DString(posimage2, _("Message Text 1 file 18"), 1, 1, colorimg, ' 14 14 0');posimage2 += '0 20 0';

};

////////////////end of qc file