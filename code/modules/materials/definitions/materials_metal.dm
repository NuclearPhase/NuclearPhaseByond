/material/uranium
	name = MATERIAL_URANIUM
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/uranium
	radioactivity = 12
	icon_base = "stone"
	door_icon_base = "stone"
	table_icon_base = "stone"
	icon_reinf = "reinf_stone"
	icon_colour = "#007a00"
	weight = 22
	stack_origin_tech = list(TECH_MATERIAL = 5)
	value = 100

/material/gold
	name = MATERIAL_GOLD
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/gold
	icon_colour = COLOR_GOLD
	weight = 25
	hardness = MATERIAL_FLEXIBLE + 5
	integrity = 100
	stack_origin_tech = list(TECH_MATERIAL = 4)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = MATERIAL_GOLD
	ore_result_amount = 5
	ore_name = "native gold"
	ore_spread_chance = 10
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "nugget"
	value = 40

/material/gold/bronze //placeholder for ashtrays
	name = MATERIAL_BRONZE
	icon_colour = "#edd12f"
	ore_smelts_to = null
	ore_compresses_to = null

/material/copper
	name = MATERIAL_COPPER
	wall_name = "bulkhead"
	icon_colour = "#b87333"
	weight = 15
	hardness = MATERIAL_FLEXIBLE + 10
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = MATERIAL_COPPER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "tetrahedrite"
	ore_scan_icon = "mineral_common"
	ore_icon_overlay = "shiny"

/material/silver
	name = MATERIAL_SILVER
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/silver
	icon_colour = "#d1e6e3"
	weight = 22
	hardness = MATERIAL_FLEXIBLE + 10
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = MATERIAL_SILVER
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "native silver"
	ore_scan_icon = "mineral_uncommon"
	ore_icon_overlay = "shiny"
	value = 35

/material/steel
	name = MATERIAL_STEEL
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/steel
	brute_armor = 7
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = COLOR_STEEL
	hitsound = 'sound/weapons/smash.ogg'
	alloy_product = TRUE
	ore_smelts_to = MATERIAL_STEEL
	value = 4

/material/steel/holographic
	name = "holo" + MATERIAL_STEEL
	display_name = MATERIAL_STEEL
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_product = FALSE
	value = 0

/material/aluminium
	name = MATERIAL_ALUMINIUM
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/aluminium
	integrity = 125
	weight = 18
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#cccdcc"
	hitsound = 'sound/weapons/smash.ogg'

/material/aluminium/holographic
	name = "holo" + MATERIAL_ALUMINIUM
	display_name = MATERIAL_ALUMINIUM
	stack_type = null
	shard_type = SHARD_NONE
	conductive = 0
	alloy_product = FALSE

/material/plasteel
	name = MATERIAL_PLASTEEL
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/plasteel
	integrity = 400
	melting_point = 6000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#a8a9b2"
	explosion_resistance = 25
	brute_armor = 8
	burn_armor = 10
	hardness = MATERIAL_VERY_HARD
	weight = 23
	stack_origin_tech = list(TECH_MATERIAL = 2)
	hitsound = 'sound/weapons/smash.ogg'
	alloy_product = TRUE
	ore_smelts_to = MATERIAL_PLASTEEL
	value = 12

/material/plasteel/titanium
	name = MATERIAL_TITANIUM
	brute_armor = 10
	burn_armor = 8
	integrity = 200
	melting_point = 3000
	weight = 18
	stack_type = /obj/item/stack/material/titanium
	icon_base = "metal"
	door_icon_base = "metal"
	icon_colour = "#d1e6e3"
	icon_reinf = "reinf_metal"
	alloy_product = FALSE
	value = 30

/material/plasteel/ocp
	name = MATERIAL_OSMIUM_CARBIDE_PLASTEEL
	stack_type = /obj/item/stack/material/ocp
	integrity = 200
	melting_point = 12000
	icon_base = "solid"
	icon_reinf = "reinf_over"
	icon_colour = "#9bc6f2"
	brute_armor = 4
	burn_armor = 20
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 3)
	alloy_product = TRUE

/material/osmium
	name = MATERIAL_OSMIUM
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/osmium
	icon_colour = "#9999ff"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = MATERIAL_OSMIUM
	value = 30

/material/tritium
	name = MATERIAL_TRITIUM
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/tritium
	icon_colour = "#777777"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1
	value = 300

/material/deuterium
	name = MATERIAL_DEUTERIUM
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/deuterium
	icon_colour = "#999999"
	stack_origin_tech = list(TECH_MATERIAL = 3)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	is_fusion_fuel = 1

/material/mhydrogen
	name = MATERIAL_HYDROGEN
	display_name = "metallic hydrogen"
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/mhydrogen
	icon_colour = "#e6c5de"
	stack_origin_tech = list(TECH_MATERIAL = 6, TECH_POWER = 6, TECH_MAGNET = 5)
	is_fusion_fuel = 1
	ore_smelts_to = MATERIAL_TRITIUM
	ore_compresses_to = MATERIAL_HYDROGEN
	ore_name = "raw hydrogen"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "gems"
	value = 100

/material/platinum
	name = MATERIAL_PLATINUM
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/platinum
	icon_colour = "#deddff"
	weight = 27
	stack_origin_tech = list(TECH_MATERIAL = 2)
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	ore_smelts_to = MATERIAL_PLATINUM
	ore_compresses_to = MATERIAL_OSMIUM
	ore_result_amount = 5
	ore_spread_chance = 10
	ore_name = "raw platinum"
	ore_scan_icon = "mineral_rare"
	ore_icon_overlay = "shiny"
	value = 80

/material/iron
	name = MATERIAL_IRON
	wall_name = "bulkhead"
	stack_type = /obj/item/stack/material/iron
	icon_colour = "#5c5454"
	weight = 22
	sheet_singular_name = "ingot"
	sheet_plural_name = "ingots"
	hitsound = 'sound/weapons/smash.ogg'
	value = 5

// Adminspawn only, do not let anyone get this.
/material/voxalloy
	name = MATERIAL_VOX
	display_name = "durable alloy"
	wall_name = "bulkhead"
	stack_type = null
	icon_colour = "#6c7364"
	integrity = 1200
	melting_point = 6000       // Hull plating.
	explosion_resistance = 200 // Hull plating.
	hardness = 500
	weight = 500
	value = 100

// Likewise.
/material/voxalloy/elevatorium
	name = MATERIAL_ELEVATORIUM
	display_name = "elevator panelling"
	wall_name = "bulkhead"
	icon_colour = "#666666"

/material/aliumium
	name = MATERIAL_ALIENALLOY
	display_name = "alien alloy"
	wall_name = "bulkhead"
	stack_type = null
	icon_base = "jaggy"
	door_icon_base = "metal"
	icon_reinf = "reinf_metal"
	hitsound = 'sound/weapons/smash.ogg'
	sheet_singular_name = "chunk"
	sheet_plural_name = "chunks"
	stack_type = /obj/item/stack/material/aliumium

/material/aliumium/New()
	icon_base = "metal"
	icon_colour = rgb(rand(10,150),rand(10,150),rand(10,150))
	explosion_resistance = rand(25,40)
	brute_armor = rand(10,20)
	burn_armor = rand(10,20)
	hardness = rand(15,100)
	integrity = rand(200,400)
	melting_point = rand(400,10000)
	..()

/material/aliumium/place_dismantled_girder(var/turf/target, var/material/reinf_material)
	return

/material/hematite
	name = MATERIAL_HEMATITE
	wall_name = "bulkhead"
	stack_type = null
	icon_colour = "#aa6666"
	ore_smelts_to = MATERIAL_IRON
	ore_result_amount = 5
	ore_spread_chance = 25
	ore_scan_icon = "mineral_common"
	ore_name = "hematite"
	ore_icon_overlay = "lump"

/material/rutile
	name = MATERIAL_RUTILE
	wall_name = "bulkhead"
	stack_type = null
	icon_colour = "#d8ad97"
	ore_smelts_to = MATERIAL_TITANIUM
	ore_result_amount = 5
	ore_spread_chance = 15
	ore_scan_icon = "mineral_uncommon"
	ore_name = "rutile"
	ore_icon_overlay = "lump"