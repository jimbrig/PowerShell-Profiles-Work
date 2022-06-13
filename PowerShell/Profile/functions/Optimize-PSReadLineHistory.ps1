#requires -version 5.0
#requires -module PSReadline


Function Optimize-PSReadLineHistory {
  <#
    .SYNOPSIS
        Optimize the PSReadline history file
    .DESCRIPTION
        The PSReadline module can maintain a persistent command-line history. However, there are no provisions for managing the file. When the file gets very large, performance starting PowerShell can be affected. This command will trim the history file to a specified length as well as removing any duplicate entries.
    .PARAMETER MaximumLineCount
    Set the maximum number of lines to store in the history file.
    .PARAMETER Passthru
    By default this command does not write anything to the pipeline. Use -Passthru to get the updated history file.
    .EXAMPLE
        PS C:\> Optimize-PSReadelineHistory

        Trim the PSReadlineHistory file to default maximum number of lines.
    .EXAMPLE
        PS C:\> Optimize-PSReadelineHistory -maximumlinecount 500 -passthru

            Directory: C:\Users\Jeff\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline


            Mode                LastWriteTime         Length Name
            ----                -------------         ------ ----
            -a----        11/2/2017   8:21 AM           1171 ConsoleHost_history.txt

        Trim the PSReadlineHistory file to 500 lines and display the file listing.
    .INPUTS
        None
    .OUTPUTS
       None
    .NOTES
        version 1.0
        Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/
    .LINK
    Get-PSReadlineOption
    .LINK
    Set-PSReadlineOption
    #>
  [cmdletbinding(SupportsShouldProcess)]
  Param(
    [Parameter(ValueFromPipeline)]
    [int32]$MaximumLineCount = $MaximumHistoryCount,
    [switch]$Passthru
  )
  Begin {
    Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
    $History = (Get-PSReadlineOption).HistorySavePath
  } #begin

  Process {
    if (Test-Path -Path $History) {
      Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Measuring $history"
      $myHistory = Get-Content -Path $History

      Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Found $($myHistory.count) lines of history"
      $count = $myHistory.count - $MaximumLineCount

      if ($count -gt 0) {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Trimming $count lines to meet max of $MaximumLineCount lines"
        $myHistory | Select-Object -Skip $count -Unique  | Set-Content -Path $History

      }
    }
    else {
      Write-Warning "Failed to find $history"
    }

  } #process

  End {
    If ($Passthru) {
      Get-Item -Path $History
    }
    Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
  } #end

} #close Name
