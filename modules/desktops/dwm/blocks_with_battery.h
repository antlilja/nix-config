static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
  {"", "echo $(cat /sys/class/power_supply/BAT0/status) $(cat /sys/class/power_supply/BAT0/capacity)",	60,	0},
  {"", "wpctl get-volume @DEFAULT_SINK@ | awk -F. '{ print $NF \"%\" }'",	60,	10},
  {"", "date '+%d/%m/%Y %H:%M'",	60,	0},
};

//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
