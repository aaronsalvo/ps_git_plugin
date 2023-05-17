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
function gst { git status }
function gcmsg { git commit -m $args }

