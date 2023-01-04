if !$BOOTMODE; then
	abort "[!] magisk only"
fi

#####################
# here's the config #
REAL='/sdcard/YouTube.apk' # real youtube file
#####################
NAME='YouTube'
IS_INSTALLED=$(pm list packages | grep 'com.google.android.youtube')
IS_EXIST=$(ls -1 $REAL)

ui_print "[+] Check real $NAME"
if ! $IS_INSTALLED; then
	ui_print "[-] Real $NAME not installed"
	if ! $IS_EXIST; then
		abort "[!] file $REAL not exist"
	fi
	ui_print "[-] Installing real $NAME"
	mmm_exec showLoading
	#pm install --dont-kill -g $REAL
	#mmm_exec hideLoading
fi

ui_print "[+] real Youtube was successful installed"
