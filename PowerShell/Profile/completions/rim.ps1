# rim (R installation manager) autocompletion
If (Get-Command rim -ErrorAction SilentlyContinue) {
    $rim_ac = $(try { Join-Path -Path $(scoop prefix rim) -ChildPath _rim.ps1 } catch { '' })
    if (Test-Path -Path $rim_ac) { & $rim_ac }
}
