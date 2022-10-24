#!/bin/sh

echo "🎬 entrypoint.sh: [$(whoami)] [PHP $(php -r 'echo phpversion();')]"

echo "🎬 start supervisord"

supervisord -c /supervisor.conf
