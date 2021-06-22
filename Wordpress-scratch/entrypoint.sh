#!/usr/bin/env bash

# set -Eeuo pipefail
# wpEnvs=( "${!WORDPRESS_@}" )
# if [ ! -s /var/www/html/wp-config.php ] && [ "${#wpEnvs[@]}" -gt 0 ]; then
#     for wpConfigDocker in \
#         /var/www/html/wp-config.php \
#         /usr/src/wp-config.php \
#     ; do
#         if [ -s "$wpConfigDocker" ]; then
#             echo >&2 "No 'wp-config.php' found in $PWD, but 'WORDPRESS_...' variables supplied; copying '$wpConfigDocker' (${wpEnvs[*]})"
#             # using "awk" to replace all instances of "put your unique phrase here" with a properly unique string (for AUTH_KEY and friends to have safe defaults if they aren't specified with environment variables)
#             awk '
#                 /put your unique phrase here/ {
#                     cmd = "head -c1m /dev/urandom | sha1sum | cut -d\\  -f1"
#                     cmd | getline str
#                     close(cmd)
#                     gsub("put your unique phrase here", str)
#                 }
#                 { print }
#             ' "$wpConfigDocker" > /var/www/html/wp-config.php
#             if [ "$uid" = '0' ]; then
#                 chown www-data:www-data /var/www/html/wp-config.php || true
#             fi
#             break
#         fi
#     done
# fi

if [ ! -e /var/www/html/index.php ] && [ ! -e /var/www/html/wp-includes/version.php ]; then
    cp -rf /usr/src/wordpress/* /var/www/html/
    echo >&2 "Complete! WordPress has been successfully copied to $PWD"
fi
if [ ! -e /var/www/html/wp-config.php ]; then
    cp /usr/src/wp-config.php /var/www/html/
fi
exec "$@"