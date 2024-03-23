SKIPUNZIP=1
SET_PERMISSION() {
ui_print "- Setting Permissions"
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm_recursive "${MODPATH}/codes.sh" 0 0 0755 0700
}
MOD_EXTRACT() {
unzip -o "$ZIPFILE" service.sh -d $MODPATH >&2
unzip -o "$ZIPFILE" codes.sh -d $MODPATH >&2
unzip -o "$ZIPFILE" module.prop -d $MODPATH >&2
}
MOD_PRINT() {
ui_print "- Installing"
}
on_install() {
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

  set_bindir
}
set_bindir() {
  local bindir=/system/bin
  local xbindir=/system/xbin

  if [ ! -d /sbin/.magisk/mirror$xbindir ]; then
    # Use /system/bin instead of /system/xbin.
    mkdir -p $MODPATH$bindir
    mv $MODPATH$xbindir/sqlite3 $MODPATH$bindir
    rmdir $MODPATH$xbindir
    xbindir=$bindir
 fi

 ui_print "- Installed to $xbindir"
}
set -x
RM_RF
MOD_PRINT
MOD_EXTRACT
SET_PERMISSION
