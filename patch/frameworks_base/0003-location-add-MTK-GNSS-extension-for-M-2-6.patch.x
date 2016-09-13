From f6058f832915cb04d11d15526cf45c60c159c4d6 Mon Sep 17 00:00:00 2001
From: ferhung-mtk <ferhung27@gmail.com>
Date: Sun, 17 Apr 2016 20:55:35 +0800
Subject: [PATCH 3/8] location: add MTK GNSS extension for M(2/6).

---
 location/java/android/location/IGnssStatusListener.aidl | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/location/java/android/location/IGnssStatusListener.aidl b/location/java/android/location/IGnssStatusListener.aidl
index d84614f..9385c1a 100644
--- a/location/java/android/location/IGnssStatusListener.aidl
+++ b/location/java/android/location/IGnssStatusListener.aidl
@@ -26,7 +26,13 @@ oneway interface IGnssStatusListener
     void onGnssStarted();
     void onGnssStopped();
     void onFirstFix(int ttff);
-    void onSvStatusChanged(int svCount, in int[] svidWithFlags, in float[] cn0s,
-            in float[] elevations, in float[] azimuths);
+    void onSvStatusChanged(int svCount, in int[] prns, in float[] snrs, 
+            in float[] elevations, in float[] azimuths, 
+            int ephemerisMask, int almanacMask, int usedInFixMask);
+    void onGnssSvStatusChanged(int gnssSvCount, in int[] prns, in float[] snrs,
+            in float[] elevations, in float[] azimuths,
+            in boolean[] ephemerisPresences,
+            in boolean[] almanacPresences,
+            in boolean[] usedInFix);
     void onNmeaReceived(long timestamp, String nmea);
 }
-- 
2.9.3

