#!/bin/bash
files=4
size=1G
for ((f = 1; f <= files; f++)); do
    dd if=/dev/urandom of="$f" bs="$size" count=1 status=none
    sudo pvcreate "$(sudo losetup --find --show "$f")"
done
#Handling loop names not automized
sudo vgcreate task-vg /dev/loop13 /dev/loop/14
sudo lvcreate -l 100% -n task-lv task
sudo mkfs.ext3 -L test /dev/task-vg/task-lv
mkdir mount
sudo mount /dev/task-vg/task-lv mount
sudo vgextend task /dev/loop15 /dev/loop16
sudo lvresize -r -l +100%FREE task-vg/task-lv
sudo df -h /dev/task-vg/task-lv