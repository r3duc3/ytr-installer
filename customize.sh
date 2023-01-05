if ! $BOOTMODE; then
	abort "[!] magisk only"
fi

###############
# config here
_dir='/sdcard/revanced'
_original='YouTube.apk'
_modified='revanced.apk'
###############
# please don't change
_modifiedDir='/data/adb/revanced'
_pmCmd="pm path com.google.android.youtube | grep base | sed 's/package\://'"
###############

if ! [ -f $_dir/$_modified ]; then
	abort "[!] $_modified not found"
fi

# original
if ! [ $$_pmCmd ]; then
	ui_print "[*] original youtube not installed"
	if ! [ -f $_dir/$_original ]; then
		abort "[!] $_original not found"
	fi

	mmm_exec showLoading
	ui_print "[*] installing $_original"
	cp $_dir/$_original /data/local/tmp
	pm install --dont-kill -g "/data/local/tmp/$_original"
	mmm_exec hideLoading
	rm "/data/local/tmp/$_original"
fi

# patch
ui_print "[*] patching"
mmm_exec showLoading

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
orig=\$($_pmCmd)
[ ! -z \$orig ] && mount -o bind \$patch \$orig;
EOM

mmm_exec hideLoading
ui_print "[*] patched"
