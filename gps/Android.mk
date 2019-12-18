# Set required flags
GNSS_CFLAGS := \
    -Werror \
    -Wno-undefined-bool-conversion

LOCAL_PATH := $(call my-dir)
include $(call all-makefiles-under,$(LOCAL_PATH))
