// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.
// Higher priority also means a larger share of a given tick before sleep checks.

// SS_TICKER
// < none >

#define SS_PRIORITY_DEFAULT 50          // Default priority for both normal and background processes

// Normal
#define SS_PRIORITY_MOB            100	// Mob Life().
#define SS_PRIORITY_MACHINERY      100	// Machinery + powernet ticks.
#define SS_PRIORITY_AIR            80	// ZAS processing.
#define SS_PRIORITY_MEDICINE       75   // Human update_cm().
#define SS_PRIORITY_AIRFLOW        15	// Object movement from ZAS airflow.

// SS_BACKGROUND
#define SS_PRIORITY_OBJECTS       60	// processing_objects processing.
#define SS_PRIORITY_TEMPERATURE   50
#define SS_PRIORITY_PROCESSING    30	// Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_GARBAGE       25	// Garbage collection.
#define SS_PRIORITY_ICON_UPDATE   20
#define SS_PRIORITY_TURF          15
#define SS_PRIORITY_VINES         10	// Spreading vine effects.
#define SS_PRIORITY_WIRELESS      10	// Wireless connection setup.
#define SS_PRIORITY_ZCOPY         9  // Builds appearances for Z-Mimic.
#define SS_PRIORITY_LIGHTING      8