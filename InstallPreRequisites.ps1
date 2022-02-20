
<#
.Install-Python
Downloads and installs Python into $env:LocalAppData\Programs\Python\$PythonVersion
#>
function Install-Python {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DownloadDir
    )

    $PythonVersion = "3.10.2"
    $PythonInstaller = "python-$PythonVersion-amd64.exe"
    $PythonInstallDir = "$env:LocalAppData\Programs\Python\$PythonVersion"
    Start-BitsTransfer -Source "https://www.python.org/ftp/python/$PythonVersion/$PythonInstaller" -Destination "$DownloadDir\$PythonInstaller"

    Start-Process -FilePath "$DownloadDir\$PythonInstaller" -ArgumentList @(
        "/passive",
        "InstallAllUsers=0",
        "DefaultJustForMeTargetDir=`"$PythonInstallDir`"",
        "AssociateFiles=0",
        "Shortcuts=0",
        "Include_doc=0"
        "Include_dev=0",
        "Include_launcher=0",
        "Include_tcltk=0",
        "Include_test=0"
    ) -Wait

    [System.Environment]::SetEnvironmentVariable("PYTHON_HOME","$PythonInstallDir",[System.EnvironmentVariableTarget]::User)
    Start-Process -FilePath "$PythonInstallDir\python.exe" -ArgumentList @("-m", "pip", "install", "--upgrade", "pip") -Wait
    Start-Process -FilePath "$PythonInstallDir\python.exe" -ArgumentList @("-m", "pip", "install", "mkdocs") -Wait
}

<#
.Install-MiKTeX
Downloads and installs MiKTeX into $env:LocalAppData\Programs\MiKTeX
#>
function Install-MiKTeX {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DownloadDir
    )

    $MiKTeXVersion = "21.12"
    $MiKTeXInstaller = "basic-miktex-$MiKTeXVersion-x64.exe"
    $LocalRepoDir = "C:\ProgramData\MiKTeX"
    $MiKTeXInstallDir = "$env:LocalAppData\Programs\MiKTeX"

    if( -Not (Test-Path -Path "$LocalRepoDir")) {
        New-Item -ItemType "Directory" -Path "$LocalRepoDir"
    }

    Start-BitsTransfer -Source "https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/$MiKTeXInstaller" -Destination "$DownloadDir\$MiKTeXInstaller"

    Start-Process -FilePath "$DownloadDir\$MiKTeXInstaller" -ArgumentList @(
        "--private",
        "--package-set=complete",
        "--unattended",
        "--remote-package-repository=https://mirror.easyname.at/ctan/systems/win32/miktex/tm/packages/",
        "--local-package-repository=C:\ProgramData\MiKTeX",
        "--user-config=`"$env:AppData\MiKTeX`"",
        "--user-data=`"$env:LocalAppData\MiKTeX`"",
        "--user-install=`"$MiKTeXInstallDir`""
    ) -Wait

    # Search for updates to prevent warning messages from pdflatex
    Start-Process -FilePath "$MiKTeXInstallDir\miktex\bin\x64\mpm.exe" -ArgumentList @("--find-updates") -Wait
}

<#
.Install-Pandoc
Downloads and installs Pandoc into $env:LocalAppData\Programs\Pandoc
#>
function Install-Pandoc {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DownloadDir
    )
    
    $PandocVersion="2.17.1.1"
    $PandocMsi="pandoc-$PandocVersion-windows-x86_64.msi"
    Start-BitsTransfer -Source "https://github.com/jgm/pandoc/releases/download/$PandocVersion/$PandocMsi" -Destination "$DownloadDir\$PandocMsi"
    Start-Process -FilePath "msiexec" -ArgumentList @("/i", "$DownloadDir\$PandocMsi", "/qn", "PPLICATIONFOLDER=`"$env:LocalAppData\Programs\Pandoc`"", "ADDLOCAL=MainProgram,Complete,Manual,Citation") -Wait
}

<#
.Install-Template
Downloads and extracts the "EisVogel" template.
#>
function Install-Template {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DownloadDir
    )
    
    $EisvogelVersion="2.0.0"
    $EisvogelZip="Eisvogel-$EisvogelVersion.zip"
    Start-BitsTransfer -Source "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v$EisvogelVersion/$EisvogelZip" -Destination "$DownloadDir\$EisvogelZip"
    Expand-Archive -Path "$DownloadDir\$EisvogelZip" -DestinationPath "$env:AppData\pandoc\templates\"

}

# Create the download directory for the binaries
$UUID = (New-Guid)
$DownloadDir = "$env:TEMP\$UUID"
New-Item -ItemType "Directory" -Path "$DownloadDir"

Install-Python -DownloadDir "$DownloadDir"
Install-MiKTeX -DownloadDir "$DownloadDir"
Install-Pandoc -DownloadDir "$DownloadDir"
Install-Template -DownloadDir "$DownloadDir"

Remove-Item -Recurse -Force -Path "$DownloadDir"
