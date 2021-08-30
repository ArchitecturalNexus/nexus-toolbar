# pyRevit deploy root path
$pyrevitroot = "C:\pyRevit"

# the name of the clone we are going to create
$ourclonename = "nexus"

# pyRevit clone install path
$pyrevitcoredest = $(Join-Path $pyrevitroot $ourclonename)

# pyRevit extension install path
$pyrevitexts = $(Join-Path $pyrevitroot "Extensions")

# path to Nexus extension and repo
$ourextname = "NexusToolbar"
$ourpyrevitext = ".\extension\nexus-toolbar.git"

#
#
# DEFINING FUNCTIONS FOR PYREVIT
#
#

# confirms target path exists and is empty, removes existing if found
function Confirm-Path ([string] $targetpath) {
  Write-Output "Confirming $($targetpath)"

  If (Test-Path $targetpath) {
    Remove-Item -Path $targetpath -Recurse -Force
  }

  New-Item -ItemType Directory -Force -Path $targetpath > $null
}

# test if a command exists in the environment
function Text-CommandExists {
  param ($command)
  $oldPreference = $ErrorActionPreference
  $ErrorActionPreference = 'stop'

  try {
    if(Get-Command $command) {
      return $true
    }
  }
  catch {
    return $false
  }
  finally {
    $ErrorActionPreference = $oldPreference
  }
}

#
#
# DEFINING FUNCTIONS FOR ORCHESTRATION
#
#

# clone pyRevit
function Clone-PyRevit() {
  # verify paths exist, and are clean
  Confirm-Path $pyrevitroot
  Confirm-Path $pyrevitexts

  # close all open Revit instances first
  Write-Output "Closing all instances of Revit"
  pyrevit revits killall

  # forget all previous pyRevit clones
  pyrevit clones forget $pyrevitclonename > $null

  # clone pyRevit
  Write-Output "Cloning pyRevit Core..."
  pyrevit clone $ourclonename --dest=$pyrevitcoredest
}

# install extensions
function Install-Extensions() {
  # verify paths exist and are clean
  Confirm-Path $pyrevitexts

  # install extensions
  Write-Output "Cloning Extensions..."
  pyrevit extend ui $ourextname $ourpyrevitext --dest=$pyrevitexts
}

# configure pyRevit
function Configure-PyRevit() {
  Write-Output "Configuring pyRevit..."
  pyrevit configs logs none
  pyrevit configs checkupdates disable
  pyrevit configs autoupdate disable
  pyrevit configs rocketmode enable
  pyrevit configs filelogging disable
  pyrevit configs loadbeta disable
  pyrevit configs usagelogging disable

  pyrevit configs seed
}

# attach the pyRevit extension to all installed revit versions for all users
function Attach-PyRevit() {
  Write-Output "Attaching pyRevit to installed Revits..."
  pyrevit attach $ourclonename 277 --installed --allusers
}

#
#
# NOW, DO THE THING!
#
#

if (Test-CommandExists "pyrevit") {
  Clone-PyRevit
  Install-Extensions
  Configure-PyRevit
  Attach-PyRevit
}
