#!/bin/ash
set -e

# run passwordfile generator
sh /passwordfile-generator.sh

if [ $GENERATE_SELF_SIGNED_CERTS == 1 ]
	then
	# run ssl certs generator
	sh /certs-generator.sh
fi

# Set permissions
user="$(id -u)"
if [ "$user" = '0' ]; then
	[ -d "/mosquitto" ] && chown -R mosquitto:mosquitto /mosquitto || true
fi

exec "$@"