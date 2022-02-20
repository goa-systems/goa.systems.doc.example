[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $OutDir = "out"
)

$Errors = $false

# Validate that tools are available in the global path ($env:PATH, %PATH%, ...)
try { mkdocs.exe --help | Out-Null } catch { Write-Error -Message "Can not find mkdocs."; $Errors = $true }
try { pandoc.exe --help | Out-Null } catch { Write-Error -Message "Can not find pandoc."; $Errors = $true }

if($Errors -eq $false){
    # Clean up
    if(Test-Path -Path "$OutDir"){
        Write-Host -Object "Output directory [$OutDir] exists. Cleaning up."
        Remove-Item -Path "$OutDir" -Force -Recurse | Out-Null
        Write-Host -Object "Existing output directory deleted."
    }

    # Create output directories
    Write-Host -Object "Creating directories"
    New-Item -ItemType "Directory" -Path "$OutDir" | Out-Null
    New-Item -ItemType "Directory" -Path "$OutDir\pdf" | Out-Null
    New-Item -ItemType "Directory" -Path "$OutDir\html" | Out-Null
    Write-Host -Object "Directories created"

    # Generate outputs
    Set-Location -Path "docs"
    pandoc.exe "README.md" `
        ..\metadata.yml `
        --metadata date=$(Get-Date -Format "yyyy-MM-dd") `
        --metadata titlepage-background="../background.pdf" `
        --metadata logo=logo.png `
        -o "..\$OutDir\pdf\example.pdf" `
        -f markdown `
        --template eisvogel.latex `
        --listing
    
    Set-Location -Path ".."
    mkdocs.exe build -d "$OutDir\html"

} else {
    Write-Error -Message "Error(s) occured, execution prevented."
}