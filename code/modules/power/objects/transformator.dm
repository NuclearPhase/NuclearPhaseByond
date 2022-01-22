/obj/machinery/power/transformator
    icon = 'icons/obj/power.dmi'
    icon_state = "transformator"
    var/coef = 2
    var/obj/machinery/power/transformator/connected = null
    var/max_cap = 75 AMPER

    efficiency = 0.75

/obj/machinery/power/transformator/Process()
    if(!connected)
        connected = locate(/obj/machinery/power/transformator, get_step(src, dir))
        if(connected)
            connected.connected = src
        else
            return

    if(!powernet && !connected.powernet)
        return

    if(surplus() > connected.surplus())
        var/transfered = min(surplus(), max_cap)
        connected.powernet.add_power(transfered / coef, powernet.get_voltage() * coef)
        powernet.draw_power(transfered * powernet.get_voltage())