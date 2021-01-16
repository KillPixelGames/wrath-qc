.string map;
float CHAN_WEAPON2 = 6;
float CHAN_VOICE2 = 7;
.float wrathflags;
.float startnonsolid;
.float type;



float FL_GARBAGE = 1;
float FL_RESPAWN = 2;
float FL_SWIMMER = 4;
float FL_TOSS = 8;
float FL_SPAWNER = 16;
float FL_GIB = 32;
float FL_BBOX = 64;
float FL_MESSAGE = 128;
float FL_WONGROUND = 256;
float FL_PICKUPABLE = 512;
float FL_STARTNONSOLID = 1024;
float FL_PROJECTILE = 2048;
float FL_SECRET = 4096;


.vector oldangles;
.float nojump;

.entity oldgroundentity;

//void(vector org, float class) blood_decal;	// = 

//.float gravity;
//.float stepheight_delta;	// modifier for stepheight
//
//globals
//
float movedist;
//float	gameover;		//setwhenaruleexits
string string_null;	//nullstring,nothingshouldbeheldhere
entity newmis;	//launch_spikesetsthisafterspawningit
entity activator;	//theentitythatactivatedatriggerorbrush
entity damage_attacker;	//setbyT_Damage
entity single_player;
//float	framecount;
float skill;
.float timelightning1;
.float timelightning2;
.float timelightning3;
.float death_time_sound;
.float deathanim;
.float deathframe;
.float lifetime;
.float time2;
//.float		worldtype;	// 0=medieval 1=metal 2=base

//
//subs
//
.void() think1;
.vector finaldest, finalangle;
.vector rel_origin;	//thisistheoriginasiftheobjecthadnevermovedrelatively

//
//misc
//
.float dmg;
.float style;
.float speed;
.float height;
.float state;
.float pausetime;
.float wait;	//timefromfiringtorestarting
.float delay; .float delay2; .float delay3; .float delay4; .float delay5; .float delay6; .float delay7; .float delay8; 	
.float cnt;	//miscflag
.entity movetarget;
.entity goalentity;
.string killtarget; .string killtarget1; .string killtarget2; .string killtarget3; .string killtarget4; .string killtarget5; .string killtarget6; .string killtarget7; .string killtarget8;  

.vector pos1, pos2;	//topandbottompositions
.vector dest, dest1, dest2;
.vector mangle;	//angleatstart
.float t_length, t_width;
.float count;	// for counting triggers
.float touchtime;
.float using;
.float inactive;
.float rad_sound;	// radius sound;
.float volume;
.string target2; .string target3; .string target4; .string target5; .string target6; .string target7; .string target8;
.string 	death_target;

//
//sprites
//
.vector spriteorg;
.vector oangles;
.float pframe;
.float dframe;
//.float fscale;
.entity msprite;
//.float fake_illumination;
float globalfake_illumination;

//
//player
//
.float super_damage_finished;
.float invincible_finished;
//.float	invisible_finished;
//.float	invincible_time,invincible_sound;
//.float	invisible_time,invisible_sound;
//.float	super_time,super_sound;
//.float	rad_time;
.float fly_sound;
.float super_damage_finished;
.float radsuit_finished;
.float swim_flag;
.float air_finished;	//whentime>air_finished,startdrowning
.string deathtype;
.float crouch;
.float attemptcrouch;
.float maxspeed;
.float timefootstep;
.float luse;
.float roaming;
.float roamingtime;
.float aflag;

.float footstepvol;
.float footstepcrouchvol;

.float healthpulsetime;
.float rhealthpulsetime;	//secondary timing to reset pulse

.float armorpulsetime;
.float rarmorpulsetime;	//secondary timing to reset pulse

.float slugspulsetime;
.float rslugspulsetime;	//secondary timing to reset pulse

.float shellspulsetime;
.float rshellspulsetime;	//secondary timing to reset pulse

.float retcherpulsetime;
.float rretcherpulsetime;	//secondary timing to reset pulse

.float spitterpulsetime;
.float rspitterpulsetime;	//secondary timing to reset pulse

.float armorpulsetime;
.float rarmorpulsetime;	//secondary timing to reset pulse

.float darmorpulsetime;
.float rdarmorpulsetime;	//secondary timing to reset pulse

.float cannonpulsetime;
.float rcannonpulsetime;	//secondary timing to reset pulse

.float lancepulsetime;
.float rlancepulsetime;	//secondary timing to reset pulse
//
//Weapons
//
//.float	ammo;

//.string vweaponmodel;
.float vweaponframe;
.float vgearframe;
.entity vgear;
.entity vbullet;
.entity vbullet2;

.float vgeartime;
.float vgearframetime;
.float vgearfps;
.float vgearrelease;

.float vweaponskin;
.vector vweaponglowmod;

//.float timevweapon;
.float timesound;
.float draw_w;
.float bloody;
//
//items
//

//.float bobitem;
.float rarmorvalue;
.float darmorvalue;


vector artifact_size;
vector dark_helm_size;
vector dark_armor_size;
vector dark_shard_size;
vector helm_size;
vector armor_size;
vector shard_size;
vector coffer_key_size;
vector artifact_nsize;
vector dark_helm_nsize;
vector dark_armor_nsize;
vector dark_shard_nsize;
vector helm_nsize;
vector armor_nsize;
vector shard_nsize;
vector coffer_key_nsize;
vector heart_size;
vector chalice_size;
vector vial_size;
vector beaker_size;
vector resin_size;
vector resinl_size;
vector ore_size;
vector orel_size;
vector explosives_size;
vector explosivesl_size;
vector shells_size;
vector shellsl_size;
vector slag_size;
vector spitter_size;
vector retcher_size;
vector coach_size;
vector slag_nsize;
vector spitter_nsize;
vector retcher_nsize;
vector coach_nsize;
vector retcher_proj_size;
vector shells_size_invader;


//
//player&ai
//
.float pain_finished;
.float show_hostile;	//settotime+0.2wheneveraclientfiresa
//weaponortakesdamage.Usedtoalert
//monstersthatotherwisewouldlettheplayergo

//
//ai
//
.void() th_charge;
.void() th_stand;
.void() th_walk;
.void() th_run;
.void() th_missile;
.void() th_melee;
.void(entity attacker, float damage) th_pain;
.void() th_die;
.entity oldenemy;	//madatthisplayerbeforetakingdamage
.float lefty;
.float search_time;
.float attack_state;
.float attack_finished;
.float waitmin;
//.float waitmax;
float AS_STRAIGHT = 1;
float AS_SLIDING = 2;
float AS_MELEE = 3;
float AS_MISSILE = 4;

.float painsnd;
.float chattersnd;
.float attacksnd;
.float walksnd;
//.float sightsnd;
.float stunned;
.float execution_animation;
.float execution;
.entity execution_enemy;
.float glowmeleetime;
.float execution_enemy_spotted;
.float sight_time;
.float jmpsound;
.string noise1;
.string noise2;
.string noise3;
.float friendly_monster;

//
//func_water
//
.string cshift;
.float fwatershift;
.float fwatershifttime;
.float speed2;
.float zerogtime;
.float drag;
.float oldgravity;
//.float viewalpha;
//.vector viewcolor;
void() CheckFuncWaterDeath;

.vector ldorigin;
.vector ldtdest;

//
//funcs
//
.float usable;
.float lip;
//.string		noise4;
//.entity		trigger_field;	// door's trigger entity
.entity duser;

//
//FRIK FILES
//
.string dvweapon_model;
.float dvweapon_x;
.float dvweapon_y;
.float dvweapon_z;
.float dvweapon_scale;
.vector vweaponangles;

.string vvweapon_model;
.float vvweapon_x;
.float vvweapon_y;
.float vvweapon_z;
.float vvweapon_scale;
.vector vvweaponangles;

.float centered_cgvweapon_x;
.float centered_cgvweapon_y;
.float centered_cgvweapon_z;
.vector centered_cgweaponangles;
.float cgvweapon_x;
.float cgvweapon_y;
.float cgvweapon_z;
.float cgvweapon_scale;
.vector cgweaponangles;

.float svweapon_x;
.float svweapon_y;
.float svweapon_z;
.vector sweaponangles;
.float centered_svweapon_x;
.float centered_svweapon_y;
.float centered_svweapon_z;
.float svweapon_scale;
.vector centered_sweaponangles;

.float pvweapon_x;
.float pvweapon_y;
.float pvweapon_z;
.vector pweaponangles;
.float centered_pvweapon_x;
.float centered_pvweapon_y;
.float centered_pvweapon_z;
.vector centered_pweaponangles;
.float pvweapon_scale;

.float rvweapon_x;
.float rvweapon_y;
.float rvweapon_z;
.vector rweaponangles;
.float centered_rvweapon_x;
.float centered_rvweapon_y;
.float centered_rvweapon_z;
.vector centered_rweaponangles;
.float rvweapon_scale;

.float cvweapon_x;
.float cvweapon_y;
.float cvweapon_z;
.vector cweaponangles;
.float centered_cvweapon_x;
.float centered_cvweapon_y;
.float centered_cvweapon_z;
.vector centered_cweaponangles;
.float cvweapon_scale;

.float coachgun_damage1;
.float coachgun_damage2;
.float coachgun_damage1_mp;
.float coachgun_damage2_mp;
.float coachgun_time1;
.float coachgun_time2;
.float coachgun_spread1;
.float coachgun_spread2;
.string coachgun_model;
.float coachgunclip;
.string coachgun_muzzleflash_model;
.float coachgun_muzzleflash_scale;
.vector coachgun_muzzle_pos1;
.vector coachgun_muzzle_pos2;
.vector coachgun_muzzle_pos3;
.float precoachgunclip;

.float shotgunclip;
.float charge_shotgun;
.float shotgun_damage1;
.float shotgun_damage1_mp;
.float shotgun_time1;
.float shotgun_time2;
.float shotgun_spread1;
.string shotgun_model;
.float buckshot_count;
.float charge_shotgun_count;
.float shotgun_clip;
.float shotgun_proj_speed;
.float shotgun_proj_dmg;
.float shotgun_proj_dmg_mp;
float proj_shotgun_drunkfactorv;
float proj_shotgun_drunkfactorh;
float proj_shotgun_timing;
vector proj_shotgun_bbox;



.float voidbombs_damage1;
.float voidbombs_damage2;
.float voidbombs_time1;
.float voidbombs_time2;
.string voidbombs_model;
//.float voidbombs_wait;

float slagcannon_damage1;
float slagcannon_damage2;
float slagcannon_damage1_mp;
float slagcannon_damage2_mp;
.float slagcannon_time1;
.float slagcannon_time2;
.float holdcannon;
.float holdcannontime;
//.float holdcannonsnd;
.float slagcannonspread;
.float holdslagtime1;
.float holdslagtime2;

vector bboxslag;
vector bboxslag2;

float slagspeed;
float slagspeed2;
float slagsplashradius;
float slagsplashdamage;
float slagsplashdamage_mp;
float slagsplashradius2;
float slagsplashdamage2;
float slagsplashdamage2_mp;
float slagrocketjump;


.float flamethrower_time1;
.float flamethrower_time2;
.string flamethrower_model;


.vector lvweapon;
.vector centered_lvweapon;
.float lvweapon_scale;
.vector lweaponangles;
.vector centered_lweaponangles;
.float lance_damage;
.float lance_damage2;
.float lance_damage_mp;
.float lance_damage2_mp;
.float lance_time;
.float lance_time2;
.float lance_alpha_time;
.float lance_alpha_value;
.float lance_viewzoom;
.float lance_viewzoom_time;
.float lance_viewzoom_rate;

//string cmonster1;
//string cmonster2;
//string cmonster3;
//string cmonster4;
//string cmonster5;
//string cmonster6;
//string cmonster7;
//string cmonster8;

//float cmonster_health;
//float cmonster_melee;
//float cmonster_melee_time;

//float cmonster_missile;
//float cmonster_missile_time;

//float cmonster_missile_type;
//float cmonster_missile_speed;
//float cmonster_missile_ammount;
//float cmonster_missile_movetype;
//float cmonster_missile_effects;

//float cmonster_speed;
//string cmonster_model;
//string cmonster_missile_model;

///radialmenu
.float radial_time;
.float radialactive;
.float rmenu;
.float radialruning;

.float LifeSiphon;
.float LifeSiphon_time;

.float SoulTether;
.float Tether_time;

.float DrownerApp;
.float DrownerApp_time;

.float TrinketofRespite;
float TrinketofRespite_time;

.float Aegis;
.float Aegis_time;

.float Attar;
.float Attar_time;

////coffer 

.float coffer;
.float coffer_ammo;
.float coffer_armor;
.float coffer_artifacts;
.float coffer_health;
//.float coffer_ammo;

.float bfg;

//////weapons
float devscreen;	// On/off for the flashlight
.float flash_flag;	// On/off for the flashlight
.entity flash;	// flash entity
.float use_finished;
.string classentity;

.float oldweaponn;
.float melee_runes;
.float melee_skin;
.float melee_kills;
.float melee_kill_time;
.float melee_kill_uber;
.float melee_charging;
.float warped_time ;
.float lastweapon;

.float fall_state;

.float dmg_h;
.float dmg_t;
.float dmg_f;
.string model2;
.string particleffect;
.string tagorg2;
.float pick_up_time;

.vector lb_org;
.vector lb_org2;
.vector lb_dest;
.vector lb_dest2;
.float lb_active;
/////////////////////////////////

.float lspeedtime;
.float only_damage_monster;
.float journal;
.float time_fade;
.float heavymonster;
.float oldframe;
.vector oldvelocity;
.float nopain;
///////////////////////////////////end of qc file

.float respawnable;
.float damagetopain;
.float classmonster;
.float classmonster1;
.float classmonster2;
.float classmonster3;
.float classmonster4;
.float classmonster5;

.float pathed;
.float pathtime;

.void() olduse;
.void() oldthink;
.void() oldtouch;
.float oldpflags;
.float oldsolid;
.float oldeffects;
.float oldwait;
.float oldcount;
.float olddelay;
.string oldtarget;
.string oldtargetname;

entity obj_entity1;
entity obj_entity2;
entity obj_entity3;
entity obj_entity4;
entity obj_entity5;
entity obj_entity6;
entity obj_entity7;
entity obj_entity8;
entity obj_entity9;
entity obj_entity10;

.float shaked;
.float shake_camera_time; 
.float shake_camera_ammountx;
.float shake_camera_ammounty;
.float shake_camera_delay; 
.float shake_camera_refresh_rate; 

void() objerror_messages =
{
	entity pl = find(world, classname, "player");
	
	if(obj_entity1 != world)	string obj_message1 = strcat ((obj_entity1.classname), " ", vtos (obj_entity1.origin)," no targetname \n", "\n");
	if(obj_entity2 != world)	string obj_message2 = strcat ((obj_entity2.classname), " ", vtos (obj_entity2.origin)," no targetname \n", "\n");
	if(obj_entity3 != world)	string obj_message3 = strcat ((obj_entity3.classname), " ", vtos (obj_entity3.origin)," no targetname \n", "\n");
	if(obj_entity4 != world)	string obj_message4 = strcat ((obj_entity4.classname), " ", vtos (obj_entity4.origin)," no targetname \n", "\n");
	if(obj_entity5 != world)	string obj_message5 = strcat ((obj_entity5.classname), " ", vtos (obj_entity5.origin)," no targetname \n", "\n");
	if(obj_entity6 != world)	string obj_message6 = strcat ((obj_entity6.classname), " ", vtos (obj_entity6.origin)," no targetname \n", "\n");
	if(obj_entity7 != world)	string obj_message7 = strcat ((obj_entity7.classname), " ", vtos (obj_entity7.origin)," no targetname \n", "\n");
	if(obj_entity8 != world)	string obj_message8 = strcat ((obj_entity8.classname), " ", vtos (obj_entity8.origin)," no targetname \n", "\n");
	if(obj_entity9 != world)	string obj_message9 = strcat ((obj_entity9.classname), " ", vtos (obj_entity9.origin)," no targetname \n", "\n");
	if(obj_entity10 != world)	string obj_message10 = strcat ((obj_entity10.classname), " ", vtos (obj_entity10.origin)," no targetname \n");
	
	string obj_messagea = strcat (obj_message1,obj_message2,obj_message3,obj_message4,obj_message5);
	string obj_messageb = strcat (obj_message6,obj_message7,obj_message8,obj_message9,obj_message10);

	string obj_message  = strcat (obj_messagea, obj_messageb);
	//centerprint (pl, obj_message);
	bprint (obj_message1);
	bprint (obj_message2);
	bprint (obj_message3);
	bprint (obj_message4);
	bprint (obj_message5);
	bprint (obj_message6);
	bprint (obj_message7);
	bprint (obj_message8);
	bprint (obj_message9);
	bprint (obj_message10);
};


void() wrath_objerror =
{
	if(obj_entity1 == world)
	{
		obj_entity1 = self;
		self.think = objerror_messages;
		self.nextthink = time + 3;
		return;
	}
	if(obj_entity2 == world)
	{
		obj_entity2 = self;
		return;	
	}
	if(obj_entity3 == world)
	{
		obj_entity3 = self;
		return;	
	}
	if(obj_entity4 == world)
	{
		obj_entity4 = self;
		return;	
	}
	if(obj_entity5 == world)
	{
		obj_entity5 = self;
		return;	
	}
	if(obj_entity6 == world)
	{
		obj_entity6 = self;
		return;	
	}
	if(obj_entity7 == world)
	{
		obj_entity7 = self;
		return;	
	}
	if(obj_entity8 == world)
	{
		obj_entity8 = self;
		return;	
	}
	if(obj_entity9 == world)
	{
		obj_entity9 = self;
		return;	
	}
	if(obj_entity10 == world)
	{
		obj_entity10 = self;
		return;	
	}
};

vector (entity player) cursor_trace_endpos_fixed =
{
	vector t_endpos, org;
	t_endpos = player.cursor_trace_endpos;
	org = player.origin;
	float distance = vlen (org - t_endpos);
	if(distance > 128)
		return t_endpos;
	else
	{
		makevectors(player.v_angle);
		vector t_dest = player.origin + player.view_ofs + v_forward *2048;
		traceline((player.origin + player.view_ofs), t_dest, MOVE_WORLDONLY, player);

		return trace_endpos;
	}
};
vector (entity player) cursor_trace_endpos_forced =
{
	vector org;
	org = player.origin;

		makevectors(player.v_angle);
		vector t_dest = player.origin + player.view_ofs + v_forward *4096;
		traceline((player.origin + player.view_ofs), t_dest, MOVE_WORLDONLY, player);
		return trace_endpos;
};
