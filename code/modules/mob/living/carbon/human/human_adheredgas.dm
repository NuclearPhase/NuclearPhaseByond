#define ADHERED_GAS_COOLING_COEF 10
#define ADHERED_GAS_MAX_USE 5

/mob/living/carbon/human/proc/handle_adhered()
    if(istype(loc, /turf/unsimulated/floor/outwards))
        var/turf/unsimulated/floor/outwards/O = loc
        adhered_gas += O.adhered_gas

    var/used = between(0, adhered_gas, ADHERED_GAS_MAX_USE)
    bodytemperature += between(BODYTEMP_COOLING_MAX, -used * ADHERED_GAS_COOLING_COEF, BODYTEMP_HEATING_MAX)
    adhered_gas -= used

