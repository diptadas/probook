# Git

## Change git commit date

```console
$git rebase -i --root
change pick to edit & save for the commit

$ GIT_COMMITTER_DATE="Mon Sep 19 16:30:23 2017 +0600" git commit --amend --date="Mon Sep 19 16:30:23 2017 +0600"

$ git rebase --continue
$ git push origin master -f
```

## Git clone with an access token

```console
$ git clone https://<access-token>@github.com/diptadas/my-repo.git
```

## Applying .gitignore to committed files

```
$ git rm -r --cached .
$ git add .
$ git commit -m "refreshed ignored files"
$ git push origin master
```

## Rename local & remote branch

- https://multiplestates.wordpress.com/2015/02/05/rename-a-local-and-remote-branch-in-git/

## History editor

- https://bokub.github.io/git-history-editor/

## All commit hash

```
$ git rev-list master --reverse
```

## All pretty log

```
$ git log -1000 --pretty=format:"%H*#%an*#%ae*#%at*#%s"
```

## All pretty log json

```
$ git log \
    --pretty=format:'{%n  "commit": "%H",%n  "author": "%aN <%aE>",%n  "date": "%ad",%n  "message": "%f"%n},' \
    $@ | \
    perl -pe 'BEGIN{print "["}; END{print "]\n"}' | \
    perl -pe 's/},]/}]/'
```

## Rewrite history using filter-branch

```
$ git filter-branch --env-filter \
'if test "$GIT_AUTHOR_NAME" = "diptadas" ||
    test "$GIT_COMMITTER_NAME" = "diptadas"; then
    export GIT_AUTHOR_NAME="Dipta"
    export GIT_COMMITTER_NAME="Dipta"
fi; if test "$GIT_AUTHOR_EMAIL" = "dipta670@gmail.com" ||
    test "$GIT_COMMITTER_EMAIL" = "dipta670@gmail.com"; then
    export GIT_AUTHOR_EMAIL="dipta@appscode.com"
    export GIT_COMMITTER_EMAIL="dipta@appscode.com"
fi; if test "$GIT_COMMIT" = "e356f603bd3897289e6d96370d5f75442e9c5a59"; then
    export GIT_AUTHOR_DATE="1495562691"
    export GIT_COMMITTER_DATE="1495562691"
elif test "$GIT_COMMIT" = "e9a87b0658b1792a77c20486c90fe4cfa1c540d0"; then
    export GIT_AUTHOR_DATE="1495476291"
    export GIT_COMMITTER_DATE="1495476291"
fi' --msg-filter \
'if test "$GIT_COMMIT" = "e356f603bd3897289e6d96370d5f75442e9c5a59"; then
    echo "Added UrlWrittingExample"
elif test "$GIT_COMMIT" = "17170532ccd25763c41a8b360c3de96babf41734"; then
    echo "Added AbstractExample"
else cat
fi' && rm -rf "$(git rev-parse --git-dir)/refs/original/"
```

## Remove all local branches except master

```
$ git branch | grep -v "master" | xargs git branch -D 
```

## Reset with remote branch

```
$ git fetch origin
$ git reset --hard origin/mybranch
```

## Download a folder from Github

- https://downgit.github.io/#/home
