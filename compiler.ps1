param([String]$type = "Full")
$version = "0.0.2"

function Setup-Toolchain {
    if (!(Test-Path -LiteralPath "./toolchain/" -PathType Container)) {
        Invoke-WebRequest -Uri "https://github.com/CE-Programming/toolchain/releases/download/v11.2/CEdev-Windows.zip" -OutFile "./toolchain.zip"
        Expand-Archive -LiteralPath "./toolchain.zip" -DestinationPath "./toolchain"
        Remove-Item -Path "./toolchain.zip"
    }
}
function Setup-Path {
    if ($env:Path -notmatch ';$') {
        $env:Path += ";$pwd\toolchain\CEdev\bin"
    }
    else {
        $env:Path += "$pwd\toolchain\CEdev\bin"
    }
}
function Extract-Images {
    $gfx_path = "./src/gfx/"
    $image_files = New-Object System.Collections.ArrayList
    Get-ChildItem -Path "$gfx_path" -Recurse -Include "*.kra" | Where-Object {
        Copy-Item -LiteralPath "./src/gfx/$($_.BaseName).kra" -Destination "./src/gfx/$($_.BaseName).zip"
        $image_files.Add($_.BaseName)
    }
    foreach ($item_name in $image_files) {
        $item = "./src/gfx/$item_name.png"
        if (!(Test-Path $item -PathType Leaf)) {
            $file = $item.Replace("png", "zip")
            Expand-Archive -LiteralPath "$file" -DestinationPath "./.temp" -Force
            Move-Item -LiteralPath "./.temp/mergedimage.png" -Destination "$item"
            Remove-Item -LiteralPath "./.temp/" -Force -Recurse
        }
    }
    $zip_files = New-Object System.Collections.ArrayList
    Get-ChildItem -Path "$gfx_path" -Recurse -Include "*.zip" | Where-Object {
        $zip_files.Add($_.BaseName)
    }
    foreach ($item_name in $zip_files) {
        $item = "./src/gfx/$item_name.zip"
        Remove-Item -LiteralPath "$item"
    }
}
function Compile-GFX {
    make gfx
}
function Compile-Binary {
    make
}
function Clean-Directory {
    make clean
}
function Copy-Output {
    Remove-Item -Path "./*.8xp" -Force
    Move-Item -Path "./bin/*.8xp" -Destination "./"
}
function Cleanup {
    if (Test-Path -Path "./toolchain") {
        make clean
    }
    else {
        if (Test-Path -LiteralPath "./bin/") {
            Remove-Item -LiteralPath "./bin/" -Force -Recurse
        }
        if (Test-Path -LiteralPath "./obj/") {
            Remove-Item -LiteralPath "./obj/" -Force -Recurse
        }
    }
    $gfx_path = "./src/gfx/"
    $image_files = New-Object System.Collections.ArrayList
    Get-ChildItem -Path "$gfx_path" -Recurse -Include "*.png" | Where-Object {
        $image_files.Add($_.BaseName)
    }
    foreach ($item_name in $image_files) {
        $item = "./src/gfx/$item_name.png"
        Remove-Item -LiteralPath "$item"
    }
    $zip_files = New-Object System.Collections.ArrayList
    Get-ChildItem -Path "$gfx_path" -Recurse -Include "*.zip" | Where-Object {
        $zip_files.Add($_.BaseName)
    }
    foreach ($item_name in $zip_files) {
        $item = "./src/gfx/$item_name.zip"
        Remove-Item -LiteralPath "$item"
    }
    $misc_1_files = New-Object System.Collections.ArrayList
    Get-ChildItem -Path "$gfx_path" -Recurse -Include "*.png~" | Where-Object {
        $misc_1_files.Add($_.BaseName)
    }
    foreach ($item_name in $misc_1_files) {
        $item = "./src/gfx/$item_name.png~"
        Remove-Item -Path "$item"
    }
    $misc_2_files = New-Object System.Collections.ArrayList
    Get-ChildItem -Path "$gfx_path" -Recurse -Include "*.kra~" | Where-Object {
        $misc_2_files.Add($_.BaseName)
    }
    foreach ($item_name in $misc_2_files) {
        $item = "./src/gfx/$item_name.kra~"
        Remove-Item -Path "$item"
    }
    $font_path = "./src/fonts/"
    $font_files = New-Object System.Collections.ArrayList
    Get-ChildItem -Path "$font_path" -Recurse -Include "*.inc" | Where-Object {
        $font_files.Add($_.BaseName)
    }
    foreach ($item_name in $font_files) {
        $item = "./src/fonts/$item_name.inc"
        Remove-Item -LiteralPath "$item"
    }
    if (Test-Path -LiteralPath "./toolchain") {
        Remove-Item -LiteralPath "./toolchain" -Force -Recurse
    }
    Remove-Item -Path "./*.8xp" -Force
    if (Test-Path -LiteralPath "./src/gfx/convimg.yaml.lst") {
        Remove-Item -LiteralPath "./src/gfx/convimg.yaml.lst" -Force
    }
    Remove-Item -Path "./src/gfx/*.h" -Force
    
    Remove-Item -Path "./src/gfx/*.c" -Force   
}
function Compile-Font {
    convfont -o carray -f ./src/fonts/gameplayfont.fnt ./src/fonts/gameplayfont.inc
}

if (($type -eq "Full") -or ($type -eq "compile")) {
    Setup-Toolchain
    Setup-Path
    Extract-Images
    Compile-Font
    Compile-GFX
    Clean-Directory
    Compile-Binary
    Copy-Output
}
elseif (($type -eq "gfx") -or ($type -eq "setup")) {
    Setup-Toolchain
    Setup-Path
    Extract-Images
    Compile-GFX
}
elseif ($type -eq "font") {
    Setup-Toolchain
    Setup-Path
    Compile-Font
}
elseif ($type -eq "binary") {
    Setup-Toolchain
    Setup-Path
    Clean-Directory
    Compile-Binary
    Copy-Output
}
elseif ($type -eq "clean") {
    Setup-Path
    Cleanup
}
elseif ($type -eq "version") {
    Write-Host "Version is $version"
}
else {
    Write-Host "No valid function passed"
}