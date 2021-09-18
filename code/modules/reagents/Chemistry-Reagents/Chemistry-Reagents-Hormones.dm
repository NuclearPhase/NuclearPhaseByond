/datum/reagent/hormone
	color = "#ddcdcd"
	metabolism = 0.1
	reagent_state = LIQUID
	taste_description = "rush"

/datum/reagent/hormone/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as emergency drug to quickly increase BP by increase HR and CO."

/datum/reagent/hormone/adrenaline/affect_blood(mob/living/carbon/human/M, alien, removed)
    M.add_chemical_effect(CE_PAINKILLER, min(2 * volume, 40))

/datum/reagent/hormone/noradrenaline
	name = "Noradrenaline"
	description = "Noradrenaline is a hormone used as emergency drug in shock states to increase BP by vasoconstricting."

/datum/reagent/hormone/dopamine
	name = "Dopamine"
	description = "Dopamine is a hormone used to treat hypotension by vasoconstricting. Can cause arrythmia."

// METABOLISM
/datum/reagent/hormone/glucose
	name = "Glucose"

// 1u insulin produce 0.1u glucose decrease.
/datum/reagent/hormone/insulin
	name = "Insulin"
	metabolism = 0.001

/datum/reagent/hormone/insulin/affect_blood(mob/living/carbon/human/M, alien, removed)
	M.bloodstr.remove_reagent(/datum/reagent/hormone/glucose, 0.1)
	remove_self(1)

// 1u glucagon produce 0.1u glucose increase.
/datum/reagent/hormone/glucagon
	name = "Glucagon"

// MARKERS

/datum/reagent/hormone/marker/troponin_t
	name = "Troponin-T"
	description = "Troponin-T generated in cardiomiocites necrose cases."
