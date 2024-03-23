function boot_wait() {
 while [[ -z $(getprop sys.boot_completed) ]]; do sleep 5; done
}
function system_table_unset() {
  settings delete system "$1"
}
boot_wait
system_table_unset activity_manager_constants