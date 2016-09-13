From 029bb784556379978ee6f4a23ceba75d416a799c Mon Sep 17 00:00:00 2001
From: sub77 <sub77@ymail.com>
Date: Mon, 12 Sep 2016 23:38:04 +0200
Subject: [PATCH] MediaTek

Change-Id: Ifbca4fbc66679ef69970b793e9aeeb2eb61d80f6
---
 src/java/com/android/internal/telephony/GsmCdmaPhone.java    |  7 ++++++-
 .../android/internal/telephony/SubscriptionController.java   | 12 ++++++++++++
 .../android/internal/telephony/SubscriptionInfoUpdater.java  |  2 +-
 .../com/android/internal/telephony/uicc/IccConstants.java    |  3 +++
 .../com/android/internal/telephony/uicc/RuimRecords.java     |  5 ++++-
 src/java/com/android/internal/telephony/uicc/SIMRecords.java |  6 ++++--
 6 files changed, 30 insertions(+), 5 deletions(-)

diff --git a/src/java/com/android/internal/telephony/GsmCdmaPhone.java b/src/java/com/android/internal/telephony/GsmCdmaPhone.java
index 8dee9af..a18b2f4 100644
--- a/src/java/com/android/internal/telephony/GsmCdmaPhone.java
+++ b/src/java/com/android/internal/telephony/GsmCdmaPhone.java
@@ -1946,7 +1946,12 @@ public class GsmCdmaPhone extends Phone {
             // Complete pending USSD
 
             if (isUssdRelease) {
-                found.onUssdRelease();
+                // MTK weirdness
+                if(ussdMessage != null) {
+                    found.onUssdFinished(ussdMessage, isUssdRequest);
+                } else {
+                    found.onUssdRelease();
+                }
             } else if (isUssdError) {
                 found.onUssdFinishedError();
             } else {
diff --git a/src/java/com/android/internal/telephony/SubscriptionController.java b/src/java/com/android/internal/telephony/SubscriptionController.java
index e9caf94..9b6387a 100644
--- a/src/java/com/android/internal/telephony/SubscriptionController.java
+++ b/src/java/com/android/internal/telephony/SubscriptionController.java
@@ -257,6 +257,13 @@ public class SubscriptionController extends ISub.Stub {
          broadcastSimInfoContentChanged();
      }
 
+     private boolean isNumeric(String str) {
+         for (char c : str.toCharArray()) {
+             if (!Character.isDigit(c)) return false;
+         }
+         return true;
+     }
+
     /**
      * New SubInfoRecord instance and fill in detail info
      * @param cursor
@@ -303,6 +310,11 @@ public class SubscriptionController extends ISub.Stub {
                     + " simProvisioningStatus:" + simProvisioningStatus);
         }
 
+        if (isNumeric(carrierName)) {
+            carrierName = displayName;
+            logd("[getSubInfoRecord] carrierName changed to: " + displayName);
+        }
+
         // If line1number has been set to a different number, use it instead.
         String line1Number = mTelephonyManager.getLine1Number(id);
         if (!TextUtils.isEmpty(line1Number) && !line1Number.equals(number)) {
diff --git a/src/java/com/android/internal/telephony/SubscriptionInfoUpdater.java b/src/java/com/android/internal/telephony/SubscriptionInfoUpdater.java
index a89f19c..457b231 100644
--- a/src/java/com/android/internal/telephony/SubscriptionInfoUpdater.java
+++ b/src/java/com/android/internal/telephony/SubscriptionInfoUpdater.java
@@ -290,7 +290,7 @@ public class SubscriptionInfoUpdater extends Handler {
                         mIccId[slotId] = ICCID_STRING_FOR_NO_SIM;
                     }
                 } else {
-                    mIccId[slotId] = ICCID_STRING_FOR_NO_SIM;
+                    mIccId[slotId] = IccConstants.FAKE_ICCID;
                     logd("Query IccId fail: " + ar.exception);
                 }
                 logd("sIccId[" + slotId + "] = " + mIccId[slotId]);
diff --git a/src/java/com/android/internal/telephony/uicc/IccConstants.java b/src/java/com/android/internal/telephony/uicc/IccConstants.java
index 5ed699e..73e9699 100644
--- a/src/java/com/android/internal/telephony/uicc/IccConstants.java
+++ b/src/java/com/android/internal/telephony/uicc/IccConstants.java
@@ -107,4 +107,7 @@ public interface IccConstants {
 
     //UICC access
     static final String DF_ADF = "7FFF";
+
+    //CM-Specific : Fake ICCID
+    static final String FAKE_ICCID = "00000000000001";
 }
diff --git a/src/java/com/android/internal/telephony/uicc/RuimRecords.java b/src/java/com/android/internal/telephony/uicc/RuimRecords.java
index af7d5bc..004a81c 100644
--- a/src/java/com/android/internal/telephony/uicc/RuimRecords.java
+++ b/src/java/com/android/internal/telephony/uicc/RuimRecords.java
@@ -666,7 +666,10 @@ public class RuimRecords extends IccRecords {
                 ar = (AsyncResult)msg.obj;
                 String localTemp[] = (String[])ar.result;
                 if (ar.exception != null) {
-                    break;
+                    mIccId = FAKE_ICCID;
+                }
+                else {
+                    mIccId = IccUtils.bcdToString(data, 0, data.length);
                 }
 
                 mMyMobileNumber = localTemp[0];
diff --git a/src/java/com/android/internal/telephony/uicc/SIMRecords.java b/src/java/com/android/internal/telephony/uicc/SIMRecords.java
index b3a9ee3..0cb9d7b 100644
--- a/src/java/com/android/internal/telephony/uicc/SIMRecords.java
+++ b/src/java/com/android/internal/telephony/uicc/SIMRecords.java
@@ -879,10 +879,12 @@ public class SIMRecords extends IccRecords {
                 data = (byte[])ar.result;
 
                 if (ar.exception != null) {
-                    break;
+                    mIccId = FAKE_ICCID;
+                }
+                else {
+	                    mIccId = IccUtils.bcdToString(data, 0, data.length);
                 }
 
-                mIccId = IccUtils.bcdToString(data, 0, data.length);
                 mFullIccId = IccUtils.bchToString(data, 0, data.length);
 
                 log("iccid: " + SubscriptionInfo.givePrintableIccid(mFullIccId));
-- 
2.9.3

