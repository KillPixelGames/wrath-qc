string line1;
string line2;
string line3;
string line4;
void(float mapname_list) read_frik_stats = 
{
	local float nLength;
	local string namewbsp, namecomplete, currentmaplocal, currentmap;

	if (mapname_list == 1)
		currentmaplocal = "maps/hub1.bsp";
	if (mapname_list == 2)
		currentmaplocal = "maps/e1m1.bsp";
	if (mapname_list == 3)
		currentmaplocal = "maps/e1m2.bsp";
	if (mapname_list == 4)
		currentmaplocal = "maps/e1m3.bsp";
	if (mapname_list == 5)
		currentmaplocal = "maps/e1m4.bsp";
	if (mapname_list == 6)
		currentmaplocal = "maps/e1m5.bsp";
	namecomplete = substring(currentmaplocal, 5, 100);
	nLength = strlen(namecomplete);
	namewbsp = substring(namecomplete, 0, nLength - 4);
	currentmap = namewbsp;
	local float readparms;
	local string readtext;
	read_currentprofileslot();
	readparms = fopen_wrath((strcat("profiles/", profilename, "/maps/", currentmap, ".stats")), FILE_READ);
	readtext = fgets(readparms);	//read the text
	line1 = (readtext);
	readtext = fgets(readparms);
	line2 = (readtext);
	readtext = fgets(readparms);
	line3 = (readtext);
	readtext = fgets(readparms);
	line4 = (readtext);
	fclose_wrath(readparms);
};

void() show_journal_ui = 
{
	string ui_image, ui_image2;
	vector posimage, posimage2, posimage3;
	ui_image = "gfx/journal/journal.tga";
	posimage = '224 70 0';
	drawfill('0 0 0', vid_width *'1 0 0' + vid_height *'0 1 0', '0 0 0', 0.65, 0);

	DImage3((posimage), ui_image, 1, '1 1 1', ('512 400 0'));

	posimage3 = '120 -480 0' + '0 300 0';

	vector scroll_variation, scroll_variation3;

	vector colorimg;
	colorimg = '-1 -1 -1';

	if (journal_chapter == 1)
	{

		float visited_maps;
		visited_maps = getstatf(STAT_SPOTTED_MAPS);
		posimage = '224 70 0' + '82 80 0';

		if (visited_maps & LE_HUB1)
		{
			DImage3(posimage, "gfx/journal/labels/label_hub1.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_hub1_active.tga", 1, '1 1 1', '128 16 0', 301);
			posimage += nofixed_vector('0 32 0');
		}

		if (visited_maps & LE_E1M1)
		{
			DImage3(posimage, "gfx/journal/labels/label_e1m1.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_e1m1_active.tga", 1, '1 1 1', '128 16 0', 302);
			posimage += nofixed_vector('0 32 0');
		}

		if (visited_maps & LE_E1M2)
		{
			DImage3(posimage, "gfx/journal/labels/label_e1m2.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_e1m2_active.tga", 1, '1 1 1', '128 16 0', 303);
			posimage += nofixed_vector('0 32 0');
		}

		if (visited_maps & LE_E1M3)
		{
			DImage3(posimage, "gfx/journal/labels/label_e1m3.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_e1m3_active.tga", 1, '1 1 1', '128 16 0', 304);
			posimage += nofixed_vector('0 32 0');
		}

		if (visited_maps & LE_E1M4)
		{
			DImage3(posimage, "gfx/journal/labels/label_e1m4.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_e1m4_active.tga", 1, '1 1 1', '128 16 0', 305);
			posimage += nofixed_vector('0 32 0');
		}
		if (visited_maps & LE_E1M5)
		{
			DImage3(posimage, "gfx/journal/labels/label_e1m5.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_e1m5_active.tga", 1, '1 1 1', '128 16 0', 306);
			posimage += nofixed_vector('0 32 0');
		}		float found_secrets_local, total_secrets_local;

		found_secrets_local = getstati(STAT_SECRETS);
		total_secrets_local = getstati(STAT_TOTALSECRETS);

		float killed_monsters_local, total_monsters_local;

		killed_monsters_local = getstati(STAT_MONSTERS);
		total_monsters_local = getstati(STAT_TOTALMONSTERS);

		local string strTime;
		strTime = SG_GetFormattedTimeStringUnZoned(time);
		string hasrelic;
		local float hasrelics;
		hasrelics = getstatf(STAT_FOUND_RELICS);
		if ((journal_page_maps == 1) && (visited_maps & LE_HUB1))
		{
			ui_image2 = "gfx/journal/pages/page_hub1.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
			posimage2 = '224 70 0' + '256 268 0' + '120 8 0';

			DImage3(('224 70 0' + '293 268 0'), "gfx/journal/stats_hub.tga", 1, '1 1 1', '56 56 0');

			if (hasrelics & RL_E1M1)
				DImage3(('224 70 0' + '256 24 0' + '32 168 0'), "gfx/journal/pages/relic_e1m1", 1, '1 1 1', '64 64 0');
			if (hasrelics & RL_E1M2)
				DImage3(('224 70 0' + '256 24 0' + '7 97 0'), "gfx/journal/pages/relic_e1m2", 1, '1 1 1', '64 64 0');
			if (hasrelics & RL_E1M3)
				DImage3(('224 70 0' + '256 24 0' + '136 89 0'), "gfx/journal/pages/relic_e1m3", 1, '1 1 1', '64 64 0');
			if (hasrelics & RL_E1M4)
				DImage3(('224 70 0' + '256 24 0' + '111 168 0'), "gfx/journal/pages/relic_e1m4", 1, '1 1 1', '64 64 0');
			if (hasrelics & RL_E1M5)
				DImage3(('224 70 0' + '256 24 0' + '71 49 0'), "gfx/journal/pages/relic_e1m5", 1, '1 1 1', '64 64 0');

			if (mapname == "maps/hub1.bsp")
			{
				DstringJournal(posimage2, strcat(ftos(found_secrets_local), "/", ftos(total_secrets_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(ftos(getstatf(STAT_USED_RELICS)), "/5"), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(strTime), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
			else
			{
				read_frik_stats(1);
				DstringJournal(posimage2, line2, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(ftos(getstatf(STAT_USED_RELICS)), "/5"), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line4, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
		}

		if ((journal_page_maps == 2) && (visited_maps & LE_E1M1))
		{
			ui_image2 = "gfx/journal/pages/page_e1m1.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
			posimage2 = '224 70 0' + '256 268 0' + '126 3 0';

			DImage3(('224 70 0' + '293 268 0'), "gfx/journal/stats_level.tga", 1, '1 1 1', '64 64 0');

			if (hasrelics & RL_E1M1)
				hasrelic = "1";
			else
				hasrelic = "0";

			if (hasrelics & RL_E1M1)
				DImage3(('224 70 0' + '272 80 0'), "gfx/journal/pages/relic_e1m1_large", 1, '1 1 1', '184 184 0');

			if (mapname == "maps/e1m1.bsp")
			{
				DstringJournal(posimage2, strcat(ftos(killed_monsters_local), "/", ftos(total_monsters_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(ftos(found_secrets_local), "/", ftos(total_secrets_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(hasrelic, "/1"), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, strcat(strTime), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
			else
			{
				read_frik_stats(2);
				DstringJournal(posimage2, line1, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line2, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line3, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, line4, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
		}

		if ((journal_page_maps == 3) && (visited_maps & LE_E1M2))
		{
			ui_image2 = "gfx/journal/pages/page_e1m2.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
			posimage2 = '224 70 0' + '256 268 0' + '126 3 0';

			DImage3(('224 70 0' + '293 268 0'), "gfx/journal/stats_level.tga", 1, '1 1 1', '64 64 0');

			if (hasrelics & RL_E1M2)
				hasrelic = "1";
			else
				hasrelic = "0";

			if (hasrelics & RL_E1M2)
				DImage3(('224 70 0' + '272 80 0'), "gfx/journal/pages/relic_e1m2_large", 1, '1 1 1', '184 184 0');

			if (mapname == "maps/e1m2.bsp")
			{
				DstringJournal(posimage2, strcat(ftos(killed_monsters_local), "/", ftos(total_monsters_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(ftos(found_secrets_local), "/", ftos(total_secrets_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(hasrelic, "/1"), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, strcat(strTime), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
			else
			{
				read_frik_stats(3);
				DstringJournal(posimage2, line1, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line2, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line3, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, line4, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
		}
		if ((journal_page_maps == 4) && (visited_maps & LE_E1M3))
		{
			ui_image2 = "gfx/journal/pages/page_e1m3.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
			posimage2 = '224 70 0' + '256 268 0' + '126 3 0';

			DImage3(('224 70 0' + '293 268 0'), "gfx/journal/stats_level.tga", 1, '1 1 1', '64 64 0');

			if (hasrelics & RL_E1M3)
				hasrelic = "1";
			else
				hasrelic = "0";

			if (hasrelics & RL_E1M3)
				DImage3(('224 70 0' + '272 80 0'), "gfx/journal/pages/relic_e1m3_large", 1, '1 1 1', '184 184 0');

			if (mapname == "maps/e1m3.bsp")
			{
				DstringJournal(posimage2, strcat(ftos(killed_monsters_local), "/", ftos(total_monsters_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(ftos(found_secrets_local), "/", ftos(total_secrets_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(hasrelic, "/1"), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, strcat(strTime), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
			else
			{
				read_frik_stats(4);
				DstringJournal(posimage2, line1, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line2, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line3, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, line4, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
		}
		if ((journal_page_maps == 5) && (visited_maps & LE_E1M4))
		{
			ui_image2 = "gfx/journal/pages/page_e1m4.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
			posimage2 = '224 70 0' + '256 268 0' + '126 3 0';

			DImage3(('224 70 0' + '293 268 0'), "gfx/journal/stats_level.tga", 1, '1 1 1', '64 64 0');

			if (hasrelics & RL_E1M4)
				hasrelic = "1";
			else
				hasrelic = "0";

			if (hasrelics & RL_E1M4)
				DImage3(('224 70 0' + '272 80 0'), "gfx/journal/pages/relic_e1m4_large", 1, '1 1 1', '184 184 0');

			if (mapname == "maps/e1m4.bsp")
			{
				DstringJournal(posimage2, strcat(ftos(killed_monsters_local), "/", ftos(total_monsters_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(ftos(found_secrets_local), "/", ftos(total_secrets_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(hasrelic, "/1"), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, strcat(strTime), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
			else
			{
				read_frik_stats(5);
				DstringJournal(posimage2, line1, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line2, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line3, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, line4, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
		}
		if ((journal_page_maps == 6) && (visited_maps & LE_E1M5))
		{
			ui_image2 = "gfx/journal/pages/page_e1m5.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
			posimage2 = '224 70 0' + '256 268 0' + '126 3 0';

			DImage3(('224 70 0' + '293 268 0'), "gfx/journal/stats_level.tga", 1, '1 1 1', '64 64 0');

			if (hasrelics & RL_E1M5)
				hasrelic = "1";
			else
				hasrelic = "0";

			if (hasrelics & RL_E1M5)
				DImage3(('224 70 0' + '272 80 0'), "gfx/journal/pages/relic_e1m5_large", 1, '1 1 1', '184 184 0');

			if (mapname == "maps/e1m5.bsp")
			{
				DstringJournal(posimage2, strcat(ftos(killed_monsters_local), "/", ftos(total_monsters_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(ftos(found_secrets_local), "/", ftos(total_secrets_local)), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, strcat(hasrelic, "/1"), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, strcat(strTime), 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
			else
			{
				read_frik_stats(6);
				DstringJournal(posimage2, line1, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line2, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 15 0');
				DstringJournal(posimage2, line3, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 16 0');
				DstringJournal(posimage2, line4, 1, 1, colorimg, ' 10 10 0');
				posimage2 += nofixed_vector('0 32 0');
			}
		}
		DImage3(('51 336 0' + '224 70 0'), "gfx/journal/taba_active.tga", 1, '1 1 1', '88 48 0');
		DImage4(('51 336 0' + '224 70 0'), "gfx/journal/taba_active.tga", 1, '1 1 1', '88 48 0', 200);
		DImage4(('144 336 0' + '224 70 0'), "gfx/journal/tabb_active.tga", 1, '1 1 1', '96 56 0', 201);
		DImage4(('264 328 0' + '224 70 0'), "gfx/journal/tabc_active.tga", 1, '1 1 1', '88 64 0', 202);
		DImage4(('368 328 0' + '224 70 0'), "gfx/journal/tabd_active.tga", 1, '1 1 1', '96 64 0', 203);

	}

	if (journal_chapter == 2)
	{
		float jitems_armory;
		jitems_armory = getstati(STAT_ITEMS);

		//DstringJournal (posimage,"armoryS", 1, 1, '0.5 -1 -1',' 9 9 0');
		posimage = '224 70 0' + '82 80 0';
		string grer_armory;
		grer_armory = ftos(jitems_armory);
		//DstringJournal (posimage,grer_armory, 1, 1, colorimg,' 9 9 0', 1);

		scroll_variation_y += -32 * journal_scroll_armory;
		posimage += scroll_variation;

		posimage = (posimage);

		if (jitems_armory & IT_MELEE)
		{
			DImage3b(posimage, "gfx/journal/labels/label_melee.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_melee_active.tga", 1, '1 1 1', '128 16 0', 331);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_armory & IT_COACHGUN)
		{
			DImage3b(posimage, "gfx/journal/labels/label_coachgun.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_coachgun_active.tga", 1, '1 1 1', '128 16 0', 332);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_armory & IT_SHOTGUN)
		{
			DImage3b(posimage, "gfx/journal/labels/label_shotgun.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_shotgun_active.tga", 1, '1 1 1', '128 16 0', 333);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_armory & IT_SPITTER)
		{
			DImage3b(posimage, "gfx/journal/labels/label_spitter.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_spitter_active.tga", 1, '1 1 1', '128 16 0', 334);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_armory & IT_RETCHER)
		{
			DImage3b(posimage, "gfx/journal/labels/label_retcher.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_retcher_active.tga", 1, '1 1 1', '128 16 0', 335);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_armory & IT_CANNON)
		{
			DImage3b(posimage, "gfx/journal/labels/label_cannon.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_cannon_active.tga", 1, '1 1 1', '128 16 0', 336);
			posimage += nofixed_vector('0 32 0');
		}

		/*if(firstscroll  == 1)
		{
		DImage3  (('224 70 0' + '128 32 0'),"gfx/journal/arrow_up", 1, '1 1 1', '32 40 0');
		DImage4  (('224 70 0' + '128 32 0'),"gfx/journal/arrow_up_active", 1, '1 1 1', '32 40 0', 100);
		}

		if(lastscroll  == 1)
		{
		DImage3  (('224 70 0' + '128 272 0'),"gfx/journal/arrow_down", 1, '1 1 1', '32 40 0');
		DImage4  (('224 70 0' + '128 272 0'),"gfx/journal/arrow_down_active", 1, '1 1 1', '32 40 0', 101);	
		}

		firstscroll  = 0;
		lastscroll = 0;
		*/
		if (journal_page_armory == 1)
		{
			ui_image2 = "gfx/journal/pages/page_melee.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_armory == 2)
		{
			ui_image2 = "gfx/journal/pages/page_coachgun.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_armory == 3)
		{
			ui_image2 = "gfx/journal/pages/page_shotgun.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_armory == 4)
		{
			ui_image2 = "gfx/journal/pages/page_spitter.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_armory == 5)
		{
			ui_image2 = "gfx/journal/pages/page_retcher.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_armory == 6)
		{
			ui_image2 = "gfx/journal/pages/page_cannon.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		DImage3(('144 336 0' + '224 70 0'), "gfx/journal/tabb_active.tga", 1, '1 1 1', '96 56 0');
		DImage4(('51 336 0' + '224 70 0'), "gfx/journal/taba_active.tga", 1, '1 1 1', '88 48 0', 200);
		DImage4(('144 336 0' + '224 70 0'), "gfx/journal/tabb_active.tga", 1, '1 1 1', '96 56 0', 201);
		DImage4(('264 328 0' + '224 70 0'), "gfx/journal/tabc_active.tga", 1, '1 1 1', '88 64 0', 202);
		DImage4(('368 328 0' + '224 70 0'), "gfx/journal/tabd_active.tga", 1, '1 1 1', '96 64 0', 203);

	}

	if (journal_chapter == 3)
	{
		float jitems_bestiary;
		jitems_bestiary = getstatf(STAT_JOURNAL_MESSAGESM);

		//DstringJournal (posimage,"BESTIARYS", 1, 1, '0.5 -1 -1',' 9 9 0');
		posimage = '224 70 0' + '82 80 0';
		string grer_bestiary;
		grer_bestiary = ftos(jitems_bestiary);
		//DstringJournal (posimage,grer_bestiary, 1, 1, colorimg,' 9 9 0', 1);

		scroll_variation_y += -32 * journal_scroll_bestiary;
		posimage += scroll_variation;

		posimage = (posimage);

		if (jitems_bestiary & JB_A)
		{
			DImage3b(posimage, "gfx/journal/labels/label_fallen.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_fallen_active.tga", 1, '1 1 1', '128 16 0', 301);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_B)
		{
			DImage3b(posimage, "gfx/journal/labels/label_wraith.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_wraith_active.tga", 1, '1 1 1', '128 16 0', 302);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_C)
		{
			DImage3b(posimage, "gfx/journal/labels/label_afflicted.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_afflicted_active.tga", 1, '1 1 1', '128 16 0', 303);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_D)
		{
			DImage3b(posimage, "gfx/journal/labels/label_widow.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_widow_active.tga", 1, '1 1 1', '128 16 0', 304);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_E)
		{
			DImage3b(posimage, "gfx/journal/labels/label_invader.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_invader_active.tga", 1, '1 1 1', '128 16 0', 305);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_F)
		{
			DImage3b(posimage, "gfx/journal/labels/label_heretic.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_heretic_active.tga", 1, '1 1 1', '128 16 0', 306);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_G)
		{
			DImage3b(posimage, "gfx/journal/labels/label_executioner.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_executioner_active.tga", 1, '1 1 1', '128 16 0', 307);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_H)
		{
			DImage3b(posimage, "gfx/journal/labels/label_stricken.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_stricken_active.tga", 1, '1 1 1', '128 16 0', 308);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_I)
		{
			DImage3b(posimage, "gfx/journal/labels/label_wretch.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_wretch_active.tga", 1, '1 1 1', '128 16 0', 309);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_J)
		{
			DImage3b(posimage, "gfx/journal/labels/label_oppressor.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_oppressor_active.tga", 1, '1 1 1', '128 16 0', 310);
			posimage += nofixed_vector('0 32 0');
		}

		if (jitems_bestiary & JB_K)
		{
			DImage3b(posimage, "gfx/journal/labels/label_lurker.tga", 1, '1 1 1', '128 16 0');
			DImage4(posimage, "gfx/journal/labels/label_lurker_active.tga", 1, '1 1 1', '128 16 0', 311);
		}
		if (firstscroll == 1)
		{
			DImage3(('224 70 0' + '128 32 0'), "gfx/journal/arrow_up", 1, '1 1 1', '32 40 0');
			DImage4(('224 70 0' + '128 32 0'), "gfx/journal/arrow_up_active", 1, '1 1 1', '32 40 0', 100);
		}

		if (lastscroll == 1)
		{
			DImage3(('224 70 0' + '128 272 0'), "gfx/journal/arrow_down", 1, '1 1 1', '32 40 0');
			DImage4(('224 70 0' + '128 272 0'), "gfx/journal/arrow_down_active", 1, '1 1 1', '32 40 0', 101);
		}

		firstscroll = 0;
		lastscroll = 0;

		if (journal_page_bestiary == 1)
		{
			ui_image2 = "gfx/journal/pages/page_fallen.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 2)
		{
			ui_image2 = "gfx/journal/pages/page_wraith.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 3)
		{
			ui_image2 = "gfx/journal/pages/page_afflicted.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 4)
		{
			ui_image2 = "gfx/journal/pages/page_widow.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 5)
		{
			ui_image2 = "gfx/journal/pages/page_invader.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 6)
		{
			ui_image2 = "gfx/journal/pages/page_heretic.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 7)
		{
			ui_image2 = "gfx/journal/pages/page_executioner.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 8)
		{
			ui_image2 = "gfx/journal/pages/page_stricken.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 9)
		{
			ui_image2 = "gfx/journal/pages/page_wretch.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}
		if (journal_page_bestiary == 10)
		{
			ui_image2 = "gfx/journal/pages/page_oppressor.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}

		if (journal_page_bestiary == 11)
		{
			ui_image2 = "gfx/journal/pages/page_lurker.tga";
			DImage3(('224 70 0' + '256 24 0'), ui_image2, 1, '1 1 1', '216 304 0');
		}		
		
		DImage3(('264 328 0' + '224 70 0'), "gfx/journal/tabc_active.tga", 1, '1 1 1', '88 64 0');
		DImage4(('51 336 0' + '224 70 0'), "gfx/journal/taba_active.tga", 1, '1 1 1', '88 48 0', 200);
		DImage4(('144 336 0' + '224 70 0'), "gfx/journal/tabb_active.tga", 1, '1 1 1', '96 56 0', 201);
		DImage4(('264 328 0' + '224 70 0'), "gfx/journal/tabc_active.tga", 1, '1 1 1', '88 64 0', 202);
		DImage4(('368 328 0' + '224 70 0'), "gfx/journal/tabd_active.tga", 1, '1 1 1', '96 64 0', 203);
	}

	if (journal_chapter == 4)
	{
		float localtotalscroll;

		///////////// Key "Move Forward");	
		tokenize(findkeysforcommand("+forward", 0));
		if (argv(0) != "-1")
			string fw_key1 = keynumtostring(stof(argv(0)));
		else
			fw_key1 = " ";
		///////////// Key "Move backward");	
		tokenize(findkeysforcommand("+back", 0));
		if (argv(0) != "-1")
			string fw_key2 = keynumtostring(stof(argv(0)));
		else
			fw_key2 = " ";
		///////////// Key "Move Left");
		tokenize(findkeysforcommand("+moveleft", 0));
		if (argv(0) != "-1")
			string fw_key3 = keynumtostring(stof(argv(0)));
		else
			fw_key3 = " ";
		///////////// Key "Move Right");	
		tokenize(findkeysforcommand("+moveright", 0));
		if (argv(0) != "-1")
			string fw_key4 = keynumtostring(stof(argv(0)));
		else
			fw_key4 = " ";
		///////////// Key "Fire");	
		tokenize(findkeysforcommand("+attack", 0));
		if (argv(0) != "-1")
			string fw_key5 = keynumtostring(stof(argv(0)));
		else
			fw_key5 = " ";
		///////////// Key "Alt Fire");	
		tokenize(findkeysforcommand("+button3", 0));
		if (argv(0) != "-1")
			string fw_key6 = keynumtostring(stof(argv(0)));
		else
			fw_key6 = " ";
		///////////// Key "Inventory");
		tokenize(findkeysforcommand("+button6", 0));
		if (argv(0) != "-1")
			string fw_key7 = keynumtostring(stof(argv(0)));
		else
			fw_key7 = " ";
		///////////// Key "Jump");	
		tokenize(findkeysforcommand("+jump", 0));
		if (argv(0) != "-1")
			string fw_key8 = keynumtostring(stof(argv(0)));
		else
			fw_key8 = " ";
		///////////// Key "Crouch");	
		tokenize(findkeysforcommand("+button4", 0));
		if (argv(0) != "-1")
			string fw_key9 = keynumtostring(stof(argv(0)));
		else
			fw_key9 = " ";
		///////////// Key "Melee");
		tokenize(findkeysforcommand("impulse 1", 0));
		if (argv(0) != "-1")
			string fw_key10 = keynumtostring(stof(argv(0)));
		else
			fw_key10 = " ";
		///////////// Key "Coachgun");	
		tokenize(findkeysforcommand("impulse 2", 0));
		if (argv(0) != "-1")
			string fw_key11 = keynumtostring(stof(argv(0)));
		else
			fw_key11 = " ";
		///////////// Key "Shotgun");
		tokenize(findkeysforcommand("impulse 3", 0));
		if (argv(0) != "-1")
			string fw_key12 = keynumtostring(stof(argv(0)));
		else
			fw_key12 = " ";
		///////////// Key "Fang Spittter");
		tokenize(findkeysforcommand("impulse 4", 0));
		if (argv(0) != "-1")
			string fw_key14 = keynumtostring(stof(argv(0)));
		else
			fw_key14 = " ";
		///////////// Key "Retcher");
		tokenize(findkeysforcommand("impulse 5", 0));
		if (argv(0) != "-1")
			string fw_key15 = keynumtostring(stof(argv(0)));
		else
			fw_key15 = " ";
		///////////// Key "Slag Cannon");
		tokenize(findkeysforcommand("impulse 6", 0));
		if (argv(0) != "-1")
			string fw_key16 = keynumtostring(stof(argv(0)));
		else
			fw_key16 = " ";
		/*	///////////// Key "Artifact Inventory");
			tokenize(findkeysforcommand("impulse 7",0));
			if(argv(0) != "-1")
			string fw_key17 = keynumtostring (stof(argv(0)));
			else
			fw_key17 = " ";	
			///////////// Key "Artifact Inventory");
			tokenize(findkeysforcommand("impulse 8",0));
			if(argv(0) != "-1")
			string fw_key18 = keynumtostring (stof(argv(0)));
			else
			fw_key18 = " ";	
			///////////// Key "Artifact Inventory");
			tokenize(findkeysforcommand("impulse 9",0));
			if(argv(0) != "-1")
			string fw_key19 = keynumtostring (stof(argv(0)));
			else
			fw_key19 = " ";	*/
		///////////// Key "Use");
		tokenize(findkeysforcommand("+button5", 0));
		if (argv(0) != "-1")
			string fw_key20 = keynumtostring(stof(argv(0)));
		else
			fw_key20 = " ";
		///////////// Key "Journal");
		tokenize(findkeysforcommand("impulse 35", 0));
		if (argv(0) != "-1")
			string fw_key21 = keynumtostring(stof(argv(0)));
		else
			fw_key21 = " ";
		///////////// Key "Use Artifact");
		tokenize(findkeysforcommand("impulse 15", 0));
		if (argv(0) != "-1")
			string fw_key22 = keynumtostring(stof(argv(0)));
		else
			fw_key22 = " ";
		///////////// Key "Walk");
		tokenize(findkeysforcommand("+button7", 0));
		if (argv(0) != "-1")
			string fw_key28 = keynumtostring(stof(argv(0)));
		else
			fw_key28 = " ";
		///////////// Key "Swim Up");
		tokenize(findkeysforcommand("+moveup", 0));
		if (argv(0) != "-1")
			string fw_key23 = keynumtostring(stof(argv(0)));
		else
			fw_key23 = " ";
		///////////// Key "Swim Down");
		tokenize(findkeysforcommand("+movedown", 0));
		if (argv(0) != "-1")
			string fw_key24 = keynumtostring(stof(argv(0)));
		else
			fw_key24 = " ";
		///////////// Key "Last Weapon");
		tokenize(findkeysforcommand("impulse 57", 0));
		if (argv(0) != "-1")
			string fw_key25 = keynumtostring(stof(argv(0)));
		else
			fw_key25 = " ";
		///////////// Key "Prev Weapon");
		tokenize(findkeysforcommand("impulse 55", 0));
		if (argv(0) != "-1")
			string fw_key26 = keynumtostring(stof(argv(0)));
		else
			fw_key26 = " ";
		///////////// Key "Next Weapon");
		tokenize(findkeysforcommand("impulse 56", 0));
		if (argv(0) != "-1")
			string fw_key27 = keynumtostring(stof(argv(0)));
		else
			fw_key27 = " ";
		///////////// Key "Use Soul Tether");
		tokenize(findkeysforcommand("impulse 81", 0));
		if (argv(0) != "-1")
			string fw_key29 = keynumtostring(stof(argv(0)));
		else
			fw_key29 = " ";
		///////////// Key "Load Soul Tether");
		tokenize(findkeysforcommand("impulse 89", 0));
		if (argv(0) != "-1")
			string fw_key30 = keynumtostring(stof(argv(0)));
		else
			fw_key30 = " ";

		posimage = '224 70 0' + '82 80 0';
		scroll_variation3_y += -32 * journal_scroll;
		posimage += scroll_variation3;
		posimage = (posimage);

		DImage3(posimage, "gfx/journal/labels/label_controls_active", 1, '1 1 1', '128 16 0');
		//DstringJournal(posimage + '35 25 0', strcat("Controls"), 1, 1, '1 1 1', ' 10 10 0');
		posimage += nofixed_vector('0 32 0');
		localtotalscroll++;

		posimage2 = '272 60 0 ' + '216 30 0';
		posimage2 += ('0 8 0');
		DstringJournal(posimage2, strcat("Move Forward...........", case_fixed(fw_key1)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Move backward........", case_fixed(fw_key2)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Move Left..................", case_fixed(fw_key3)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Move Right................", case_fixed(fw_key4)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Jump.........................", case_fixed(fw_key8)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Crouch......................", case_fixed(fw_key9)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Walk..........................", case_fixed(fw_key28)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Swim Up...................", case_fixed(fw_key23)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Swim Down..............", case_fixed(fw_key24)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Primary Fire..............", case_fixed(fw_key5)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Secondary Fire.........", case_fixed(fw_key6)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Use............................", case_fixed(fw_key20)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Artifacts (hold)...........", case_fixed(fw_key7)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Use Artifact...............", case_fixed(fw_key22)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Use Soul Tether........", case_fixed(fw_key28)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Load game Menu........", case_fixed(fw_key29)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Journal......................", case_fixed(fw_key21)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Next Weapon............", case_fixed(fw_key27)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Previous Weapon.....", case_fixed(fw_key26)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Last Weapon.............", case_fixed(fw_key25)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Ruination Blade.........", case_fixed(fw_key10)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Coachgun.................", case_fixed(fw_key11)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Shotgun....................", case_fixed(fw_key12)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Fang Spittter.............", case_fixed(fw_key14)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Retcher.....................", case_fixed(fw_key15)), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		DstringJournal(posimage2, strcat("Main Menu.............[Escape]"), 1, 1, colorimg, ' 10 8 0');
		posimage2 += nofixed_vector('0 10 0');
		/*
		DstringJournal(posimage2, strcat("Move Forward...........", case_fixed(fw_key1)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Move backward........", case_fixed(fw_key2)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Move Left..................", case_fixed(fw_key3)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Move Right................", case_fixed(fw_key4)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Jump.........................", case_fixed(fw_key8)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Crouch......................", case_fixed(fw_key9)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Walk..........................", case_fixed(fw_key28)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Swim Up...................", case_fixed(fw_key23)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Swim Down..............", case_fixed(fw_key24)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Primary Fire..............", case_fixed(fw_key5)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Secondary Fire.........", case_fixed(fw_key6)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Use............................", case_fixed(fw_key20)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Artifacts (hold)...........", case_fixed(fw_key7)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Use Artifact...............", case_fixed(fw_key22)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Use Soul Tether........", case_fixed(fw_key28)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Load game Menu........", case_fixed(fw_key29)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Journal......................", case_fixed(fw_key21)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Next Weapon............", case_fixed(fw_key27)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Previous Weapon.....", case_fixed(fw_key26)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Last Weapon.............", case_fixed(fw_key25)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Ruination Blade.........", case_fixed(fw_key10)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Coachgun.................", case_fixed(fw_key11)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Shotgun....................", case_fixed(fw_key12)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Fang Spittter.............", case_fixed(fw_key14)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Retcher.....................", case_fixed(fw_key15)), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');
		DstringJournal(posimage2, strcat("Main Menu.............[Escape]"), 1, 1, colorimg, ' 10 10 0');
		posimage2 += nofixed_vector('0 12 0');*/

		DImage3(('368 328 0' + '224 70 0'), "gfx/journal/tabd_active.tga", 1, '1 1 1', '96 64 0');


		DImage4(('51 336 0' + '224 70 0'), "gfx/journal/taba_active.tga", 1, '1 1 1', '88 48 0', 200);
		DImage4(('144 336 0' + '224 70 0'), "gfx/journal/tabb_active.tga", 1, '1 1 1', '96 56 0', 201);
		DImage4(('264 328 0' + '224 70 0'), "gfx/journal/tabc_active.tga", 1, '1 1 1', '88 64 0', 202);
		DImage4(('368 328 0' + '224 70 0'), "gfx/journal/tabd_active.tga", 1, '1 1 1', '96 64 0', 203);
	}

	vector ompr;
	ompr = getmousepos();	//;
	drawpic(ompr, "gfx/cursor.tga", '20 20 0', '1 1 1', 1, 0);
};
