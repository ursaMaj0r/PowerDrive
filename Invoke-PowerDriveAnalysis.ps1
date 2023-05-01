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
        $outputFile = "results"
    )

    $samples = Get-ChildItem $malwareDirectory -Filter *.ps1
    Foreach ($sample in $samples)
    {
        $fileName = $sample.VersionInfo.FileName
        Write-Output "Attempting to Deobfuscate $fileName with PowerDrive"
        $results = PowerDrive -InputFile $FileName 
        $results | Select-Object * | Export-Csv -Path $outputFile -NoTypeInformation -Append -Force

    }
}
