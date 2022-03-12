PROCESSING_SUBSYSTEM_DEF(mechanic)
	name = "Mechanic"
	priority = SS_PRIORITY_MECHANIC
	flags = SS_BACKGROUND | SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	wait = 2 SECONDS

/datum/controller/subsystem/processing/medicine/stat_entry(text)
	text = {"\
		[text] | \
		Processing: [processing.len] \
	"}
	..(text)