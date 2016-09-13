From 91adaf04a073b19e281321023926d9cc27380ab6 Mon Sep 17 00:00:00 2001
From: ferhung-mtk <ferhung27@gmail.com>
Date: Sun, 17 Apr 2016 21:10:15 +0800
Subject: [PATCH 7/8] location: add MTK GNSS extension for M(6/6).

---
 ...ndroid_server_location_GnssLocationProvider.cpp | 145 +++++++++------------
 1 file changed, 58 insertions(+), 87 deletions(-)

diff --git a/services/core/jni/com_android_server_location_GnssLocationProvider.cpp b/services/core/jni/com_android_server_location_GnssLocationProvider.cpp
index 3904021..6cc8676 100644
--- a/services/core/jni/com_android_server_location_GnssLocationProvider.cpp
+++ b/services/core/jni/com_android_server_location_GnssLocationProvider.cpp
@@ -40,6 +40,7 @@ static jobject mCallbacksObj = NULL;
 static jmethodID method_reportLocation;
 static jmethodID method_reportStatus;
 static jmethodID method_reportSvStatus;
+static jmethodID method_reportGnssSvStatus;
 static jmethodID method_reportAGpsStatus;
 static jmethodID method_reportNmea;
 static jmethodID method_setEngineCapabilities;
@@ -91,8 +92,8 @@ static const GnssConfigurationInterface* sGnssConfigurationInterface = NULL;
 #define CONSTELLATION_TYPE_SHIFT_WIDTH 3
 
 // temporary storage for GPS callbacks
-static GnssSvInfo sGnssSvList[GNSS_MAX_SATELLITE_COUNT];
-static size_t sGnssSvListSize;
+static GpsSvStatus  sGpsSvStatus;
+static GnssSvStatus  sGnssSvStatus;
 static const char* sNmeaString;
 static int sNmeaStringLength;
 
@@ -129,91 +130,18 @@ static void status_callback(GpsStatus* status)
 static void sv_status_callback(GpsSvStatus* sv_status)
 {
     JNIEnv* env = AndroidRuntime::getJNIEnv();
-    size_t status_size = sv_status->size;
-    // Some drives doesn't set the size field correctly. Assume GpsSvStatus_v1
-    // if it doesn't provide a valid size.
-    if (status_size == 0) {
-        ALOGW("Invalid size of GpsSvStatus found: %zd.", status_size);
-    }
-    sGnssSvListSize = sv_status->num_svs;
-    // Clamp the list size. Legacy GpsSvStatus has only 32 elements in sv_list.
-    if (sGnssSvListSize > GPS_MAX_SATELLITE_COUNT) {
-        ALOGW("Too many satellites %zd. Clamps to %d.",
-              sGnssSvListSize,
-              GPS_MAX_SATELLITE_COUNT);
-        sGnssSvListSize = GPS_MAX_SATELLITE_COUNT;
-    }
-    uint32_t ephemeris_mask = sv_status->ephemeris_mask;
-    uint32_t almanac_mask = sv_status->almanac_mask;
-    uint32_t used_in_fix_mask = sv_status->used_in_fix_mask;
-    for (size_t i = 0; i < sGnssSvListSize; i++) {
-        GnssSvInfo& info = sGnssSvList[i];
-        info.svid = sv_status->sv_list[i].prn;
-        // Defacto mapping from the overused API that was designed for GPS-only
-        if (info.svid >=1 && info.svid <= 32) {
-            info.constellation = GNSS_CONSTELLATION_GPS;
-        } else if (info.svid > GLONASS_SVID_OFFSET &&
-                   info.svid <= GLONASS_SVID_OFFSET + GLONASS_SVID_COUNT) {
-            info.constellation = GNSS_CONSTELLATION_GLONASS;
-            info.svid -= GLONASS_SVID_OFFSET;
-        } else if (info.svid > BEIDOU_SVID_OFFSET &&
-                   info.svid <= BEIDOU_SVID_OFFSET + BEIDOU_SVID_COUNT) {
-            info.constellation = GNSS_CONSTELLATION_BEIDOU;
-            info.svid -= BEIDOU_SVID_OFFSET;
-        } else if (info.svid >= SBAS_SVID_MIN && info.svid <= SBAS_SVID_MAX) {
-            info.constellation = GNSS_CONSTELLATION_SBAS;
-            info.svid += SBAS_SVID_ADD;
-        } else if (info.svid >= QZSS_SVID_MIN && info.svid <= QZSS_SVID_MAX) {
-            info.constellation = GNSS_CONSTELLATION_QZSS;
-        } else {
-            ALOGD("Unknown constellation type with Svid = %d.", info.svid);
-            info.constellation = GNSS_CONSTELLATION_UNKNOWN;
-        }
-        info.c_n0_dbhz = sv_status->sv_list[i].snr;
-        info.elevation = sv_status->sv_list[i].elevation;
-        info.azimuth = sv_status->sv_list[i].azimuth;
-        info.flags = GNSS_SV_FLAGS_NONE;
-        // Only GPS info is valid for these fields, as these masks are just 32 bits, by GPS prn
-        if (info.constellation == GNSS_CONSTELLATION_GPS) {
-            int32_t this_svid_mask = (1 << (info.svid - 1));
-            if ((ephemeris_mask & this_svid_mask) != 0) {
-                info.flags |= GNSS_SV_FLAGS_HAS_EPHEMERIS_DATA;
-            }
-            if ((almanac_mask & this_svid_mask) != 0) {
-                info.flags |= GNSS_SV_FLAGS_HAS_ALMANAC_DATA;
-            }
-            if ((used_in_fix_mask & this_svid_mask) != 0) {
-                info.flags |= GNSS_SV_FLAGS_USED_IN_FIX;
-            }
-        }
-    }
+    ALOGD("sv_status_callback(%p)", sv_status);
+    memcpy(&sGpsSvStatus, sv_status, sizeof(sGpsSvStatus));
     env->CallVoidMethod(mCallbacksObj, method_reportSvStatus);
     checkAndClearExceptionFromCallback(env, __FUNCTION__);
 }
-
-static void gnss_sv_status_callback(GnssSvStatus* sv_status) {
+  
+static void gnss_sv_status_callback(GnssSvStatus* sv_status)
+{
     JNIEnv* env = AndroidRuntime::getJNIEnv();
-    size_t status_size = sv_status->size;
-    // Check the size, and reject the object that has invalid size.
-    if (status_size != sizeof(GnssSvStatus)) {
-        ALOGE("Invalid size of GnssSvStatus found: %zd.", status_size);
-        return;
-    }
-    sGnssSvListSize = sv_status->num_svs;
-    // Clamp the list size
-    if (sGnssSvListSize > GNSS_MAX_SATELLITE_COUNT) {
-        ALOGD("Too many satellites %zd. Clamps to %d.",
-              sGnssSvListSize,
-              GNSS_MAX_SATELLITE_COUNT);
-        sGnssSvListSize = GNSS_MAX_SATELLITE_COUNT;
-    }
-    // Copy GNSS SV info into sGnssSvList, if any.
-    if (sGnssSvListSize > 0) {
-        memcpy(sGnssSvList,
-               sv_status->gnss_sv_list,
-               sizeof(GnssSvInfo) * sGnssSvListSize);
-    }
-    env->CallVoidMethod(mCallbacksObj, method_reportSvStatus);
+    ALOGD("gnss_sv_status_callback(%p)", sv_status);
+    memcpy(&sGnssSvStatus, sv_status, sizeof(sGnssSvStatus));
+    env->CallVoidMethod(mCallbacksObj, method_reportGnssSvStatus);
     checkAndClearExceptionFromCallback(env, __FUNCTION__);
 }
 
@@ -271,6 +199,7 @@ GpsCallbacks sGpsCallbacks = {
     location_callback,
     status_callback,
     sv_status_callback,
+    gnss_sv_status_callback,
     nmea_callback,
     set_capabilities_callback,
     acquire_wakelock_callback,
@@ -563,6 +492,7 @@ static void android_location_GnssLocationProvider_class_init_native(JNIEnv* env,
     method_reportLocation = env->GetMethodID(clazz, "reportLocation", "(IDDDFFFJ)V");
     method_reportStatus = env->GetMethodID(clazz, "reportStatus", "(I)V");
     method_reportSvStatus = env->GetMethodID(clazz, "reportSvStatus", "()V");
+    method_reportGnssSvStatus = env->GetMethodID(clazz, "reportGnssSvStatus", "()V");
     method_reportAGpsStatus = env->GetMethodID(clazz, "reportAGpsStatus", "(II[B)V");
     method_reportNmea = env->GetMethodID(clazz, "reportNmea", "(J)V");
     method_setEngineCapabilities = env->GetMethodID(clazz, "setEngineCapabilities", "(I)V");
@@ -754,6 +684,44 @@ static jint android_location_GnssLocationProvider_read_sv_status(JNIEnv* env, jo
     env->ReleaseFloatArrayElements(azumArray, azim, 0);
     return (jint) sGnssSvListSize;
 }
+  
+static jint android_location_GpsLocationProvider_read_gnss_sv_status(JNIEnv* env, jobject obj,
+        jintArray prnArray, jfloatArray snrArray, jfloatArray elevArray, jfloatArray azumArray,
+        jbooleanArray ephemerisPresencesArray,
+        jbooleanArray almanacPresencesArray,
+        jbooleanArray usedInFixArray)
+{
+    // this should only be called from within a call to reportGnssSvStatus
+
+    jint* prns = env->GetIntArrayElements(prnArray, 0);
+    jfloat* snrs = env->GetFloatArrayElements(snrArray, 0);
+    jfloat* elev = env->GetFloatArrayElements(elevArray, 0);
+    jfloat* azim = env->GetFloatArrayElements(azumArray, 0);
+    jboolean* ephemeris_presences = env->GetBooleanArrayElements(ephemerisPresencesArray, 0);
+    jboolean* almanac_presences = env->GetBooleanArrayElements(almanacPresencesArray, 0);
+    jboolean* used_in_fix = env->GetBooleanArrayElements(usedInFixArray, 0);
+
+    int num_svs = sGnssSvStatus.num_svs;
+    for (int i = 0; i < num_svs; i++) {
+        prns[i] = sGnssSvStatus.sv_list[i].prn;
+        snrs[i] = sGnssSvStatus.sv_list[i].snr;
+        elev[i] = sGnssSvStatus.sv_list[i].elevation;
+        azim[i] = sGnssSvStatus.sv_list[i].azimuth;
+
+        ephemeris_presences[i] = sGnssSvStatus.sv_list[i].has_ephemeris ? 1 : 0;
+        almanac_presences[i] = sGnssSvStatus.sv_list[i].has_almanac ? 1 : 0;
+        used_in_fix[i] = sGnssSvStatus.sv_list[i].used_in_fix ? 1 : 0;
+    }
+
+    env->ReleaseIntArrayElements(prnArray, prns, 0);
+    env->ReleaseFloatArrayElements(snrArray, snrs, 0);
+    env->ReleaseFloatArrayElements(elevArray, elev, 0);
+    env->ReleaseFloatArrayElements(azumArray, azim, 0);
+    env->ReleaseBooleanArrayElements(ephemerisPresencesArray, ephemeris_presences, 0);
+    env->ReleaseBooleanArrayElements(almanacPresencesArray, almanac_presences, 0);
+    env->ReleaseBooleanArrayElements(usedInFixArray, used_in_fix, 0);
+    return (jint) num_svs;
+}
 
 static void android_location_GnssLocationProvider_agps_set_reference_location_cellid(
         JNIEnv* /* env */, jobject /* obj */, jint type, jint mcc, jint mnc, jint lac, jint cid, jint psc)
@@ -1633,10 +1601,13 @@ static const JNINativeMethod sMethods[] = {
             "(I)V",
             (void*)android_location_GnssLocationProvider_delete_aiding_data},
     {"native_read_sv_status",
-            "([I[F[F[F)I",
-            (void*)android_location_GnssLocationProvider_read_sv_status},
-    {"native_read_nmea", "([BI)I", (void*)android_location_GnssLocationProvider_read_nmea},
-    {"native_inject_time", "(JJI)V", (void*)android_location_GnssLocationProvider_inject_time},
+            "([I[F[F[F[I)I",
+            (void*)android_location_GpsLocationProvider_read_sv_status},
+    {"native_read_gnss_sv_status",
+            "([I[F[F[F[Z[Z[Z)I",
+            (void*)android_location_GpsLocationProvider_read_gnss_sv_status},
+    {"native_read_nmea", "([BI)I", (void*)android_location_GpsLocationProvider_read_nmea},
+    {"native_inject_time", "(JJI)V", (void*)android_location_GpsLocationProvider_inject_time},
     {"native_inject_location",
             "(DDF)V",
             (void*)android_location_GnssLocationProvider_inject_location},
-- 
2.9.3

