[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $PythonVersion = "3.10.6",

    [Parameter()]
    [string]
    $MiktexVersion = "22.7",

    [Parameter()]
    [string]
    $PanDocVersion = "2.19.2",

    [Parameter()]
    [string]
    $EisVogelVersion = "2.0.0",

    [Parameter(Mandatory = $false)]
    [Switch]
    $KeepArtifacts = $false
)

<#
.Install-Python
Downloads and installs Python into $env:LocalAppData\Programs\Python\$PythonVersion
#>
function Install-Python {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DownloadDir,

        [Parameter()]
        [string]
        $Version = "3.10.6"
    )

    $PythonInstaller = "python-$Version-amd64.exe"
    $PythonInstallDir = "$env:LocalAppData\Programs\Python\$Version"
    Start-BitsTransfer -Source "https://www.python.org/ftp/python/$Version/$PythonInstaller" -Destination "$DownloadDir\$PythonInstaller"

    Start-Process -FilePath "$DownloadDir\$PythonInstaller" -ArgumentList @(
        "/passive",
        "InstallAllUsers=0",
        "DefaultJustForMeTargetDir=`"$PythonInstallDir`"",
        "AssociateFiles=0",
        "Shortcuts=0",
        "Include_doc=0"
        "Include_dev=0",
        "PrependPath=1",
        "Include_launcher=0",
        "Include_tcltk=0",
        "Include_test=0"
    ) -Wait

    [System.Environment]::SetEnvironmentVariable("PYTHON_HOME", "$PythonInstallDir", [System.EnvironmentVariableTarget]::User)
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
        $DownloadDir,

        [Parameter()]
        [string]
        $Version = "22.7"
    )

    $MiKTeXInstaller = "basic-miktex-$Version-x64.exe"
    $MiKTeXInstallDir = "$env:LocalAppData\Programs\MiKTeX"

    Start-BitsTransfer -Source "https://miktex.org/download/ctan/systems/win32/miktex/setup/windows-x64/$MiKTeXInstaller" -Destination "$DownloadDir\$MiKTeXInstaller"

    Start-Process -FilePath "$DownloadDir\$MiKTeXInstaller" -ArgumentList @("--install", "--unattended", "--user-install=`"$MiKTeXInstallDir`"") -Wait
    Start-Process -FilePath "$MiKTeXInstallDir\miktex\bin\x64\miktex.exe" -ArgumentList @("packages", "update") -Wait -NoNewWindow
    $Packages = @("adjustbox", "auxhook", "bigintcalc", "bitset", "bookmark", "caption", "collectbox", "colortbl", "csquotes", "etexcmds", "fancyhdr", "float", "footmisc", "footnotebackref", "geometry", "gettitlestring", "hycolor", "ifoddpage", "infwarerr", "intcalc", "koma-script", "kvdefinekeys", "kvoptions", "kvsetkeys", "latex-graphics-dev", "letltxmacro", "ltxcmds", "ly1", "mdframed", "microtype", "mweights", "needspace", "pagecolor", "pdfescape", "refcount", "rerunfilecheck", "setspace", "sourcecodepro", "sourcesanspro", "titling", "uniquecounter", "upquote", "varwidth", "xurl", "zref")
    foreach ($Package in $Packages) {
        Start-Process -FilePath "$MiKTeXInstallDir\miktex\bin\x64\miktex.exe" -ArgumentList @("packages", "install", "$Package") -Wait -NoNewWindow
    }
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
        $DownloadDir,

        [Parameter()]
        [string]
        $Version = "2.19.2"
    )
    
    $PandocMsi = "pandoc-$Version-windows-x86_64.msi"
    Start-BitsTransfer -Source "https://github.com/jgm/pandoc/releases/download/$Version/$PandocMsi" -Destination "$DownloadDir\$PandocMsi"
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
        $DownloadDir,

        [Parameter()]
        [string]
        $Version = "2.0.0"
    )
    
    $EisvogelZip = "Eisvogel-$Version.zip"
    Start-BitsTransfer -Source "https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v$Version/$EisvogelZip" -Destination "$DownloadDir\$EisvogelZip"
    Expand-Archive -Path "$DownloadDir\$EisvogelZip" -DestinationPath "$env:AppData\pandoc\templates\"

}

# Create the download directory for the binaries
$UUID = (New-Guid)
$DownloadDir = "$env:TEMP\$UUID"
New-Item -ItemType "Directory" -Path "$DownloadDir"

Install-Python -DownloadDir "$DownloadDir" -Version "$PythonVersion"
Install-MiKTeX -DownloadDir "$DownloadDir" -Version "$MiktexVersion"
Install-Pandoc -DownloadDir "$DownloadDir" -Version "$PanDocVersion"
Install-Template -DownloadDir "$DownloadDir" -Version "$EisVogelVersion"

if ($KeepArtifacts -eq $false)
{
    Write-Host -Object "Deleting downloaded artifacts"
    Remove-Item -Recurse -Force -Path "$DownloadDir"
    Write-Host -Object "Downloaded artifacts deleted"
}