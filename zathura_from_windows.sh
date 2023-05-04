#!/bin/bash

# A helper script to run zathura with synctex forward search directly from
# Windows PowerShell via `wsl -- ~/.zathura_from_windows`

# This is the same as the corresponding edit in .bashrc
# For some reason, just sourcing ~/.bashrc won't work
# But this is better anyways, since really we need only the dbus
DBUS_SESSION_BUS_ADDRESS=
if [ -r ~/.dbus/session-bus/* ]
then
	source ~/.dbus/session-bus/*
	if ! $(ps -Flww -p $DBUS_SESSION_BUS_PID | grep -q dbus-daemon)
	then
		DBUS_SESSION_BUS_ADDRESS=
	fi
fi
if [[ -z $DBUS_SESSION_BUS_ADDRESS ]]
then
	# Note: it looks like this launches two dbus-daemon instances, though I
	# have no idea why. It seems that there are persistently only two (no
	# additional spawns when logging out and back in (closing WSL and
	# opening new), etc. So this seems to be fine for now.
	dbus-launch >/dev/null
	source ~/.dbus/session-bus/*
fi
export DBUS_SESSION_BUS_ADDRESS

# the .synctex.gz is written by pdflatex on the system where it runs; so all
# the paths contained will have the corresponding format, i.e. Windows paths
# for the use cases of this script. If we can find a .synctex.gz for the .pdf
# we are looking at, adjust those paths
for arg in "$@"
do
	if [[ ${arg:(-4):4} == '.pdf' ]]
	then
		synctex_filename=${arg:0:$((${#arg}-4))}.synctex
		synctex_filename_gz=${synctex_filename}.gz
		synctex_is_gz=[ -r "$synctex_filename_gz"]
		if $synctex_is_gz
		then
			gunzip -f "$synctex_filename_gz"
		fi

		if [ -r "$synctex_filename" ]
		then
			# adjust all paths (identified as everything following "[A-Z]:\")
			vim -es -c 'g+[A-Z]:\\+s+\\+/+g' -c 'g+[A-Z]:/+s+\([A-Z]\):/+/mnt/\L\1/+' +wq "$synctex_filename"

			if $synctex_is_gz
			then
				gzip -f "$synctex_filename"
			fi
		fi

		unset synctex_filename synctex_filename_gz synctex_is_gz
	fi
done

# Finally: run zathura
zathura "$@"
