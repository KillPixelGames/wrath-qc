string profilename;
float profileslot;
float(string filename, float mode) fopen_wrath = { 
local float frikfile;
//	if(!(fexists(filename)))
//		return FALSE;	

	frikfile = fopen(filename, mode);
	if (frikfile > 0)
		return frikfile;
	else
		return FALSE;	
};
void(float fhandle) fclose_wrath = { if (fhandle != -1)
		fclose(fhandle);
}

void() read_currentprofileslot = { local float readparms;
	local string readtext;
	readparms = fopen_wrath("profiles/currentprofileslot.txt", FILE_READ);	
	readtext = fgets(readparms);	
	profileslot = stof(readtext);	
	readtext = fgets(readparms);
	profilename = (readtext);
	profilename = strzone(profilename);
	fclose_wrath(readparms);
};

void(float totalsaves) writeprofilesavedlist = { local float profilenamef;
	local string writethis, profilenamestring;

	profilenamestring = strcat("profiles/", profilename, ".frk");

	profilenamef = fopen_wrath(profilenamestring, FILE_WRITE);	
	writethis = ftos(totalsaves);	
	fputs(profilenamef, writethis);	
	fputs(profilenamef, "\n");	
	fclose_wrath(profilenamef);
};

void(float val) write_tether2 = { read_currentprofileslot();
	local string saveloc;
	saveloc = strcat("profiles/", profilename, "/tetherclient.txt");

	local float writeparms;
	local string writethis;
	writeparms = fopen_wrath(saveloc, FILE_WRITE);	
	writethis = ftos(val);	
	fputs(writeparms, writethis);	
	fputs(writeparms, "\n");	
	fclose_wrath(writeparms);
};
void(float val) write_shrine = { read_currentprofileslot();
	local string saveloc;
	saveloc = strcat("profiles/", profilename, "/shrine.txt");

	local float writeparms;
	local string writethis;
	writeparms = fopen_wrath(saveloc, FILE_WRITE);	
	writethis = ftos(val);	
	fputs(writeparms, writethis);	
	fputs(writeparms, "\n");	
	fclose_wrath(writeparms);
};

void(float val) write_shrine_user = { read_currentprofileslot();
	local string saveloc;
	saveloc = strcat("profiles/", profilename, "/shrine_user.txt");

	local float writeparms;
	local string writethis;
	writeparms = fopen_wrath(saveloc, FILE_WRITE);	
	writethis = ftos(val);	
	fputs(writeparms, writethis);	
	fputs(writeparms, "\n");	
	fclose_wrath(writeparms);
};

void() Kill_Tether = { read_currentprofileslot();
	local string campaignloc;
	campaignloc = strcat("profiles/", profilename, "/tether.txt");

	local float writeparms;
	local string writethis;
	writeparms = fopen_wrath(campaignloc, FILE_WRITE);	
	writethis = ftos(0);	
	fputs(writeparms, writethis);	
	fputs(writeparms, "\n");	
	fclose_wrath(writeparms);
	if (profilename)
		strunzone(profilename);
};

void() remove_save_maps = { 
	read_currentprofileslot();
	local string hub1map, e1m1map, e1m2map,e1m3map, e1m4map, e1m5map;
	hub1map = strcat("data/profiles/", profilename, "/maps/hub1.sav");
	e1m1map = strcat("data/profiles/", profilename, "/maps/e1m1.sav");
	e1m2map = strcat("data/profiles/", profilename, "/maps/e1m2.sav");
	e1m3map = strcat("data/profiles/", profilename, "/maps/e1m3.sav");
	e1m4map = strcat("data/profiles/", profilename, "/maps/e1m4.sav");
	e1m5map = strcat("data/profiles/", profilename, "/maps/e1m5.sav");
	if (fexists(hub1map))
		fremove(hub1map);
	if (fexists(e1m1map))
		fremove(e1m1map);
	if (fexists(e1m2map))
		fremove(e1m2map);
	if (fexists(e1m3map))
		fremove(e1m3map);
	if (fexists(e1m4map))
		fremove(e1m4map);
	if (fexists(e1m5map))
		fremove(e1m5map);
		
	local string hub1stat, e1m1stat, e1m2stat, e1m3stat, e1m4stat, e1m5stat;
	hub1stat = strcat("data/profiles/", profilename, "/maps/hub1.stats");
	e1m1stat = strcat("data/profiles/", profilename, "/maps/e1m1.stats");
	e1m2stat = strcat("data/profiles/", profilename, "/maps/e1m2.stats");
	e1m3stat = strcat("data/profiles/", profilename, "/maps/e1m3.stats");
	e1m4stat = strcat("data/profiles/", profilename, "/maps/e1m4.stats");
	e1m5stat = strcat("data/profiles/", profilename, "/maps/e1m5.stats");
	if (fexists(hub1stat))
		fremove(hub1stat);
	if (fexists(e1m1stat))
		fremove(e1m1stat);
	if (fexists(e1m2stat))
		fremove(e1m2stat);
	if (fexists(e1m3stat))
		fremove(e1m3stat);
	if (fexists(e1m4stat))
		fremove(e1m4stat);
	if (fexists(e1m5stat))
		fremove(e1m5stat);
		
	//episode 2

	local string hub2map, e2m1map, e2m2map,e2m3map, e2m4map, e2m5map;
	hub2map = strcat("data/profiles/", profilename, "/maps/hub2.sav");
	e2m1map = strcat("data/profiles/", profilename, "/maps/e2m1.sav");
	e2m2map = strcat("data/profiles/", profilename, "/maps/e2m2.sav");
	e2m3map = strcat("data/profiles/", profilename, "/maps/e2m3.sav");
	e2m4map = strcat("data/profiles/", profilename, "/maps/e2m4.sav");
	e2m5map = strcat("data/profiles/", profilename, "/maps/e2m5.sav");
	if (fexists(hub2map))
		fremove(hub2map);
	if (fexists(e2m1map))
		fremove(e2m1map);
	if (fexists(e2m2map))
		fremove(e2m2map);
	if (fexists(e2m3map))
		fremove(e2m3map);
	if (fexists(e2m4map))
		fremove(e2m4map);
	if (fexists(e2m5map))
		fremove(e2m5map);
		
	local string hub2stat, e2m1stat, e2m2stat, e2m3stat, e2m4stat, e2m5stat;
	hub2stat = strcat("data/profiles/", profilename, "/maps/hub2.stats");
	e2m1stat = strcat("data/profiles/", profilename, "/maps/e2m1.stats");
	e2m2stat = strcat("data/profiles/", profilename, "/maps/e2m2.stats");
	e2m3stat = strcat("data/profiles/", profilename, "/maps/e2m3.stats");
	e2m4stat = strcat("data/profiles/", profilename, "/maps/e2m4.stats");
	e2m5stat = strcat("data/profiles/", profilename, "/maps/e2m5.stats");
	if (fexists(hub2stat))
		fremove(hub2stat);
	if (fexists(e2m1stat))
		fremove(e2m1stat);
	if (fexists(e2m2stat))
		fremove(e2m2stat);
	if (fexists(e2m3stat))
		fremove(e2m3stat);
	if (fexists(e2m4stat))
		fremove(e2m4stat);
	if (fexists(e2m5stat))
		fremove(e2m5stat);
		
	local string hub3map, e3m1map, e3m2map,e3m3map, e3m4map, e3m5map;
	hub3map = strcat("data/profiles/", profilename, "/maps/hub3.sav");
	e3m1map = strcat("data/profiles/", profilename, "/maps/e3m1.sav");
	e3m2map = strcat("data/profiles/", profilename, "/maps/e3m2.sav");
	e3m3map = strcat("data/profiles/", profilename, "/maps/e3m3.sav");
	e3m4map = strcat("data/profiles/", profilename, "/maps/e3m4.sav");
	e3m5map = strcat("data/profiles/", profilename, "/maps/e3m5.sav");
	if (fexists(hub3map))
		fremove(hub3map);
	if (fexists(e3m1map))
		fremove(e3m1map);
	if (fexists(e3m2map))
		fremove(e3m2map);
	if (fexists(e3m3map))
		fremove(e3m3map);
	if (fexists(e3m4map))
		fremove(e3m4map);
	if (fexists(e3m5map))
		fremove(e3m5map);
		
	local string hub3stat, e3m1stat, e3m2stat, e3m3stat, e3m4stat, e3m5stat;
	hub3stat = strcat("data/profiles/", profilename, "/maps/hub3.stats");
	e3m1stat = strcat("data/profiles/", profilename, "/maps/e3m1.stats");
	e3m2stat = strcat("data/profiles/", profilename, "/maps/e3m2.stats");
	e3m3stat = strcat("data/profiles/", profilename, "/maps/e3m3.stats");
	e3m4stat = strcat("data/profiles/", profilename, "/maps/e3m4.stats");
	e3m5stat = strcat("data/profiles/", profilename, "/maps/e3m5.stats");
	if (fexists(hub3stat))
		fremove(hub3stat);
	if (fexists(e3m1stat))
		fremove(e3m1stat);
	if (fexists(e3m2stat))
		fremove(e3m2stat);
	if (fexists(e3m3stat))
		fremove(e3m3stat);
	if (fexists(e3m4stat))
		fremove(e3m4stat);
	if (fexists(e3m5stat))
		fremove(e3m5stat);
};
void(string filefrom, string fileto)fcopy_wrath =
{

if(fexists(strcat ("data/",filefrom)))
fcopy (filefrom, fileto);
};
void(float istether) copy_save_maps = { 
	read_currentprofileslot();
	string hub1map, e1m1map, e1m2map, e1m3map, e1m4map, e1m5map;
	string tohub1map, toe1m1map, toe1m2map, toe1m3map, toe1m4map, toe1m5map;
	hub1map = strcat("profiles/", profilename, "/maps/hub1.sav");
	e1m1map = strcat("profiles/", profilename, "/maps/e1m1.sav");
	e1m2map = strcat("profiles/", profilename, "/maps/e1m2.sav");
	e1m3map = strcat("profiles/", profilename, "/maps/e1m3.sav");
	e1m4map = strcat("profiles/", profilename, "/maps/e1m4.sav");
	e1m5map = strcat("profiles/", profilename, "/maps/e1m5.sav");

	if (istether == 2)
	{
		tohub1map = strcat("profiles/", profilename, "/autosave/maps/hub1.sav");
		toe1m1map = strcat("profiles/", profilename, "/autosave/maps/e1m1.sav");
		toe1m2map = strcat("profiles/", profilename, "/autosave/maps/e1m2.sav");
		toe1m3map = strcat("profiles/", profilename, "/autosave/maps/e1m3.sav");
		toe1m4map = strcat("profiles/", profilename, "/autosave/maps/e1m4.sav");
		toe1m5map = strcat("profiles/", profilename, "/autosave/maps/e1m5.sav");
	}

	if (istether == 1)
	{
		tohub1map = strcat("profiles/", profilename, "/tether/maps/hub1.sav");
		toe1m1map = strcat("profiles/", profilename, "/tether/maps/e1m1.sav");
		toe1m2map = strcat("profiles/", profilename, "/tether/maps/e1m2.sav");
		toe1m3map = strcat("profiles/", profilename, "/tether/maps/e1m3.sav");
		toe1m4map = strcat("profiles/", profilename, "/tether/maps/e1m4.sav");
		toe1m5map = strcat("profiles/", profilename, "/tether/maps/e1m5.sav");
	}

	if (istether == 0)
	{
		tohub1map = strcat("profiles/", profilename, "/shrine/maps/hub1.sav");
		toe1m1map = strcat("profiles/", profilename, "/shrine/maps/e1m1.sav");
		toe1m2map = strcat("profiles/", profilename, "/shrine/maps/e1m2.sav");
		toe1m3map = strcat("profiles/", profilename, "/shrine/maps/e1m3.sav");
		toe1m4map = strcat("profiles/", profilename, "/shrine/maps/e1m4.sav");
		toe1m5map = strcat("profiles/", profilename, "/shrine/maps/e1m5.sav");
	}

	fcopy_wrath (hub1map, tohub1map);
	fcopy_wrath (e1m1map, toe1m1map);
	fcopy_wrath (e1m2map, toe1m2map);
	fcopy_wrath (e1m3map, toe1m3map);
	fcopy_wrath (e1m4map, toe1m4map);
	fcopy_wrath (e1m5map, toe1m5map);

	string hub1stat, e1m1stat, e1m2stat, e1m3stat, e1m4stat, e1m5stat;
	string tohub1stat, toe1m1stat, toe1m2stat, toe1m3stat, toe1m4stat, toe1m5stat;
	hub1stat = strcat("profiles/", profilename, "/maps/hub1.stats");
	e1m1stat = strcat("profiles/", profilename, "/maps/e1m1.stats");
	e1m2stat = strcat("profiles/", profilename, "/maps/e1m2.stats");
	e1m3stat = strcat("profiles/", profilename, "/maps/e1m3.stats");
	e1m4stat = strcat("profiles/", profilename, "/maps/e1m4.stats");
	e1m5stat = strcat("profiles/", profilename, "/maps/e1m5.stats");

	if (istether == 2)
	{
		tohub1stat = strcat("profiles/", profilename, "/autosave/maps/hub1.stats");
		toe1m1stat = strcat("profiles/", profilename, "/autosave/maps/e1m1.stats");
		toe1m2stat = strcat("profiles/", profilename, "/autosave/maps/e1m2.stats");
		toe1m3stat = strcat("profiles/", profilename, "/autosave/maps/e1m3.stats");
		toe1m4stat = strcat("profiles/", profilename, "/autosave/maps/e1m4.stats");
		toe1m5stat = strcat("profiles/", profilename, "/autosave/maps/e1m5.stats");
	}

	if (istether == 1)
	{
		tohub1stat = strcat("profiles/", profilename, "/tether/maps/hub1.stats");
		toe1m1stat = strcat("profiles/", profilename, "/tether/maps/e1m1.stats");
		toe1m2stat = strcat("profiles/", profilename, "/tether/maps/e1m2.stats");
		toe1m3stat = strcat("profiles/", profilename, "/tether/maps/e1m3.stats");
		toe1m4stat = strcat("profiles/", profilename, "/tether/maps/e1m4.stats");
		toe1m5stat = strcat("profiles/", profilename, "/tether/maps/e1m5.stats");
	}

	if (istether == 0)
	{
		tohub1stat = strcat("profiles/", profilename, "/shrine/maps/hub1.stats");
		toe1m1stat = strcat("profiles/", profilename, "/shrine/maps/e1m1.stats");
		toe1m2stat = strcat("profiles/", profilename, "/shrine/maps/e1m2.stats");
		toe1m3stat = strcat("profiles/", profilename, "/shrine/maps/e1m3.stats");
		toe1m4stat = strcat("profiles/", profilename, "/shrine/maps/e1m4.stats");
		toe1m5stat = strcat("profiles/", profilename, "/shrine/maps/e1m5.stats");
	}

	fcopy_wrath (hub1stat, tohub1stat);
	fcopy_wrath (e1m1stat, toe1m1stat);
	fcopy_wrath (e1m2stat, toe1m2stat);
	fcopy_wrath (e1m3stat, toe1m3stat);
	fcopy_wrath (e1m4stat, toe1m4stat);
	fcopy_wrath (e1m5stat, toe1m5stat);

	string hub2map, e2m1map, e2m2map, e2m3map, e2m4map, e2m5map;
	string tohub2map, toe2m1map, toe2m2map, toe2m3map, toe2m4map, toe2m5map;
	hub2map = strcat("profiles/", profilename, "/maps/hub2.sav");
	e2m1map = strcat("profiles/", profilename, "/maps/e2m1.sav");
	e2m2map = strcat("profiles/", profilename, "/maps/e2m2.sav");
	e2m3map = strcat("profiles/", profilename, "/maps/e2m3.sav");
	e2m4map = strcat("profiles/", profilename, "/maps/e2m4.sav");
	e2m5map = strcat("profiles/", profilename, "/maps/e2m5.sav");

	if (istether == 2)
	{
		tohub2map = strcat("profiles/", profilename, "/autosave/maps/hub2.sav");
		toe2m1map = strcat("profiles/", profilename, "/autosave/maps/e2m1.sav");
		toe2m2map = strcat("profiles/", profilename, "/autosave/maps/e2m2.sav");
		toe2m3map = strcat("profiles/", profilename, "/autosave/maps/e2m3.sav");
		toe2m4map = strcat("profiles/", profilename, "/autosave/maps/e2m4.sav");
		toe2m5map = strcat("profiles/", profilename, "/autosave/maps/e2m5.sav");
	}

	if (istether == 1)
	{
		tohub2map = strcat("profiles/", profilename, "/tether/maps/hub2.sav");
		toe2m1map = strcat("profiles/", profilename, "/tether/maps/e2m1.sav");
		toe2m2map = strcat("profiles/", profilename, "/tether/maps/e2m2.sav");
		toe2m3map = strcat("profiles/", profilename, "/tether/maps/e2m3.sav");
		toe2m4map = strcat("profiles/", profilename, "/tether/maps/e2m4.sav");
		toe2m5map = strcat("profiles/", profilename, "/tether/maps/e2m5.sav");
	}

	if (istether == 0)
	{
		tohub2map = strcat("profiles/", profilename, "/shrine/maps/hub2.sav");
		toe2m1map = strcat("profiles/", profilename, "/shrine/maps/e2m1.sav");
		toe2m2map = strcat("profiles/", profilename, "/shrine/maps/e2m2.sav");
		toe2m3map = strcat("profiles/", profilename, "/shrine/maps/e2m3.sav");
		toe2m4map = strcat("profiles/", profilename, "/shrine/maps/e2m4.sav");
		toe2m5map = strcat("profiles/", profilename, "/shrine/maps/e2m5.sav");
	}

	fcopy_wrath (hub2map, tohub2map);
	fcopy_wrath (e2m1map, toe2m1map);
	fcopy_wrath (e2m2map, toe2m2map);
	fcopy_wrath (e2m3map, toe2m3map);
	fcopy_wrath (e2m4map, toe2m4map);
	fcopy_wrath (e2m5map, toe2m5map);

	string hub2stat, e2m1stat, e2m2stat, e2m3stat, e2m4stat, e2m5stat;
	string tohub2stat, toe2m1stat, toe2m2stat, toe2m3stat, toe2m4stat, toe2m5stat;
	hub2stat = strcat("profiles/", profilename, "/maps/hub2.stats");
	e2m1stat = strcat("profiles/", profilename, "/maps/e2m1.stats");
	e2m2stat = strcat("profiles/", profilename, "/maps/e2m2.stats");
	e2m3stat = strcat("profiles/", profilename, "/maps/e2m3.stats");
	e2m4stat = strcat("profiles/", profilename, "/maps/e2m4.stats");
	e2m5stat = strcat("profiles/", profilename, "/maps/e2m5.stats");

	if (istether == 2)
	{
		tohub2stat = strcat("profiles/", profilename, "/autosave/maps/hub2.stats");
		toe2m1stat = strcat("profiles/", profilename, "/autosave/maps/e2m1.stats");
		toe2m2stat = strcat("profiles/", profilename, "/autosave/maps/e2m2.stats");
		toe2m3stat = strcat("profiles/", profilename, "/autosave/maps/e2m3.stats");
		toe2m4stat = strcat("profiles/", profilename, "/autosave/maps/e2m4.stats");
		toe2m5stat = strcat("profiles/", profilename, "/autosave/maps/e2m5.stats");
	}

	if (istether == 1)
	{
		tohub2stat = strcat("profiles/", profilename, "/tether/maps/hub2.stats");
		toe2m1stat = strcat("profiles/", profilename, "/tether/maps/e2m1.stats");
		toe2m2stat = strcat("profiles/", profilename, "/tether/maps/e2m2.stats");
		toe2m3stat = strcat("profiles/", profilename, "/tether/maps/e2m3.stats");
		toe2m4stat = strcat("profiles/", profilename, "/tether/maps/e2m4.stats");
		toe2m5stat = strcat("profiles/", profilename, "/tether/maps/e2m5.stats");
	}

	if (istether == 0)
	{
		tohub2stat = strcat("profiles/", profilename, "/shrine/maps/hub2.stats");
		toe2m1stat = strcat("profiles/", profilename, "/shrine/maps/e2m1.stats");
		toe2m2stat = strcat("profiles/", profilename, "/shrine/maps/e2m2.stats");
		toe2m3stat = strcat("profiles/", profilename, "/shrine/maps/e2m3.stats");
		toe2m4stat = strcat("profiles/", profilename, "/shrine/maps/e2m4.stats");
		toe2m5stat = strcat("profiles/", profilename, "/shrine/maps/e2m5.stats");
	}

	fcopy_wrath (hub2stat, tohub2stat);
	fcopy_wrath (e2m1stat, toe2m1stat);
	fcopy_wrath (e2m2stat, toe2m2stat);
	fcopy_wrath (e2m3stat, toe2m3stat);
	fcopy_wrath (e2m4stat, toe2m4stat);
	fcopy_wrath (e2m5stat, toe2m5stat);
		
	string hub3map, e3m1map, e3m2map, e3m3map, e3m4map, e3m5map;
	string tohub3map, toe3m1map, toe3m2map, toe3m3map, toe3m4map, toe3m5map;
	hub3map = strcat("profiles/", profilename, "/maps/hub3.sav");
	e3m1map = strcat("profiles/", profilename, "/maps/e3m1.sav");
	e3m2map = strcat("profiles/", profilename, "/maps/e3m2.sav");
	e3m3map = strcat("profiles/", profilename, "/maps/e3m3.sav");
	e3m4map = strcat("profiles/", profilename, "/maps/e3m4.sav");
	e3m5map = strcat("profiles/", profilename, "/maps/e3m5.sav");

	if (istether == 2)
	{
		tohub3map = strcat("profiles/", profilename, "/autosave/maps/hub3.sav");
		toe3m1map = strcat("profiles/", profilename, "/autosave/maps/e3m1.sav");
		toe3m2map = strcat("profiles/", profilename, "/autosave/maps/e3m2.sav");
		toe3m3map = strcat("profiles/", profilename, "/autosave/maps/e3m3.sav");
		toe3m4map = strcat("profiles/", profilename, "/autosave/maps/e3m4.sav");
		toe3m5map = strcat("profiles/", profilename, "/autosave/maps/e3m5.sav");
	}

	if (istether == 1)
	{
		tohub3map = strcat("profiles/", profilename, "/tether/maps/hub3.sav");
		toe3m1map = strcat("profiles/", profilename, "/tether/maps/e3m1.sav");
		toe3m2map = strcat("profiles/", profilename, "/tether/maps/e3m2.sav");
		toe3m3map = strcat("profiles/", profilename, "/tether/maps/e3m3.sav");
		toe3m4map = strcat("profiles/", profilename, "/tether/maps/e3m4.sav");
		toe3m5map = strcat("profiles/", profilename, "/tether/maps/e3m5.sav");
	}

	if (istether == 0)
	{
		tohub3map = strcat("profiles/", profilename, "/shrine/maps/hub3.sav");
		toe3m1map = strcat("profiles/", profilename, "/shrine/maps/e3m1.sav");
		toe3m2map = strcat("profiles/", profilename, "/shrine/maps/e3m2.sav");
		toe3m3map = strcat("profiles/", profilename, "/shrine/maps/e3m3.sav");
		toe3m4map = strcat("profiles/", profilename, "/shrine/maps/e3m4.sav");
		toe3m5map = strcat("profiles/", profilename, "/shrine/maps/e3m5.sav");
	}

	fcopy_wrath (hub3map, tohub3map);
	fcopy_wrath (e3m1map, toe3m1map);
	fcopy_wrath (e3m2map, toe3m2map);
	fcopy_wrath (e3m3map, toe3m3map);
	fcopy_wrath (e3m4map, toe3m4map);
	fcopy_wrath (e3m5map, toe3m5map);

	string hub3stat, e3m1stat, e3m2stat, e3m3stat, e3m4stat, e3m5stat;
	string tohub3stat, toe3m1stat, toe3m2stat, toe3m3stat, toe3m4stat, toe3m5stat;
	hub3stat = strcat("profiles/", profilename, "/maps/hub3.stats");
	e3m1stat = strcat("profiles/", profilename, "/maps/e3m1.stats");
	e3m2stat = strcat("profiles/", profilename, "/maps/e3m2.stats");
	e3m3stat = strcat("profiles/", profilename, "/maps/e3m3.stats");
	e3m4stat = strcat("profiles/", profilename, "/maps/e3m4.stats");
	e3m5stat = strcat("profiles/", profilename, "/maps/e3m5.stats");

	if (istether == 2)
	{
		tohub3stat = strcat("profiles/", profilename, "/autosave/maps/hub3.stats");
		toe3m1stat = strcat("profiles/", profilename, "/autosave/maps/e3m1.stats");
		toe3m2stat = strcat("profiles/", profilename, "/autosave/maps/e3m2.stats");
		toe3m3stat = strcat("profiles/", profilename, "/autosave/maps/e3m3.stats");
		toe3m4stat = strcat("profiles/", profilename, "/autosave/maps/e3m4.stats");
		toe3m5stat = strcat("profiles/", profilename, "/autosave/maps/e3m5.stats");
	}

	if (istether == 1)
	{
		tohub3stat = strcat("profiles/", profilename, "/tether/maps/hub3.stats");
		toe3m1stat = strcat("profiles/", profilename, "/tether/maps/e3m1.stats");
		toe3m2stat = strcat("profiles/", profilename, "/tether/maps/e3m2.stats");
		toe3m3stat = strcat("profiles/", profilename, "/tether/maps/e3m3.stats");
		toe3m4stat = strcat("profiles/", profilename, "/tether/maps/e3m4.stats");
		toe3m5stat = strcat("profiles/", profilename, "/tether/maps/e3m5.stats");
	}

	if (istether == 0)
	{
		tohub3stat = strcat("profiles/", profilename, "/shrine/maps/hub3.stats");
		toe3m1stat = strcat("profiles/", profilename, "/shrine/maps/e3m1.stats");
		toe3m2stat = strcat("profiles/", profilename, "/shrine/maps/e3m2.stats");
		toe3m3stat = strcat("profiles/", profilename, "/shrine/maps/e3m3.stats");
		toe3m4stat = strcat("profiles/", profilename, "/shrine/maps/e3m4.stats");
		toe3m5stat = strcat("profiles/", profilename, "/shrine/maps/e3m5.stats");
	}

	fcopy_wrath (hub3stat, tohub3stat);
	fcopy_wrath (e3m1stat, toe3m1stat);
	fcopy_wrath (e3m2stat, toe3m2stat);
	fcopy_wrath (e3m3stat, toe3m3stat);
	fcopy_wrath (e3m4stat, toe3m4stat);
	fcopy_wrath (e3m5stat, toe3m5stat);
};

string autosave_date;
string tether_date;
string shrine_date;

void(string local_profilename) checkdates =
{
	local float readparms, localmenuversion;
	local string readtext;
	readparms = fopen_wrath(strcat("profiles/",local_profilename,"/dates.txt"), FILE_READ);
	readtext = fgets(readparms);
	autosave_date = (readtext);
	readtext = fgets(readparms);
	tether_date = (readtext);
	readtext = fgets(readparms);
	shrine_date = (readtext);
	fclose_wrath(readparms);
};

void(float type) writedates = 
{ 	
	read_currentprofileslot();

	checkdates (profilename);

 	local float writeparms;
 	local string writethis;
	writeparms = fopen_wrath(strcat("profiles/", profilename,"/dates.txt"),  FILE_WRITE);
 	writethis = strftime(1,"%Y-%m-%d %H:%M:%S");
	if(type == 1)
		fputs(writeparms, writethis);
	else
		fputs(writeparms, autosave_date);
 	fputs(writeparms, "\n");

	if(type == 2)
		fputs(writeparms, writethis);
	else
		fputs(writeparms, tether_date);
 	fputs(writeparms, "\n");

	if(type == 3)
		fputs(writeparms, writethis);
	else
		fputs(writeparms, shrine_date);
 	fputs(writeparms, "\n");
 	fclose_wrath(writeparms);
	if (profilename)
		strunzone(profilename);
 };

string timestamp_map1;
string timestamp_map2;
string timestamp_map3;


void(string local_profilename) get_timestamp_map = 
{

	local float readparms;
	local string readtext;
	readparms = fopen_wrath(strcat("profiles/",local_profilename,"/timestamp.txt"), FILE_READ);
	readtext = fgets(readparms);
	timestamp_map1= (readtext);
	readtext = fgets(readparms);
	timestamp_map2 = (readtext);
	readtext = fgets(readparms);
	timestamp_map3= (readtext);
	fclose_wrath(readparms);
};



