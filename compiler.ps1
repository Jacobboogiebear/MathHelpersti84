param([String]$type = "Full")

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
        $image_files.Add($_.BaseName)
    }
    foreach ($item_name in $image_files) {
        $item = "./src/gfx/$item_name.png"
        if (!(Test-Path $item -PathType Leaf)) {
            $file = $item.Replace("png", "kra")
            Expand-Archive -LiteralPath "$file" -DestinationPath "./.temp" -Force
            Move-Item -LiteralPath "./.temp/mergedimage.png" -Destination "$item"
            Remove-Item -LiteralPath "./.temp/" -Force -Recurse
        }
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

if (($type -eq "Full") -or ($type -eq "compile")) {
    Setup-Toolchain
    Setup-Path
    Extract-Images
    Compile-GFX
    Clean-Directory
    Compile-Binary
    Copy-Output
}
elseif ($type -eq "gfx") {
    Setup-Toolchain
    Setup-Path
    Extract-Images
    Compile-GFX
}
elseif ($type -eq "binary") {
    Setup-Toolchain
    Setup-Path
    Clean-Directory
    Compile-Binary
    Copy-Output
}
elseif ($type -eq "clean") {
    Cleanup
}