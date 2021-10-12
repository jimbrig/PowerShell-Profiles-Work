Function Update-ProfileModules {

    $modpath = ($env:PSModulePath -split ";")[0]
    $ymlpath = "$modpath\modules.yml"
    $mods = (Get-ChildItem $modpath -Directory).Name
    ConvertTo-Yaml -Data $mods -OutFile $ymlpath -Force

    git pull
    git add modules/**
    git commit -m "config: Updated modules configurations"
    git-cliff -o "$HOME\Documents\CHANGELOG.md"
    git commit -m "doc: update CHANGELOG.md for added modules"
    git push

}

