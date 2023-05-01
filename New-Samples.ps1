function New-PowerDriveSamples
{
    <#
    .SYNOPSIS
        Converts repo of samples to individual files

    .NOTES
        History:
        Version     Who             When        What
        1.0         Jeff Malavasi   04/23/2023  init

    .PARAMETER inputFile
    Specifies the text file with the obfuscated samples
    .PARAMETER outputDirectory
    Specifies the folder to place the obfuscated samples
    #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [String]
        $inputFile,
        [String]
        $outputDirectory
    )

    $samples = Get-Content $inputFile
    $samples = $samples | Select-String -Pattern "Layer 1" -Context 1

    $count=0
    Foreach ($sample in $samples)
    {
        $sample.Context.PostContext | Out-File $outputDirectory/$count.ps1
        $count++
    }
}