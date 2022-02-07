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