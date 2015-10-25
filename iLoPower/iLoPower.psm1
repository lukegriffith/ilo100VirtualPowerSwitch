function Get-iLOPower {
  [cmdletbinding()]
  param(
      [parameter(Mandatory=$true)]
      [string]$ComputerName,
      [parameter(Mandatory=$true)]
      [pscredential]$Credential

  )

  $url = 'http://' + $ComputerName + '/chassis.html'
  try { $a = Invoke-WebRequest -Uri $url -Credential $Credential }
  Catch { $failed = $true; $power = "Unknown" }

  if (!$failed) {
    $regex = '<TR><TD><STRONG>Power Status:</STRONG></TD><TD>(OFF|ON)</TD></TR>'
    $power = [regex]::Match($a.Content, $regex).Groups[1].value
  }

  $object = [PSCustomObject]@{ComputerName = $ComputerName; PowerStatus = $power; Credential = $Credential}

   
  [string[]]$DefaultProperties = 'ComputerName','PowerStatus'

  # Add the PSStandardMembers.DefaultDisplayPropertySet member
  $defaultPropertiesSet = New-Object -TypeName System.Management.Automation.PSPropertySet -ArgumentList DefaultDisplayPropertySet,$DefaultProperties
  $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]$defaultPropertiesSet 
  
  # Attach default display property set
  $object | Add-Member -MemberType MemberSet -Name PSStandardMembers -Value $PSStandardMembers -PassThru



         

}


function Set-iLOPower {
  [cmdletbinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
  param(
  [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
  [string]$ComputerName,
  [parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
  [pscredential]$Credential,
  [parameter(Mandatory=$true,ParameterSetName='Power On')]
  [switch]$On,
  [parameter(Mandatory=$true,ParameterSetName='Power Off')]
  [switch]$Off
  )
  
  if ($pscmdlet.ShouldProcess($computername)) {
    if ($PSCmdlet.ParameterSetName -eq 'Power On') {
      Invoke-WebRequest -Uri "http://$ComputerName/chassis.html?PwrCtrl=PowerUp&Button1=Apply" -Method Post -Credential $Credential
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'Power Off') {
      Invoke-WebRequest -Uri "http://$ComputerName/chassis.html?PwrCtrl=PowerDown&Button1=Apply" -Method Post -Credential $Credential
    }
  }
  
  Start-Sleep -Seconds 1
  
  Get-iLOPower -ComputerName $ComputerName -Credential $Credential
}


