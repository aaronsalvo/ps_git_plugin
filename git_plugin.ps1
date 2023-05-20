# This section removes aliases to builtin cmdlets. 
$builtins = @(
  'gcm',
  'gcb',
  'gc',
  'gcs',
  'gl',
  'gm',
  'gp',
  'gpv'
)
foreach ($builtin in $builtins) {
  if (Test-Path alias:$builtin) {
    del alias:$builtin -Force
  }
}

# Check if main exists and use instead of master
function git_main_branch {
  if ((Test-Path -Path "$($env:USERPROFILE)\.git") -or (Get-Command git -ErrorAction SilentlyContinue)) {
    $refs = @('refs/heads/main', 
              'refs/heads/trunk', 
              'refs/heads/mainline', 
              'refs/heads/default',
              'refs/remotes/origin/main', 
              'refs/remotes/origin/trunk',
              'refs/remotes/origin/mainline',
              'refs/remotes/origin/default', 
              'refs/remotes/upstream/main',
              'refs/remotes/upstream/trunk',
              'refs/remotes/upstream/mainline',
              'refs/remotes/upstream/default'
              )

    foreach ($ref in $refs) {
      if (git show-ref --verify "$ref" 2> $null) {
        $ref.Substring($ref.LastIndexOf('/') + 1)
        return
      }
    }

    Write-Output "master"
  }
}

# Check for develop and similarly named branches
function git_develop_branch() {
  if (!(git rev-parse --git-dir 2> $null)) { 
    return
  }

  foreach ($branch in @('dev', 'devel', 'development')) {
    if (git show-ref --verify refs/heads/$branch 2> $null) {
      Write-Output $branch
      return
    }
  }

  Write-Output "develop"
}

function g { git $args }
function ga { git add $args }
function gaa { git add --all $args }
function gam { git am $args }
function gama { git am --abort $args }
function gamc { git am --continue $args }
function gams { git am --skip $args }
function gamscp { git am --show-current-patch $args }
function gap { git apply $args }
function gapa { git add --patch $args }
function gapt { git apply --3way $args }
function gau { git add --update $args }
function gav { git add --verbose $args }
function gb { git branch $args }
function gbD { git branch --delete --force $args }
function gba { git branch --all $args }
function gbd { git branch --delete $args }
function gbg { git branch -vv | Select-String ": gone]" $args }
function gbl { git blame -b -w $args }
function gbnm { git branch --no-merged $args }
function gbr { git branch --remote $args }
function gbs { git bisect $args }
function gbsb { git bisect bad $args }
function gbsg { git bisect good $args }
function gbsr { git bisect reset $args }
function gbss { git bisect start $args }
function gc { git commit --verbose $args }
function gc! { git commit --verbose --amend $args }
function gca { git commit --verbose --all $args }
function gca! { git commit --verbose --all --amend $args }
function gcam { git commit --all --message $args }
function gcan! { git commit --verbose --all --no-edit --amend $args }
function gcans! { git commit --verbose --all --signoff --no-edit --amend $args }
function gcas { git commit --all --signoff $args }
function gcasm { git commit --all --signoff --message $args }
function gcb { git checkout -b $args }
function gcd { git checkout $(git_develop_branch) }
function gcf { git config --list $args }
function gcl { git clone --recurse-submodules $args }
function gclean { git clean --interactive -d $args }
function gcm { git checkout $(git_main_branch) }
function gcmsg { git commit -m $args }
function gcn! { git commit --verbose --no-edit --amend }
function gco { git checkout $args }
function gcor { git checkout --recurse-submodules $args }
function gcount { git shortlog --summary --numbered $args }
function gcp { git cherry-pick $args }
function gcpa { git cherry-pick --abort }
function gcpc { git cherry-pick --continue }
function gcs { git commit --gpg-sign $args }
function gcsm { git commit --signoff --message $args }
function gcss { git commit --gpg-sign --signoff $args }
function gcssm { git commit --gpg-sign --signoff --message $args }
function gd { git diff $args }
function gdca { git diff --cached $args }
function gdct { git describe --tags $(git rev-list --tags --max-count=1) $args }
function gdcw { git diff --cached --word-diff $args }
function gds { git diff --staged $args }
function gdt { git diff-tree --no-commit-id --name-only -r $args }
#function gdup { git diff @{upstream} $args }
function gdw { git diff --word-diff $args }
function gf { git fetch $args }
function gfa { git fetch --all --prune --jobs=10 $args }
function gfg { git ls-files | Select-String $args }
function gfo { git fetch origin $args }
function gg { git gui citool $args }
function gga { git gui citool --amend $args }
function ggpull { git pull origin "$(git_current_branch)" $args }
function ggpush { git push origin "$(git_current_branch)" $args }
function ggsup { git branch --set-upstream-to=origin/$(git_current_branch) $args }
function ghh { git help $args }
function gignore { git update-index --assume-unchanged $args }
function gignored { git ls-files -v | Select-String "^[[:lower:]]" $args }
function git-svn-dcommit-push {
    git svn dcommit
    git push github $(git_main_branch):svntrunk $args
}

function gk { \gitk --all --branches $args }
function gke { \gitk --all $(git log --walk-reflogs --pretty=%h) $args }
function gl { git pull $args }
function glg { git log --stat $args }
function glgg { git log --graph $args }
function glgga { git log --graph --decorate --all $args }
function glgm { git log --graph --max-count=10 $args }
function glgp { git log --stat --patch $args }
function glo { git log --oneline --decorate $args }
function glod { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' $args }
function glods { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short $args }
function glog { git log --oneline --decorate --graph $args }
function gloga { git log --oneline --decorate --graph --all $args }
function glol { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' $args }
function glola { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all $args }
function glols { git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat $args }
function glp { _git_log_prettily $args }
function gluc { git pull upstream $(git_current_branch) $args }
function glum { git pull upstream $(git_main_branch) $args }
function gm { git merge $args }
function gma { git merge --abort $args }
function gmom { git merge origin/$(git_main_branch) $args }
function gms { git merge --squash $args }
function gmtl { git mergetool --no-prompt $args }
function gmtlvim { git mergetool --no-prompt --tool=vimdiff $args }
function gmum { git merge upstream/$(git_main_branch) $args }
function gp { git push $args }
function gpd { git push --dry-run $args }
function gpf { git push --force-with-lease --force-if-includes $args }
function gpf! { git push --force $args }
function gpoat {
    git push origin --all
    git push origin --tags $args
}

function gpod { git push origin --delete $args }
function gpr { git pull --rebase $args }
function gpristine { git reset --hard git clean --force -dfx $args }
function gpsup { git push --set-upstream origin $(git_current_branch) $args }
function gpsupf { git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes $args }
function gpu { git push upstream $args }
function gpv { git push --verbose $args }
function gr { git remote $args }
function gra { git remote add $args }
function grb { git rebase $args }
function grba { git rebase --abort $args }
function grbc { git rebase --continue $args }
function grbd { git rebase $(git_develop_branch) $args }
function grbi { git rebase --interactive $args }
function grbm { git rebase $(git_main_branch) $args }
function grbo { git rebase --onto $args }
function grbom { git rebase origin/$(git_main_branch) $args }
function grbs { git rebase --skip $args }
function grep { Select-String --pattern $args --exclude='*.bzr','CVS','.git','.hg','.svn','.idea','.tox' $args }
function grev { git revert $args }
function grh { git reset $args }
function grhh { git reset --hard $args }
function grm { git rm $args }
function grmc { git rm --cached $args }
function grmv { git remote rename $args }
function groh { git reset origin/$(git_current_branch) --hard $args }
function grrm { git remote remove $args }
function grs { git restore $args }
function grset { git remote set-url $args }
function grss { git restore --source $args }
function grst { git restore --staged $args }
function grt { Set-Location "$(git rev-parse --show-toplevel || echo .)" $args }
function gru { git reset -- $args }
function grup { git remote update $args }
function grv { git remote --verbose $args }
function gsb { git status --short --branch $args }
function gsd { git svn dcommit $args }
function gsh { git show $args }
function gsi { git submodule init $args }
function gsps { git show --pretty=short --show-signature $args }
function gsr { git svn rebase $args }
function gss { git status --short $args }
function gst { git status $args }
function gsta { git stash push $args }
function gstaa { git stash apply $args }
function gstall { git stash --all $args }
function gstc { git stash clear $args }
function gstd { git stash drop $args }
function gstl { git stash list $args }
function gstp { git stash pop $args }
function gsts { git stash show --text $args }
function gsu { git submodule update $args }
function gsw { git switch $args }
function gswc { git switch --create $args }
function gswd { git switch $(git_develop_branch) $args }
function gswm { git switch $(git_main_branch) $args }
function gtl { git tag --sort=-v:refname -n --list "$args*" $args }
function gts { git tag --sign $args }
function gtv { git tag | Sort-Object -Version $args }
function gunignore { git update-index --no-assume-unchanged $args }
function gunwip { git log --max-count=1 | Select-String -Quiet "--wip--" && git reset HEAD~1 $args }
function gup { git pull --rebase $args }
function gupa { git pull --rebase --autostash $args }
function gupav { git pull --rebase --autostash --verbose $args }
function gupom { git pull --rebase origin $(git_main_branch) $args }
function gupomi { git pull --rebase=interactive origin $(git_main_branch) $args }
function gupv { git pull --rebase --verbose $args }
function gwch { git whatchanged -p --abbrev-commit --pretty=medium $args }
function gwip {
    git add -A
    git rm $(git ls-files --deleted) $args
    git commit --no-verify --message="--wip-- [skip ci]" $args
}

function history { Get-Command -type alias | Select-String "git" | Select-Object -expandproperty Name $args }
function ungit {
    git reset $args
    git checkout -- $args
}

