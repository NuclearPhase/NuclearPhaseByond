/datum/xgm_fluid/oxygen
	id = FLUID_OXYGEN
	gas_name = "Oxygen"
	liquid_name = "Liquid Oxygen"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.032	// kg/mol
	flags = XGM_FLUID_OXIDIZER | XGM_FLUID_FUSION_FUEL
	reagent = /datum/reagent/oxygen
	symbol_html = "O<sub>2</sub>"
	symbol = "O2"
	triple_point_temperature = 54.36
	triple_point_pressure = 156
	hypercritical_point_temperature = 154.8
	hypercritical_point_pressure = 5.076 MPA
	just_solid_temp = 53.15
	lambda = 441.6


/datum/xgm_fluid/nitrogen
	id = FLUID_NITROGEN
	gas_name = "Nitrogen"
	liquid_name = "Liquid Nitrogen"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.028	// kg/mol
	symbol_html = "N<sub>2</sub>"
	symbol = "N2"
	triple_point_temperature = 63.15
	triple_point_pressure = 12.53 KPA
	hypercritical_point_temperature = 126.6
	hypercritical_point_pressure = 3.398 MPA
	just_solid_temp = 63.15
	lambda = 719.6

/datum/xgm_fluid/hydrogen
	id = FLUID_HYDROGEN
	gas_name = "Hydrogen"
	liquid_name = "Liquid Hydrogen"
	specific_heat = 100	// J/(mol*K)
	molar_mass = 0.002	// kg/mol
	flags = XGM_FLUID_FUEL|XGM_FLUID_FUSION_FUEL
	burn_product = FLUID_WATER
	symbol_html = "H<sub>2</sub>"
	symbol = "H2"
	triple_point_temperature = 13.96
	triple_point_pressure = 7.2 KPA
	hypercritical_point_temperature = 33
	hypercritical_point_pressure = 1.297 MPA
	lambda = 118

/datum/xgm_fluid/carbon_dioxide
	id = FLUID_CO2
	gas_name = "Carbon Dioxide"
	liquid_name = "Liquid Carbon Dioxide"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol
	symbol_html = "CO<sub>2</sub>"
	symbol = "CO2"
	triple_point_temperature = 216.16
	triple_point_pressure = 0.516 MPA
	hypercritical_point_temperature = 303.9
	hypercritical_point_pressure = 7.37 MPA
	just_solid_temp = 195.15
	lambda = 2.504 KJ

/datum/xgm_fluid/methyl_bromide
	id = FLUID_METHYL_BROMIDE
	gas_name = "Methyl Bromide"
	specific_heat = 42.59 // J/(mol*K)
	molar_mass = 0.095	  // kg/mol
	reagent = /datum/reagent/toxin/methyl_bromide
	symbol_html = "CH<sub>3</sub>Br"
	symbol = "CH3Br"

/datum/xgm_fluid/phoron
	id = FLUID_PHORON
	gas_name = "Phoron"

	//Note that this has a significant impact on TTV yield.
	//Because it is so high, any leftover phoron soaks up a lot of heat and drops the yield pressure.
	specific_heat = 200	// J/(mol*K)

	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	molar_mass = 0.405	// kg/mol

	tile_color = "#ff9940"
	overlay_limit = 0.7
	flags = XGM_FLUID_FUEL | XGM_FLUID_CONTAMINANT | XGM_FLUID_FUSION_FUEL
	breathed_product = /datum/reagent/toxin/phoron
	symbol_html = "Ph"
	symbol = "Ph"

/datum/xgm_fluid/sleeping_agent
	id = FLUID_N2O
	gas_name = "Nitrous Oxide"
	specific_heat = 40	// J/(mol*K)
	molar_mass = 0.044	// kg/mol. N2O
	flags = XGM_FLUID_OXIDIZER //N2O is a powerful oxidizer
	breathed_product = /datum/reagent/nitrous_oxide
	symbol_html = "N<sub>2</sub>O"
	symbol = "N2O"

/datum/xgm_fluid/methane
	id = FLUID_METHANE
	gas_name = "Methane"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.016	// kg/mol
	flags = XGM_FLUID_FUEL
	symbol_html = "CH<sub>4</sub>"
	symbol = "CH4"

/datum/xgm_fluid/alium
	id = FLUID_ALIEN
	gas_name = "Aliether"
	hidden_from_codex = TRUE
	symbol_html = "X"
	symbol = "X"

/datum/xgm_fluid/alium/New()
	var/num = rand(100,999)
	gas_name = "Compound #[num]"
	specific_heat = rand(1, 400)	// J/(mol*K)
	molar_mass = rand(20,800)/1000	// kg/mol
	if(prob(40))
		flags |= XGM_FLUID_FUEL
	else if(prob(40)) //it's prooobably a bad idea for gas being oxidizer to itself.
		flags |= XGM_FLUID_OXIDIZER
	if(prob(40))
		flags |= XGM_FLUID_CONTAMINANT
	if(prob(40))
		flags |= XGM_FLUID_FUSION_FUEL

	symbol_html = "X<sup>[num]</sup>"
	symbol = "X-[num]"
	if(prob(50))
		tile_color = RANDOM_RGB
		overlay_limit = 0.5

/datum/xgm_fluid/hydrogen/deuterium
	id = FLUID_DEUTERIUM
	gas_name = "Deuterium"
	symbol_html = "D"
	symbol = "D"

/datum/xgm_fluid/hydrogen/tritium
	id = FLUID_TRITIUM
	gas_name = "Tritium"
	symbol_html = "T"
	symbol = "T"

/datum/xgm_fluid/helium
	id = FLUID_HELIUM
	gas_name = "Helium"
	specific_heat = 80	// J/(mol*K)
	molar_mass = 0.004	// kg/mol
	flags = XGM_FLUID_FUSION_FUEL
	breathed_product = /datum/reagent/helium
	symbol_html = "He"
	symbol = "He"

/datum/xgm_fluid/argon
	id = FLUID_ARGON
	gas_name = "Argon"
	specific_heat = 10	// J/(mol*K)
	molar_mass = 0.018	// kg/mol
	symbol_html = "Ar"
	symbol = "Ar"

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/datum/xgm_fluid/krypton
	id = FLUID_KRYPTON
	gas_name = "Krypton"
	specific_heat = 5	// J/(mol*K)
	molar_mass = 0.036	// kg/mol
	symbol_html = "Kr"
	symbol = "Kr"

/datum/xgm_fluid/neon
	id = FLUID_NEON
	gas_name = "Neon"
	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.01	// kg/mol
	symbol_html = "Ne"
	symbol = "Ne"

/datum/xgm_fluid/xenon
	id = FLUID_XENON
	gas_name = "Xenon"
	specific_heat = 3	// J/(mol*K)
	molar_mass = 0.054	// kg/mol
	breathed_product = /datum/reagent/nitrous_oxide/xenon
	symbol_html = "Xe"
	symbol = "Xe"

/datum/xgm_fluid/nitrodioxide
	id = FLUID_NO2
	gas_name = "Nitrogen Dioxide"
	tile_color = "#ca6409"
	specific_heat = 37	// J/(mol*K)
	molar_mass = 0.054	// kg/mol
	flags = XGM_FLUID_OXIDIZER
	breathed_product = /datum/reagent/toxin
	symbol_html = "NO<sub>2</sub>"
	symbol = "NO2"

/datum/xgm_fluid/nitricoxide
	id = FLUID_NO
	gas_name = "Nitric Oxide"

	specific_heat = 10	// J/(mol*K)
	molar_mass = 0.030	// kg/mol
	flags = XGM_FLUID_OXIDIZER
	symbol_html = "NO"
	symbol = "NO"

/datum/xgm_fluid/chlorine
	id = FLUID_CHLORINE
	gas_name = "Chlorine"
	tile_color = "#c5f72d"
	overlay_limit = 0.5
	specific_heat = 5	// J/(mol*K)
	molar_mass = 0.017	// kg/mol
	flags = XGM_FLUID_CONTAMINANT
	breathed_product = /datum/reagent/toxin/chlorine
	symbol_html = "Cl"
	symbol = "Cl"

/datum/xgm_fluid/sulfurdioxide
	id = FLUID_SULFUR
	gas_name = "Sulfur Dioxide"

	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.044	// kg/mol
	symbol_html = "SO<sub>2</sub>"
	symbol = "SO2"

/datum/xgm_fluid/ammonia
	id = FLUID_AMMONIA
	gas_name = "Ammonia"

	specific_heat = 20	// J/(mol*K)
	molar_mass = 0.017	// kg/mol
	breathed_product = /datum/reagent/ammonia
	symbol_html = "NH<sub>3</sub>"
	symbol = "NH3"

/datum/xgm_fluid/carbon_monoxide
	id = FLUID_CO
	gas_name = "Carbon Monoxide"
	specific_heat = 30	// J/(mol*K)
	molar_mass = 0.028	// kg/mol
	breathed_product = /datum/reagent/carbon_monoxide
	symbol_html = "CO"
	symbol = "CO"
