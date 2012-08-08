#!/usr/local/bin/bash
#
## SCRIPT TO START PERIODIC CHECKS AND EXCHANGE DOMU-ID

LANG="C"
export LANG

action()
{
    descr=$1 ; shift
    cmd=$@
    echo -n "$descr "
    $cmd
    ret=$?
    if [ $ret -eq 0 ] ; then
	echo "OK"
    else
	echo "Failed"
    fi
    return $ret
}

XE_LINUX_DISTRIBUTION=/usr/local/sbin/xe-linux-distribution
XE_LINUX_DISTRIBUTION_CACHE=/var/cache/xe-linux-distribution
XE_DAEMON=/usr/local/sbin/xe-daemon
XE_DAEMON_PIDFILE=/var/run/xe-daemon.pid

if [ ! -x "${XE_LINUX_DISTRIBUTION}" ] ; then
    exit 0
fi

start()
{
    action $"Detecting Operating system:" \
	${XE_LINUX_DISTRIBUTION} ${XE_LINUX_DISTRIBUTION_CACHE}

    action $"Starting xe daemon: " /usr/bin/true
    mkdir -p $(dirname ${XE_DAEMON_PIDFILE})
    # This is equivalent to daemon() in C
    ( exec &>/dev/null ; ${XE_DAEMON} -p ${XE_DAEMON_PIDFILE} & )
}

stop()
{
    action $"Stopping xe daemon: "   kill -TERM $(cat ${XE_DAEMON_PIDFILE})
}

case "$1" in
  start)
        start
        ;;
  stop)
	stop
	;;
  force-reload|restart)
	stop
	start
	;;
  *)
        # do not advertise unreasonable commands that there is no reason
        # to use with this device
        echo $"Usage: $0 start|restart"
        exit 1
esac

exit $?
