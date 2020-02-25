void(float index, float type, .string value) SV_AddStatString = #232;

void(float index, float type, .float value) SV_AddStatFloat = #232;


// Entity Sending

.float() SendEntity;
.float SendFlags ;
.float Version;


.float item_cnt;
.float wrath_debug_screen;
.float enhealth;
.float enframe;
.float timels;
.float msg;
.float lf;

.entity vweapon;
.float vweaponstate;
.float crosshairflag;
.float tetherhasmodel;

.float pulseicons;
.float deadmenuflag;
.float wlightning;
.vector ltdest;
.vector lorigin;
.float artifacttime;
.float tethertime;
.float tether_global_time;

.float damagescreen;
.float shrine;
.float relics;
.float oldrelics;
.float slot_keys;
.float slot_relics;
.float spotted_maps;
.float time_hudmessage;
.float stat_time_hudmessage;


.float foundedrelics;


float EF_NOPVSCULL 				= 8192;

float AS_STRING = 1;
float AS_FLOAT_TRUNCATED = 2;
float AS_FLOAT = 8;

float MSG_ENTITY = 5;

float ENT_HUDMSG = 1;
float ENT_HMMSG = 2;
float ENT_HUDMSG2 = 3;
//float ENT_ARTIFACT 				= 4;  

const float STAT_RMENU = 34;
const float STAT_LF = 35;
const float STAT_X = 36;
const float STAT_Y = 37;
const float STAT_Z = 38;
const float STAT_AMMO_FLAMETHROWER = 39;
const float STAT_AMMO_COACHGUN = 40;
const float STAT_AMMO_CANNON = 41;
const float STAT_AMMO_BOMBS = 42;
const float STAT_AMMO_SHOTGUN = 43;
const float STAT_RD_ST = 44;
const float STAT_RD_LS = 45;
const float STAT_RD_TR = 46;
const float STAT_RD_AE = 47;
const float STAT_RD_DA = 48;
const float STAT_ARTIFACTTIME = 49;
const float STAT_RADIALACTIVE = 50;
const float STAT_WRATHDEBUGSCREEN = 51;
const float STAT_VWEAPONFRAME = 52;
const float STAT_ENHEALTH = 53;
const float STAT_ENFRAME = 54;
const float STAT_TIMEFLY = 55;
const float STAT_TIMELS = 56;
const float STAT_THWOFG = 57;
const float STAT_LOX = 60;
const float STAT_LOY = 61;
const float STAT_LOZ = 62;
const float STAT_LODX = 63;
const float STAT_LODY = 64;
const float STAT_LODZ = 65;
const float STAT_LDX = 66;
const float STAT_LDY = 67;
const float STAT_LDZ = 68;
const float STAT_WLIGHTNING = 69;
const float STAT_JOURNAL = 70;
const float STAT_JOURNAL_MESSAGES = 71;
const float STAT_NORMAL_MESSAGES = 72;
const float STAT_VWEAPONSTATE = 74;
const float STAT_LASTWEAPON = 75;
const float STAT_PULSEICON = 76;
const float STAT_DEADMENU = 77;
const float STAT_DAMAGESCREEN = 78;
const float STAT_CROSSHAIR = 79;
const float STAT_SHRINE = 80;
const float STAT_TETHER = 81;	// fix that, use shrine stat instead
const float STAT_RELICS = 82;	// 
const float STAT_SLOT_KEYS = 83;	// 
const float STAT_SLOT_RELICS = 84;	// 
const float STAT_TIME_HUDMESSAGE = 85;	// 
const float STAT_JOURNAL_MESSAGESM = 86;
const float STAT_SPOTTED_MAPS = 87;
const float STAT_USED_RELICS = 88;
const float STAT_FOUND_RELICS = 89;
const float STAT_TETHERTIME = 90;


const float STAT_DARM = 93;
const float STAT_RARM = 94;

float IT_COACHGUN = 1;
float IT_SHOTGUN = 2;
float IT_SPITTER = 4;
float IT_RETCHER = 8;
float IT_CANNON = 16;
float IT_MELEE = 32;
float IT_ROCKET_LAUNCHER = 64;
float IT_EXTRA_WEAPON = 128;
float IT_VIEWMODEL = 512;
float IT_ROCKETS = 1024;
float IT_CELLS = 2048;
float IT_CANNON2 = 4096;
float IT_ARMOR1 = 8192;
float IT_ARMOR2 = 16384;
float IT_ARMOR3 = 32768;
float IT_SUPERHEALTH = 65536;
float IT_KEY1 = 131072;
float IT_KEY2 = 262144;
float IT_KEY3 = 256;
float IT_KEY4 = 65536;
float IT_SUIT = 2097152;
float IT_QUAD = 4194304;

float RL_E1M1 = 1;
float RL_E1M2 = 2;
float RL_E1M3 = 4;
float RL_E1M4 = 8;
float RL_E1M5 = 16;

float SLOT_ARMOR1 = 1;
float SLOT_ARMOR2 = 2;
float SLOT_ARMOR3 = 4;
float SLOT_ARMOR4 = 8;
float SLOT_ARMOR5 = 16;
float SLOT_ARMOR6 = 32;
float SLOT_ARMOR7 = 64;
float SLOT_ARMOR8 = 128;
float SLOT_ARMOR9 = 256;
float SLOT_ARMOR10 = 512;

#define FULLSEND 0xffffff

float SVC_SETVIEW = 5;
float SVC_SETVIEWANGLES = 10;

.float journal_jmessages;
float JM_A = 1;
float JM_B = 2;
float JM_C = 4;
float JM_D = 8;
float JM_E = 16;
float JM_F = 32;
float JM_G = 64;
float JM_H = 128;
float JM_I = 256;
float JM_J = 512;
float JM_K = 1024;
float JM_L = 2048;
float JM_M = 4096;
float JM_N = 8192;
float JM_O = 16384;
float JM_P = 32768;
float JM_Q = 65536;
float JM_R = 131072;
float JM_S = 262144;
float JM_T = 1048576;
float JM_U = 2097152;
float JM_V = 4194304;
float JM_W = 8388608;

.float journal_jmessagesm;
/*
1 = fallen
2 = wraith
3 = afflicted
4 = widow
5 = invader
6 = heretic
7 = executioner
8 = stricken
*/
float JB_A = 1;
float JB_B = 2;
float JB_C = 4;
float JB_D = 8;
float JB_E = 16;
float JB_F = 32;
float JB_G = 64;
float JB_H = 128;
float JB_I = 256;
float JB_J = 512;
float JB_K = 1024;
float JB_L = 2048;
float JB_M = 4096;
float JB_N = 8192;
float JB_O = 16384;
float JB_P = 32768;
float JB_Q = 65536;
float JB_R = 131072;
float JB_S = 262144;
float JB_T = 1048576;
float JB_U = 2097152;
float JB_V = 4194304;
float JB_W = 8388608;

.float explored_maps;
float LE_HUB1 = 1;
float LE_HUB2 = 2;
float LE_E1M1 = 4;
float LE_E1M2 = 8;
float LE_E1M3 = 16;
float LE_E1M4 = 32;
float LE_E1M5 = 64;
float LE_E2M1 = 128;
float LE_E2M2 = 256;
float LE_E2M3 = 512;
float LE_E2M4 = 1024;
float LE_E2M5 = 2048;
float LE_E3M1 = 4096;
float LE_E3M2 = 8192;
float LE_E3M3 = 16384;
float LE_E3M4 = 32768;
float LE_E3M5 = 65536;
float LE_E4M1 = 131072;
float LE_E4M2 = 262144;
float LE_E4M3 = 524288;
float LE_E4M4 = 1048576;
float LE_E4M5 = 2097152;
float LE_HUB3 = 4194304;
float LE_HUB4 = 8388608;

.float centerprint_messages;
/*
1 = first artifact
2 = first time to open inventory
4 =  first soul tether
8 =
16 =
32 = 
64 =
128 =
256 =
512 =
1024 =
2048 =
4096 =
8192 =
16384 =
32768  =
65536 =
131072 = 
262144 =
1048576 =
2097152 =
4194304 =  
8388608 =
*/
float CENTERPRINT_A = 1;
float CENTERPRINT_B = 2;
float CENTERPRINT_C = 4;
float CENTERPRINT_D = 8;
float CENTERPRINT_E = 16;
float CENTERPRINT_F = 32;
float CENTERPRINT_G = 64;
float CENTERPRINT_H = 128;
float CENTERPRINT_I = 256;
float CENTERPRINT_J = 512;
float CENTERPRINT_K = 1024;
float CENTERPRINT_L = 2048;
float CENTERPRINT_M = 4096;
float CENTERPRINT_N = 8192;
float CENTERPRINT_O = 16384;
float CENTERPRINT_P = 32768;
float CENTERPRINT_Q = 65536;
float CENTERPRINT_R = 131072;
float CENTERPRINT_S = 262144;
float CENTERPRINT_T = 1048576;
float CENTERPRINT_U = 2097152;
float CENTERPRINT_V = 4194304;
float CENTERPRINT_W = 8388608;

float SG_MathModulus(float a, float b)
{
	return (a - (floor(a / b) *b));
}

string SG_GetFormattedTimeStringUnZoned(float tTime)
{
	local float nTime;
	nTime = rint(tTime);
	local string strTime;
	local float nMinutes;
	nMinutes = floor(nTime / 60);
	strTime = ftos(nMinutes);
	strTime = strcat(strTime, ":");
	local float nSeconds;
	nSeconds = SG_MathModulus(nTime, 60);
	if (nSeconds < 10)
		strTime = strcat(strTime, "0", ftos(nSeconds));
	else
		strTime = strcat(strTime, ftos(nSeconds));
	return strTime;
}

string(string strtofix) case_fixed = { if (strlen(strtofix) == 1)
		strtofix = strtoupper(strtofix);
	else
	{
		strtofix = strtolower(strtofix);
		string uppercase = substring(strtofix, 0, 1);
		uppercase = strtoupper(uppercase);
		string restoftheword = substring(strtofix, 1, strlen(strtofix));
		strtofix = strcat(uppercase, restoftheword);
	}
	if (strtofix == "Shift")
		strtofix = "Left Shift";
	if (strtofix == "Ctrl")
		strtofix = "Left Control";
	if (strtofix == "Mouse1")
		strtofix = "Left Mouse";
	if (strtofix == "Mouse2")
		strtofix = "Right Mouse";
	if (strtofix == "Mouse3")
		strtofix = "Middle Mouse";
	if (strtofix == "Mwheelup")
		strtofix = "Mouse Wheel Up";
	if (strtofix == "Mwheeldown")
		strtofix = "Mouse Wheel Down";
	strtofix = strcat("[", strtofix, "]");
	return strtofix;
}