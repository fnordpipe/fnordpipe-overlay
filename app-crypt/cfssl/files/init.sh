#!/sbin/openrc-run
# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

depend() {
  need net
  before nginx
}

start() {
  start-stop-daemon --start --make-pidfile --pidfile /run/cfssl.pid --chdir /var/lib/cfssl --background --quiet --user cfssl:cfssl --exec cfssl -- serve -ca-key rootca-key.pem -ca rootca.pem -config /etc/cfssl/config.json
  eend $?
}

stop() {
  start-stop-daemon --stop --pidfile /run/cfssl.pid
  eend $?
}
