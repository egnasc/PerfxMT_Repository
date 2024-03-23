#!/system/bin/sh
#!/bin/bash
MODDIR=${0%/*}
sleep 1
1°-deadline
Equally | 1°-bfq
2°-zen
Samsung| 2° -ssg
3°-row
4°-cfq
5°-fiops
6°-sio
Samsung | 7°- mq-deadline
8°-noop

# Noop
echo noop > /sys/block/mmcblk0/queue/scheduler
echo noop > /sys/block/mmcblk1/queue/scheduler
echo noop > /sys/block/sda/queue/scheduler
echo noop > /sys/block/sdb/queue/scheduler
echo noop > /sys/block/sdc/queue/scheduler
echo noop > /sys/block/sdd/queue/scheduler
echo noop > /sys/block/sde/queue/scheduler
echo noop > /sys/block/sdf/queue/scheduler

# Mq-Ddeadline
echo mq-deadline > /sys/block/mmcblk0/queue/scheduler
echo mq-deadline > /sys/block/mmcblk1/queue/scheduler
echo mq-deadline > /sys/block/sda/queue/scheduler
echo mq-deadline > /sys/block/sdb/queue/scheduler
echo mq-deadline > /sys/block/sdc/queue/scheduler
echo mq-deadline > /sys/block/sdd/queue/scheduler
echo mq-deadline > /sys/block/sde/queue/scheduler
echo mq-deadline > /sys/block/sdf/queue/scheduler

# Sio
echo sio > /sys/block/mmcblk0/queue/scheduler
echo sio > /sys/block/mmcblk1/queue/scheduler
echo sio > /sys/block/sda/queue/scheduler
echo sio > /sys/block/sdb/queue/scheduler
echo sio > /sys/block/sdc/queue/scheduler
echo sio > /sys/block/sdd/queue/scheduler
echo sio > /sys/block/sde/queue/scheduler
echo sio > /sys/block/sdf/queue/scheduler

# Fiops
echo fiops > /sys/block/mmcblk0/queue/scheduler
echo fiops > /sys/block/mmcblk1/queue/scheduler
echo fiops > /sys/block/sda/queue/scheduler
echo fiops > /sys/block/sdb/queue/scheduler
echo fiops > /sys/block/sdc/queue/scheduler
echo fiops > /sys/block/sdd/queue/scheduler
echo fiops > /sys/block/sde/queue/scheduler
echo fiops > /sys/block/sdf/queue/scheduler

# Cfq
echo cfq > /sys/block/mmcblk0/queue/scheduler
echo cfq > /sys/block/mmcblk1/queue/scheduler
echo cfq > /sys/block/sda/queue/scheduler
echo cfq > /sys/block/sdb/queue/scheduler
echo cfq > /sys/block/sdc/queue/scheduler
echo cfq > /sys/block/sdd/queue/scheduler
echo cfq > /sys/block/sde/queue/scheduler
echo cfq > /sys/block/sdf/queue/scheduler

# Row
echo row > /sys/block/mmcblk0/queue/scheduler
echo row > /sys/block/mmcblk1/queue/scheduler
echo row > /sys/block/sda/queue/scheduler
echo row > /sys/block/sdb/queue/scheduler
echo row > /sys/block/sdc/queue/scheduler
echo row > /sys/block/sdd/queue/scheduler
echo row > /sys/block/sde/queue/scheduler
echo row > /sys/block/sdf/queue/scheduler

# Ssg
echo ssg > /sys/block/mmcblk0/queue/scheduler
echo ssg > /sys/block/mmcblk1/queue/scheduler
echo ssg > /sys/block/sda/queue/scheduler
echo ssg > /sys/block/sdb/queue/scheduler
echo ssg > /sys/block/sdc/queue/scheduler
echo ssg > /sys/block/sdd/queue/scheduler
echo ssg > /sys/block/sde/queue/scheduler
echo ssg > /sys/block/sdf/queue/scheduler

# Zen
echo zen > /sys/block/mmcblk0/queue/scheduler
echo zen > /sys/block/mmcblk1/queue/scheduler
echo zen > /sys/block/sda/queue/scheduler
echo zen > /sys/block/sdb/queue/scheduler
echo zen > /sys/block/sdc/queue/scheduler
echo zen > /sys/block/sdd/queue/scheduler
echo zen > /sys/block/sde/queue/scheduler
echo zen > /sys/block/sdf/queue/scheduler

# Bfq
echo bfq > /sys/block/mmcblk0/queue/scheduler
echo bfq > /sys/block/mmcblk1/queue/scheduler
echo bfq > /sys/block/sda/queue/scheduler
echo bfq > /sys/block/sdb/queue/scheduler
echo bfq > /sys/block/sdc/queue/scheduler
echo bfq > /sys/block/sdd/queue/scheduler
echo bfq > /sys/block/sde/queue/scheduler
echo bfq > /sys/block/sdf/queue/scheduler

# Deadline
echo deadline > /sys/block/mmcblk0/queue/scheduler
echo deadline > /sys/block/mmcblk1/queue/scheduler
echo deadline > /sys/block/sda/queue/scheduler
echo deadline > /sys/block/sdb/queue/scheduler
echo deadline > /sys/block/sdc/queue/scheduler
echo deadline > /sys/block/sdd/queue/scheduler
echo deadline > /sys/block/sde/queue/scheduler
echo deadline > /sys/block/sdf/queue/scheduler

sleep 1

# ZRam Charger
echo 1 > /sys/block/zram0/reset
echo 0 > /sys/block/zram0/comp_algorithm
echo lz4 > /sys/block/zram0/comp_algorithm
echo 0 > /sys/block/zram0/disksize
echo 2521225472 > /sys/block/zram0/disksize
echo 4 > /sys/block/zram0/max_comp_streams

sleep 30

# Notification
sleep 10
su -lp 2000 -c "cmd notification post -S bigtext -t 'PerFx Mthread' 'Tag' 'Successfully applied to the system'"

sleep 10
MODDIR=${0%/*}
"${MODDIR}/codes.sh" > /dev/null
