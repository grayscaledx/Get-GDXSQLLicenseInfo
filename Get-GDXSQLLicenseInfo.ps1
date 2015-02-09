Function Get-GDXSQLLicenseInfo{

    [CmdletBinding()]
    param(
    [string[]]$ComputerName = $env:COMPUTERNAME
    )

    BEGIN {
    
        $collection = @()

    }

    PROCESS {
    
        foreach($c in $ComputerName){
            
            try {

                $SQLNameSpaces = Get-WmiObject -Namespace ROOT\Microsoft\SqlServer -Class __NAMESPACE -ComputerName $c
                Write-Output $SQLNameSpaces

                foreach ($cmclass in $(($SQLNameSpaces.Name) -match "ComputerManagement")){
                
                    $cmquery = Get-WmiObject -Namespace ($cmclass.__NAMESPACE)\($cmclass.Name) -Class SqlServiceAdvancedProperty   
                    $collection += $cmquery  
                
                }

                
            } catch {

            }
        
        }
    
    }

    END {
    
        Write-Output $collection
    
    }

}