/obj/structure/mri_rail
	icon = 'icons/obj/medicine.dmi'
	icon_state = "mri_rail"

/obj/structure/bed/mri_seat
	icon = 'icons/obj/medicine.dmi'
	icon_state = "mri_seat"

/obj/structure/bed/mri_seat/update_icon()
	return

#define MRI_FREE 0
#define MRI_SLIDE_IN 1
#define MRI_SLIDED_FREE 2
#define MRI_WORK 3
#define MRI_SLIDE_OUT 4

/obj/machinery/mri
	name = "MRI"
	icon = 'icons/obj/medicine.dmi'
	icon_state = "mri_base"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 1 KWATT
	active_power_usage = 100 KWATT
	var/state = MRI_FREE
