package com.example.reta
import java.io.File
import android.os.Build
import java.io.BufferedReader
import java.io.InputStreamReader

object RootCheck {
      init {
            try {
                  System.loadLibrary("root_check")
                } catch (e: UnsatisfiedLinkError) {
                  // Native lib not loaded, fallback to Java checks only
                }
          }

      @JvmStatic
      external fun nativeIsDeviceRooted(): Boolean

      @Volatile
      private var cachedResult: Boolean? = null

      fun isRooted(): Boolean {
            cachedResult?.let { return it }
            val result = checkRootMethod1() ||
                checkRootMethod2() ||
                checkRootMethod3() ||
                nativeIsDeviceRooted()
            cachedResult = result
            return result
          }

      // Check for common root binaries and apps
      private fun checkRootMethod1(): Boolean {
            val paths = arrayOf(
              "/system/app/Superuser.apk",
              "/sbin/su",
              "/system/bin/su",
              "/system/xbin/su",
              "/data/local/xbin/su",
              "/data/local/bin/su",
              "/system/sd/xbin/su",
              "/system/bin/failsafe/su",
              "/data/local/su",
              "/system/usr/we-need-root/su-backup",
              "/system/xbin/mu"
            )
            return paths.any { File(it).exists() }
          }

      // Check build tags for test-keys
      private fun checkRootMethod2(): Boolean {
            return Build.TAGS?.contains("test-keys") ?: false
          }

      // Try executing su command
      private fun checkRootMethod3(): Boolean {
            return try {
                  val process = Runtime.getRuntime().exec(arrayOf("/system/xbin/which", "su"))
                  val reader = BufferedReader(InputStreamReader(process.inputStream))
                  val output = reader.readLine()
                  reader.close()
                  process.destroy()
                  output != null
                } catch (e: Exception) {
                  false
                }
          }
}
