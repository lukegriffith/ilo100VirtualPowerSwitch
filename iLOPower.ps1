function Get-ilo100PowerStatus ([switch]$external, [pscredential]$cred) {

    if ($external){$computerName = "###"} else {$computerName = "192.168.0.200"}

    $computerName | foreach {
    try {
    # Invokes web request to URI - logging in with the credentials and directing it to the chassis.html uri.
    $ilo = Invoke-WebRequest -uri "http://$($computerName)/chassis.html" -Credential $cred   
    }
    catch {
    }

    # generate a hashtable, for the object return.
    $prop = @{}
    # adding the computer name to the hashtable.
    $prop.Add("ComputerName","$computerName")

    # run RegEx matches on the returned content, checking for ON and OF under the Power Status: 

    if ($ilo.Content -match "Power Status:</STRONG></TD><TD>ON</TD>") 
    {
        # Adds ON to hashtable
        $prop.Add('PowerStatus', 'ON')
    }
    elseif ($ilo.Content -match "Power Status:</STRONG></TD><TD>OFF</TD>")
    {
        # Adds OFF to hashtable
        $prop.Add('PowerStatus', 'OFF')
    }
    else {
        # Adds connection failure to hashtable
        $prop.Add('Connection','False')
    }

    # Returns object
    New-Object -TypeName PSObject -Property $prop

    
}
}

function Set-ilo100PowerStatus {

    # Use parameter sets to ensure the on and off switch are not both sent at the same time. 
    [CmdletBinding(DefaultParameterSetName='Power On')]
    param(
        [switch]$external, 
        [pscredential]$cred,
        [Parameter(ParameterSetName='Power On')]
        [switch]$PowerOn,
        [Parameter(ParameterSetName='Power Off')]
        [switch]$PowerOff        
        )

        if ($external){$computerName = "###"} else {$computerName = "192.168.0.200"}
      
        # Using the same methods, webrequest to the action the form uses in the GUI
        if ($PowerOn) {
            Write-Verbose "$computerName Powering On"
            try { Invoke-WebRequest -Uri "http://$($computerName)/chassis.html?PwrCtrl=PowerUp&Button1=Apply" -Credential $cred } catch { Write-Error -Exception $Error[0] }
            
        }

        if ($PowerOff) {
            Write-Verbose "$computerName Powering Down"
            try { Invoke-WebRequest -Uri "http://$($computerName)/chassis.html?PwrCtrl=PowerDown&Button1=Apply" -Credential $cred } catch {  Write-Error -Exception $Error[0] } 
            
        }
        
        # Checks the status of the server after power set. 
        Get-ilo100PowerStatus -computerName $computerName -cred $cred

}