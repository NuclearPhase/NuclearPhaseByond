/datum/happiness_event
	var/description
	var/happiness = 0
	var/timeout = 0

///For descriptions, use the span classes bold info, info, none, warning and boldwarning in order from great to horrible.

//thirst
/datum/happiness_event/thirst/filled
	description = "<span class='binfo'>I've had enough to drink for a while!</span>"
	happiness = 4

/datum/happiness_event/thirst/watered
	description = "<span class='info'>I have recently had something to drink.</span>"
	happiness = 2

/datum/happiness_event/thirst/thirsty
	description = "<span class='warning'>I'm getting a bit thirsty.</span>"
	happiness = -7

/datum/happiness_event/thirst/dehydrated
	description = "<span class='danger'>I need water!</span>"
	happiness = -14



//nutrition
/datum/happiness_event/nutrition/fat
	description = "<span class='warning'><B>I'm so fat..</B></span>" //muh fatshaming
	happiness = -4

/datum/happiness_event/nutrition/wellfed
	description = "<span class='binfo'>My belly feels round and full.</span>"
	happiness = 4

/datum/happiness_event/nutrition/fed
	description = "<span class='info'>I have recently had some food.</span>"
	happiness = 2

/datum/happiness_event/nutrition/hungry
	description = "<span class='warning'>I'm getting a bit hungry.</span>"
	happiness = -6

/datum/happiness_event/nutrition/starving
	description = "<span class='danger'>I'm starving!</span>"
	happiness = -12


//Hygiene
/datum/happiness_event/hygiene/clean
	description = "<span class='info'>I feel so clean!"
	happiness = 2

/datum/happiness_event/hygiene/smelly
	description = "<span class='warning'>I smell like shit."
	happiness = -5

/datum/happiness_event/hygiene/vomitted
	description = "<span class='warning'>Ugh, I've vomitted."
	happiness = -5
	timeout = 1800



//Disgust
/datum/happiness_event/disgust/gross
	description = "<span class='warning'>That was gross.</span>"
	happiness = -2
	timeout = 1800

/datum/happiness_event/disgust/verygross
	description = "<span class='warning'>I think I'm going to puke...</span>"
	happiness = -4
	timeout = 1800

/datum/happiness_event/disgust/disgusted
	description = "<span class='danger'>Oh god that's disgusting...</span>"
	happiness = -6
	timeout = 1800



//Generic events
/datum/happiness_event/favorite_food
	description = "<span class='info'>I really liked eating that.</span>"
	happiness = 3
	timeout = 2400

/datum/happiness_event/nice_shower
	description = "<span class='info'>I had a nice shower.</span>"
	happiness = 1
	timeout = 1800

/datum/happiness_event/handcuffed
	description = "<span class='warning'>I guess my antics finally caught up with me..</span>"
	happiness = -1

/datum/happiness_event/booze
	description = "<span class='info'>Alcohol makes the pain go away.</span>"
	happiness = 3
	timeout = 2400

/datum/happiness_event/relaxed//For nicotine.
	description = "<span class='info'>I feel relaxed.</span>"
	happiness = 1
	timeout = 1800

/datum/happiness_event/antsy//Withdrawl.
	description = "<span class='danger'>I could use a smoke.</span>"
	happiness = -3
	timeout = 1800

/datum/happiness_event/hot_food //Hot food feels good!
	description = "<span class='info'>I've eaten something warm.</span>"
	happiness = 3
	timeout = 1800

/datum/happiness_event/cold_drink //Cold drinks feel good!
	description = "<span class='info'>I've had something refreshing.</span>"
	happiness = 3
	timeout = 1800

/datum/happiness_event/high
	description = "<span class='binfo'>I'm high as fuck</span>"
	happiness = 12



//Embarassment
/datum/happiness_event/hygiene/shit
	description = "<span class='danger'>I shit myself. How embarassing."
	happiness = -12
	timeout = 1800

/datum/happiness_event/hygiene/pee
	description = "<span class='danger'>I pissed myself. How embarassing."
	happiness = -12
	timeout = 1800

/datum/happiness_event/badsex
	description = "<span class='warning'>Ugh, that sex was horrible."
	happiness = -4
	timeout = 1800

//Good sex here too because why not.
/datum/happiness_event/came
	description = "<span class='binfo'>I came!"
	happiness = 10
	timeout = 1800

//For when you get branded.
/datum/happiness_event/humiliated
	description = "<span class='danger'>I've been humiliated, and I am embarassed.</span>"
	happiness = -10
	timeout = 1800

//And when you've seen someone branded
/datum/happiness_event/punished_heretic
	description = "<span class='binfo'>I've seen a punished heretic.</span>"
	happiness = 10
	timeout = 1800


//Unused so far but I want to remember them to use them later.
/datum/happiness_event/disturbing
	description = "<span class='danger'>I recently saw something disturbing</span>"
	happiness = -2

/datum/happiness_event/clown
	description = "<span class='info'>I recently saw a funny clown!</span>"
	happiness = 1

/datum/happiness_event/cloned_corpse
	description = "<span class='danger'>I recently saw my own corpse...</span>"
	happiness = -6

/datum/happiness_event/surgery
	description = "<span class='danger'>HE'S CUTTING ME OPEN!!</span>"
	happiness = -8

// additicions

/datum/happiness_event/opiates/h1
	description = SPAN_NOTICE("You feel relaxed...")
	happiness = 2

/datum/happiness_event/opiates/h2
	description = SPAN_WARNING("You really want opiates!")
	happiness = 4

/datum/happiness_event/opiates/h3
	description = SPAN_DANGER("You need opiates!")
	happiness = 6

/datum/happiness_event/opiates/h4
	description = SPAN_DANGER("<big>You really need opiates!</big>")
	happiness = 8

/datum/happiness_event/opiates/h5
	description = SPAN_DANGER("<big>OH GOD! You cannot live without opiates.</big>")
	happiness = 10