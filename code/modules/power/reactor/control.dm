/*/*
	Control - interface to link buttons, switches and other to objects.
*/

// controller obj.
/obj/machinery/controller/
	var/linked_id = "" // keep in mind, this id is a tag of /obj/.
					   // keep format: control@[name]@[number]
	var/obj/linked = null

// datum to hold info used to interact with obj.

/datum/control/custom
	/*interacting will call control_interact and no extra acts*/

/datum/control/logical_switch
	var/state = FALSE

/obj/var/datum/control/ccontrol = null

// calls when human interacts with controller, info in control var.
/obj/proc/control_interact(/mob/living/carbon/human/, /obj/machinery/controller/)
////

/obj/machinery/controller/proc/update_linked()
	if(linked && linked.tag == linked_id)
		return
	linked = locate(linked_id)

/obj/machinery/controller/Initialize()
	. = ..()
	update_linked()

/obj/machinery/controller/Process()
	. = ..()
	update_linked()

/obj/machinery/controller/attack_hand(mob/living/carbon/human/H)
	..()
	if(istype(linked?.ccontrol, /datum/control/logical_switch))
		var/datum/control/logical_switch/LS = linked.ccontrol
		LS.state = !LS.state

	linked?.control_interact(H, src)
*/


/obj/machinery/reactorpanel //A huge information display
	name = "Primary reactor information panel"
	desc = "A huge display that shows all the information you need to not blow up the C.C.F.R."
	icon = 'icons/obj/reactor_panel.dmi'
	icon_state = "offline"

/obj/machinery/reactorpanel/update_icon()
	. = ..()
