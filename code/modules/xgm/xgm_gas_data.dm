/*
/datum/xgm_fluid_data
	//Simple list of all the gas IDs.
	var/list/gases = list()
	//The friendly, human-readable name for the gas.
	var/list/gas_name = list()
	var/list/liquid_name = list()

	//Specific heat of the gas.  Used for calculating heat capacity.
	var/list/specific_heat = list()
	//Molar mass of the gas.  Used for calculating specific entropy.
	var/list/molar_mass = list()
	//Tile overlays.  /obj/effect/gas_overlay, created from references to 'icons/effects/tile_effects.dmi'
	var/list/tile_overlay = list()
	//Optional color for tile overlay
	var/list/tile_overlay_color = list()
	//Overlay limits.  There must be at least this many moles for the overlay to appear.
	var/list/overlay_limit = list()
	//Flags.
	var/list/flags = list()
	//Products created when burned. For fuel only for now (not oxidizers)
	var/list/burn_product = list()

	// Binded with fluid reagent.
	var/list/reagent = list()
	// Temperature in K that the gas will condense.
	var/list/condensation_points = list()
	//If it shouldn't autogenerate a codex entry
	var/list/hidden_from_codex = list()

	var/list/triple_point = list() // {temperature, pressure in Pa}
	var/list/hypercritical_point = list() // {temperature, pressure in Pa}
	var/list/lambda = list() // J/kg, energy used to convert liquid to gas
	var/list/just_solid_temp = list()
	//Holds the symbols
	var/list/symbol_html = list()
	var/list/symbol = list()

GLOBAL_DATUM(fluid_data, /datum/xgm_fluid_data)
*/

/datum/xgm_fluid
	var/id = ""
	var/gas_name = "Unnamed Gas"
	var/liquid_name = "Unnamed Liquid"
	var/specific_heat = 20	// J/(mol*K)
	var/molar_mass = 0.032	// kg/mol

	var/tile_overlay = "generic"
	var/tile_color = null
	var/overlay_limit = null

	var/flags = 0
	var/burn_product = FLUID_CO2
	var/breathed_product
	var/condensation_point = INFINITY
	var/condensation_product
	var/hidden_from_codex
	var/symbol_html = "X"
	var/symbol = "X"

	var/reagent

	var/triple_point_temperature = 273.16
	var/triple_point_pressure = 610
	var/hypercritical_point_temperature = 647.3
	var/hypercritical_point_pressure = 22.1 MPA
	var/just_solid_temp = 200
	var/lambda = 17.248 // J/mol (J/kg * molar_mass)

	// precalculations
	var/pc_rev_hct_m_tpt = 0.002672 // 1 / (hypercritical_point_temperature - triple_point_temperature)

/datum/fluid_data_wrap
	var/list/impl

GLOBAL_RAW(/list/datum/xgm_fluid/fluid_data)
GLOBAL_MANAGED(fluid_data, null)

GLOBAL_DATUM_INIT(fluid_data_wrap, /datum/fluid_data_wrap, new)

/hook/startup/proc/generate_fluid_data()
	GLOB.fluid_data = list()
	for(var/p in subtypesof(/datum/xgm_fluid))
		var/datum/xgm_fluid/fluid = new p //avoid initial() because of potential New() actions

		if(fluid.id in GLOB.fluid_data)
			error("Duplicate fluid id `[fluid.id]` in `[p]`")

		fluid.pc_rev_hct_m_tpt = 1.0 / (fluid.hypercritical_point_temperature - fluid.triple_point_temperature)

		GLOB.fluid_data[fluid.id] = fluid

	GLOB.fluid_data_wrap.impl = GLOB.fluid_data
	return 1

/*
/hook/startup/proc/generate_fluid_data()
	GLOB.fluid_data = new
	for(var/p in subtypesof(/datum/xgm_fluid))
		var/datum/xgm_fluid/fluid = new p //avoid initial() because of potential New() actions

		if(fluid.id in GLOB.fluid_data)
			error("Duplicate fluid id `[fluid.id]` in `[p]`")

		GLOB.fluid_data += fluid.id
		GLOB.fluid_data.gas_name[fluid.id] = fluid.gas_name
		GLOB.fluid_data.liquid_name[fluid.id] = fluid.liquid_name || "Liquid [fluid.gas_name]"
		GLOB.fluid_data.specific_heat[fluid.id] = fluid.specific_heat
		GLOB.fluid_data.molar_mass[fluid.id] = fluid.molar_mass
		if(fluid.overlay_limit)
			GLOB.fluid_data.overlay_limit[fluid.id] = fluid.overlay_limit
			GLOB.fluid_data.tile_overlay[fluid.id] = fluid.tile_overlay
			GLOB.fluid_data.tile_overlay_color[fluid.id] = fluid.tile_color
		GLOB.fluid_data.flags[fluid.id] = fluid.flags
		GLOB.fluid_data.burn_product[fluid.id] = fluid.burn_product
		GLOB.fluid_data.just_solid_temp[fluid.id] = fluid.just_solid_temp
		GLOB.fluid_data.triple_point[fluid.id] = fluid.triple_point
		GLOB.fluid_data.hypercritical_point[fluid.id] = fluid.hypercritical_point
		GLOB.fluid_data.lambda[fluid.id] = fluid.lambda

		GLOB.fluid_data.symbol_html[fluid.id] = fluid.symbol_html
		GLOB.fluid_data.symbol[fluid.id] = fluid.symbol

		GLOB.fluid_data.reagent[fluid.id] = fluid.reagent

		GLOB.fluid_data.hidden_from_codex[fluid.id] = fluid.hidden_from_codex
	return 1
*/

/obj/effect/gas_overlay
	name = "gas"
	desc = "You shouldn't be clicking this."
	icon = 'icons/effects/tile_effects.dmi'
	icon_state = "generic"
	layer = FIRE_LAYER
	appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_COLOR
	mouse_opacity = 0
	var/gas_id

/obj/effect/gas_overlay/proc/update_alpha_animation(var/new_alpha)
	animate(src, alpha = new_alpha)
	alpha = new_alpha
	animate(src, alpha = 0.8 * new_alpha, time = 10, easing = SINE_EASING | EASE_OUT, loop = -1)
	animate(alpha = new_alpha, time = 10, easing = SINE_EASING | EASE_IN, loop = -1)

/obj/effect/gas_overlay/Initialize(mapload, gas)
	. = ..()
	gas_id = gas
	if(GLOB.fluid_data[gas_id].tile_overlay)
		icon_state = GLOB.fluid_data[gas_id].tile_overlay
	color = GLOB.fluid_data[gas_id].tile_color