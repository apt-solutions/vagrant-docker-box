#!/usr/bin/env sh

# url to this demo instance
wpurl=$1
# absolute path to the demo docker dontainer
wdir=$2
# url to ping evalsoft this demo is alive
pingAliveUrl=$3

searchstring="{{{wordpress_siteurl}}}"
searchfile="$wdir"".data/wordpress/wp-config.php"

pluginsearch="{{{demo_ping_alive_url}}}"
pluginfile="$wdir"".data/wordpress/wp-content/plugins/evalsoft_activity/evalsoft_activity.php"

chown -R www-data:www-data "$wdir"".data/wordpress"

# i am not sure why but sometimes the replacement of the wordpress config parameters fails
# in this case just sleep 1 second and try again.
# i think this is due to docker-compose need a moment or so to setup/bind the volumes ...
i=0
while [ "$i" -le 10 ]
do
  i="$((i+1))"

  if [ ! -f "$searchfile" ]; then
    # searchfile does not exists
    sleep 1s
    continue
  fi

  # Update wp-config.php: Set new "WP_SITEURL" and "WP_HOME" definitions with the new given port.
  sed -i "s#$searchstring#$wpurl#g" "$searchfile"

  occurences=$(cat "$searchfile" | grep -e "$searchstring" )

  if [ -n "$occurences" ]; then
    # the searchstring still exists in the search file
    sleep 1s
    continue

  else
    break

  fi

done

occurences=$(cat "$searchfile" | grep -e "$searchstring" )

if [ -n "$occurences" ]; then
  echo "unable to replace wp-config.php parameters."
  exit
fi

# replace "demo ping alive url" in the wordpress plugin file
sed -i "s#$pluginsearch#$pingAliveUrl#g" "$pluginfile"

# Looks like wordpress need a call of the site to process the new "WP_SITEURL" and "WP_HOME" definitions
# This very first call fails with a redirect to the current set site_url.
# Therefore just do this call once in the background so that the user does not experience this "fail"
curl --get "$wpurl" --connect-timeout 10 1> /dev/null 2>&1

echo "0"
