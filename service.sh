#!/system/bin/sh
while [ "$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do sleep 3; done
stock_path=$(pm path com.google.android.youtube | grep base | sed 's/package://g')
[ ! -z $stock_path ] && mount -o bind $MODDIR/base.apk $stock_path
