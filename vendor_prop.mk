#
# Copyright (C) 2018-2019 The LineageOS Project
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

# Audio
PRODUCT_PROPERTY_OVERRIDES += \
    af.fast_track_multiplier=1 \
    audio.deep_buffer.media=true \
    audio.offload.video=true \
    audio.safemedia.force=true \
    persist.vendor.audio.fluence.audiorec=false \
    persist.vendor.audio.fluence.speaker=true \
    persist.vendor.audio.fluence.voicecall=true \
    persist.vendor.audio.fluence.voicerec=false \
    persist.vendor.audio.ras.enabled=false \
    persist.vendor.bt.a2dp_offload_cap=sbc-aac \
    ro.vendor.audio.sdk.fluencetype=fluence \
    ro.vendor.audio.sdk.ssr=false \
    vendor.audio.dolby.ds2.enabled=false \
    vendor.audio.dolby.ds2.hardbypass=false \
    vendor.audio.flac.sw.decoder.24bit=true \
    vendor.audio.hw.aac.encoder=true \
    vendor.audio.noisy.broadcast.delay=600 \
    vendor.audio.offload.buffer.size.kb=32 \
    vendor.audio.offload.gapless.enabled=true \
    vendor.audio.offload.multiaac.enable=true \
    vendor.audio.offload.multiple.enabled=false \
    vendor.audio.offload.passthrough=false \
    vendor.audio.offload.pstimeout.secs=3 \
    vendor.audio.offload.track.enable=true \
    vendor.audio.parser.ip.buffer.size=262144 \
    vendor.audio.safx.pbe.enabled=true \
    vendor.audio.tunnel.encode=false \
    vendor.audio.use.sw.alac.decoder=true \
    vendor.audio.use.sw.ape.decoder=true \
    vendor.audio_hal.period_size=192 \
    vendor.fm.a2dp.conc.disabled=true

# Bluetooth
PRODUCT_PROPERTY_OVERRIDES += \
    qcom.bluetooth.soc=cherokee \
    ro.bt.bdaddr_path=/proc/bt_mac

# Camera
PRODUCT_PROPERTY_OVERRIDES += \
    persist.camera.gyro.android=2 \
    persist.camera.gyro.disable=0 \
    vendor.camera.aux.packagelist=com.razerzone.camera \
    vidc.enc.dcvs.extra-buff-count=2

# Display
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.latch_unsignaled=0 \
    persist.metadata_dynfps.disable \
    ro.opengles.version=196610 \
    ro.sf.lcd_density=560

# FRP
PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/platform/soc/1da4000.ufshc/by-name/frp

# Keys
PRODUCT_PROPERTY_OVERRIDES += \
    qemu.hw.mainkeys=0

# Media
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.vidc.dec.120fps.enabled=1 \
    vendor.vidc.dec.drc.enable=1 \
    vidc.enc.dcvs.extra-buff-count=2

# Memory
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m \
    dalvik.vm.heapmaxfree=8m \
    dalvik.vm.heapminfree=4m \
    dalvik.vm.heapsize=512m \
    dalvik.vm.heapstartsize=16m \
    dalvik.vm.heaptargetutilization=0.75

# NFC
PRODUCT_PROPERTY_OVERRIDES += \
    nfc.app_log_level=2

# Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=libqti-perfd-client.so \
    sdm.debug.disable_skip_validate=1

# Radio
PRODUCT_PROPERTY_OVERRIDES += \
    persist.data.mode=concurrent \
    persist.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.rat_on=combine \
    persist.vendor.radio.sib16_support=1 \
    rild.libpath=/vendor/lib64/libril-qc-qmi-1.so \
    vendor.voice.path.for.pcm.voip=false

# Vendor security patch level
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.build.security_patch=2018-07-05

# Random
PRODUCT_PROPERTY_OVERRIDES += \
    persist.mwc.walk_around=1 \
    ro.oem_unlock_supported=true \
    ro.build.shutdown_timeout=0 \
    ro.com.google.gmsversion=8.1_201807 \
    ro.cp_system_other_odex=1 \
    ro.opa.eligible_device=true \
    ro.qcom.hdr.config=/system/etc/hdr_tm_config.xml \
    ro.razer.internal.api=1 \
    ro.razer.internal.list=9 \
    ro.razer.internal.mask=254 \
    ro.razer.internal.zval=26 \
    ro.setupwizard.mode=OPTIONAL \
    ro.setupwizard.require_network=junk \
    ro.setupwizard.rotation_locked=true \
    sys.vendor.shutdown.waittime=500
