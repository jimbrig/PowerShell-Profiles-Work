Function Update-ProfileModules {

    $modpath = ($env:PSModulePath -split ";")[0]
    $ymlpath = "$modpath\modules.yml"
    $mods = (Get-ChildItem $modpath -Directory).Name
    ConvertTo-Yaml -Data $mods -OutFile $ymlpath -Force

    Set-Location "$HOME\Documents\PowerShell"
    git pull
    git add Modules/**
    git commit -m "config: Updated module configuration"
    Set-Location "$HOME\Documents"
    git-cliff -o "$HOME\Documents\CHANGELOG.md"
    git commit -m "doc: update CHANGELOG.md for added modules"
    git push

}

Update-ProfileModules