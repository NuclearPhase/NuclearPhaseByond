/datum/xgm_fluid/water
	id = FLUID_WATER
	gas_name = "Steam"
	liquid_name = "Water"
	tile_overlay = "generic"
	overlay_limit = 0.5
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.02	// kg/mol
	reagent = /datum/reagent/water
	condensation_point =   308.15 // 35C. Dew point is ~20C but this is better for gameplay considerations.
	symbol_html = "H<sub>2</sub>O"
	symbol = "H2O"
	lambda = 10.78