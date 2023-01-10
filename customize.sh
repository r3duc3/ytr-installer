if ! $BOOTMODE; then
	abort "[!] magisk only"
fi

if [ -n "$MMM_EXT_SUPPORT" ]; then
	ui_print "#!useExt"
	mmm_exec() {
		ui_print "$(echo "#!$@")"
	}
else
	mmm_exec() { true; }
fi

# determine config
config="$MODPATH/ytr-config.prop"
for file in '/sdcard' '/sdcard/revanced'; do
	if [ -f "$file/ytr-config.prop" ]; then
		ui_print "[*] custom config found"
		config="$file/ytr-config.prop"
		break
	fi
done

prop() {
    grep "${1}" ${config} | cut -d'=' -f2
}

######################
# please don't change
_dir=$(prop 'config.dir')
_mode=$(prop 'config.mode')
_original=$(prop 'name.original')
_modified=$(prop 'name.modified')
_modifiedDir='/data/adb/revanced'
_pkg='com.google.android.youtube'
_base=$(pm path $_pkg | sed 's/package://')
######################

if [ $_mode == 'system' ]; then
	abort "[!] '$_mode' install under development"
fi

if ! [ -f $_dir/$_modified ]; then
	abort "[!] $_modified not found"
fi

# original
if ! [ $_base ]; then
	ui_print "[*] original youtube not installed"
	if ! [ -f $_dir/$_original ]; then
		abort "[!] $_dir/$_original not found"
	fi

	mmm_exec showLoading
	ui_print "[*] installing $_original"
	cp $_dir/$_original /data/local/tmp
	pm install -i 'com.android.vending' "/data/local/tmp/$_original"
	rm "/data/local/tmp/$_original"
	mmm_exec hideLoading
fi

ui_print "[*] original youtube installed"

# revanced
mmm_exec showLoading
ui_print "[*] installing youtube revanced"

am force-stop $_pkg
umount -l $_base

mkdir -p $_modifiedDir
chmod 0755 $_modifiedDir
chown shell:shell $_modifiedDir

cp $_dir/$_modified $_modifiedDir
chmod 0644 $_modifiedDir/$_modified
chown system:system $_modifiedDir/$_modified
chcon u:object_r:apk_data_file:s0 $_modifiedDir/$_modified

cat > $MODPATH/service.sh << EOM
#!/usr/bin/sh
while [ "\$(getprop sys.boot_completed | tr -d '\r')" != "1" ]; do sleep 3; done
patch=$_modifiedDir/$_modified
orig=\$(pm path $_pkg | sed 's/package://')
[ ! -z \$orig ] && mount -o bind \$patch \$orig;
EOM

cat > $MODPATH/uninstall.sh << EOM
am force-stop $_pkg
umount -l \$($_pmCmd)
rm -rf $_modifiedDir
EOM

mmm_exec hideLoading
ui_print "[*] success"
