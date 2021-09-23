//I am aware this is probably the worst possible way of doing it but I'm using this method till I get a better one. - Matt
// FUCK YOU MATT

/mob
	var/strength = 10
	var/dexterity = 10
	var/intelligence = 10
	var/list/skills = list()

/mob/proc/get_skill(skill_id)
	return LAZYACCESS(skills, skill_id) || 0

/mob/proc/skillcheck(skill_id, required, message, affected = 0)
	if(mood_affect() && (get_skill(skill_id) >= required || prob(affected)))
		return TRUE
	if(message)
		to_chat(src, SPAN_WARNING(message))
	return FALSE

/mob/proc/statcheck(stat, requirement, _r = FALSE)
	if(stat >= requirement)
		return TRUE
	if(_r)
		return FALSE
	return mood_affect() && .(stat, rand(1, requirement + 10), _r = TRUE)

//having a bad mood fucks your shit up fam.
// returns false if failed
/mob/proc/mood_affect()
	if(!iscarbon(src))
		return TRUE
	var/mob/living/carbon/C = src
	if(C.happiness < MOOD_LEVEL_SAD1)
		return prob(100 - abs(C.happiness) * 1.5)
	return TRUE


proc/strToDamageModifier(var/strength)
	switch(strength)
		if(1 to 5)
			return 0.5

		if(6 to 11)
			return 1

		if(12 to 15)
			return 1.5

		if(16 to 18)
			return  1.75

		if(18 to INFINITY)
			return 2

proc/strToSpeedModifier(var/strength, var/w_class)//Looks messy. Is messy. Is also only used once. But I don't give a fuuuuuuuuck.
	switch(strength)
		if(1 to 5)
			if(w_class > ITEM_SIZE_NORMAL)
				return 20

		if(6 to 11)
			if(w_class > ITEM_SIZE_NORMAL)
				return 15

		if(12 to 15)
			if(w_class > ITEM_SIZE_NORMAL)
				return 10

		if(16 to INFINITY)
			if(w_class > ITEM_SIZE_NORMAL)
				return 5

//Stats helpers.
/mob/proc/add_stats(var/stre, var/dexe, var/inti)//To make adding stats quicker.
	if(stre)
		strength = stre
	if(dexe)
		dexterity = dexe
	if(inti)
		intelligence = inti


/mob/proc/adjustStrength(var/num)
	strength += num

/mob/proc/adjustDexterity(var/num)
	dexterity += num

/mob/proc/adjustInteligence(var/num)
	intelligence += num

// TODO: Make temporary skill/stat adjust.