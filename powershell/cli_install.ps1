# install CLI dependencies
Write-Output "Installing .Net (4.8)..."
Start-Process -FilePath ".\CLI\Dependencies\ndp48-web.exe" `
-ArgumentList "/q /norestart" `
-Wait `
-Verb RunAs > $null
Write-Output ".Net Installed Successfully"

# install/update pyRevit CLI
Write-Output "Installing pyRevit CLI..."
Start-Process -FilePath ".\CLI\pyRevit.CLI_4.8.8_signed.exe" `
-Wait `
-ArgumentList "/exenoui /qn" > $null
Write-Output "pyRevit CLI Installed Successfully"

# add pyRevit to path
Write-Output "Adding pyRevit to path..."
$env:path = "C:\Program Files\pyRevit CLI"
Write-Output "Done"
