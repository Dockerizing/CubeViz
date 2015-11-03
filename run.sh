#!/bin/bash

VOSCMD=/usr/bin/virtuoso-t
CONFIG=virtuoso.ini

# configure virtuoso
if [ -f ${CONFIG} ]; then
    echo "Reuse existing virtuoso.ini in database directory"
else
    echo -n "Copy default virtuoso.ini to database directory (because none exists) …"
    cp /virtuoso.ini.dist ${CONFIG}
    if [ ! -z ${BUFFERS} ]; then
        echo "Adjusting VOS disk buffers to: $BUFFERS"
        perl -pi -e "s/^\s*(NumberOfBuffers\s+=\s+)\d+.*$/\1 ${BUFFERS}/" ${CONFIG}
        let 'MAX_DIRTY = 6 * BUFFERS / 10'
        perl -pi -e "s/^\s*(MaxDirtyBuffers\s+=\s+)\d+.*$/\1 ${MAX_DIRTY}/" ${CONFIG}
    fi

    grep -i serverport ${CONFIG}
    echo " (done)"
fi

# allowing for clean shutdown of background jobs if virtuoso is terminated
cleanup () {
  echo "Stopping virtuoso..."
  [[ -n $vospid ]] && kill -TERM "$vospid"

  exit 0
}

trap 'cleanup' INT TERM

# change password
echo "Setting virtuoso dba password."
${VOSCMD} +configfile ${CONFIG} +foreground +pwdold dba +pwddba ${PWDDBA}

# Start server
echo "Starting virtuoso..."
${VOSCMD} +configfile ${CONFIG} &
vospid=$!
