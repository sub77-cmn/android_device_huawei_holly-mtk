From 5a7aa62ccbc7728368cfa56a5f0be9628cff512d Mon Sep 17 00:00:00 2001
From: ferhung-mtk <ferhung27@gmail.com>
Date: Sun, 17 Apr 2016 21:03:38 +0800
Subject: [PATCH 5/8] location: add MTK GNSS extension for M(4/6).

---
 .../server/location/GnssLocationProvider.java      | 96 ++++++++++++++++++++--
 1 file changed, 89 insertions(+), 7 deletions(-)

diff --git a/services/core/java/com/android/server/location/GnssLocationProvider.java b/services/core/java/com/android/server/location/GnssLocationProvider.java
index c219392..45d4ec2 100644
--- a/services/core/java/com/android/server/location/GnssLocationProvider.java
+++ b/services/core/java/com/android/server/location/GnssLocationProvider.java
@@ -1606,6 +1606,72 @@ public class GnssLocationProvider implements LocationProviderInterface {
         }
     }
 
+     /**
+     * Count number of GNSS satellites used in fix.
+     *
+     * We could not rely on Integer.bitCount as GNSS used-in-fix info is not
+     * represented as a bit-mask.
+     */
+    private int countGnssSvUsedInFix(final int gnssSvCount) {
+        int result = 0;
+
+        for (int i = 0; i < gnssSvCount; i++) {
+            if (mSvUsedInFix[i]) {
+                result++;
+            }
+        }
+
+        return result;
+    }
+
+    /**
+     * called from native code to update GNSS SV info
+     */
+    private void reportGnssSvStatus() {
+        final int svCount = native_read_gnss_sv_status(
+                mSvs,
+                mSnrs,
+                mSvElevations,
+                mSvAzimuths,
+                mSvEphemerisPresences,
+                mSvAlmanacPresences,
+                mSvUsedInFix);
+        mListenerHelper.onGnssSvStatusChanged(
+                svCount,
+                mSvs,
+                mSnrs,
+                mSvElevations,
+                mSvAzimuths,
+                mSvEphemerisPresences,
+                mSvAlmanacPresences,
+                mSvUsedInFix);
+
+        if (VERBOSE) {
+            Log.v(TAG, "GNSS SV count: " + svCount);
+            for (int i = 0; i < svCount; i++) {
+                Log.v(TAG, "sv: " + mSvs[i] +
+                        " snr: " + mSnrs[i]/10 +
+                        " elev: " + mSvElevations[i] +
+                        " azimuth: " + mSvAzimuths[i] +
+                        (!mSvEphemerisPresences[i] ? "  " : " E") +
+                        (!mSvAlmanacPresences[i] ? "  " : " A") +
+                        (!mSvUsedInFix[i] ? "" : "U"));
+            }
+        }
+
+        // return number of sets used in fix instead of total
+        updateStatus(mStatus, countGnssSvUsedInFix(svCount));
+
+        if (mNavigating && mStatus == LocationProvider.AVAILABLE && mLastFixTime > 0 &&
+            System.currentTimeMillis() - mLastFixTime > RECENT_FIX_TIMEOUT) {
+            // send an intent to notify that the GPS is no longer receiving fixes.
+            Intent intent = new Intent(LocationManager.GPS_FIX_CHANGE_ACTION);
+            intent.putExtra(LocationManager.EXTRA_GPS_ENABLED, false);
+            mContext.sendBroadcastAsUser(intent, UserHandle.ALL);
+            updateStatus(LocationProvider.TEMPORARILY_UNAVAILABLE, mSvCount);
+        }
+    }
+
     /**
      * called from native code to update AGPS status
      */
@@ -2405,13 +2471,23 @@ public class GnssLocationProvider implements LocationProviderInterface {
     }
 
     // for GPS SV statistics
-    private static final int MAX_SVS = 64;
+    private static final int MAX_SVS = 32;
+    private static final int EPHEMERIS_MASK = 0;
+    private static final int ALMANAC_MASK = 1;
+    private static final int USED_FOR_FIX_MASK = 2;
+  
+    // GNSS extension
+    private static final int MAX_GNSS_SVS = 256;
 
     // preallocated arrays, to avoid memory allocation in reportStatus()
-    private int mSvidWithFlags[] = new int[MAX_SVS];
-    private float mCn0s[] = new float[MAX_SVS];
-    private float mSvElevations[] = new float[MAX_SVS];
-    private float mSvAzimuths[] = new float[MAX_SVS];
+    private int mSvs[] = new int[MAX_GNSS_SVS];
+    private float mSnrs[] = new float[MAX_GNSS_SVS];
+    private float mSvElevations[] = new float[MAX_GNSS_SVS];
+    private float mSvAzimuths[] = new float[MAX_GNSS_SVS];
+    private int mSvMasks[] = new int[3];
+    private boolean mSvEphemerisPresences[] = new boolean[MAX_GNSS_SVS];
+    private boolean mSvAlmanacPresences[] = new boolean[MAX_GNSS_SVS];
+    private boolean mSvUsedInFix[] = new boolean[MAX_GNSS_SVS];
     private int mSvCount;
     // preallocated to avoid memory allocation in reportNmea()
     private byte[] mNmeaBuffer = new byte[120];
@@ -2431,8 +2507,14 @@ public class GnssLocationProvider implements LocationProviderInterface {
     private native void native_delete_aiding_data(int flags);
     // returns number of SVs
     // mask[0] is ephemeris mask and mask[1] is almanac mask
-    private native int native_read_sv_status(int[] prnWithFlags, float[] cn0s, float[] elevations,
-            float[] azimuths);
+    private native int native_read_sv_status(int[] svs, float[] snrs,
+            float[] elevations, float[] azimuths, int[] masks);
+    // returns number of GNSS SVs
+    private native int native_read_gnss_sv_status(int[] svs, float[] snrs,
+            float[] elevations, float[] azimuths,
+            boolean[] ephemerisPresences,
+            boolean[] almanacPresences,
+            boolean[] usedInFix);
     private native int native_read_nmea(byte[] buffer, int bufferSize);
     private native void native_inject_location(double latitude, double longitude, float accuracy);
 
-- 
2.9.3

