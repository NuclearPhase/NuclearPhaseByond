SUBSYSTEM_DEF(legacy)
	name = "Legacy"
	init_order = SS_INIT_LEGACY
	flags = SS_NO_FIRE

/datum/controller/subsystem/legacy/Initialize(timeofday)
	master_controller.setup()
	return ..()
