From 6095b4061a9b15b68e77448b1c5d72e90b96b266 Mon Sep 17 00:00:00 2001
From: ferhung-mtk <ferhung27@gmail.com>
Date: Sun, 17 Apr 2016 20:57:41 +0800
Subject: [PATCH 4/8] location: add MTK GNSS extension for M(3/6).

---
 .../java/android/location/LocationManager.java     | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/location/java/android/location/LocationManager.java b/location/java/android/location/LocationManager.java
index eae9664..6588ec2 100644
--- a/location/java/android/location/LocationManager.java
+++ b/location/java/android/location/LocationManager.java
@@ -1651,6 +1651,31 @@ public class LocationManager {
             }
         }
 
+          @Override
+        public void onGnssSvStatusChanged(int gnssSvCount, int[] prns, float[] snrs,
+                float[] elevations, float[] azimuths,
+                boolean[] ephemerisPresences,
+                boolean[] almanacPresences,
+                boolean[] usedInFix) {
+            if (mListener != null) {
+                mGpsStatus.setStatusFromGnss(
+                        gnssSvCount,
+                        prns,
+                        snrs,
+                        elevations,
+                        azimuths,
+                        ephemerisPresences,
+                        almanacPresences,
+                        usedInFix);
+
+                Message msg = Message.obtain();
+                msg.what = GpsStatus.GPS_EVENT_SATELLITE_STATUS;
+                // remove any SV status messages already in the queue
+                mGpsHandler.removeMessages(GpsStatus.GPS_EVENT_SATELLITE_STATUS);
+                mGpsHandler.sendMessage(msg);
+            }
+        }
+
         @Override
         public void onNmeaReceived(long timestamp, String nmea) {
             if (mGnssNmeaListener != null) {
-- 
2.9.3

