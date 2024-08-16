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
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/razer/cheryl',
    'hardware/qcom-caf/msm8998',
    'hardware/qcom-caf/wlan',
    'vendor/qcom/opensource/dataservices',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'com.qualcomm.qti.dpm.api@1.0',
        'vendor.qti.imsrtpservice@3.0',
    ): lib_fixup_vendor_suffix,
    (
    ): lib_fixup_remove,
}

blob_fixups: blob_fixups_user_type = {
    (
        'system_ext/lib/com.qualcomm.qti.ant@1.0.so',
        'system_ext/lib64/com.qualcomm.qti.ant@1.0.so',
        'vendor/bin/hw/android.hardware.bluetooth@1.0-service-qti',
        'vendor/lib64/com.qualcomm.qti.ant@1.0.so',
        'vendor/lib64/vendor.qti.hardware.fm@1.0.so',
    ): blob_fixup()
        .replace_needed('libhidlbase.so', 'libhidlbase-v32.so'),
    'system_ext/lib64/lib-imscamera.so': blob_fixup()
        .add_needed('libgui_shim.so'),
    'system_ext/lib64/lib-imsvideocodec.so': blob_fixup()
        .add_needed('libgui_shim.so')
        .replace_needed('libqdMetaData.so', 'libqdMetaData.system.so'),
    'vendor/bin/hw/android.hardware.drm@1.1-service.widevine': blob_fixup()
        .replace_needed('libhidltransport.so', 'libhidlbase.so')
        .remove_needed('libhwbinder.so'),
    'vendor/lib/hw/camera.msm8998.so': blob_fixup()
        .remove_needed('android.hidl.base@1.0.so'),
    'vendor/lib/libdczoom.so': blob_fixup()
        .add_needed('libui_shim.so')
        .replace_needed('libstdc++.so', 'libstdc++_vendor.so'),
    'vendor/lib/libfusionLibrary.so': blob_fixup()
        .fix_soname()
        .add_needed('libui_shim.so'),
    (
        'vendor/lib/libdualcameraddm.so',
        'vendor/lib/libmmcamera_hdr_gb_lib.so',
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
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
