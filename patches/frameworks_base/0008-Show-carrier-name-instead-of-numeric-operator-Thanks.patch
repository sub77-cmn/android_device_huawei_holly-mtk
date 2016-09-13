From b603b114f0821f8f739f06db7f6df264d2e567b4 Mon Sep 17 00:00:00 2001
From: fire855 <thefire855@gmail.com>
Date: Sun, 31 Jul 2016 20:20:40 +0200
Subject: [PATCH 8/8] Show carrier name instead of numeric operator Thanks to
 @DerTeufel

Change-Id: I2ce4349cecfc2b9eda8acb33aeaafdeb43673cb7
---
 .../statusbar/policy/MobileSignalController.java   | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/packages/SystemUI/src/com/android/systemui/statusbar/policy/MobileSignalController.java b/packages/SystemUI/src/com/android/systemui/statusbar/policy/MobileSignalController.java
index 6561ad8..bca9b8b 100644
--- a/packages/SystemUI/src/com/android/systemui/statusbar/policy/MobileSignalController.java
+++ b/packages/SystemUI/src/com/android/systemui/statusbar/policy/MobileSignalController.java
@@ -119,6 +119,13 @@ public class MobileSignalController extends SignalController<
 
         String networkName = info.getCarrierName() != null ? info.getCarrierName().toString()
                 : mNetworkNameDefault;
+
+        if (isNumeric(networkName)) {
+            String displayName = info.getDisplayName() != null? info.getDisplayName().toString()
+                : mNetworkNameDefault;
+            networkName = displayName;
+        }
+
         mLastState.networkName = mCurrentState.networkName = networkName;
         mLastState.networkNameData = mCurrentState.networkNameData = networkName;
         mLastState.enabled = mCurrentState.enabled = hasMobileData;
@@ -127,11 +134,12 @@ public class MobileSignalController extends SignalController<
         updateDataSim();
     }
 
-    //TODO - Remove this when carrier pack is enabled for carrier one
-    public static boolean isCarrierOneSupported() {
-        String property = SystemProperties.get("persist.radio.atel.carrier");
-        return "405854".equals(property);
-    }
+    private boolean isNumeric(String str) {
+         for (char c : str.toCharArray()) {
+             if (!Character.isDigit(c)) return false;
+         }
+         return true;
+     }
 
     public void setConfiguration(Config config) {
         mConfig = config;
@@ -542,14 +550,14 @@ public class MobileSignalController extends SignalController<
         StringBuilder str = new StringBuilder();
         StringBuilder strData = new StringBuilder();
         if (showPlmn && plmn != null) {
-            str.append(plmn);
+            if (!isNumeric(plmn)) str.append(plmn);
             strData.append(plmn);
             if (showRat) {
                 str.append(" ").append(networkClass);
                 strData.append(" ").append(networkClass);
             }
         }
-        if (showSpn && spn != null) {
+        if (/*showSpn &&*/ spn != null) {
             if (str.length() != 0) {
                 str.append(mNetworkNameSeparator);
             }
-- 
2.9.3

