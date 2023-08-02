# PS-DetechtionMethod
The Module contain **2 class** and **7 function**. The Class are designed to be acess by using function and not directly if you do stuff may not work as it should.


## Class and Function Sumary
|          Name         |   Type    |         Description                         
|-----------------------|-----------|-----------------------------|
`DetectionMethod`       | Class     | The class contain 3 property **Compliant**, **Type** and **Result** this class contain a lot method that represent a type of Detection Method like: Folder, File, Registry, Application and script.
`DetectionMethodGroup`  | Class     | The class contain 3 property **Compliant**, **Type** and **Methods** this class i use to stack the `DetectionMethod` and provide a quick way to test it all by using **TestDetectionMethod**
`Start-DetectionMethod` | Function | This is the first thing to call in Module it will create new object from class automatically in proper way and record session in file you must provide **ApplicationName** and **DetectionMethodScript** that should contain all other function
`Add-Folder` | Function | This add a detection method that will check for folder
`Add-File` | Function |This add a detection method that will check for file
`Add-Registry` | Function |This add a detection method that will check for registry path, key and value
`Add-Application ` | Function |This add a detection method that will check for Application by Product Code, Name and Version
`Add-Script ` | Function |This add a detection method that allow to add custum script as detection method

Also it exist `Test-DetectionMethod` this function will check the `DetectionGroup` ****TestDetectionMethod**** and depend of result $true or $false it will make proper output for MECM so it will can fall as Install or not also throw error detail to screen.
> When you use `Start-DetectionMethod` that will be  also record in the log file: **C:\LogFiles\ApplicationName\Today_Date&Time.log** 


## Special parameter of function
- Most of all function **-Operator**: That must be specify in function that check Version, Date & Time or Integer if not specify it will assume you want check if value to check is equal to local value of machine.
- `Add-Application` **-Version**: Cannot be use alone you must provide -Product_Code "{3435435-5435-345435-43533}"
- `Add-File` **-Size**: If you do not provide **-Size_Target** script will assume the size you provide is in byte
- `Add-Registry` **-Value**: If you do not provide **Value_Type** script will assume the values you provide is a String. Also note if you try to use **-Operator** and the type is String that will be alway be like if you use Equal
- Most of all function: You could provide multiple parameter like for folder if you provide at same time   
**-Date_Created** and **-Date_Modified** that will create 2 detection method that will check both value


## Exemple of use
First you need to install module and import the module by using this:

    using  module  PS-DetectionMethod
or

    Import-Module PS-DetectionMethod

Use first one if you want to access class directly else you can use second one. Then now the module is loaded the properly way to use the module is like this:

    Start-DetectionMethod -ApplicationName "Test PS Module v2" `
    {
        Add-Registry -Target HKEY_LOCAL_MACHINE -Key "SOFTWARE"
        Add-File -Path "C:\TEMP\myfile.txt"
    }

One way to maintain up-to date, install and import module could be like this:

    $TargetModuleVersion = "1.1.2.2";$ErrorActionPreference = "SilentlyContinue";Remove-Module PS-DetectionMethod -Force;Uninstall-Module -Name PS-DetectionMethod -AllVersions -Force;Install-Module PS-DetectionMethod -RequiredVersion "$TargetModuleVersion" -Force -SkipPublisherCheck;Import-Module PS-DetectionMethod -RequiredVersion "$TargetModuleVersion";$ErrorActionPreference = "Continue";
