#!/usr/bin/env bash
set -Eeuo pipefail

if [ ! -e /var/www/html/index.php ] && [ ! -e /var/www/html/wp-includes/version.php ]; then
    cp -rf /usr/src/wordpress/* /var/www/html/
    echo >&2 "Complete! WordPress has been successfully copied to $PWD"
fi


if [[ "$1" == apache2* ]] || [ "$1" = 'php-fpm' ]; then
        uid="$(id -u)"
        gid="$(id -g)"
        if [ "$uid" = '0' ]; then
                case "$1" in
                        apache2*)
                                user="${APACHE_RUN_USER:-www-data}"
                                group="${APACHE_RUN_GROUP:-www-data}"

                                # strip off any '#' symbol ('#1000' is valid syntax for Apache)
                                pound='#'
                                user="${user#$pound}"
                                group="${group#$pound}"
                                ;;
                        *) # php-fpm
                                user='www-data'
                                group='www-data'
                                ;;
                esac
        else
                user="$uid"
                group="$gid"
        fi
        wpEnvs=( "${!WORDPRESS_@}" )
        if [ ! -s wp-config.php ] && [ "${#wpEnvs[@]}" -gt 0 ]; then
                for wpConfigDocker in \
                        /usr/src/wp-config.php \
                        /var/www/html/wp-config.php \
                ; do
                        if [ -s "$wpConfigDocker" ]; then
                                echo >&2 "No 'wp-config.php' found in $PWD, but 'WORDPRESS_...' variables supplied; copying '$wpConfigDocker' (${wpEnvs[*]})"
                                # using "awk" to replace all instances of "put your unique phrase here" with a properly unique string (for AUTH_KEY and friends to have safe defaults if they aren't specified with >                                
                                awk '
                                        /put your unique phrase here/ {
                                                cmd = "head -c1m /dev/urandom | sha1sum | cut -d\\  -f1"
                                                cmd | getline str
                                                close(cmd)
                                                gsub("put your unique phrase here", str)
                                        }
                                        { print }
                                ' "$wpConfigDocker" > /var/www/html/wp-config.php
                                if [ "$uid" = '0' ]; then
                                        # attempt to ensure that wp-config.php is owned by the run user
                                        # could be on a filesystem that doesn't allow chown (like some NFS setups)
                                        chown "$user:$group" /var/www/html/* || true
                                fi
                                break
                        fi
                done
        fi
fi
exec "$@"
