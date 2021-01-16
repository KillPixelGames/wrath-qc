float menuversion = 1.285;
void check_keys(float a, float b);
void m_hide();
float Menu_Active;
float selected_option;

float time;
float vid_x;
float vid_y;
float vid_rx;
float vid_ry;
float menutype;

float coronaoclussion;
float volm;

float senm;

float acel;
float macel;

float mvol;
float bgmvol;
float brightlev;
float gammalev;
float contlev;
float fovlev;
float gkcommand;

float effvol;

float draggable_select;
float olddraggable_select;
vector draggable_select_vector;

float fscselected;
float versync;
float antial;

float profileslot;
float keybind;

float argv1;
float argv2;
float argv3;
float argv4;

float enterindex;
float M_TYPE_NONE = 0;
float M_TYPE_LOAD = 1;
float M_TYPE_SAVE = 2;
float M_TYPE_SKILL = 3;
float M_TYPE_CREDITS = 4;
float M_TYPE_HELP = 5;
float M_TYPE_OPTIONS = 6;
float M_TYPE_CONTROLS = 7;
float M_TYPE_VIDEO = 8;
float M_TYPE_AUDIO = 9;
float M_YNQ = 10;
float M_YND = 11;
float M_TYPE_DNONE = 12;
float M_TYPE_PROFILE = 14;
float M_TYPE_RESUME = 15;
float M_TYPE_GAMEPLAY = 16;
float M_TYPE_CONFIRMRESOLUTION = 17;
float M_TYPE_RESOLUTION = 18;
float M_TYPE_CONFIRMANTIALIAS = 19;
float M_TYPE_CONFIRMFULLSCREEN = 20;
float M_TYPE_CONFIRMBIND = 21;
float M_TYPE_PLAYING = 22;
float M_TYPE_SELECT_DIFFICULT = 23;
float M_TYPE_DELETEPROFILE = 24;
float M_TYPE_CONTROLBINDS = 25;
float M_TYPE_CONTROLRESTART = 26;

float profileslotpage;
float checksaves;

float autocvar_vid_conwidth;
float autocvar_vid_conheight;
vector mouse_pos;
float vid_wres;
float vid_fullscr;
float vid_hres;
float vid_aalias;

vector BTT_FONT_SIZE;	// '16 16 0'
vector BTT_IMG_SIZE;	// '256 32 0'
vector BTT_IMG_SIZE2;	// '128 32 0'
vector BTT_IMG_SIZE3;	// '32 32 0'

float vy_rel;
float vx_rel;

string profilename1;
string profilename2;
string profilename3;
string profilename4;
string profilename5;
string profilename6;
string profilename7;
string profilename8;
string profilename9;
string profilename10;
string profilename11;
string profilename12;
float currentprofilessaves;

float profilesammount;

vector(vector vctr) fixed_vector = 
{
	local vector vectr;
	vectr_x = vctr_x * vx_rel;
	vectr_y = vctr_y * vy_rel;
	return (vectr);
};

vector(vector vctr) fixed_vector2 = 
{
	local vector vectr;
	vectr_x = vctr_x * vy_rel;
	vectr_y = vctr_y * vy_rel;

	vectr_y = rint(vectr_y);
	vectr_x = rint(vectr_x);

	return (vectr);
};
