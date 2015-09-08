#!/bin/bash

TIM=`date '+%F_%T'`
BAK=backup_$TIM
SRC=`pwd`

# TODO possible improvement using rsync
#rsync -av --exclude=".*" src dest

echo
echo "Installing Awesome config..."
cd ~/.config/
if [ "$1" != "--no-backup" ] && [ -e awesome ] ; then
    echo "  renamimg original awesome directory to awesome.$BAK"
    mv awesome awesome.$BAK
else
    echo "  removing old awesome directory"
    rm -rf awesome
fi
echo "  copying new files ..."
cp -r $SRC awesome
echo "  deleting unneeded files ..."
cd awesome && rm -rf .git* install.sh
echo "done."
echo
