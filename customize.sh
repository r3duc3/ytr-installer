if !$BOOTMODE; then
	abort "[!] magisk only"
fi

#####################
# here's the config #
REAL_NAME='YouTube'
MODIFIED='/data/adb/revanced.apk' # modified youtube
#####################

if ! [ -f $MODIFIED ]; then
	abort "[!] modified youtube not found"
fi

INSTALLED=$(pm list packages | grep 'com.google.android.youtube')

# check real Youtube first
ui_print "[+] Check real $REAL_NAME"
if ! [ $INSTALLED ]; then
	ui_print "[-] Real $REAL_NAME not installed"
	if ! [ -f "/sdcard/$REAL_NAME.apk" ]; then
		abort "[!] file $REAL_NAME not exist"
	fi
	ui_print "[-] Installing real $REAL_NAME"
	cp "/sdcard/$REAL_NAME.apk" "/data/local/tmp"
	mmm_exec showLoading
	pm install --dont-kill -g "/data/local/tmp/$REAL_NAME.apk"
	mmm_exec hideLoading
	rm "/data/local/tmp/$REAL_NAME.apk"
fi
ui_print "[-] real $REAL_NAME installed"

# then patch
ui_print "[+] revanced patch"
mmm_exec showLoading
cp $MODIFIED $MODPATH/base.apk
rm $MODIFIED
mmm_exec hideLoading
ui_print "[-] installed"
