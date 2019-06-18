#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE=cheryl
VENDOR=razer

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

LINEAGE_ROOT="${MY_DIR}"/../../..

HELPER="${LINEAGE_ROOT}/vendor/lineage/build/tools/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
    vendor/etc/permissions/qti-vzw-ims-internal.xml)
        sed -i 's|/system/vendor/framework/qti-vzw-ims-internal.jar|/vendor/framework/qti-vzw-ims-internal.jar|g' "${2}"
        ;;
    vendor/etc/permissions/qcrilhook.xml)
        sed -i 's|/system/framework/qcrilhook.jar|/vendor/framework/qcrilhook.jar|g' "${2}"
        ;;
    vendor/lib/libdczoom.so)
        patchelf --remove-needed "libandroid.so" "${2}"
        patchelf --remove-needed "libgui.so" "${2}"
        ;;
    vendor/lib64/lib-dplmedia.so)
        patchelf --remove-needed "libmedia.so" "${2}"
        ;;
    vendor/etc/init/com.qualcomm.qti.wifidisplayhal@1.0-service.rc)
        sed -i "/ disabled/Q" "${2}"
        ;;
    vendor/lib/libaudcal.so)
        sed -i "s|\/data\/vendor\/misc\/audio\/acdbdata\/delta\/|\/data\/vendor\/audio\/acdbdata\/delta\/\x00\x00\x00\x00\x00|g" "${2}"
        ;;
    vendor/lib/libmmcamera_ppeiscore.so)
        patchelf --remove-needed "libgui.so" "${2}"
        ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${LINEAGE_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" \
        "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
