#!/bin/bash
#shellcheck disable=SC1009
#shellcheck disable=SC1073
#shellcheck disable=SC2164
logfile=$(basename -s .sh "$0").log
function usage() {
    echo "Usage: $(basename $0) [-h] [-d] [-r]"
    echo " -d, --directory <directory> A directory, where script should make new dirs and files. Default is current dir."
    echo " -s, --depth <number>        Subdirs depth generation. Default is 3."
    echo " -c, --subdirs <number>      Number of dirs to generate in each directory."
    echo " -f, --files <number>        Number of files to create in each directory. Default is 10."
    echo " -m, --maxsize <number>      Maximum size of file in bytes (number only). Default is 1488."
    echo " -h, --help                  Show this help"
    echo ""
    echo "This script randomly generates files and dirs in specified dir according to given args"
    echo "Max name length is 8 symbols and cannot be changed by user."
    echo "Debug information can be found in $logfile"
}

#Max name length is constant according to task
max_name_length=8
depth=3
subdirs=3
files=10
max_size=1488
directory=$(pwd)

while :; do
    case "$1" in
    -d | --directory)
        shift
        directory="$1"
        shift
        ;;
    -s | --depth)
        shift
        depth="$1"
        shift
        ;;
    -c | --subdirs)
        shift
        subdirs="$1"
        shift
        ;;
    -f | --files)
        shift
        files="$1"
        shift
        ;;
    -m | --maxsize)
        shift
        max_size="$1"
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    *) # No more options
        break
        ;;
    esac
done

echo "Depth is $depth, subdirs is $subdirs, files is $files" >"$logfile"
cd "$directory"

#Function generates random name with random length limited by $max_name_length
random_name() {
    name_length=$((RANDOM % max_name_length + 1))
    name=$(tr -dc A-Za-z0-9 </dev/urandom | head -c $name_length)
}
create_files() {
    for ((f = 1; f <= files; f++)); do
        random_name
        dd if=/dev/urandom of="$name" bs="$max_size" count=1 status=none
    done
}
d=1
create_dirs() {
    if [[ $d -lt $depth ]]; then
        ((d++))
        for ((s = 1; s <= subdirs; s++)); do
            parent_dir=$(pwd)
            random_name
            mkdir "$name" && cd "$_"
            create_files
            create_dirs
            cd "$parent_dir"
        done
    fi
}

create_files
create_dirs
# for ((d = 1; d <= depth; d++)); do
#     create_dirs
# done
# for ((d = 1; d <= depth; d++)); do
#     for ((s = 1; s <= subdirs; s++)); do
#         name_length=$((RANDOM % max_name_length + 1))
#         parent_dir=$(pwd)
#         mkdir "$(tr -dc A-Za-z0-9 </dev/urandom | head -c $name_length)" && cd "$_"
#         for ((f = 1; f <= files; f++)); do
#             name_length=$((RANDOM % max_name_length + 1))
#             touch "$(tr -dc A-Za-z0-9 </dev/urandom | head -c $name_length)"
#         done
#         cd "$parent_dir"
#     done
# done
# cd "$depth_dir"
