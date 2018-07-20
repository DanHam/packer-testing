#!/usr/bin/env bash
#
# When the build VM is imported into Hyper-V the VM is given a new virtual
# network card. The MAC address of the new card will be different to the
# card that the VM was originally built with. This means that the MAC
# address written into the network configuration file at build time will
# now be wrong and the interface will not be brought up as intended when
# the system boots.
# This script creates a systemd unit file and ensures it is enabled. The
# unit runs just before the networking is brought up and runs a script to
# reconfigure the network interface configuration file so the MAC address
# matches that of the new interface. The UUID in the configuration file is
# also regenerated.

# Packer logging
echo "Creating systemd unit to ensure interface config contains correct MAC..."

# The upload location of the script run by the unit file is specified in the
# Packer configuration template and exported as an environment variable
SCRIPT_UPLOAD_PATH="${HVMAC_SCRIPT_UPLOAD_PATH}"
# Set the install path for the uploaded script
SCRIPT_LOCATION="/lib/systemd/system/hyperv-correct-mac-addr.sh"

# The script to configure the interface configuration file should have been
# uploaded by Packer in a previous step. Move the uploaded script into
# place and set permissions
if [ -e ${SCRIPT_UPLOAD_PATH} ]; then
    # Copy then move so we set the correct SELinux attributes
    cp ${SCRIPT_UPLOAD_PATH} ${SCRIPT_LOCATION}
    chmod u+x ${SCRIPT_LOCATION}
    rm -f ${SCRIPT_UPLOAD_PATH}
else
    echo "ERROR hyperv-correct-mac-addr script missing: ${SCRIPT_UPLOAD_PATH}"
    exit -1
fi

# Write the unit file
UNIT_FILE_LOCATION="/lib/systemd/system/hyperv-correct-mac.service"
UNIT="${UNIT_FILE_LOCATION##*/}"

printf "%s" "\
[Unit]
Description=Hyper-V: Ensure iface config contains correct MAC and renewed UUID
Before=network.target
Requires=network-pre.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=${SCRIPT_LOCATION}
ExecStop=/bin/true

[Install]
WantedBy=multi-user.target
" >${UNIT_FILE_LOCATION}

# Make systemd aware of the newly created unit
systemctl daemon-reload
# Enable the service
systemctl enable ${UNIT} >/dev/null 2>&1

exit 0
