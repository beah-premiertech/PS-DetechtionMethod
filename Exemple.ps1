try
{
    #Get if Module is install then install it and import it or update it if not and import it
    $Name = "PS-DetectionMethod";$Version = "1.1.2.2";
    if(Get-InstalledModule -Name $Name){Update-Module -Name $Name -RequiredVersion $Version -Force;Import-Module -Name $Name -RequiredVersion $Version -Force;}
    else{Install-Module -Name $Name -RequiredVersion $Version -Force;Import-Module -Name $Name -RequiredVersion $Version -Force;}

    #Set application name for log file and give the script block to run before do the test (you probably want to use module function at this point)
    Start-DetectionMethod -ApplicationName "My Application Name" `
    {
        <#
            Here you can place the code you want and do thing like you always do but that will have no interest
            what you want to do is to add detection method it work basicly as you add it from UI but it in script so every method
            you add here will be process in order you add it if one fail it will stop the check and return error 404 + output detail in log   
        #>

        ### Add a file Exemple ###
        Add-File -Path "C:\Program Files (x86)\Windows Mail\wab.exe"
        Add-File -Path "C:\Program Files (x86)\Windows Mail\wab.exe" -Date_Created "2023-03-15 10:18 AM" -Operator 'Greater than or equal to'
        Add-File -Path "C:\Program Files (x86)\Windows Mail\wab.exe" -Date_Modified "2023-03-15 10:18 AM" -Operator 'Less than'
        Add-File -Path "C:\Program Files (x86)\Windows Mail\wab.exe" -Version "10.0.19041.2673" -Operator 'Not equal to'
        Add-File -Path "C:\Program Files (x86)\Windows Mail\wab.exe" -Version "10.0.19041.2673" -Operator 'Greater than' -Version_Target Product
        Add-File -Path "C:\Program Files (x86)\Windows Mail\wab.exe" -Build "19041" -Version_Target File -Operator 'Less than or equal to'
        Add-File -Path "C:\Program Files (x86)\Windows Mail\wab.exe" -Size "1" -Size_Target Mb -Operator Equals
        Add-File -Path "C:\Program Files (x86)\Windows Mail\wab.exe" -Date_Created "2023-03-15 10:18 AM" -Date_Modified "2023-03-15 10:18 AM" -Version "10.0.19041.2673" -Size "10" -Size_Target Kb -Operator 'Greater than or equal to'

        ### Add a folder Exemple ###
        Add-Folder -Path "C:\Program Files (x86)\Windows Mail"
        Add-Folder -Path "C:\Program Files (x86)\Windows Mail" -Date_Created "2023-03-15 10:18 AM" -Operator 'Greater than or equal to'
        Add-Folder -Path "C:\Program Files (x86)\Windows Mail" -Date_Modified "2023-03-15 10:18 AM" -Operator 'Less than'
        Add-Folder -Path "C:\Program Files (x86)\Windows Mail" -Date_Created "2023-03-15 10:18 AM" -Date_Modified "2023-03-15 10:18 AM" -Operator 'Less than'

        ### Add a registry Exemple ###
        Add-Registry -Target ALL_USERS -Key "SOFTWARE"
        Add-Registry -Target HKEY_CURRENT_USER -Key "SOFTWARE"
        Add-Registry -Target HKEY_LOCAL_MACHINE -Key "SOFTWARE"
        Add-Registry -Target HKEY_USERS -Key "S-1-5-21-734744446-43673474-745475547-754754574\SOFTWARE"
        Add-Registry -Target HKEY_LOCAL_MACHINE -Key "SOFTWARE\Microsoft\MediaPlayer" -Name "IEInstall"
        Add-Registry -Target HKEY_LOCAL_MACHINE -Key "SOFTWARE\Microsoft\MediaPlayer" -Name "IEInstall" -Value "no" -Value_Type String
        Add-Registry -Target HKEY_LOCAL_MACHINE -Key "SOFTWARE\Microsoft\MediaPlayer" -Name "IEInstall" -Value "1.1.1.1" -Value_Type Version -Operator 'Greater than'
        Add-Registry -Target HKEY_LOCAL_MACHINE -Key "SOFTWARE\Microsoft\MediaPlayer" -Name "IEInstall" -Value "1342314" -Value_Type Integer -Operator 'Less than or equal to'

        ### Add a application Exemple ###
        Add-Application -Name "My Application"
        Add-Application -Product_Code "{5235325-235325-23532523-32532523}"
        Add-Application -Product_Code "{5235325-235325-23532523-32532523}" -Version "1.01.1.1" -Operator 'Less than'

        ### Add a script Exemple ###
        Add-Script -Type "Process" -Result_Global_Variable_Name "Result" -Script `
        {
            if(Get-Process -Name "notepad")
            {
                return $true
            }
            else
            {
                $Global:Result = "NotePad is not open wet...";
                return $false
            }
        } 
    }
}
catch
{
}
