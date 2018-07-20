#!/usr/bin/env bash
#
# Script to ensure the MAC address configured in each interface
# configuration file under /etc/sysconfig/network-scripts matches the MAC
# address obtained by querying /sys. If the MAC address needs to be
# corrected then the UUID contained in the file is also regenerated.

# Get the list of interfaces (excluding lo)
INTERFACES="$(ls -1 /sys/class/net | grep -v lo)"

# Loop over all interfaces and correct the MAC address in the config file
# if it differs from the MAC address we get by querying /sys
CONFIG_ROOT="/etc/sysconfig/network-scripts"
for INTERFACE in ${INTERFACES}; do
    # Skip to next interface if there is no associated config file
    CONFIG_FILE="${CONFIG_ROOT}/ifcfg-${INTERFACE}"
    if [ ! -e ${CONFIG_FILE} ]; then
        continue
    fi

    # Get the MAC address of the interface by querying /sys
    MAC_ADDR="$(cat /sys/class/net/${INTERFACE}/address | \
                tr '[:lower:]' '[:upper:]')"

    # Get the MAC address from the interface config file
    CONFIG_MAC_ADDR="$(sed -n 's/^HWADDR="\(.*\)"/\1/p' ${CONFIG_FILE})"

    # If the addresses match the config is good
    if [ ${MAC_ADDR} == ${CONFIG_MAC_ADDR} ]; then
        continue
    fi

    # Delete old comments
    sed -i "/^#/d" ${CONFIG_FILE}
    sed -i "1s/^/# Updated by ${BASH_SOURCE[0]##*\/}\n/" ${CONFIG_FILE}
    # Set the correct MAC for the interface in the config file
    sed -i "s/\(^HWADDR=\"\).*\(\"\)/\1${MAC_ADDR}\2/" ${CONFIG_FILE}
    # If the MAC address needed updating we should also update the UUID
    sed -i "s/\(^UUID=\"\).*\(\"\)/\1$(uuidgen)\2/" ${CONFIG_FILE}
done

exit 0
