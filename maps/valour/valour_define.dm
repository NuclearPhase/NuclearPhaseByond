
/datum/map/valour
	name = "Valour"
	full_name = "The Valour"
	path = "valour"

	lobby_icon = 'maps/valour/utopia_lobby.dmi'

	station_levels = list(1, 2, 3, 4, 5, 6)
	contact_levels = list(1, 2, 3, 4, 5, 6)
	player_levels = list(1, 2, 3, 4, 5, 6)
	accessible_z_levels = list("5"=15)

	allowed_spawns = list("Arrivals Shuttle")

	shuttle_docked_message = "The shuttle has docked."
	shuttle_leaving_dock = "The shuttle has departed from home dock."
	shuttle_called_message = "A scheduled transfer shuttle has been sent."
	shuttle_recall_message = "The shuttle has been recalled"
	emergency_shuttle_docked_message = "The emergency escape shuttle has docked."
	emergency_shuttle_leaving_dock = "The emergency escape shuttle has departed from %dock_name%."
	emergency_shuttle_called_message = "An emergency escape shuttle has been sent."
	emergency_shuttle_recall_message = "The emergency shuttle has been recalled"