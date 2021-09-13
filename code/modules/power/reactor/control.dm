/obj/machinery/power/fusion/rswitch
	name = "Switch"
	var/iswitchable = 1 //Can you press it
	var/iposition = 0 //0 = off, 1 = on
	var/iobject //Basically the object the switch will interact with
/obj/machinery/power/fusion/rswitch/attack_hand(user)
	. = ..()
	sinteract()
/obj/machinery/power/fusion/rswitch/sinteract()
	if(iswitchable && iobject)
		if(!iposition)
			iposition = 1
			iobject.Signal(1)
			//Sound and icon here
			sleep(20)
		else
			iposition = 0
			iobject.Signal(0)
			//Sound and icon here
			sleep(20)
	else
		//Sound here
/obj/machinery/power/fusion/rswitch/dangerous
	name = "Secure Switch"
/obj/machinery/power/fusion/rswitch/dangerous/attack_hand(mob/user)
	. = ..()
	if(alert("Switching [src] may lead to bad circumstances. Continue?", "Switching confirmation", "Yes", "No") == "Yes")
		sinteract()
/obj/machinery/power/fusion/rswitch/rbutton
	name = "Button"

/obj/machinery/power/fusion/rswitch/coolantpump/inner
	name = "Exchanger to Reactor"
	desc = "A switch that controls station Alpha coolant pumps"

/obj/machinery/power/fusion/rswitch/coolantpump/outer
	name = "Reactor to Exchanger"
	desc = "A switch that controls station Alpha coolant pumps"

/obj/machinery/power/fusion/rswitch/aircooling
	name = "Air Cooling"
	desc = "A switch that controls reactor atmosphere cooling"

/obj/machinery/power/fusion/rswitch/watercooling
	name = "Liquid Cooling"
	desc = "Brings liquid cooling system online, yet decreases reactor fuel efficiency"
