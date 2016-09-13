From 7602406faa161d0ec73b621113669c4775ba604b Mon Sep 17 00:00:00 2001
From: ferhung-mtk <ferhung27@gmail.com>
Date: Sun, 17 Apr 2016 21:05:23 +0800
Subject: [PATCH 6/8] location: add MTK GNSS extension for M(5/6).

---
 .../server/location/GnssStatusListenerHelper.java  | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/services/core/java/com/android/server/location/GnssStatusListenerHelper.java b/services/core/java/com/android/server/location/GnssStatusListenerHelper.java
index d471e45..de3ec4e 100644
--- a/services/core/java/com/android/server/location/GnssStatusListenerHelper.java
+++ b/services/core/java/com/android/server/location/GnssStatusListenerHelper.java
@@ -91,6 +91,32 @@ abstract class GnssStatusListenerHelper extends RemoteListenerHelper<IGnssStatus
         };
         foreach(operation);
     }
+  
+    public void onGnssSvStatusChanged(
+            final int svCount,
+            final int[] prns,
+            final float[] snrs,
+            final float[] elevations,
+            final float[] azimuths,
+            final boolean[] ephemerisPresences,
+            final boolean[] almanacPresences,
+            final boolean[] usedInFix) {
+        Operation operation = new Operation() {
+            @Override
+            public void execute(IGpsStatusListener listener) throws RemoteException {
+                listener.onGnssSvStatusChanged(
+                        svCount,
+                        prns,
+                        snrs,
+                        elevations,
+                        azimuths,
+                        ephemerisPresences,
+                        almanacPresences,
+                        usedInFix);
+            }
+        };
+        foreach(operation);
+    }
 
     public void onNmeaReceived(final long timestamp, final String nmea) {
         Operation operation = new Operation() {
-- 
2.9.3

