/datum/map/utopia
	allowed_jobs = list(
						/datum/job/assistant,
						///datum/job/captain,
						///datum/job/hop,
						///datum/job/doctor,
						///datum/job/chemist,
						///datum/job/officer,
						///datum/job/qm,
						///datum/job/engineer,
						///datum/job/cargo_tech,
						///datum/job/mining,
						///datum/job/chef,
						///datum/job/chaplain,
						///datum/job/janitor,
						///datum/job/Paramedic,
						///datum/job/bartender
						///datum/job/rd,
						///datum/job/scientist,
						)

/datum/job/assistant
	title = "Assistant"
	department = "Civilian"
	department_flag = CIV
	total_positions = -1
	spawn_positions = -1
	supervisors = "absolutely everyone"
	selection_color = "#515151"
	economic_modifier = 1
	access = list()			//See /datum/job/assistant/get_access()
	minimal_access = list()	//See /datum/job/assistant/get_access()
	alt_titles = list("Technical Assistant","Medical Intern","Research Assistant","Visitor")
	outfit_type = /decl/hierarchy/outfit/job/assistant

	equip(var/mob/living/carbon/human/H)
		..()
		H.add_stats(rand(6,13), rand(6,13), rand(5,9))
		H.add_skills(rand(20, 60), rand(0,40), rand(0, 50), rand(0, 50))