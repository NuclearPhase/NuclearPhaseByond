#define POWERNET_AMPERAGE(powernet) (powernet.voltage ? min(powernet.avail, powernet.viewload / powernet.voltage) : 0)
#define POWERNET_WATTAGE(powernet) (POWERNET_AMPERAGE(powernet) * powernet.voltage)
#define POWERNET_HEAT(powernet, resistance) POWER2HEAT(POWERNET_AMPERAGE(powernet) ** 2 * (resistance))