Function Install-OfficeRibbonEditor {

    $URI = 'https://bettersolutions.com/vba/ribbon/OfficeCustomUIEditorFiles.zip'
    $OutFile = "$HOME\Downloads\OfficeCustomUIEditorFiles.zip"
    $DestDir = "$HOME\tools\OfficeCustomUIEditor"

    Invoke-WebRequest -Uri $URI -OutFile $OutFile

    Expand-Archive -Path $OutFile -DestinationPath $DestDir


}

Function Configure-OfficeRibbonEditor {

    $DotNetRunTimeVersion = '6.0.5'

    $XMLIn = [xml]$xmlElm = Get-Content -Path "$HOME\tools\OfficeCustomUIEditor\CustomUIEditor.exe.config"

    $xmlWriter = New-Object System.XMl.XmlTextWriter("$HOME\tools\OfficeCustomUIEditor\config\CustomUIEditor.exe.config", $Null)

    $xmlWriter = New-Object System.XMl.XmlTextWriter("$HOME\tools\OfficeCustomUIEditor\config\CustomUIEditor.exe.config", $Null)
    $xmlWriter.Formatting = 'Indented'
    $xmlWriter.Indentation = 1
    $xmlWriter.IndentChar = "`t"

    $xmlWriter.WriteStartDocument()
    $xmlWriter.WriteStartElement('configuration')
    $xmlWriter.WriteAttributeString('appSettings', $null)
    $xmlWriter.WriteComment('User application and configured property settings go here')
    $xmlWriter.WriteStartElement('startup')
    $xmlWriter.WriteElementString('supportedRuntime version', $DotNetRunTimeVersion)
    $xmlWriter.WriteEndElement()
    $xmlWriter.WriteEndElement()
    $xmlWriter.WriteEndDocument()
    $xmlWriter.Flush()
    $xmlWriter.Close()

    $XML = ((
@"
<?xml version="1.0"?>
<configuration>
    <appSettings>
        <!--   User application and configured property settings go here.-->
        <!--   Example: <add key="settingName" value="settingValue"/> -->
    </appSettings>
    <startup>
        <supportedRuntime version="$($DotNetRunTimeVersion)"
        <supportedRuntime version="v2.0.50727"/>
    </startup>
</configuration>
"@).TrimEnd()).TrimStart()



}