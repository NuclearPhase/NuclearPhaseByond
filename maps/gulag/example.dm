#if !defined(USING_MAP_DATUM)
	#include "example_areas.dm"

	#include "example_unit_testing.dm"

	#include "example-1.dmm"
	#include "example-2.dmm"

	#include "gulag_jobs.dm"

	#include "gulag_turfs.dm"

	#include "../../code/modules/lobby_music/absconditus.dm"

	#define USING_MAP_DATUM /datum/map/gulag

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Example

#endif
