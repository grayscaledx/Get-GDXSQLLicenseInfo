Function Get-GDXSQLLicenseInfo{

    [CmdletBinding()]
    param(
    [string[]]$ComputerName = $env:COMPUTERNAME
    )

    BEGIN {
    
        $collection = @()
        $sqlNamespace = "ROOT\Microsoft\SqlServer"

    }

    PROCESS {
    
        foreach ($c in $ComputerName){
            
            try {

                $SQLNameSpaces = Get-WmiObject -Namespace $sqlNameSpace -Class __NAMESPACE -ComputerName $c

                foreach ($sqlInstalledNamespace in $(($SQLNameSpaces.Name) -match "ComputerManagement")){
                
                    $sqlWMIInstances = Get-WmiObject -Namespace $sqlNamespace\$sqlInstalledNamespace -Class SqlServiceAdvancedProperty
                    foreach ($sqlInfo in $sqlWMIInstances){
                    
                        if ($sqlInfo.PropertyName -match "SKUNAME") {

                            $props = @{
                                        'ComputerName' = $c
                                        'PSComputerName' = $sqlInfo.PSComputerName
                                        'SQLEdition' = $sqlInfo.PropertyStrValue
                                        'ServiceName' = $sqlInfo.ServiceName
                            }

                            $obj = New-Object -TypeName psobject -Property $props
                            $collection += $obj
                        
                        }

                    }
                
                }

                
            } catch {

            }
        
        }
    
    }

    END {
    
        Write-Output $collection
    
    }

}