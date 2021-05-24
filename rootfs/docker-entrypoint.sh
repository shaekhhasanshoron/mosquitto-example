#!/bin/ash
set -e

# run passwordfile generator
sh /passwordfile-generator.sh

# run ssl certs generator
# sh /certs-generator.sh

# Set permissions
user="$(id -u)"
if [ "$user" = '0' ]; then
	[ -d "/mosquitto" ] && chown -R mosquitto:mosquitto /mosquitto || true
fi

exec "$@"