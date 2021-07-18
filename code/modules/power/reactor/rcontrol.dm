

/obj/machinery/reactorpanel //A huge information display
	name = "Primary reactor information panel"
	desc = "A huge display that shows all the information you need to not blow up the C.C.F.R."
	icon = 'icons/obj/reactor_panel.dmi'
	icon_state = "offline"
	var/active = FALSE

/obj/machinery/reactorpanel/update_icon()
	. = ..()
	overlays.Cut()
	if(!RREACTOR)
		icon_state = "online-stale"
		return
	if(!active)
		icon_state = "offline"
		return
	if(FI1.locked)
		overlays += image('icons/obj/reactor_panel.dmi', "cell1-lock")
	else
		overlays += image('icons/obj/reactor_panel.dmi', "cell1-unlock")
	if(FI2.locked)
		overlays += image('icons/obj/reactor_panel.dmi', "cell2-lock")
	else
		overlays += image('icons/obj/reactor_panel.dmi', "cell2-unlock")
	if(FI3.locked)
		overlays += image('icons/obj/reactor_panel.dmi', "cell3-lock")
	else
		overlays += image('icons/obj/reactor_panel.dmi', "cell3-unlock")
	switch(RREACTOR.superstructure_integrity)
		if(100 to 75)
			overlays += image('icons/obj/reactor_panel.dmi', "integrity100")
		if(75 to 50)
			overlays += image('icons/obj/reactor_panel.dmi', "integrity75")
		if(50 to 25)
			overlays += image('icons/obj/reactor_panel.dmi', "integrity50")
		if(25 to 5)
			overlays += image('icons/obj/reactor_panel.dmi', "integrity25")
		if(5 to 0)
			overlays += image('icons/obj/reactor_panel.dmi', "integrity0")