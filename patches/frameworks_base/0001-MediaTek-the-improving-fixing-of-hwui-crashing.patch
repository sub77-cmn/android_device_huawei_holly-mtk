From c634fe6c1346d91f58bf0ea4cf910120040e453c Mon Sep 17 00:00:00 2001
From: ferhung-mtk <ferhung27@gmail.com>
Date: Sun, 17 Apr 2016 20:49:46 +0800
Subject: [PATCH 1/8] MediaTek: the improving & fixing of hwui crashing.

---
 libs/hwui/Caches.cpp | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/libs/hwui/Caches.cpp b/libs/hwui/Caches.cpp
index 949ad45..5db9198 100644
--- a/libs/hwui/Caches.cpp
+++ b/libs/hwui/Caches.cpp
@@ -80,16 +80,21 @@ bool Caches::init() {
 }
 
 void Caches::initExtensions() {
+#ifndef MTK_HARDWARE
     if (mExtensions.hasDebugMarker()) {
         eventMark = glInsertEventMarkerEXT;
-
         startMark = glPushGroupMarkerEXT;
         endMark = glPopGroupMarkerEXT;
     } else {
-        eventMark = eventMarkNull;
-        startMark = startMarkNull;
-        endMark = endMarkNull;
+         eventMark = eventMarkNull;
+         startMark = startMarkNull;
+         endMark = endMarkNull;
     }
+#else
+         eventMark = eventMarkNull;
+         startMark = startMarkNull;
+         endMark = endMarkNull;
+#endif
 }
 
 void Caches::initConstraints() {
-- 
2.9.3

