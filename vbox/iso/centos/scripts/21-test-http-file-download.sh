#!/usr/bin/env bash
#
# Set verbose/quiet output based on env var configured in Packer template
[[ "${DEBUG}" = true ]] && REDIRECT="/dev/stdout" || REDIRECT="/dev/null"

FILE_NAME="random.txt"
SOURCE_FILE="${PACKER_HTTP_ADDR}/${FILE_NAME}"
TARGET_FILE="/${FILE_NAME}"

echo "The source file is at ${SOURCE_FILE}"
echo "Downloading file..."
curl -sSL ${SOURCE_FILE} > ${TARGET_FILE}

echo "Calculating md5 sum and comparing..."
SOURCE_FILE_MD5="c3b62a675989c760fb3ae743444e926e"
TARGET_FILE_MD5="$(md5sum ${TARGET_FILE} | cut -d' ' -f1)"

if [ "${SOURCE_FILE_MD5}" != "${TARGET_FILE_MD5}" ]; then
    echo "ERROR: The md5sum of the downloaded file is wrong"
else
    echo "GREAT: The md5sum of the downloaded file is good!"
fi

echo -e "Complete\n"

exit 0
