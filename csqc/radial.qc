float slotradialselected;
float mm;
float oldslotradialselected;
float rmenualpha;
vector real_radialpos;
vector gomp;

vector(vector pos) relconsizex = 
{
	vector newpos;
	newpos = pos;
	newpos_x -= ((960 - vid_width) *0.5);
	newpos_y += ((540 - vid_height) *0.5);
	return newpos;
};
float(float a) nextslot;
float(float a) prevslot;
float oldmarkerposx;

float firstslot;
float lastslot;

void() fl_slot = 
{
	float slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10;
	slot1 = 0;
	slot2 = getstatf(STAT_RD_DA);
	slot3 = 0;
	slot4 = getstatf(STAT_RD_CA);
	slot5 = 0;
	slot6 = getstatf(STAT_RD_LS);
	slot7 = getstatf(STAT_RD_TR);
	slot8 = getstatf(STAT_RD_AE);
	slot9 = 0;
	slot10 = 0;
	
	

	if (slot1 > 0)
		firstslot = 1;
	else if (slot2 > 0)
		firstslot =  2;
	else if (slot3 > 0)
		firstslot =  3;
	else if (slot4 > 0)
		firstslot =  4;
	else if (slot5 > 0)
		firstslot =  5;
	else if (slot6 > 0)
		firstslot =  6;
	else if (slot7 > 0)
		firstslot =  7;
	else if (slot8 > 0)
		firstslot =  8;
	else if (slot9 > 0)
		firstslot =  9;
	else if (slot10 > 0)
		firstslot =  10;
	else
		firstslot =  0;

	if (slot10 > 0)
		lastslot = 10;
	else if (slot9 > 0)
		lastslot =  9;
	else if (slot8 > 0)
		lastslot =  8;
	else if (slot7 > 0)
		lastslot =  7;
	else if (slot6 > 0)
		lastslot =  6;
	else if (slot5 > 0)
		lastslot =  5;
	else if (slot4 > 0)
		lastslot =  4;
	else if (slot3 > 0)
		lastslot =  3;
	else if (slot2 > 0)
		lastslot =  2;
	else if (slot1 > 0)
		lastslot =  1;
	else
		lastslot =  0;

};

void() slot_icons = 
{
	float slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10;
	vector col1, col2, col3, col4, col5, col6, col7, col8, col9, col10;
	slot1 = 0;
	slot2 = getstatf(STAT_RD_DA);
	slot3 = 0;
	slot4 = getstatf(STAT_RD_CA);
	slot5 = 0;
	slot6 = getstatf(STAT_RD_LS);
	slot7 = getstatf(STAT_RD_TR);
	slot8 = getstatf(STAT_RD_AE);
	slot9 = 0;
	slot10 = 0;
	string ns1, ns2, ns3, ns4, ns5, ns6, ns7, ns8, ns9, ns10;

	vector real_artifactdescpos, real_bigiconpos, marker_pos;

	real_bigiconpos = bigiconpos;
	real_bigiconpos_x = real_bigiconpos_x - ((960 - vid_width) *0.5);
	real_bigiconpos_y = real_bigiconpos_y + ((540 - vid_height) *0.5);
	real_artifactdescpos = artifactdescpos;
	real_artifactdescpos_x = real_artifactdescpos_x - ((960 - vid_width) *0.5);
	real_artifactdescpos_y = real_artifactdescpos_y + ((540 - vid_height) *0.5);

	if (slotradialselected == 1)
	{
		col1 = '1 1 1';
		DImage2(real_artifactdescpos, "gfx/artifactmenu/artifactA_info.tga", 1 *rmenualpha, r_ic, col1, '240 80 0', radialflag);
		DImage2(real_bigiconpos, "gfx/artifactmenu/artifactA_icon_large.tga", 1 *rmenualpha, r_ic, col1, '84 84 0', radialflag);
	}
	else
		col1 = '0.5 0.5 0.5';
	if (slotradialselected == 2)
	{
		col2 = '1 1 1';
		DImage2(real_artifactdescpos, "gfx/artifactmenu/artifactB_info.tga", 1 *rmenualpha, r_ic, col2, '240 80 0', radialflag);
		DImage2(real_bigiconpos, "gfx/artifactmenu/artifactB_icon_large.tga", 1 *rmenualpha, r_ic, col2, '84 84 0', radialflag);
	}
	else
		col2 = '0.5 0.5 0.5';
	if (slotradialselected == 3)
	{
		col3 = '1 1 1';
		DImage2(real_artifactdescpos, "gfx/artifactmenu/artifactC_info.tga", 1 *rmenualpha, r_ic, col3, '240 80 0', radialflag);
		DImage2(real_bigiconpos, "gfx/artifactmenu/artifactC_icon_large.tga", 1 *rmenualpha, r_ic, col3, '84 84 0', radialflag);
	}
	else
		col3 = '0.5 0.5 0.5';
	if (slotradialselected == 4)
	{
		col4 = '1 1 1';
		DImage2(real_artifactdescpos, "gfx/artifactmenu/artifactD_info.tga", 1 *rmenualpha, r_ic, col4, '240 80 0', radialflag);
		DImage2(real_bigiconpos, "gfx/artifactmenu/artifactD_icon_large.tga", 1 *rmenualpha, r_ic, col4, '84 84 0', radialflag);
	}
	else
		col4 = '0.5 0.5 0.5';
	if (slotradialselected == 5)
	{
		col5 = '1 1 1';
		DImage2(real_artifactdescpos, "gfx/artifactmenu/artifactE_info.tga", 1 *rmenualpha, r_ic, col5, '240 80 0', radialflag);
		DImage2(real_bigiconpos, "gfx/artifactmenu/artifactE_icon_large.tga", 1 *rmenualpha, r_ic, col5, '84 84 0', radialflag);
	}
	else
		col5 = '0.5 0.5 0.5';
	if (slotradialselected == 6)
	{
		col6 = '1 1 1';
		DImage2(real_artifactdescpos, "gfx/artifactmenu/artifactF_info.tga", 1 *rmenualpha, r_ic, col6, '240 80 0', radialflag);
		DImage2(real_bigiconpos, "gfx/artifactmenu/artifactF_icon_large.tga", 1 *rmenualpha, r_ic, col6, '84 84 0', radialflag);
	}
	else
		col6 = '0.5 0.5 0.5';
	if (slotradialselected == 7)
	{
		col7 = '1 1 1';
		DImage2(real_artifactdescpos, "gfx/artifactmenu/artifactG_info.tga", 1 *rmenualpha, r_ic, col7, '240 80 0', radialflag);
		DImage2(real_bigiconpos, "gfx/artifactmenu/artifactG_icon_large.tga", 1 *rmenualpha, r_ic, col7, '84 84 0', radialflag);
	}
	else
		col7 = '0.5 0.5 0.5';
	if (slotradialselected == 8)
	{
		col8 = '1 1 1';
		DImage2(real_artifactdescpos, "gfx/artifactmenu/artifactH_info.tga", 1 *rmenualpha, r_ic, col8, '240 80 0', radialflag);
		DImage2(real_bigiconpos, "gfx/artifactmenu/artifactH_icon_large.tga", 1 *rmenualpha, r_ic, col8, '84 84 0', radialflag);
	}
	else
		col8 = '0.5 0.5 0.5';

	col9 = '0.5 0.5 0.5';
	col10 = '0.5 0.5 0.5';
	//col8 = '1 1 1';

	local vector real_r_si1, real_r_si2, real_r_si3, real_r_si4, real_r_si5, real_r_si6, real_r_si7, real_r_si8, real_r_si9, real_r_si10;
	local vector real_r_ic1, real_r_ic2, real_r_ic3, real_r_ic4, real_r_ic5, real_r_ic6, real_r_ic7, real_r_ic8, real_r_ic9, real_r_ic10;

	real_r_si1 = relconsizex(r_si1);
	real_r_si2 = relconsizex(r_si2);
	real_r_si3 = relconsizex(r_si3);
	real_r_si4 = relconsizex(r_si4);
	real_r_si5 = relconsizex(r_si5);
	real_r_si6 = relconsizex(r_si6);
	real_r_si7 = relconsizex(r_si7);
	real_r_si8 = relconsizex(r_si8);
	real_r_si9 = relconsizex(r_si9);
	real_r_si10 = relconsizex(r_si10);
	real_r_ic1 = relconsizex(r_ic1);
	real_r_ic2 = relconsizex(r_ic2);
	real_r_ic3 = relconsizex(r_ic3);
	real_r_ic4 = relconsizex(r_ic4);
	real_r_ic5 = relconsizex(r_ic5);
	real_r_ic6 = relconsizex(r_ic6);
	real_r_ic7 = relconsizex(r_ic7);
	real_r_ic8 = relconsizex(r_ic8);
	real_r_ic9 = relconsizex(r_ic9);
	real_r_ic10 = relconsizex(r_ic10);

	if (slot1 > 0)
	{
		ns1 = strcat("gfx/artifactmenu/artifact_num", ftos(slot1), ".tga");
		DImage2(real_r_si1, ns1, 1 *rmenualpha, r_si, col1, '8 8 0', radialflag);
		DImage2(real_r_ic1, "gfx/artifactmenu/artifactA_icon.tga", 1 *rmenualpha, r_ic, col1, '40 40 0', radialflag);
	}

	if (slot2 > 0)
	{
		ns2 = strcat("gfx/artifactmenu/artifact_num", ftos(slot2), ".tga");
		DImage2(real_r_si2, ns2, 1 *rmenualpha, r_si, col2, '8 8 0', radialflag);
		DImage2(real_r_ic2, "gfx/artifactmenu/artifactB_icon.tga", 1 *rmenualpha, r_ic, col2, '40 40 0', radialflag);
	}

	if (slot3 > 0)
	{
		ns3 = strcat("gfx/artifactmenu/artifact_num", ftos(slot3), ".tga");
		DImage2(real_r_si3, ns3, 1 *rmenualpha, r_si, col3, '8 8 0', radialflag);
		DImage2(real_r_ic3, "gfx/artifactmenu/artifactC_icon.tga", 1 *rmenualpha, r_ic, col3, '40 40 0', radialflag);
	}

	if (slot4 > 0)
	{
		ns4 = strcat("gfx/artifactmenu/artifact_num", ftos(slot4), ".tga");
		DImage2(real_r_si4, ns4, 1 *rmenualpha, r_si, col4, '8 8 0', radialflag);
		DImage2(real_r_ic4, "gfx/artifactmenu/artifactD_icon.tga", 1 *rmenualpha, r_ic, col4, '40 40 0', radialflag);
	}

	if (slot5 > 0)
	{
		ns5 = strcat("gfx/artifactmenu/artifact_num", ftos(slot5), ".tga");
		DImage2(real_r_si5, ns5, 1 *rmenualpha, r_si, col5, '8 8 0', radialflag);
		DImage2(real_r_ic5, "gfx/artifactmenu/artifactE_icon.tga", 1 *rmenualpha, r_ic, col5, '40 40 0', radialflag);
	}

	if (slot6 > 0)
	{
		ns6 = strcat("gfx/artifactmenu/artifact_num", ftos(slot6), ".tga");
		DImage2(real_r_si6, ns6, 1 *rmenualpha, r_si, col6, '8 8 0', radialflag);
		DImage2(real_r_ic6, "gfx/artifactmenu/artifactF_icon.tga", 1 *rmenualpha, r_ic, col6, '40 40 0', radialflag);
	}

	if (slot7 > 0)
	{
		ns7 = strcat("gfx/artifactmenu/artifact_num", ftos(slot7), ".tga");
		DImage2(real_r_si7, ns7, 1 *rmenualpha, r_si, col7, '8 8 0', radialflag);
		DImage2(real_r_ic7, "gfx/artifactmenu/artifactG_icon.tga", 1 *rmenualpha, r_ic, col7, '40 40 0', radialflag);
	}

	if (slot8 > 0)
	{
		ns8 = strcat("gfx/artifactmenu/artifact_num", ftos(slot8), ".tga");
		DImage2(real_r_si8, ns8, 1 *rmenualpha, r_si, col8, '8 8 0', radialflag);
		DImage2(real_r_ic8, "gfx/artifactmenu/artifactH_icon.tga", 1 *rmenualpha, r_ic, col8, '40 40 0', radialflag);
	}

	if (slot9 > 0)
	{
		ns9 = strcat("gfx/artifactmenu/artifact_num", ftos(slot9), ".tga");
		DImage2(real_r_si9, ns9, 1 *rmenualpha, r_si, col9, '8 8 0', radialflag);
		DImage2(real_r_ic9, "gfx/artifactmenu/artifactI_icon.tga", 1 *rmenualpha, r_ic, col9, '40 40 0', radialflag);
	}

	if (slot10 > 0)
	{
		ns10 = strcat("gfx/artifactmenu/artifact_num", ftos(slot10), ".tga");
		DImage2(real_r_si10, ns10, 1 *rmenualpha, r_si, col10, '8 8 0', radialflag);
		DImage2(real_r_ic10, "gfx/artifactmenu/artifactJ_icon.tga", 1 *rmenualpha, r_ic, col10, '40 40 0', radialflag);
	}

	vector relomp, align;
	float ry = (vid_rwidth / vid_rheight);

	align_x = 240;
	align_y = vid_height - 27;
	vector v_ry;
	v_ry_x = 12* ry;
	real_r_ic1 += align- v_ry;
	real_r_ic2 += align- v_ry;
	real_r_ic3 += align- v_ry;
	real_r_ic4 += align- v_ry;
	real_r_ic5 += align- v_ry;
	real_r_ic6 += align- v_ry;
	real_r_ic7 += align- v_ry;
	real_r_ic8 += align- v_ry;
	real_r_ic9 += align- v_ry;
	real_r_ic10 += align- v_ry;


	relomp_x = (gomp_x);
	marker_pos_y = real_radialpos_y - 64;



	fl_slot();
	
	marker_pos_x = relomp_x;
	
	if (firstslot < 6)
	{
		if((firstslot == 1) && (relomp_x <= real_r_ic1_x+ 16 * ry)) 
			marker_pos_x = real_r_ic1_x + 16 * ry;
		if((firstslot == 2) && (relomp_x <= real_r_ic2_x+ 16 * ry))
			marker_pos_x = real_r_ic2_x + 16 * ry;
		if((firstslot == 3) && (relomp_x <= real_r_ic3_x+ 16 * ry)) 
			marker_pos_x = real_r_ic3_x + 16 * ry;
		if((firstslot == 4) && (relomp_x <= real_r_ic4_x+ 16 * ry)) 
			marker_pos_x = real_r_ic4_x + 16 * ry;
		if((firstslot == 5) && (relomp_x <= real_r_ic5_x+ 16 * ry)) 
			marker_pos_x = real_r_ic5_x + 16 * ry;
	}
	else
		if (relomp_x <= real_r_ic5_x + 48 * ry) 
			marker_pos_x = real_r_ic5_x + 48 * ry;
	

	
	if (lastslot > 5)
	{
		if((lastslot == 10) && (relomp_x >= real_r_ic10_x+ 16 * ry)) 
			marker_pos_x = real_r_ic10_x + 16 * ry;
		if((lastslot == 9) && (relomp_x >= real_r_ic9_x+ 16 * ry)) 
			marker_pos_x = real_r_ic9_x + 16 * ry;
		if((lastslot == 8) && (relomp_x >= real_r_ic8_x+ 16 * ry)) 
			marker_pos_x = real_r_ic8_x + 16 * ry;
		if((lastslot == 7) && (relomp_x >= real_r_ic7_x+ 16 * ry))
			marker_pos_x = real_r_ic7_x + 16 * ry;
		if((lastslot == 6) && (relomp_x >= real_r_ic6_x+ 16 * ry)) 
			marker_pos_x = real_r_ic6_x + 16 * ry;
	}
	else
		if (relomp_x >= real_r_ic6_x + 1 * ry) 
			marker_pos_x = real_r_ic6_x + 1 * ry;
	
	
	if(((marker_pos_x >= real_r_ic1_x) && (marker_pos_x <real_r_ic1_x + 50* ry)) && (slot1))
	slotradialselected = 1;
	if(((marker_pos_x >= real_r_ic2_x) && (marker_pos_x <real_r_ic2_x + 50* ry)) && (slot2))
	slotradialselected = 2;
	if(((marker_pos_x >= real_r_ic3_x) && (marker_pos_x <real_r_ic3_x + 50* ry)) && (slot3))
	slotradialselected = 3;
	if(((marker_pos_x >= real_r_ic4_x) && (marker_pos_x <real_r_ic4_x + 50* ry)) && (slot4))
	slotradialselected = 4;
	if(((marker_pos_x >= real_r_ic5_x) && (marker_pos_x <real_r_ic5_x + 50* ry)) && (slot5))
	slotradialselected = 5;
	if(((marker_pos_x >= real_r_ic6_x) && (marker_pos_x <real_r_ic6_x + 50* ry)) && (slot6))
	slotradialselected = 6;
	if(((marker_pos_x >= real_r_ic7_x) && (marker_pos_x <real_r_ic7_x + 50* ry)) && (slot7))
	slotradialselected = 7;
	if(((marker_pos_x >= real_r_ic8_x) && (marker_pos_x <real_r_ic8_x + 50* ry)) && (slot8))
	slotradialselected = 8;
	if(((marker_pos_x >= real_r_ic9_x) && (marker_pos_x <real_r_ic9_x + 50* ry)) && (slot9))
	slotradialselected = 9;
	if(((marker_pos_x >= real_r_ic10_x) && (marker_pos_x <real_r_ic10_x + 50* ry)) && (slot10))
	slotradialselected = 10;
	
		
	if(firstslot)
	DImage2(marker_pos - '240 0 0' , "gfx/artifactmenu/artifact_marker.tga", 1 *rmenualpha, r_ic, '1 1 1', '16 76 0', radialflag2);
//	drawstring(gomp, "X", '20 20 0', '1 1 1', 1, 0);

};


float slot_timer;
float(float cs) nextslot = 
{
	

	mm = 0;
	//restart_cursor();;
	float slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10;
	slot1 = 0;
	slot2 = getstatf(STAT_RD_DA);
	slot3 = 0;
	slot4 = getstatf(STAT_RD_CA);
	slot5 = 0;
	slot6 = getstatf(STAT_RD_LS);
	slot7 = getstatf(STAT_RD_TR);
	slot8 = getstatf(STAT_RD_AE);
	slot9 = 0;
	slot10 = 0;
	if (cs == 1)
	{
		if (slot2 > 0)
			return 2;
		if (slot3 > 0)
			return 3;
		if (slot4 > 0)
			return 4;
		if (slot5 > 0)
			return 5;
		if (slot6 > 0)
			return 6;
		if (slot7 > 0)
			return 7;
		if (slot8 > 0)
			return 8;
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 1;
	}

	if (cs == 2)
	{
		if (slot3 > 0)
			return 3;
		if (slot4 > 0)
			return 4;
		if (slot5 > 0)
			return 5;
		if (slot6 > 0)
			return 6;
		if (slot7 > 0)
			return 7;
		if (slot8 > 0)
			return 8;
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 2;
	}

	if (cs == 3)
	{
		if (slot4 > 0)
			return 4;
		if (slot5 > 0)
			return 5;
		if (slot6 > 0)
			return 6;
		if (slot7 > 0)
			return 7;
		if (slot8 > 0)
			return 8;
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 3;
	}

	if (cs == 4)
	{
		if (slot5 > 0)
			return 5;
		if (slot6 > 0)
			return 6;
		if (slot7 > 0)
			return 7;
		if (slot8 > 0)
			return 8;
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 4;
	}

	if (cs == 5)
	{
		if (slot6 > 0)
			return 6;
		if (slot7 > 0)
			return 7;
		if (slot8 > 0)
			return 8;
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 5;
	}

	if (cs == 6)
	{
		if (slot7 > 0)
			return 7;
		if (slot8 > 0)
			return 8;
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 6;
	}

	if (cs == 7)
	{
		if (slot8 > 0)
			return 8;
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 7;
	}

	if (cs == 8)
	{
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 8;
	}

	if (cs == 9)
	{
		if (slot10 > 0)
			return 10;
		else
			return 9;
	}

	if (cs == 10)
	{
		return 10;
	}

	if (cs == 11)
	{
		if (slot6 > 0)
			return 6;
		if (slot7 > 0)
			return 7;
		if (slot8 > 0)
			return 8;
		if (slot9 > 0)
			return 9;
		if (slot10 > 0)
			return 10;
		else
			return 11;
	}
	else
		return 1;
};

float(float cs) prevslot = 
{
	

	mm = 0;
	//restart_cursor();;
	float slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10;
	slot1 = 0;
	slot2 = getstatf(STAT_RD_DA);
	slot3 = 0;
	slot4 = getstatf(STAT_RD_CA);
	slot5 = 0;
	slot6 = getstatf(STAT_RD_LS);
	slot7 = getstatf(STAT_RD_TR);
	slot8 = getstatf(STAT_RD_AE);
	slot9 = 0;
	slot10 = 0;
	if (cs == 1)
	{
		return 1;
	}

	if (cs == 2)
	{
		if (slot1 > 0)
			return 1;
		else
			return 2;
	}

	if (cs == 3)
	{
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 3;
	}

	if (cs == 4)
	{
		if (slot3 > 0)
			return 3;
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 4;
	}

	if (cs == 5)
	{
		if (slot4 > 0)
			return 4;
		if (slot3 > 0)
			return 3;
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 5;
	}

	if (cs == 6)
	{
		if (slot5 > 0)
			return 5;
		if (slot4 > 0)
			return 4;
		if (slot3 > 0)
			return 3;
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 6;
	}

	if (cs == 7)
	{
		if (slot6 > 0)
			return 6;
		if (slot5 > 0)
			return 5;
		if (slot4 > 0)
			return 4;
		if (slot3 > 0)
			return 3;
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 7;
	}

	if (cs == 8)
	{
		if (slot7 > 0)
			return 7;
		if (slot6 > 0)
			return 6;
		if (slot5 > 0)
			return 5;
		if (slot4 > 0)
			return 4;
		if (slot3 > 0)
			return 3;
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 8;
	}

	if (cs == 9)
	{
		if (slot8 > 0)
			return 8;
		if (slot7 > 0)
			return 7;
		if (slot6 > 0)
			return 6;
		if (slot5 > 0)
			return 5;
		if (slot4 > 0)
			return 4;
		if (slot3 > 0)
			return 3;
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 9;
	}

	if (cs == 10)
	{
		if (slot9 > 0)
			return 9;
		if (slot8 > 0)
			return 8;
		if (slot7 > 0)
			return 7;
		if (slot6 > 0)
			return 6;
		if (slot5 > 0)
			return 5;
		if (slot4 > 0)
			return 4;
		if (slot3 > 0)
			return 3;
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 10;
	}

	if (cs == 11)
	{
		if (slot5 > 0)
			return 5;
		if (slot4 > 0)
			return 4;
		if (slot3 > 0)
			return 3;
		if (slot2 > 0)
			return 2;
		if (slot1 > 0)
			return 1;
		else
			return 11;
	}
	else
		return 1;
};
float deathmatch;

float inventory_active;
void() ArtifactMenu = 
{
	vector vi;
	vi = '220 -400 0';
	//float a1, a2,a3,a4,a5,a6,a7,a8;
	//float s1, s2,s3,s4,s5,s6,s7,s8;
	//vector va1, va2,va3,va4,va5,va6,va7,va8;
	//float itmselected, nslot;
	gomp = getmousepos();	//;

	if (rmenualpha > 0)
	{
		if (!slotradialselected)
		{
			slotradialselected = 11;	//firstslot();
			if (deathmatch != 1)
				localcmd("slowmo 0.1\n");
			localcmd("crosshair 0\n");
			localcmd("scratch3 1\n");

			//localcmd("r_viewscale 0.125\n");
		}

		if (mm == 0)
		{
			setcursormode(1);
			mm = 1;
		}

		drawfill('0 0 0', vid_width *'1 0 0' + vid_height *'0 1 0', '0 0 0', 0.65 *rmenualpha, 0);
		vector omp;
		omp = getmousepos();	//;
		vector relomp;	//, relmp;
		relomp_x = omp_x;
		relomp_y = omp_y;
		//local float rdist;
		float slot1, slot2, slot3, slot4, slot5, slot6, slot7, slot8, slot9, slot10;
		slot1 = 0;
		slot2 = getstatf(STAT_RD_DA);
		slot3 = 0;
		slot4 = getstatf(STAT_RD_CA);
		slot5 = 0;
		slot6 = getstatf(STAT_RD_LS);
		slot7 = getstatf(STAT_RD_TR);
		slot8 = getstatf(STAT_RD_AE);
		slot9 = 0;
		slot10 = 0;

		float art_min_screen_width, art_max_screen_width;	// 400 550 are the values of reference for 960 vid_conwidth, now are fixed 5 units 

		art_min_screen_width = (vid_width / 2) - 75;
		art_max_screen_width = (vid_width / 2) + 75;

		if ((rmenualpha >= 1) && (inventory_active) && (slot_timer <= 0))
		{
			/*if (slotradialselected == 1)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					restart_cursor();

				}
			}
			else if (slotradialselected == 2)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 3)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 4)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					relomp_x = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 5)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 6)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 7)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 8)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 9)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 10)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			else if (slotradialselected == 11)
			{
				if (relomp_x > art_max_screen_width)
				{
					mm = 0;
					slotradialselected = nextslot(slotradialselected);
					restart_cursor();
				}

				if (relomp_x < art_min_screen_width)
				{
					mm = 0;
					slotradialselected = prevslot(slotradialselected);
					restart_cursor();
				}
			}
			*/
		}

		//string pic_radial;
		//pic_radial =strcat ("gfx/radial/slot",ftos(slotradialselected), ".tga");
		//DImage2(radialpos,"gfx/radial/radial_guide",1,radialscale,'1 1 1','176 176 0',radialflag );
		//DImage2(radialpos,pic_radial,1 *rmenualpha,radialscale,'1 1 1','176 176 0',radialflag );

		real_radialpos = radialpos;
		real_radialpos_y = real_radialpos_y + ((540 - vid_height) *0.5);
		real_radialpos_x = real_radialpos_x - ((960 - vid_width) *0.5);

		DImage2(real_radialpos, "gfx/artifactmenu/artifact_menu.tga", 1 *rmenualpha, 1, '1 1 1', '688 144 0', 1);
		//	DImage2(radialpos,"gfx/artifactmenu/artifact_menu.tga",1 *rmenualpha,1,'1 1 1',artsize,1 );
		slot_icons();
		string X;
		X = strcat(ftos(relomp_y - (vid_height /*-27*/)), "  y    and    x    ", (ftos(relomp_x /*- 240*/)), "  ");
		X = "x";
		//drawstring(relomp, X, '8 8 0', '3 3 3', 1);     	// Draw the "cursor"
		oldslotradialselected = slotradialselected;
	}

	//else if (rmenu == 0) 
	if (rmenualpha == 0)
	{
		if ((oldslotradialselected > 0) && (oldslotradialselected < 12))
		{
			local string impulselected;
			impulselected = strcat("impulse ", ftos(20 + slotradialselected), "\n");
			localcmd("slowmo 1\n");
			localcmd("crosshair 2\n");
			localcmd("scratch3 0\n");
			//localcmd("r_viewscale 0.25\n");
			localcmd(impulselected);
			oldslotradialselected = 14;
			slotradialselected = 0;
			mm = 0;
		}

		if (oldslotradialselected >= 14)
		{
			slotradialselected = 0;
			setcursormode(0);
			oldslotradialselected = 0;
		}
	}
};

