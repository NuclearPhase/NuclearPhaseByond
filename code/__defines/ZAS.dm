//#define ZASDBG
#define MULTIZAS

#define AIR_BLOCKED 1
#define ZONE_BLOCKED 2
#define BLOCKED 3

#define ZONE_MIN_SIZE 14 //zones with less than this many turfs will always merge, even if the connection is not direct

#define CANPASS_ALWAYS 1
#define CANPASS_DENSITY 2
#define CANPASS_PROC 3
#define CANPASS_NEVER 4

#define NORTHUP (NORTH|UP)
#define EASTUP (EAST|UP)
#define SOUTHUP (SOUTH|UP)
#define WESTUP (WEST|UP)
#define NORTHDOWN (NORTH|DOWN)
#define EASTDOWN (EAST|DOWN)
#define SOUTHDOWN (SOUTH|DOWN)
#define WESTDOWN (WEST|DOWN)

//Redefinitions of the diagonal directions so they can be stored in one var without conflicts
#define N_NORTH     2
#define N_SOUTH     4
#define N_EAST      16
#define N_WEST      256
#define N_NORTHEAST 32
#define N_NORTHWEST 512
#define N_SOUTHEAST 64
#define N_SOUTHWEST 1024

#define TURF_HAS_VALID_ZONE(T) (istype(T, /turf/simulated) && T:zone && !T:zone:invalid)

#ifdef MULTIZAS

var/list/csrfz_check = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, NORTHUP, EASTUP, WESTUP, SOUTHUP, NORTHDOWN, EASTDOWN, WESTDOWN, SOUTHDOWN)
var/list/gzn_check = list(NORTH, SOUTH, EAST, WEST, UP, DOWN)

#define ATMOS_CANPASS_TURF(ret,A,B) \
	if (A.blocks_air & AIR_BLOCKED || B.blocks_air & AIR_BLOCKED) { \
		ret = BLOCKED; \
	} \
	else if (B.z != A.z) { \
		if (B.z < A.z) { \
			ret = (A.z_flags & ZM_ALLOW_ATMOS) ? ZONE_BLOCKED : BLOCKED; \
		} \
		else { \
			ret = (B.z_flags & ZM_ALLOW_ATMOS) ? ZONE_BLOCKED : BLOCKED; \
		} \
	} \
	else if (A.blocks_air & ZONE_BLOCKED || B.blocks_air & ZONE_BLOCKED) { \
		ret = (A.z == B.z) ? ZONE_BLOCKED : AIR_BLOCKED; \
	} \
	else if (A.contents.len) { \
		ret = 0;\
		for (var/thing in A) { \
			var/atom/movable/AM = thing; \
			switch (AM.atmos_canpass) { \
				if (CANPASS_ALWAYS) { \
					continue; \
				} \
				if (CANPASS_DENSITY) { \
					if (AM.density) { \
						ret |= AIR_BLOCKED; \
					} \
				} \
				if (CANPASS_PROC) { \
					ret |= AM.c_airblock(B); \
				} \
				if (CANPASS_NEVER) { \
					ret = BLOCKED; \
				} \
			} \
			if (ret == BLOCKED) { \
				break;\
			}\
		}\
	}
#else

var/list/csrfz_check = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/gzn_check = list(NORTH, SOUTH, EAST, WEST)

#define ATMOS_CANPASS_TURF(ret,A,B) \
	if (A.blocks_air & AIR_BLOCKED || B.blocks_air & AIR_BLOCKED) { \
		ret = BLOCKED; \
	} \
	else if (A.blocks_air & ZONE_BLOCKED || B.blocks_air & ZONE_BLOCKED) { \
		ret = ZONE_BLOCKED; \
	} \
	else if (A.contents.len) { \
		ret = 0;\
		for (var/thing in A) { \
			var/atom/movable/AM = thing; \
			switch (AM.atmos_canpass) { \
				if (CANPASS_ALWAYS) { \
					continue; \
				} \
				if (CANPASS_DENSITY) { \
					if (AM.density) { \
						ret |= AIR_BLOCKED; \
					} \
				} \
				if (CANPASS_PROC) { \
					ret |= AM.c_airblock(B); \
				} \
				if (CANPASS_NEVER) { \
					ret = BLOCKED; \
				} \
			} \
			if (ret == BLOCKED) { \
				break;\
			}\
		}\
	}

#endif

#define UPDATE_VALUES_SAFE(mixture) \
	mixture.total_moles = 0; \
	for(var/_g in mixture.gas) { \
		if(mixture.gas[_g] <= 0) { \
			mixture.gas -= _g; mixture.phases -= _g; \
		} \
		else { \
			mixture.total_moles += mixture.gas[_g]; \
			if(!mixture.phases[_g]) mixture.phases[_g] = FLUID_PHASE_GAS; \
		} \
	}

#define UPDATE_VALUES(mixture) \
	UPDATE_VALUES_SAFE(mixture) \
	if(GLOB.fluid_data) {\
		UPDATE_HEAT_CAPACITY(mixture) \
		mixture.handle_fluids_phase_transition(); \
	}

#define DIVIDE_MIXTURE(mixture, factor) \
	for(var/_g in mixture.gas) { \
		mixture.gas[_g] /= factor; \
	} \
	UPDATE_VALUES(mixture)

#define MULTIPLY_MIXTURE(mixture, factor) \
	for(var/_g in mixture.gas) { \
		mixture.gas[_g] *= factor; \
	} \
	UPDATE_VALUES(mixture)

#define SUBSTRACT_MIXTURE(mixture, rtexture) \
	for(var/_g in mixture.gas) { \
		mixture.gas[_g] -= rtexture.gas[_g]; \
	} \
	UPDATE_VALUES(mixture)

#define COPY_MIXTURE(destmixture, srcmixture) \
	destmixture.gas = srcmixture.gas.Copy(); \
	destmixture.temperature = srcmixture.temperature; \
	UPDATE_VALUES(destmixture)

#define UPDATE_HEAT_CAPACITY(mixture) \
	mixture.heat_capacity = 0; \
	for(var/_g in mixture.gas) { \
		var/datum/xgm_fluid/_data = GLOB.fluid_data[_g]; \
		mixture.heat_capacity += (_data.specific_heat * mixture.gas[_g] + (mixture.temperature * 0.5) + (RETURN_PARTIAL_PRESSURE(mixture, _g) * 0.00001)) * mixture.phases[_g]; \
	} \
	mixture.heat_capacity *= mixture.group_multiplier;

#define RETURN_PRESSURE(mixture) (mixture.volume ? ((mixture.total_moles * R_IDEAL_GAS_EQUATION * mixture.temperature) / mixture.volume) : 0)

// returns Pa
#define RETURN_PARTIAL_PRESSURE(mixture, gasid) ((mixture.gas[gasid] / mixture.total_moles) * (RETURN_PRESSURE(mixture) * (1 KPA)))


#define ADJUST_FLUID(mixture, id, moles) mixture.gas[id] += moles / mixture.group_multiplier;
#define ADJUST_FLUID_UPDATE(mixture, id, moles) \
	ADJUST_FLUID(mixture, id, moles) \
	UPDATE_VALUES(mixture)