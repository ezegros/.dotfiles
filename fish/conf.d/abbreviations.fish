if status is-interactive
    abbr -a -g vim nvim
    abbr -a -g vi nvim

    abbr -a -g - 'z -'

    abbr -a -g ga 'git add'
    abbr -a -g gap 'git add --patch'
    abbr -a -g gb 'git branch'
    abbr -a -g gbm 'git branch -m'
    abbr -a -g gca 'git commit --amend'
    abbr -a -g gcmsg 'git commit -m'
    abbr -a -g gcam 'git commit -am'
    abbr -a -g gcl 'git clone'
    abbr -a -g gco 'git checkout'
    abbr -a -g gcb 'git checkout -b'
    abbr -a -g gdf 'git diff'
    abbr -a -g gf 'git fetch'
    abbr -a -g gfa 'git fetch --all'
    abbr -a -g glo 'git log'
    abbr -a -g gm 'git merge'
    abbr -a -g gpl 'git pull'
    abbr -a -g gp 'git push'
    abbr -a -g gpum 'git push -u origin master'
    abbr -a -g gpuo 'git push -u origin'
    abbr -a -g gpsup 'git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
    abbr -a -g gpf 'git push --force-with-lease'
    abbr -a -g grb 'git rebase'
    abbr -a -g grba 'git rebase --abort'
    abbr -a -g grbc 'git rebase --continue'
    abbr -a -g grbi 'git rebase -i'
    abbr -a -g gs 'git stash'
    abbr -a -g gd 'git diff'
    abbr -a -g gcp 'git cherry-pick'

    abbr -a -g k 'kubectl'

    abbr -a -g dots 'cd $HOME/.dotfiles'
end
