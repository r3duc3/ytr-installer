if !$BOOTMODE; then
	abort "[!] magisk only"
fi

#####################
# here's the config #
REAL='/sdcard/YouTube.apk' # real youtube file
MODIFIED='/data/adb/revanced.apk' # modified youtube
#####################

if ! [ -f $MODIFIED ]; then
	abort "[!] modified youtube not found"
fi

NAME='YouTube'
INSTALLED=$(pm list packages | grep 'com.google.android.youtube')
EXIST=$(ls -1 $REAL)

# check real Youtube first
ui_print "[+] Check real $NAME"
if ! $INSTALLED; then
	ui_print "[-] Real $NAME not installed"
	if ! $EXIST; then
		abort "[!] file $REAL not exist"
	fi
	ui_print "[-] Installing real $NAME"
	mmm_exec showLoading
	pm install --dont-kill -g $REAL
	mmm_exec hideLoading
fi
ui_print "[-] real $NAME installed"

# then patch
REAL_BASE=$(pm path com.google.android.youtube | sed 's/package://g')
REAL_PATH=$(dirname $REAL_BASE)
MODIFIED_PATH="$MODPATH/$REAL_PATH"
mkdir $MODIFIED_PATH
cp $MODIFIED $MODIFIED_PATH
ui_print "[+] revanced installed"
