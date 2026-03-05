#!/bin/bash
# hw.sh - sets up new lab files for IFT 383
# Run it, pick your lab and task number, and it handles the rest:
# naming, file extension, shebang, permissions, and drops you into vim.

# figure out where this script lives so paths work from anywhere
scriptdir="$(cd "$(dirname "$0")" && pwd)"

# first time? you'll be asked for your ASURITE. after that it's saved in .asurite
# (delete .asurite if you need to change it)
asurite_file="${scriptdir}/.asurite"

if [ -f "${asurite_file}" ]; then
    asurite=$(cat "${asurite_file}")
else
    read -p "Enter your ASURITE ID: " asurite
    echo "${asurite}" > "${asurite_file}"
    echo "ASURITE saved - you won't be asked again."
fi

# which lab and task?
read -p "Enter the lab letter: " labletter
read -p "Enter the task number: " tasknum

# zero-pad task number (1 -> 01)
tasknum=$(printf "%02d" "${tasknum}")

# lowercase it
labletter=$(echo "${labletter}" | tr '[:upper:]' '[:lower:]')

# each lab uses a different language, so set the extension and shebang:
#   c     = plain shell (no shebang)
#   e     = awk
#   f, g  = bash
#   h, i  = python
case "${labletter}" in
    c)
        ext=".sh"
        shebang=""
        ;;
    e)
        ext=".awk"
        shebang="#!/usr/bin/awk -f"
        ;;
    f|g)
        ext=".sh"
        shebang="#!/bin/bash"
        ;;
    h|i)
        ext=".py"
        shebang="#!/usr/bin/python3"
        ;;
    *)
        ext=".sh"
        shebang="#!/bin/bash"
        ;;
esac

# put it all together: lab_c_task_01_asurite.sh
filename="lab_${labletter}_task_${tasknum}_${asurite}${ext}"
labdir="${scriptdir}/lab_${labletter}"
filepath="${labdir}/${filename}"

# don't mess with existing files
if [ -f "${filepath}" ]; then
    echo "${filepath} already exists, try again."
    exit 111
fi

# write the shebang if the language needs one
if [ -n "${shebang}" ]; then
    echo "${shebang}" > "${filepath}"
else
    touch "${filepath}"
fi

# make it executable and open in vim
chmod u+x "${filepath}"
vim "${filepath}"
