
/datum/masslift/cable
	var/id = "id"
	var/power = 1000

var/global/list/datum/masslift/cable/masslift_cables = list()
var/global/masslift_cables_id = 0

proc/get_random_masslift_id()
	return "[rand(1,999)]-[masslift_cables_id++]"

/datum/masslift/cable/Destroy()
	masslift_cables -= id
	..()

/obj/masslift/cable
	var/cable_id = "id"
	icon = 'icons/masslift/cable.dmi'
	icon_state = "cable"
	density = 1
	plane = BLOB_PLANE

/obj/masslift/cable/Initialize()
	if(!(cable_id in masslift_cables))
		masslift_cables[cable_id] = new /datum/masslift/cable()
		masslift_cables[cable_id].id = cable_id

/obj/masslift/cable/proc/get_cable()
	if(!(cable_id in masslift_cables))
		masslift_cables[cable_id] = new /datum/masslift/cable()
		masslift_cables[cable_id].id = cable_id
	return cable_id in masslift_cables ? masslift_cables[cable_id] : null

/obj/masslift/extender
	icon = 'icons/masslift/cable.dmi'
	icon_state = "extender"
	var/obj/masslift/cable/cable = null

/obj/masslift/extender/proc/update()
	cable = locate(/obj/masslift/cable, get_step(src, DOWN))
	if(cable)
		var/id = cable.cable_id
		cable = new /obj/masslift/cable(loc)
		cable.cable_id = id

/obj/masslift/extender/Initialize()
	update()

/obj/masslift/extender/Process()
	if(!cable)
		update()