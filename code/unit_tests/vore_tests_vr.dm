/datum/unit_test/belly_nonsuffocation
	name = "MOB: human mob does not suffocate in a belly"
	var/startLifeTick
	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey
	async = 1

/datum/unit_test/belly_nonsuffocation/start_test()
	pred = create_test_mob()
	if(!istype(pred))
		return 0
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return 0

	return 1

/datum/unit_test/belly_nonsuffocation/check_result()
	// Unfortunately we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return 0

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		fail("[pred] has no vore_selected.")
		return 1
	
	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)
		
		if(prey.loc != pred.vore_selected)
			fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return 1
	
		// Okay, we succeeded in eating them, now lets wait a bit
		startLifeTick = pred.life_tick
		startOxyloss = prey.getOxyLoss()
		return 0
	
	if(pred.life_tick < (startLifeTick + 10))
		return 0 // Wait for them to breathe a few times

	// Alright lets check it!
	endOxyloss = prey.getOxyLoss()
	if(startOxyloss < endOxyloss)
		fail("Prey takes oxygen damage in a pred's belly! (Before: [startOxyloss]; after: [endOxyloss])")
	else
		pass("Prey is not taking oxygen damage in pred's belly. (Before: [startOxyloss]; after: [endOxyloss])")

	qdel(prey)
	qdel(pred)
	return 1
////////////////////////////////////////////////////////////////
/datum/unit_test/belly_spacesafe
	name = "MOB: human mob protected from space in a belly"
	var/startLifeTick
	var/startOxyloss
	var/endOxyloss
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey
	async = 1

/datum/unit_test/belly_spacesafe/start_test()
	pred = create_test_mob()
	if(!istype(pred))
		return 0
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return 0

	return 1

/datum/unit_test/belly_spacesafe/check_result()
	// Unfortunately we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return 0

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		fail("[pred] has no vore_selected.")
		return 1
	
	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)
		
		if(prey.loc != pred.vore_selected)
			fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return 1
		else
			var/turf/T = locate(/turf/space)
			if(!T)
				fail("could not find a space turf for testing")
				return 1
			else
				pred.forceMove(T)

		// Okay, we succeeded in eating them, now lets wait a bit
		startLifeTick = pred.life_tick
		startOxyloss = prey.getOxyLoss()
		return 0
	
	if(pred.life_tick < (startLifeTick + 10))
		return 0 // Wait for them to breathe a few times

	// Alright lets check it!
	endOxyloss = prey.getOxyLoss()
	if(startOxyloss < endOxyloss)
		fail("Prey takes oxygen damage in space! (Before: [startOxyloss]; after: [endOxyloss])")
	else
		pass("Prey is not taking oxygen damage in space. (Before: [startOxyloss]; after: [endOxyloss])")

	qdel(prey)
	qdel(pred)
	return 1
////////////////////////////////////////////////////////////////
/datum/unit_test/belly_damage
	name = "MOB: human mob takes damage from digestion"
	var/startLifeTick
	var/startBruteBurn
	var/endBruteBurn
	var/mob/living/carbon/human/pred
	var/mob/living/carbon/human/prey
	async = 1

/datum/unit_test/belly_damage/start_test()
	pred = create_test_mob()
	if(!istype(pred))
		return 0
	prey = create_test_mob(pred.loc)
	if(!istype(prey))
		return 0

	return 1

/datum/unit_test/belly_damage/check_result()
	// Unfortunately we need to wait for the pred's belly to initialize. (Currently after a spawn())
	if(!pred.vore_organs || !pred.vore_organs.len)
		return 0

	// Now that pred belly exists, we can eat the prey.
	if(!pred.vore_selected)
		fail("[pred] has no vore_selected.")
		return 1
	
	// Attempt to eat the prey
	if(prey.loc != pred.vore_selected)
		pred.vore_selected.nom_mob(prey)
		
		if(prey.loc != pred.vore_selected)
			fail("[pred.vore_selected].nom_mob([prey]) did not put prey inside [pred]")
			return 1
	
		// Okay, we succeeded in eating them, now lets wait a bit
		pred.vore_selected.digest_mode = DM_DIGEST
		startLifeTick = pred.life_tick
		startBruteBurn = prey.getBruteLoss() + prey.getFireLoss()
		return 0
	
	if(pred.life_tick < (startLifeTick + 10))
		return 0 // Wait a few ticks for damage to happen

	// Alright lets check it!
	endBruteBurn = prey.getBruteLoss() + prey.getFireLoss()
	if(startBruteBurn >= endBruteBurn)
		fail("Prey doesn't take damage in digesting belly! (Before: [startBruteBurn]; after: [endBruteBurn])")
	else
		pass("Prey is taking damage in pred's belly. (Before: [startBruteBurn]; after: [endBruteBurn])")

	qdel(prey)
	qdel(pred)
	return 1
