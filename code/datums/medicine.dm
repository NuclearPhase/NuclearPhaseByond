/datum/organ_disease
    var/name
    var/strength = 20
    var/max_strength = 40
    var/dstrength = 1
    var/gone_level = 0

/datum/organ_disease/proc/update()
    return

/datum/organ_disease/proc/can_gone()
    return strength <= gone_level

/datum/organ_disease/infarct
    dstrength = 0.05

/datum/organ_disease/infarct/update()
    strength = between(0, strength + dstrength, max_strength)