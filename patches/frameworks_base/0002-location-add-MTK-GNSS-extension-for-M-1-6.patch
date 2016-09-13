From d10ad82e15daed52db551557ce739df00ba31079 Mon Sep 17 00:00:00 2001
From: ferhung-mtk <ferhung27@gmail.com>
Date: Sun, 17 Apr 2016 20:53:48 +0800
Subject: [PATCH 2/8] location: add MTK GNSS extension for M(1/6).

---
 location/java/android/location/GpsStatus.java | 35 +++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/location/java/android/location/GpsStatus.java b/location/java/android/location/GpsStatus.java
index b601cde..a669d70 100644
--- a/location/java/android/location/GpsStatus.java
+++ b/location/java/android/location/GpsStatus.java
@@ -194,6 +194,41 @@ public final class GpsStatus {
         }
     }
 
+      /**
+     * Used internally within {@link LocationManager} to copy GPS status
+     * data from the Location Manager Service to its cached GpsStatus instance.
+     * Is synchronized to ensure that GPS status updates are atomic.
+     *
+     * This is modified to become aware of explicit GNSS support of &gt;32
+     * satellites.
+     */
+    synchronized void setStatusFromGnss(int gnssSvCount, int[] prns, float[] snrs,
+            float[] elevations, float[] azimuths,
+            boolean[] ephemerisPresences,
+            boolean[] almanacPresences,
+            boolean[] usedInFix) {
+        clearSatellites();
+        for (int i = 0; i < gnssSvCount; i++) {
+            int prn = prns[i] - 1;
+
+            if (prn >= 0 && prn < NUM_SATELLITES) {
+                GpsSatellite satellite = mSatellites.get(prn);
+                if (satellite == null) {
+                    satellite = new GpsSatellite(prn);
+                    mSatellites.put(prn, satellite);
+                }
+
+                satellite.mValid = true;
+                satellite.mSnr = snrs[i];
+                satellite.mElevation = elevations[i];
+                satellite.mAzimuth = azimuths[i];
+                satellite.mHasEphemeris = ephemerisPresences[i];
+                satellite.mHasAlmanac = almanacPresences[i];
+                satellite.mUsedInFix = usedInFix[i];
+            }
+        }
+    }
+
     /**
      * Copies GPS satellites information from GnssStatus object.
      * Since this method is only used within {@link LocationManager#getGpsStatus},
-- 
2.9.3

