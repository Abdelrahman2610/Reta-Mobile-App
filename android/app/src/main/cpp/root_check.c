#include <jni.h>

#include <unistd.h>

#include <string.h>

#include <stdio.h>



// For __system_property_get and PROP_VALUE_MAX

#if __has_include(<sys/system_properties.h>)

#include <sys/system_properties.h>

#else

#ifndef PROP_VALUE_MAX

#define PROP_VALUE_MAX 92

#endif

extern int __system_property_get(const char *name, char *value);

#endif


JNIEXPORT jboolean

JNICALL

Java_com_example_reta_RootCheck_nativeIsDeviceRooted(
        JNIEnv *env,
        jclass clazz
) {


    if (access("/system/xbin/su", F_OK) == 0) return JNI_TRUE;
    if (access("/system/bin/su", F_OK) == 0) return JNI_TRUE;

    if (access("/sbin/magisk", F_OK) == 0 ||
        access("/sbin/magiskhide", F_OK) == 0) {
        return JNI_TRUE;
    }

    char debuggable[PROP_VALUE_MAX] = {0};
    __system_property_get("ro.debuggable", debuggable);
    if (strcmp(debuggable, "1") == 0) return JNI_TRUE;

    FILE *maps = fopen("/proc/self/maps", "r");
    if (maps != NULL) {
        char line[256];
        while (fgets(line, sizeof(line), maps)) {
            if (strstr(line, "frida")) {
                fclose(maps);
                return JNI_TRUE;
            }
        }
        fclose(maps);
    }

    return JNI_FALSE;

}