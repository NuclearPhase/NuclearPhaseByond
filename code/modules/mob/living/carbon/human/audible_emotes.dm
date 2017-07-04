proc/agony_scream(var/mob/M)
	var/screamsound = null
	if(M.stat)//No dead or unconcious people screaming pls.
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isMonkey())
			screamsound = "sound/voice/monkey_pain[rand(1,3)].ogg"

		else if(H.isChild())
			screamsound = "sound/voice/child_pain[rand(1,2)].ogg"

		else if(M.gender == MALE)
			screamsound = pick('sound/voice/man_pain1.ogg','sound/voice/man_pain2.ogg','sound/voice/man_pain3.ogg')

		else
			screamsound = pick('sound/voice/woman_agony1.ogg','sound/voice/woman_agony2.ogg','sound/voice/woman_agony3.ogg')


	if(screamsound)
		playsound(M, screamsound, 25, 0, 1)

proc/gasp_sound(var/mob/M)
	var/gaspsound = null
	if(M.stat)
		return

	if(M.gender == MALE)
		gaspsound = pick('sound/voice/gasp_male1.ogg','sound/voice/gasp_male2.ogg','sound/voice/gasp_male3.ogg','sound/voice/gasp_male4.ogg','sound/voice/gasp_male5.ogg','sound/voice/gasp_male6.ogg','sound/voice/gasp_male7.ogg')

	if(M.gender == FEMALE)
		gaspsound = pick('sound/voice/gasp_female1.ogg','sound/voice/gasp_female2.ogg','sound/voice/gasp_female3.ogg','sound/voice/gasp_female4.ogg','sound/voice/gasp_female5.ogg','sound/voice/gasp_female6.ogg','sound/voice/gasp_female7.ogg')

	if(gaspsound)
		playsound(M, gaspsound, 25, 0, 1)

proc/agony_moan(var/mob/M)
	var/moansound = null
	if(M.stat)//No dead or unconcious people screaming pls.
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.isMonkey())
			return

		if(H.isChild())
			moansound = 'sound/voice/child_moan1.ogg'

		else if(M.gender == MALE)
			moansound = "sound/voice/male_moan[rand(1,3)].ogg"

		else
			moansound = "sound/voice/female_moan[rand(1,3)].ogg"


	if(moansound)
		playsound(M, moansound, 25, 0, 1)