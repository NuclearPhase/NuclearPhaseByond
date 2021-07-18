/obj/machinery/coolantpiping //For la liquid metal
    name = "Coolant pipe"
    desc = "A large pipe that transfers liquid metal coolant"
    //icon = ''
    //icon_state = ""
    var/overheating = FALSE

/obj/machinery/coolantpiping/examine(mob/user, distance, infix, suffix)
    . = ..()
    if(overheating)
        to_chat(user, "It has a bright red color!")



/obj/machinery/atmospherics/pipe/reactor //Just a different sprite for steam transfer
    name = "Coolant pipe"
    desc = "A large pipe that transfers steam between the turbines and heat exchanger"
//    icon = ''
//    icon_state = ""