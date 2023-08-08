[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

# Ensure develop branch is up to date
git switch develop
git pull --rebase=false origin --prune

# Ensure main branch is up to date
git fetch
git update-ref refs/heads/main refs/remotes/origin/main

# Create release
git flow init -d
git flow release start $Version develop
git flow release finish -m $Version $Version

# Push changes
git push origin refs/heads/develop
git push origin refs/heads/main
git push origin refs/tags/$Version