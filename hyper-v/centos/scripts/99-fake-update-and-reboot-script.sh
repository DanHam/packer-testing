#!/usr/bin/env bash
#
# Fake script pretending to update installed packages and initiate system
# restart as required

# Pretend we are doing some updates
echo "Hello friend... I'm pretending to do some updates here..."
echo "Actually, I'm gonna take a snooze instead"
sleep 5
echo "OK, enough of that..."
REBOOT=1

# Reboot if required
if [ $REBOOT == 1 ]; then
    echo "System restart required post install of updates. Rebooting..."
    # Give time for the output to be logged/sent back to Packer
    sleep 1 # ... ok, so it's pretty quick!
    # nohup prevents freezes in Packer due to execution moving to the next
    # script while a reboot is in progress. This should be coupled with a
    # "pause_before" stanza for the next provisioner in the Packer
    # to guarantee the required behaviour.
    nohup shutdown --reboot now </dev/null >/dev/null 2>&1 &
fi

exit 0
