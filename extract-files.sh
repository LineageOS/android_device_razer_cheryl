#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=cheryl
VENDOR=razer

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

KANG=
SECTION=

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
        system_ext/etc/init/dpmd.rc)
            sed -i "s|/system/product/bin/|/system/system_ext/bin/|g" "${2}"
            ;;
        system_ext/etc/permissions/com.qti.dpmframework.xml | system_ext/etc/permissions/dpmapi.xml)
            sed -i "s|/system/product/framework/|/system/system_ext/framework/|g" "${2}"
            ;;
        system_ext/etc/permissions/qcrilhook.xml)
            sed -i 's|/product/framework/qcrilhook.jar|/system/system_ext/framework/qcrilhook.jar|g' "${2}"
            ;;
        system_ext/lib64/lib-imscamera.so)
            for LIBGUI_SHIM in $(grep -L "libgui_shim.so" "${2}"); do
                "${PATCHELF}" --add-needed "libgui_shim.so" "${LIBGUI_SHIM}"
            done
            ;;
        system_ext/lib64/lib-imsvideocodec.so)
            for LIBGUI_SHIM in $(grep -L "libgui_shim.so" "${2}"); do
                "${PATCHELF}" --add-needed "libgui_shim.so" "${LIBGUI_SHIM}"
            done
            for LIBUI_SHIM in $(grep -L "libui_shim.so" "${2}"); do
                "${PATCHELF}" --add-needed "libui_shim.so" "$LIBUI_SHIM"
            done
            ;;
        system_ext/lib64/libdpmframework.so)
            for LIBDPM_SHIM in $(grep -L "libshim_dpmframework.so" "${2}"); do
                "${PATCHELF}" --add-needed "libshim_dpmframework.so" "$LIBDPM_SHIM"
            done
            ;;
        vendor/lib/hw/camera.msm8998.so)
            "${PATCHELF}" --remove-needed "android.hidl.base@1.0.so" "${2}"
            ;;
        vendor/lib/libdczoom.so)
            for LIBUI_SHIM2 in $(grep -L "libui_shim.so" "${2}"); do
                "${PATCHELF}" --add-needed "libui_shim.so" "$LIBUI_SHIM2"
            done
            ;;
        vendor/lib/libfusionLibrary.so)
            for LIBUI_SHIM3 in $(grep -L "libui_shim.so" "${2}"); do
                "${PATCHELF}" --add-needed "libui_shim.so" "$LIBUI_SHIM3"
            done
            ;;
        vendor/lib/libmmcamera_interface.so)
            "${SIGSCAN}" -p "01 28 18 BF" -P "FF" -f "${2}"
            ;;
    esac
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
