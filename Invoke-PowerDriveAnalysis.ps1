function Invoke-PowerDriveAnalysis
{
    <#
    .SYNOPSIS
        Deobfuscates and analyzes PowerShell scripts using PowerDrive

    .NOTES
        History:
        Version     Who             When        What
        1.0         Jeff Malavasi   04/23/2023  init

    .PARAMETER Results
    Specifies the directory of the malware samples

    .PARAMETER outputFile
    Specifies the name of the output file
    #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [String]
        $malwareDirectory,
        [String]
        $outputFile="results"
    )

    $samples = Get-ChildItem $malwareDirectory -Filter *.ps1
    Foreach ($sample in $samples)
    {
        $fileName = $sample.VersionInfo.FileName
        $resultsName = "$malwareDirectory\$($sample.Name).txt"
        Write-Output "Attempting to Deobfuscate $fileName with PowerDrive"
        $results = PowerDrive -InputFile $FileName 
        $results | Out-File $resultsName
        Write-Output "Analyzing results from PowerDrive"

        # Format Output
        $output=$results.split("#")
        $output = $output.Where({ $_ -ne ""})

        # Get Basic Info
        $layerCount = $output.Where({ $_ -like "*Layer*"}).count
        $isEncoded = $results -match "^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{4}|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{2}={2})$"

        # Check for Anti Debug
        $antiDebugSleep = $results -match "sleep"
        $antiDebugNull = $results -match "out-null"

        # Check for Action
        $actionDownload = $results -match "download"
        $actionProcess = $results -match "-Process"

        # Get Remote URLs
        $start = ($output[-1].IndexOf(':')  +1)
        $length = ($output[-1].Length) - $start
        $remoteURLs = $output[-1].Substring($start,$length)
        $remoteURLs = $remoteURLs.replace(",",";")
        $remoteURLStatus = !($results -match "Cannot connect")

        $analysis = [PSCustomObject]@{
            FileName   = $fileName
            LayerCount = $layerCount
            Encoded    = $isEncoded
            Sleep      = $antiDebugSleep
            Null       = $antiDebugNull
            Download   = $actionDownload
            Process    = $actionProcess
            URLs       = $remoteURLs
            URLActive  = $remoteURLStatus
        }

        # Output
        Write-Verbose "Raw Output:`n$output"
        Write-Output "Analysis:`n$analysis"

        # Store in Results file
        $analysis | Export-CSV $outputFile -NoTypeInformation -Append -Force

    }
}
Invoke-PowerDriveAnalysis -malwareDirectory $malwareDirectory -outputFile $outputFile