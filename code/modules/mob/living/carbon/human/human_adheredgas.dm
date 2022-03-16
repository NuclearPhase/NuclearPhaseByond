#define ADHERED_GAS_COOLING_COEF 10
#define ADHERED_GAS_MAX_USE 5

/mob/living/carbon/human/proc/handle_adhered()
    if(istype(loc, /turf/unsimulated/floor/outwards))
        var/turf/unsimulated/floor/outwards/O = loc
        adhered_gas += O.adhered_gas

    var/used = clamp(adhered_gas, 0, ADHERED_GAS_MAX_USE)
    bodytemperature += clamp(-used * ADHERED_GAS_COOLING_COEF, BODYTEMP_COOLING_MAX, BODYTEMP_HEATING_MAX)
    adhered_gas -= used

