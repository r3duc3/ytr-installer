#!/system/bin/sh
while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do sleep 3; done
base_path=/data/adb/revanced.apk
stock_path=$(pm path com.google.android.youtube | grep base | sed 's/package://g')
[ ! -z $stock_path ] && mount -o bind $base_path $stock_path
