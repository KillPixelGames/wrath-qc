
/*
==============================================================================

			CONSTANT DEFINITIONS

==============================================================================
*/

const float MASK_ENGINE			= 1;
const float MASK_ENGINEVIEWMODELS	= 2;
const float MASK_NORMAL			= 4;

const float RF_VIEWMODEL	= 1;
const float RF_EXTERNALMODEL	= 2;
const float RF_DEPTHHACK	= 4;
const float RF_ADDITIVE		= 8;
const float RF_USEAXIS		= 16;

const float VF_MIN		= 1;	//(vector)
const float VF_MIN_X		= 2;	//(float)
const float VF_MIN_Y		= 3;	//(float)
const float VF_SIZE		= 4;	//(vector) (viewport size)
const float VF_SIZE_Y		= 5;	//(float)
const float VF_SIZE_X		= 6;	//(float)
const float VF_VIEWPORT		= 7;	//(vector, vector)
const float VF_FOV		= 8;	//(vector)
const float VF_FOVX		= 9;	//(float)
const float VF_FOVY		= 10;	//(float)
const float VF_ORIGIN		= 11;	//(vector)
const float VF_ORIGIN_X		= 12;	//(float)
const float VF_ORIGIN_Y		= 13;	//(float)
const float VF_ORIGIN_Z		= 14;	//(float)
const float VF_ANGLES		= 15;	//(vector)
const float VF_ANGLES_X		= 16;	//(float)
const float VF_ANGLES_Y		= 17;	//(float)
const float VF_ANGLES_Z		= 18;	//(float)
const float VF_DRAWWORLD	= 19;	//(float)
const float VF_DRAWENGINESBAR	= 20;	//(float)
const float VF_DRAWCROSSHAIR	= 21;	//(float)

const float VF_CL_VIEWANGLES	= 33;	//(vector)
const float VF_CL_VIEWANGLES_X	= 34;	//(float)
const float VF_CL_VIEWANGLES_Y	= 35;	//(float)
const float VF_CL_VIEWANGLES_Z	= 36;	//(float)

const float VF_PERSPECTIVE      = 200;

#define VF_FOG_DENSITY        202 //(float)
#define VF_FOG_COLOR        203 //(vector)
#define VF_FOG_COLOR_R        204 //(float)
#define VF_FOG_COLOR_G        205 //(float)
#define VF_FOG_COLOR_B        206 //(float)
#define VF_FOG_ALPHA        207 //(float)
#define VF_FOG_START        208 //(float)
#define VF_FOG_END           209 //(float)
#define VF_FOG_HEIGHT        210 //(float)
#define VF_FOG_FADEDEPTH    211 //(float)

const float STAT_HEALTH		= 0;
const float STAT_WEAPONMODEL	= 2;
const float STAT_AMMO		= 3;
const float STAT_ARMOR		= 4;
const float STAT_WEAPONFRAME	= 5;
const float STAT_SHELLS		= 6;
const float STAT_NAILS		= 7;
const float STAT_ROCKETS	= 8;
const float STAT_CELLS		= 9;
const float STAT_ACTIVEWEAPON	= 10;
const float STAT_TOTALSECRETS	= 11;
const float STAT_TOTALMONSTERS	= 12;
const float STAT_SECRETS		= 13;
const float STAT_MONSTERS		= 14;
const float STAT_ITEMS		= 15;
const float STAT_VIEWHEIGHT	= 16;

// Quake Sound Constants
const float CHAN_AUTO			= 0;
const float CHAN_WEAPON			= 1;
const float CHAN_VOICE			= 2;
const float CHAN_ITEM			= 3;
const float CHAN_BODY			= 4;

const float ATTN_NONE			= 0;
const float ATTN_NORM			= 1;
const float ATTN_IDLE			= 2;
const float ATTN_STATIC			= 3;

// Frik File Constants
const float FILE_READ			= 0;
const float FILE_APPEND			= 1;
const float FILE_WRITE			= 2;

// Quake Point Contents
const float CONTENT_EMPTY					= -1;
const float CONTENT_SOLID					= -2;
const float CONTENT_WATER					= -3;
const float CONTENT_SLIME					= -4;
const float CONTENT_LAVA					= -5;
const float CONTENT_SKY						= -6;

// Quake Solid Constants
const float SOLID_NOT						= 0;
const float SOLID_TRIGGER					= 1;
const float SOLID_BBOX						= 2;
const float SOLID_SLIDEBOX					= 3;
const float SOLID_BSP						= 4;
const float SOLID_CORPSE					= 5;

// Quake Move Constants
const float MOVE_NORMAL						= 0;
const float MOVE_NOMONSTERS					= 1;
const float MOVE_MISSILE					= 2;

// Boolean Constants
const float true	= 1;
const float false	= 0;
const float TRUE	= 1;
const float FALSE	= 0;

const float EXTRA_LOW = -99999999;
const float EXTRA_HIGH = 99999999;

const vector VEC_1	= '1 1 1';
const vector VEC_0	= '0 0 0';
const vector VEC_M1	= '-1 -1 -1';

const float M_PI = 3.14159265358979323846;

vector	VEC_HULL_MIN = '-16 -16 -24';
vector	VEC_HULL_MAX = '16 16 32';

// Quake Temporary Entity Constants
const float TE_SPIKE						= 0;
const float TE_SUPERSPIKE					= 1;
const float TE_GUNSHOT						= 2;
const float TE_EXPLOSION					= 3;
const float TE_TAREXPLOSION					= 4;
const float TE_LIGHTNING1					= 5;
const float TE_LIGHTNING2					= 6;
const float TE_WIZSPIKE						= 7;
const float TE_KNIGHTSPIKE					= 8;
const float TE_LIGHTNING3					= 9;
const float TE_LAVASPLASH					= 10;
const float TE_TELEPORT						= 11;
const float TE_EXPLOSION2					= 12;
	// Darkplaces Additions
	const float TE_EXPLOSIONRGB					= 53;
	const float TE_GUNSHOTQUAD					= 57;
	const float TE_EXPLOSIONQUAD 				= 70;
	const float TE_SPIKEQUAD					= 58;
	const float TE_SUPERSPIKEQUAD				= 59;

// PFlags for Dynamic Lights
const float PFLAGS_NOSHADOW					= 1;
const float PFLAGS_CORONA					= 2;
const float PFLAGS_FULLDYNAMIC				= 128;

const float EF_ADDITIVE		= 32;
const float EF_BLUE		= 64;
const float EF_FLAME		= 1024;
const float EF_FULLBRIGHT	= 512;
const float EF_NODEPTHTEST	= 8192;
const float EF_NODRAW		= 16;
const float EF_NOSHADOW		= 4096;
const float EF_RED		= 128;
const float EF_STARDUST		= 2048;
const float EF_SELECTABLE 	= 16384;

const float PFL_ONGROUND	= 1;
const float PFL_CROUCH		= 2;
const float PFL_DEAD		= 4;
const float PFL_GIBBED		= 8;

// draw flags
const float DRAWFLAG_NORMAL = 0;
const float DRAWFLAG_ADDITIVE = 1;
const float DRAWFLAG_MODULATE = 2;
const float DRAWFLAG_2XMODULATE = 3;
const float DRAWFLAG_SCREEN = 4;
const float DRAWFLAG_MIPMAP = 0x100; // only for R_BeginPolygon



#define CLIENTCOMMAND_GET_FOG							"get_fog"
#define CLIENTCOMMAND_DELETE_QNG					"delete_qng"
#define CLIENTCOMMAND_DUMP_SPAWNERS			"dump_spawners"
#define CLIENTCOMMAND_NOATTACK							"noattack"
////////////////end of qc file
