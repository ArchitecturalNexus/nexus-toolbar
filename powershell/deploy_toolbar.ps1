# pyRevit deploy root path
$pyrevitroot = "C:\pyRevit"

# the name of the clone we are going to create
$ourclonename = "nexus"

# pyRevit clone install path
$pyrevitcoredest = $(Join-Path $pyrevitroot $ourclonename)

# pyRevit extension install path
$pyrevitexts = $(Join-Path $pyrevitroot "Extensions")
