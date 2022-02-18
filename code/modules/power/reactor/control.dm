/obj/machinery/power/nuclear/controlrod
	name = "Control rod"
	icon = 'icons/obj/machines/nuclear.dmi'
	icon_state = "controlrods"

	anchored = TRUE

	var/state = 0 // 0 - 100
	var/obj/machinery/power/nuclear/core/connected = null

/obj/machinery/power/nuclear/controlrod/update_icon()
	pixel_y = state / 2

/obj/machinery/power/nuclear/controlrod/proc/update_core()
	if(connected)
		connected.rods -= src
	connected = locate() in orange(1, src)
	connected.rods |= src

/obj/machinery/power/nuclear/controlrod/Initialize()
	update_core()
