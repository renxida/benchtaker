remote=$1
rsync -razh ~/benchtaker $remote:~/

ssh $remote 'cd benchtaker/safeside && tmux new -s runsafeside -d "bash ./run.sh"'
