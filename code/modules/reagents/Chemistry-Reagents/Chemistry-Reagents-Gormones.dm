/datum/reagent/gormone/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as a drug to quickly increase blood pressure."
	taste_description = "rush"
	reagent_state = LIQUID
	color = "#c8a5dc"
	scannable = 1
	overdose = 20
	metabolism = 0.1

/datum/reagent/gormone/adrenaline/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
    M.add_chemical_effect(CE_PAINKILLER, min(2 * volume, 40))
    M.add_chemical_effect(CE_PULSE, volume * 6)
    M.add_chemical_effect(CE_CARDIAC_OUTPUT, 1 + volume * 0.05)

// MARKERS
/datum/reagent/gormone/marker
	color = "#ddcdcd"
	metabolism = 0.1
	reagent_state = LIQUID
	taste_description = "rush"

/datum/reagent/gormone/marker/troponin_t
	name = "Troponin-T"
	description = "Troponin-T generated in cardiomiocites necrose cases."
	