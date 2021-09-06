
dstRepository="$1"
files="$2"

echo "syncing $files to $dstRepository"
pwd
set

cat $GITHUB_EVENT_PATH

# only run on pushes to master (or other specified branch)

# check out dst project to tmp dir

# for each file
#   check if it is the push
#   what if the action missed to run on a push?
#   if file has changed
#   copy file into tmp dir
# end

# if there are changes in tmp dir
# push changes to a branch
# create pr

