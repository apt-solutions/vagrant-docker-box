#!/usr/bin/env bash

wpurl=$1
searchstring="{{{wordpress_siteurl}}}"
searchfile="./.data/wordpress/wp-config.php"

# i am not sure why but sometimes the replacement of the wordpress config parameters fails
# in this case just sleep 1 second and try again.
# i think this is due to docker-compose need a moment or so to setup/bind the volumes ...
i=0
while
  i="$((i+1))"

  if [ ! -f "$searchfile" ]; then
    # searchfile does not exists
    sleep 1s
    continue
  fi

	# Update wp-config.php: Set new "WP_SITEURL" and "WP_HOME" definitions with the new given port.
	sudo sed -i "s#$searchstring#$wpurl#g" "$searchfile"

	occurences=$(cat "$searchfile" | grep -e "$searchstring" )

	if [ -n "$occurences" ]; then
		# the searchstring still exists in the search file
	  sleep 1s
	  continue
	fi

  # prevent endless loops!
  if [ "$i" -ge 10 ]; then
    # reset port to empty string indicating error (no usable open port found)
    port=""
    break
  fi
do :; done

occurences=$(cat "$searchfile" | grep -e "$searchstring" )

if [ -n "$occurences" ]; then
  echo "unable to replace wp-config.php parameters."
  exit
fi

# Looks like wordpress need a call of the site to process the new "WP_SITEURL" and "WP_HOME" definitions
# This very first call fails with a redirect to the current set site_url.
# Therefore just do this call once in the background so that the user does not experience this "fail"
wget "$wpurl" 1> /dev/null 2>&1

echo "0"
