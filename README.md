# PowerDrive
## A Tool for De-Obfuscating PowerShell Scripts

Obfuscation is a technique used by malicious software to avoid detection. This tool allows de-obfuscating PowerShell scripts, even after multiple obfuscation attempts.

**IMPORTANT: Always execute PowerDrive in an isolated environment, as malware could be downloaded and executed during the de-obfuscation process.**

## How to use

1. Open a new PowerShell instance.
2. Import the PowerDrive module:
> Import-Module PowerDrive.psm1
3. Run PowerDrive (the file path containing the obfuscated PowerShell script must be passed):
> PowerDrive .\obfuscated_script.ps1

## Added Functions
### New-PowerDriveSamples
1. Open a new PowerShell instance.
2. Import the function:
> ./New-PowerDriveSamples.ps1
3. Run Function:
> New-PowerDriveSamples -InputFile {Path to deobfuscated samples file} -outputDir {path to directory to place scripts}

### Invoke-PowerDriveAnalysis
1. Open a PowerShell instance with the PowerDrive Module imported.
2. Import the function:
> ./Invoke-PowerDriveAnalysis.ps1
3. Run Function:
> Invoke-PowerDriveAnalysis -malwareDirectory {Path to directory with scripts} -outputFile {path with filename to place results csv}


## Additional information
This tool has been adapted from [1] by Jeff Malavasi in the context of repurposing the module for bulk detection and SIEM ingestion. An additional script was created that can be used to scan directories for potentially obfuscated scripts and log to a file directory. This file can be later picked up by a SIEM for alerting and monitoring across the enterprise.

[1] Denis Ugarte, Davide Maiorca, Fabrizio Cara and Giorgio Giacinto. PowerDrive: Accurate De-Obfuscation and Analysis of PowerShell Malware.
