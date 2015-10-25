$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

$cred = Get-Credential -Message "Enter credentials for iLO Host"
$ComputerName = '192.168.0.200' # IP address of iLO

Describe "Get-iLOPower" {
    It "Get current power status" {
        Get-iLOPower -computerName $ComputerName -credential $cred | Select -ExpandProperty PowerStatus | Should match "ON|OFF|Unknown"
    }
}
