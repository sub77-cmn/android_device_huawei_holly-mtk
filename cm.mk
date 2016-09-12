## Specify phone tech before including full_phone

# Release name
PRODUCT_RELEASE_NAME := terrapad803

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full.mk)

# Inherit from hardware-specific part of the product configuration
$(call inherit-product, device/terra/terrapad803/device.mk)
$(call inherit-product-if-exists, vendor/terra/terrapad803/terrapad803-vendor.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := terrapad803
PRODUCT_NAME := cm_terrapad803
PRODUCT_BRAND := Terra
PRODUCT_MODEL := terrapad803
PRODUCT_MANUFACTURER := Terra

PRODUCT_GMS_CLIENTID_BASE := android-mediatek
