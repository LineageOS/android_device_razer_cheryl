#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

import extract_utils.tools

extract_utils.tools.DEFAULT_PATCHELF_VERSION = '0_9'

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

blob_fixups: blob_fixups_user_type = {
    (
        'system_ext/lib/com.qualcomm.qti.ant@1.0.so',
        'system_ext/lib64/com.qualcomm.qti.ant@1.0.so',
        'vendor/bin/hw/android.hardware.bluetooth@1.0-service-qti',
    ): blob_fixup()
        .replace_needed('libhidlbase.so', 'libhidlbase-v32.so'),
    'system_ext/lib64/lib-imscamera.so': blob_fixup()
        .add_needed('libgui_shim.so'),
    'system_ext/lib64/lib-imsvideocodec.so': blob_fixup()
        .add_needed('libgui_shim.so')
        .replace_needed('libqdMetaData.so', 'libqdMetaData.system.so'),
    'vendor/lib/hw/camera.msm8998.so': blob_fixup()
        .remove_needed('android.hidl.base@1.0.so'),
    'vendor/lib/libdczoom.so': blob_fixup()
        .add_needed('libui_shim.so')
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    'vendor/lib/libfusionLibrary.so': blob_fixup()
        .add_needed('libui_shim.so'),
    (
        'vendor/lib/libchromaflash.so',
        'vendor/lib/libdualcameraddm.so',
        'vendor/lib/libmmcamera_hdr_gb_lib.so',
        'vendor/lib/liboptizoom.so',
        'vendor/lib/libseemore.so',
        'vendor/lib/libtrueportrait.so',
    ): blob_fixup()
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    'vendor/lib/libmmcamera_interface.so': blob_fixup()
        .sig_replace('01 28 18 BF', 'FF'),
    'vendor/lib64/libril-qc-hal-qmi.so': blob_fixup()
        .replace_needed('android.hardware.radio.config@1.0.so', 'android.hardware.radio.c_shim@1.0.so')
        .replace_needed('android.hardware.radio.config@1.1.so', 'android.hardware.radio.c_shim@1.1.so')
        .replace_needed('android.hardware.radio.config@1.2.so', 'android.hardware.radio.c_shim@1.2.so'),
    'vendor/lib64/libwvhidl.so': blob_fixup()
        .add_needed('libcrypto_shim.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'cheryl',
    'razer',
    blob_fixups=blob_fixups,
    add_firmware_proprietary_file=True,
    check_elf=False,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
