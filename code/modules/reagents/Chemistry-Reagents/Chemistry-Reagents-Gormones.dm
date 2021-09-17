// isgormone(T, adrenaline) ...
#define isgormone(G, T) istype(G, /datum/reagent/gormone/##T)

/datum/reagent/gormone
	color = "#ddcdcd"
	metabolism = 0.1
	reagent_state = LIQUID
	taste_description = "rush"

/datum/reagent/gormone/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as emergency drug to quickly increase BP by increase HR and CO."

/datum/reagent/gormone/adrenaline/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
    owner.add_chemical_effect(CE_PAINKILLER, min(2 * volume, 40))

/datum/reagent/gormone/noradrenaline
	name = "Noradrenaline"
	description = "Noradrenaline is a hormone used as emergency drug in shock states to increase BP by vasoconstricting and increasing HR."

/datum/reagent/gormone/dopamine
	name = "Dopamine"
	description = "Dopamine is a hormone used to treat hypotension by vasoconstricting. Can cause arrythmia."

// MARKERS

/datum/reagent/gormone/marker/troponin_t
	name = "Troponin-T"
	description = "Troponin-T generated in cardiomiocites necrose cases."
	