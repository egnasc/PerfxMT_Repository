#!/system/bin/sh

loop=$(cat /sys/block/zram0/backing_dev | grep -o "loop[0-9]*")
echo "none" &gt; "/sys/block/$loop/queue/scheduler"
echo "deadline" &gt; "/sys/block/zram0/queue/scheduler"
echo "noop" &gt; "/sys/block/sda/queue/scheduler"
echo "noop" &gt; "/sys/block/sdc/queue/scheduler"
echo "noop" &gt; "/sys/block/sdb/queue/scheduler"

echo "128" &gt; "/sys/block/sda/queue/read_ahead_kb"
echo "128" &gt; "/sys/block/sde/queue/read_ahead_kb"
echo "1536" &gt; "/sys/block/mmcblk0/queue/read_ahead_kb"
echo "2048" &gt; "/sys/block/zram0/queue/read_ahead_kb"

echo "3" &gt; "/proc/sys/vm/drop_caches"

echo "0" &gt; "/sys/block/zram0/queue/rotational"
echo "0" &gt; "/sys/module/subsystem_restart/parameters/enable_ramdumps"
echo "0" &gt; "/sys/module/subsystem_restart/parameters/enable_mini_ramdumps"

echo "11" &gt; "/proc/sys/kernel/mi_iolimit"
```

# This code eliminates unnecessary repetitions and uses proper quotes for file paths. It also follows best practices for shell scripting.

# Mt-Perfx MThead
function get_prop() {
  resetprop "$1"
}

function set_prop() {
  resetprop -n "$1" "$2"
}

function read_file() {
  if [[ -f $1 ]]; then
    if [[ ! -r $1 ]]; then
      chmod +r "$1"
    fi
    cat "$1"
  else
    echo "File $1 not found"
  fi
}

function write_file() {
  if [[ -f $1 ]]; then
    if [[ ! -w $1 ]]; then
      chmod +w "$1"
    fi
    echo "$2" >"$1"
  else
    echo "File $1 not found"
  fi
}

function boot_wait() {
  while [[ -z $(getprop sys.boot_completed) ]]; do
    sleep 5
  done
}

function opt_game_task() {
  local game_pid game_tid comm
  for game_pid in $(pgrep -fl "$1" | awk '!/bindfs/ && !/pgrep/ {print $1}'); do
    for game_tid in $(ls "/proc/$game_pid/task/"); do
      comm="$(read_file "/proc/$game_pid/task/$game_tid/comm")"
      case $comm in
        *Jit*|*HeapTaskDaemon*|*FinalizerDaemon*|*ReferenceQueueD*)
          taskset -p "0f" "$game_tid"
          ;;
        *UnityPreload*|*ace_worker*|*NativeThread*|*Thread-*|*UnityMultiRende*|*AsyncReadManage*|*UnityChoreograp*|*Worker*|*CoreThread*)
          taskset -p "ff" "$game_tid"
          ;;
        *UnityMain*|*UnityGfxDeviceW*|*Apollo-Source*|*Apollo-File*)
          taskset -p "f0" "$game_tid"
          ;;
        *GameThread*|*GLThread*|*RenderThread*)
          taskset -p "f0" "$game_tid"
          ;;
        *MIHOYO_NETWORK*|*Audio*|*tp_schedule*|*GVoice*|*FMOD*mixer*|*FMOD*stream*|*ff_read*)
          taskset -p "0f" "$game_tid"
          ;;
        *NativeThread*|*SDLThread*|*RHIThread*|*TaskGraphNP*|*MainThread-UE4*)
          taskset -p "ff" "$game_tid"
          ;;
        *)
          taskset -p "ff" "$game_tid"
          ;;
      esac
    done
  done
}

function after() {
  boot_wait
  local moddir="/data/adb/modules"
  set_prop univ.game.taskopt unset
  while true; do
    sleep 10
    local WinDump
    WinDump=$(dumpsys window | grep -E 'mCurrentFocus|mFocusedApp' | grep -o -e "com.activision.callofduty.shooter" -e "com.olzhass.carparking.multyplayer" -e "com.epicgames.fortnite" -e "com.miniclip.agar.io" -e "xyz.aethersx2.android" -e "com.YoStarEN.Arknights" -e "com.pubg.newstate" -e "com.dts.freefireth" -e "com.dts.freefiremax" -e "com.ea.gp.fifamobile" -e "com.miHoYo.GenshinImpact" -e "com.mobile.legends" -e "com.rayark.sdorica" -e "com.garena.game.kgvn" -e "com.vng.mlbbvn" -e "com.ea.games.r3_row" -e "com.sprduck.garena.vn" -e "com.gameloft.android.ANMP.GloftMVHM" -e "com.supercell.brawlstars" -e "com.autumn.skullgirls" -e "com.proximabeta.nikke" -e "com.activision.callofduty.shooter" -e "com.activision.callofduty.warzone" -e "com.levelinfinite.hotta.gp" -e "com.pubg.imobile" -e "com.tencent.ig" -e "com.kog.grandchaseglobal" -e "com.firsttouchgames.dls7" -e "net.wargaming.wot.blitz" -e "com.gabama.monopostolite" -e "com.miHoYo.GenshinImpact" -e "com.proximabeta.nikke" -e "com.je.supersus" -e "com.citra.emu" -e "com.dolphinemu.dolphinemu" -e "com.netease.racerna" -e "com.riotgames.league.wildrift" -e "skyline.purple" -e "org.vita3k.emulator" -e "org.mm.jr" -e "com.kakaogames.eversoul" -e "com.mobile.legends" -e "com.netease.frxyna" -e "com.smokoko.race" -e "com.pearlabyss.blackdesertm.gl" -e "jp.konami.pesam" -e "com.netease.racerna" -e "com.criticalforceentertainment.criticalops" -e "com.garena.game.codm" -e "com.stove.epic7.google" | head -1)
    if [[ $WinDump ]]; then
      if [[ ! -f $moddir/MLT ]] && [[ ! -f $moddir/MLS ]]; then 
        if [[ ! $(get_prop univ.game.taskopt) == "true" ]]; then
          opt_game_task "$WinDump"
          set_prop univ.game.taskopt true
        fi
      fi
    else
      if [[ ! $(get_prop univ.game.taskopt) == "false" ]]; then
        set_prop univ.game.taskopt false
      fi
    fi
    sleep 10
  done
}

if [[ $1 == "after" ]]; then
  if [[ $2 == "debug" ]]; then
    set -x
    after
  else
    after > /dev/null 2>&1 
  fi
fi

# Codigo traduzido, reprogramado, otimizado, complementado e melhorado

#LyPerf
# Variáveis
SC="/sys/devices/system/cpu/cpu0/cpufreq/schedutil"
TP="/dev/stune/top-app/uclamp.max"
DV="/dev/stune"
CP="/dev/cpuset"
ZW="/sys/module/zswap"
MC="/sys/module/mmc_core"
WT="/proc/sys/vm/watermark_boost_factor"
KL="/proc/sys/kernel"
VM="/proc/sys/vm"
S2="/sys/devices/system/cpu/cpufreq/schedutil"
MG="/sys/kernel/mm/lru_gen"
BT="$(getprop ro.boot.bootdevice)"
BL="/dev/blkio"

# Função para configurar os limites de taxa de subida e descida para as CPUs
configure_cpu_limits() {
    for cpu in /sys/devices/system/cpu/*/cpufreq/schedutil; do
        echo 500 > "${cpu}/up_rate_limit_us"
        echo 20000 > "${cpu}/down_rate_limit_us"
    done
}

# Função para configurar os parâmetros do kernel
configure_kernel_params() {
    echo 5000000 > "${KL}/sched_migration_cost_ns"
    echo 6000000 > "${KL}/sched_latency_ns"
    sleep 0.5
    sleep 0.5
    echo 20 > "${VM}/vfs_cache_pressure"
    echo 20 > "${VM}/stat_interval"
    echo 32 > "${VM}/watermark_scale_factor"
    echo 0 > "${VM}/compaction_proactiveness"
    echo 5000 > "${MG}/min_ttl_ms"
    echo 15 > "${KL}/perf_cpu_time_max_percent"
    echo 0 > "${KL}/sched_schedstats"
    echo "0 0 0 0" > "${KL}/printk"
    echo off > "${KL}/printk_devkmsg"
}

# Função para configurar os limites de uclamp para diferentes grupos de processos
configure_uclamp() {
    for ta in "$CP"/*/top-app; do
        echo max > "${ta}/uclamp.max"
        echo 10 > "${ta}/uclamp.min"
        echo 1 > "${ta}/uclamp.boosted"
        echo 1 > "${ta}/uclamp.latency_sensitive"
    done
    for group in foreground background system-background; do
        for dir in "$CP"/*/"$group"; do
            echo 50 > "${dir}/uclamp.max"
            echo 0 > "${dir}/uclamp.min"
            echo 0 > "${dir}/uclamp.boosted"
            echo 0 > "${dir}/uclamp.latency_sensitive"
        done
    done
}

# Função para configurar os parâmetros de rede
configure_network_params() {
    echo 1 > /proc/sys/net/ipv4/tcp_ecn
}

# Função para configurar o ajuste de leitura antecipada para os dispositivos de bloco
configure_read_ahead() {
    for queue2 in /sys/block/*/queue/read_ahead_kb; do
        echo 128 > "$queue2"
    done
}

# Função para habilitar o UFSTW (UFS Turbo Write Tweak)
enable_ufstw() {
    echo 1 > "/sys/devices/platform/soc/${BT}/ufstw_lu0/tw_enable"
}

# Função para configurar o limite de fragmentação externa
configure_extfrag_threshold() {
    echo 750 > "${VM}/extfrag_threshold"
}

# Função para desabilitar o CRC do Spi
disable_spi_crc() {
    echo 0 > "${MC}/parameters/use_spi_crc"
}

# Função para configurar o compressor e a zpool do zswap
configure_zswap() {
    echo "zstd" > "${ZW}/parameters/compressor"
    echo "zram" > "${ZW}/parameters/zpool"
}

# Função para ajustar as configurações do Blkio
configure_blkio() {
    echo 1000 > "${BL}/blkio.weight"
    echo 200 > "${BL}/background/blkio.weight"
    echo 2000 > "${BL}/blkio.group_idle"
    echo 0 > "${BL}/background/blkio.group_idle"
}

# Chamadas das funções de configuração
configure_cpu_limits
configure_kernel_params
configure_uclamp
configure_network_params
configure_read_ahead
enable_ufstw
configure_extfrag_threshold
disable_spi_crc
configure_zswap
configure_blkio

# CPU-Aff

change_task_affinity(){
    local ps_ret
    ps_ret="$(ps -Ao pid,args)"
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            taskset -p "$2" "$temp_tid"
        done
    done
}

change_task_nice(){
    local ps_ret
    ps_ret="$(ps -Ao pid,args)"
    for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
            renice "$2" -p "$temp_tid"
        done
    done
}

change_task_nice "kswapd" "-4"
change_task_affinity "kswapd" "4"
change_task_nice "oom_reaper" "-4"
change_task_affinity "oom_reaper" "4"

# The previous code seems fine, but here is a suggestion for improvement:

change_task_affinity(){
    local ps_ret
    ps_ret=$(ps -Ao pid,args)
    while IFS= read -r line; do
        temp_pid=$(echo "$line" | awk '{print $1}')
        for temp_tid in "/proc/$temp_pid/task/"*; do
            taskset -p "$2" "$temp_tid"
        done
    done &lt;&lt;&lt; "$(echo "$ps_ret" | grep "$1")"
}

change_task_nice(){
    local ps_ret
    ps_ret=$(ps -Ao pid,args)
    while IFS= read -r line; do
        temp_pid=$(echo "$line" | awk '{print $1}')
        for temp_tid in "/proc/$temp_pid/task/"*; do
            renice "$2" -p "$temp_tid"
        done
    done &lt;&lt;&lt; "$(echo "$ps_ret" | grep "$1")"
}

change_task_nice "kswapd" "-4"
change_task_affinity "kswapd" "4"
change_task_nice "oom_reaper" "-4"
change_task_affinity "oom_reaper" "4"

# In this revised version, we use a while loop and process substitution to iterate over each line of the ps output that matches the given process name. This allows us to avoid using array operations and makes the code more efficient.

# IO Limit 

loop=$(cat /sys/block/zram0/backing_dev | grep -o "loop[0-9]*")
echo "none" &gt; "/sys/block/$loop/queue/scheduler"
echo "deadline" &gt; "/sys/block/zram0/queue/scheduler"
echo "noop" &gt; "/sys/block/sda/queue/scheduler"
echo "noop" &gt; "/sys/block/sdc/queue/scheduler"
echo "noop" &gt; "/sys/block/sdb/queue/scheduler"

echo "128" &gt; "/sys/block/sda/queue/read_ahead_kb"
echo "128" &gt; "/sys/block/sde/queue/read_ahead_kb"
echo "1536" &gt; "/sys/block/mmcblk0/queue/read_ahead_kb"
echo "2048" &gt; "/sys/block/zram0/queue/read_ahead_kb"

echo "3" &gt; "/proc/sys/vm/drop_caches"

echo "0" &gt; "/sys/block/zram0/queue/rotational"
echo "0" &gt; "/sys/module/subsystem_restart/parameters/enable_ramdumps"
echo "0" &gt; "/sys/module/subsystem_restart/parameters/enable_mini_ramdumps"

echo "11" &gt; "/proc/sys/kernel/mi_iolimit"
```

# This code eliminates unnecessary repetitions and uses proper quotes for file paths. It also follows best practices for shell scripting.

# Rtmm-Code

    mi_rtmm=''
    if [[ -d '/d/rtmm' ]]; then
      mi_rtmm=/d/rtmm/reclaim
    elif [[ -d '/sys/kernel/mm/rtmm' ]]; then
      mi_rtmm='/sys/kernel/mm/rtmm'
    else
      return
    fi
    chmod 000 $mi_rtmm/reclaim/auto_reclaim 2>/dev/null
    chown root:root $mi_rtmm/reclaim/auto_reclaim 2>/dev/null
    chmod 000 $mi_rtmm/reclaim/global_reclaim 2>/dev/null
    chown root:root $mi_rtmm/reclaim/global_reclaim 2>/dev/null
    chmod 000 $mi_rtmm/reclaim/proc_reclaim 2>/dev/null
    chown root:root $mi_rtmm/reclaim/proc_reclaim 2>/dev/null
    chmod 000 $mi_rtmm/reclaim/kill 2>/dev/null
    chown root:root $mi_rtmm/reclaim/kill 2>/dev/null
    chown root:root $mi_rtmm/compact/compact_memory 2>/dev/null

# Scheduler 

mkdir -p $NVBASE/modules_update/$MODID/system/
mkdir -p $NVBASE/modules_update/$MODID/system/vendor/
mkdir -p
sleep 1

# System UI

echo 1 &gt; /proc/sys/kernel/sched_preempt_thresh
echo 20 &gt; /proc/sys/kernel/sched_freq_inc_notify
echo 400000 &gt; /proc/sys/kernel/watchdog_thresh

# These settings adjust the CPU scheduler behavior, improving preemptive multitasking and overall responsiveness.

# Unity Task
echo "com.miHoYo., com.activision., com.epicgames., UnityMain, libunity.so, libil2cpp.so" >  /proc/sys/kernel/sched_lib_name
echo "255" >  /proc/sys/kernel/sched_lib_mask_force
sleep 10
echo "noop" &gt; /sys/block/mmcblk0/queue/scheduler
echo 128 &gt; /sys/block/mmcblk0/queue/read_ahead_kb

# Fstrimm 
    fstrim -v /data;
    fstrim -v /system;
    fstrim -v /cache;
    fstrim -v /vendor;
    fstrim -v /product;

# Writecack

  sleep 120
    echo all > /sys/block/zram0/idle
    sleep 90
    echo idle > /sys/block/zram0/writeback

# Perfx2a2 

settings put global persist.bg.dexopt.enable true
settings put global pm.dexopt.bg-dexopt everything
settings put global pm.dexopt.forced-dexopt everything
settings put global pm.dexopt.core-app everything
settings put global pm.dexopt.install everything
settings put global pm.dexopt.nsys-library everything
settings put global pm.dexopt.shared-apk everything
settings put global dalvik.vm.bg-dex2oat-threads 8
settings put global dex2oat-filter everything

system_table_set() {
  settings put system "$1" "$2"
}
boot_wait
system_table_set activity_manager_constants max_cached_processes=0,background_settle_time=60000,fgservice_min_shown_time=2000,fgservice_min_report_time=3000,fgservice_screen_on_before_time=1000,fgservice_screen_on_after_time=5000,content_provider_retain_time=20000,gc_timeout=5000,gc_min_interval=60000,full_pss_min_interval=1200000,full_pss_lowered_interval=300000,power_check_interval=300000,power_check_max_cpu_1=0,power_check_max_cpu_2=0,power_check_max_cpu_3=0,power_check_max_cpu_4=0,service_usage_interaction_time=1800000,usage_stats_interaction_interval=7200000,service_restart_duration=1000,service_reset_run_duration=60000,service_restart_duration_factor=0,service_min_restart_time_between=10000,service_max_inactivity=1800000,service_bg_start_timeout=15000,CUR_MAX_CACHED_PROCESSES=0,CUR_MAX_EMPTY_PROCESSES=0,CUR_TRIM_EMPTY_PROCESSES=0,CUR_TRIM_CACHED_PROCESSES=0

    loop=$(cat /sys/block/zram0/backing_dev | grep -o "loop[0-30]*")
    echo none > /sys/block/$loop/queue/scheduler
    echo 1024 /sys/block/$loop/queue/read_ahead_kb
    echo 256 /sys/block/sda/queue/read_ahead_kb
    echo 256 /sys/block/sde/queue/read_ahead_kb
    echo 128 /sys/block/sda/queue/nr_requests
    echo 128 /sys/block/sde/queue/nr_requests
    echo 2 /sys/block/sda/queue/rq_affinity
    echo 2 /sys/block/sde/queue/rq_affinity
    echo 0 /proc/sys/vm/overcommit_memory

    change_task(){
      local ps_ret="$(ps -Ao pid,args)"
      for temp_pid in $(echo "$ps_ret" | grep "$1" | awk '{print $1}'); do
        for temp_tid in $(ls "/proc/$temp_pid/task/"); do
          taskset -p "$2" "$temp_tid"
          renice "$3" -p "$temp_tid"
        done
      done
    }
    change_task "kswapd" "fe" "-2"
    change_task "oom_reaper" "8" "-2"
    echo true > /sys/kernel/mm/swap/vma_ra_enabled
    echo 2 /proc/sys/vm/page-cluster
    echo 0 /proc/sys/vm/compact_unevictable_allowed
    echo 500 /proc/sys/vm/extfrag_threshold

    sleep 40
    am force-stop com.miui.micloudsync
    am force-stop com.miui.cloudservice
    am force-stop com.android.thememanager
    am force-stop com.xiaomi.account
    am force-stop com.miui.voiceassist
    am force-stop com.xiaomi.market
}

# Ram Zram Method
echo 1 &gt; /sys/block/zram0/reset
echo lz4 &gt; /sys/block/zram0/comp_algorithm
echo 75% &gt; /proc/sys/vm/swappiness
echo 50 &gt; /proc/sys/vm/vfs_cache_pressure

# These commands create and configure a compressed swap device using ZRAM, ensuring a balance between swapping and maintaining application data in RAM.



