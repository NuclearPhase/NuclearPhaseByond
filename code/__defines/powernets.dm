#define POWERNET_WATTAGE(powernet) (powernet.voltage ? min(powernet.lavailable, powernet.ldemand) : 0)
#define POWERNET_AMPERAGE(powernet) (powernet.voltage ? (min(powernet.lavailable, powernet.ldemand) / powernet.voltage) : 0)
#define POWERNET_HEAT(powernet, resistance) POWER2HEAT(POWERNET_AMPERAGE(powernet) ** 2 * (resistance))