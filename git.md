### Change git commit date

```console
git rebase -i --root
change pick to edit & save for the commit

GIT_COMMITTER_DATE="Mon Sep 19 16:30:23 2017 +0600" git commit --amend --date="Mon Sep 19 16:30:23 2017 +0600"

git rebase --continue
git push origin master -f
```