# Copyright (C) 2014 The CyanogenMod Project
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

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from ms013g device
$(call inherit-product, device/terra/terrapad803/device.mk)

# Device identifier. This must come after all inclusions
PRODUCT_DEVICE := terrapad803
PRODUCT_NAME := cm_terrapad803
PRODUCT_BRAND := Terra
PRODUCT_MODEL := terrapad803
PRODUCT_MANUFACTURER := Terra

PRODUCT_BUILD_PROP_OVERRIDES += TARGET_DEVICE=ks01lte \
        PRODUCT_NAME=ks01ltexx \
        BUILD_FINGERPRINT=samsung/ks01ltexx/ks01lte:5.0.1/LRX22C/I9506XXUDOJ2:user/release-keys \
        PRIVATE_BUILD_DESC="ks01ltexx-user 5.0.1 LRX22C I9506XXUDOJ2 release-keys"
