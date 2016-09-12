#!/bin/bash

cd ../../..
#cd external/sepolicy
#git apply -v ../../device/terra/terrapad803/patches/external_sepolicy.patch
#cd ../..
cd frameworks/av
git apply -v ../../device/terra/terrapad803/patches/frameworks_av.patch
cd ../..
cd frameworks/base
git apply -v ../../device/terra/terrapad803/patches/frameworks_base.patch
cd ../..
cd frameworks/native
git apply -v ../../device/terra/terrapad803/patches/frameworks_native.patch
cd ../..
cd frameworks/opt/telephony
git apply -v ../../../device/terra/terrapad803/patches/telephony.patch 
cd ../../..
cd hardware/libhardware
git apply -v ../../device/terra/terrapad803/patches/hardware_libhardware.patch
cd ../..
cd system/bt
git apply -v ../../device/terra/terrapad803/patches/system_bt.patch
cd ../..
#cd system/core
#git apply -v ../../device/terra/terrapad803/patches/system_core.patch
#cd ../..
cd system/netd
git apply -v ../../device/terra/terrapad803/patches/system_netd.patch
cd ../..
cd external/wpa_supplicant_8
git apply -v ../../device/terra/terrapad803/patches/nvram.patch
cd ../..

echo Patches Successful
echo "#SPT "
