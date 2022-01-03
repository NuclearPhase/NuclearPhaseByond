#if !defined(using_map_DATUM)
	#include "valour_areas.dm"
	#include "valour_shuttles.dm"
	#include "valour_unit_testing.dm"

	#include "valour-1.dmm"
	#include "valour-2.dmm"
	#include "valour-3.dmm"
	#include "valour-4.dmm"
	#include "valour-5.dmm"
	#include "valour-masslift.dmm"

	#include "../../code/modules/lobby_music/absconditus.dm"

	#define using_map_DATUM /datum/map/valour

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Valour

#endif
