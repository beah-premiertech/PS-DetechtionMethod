class DetectionMethod {
    [bool]$Compliant
    [string]$Type
    [string]$Result
    Hidden[void]TestDateOfItem([string]$Path,[string]$Operator,[string]$Target,[string]$ltype)
    {
        $File = Get-Item -Path $Path;
        [datetime]$Target_DateTime = Get-Date -Date $Target -Format "MM/dd/yyyy h:mm tt";
        [datetime]$Test_DateTime = Get-Date -Date $File.CreationTime -Format "MM/dd/yyyy h:mm tt";
        switch ($Operator)
        {
            "Equals" { if($Test_DateTime -eq $Target_DateTime){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "$ltype $Path not match creation time $Test_DateTime $Operator $Target_DateTime";} }
            "Not equal to" { if($Test_DateTime -ne $Target_DateTime){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "$ltype $Path not match creation time $Test_DateTime $Operator $Target_DateTime";} }
            "Greater than or equal to" { if($Test_DateTime -ge $Target_DateTime){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "$ltype $Path not match creation time $Test_DateTime  $Operator $Target_DateTime";} }
            "Greater than" { if($Test_DateTime -gt $Target_DateTime){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "$ltype $Path not match creation time $Test_DateTime $Operator $Target_DateTime";} }
            "Less than" { if($Test_DateTime -lt $Target_DateTime){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "$ltype $Path not match creation time $Test_DateTime $Operator $Target_DateTime";} }
            "Less than or equal to" { if($Test_DateTime -le $Target_DateTime){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "$ltype $Path not match creation time $Test_DateTime $Operator $Target_DateTime";} }
            Default { if($Test_DateTime -eq $Target_DateTime){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "$ltype $Path not match creation time $Test_DateTime $Operator $Target_DateTime";} }
        }
    }
    [void]TestFolder([string]$Path,[string]$Date_Created,[string]$Date_Modified,[string]$Operator)
    {
       $this.Type = "Folder"
       if($Path.Length -ge 3 -and $Path -like "*:\*")
       {
       
            if($Date_Created.Length -lt 1 -and $Date_Modified.Length -lt 1)
            {
                if(Test-Path -Path $Path -PathType Container){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "Folder do not exist: $Path"}
            }
            else
            {
                if(Test-Path -Path $Path -PathType Container)
                {
                    if($Date_Created.Length -gt 1)
                    {
                        $this.TestDateOfItem($Path,$Operator,$Date_Created,$this.Type);
                    }
                    if($Date_Modified.Length -gt 1)
                    {
                        $this.TestDateOfItem($Path,$Operator,$Date_Modified,$this.Type);
                    }
                }
                else
                {
                    $this.Result = "$Path is not exist"
                    $this.Compliant = $false;
                }
            }
       }
       else
       {
            $this.Result = "Path: $Path is not valid"
            $this.Compliant = $false;
       }
    }
    [void]TestFile([string]$Path,[string]$Date_Created,[string]$Date_Modified,[string]$Operator,[string[]]$Ver_Arg_List,[string]$Size)
    {
       $this.Type = "File"
       $ltype = $this.Type
       if($Path.Length -gt 3 -and $Path -like "*:\*")
       {
            if($Date_Created.Length -lt 1 -and $Date_Modified.Length -lt 1 -and $Size.Length -lt 1 -and $Ver_Arg_List.Length -lt 1)
            {
                if(Test-Path -Path $Path -PathType Leaf){$this.Compliant = $true;}else{$this.Compliant = $false;$this.Result = "$ltype do not exist: $Path"}
            }
            else
            {
                if(Test-Path -Path $Path -PathType Leaf)
                {
                    if($Date_Created.Length -gt 1)
                    {
                        $this.TestDateOfItem($Path,$Operator,$Date_Created,$this.Type);
                    }
                    if($Date_Modified.Length -gt 1)
                    {
                        $this.TestDateOfItem($Path,$Operator,$Date_Modified,$this.Type);
                    }
                    if($Ver_Arg_List.Count -gt 2) 
                    {
                        $File = Get-ChildItem -Path $Path -File;
                        $Mode = $Ver_Arg_List[0];
                        $Version = $Ver_Arg_List[1];
                        $Target_Version = $Ver_Arg_List[2];
                        switch ($Mode) {
                            "Full" 
                            {
                                try
                                {
                                    [version]$Require_Version = $Version
                                    if($Target_Version -eq "File")
                                    {
                                        [version]$FP_Version = $File.VersionInfo.FileVersionRaw
                                    }
                                    else
                                    {
                                        [version]$FP_Version = $File.VersionInfo.ProductVersionRaw
                                    }
                                    switch ($Operator)
                                    {
                                        "Equals" { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match version $FP_Version $Operator $Require_Version";} }
                                        "Not equal to" { if($FP_Version -ne $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match version $FP_Version $Operator $Require_Version";} }
                                        "Greater than or equal to" { if($FP_Version -ge $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match version $FP_Version $Operator $Require_Version";}}
                                        "Greater than" { if($FP_Version -gt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match version $FP_Version $Operator $Require_Version";} }
                                        "Less than" { if($FP_Version -lt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match version $FP_Version $Operator $Require_Version";} }
                                        "Less than or equal to" { if($FP_Version -le $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match version $FP_Version $Operator $Require_Version";} }
                                        Default { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match version $FP_Version $Operator $Require_Version";} }
                                    }
                                }
                                catch
                                {
                                    $this.Result = "For $ltype Version you specify or File/Product version is not reconize as valid Version you must provide at lest string that contain at least Major.Minor also the string must not include letter";
                                }
                            }
                            "Major" 
                            {
                                [int]$Require_Version = $Version
                                if($Target_Version -eq "File")
                                {
                                    [int]$FP_Version = $File.VersionInfo.FileMajorPart
                                }
                                else
                                {
                                    [int]$FP_Version = $File.VersionInfo.ProductMajorPart
                                }
                                switch ($Operator)
                                {
                                    "Equals" { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Major version $FP_Version $Operator $Require_Version";} }
                                    "Not equal to" { if($FP_Version -ne $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Major version $FP_Version $Operator $Require_Version";} }
                                    "Greater than or equal to" { if($FP_Version -ge $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Major version $FP_Version $Operator $Require_Version";}}
                                    "Greater than" { if($FP_Version -gt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Major version $FP_Version $Operator $Require_Version";} }
                                    "Less than" { if($FP_Version -lt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Major version $FP_Version $Operator $Require_Version";} }
                                    "Less than or equal to" { if($FP_Version -le $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Major version $FP_Version $Operator $Require_Version";} }
                                    Default { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Major version $FP_Version $Operator $Require_Version";} }
                                }
                            }
                            "Minor" 
                            {
                                [int]$Require_Version = $Version
                                if($Target_Version -eq "File")
                                {
                                    [int]$FP_Version = $File.VersionInfo.FileMinorPart
                                }
                                else
                                {
                                    [int]$FP_Version = $File.VersionInfo.ProductMinorPart
                                }
                                switch ($Operator)
                                {
                                    "Equals" { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Minor version $FP_Version $Operator $Require_Version";} }
                                    "Not equal to" { if($FP_Version -ne $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Minor version $FP_Version $Operator $Require_Version";} }
                                    "Greater than or equal to" { if($FP_Version -ge $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Minor version $FP_Version $Operator $Require_Version";}}
                                    "Greater than" { if($FP_Version -gt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Minor version $FP_Version $Operator $Require_Version";} }
                                    "Less than" { if($FP_Version -lt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Minor version $FP_Version $Operator $Require_Version";} }
                                    "Less than or equal to" { if($FP_Version -le $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Minor version $FP_Version $Operator $Require_Version";} }
                                    Default { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Minor version $FP_Version $Operator $Require_Version";} }
                                }
                            }
                            "Build" 
                            {
                                [int]$Require_Version = $Version
                                if($Target_Version -eq "File")
                                {
                                    [int]$FP_Version = $File.VersionInfo.FileBuildPart;
                                }
                                else
                                {
                                    [int]$FP_Version = $File.VersionInfo.ProductBuildPart;
                                }
                                switch ($Operator)
                                {
                                    "Equals" { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Build version $FP_Version $Operator $Require_Version";} }
                                    "Not equal to" { if($FP_Version -ne $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Build version $FP_Version $Operator $Require_Version";} }
                                    "Greater than or equal to" { if($FP_Version -ge $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Build version $FP_Version $Operator $Require_Version";}}
                                    "Greater than" { if($FP_Version -gt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Build version $FP_Version $Operator $Require_Version";} }
                                    "Less than" { if($FP_Version -lt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Build version $FP_Version $Operator $Require_Version";} }
                                    "Less than or equal to" { if($FP_Version -le $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Build version $FP_Version $Operator $Require_Version";} }
                                    Default { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match Build version $FP_Version $Operator $Require_Version";} }
                                }
                            }
                            "BuildExt"
                            {
                                [int]$Require_Version = $Version
                                if($Target_Version -eq "File")
                                {
                                    [int]$FP_Version = $File.VersionInfo.FilePrivatePart
                                }
                                else
                                {
                                    [int]$FP_Version = $File.VersionInfo.ProductPrivatePart
                                }
                                switch ($Operator)
                                {
                                    "Equals" { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match BuildExt version $FP_Version $Operator $Require_Version";} }
                                    "Not equal to" { if($FP_Version -ne $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match BuildExt version $FP_Version $Operator $Require_Version";} }
                                    "Greater than or equal to" { if($FP_Version -ge $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match BuildExt version $FP_Version $Operator $Require_Version";}}
                                    "Greater than" { if($FP_Version -gt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match BuildExt version $FP_Version $Operator $Require_Version";} }
                                    "Less than" { if($FP_Version -lt $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match BuildExt version $FP_Version $Operator $Require_Version";} }
                                    "Less than or equal to" { if($FP_Version -le $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match BuildExt version $FP_Version $Operator $Require_Version";} }
                                    Default { if($FP_Version -eq $Require_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match BuildExt version $FP_Version $Operator $Require_Version";} }
                                }
                            }
                            Default{$this.Result = "For $ltype Mode is not reconize valid Mode is: Full, Major, Minor, Build";}
                        }
                    }
                    else
                    {
                        if($Ver_Arg_List.Count -ne 0)
                        {
                            $this.Result = "Missing argument for $ltype Version check-up you must specify an array declare in this order: @(`$Mode,`$Version_or_Number,`$Target_Version)";
                        }
                    }
                    if($Size.Length -ge 1)
                    {
                        $File = Get-ChildItem -Path $Path -File;
                        $lsize = $File.Length
                        switch ($Operator)
                        {
                            "Equals" { if($File.Length -eq $Size){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match size $Size $Operator $lsize";} }
                            "Not equal to" { if($File.Length -ne $Size){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match size $Size $Operator $lsize";} }
                            "Greater than or equal to" { if($File.Length -ge $Size){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match size $Size $Operator $lsize";}}
                            "Greater than" { if($File.Length -gt $Size){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match size $Size $Operator $lsize";} }
                            "Less than" { if($File.Length -lt $Size){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match size $Size $Operator $lsize";} }
                            "Less than or equal to" { if($File.Length -le $Size){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match size $Size $Operator $lsize";} }
                            Default { if($File.Length -eq $Size){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match size $Size $Operator $lsize";} }
                        }
                    }
                }
                else
                {
                    $this.Result = "$Path is not exist"
                    $this.Compliant = $false;
                }
            }
       }
       else
       {
            $this.Result = "Path: $Path is not valid"
            $this.Compliant = $false;
       }
    }
    [void]TestRegistry([string]$Target,[string]$Key,[string]$Name,[string]$Value,[string]$Operator,[string]$Value_Type)
    {
        $this.Type = "Registry"
        $ltype = $this.Type
        if($Name.Length -lt 1)
        {
            switch ($Target)
            {
                "HKEY_LOCAL_MACHINE"
                {
                    if(Test-Path -Path Registry::HKEY_LOCAL_MACHINE\$Key -PathType Any)
                    {$this.Compliant = $true;}
                    else
                    {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key"}
                }
                "HKEY_CURRENT_USER"
                {
                    [string]$user = [string]((Get-CimInstance -Class Win32_ComputerSystem).UserName).split("\")[1]
                    [string]$SID = [string]((Get-ADUser -Identity $user).SID)
                    if(Test-Path -Path Registry::HKEY_USERS\$SID`\$Key -PathType Any)
                    {$this.Compliant = $true;}
                    else
                    {$this.Compliant = $false;$this.Result = "$ltype check as not found HKEY_USERS\$SID`\$key"}
                }
                "HKEY_USERS"
                {
                    if(Test-Path -Path Registry::HKEY_USERS\$Key -PathType Any)
                    {$this.Compliant = $true;}
                    else
                    {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key"}
                }
                "ALL_USERS"
                {
                    [bool]$each_asit = $true;
                    [string[]]$error_stack = @()
                    foreach($UKey in Get-ChildItem Registry::HKEY_USERS)
                    {
                        if($UKey.Name -notlike "*HKEY_USERS\.DEFAULT*" -and $UKey.Name -notlike "*_Classes" -and $UKey.Name.Length -gt 30)
                        {
                            $profilekey = $UKey.Name
                            if(-not (Test-Path Registry::$profilekey`\$key)){$each_asit = $false;$error_stack += "$profilekey`\$key";}
                        }
                    }
                    if($each_asit -eq $true)
                    {
                        $this.Compliant = $true;
                    }
                    else
                    {
                        $this.Compliant = $false;
                        [string]$string_error = ([string]($error_stack).Replace("`n",";"));
                        $this.Result = "All the folowing $ltype key are missing on device $string_error" 
                    }
                }
                Default {$this.Result = "The $ltype check required to specify a Target: HKEY_LOCAL_MACHINE, HKEY_CURRENT_USER, HKEY_USERS, ALL_USERS"}
            }
        }
        else
        {
            if($Value.Length -lt 1)
            {
                switch ($Target)
                {
                    "HKEY_LOCAL_MACHINE"
                    {
                        if(Test-Path -Path Registry::HKEY_LOCAL_MACHINE\$Key -PathType Any)
                        {
                            if(((Get-Item Registry::HKEY_LOCAL_MACHINE\$key).Property) -eq $Name)
                            {$this.Compliant = $true;}
                            else
                            {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key Name: $Name";}
                        }
                        else
                        {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key"}
                    }
                    "HKEY_CURRENT_USER"
                    {
                        [string]$user = [string]((Get-CimInstance -Class Win32_ComputerSystem).UserName).split("\")[1]
                        [string]$SID = [string]((Get-ADUser -Identity $user).SID)
                        if(Test-Path -Path Registry::HKEY_USERS\$SID`\$Key -PathType Any)
                        {
                            if(((Get-Item Registry::HKEY_USERS\$SID`\$key).Property) -eq $Name)
                            {$this.Compliant = $true;}
                            else
                            {$this.Compliant = $false;$this.Result = "$ltype check as not found HKEY_USERS\$SID`\$key Name: $Name";}
                        }
                        else
                        {$this.Compliant = $false;$this.Result = "$ltype check as not found HKEY_USERS\$SID`\$key"}
                    }
                    "HKEY_USERS"
                    {
                        if(Test-Path -Path Registry::HKEY_USERS\$Key -PathType Any)
                        {
                            if(((Get-Item Registry::HKEY_USERS\$key).Property) -eq $Name)
                            {$this.Compliant = $true;}
                            else
                            {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key Name: $Name";}
                        }
                        else
                        {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key"}
                    }
                    "ALL_USERS"
                    {
                        [bool]$each_asit = $true;
                        [string[]]$error_stack = @()
                        foreach($UKey in Get-ChildItem Registry::HKEY_USERS)
                        {
                            if($UKey.Name -notlike "*HKEY_USERS\.DEFAULT*" -and $UKey.Name -notlike "*_Classes" -and $UKey.Name.Length -gt 30)
                            {
                                $profilekey = $UKey.Name
                                if(-not (Test-Path Registry::$profilekey`\$key))
                                {
                                    $each_asit = $false;
                                    $error_stack += "$profilekey`\$key";
                                }
                                else
                                {
                                    if(-not (((Get-Item Registry::$profilekey`\$key).Property) -eq $Name))
                                    {$each_asit = $false;$error_stack += "$Target`\$key => $Name";}
                                }
                            }
                        }
                        if($each_asit -eq $true)
                        {
                            $this.Compliant = $true;
                        }
                        else
                        {
                            $this.Compliant = $false;
                            [string]$string_error = ([string]($error_stack).Replace("`n",";"));
                            $this.Result = "All the folowing $ltype key are missing on device $string_error" 
                        }
                    }
                    Default {$this.Result = "The $ltype check required to specify a Target: HKEY_LOCAL_MACHINE, HKEY_CURRENT_USER, HKEY_USERS, ALL_USERS"}
                }
            }
            else
            {
                switch ($Target)
                {
                    "HKEY_LOCAL_MACHINE"
                    {
                        if(Test-Path -Path Registry::HKEY_LOCAL_MACHINE\$Key -PathType Any)
                        {
                            if(((Get-Item Registry::HKEY_LOCAL_MACHINE\$key).Property) -eq $Name)
                            {
                                switch ($Value_Type)
                                {
                                    "String"
                                    {
                                        [string]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_LOCAL_MACHINE\$key -Name "$Name"
                                        [string]$Test_Value = $Value
                                        if($Item_Value -like "$Test_Value"){$this.Compliant = $true;}
                                        else{$this.Compliant = $false;$this.Result = "This $ltype check as not found $Target`\$key Name: $Name Value: $Test_Value"}
                                    }
                                    "Integer"
                                    {
                                        [int]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_LOCAL_MACHINE\$key -Name "$Name"
                                        [int]$Test_Value = $Value
                                        switch ($Operator)
                                        {
                                            "Equals" { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Not equal to" { if($Item_Value -ne $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Greater than or equal to" { if($Item_Value -ge $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";}}
                                            "Greater than" { if($Item_Value -gt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than" { if($Item_Value -lt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than or equal to" { if($Item_Value -le $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            Default { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                        }
                                    }
                                    "Version"
                                    {
                                        [version]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_LOCAL_MACHINE\$key -Name "$Name"
                                        [version]$Test_Value = $Value
                                        switch ($Operator)
                                        {
                                            "Equals" { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Not equal to" { if($Item_Value -ne $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Greater than or equal to" { if($Item_Value -ge $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";}}
                                            "Greater than" { if($Item_Value -gt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than" { if($Item_Value -lt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than or equal to" { if($Item_Value -le $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            Default { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                        }
                                    }
                                }
                            }
                            else
                            {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key Name: $Name";}
                        }
                        else
                        {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key"}
                    }
                    "HKEY_CURRENT_USER"
                    {
                        [string]$user = [string]((Get-CimInstance -Class Win32_ComputerSystem).UserName).split("\")[1]
                        [string]$SID = [string]((Get-ADUser -Identity $user).SID)
                        if(Test-Path -Path Registry::HKEY_USERS\$SID`\$Key -PathType Any)
                        {
                            if(((Get-Item Registry::HKEY_USERS\$SID`\$key).Property) -eq $Name)
                            {
                                switch ($Value_Type)
                                {
                                    "String"
                                    {
                                        [string]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_USERS\$SID`\$key -Name "$Name"
                                        [string]$Test_Value = $Value
                                        if($Item_Value -like "$Test_Value"){$this.Compliant = $true;}
                                        else{$this.Compliant = $false;$this.Result = "This $ltype check as not found $Target`\$key Name: $Name Value: $Test_Value"}
                                    }
                                    "Integer"
                                    {
                                        [int]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_USERS\$SID`\$key -Name "$Name"
                                        [int]$Test_Value = $Value
                                        switch ($Operator)
                                        {
                                            "Equals" { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Not equal to" { if($Item_Value -ne $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Greater than or equal to" { if($Item_Value -ge $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";}}
                                            "Greater than" { if($Item_Value -gt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than" { if($Item_Value -lt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than or equal to" { if($Item_Value -le $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            Default { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                        }
                                    }
                                    "Version"
                                    {
                                        [version]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_USERS\$SID`\$key -Name "$Name"
                                        [version]$Test_Value = $Value
                                        switch ($Operator)
                                        {
                                            "Equals" { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Not equal to" { if($Item_Value -ne $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Greater than or equal to" { if($Item_Value -ge $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";}}
                                            "Greater than" { if($Item_Value -gt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than" { if($Item_Value -lt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than or equal to" { if($Item_Value -le $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            Default { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                        }
                                    }
                                }
                            }
                            else
                            {$this.Compliant = $false;$this.Result = "$ltype check as not found HKEY_USERS\$SID`\$key Name: $Name";}
                        }
                        else
                        {$this.Compliant = $false;$this.Result = "$ltype check as not found HKEY_USERS\$SID`\$key"}
                    }
                    "HKEY_USERS"
                    {
                        if(Test-Path -Path Registry::HKEY_USERS\$Key -PathType Any)
                        {
                            if(((Get-Item Registry::HKEY_USERS\$key).Property) -eq $Name)
                            {
                                switch ($Value_Type)
                                {
                                    "String"
                                    {
                                        [string]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_USERS\$key -Name "$Name"
                                        [string]$Test_Value = $Value
                                        if($Item_Value -like "$Test_Value"){$this.Compliant = $true;}
                                        else{$this.Compliant = $false;$this.Result = "This $ltype check as not found $Target`\$key Name: $Name Value: $Test_Value"}
                                    }
                                    "Integer"
                                    {
                                        [int]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_USERS\$key -Name "$Name"
                                        [int]$Test_Value = $Value
                                        switch ($Operator)
                                        {
                                            "Equals" { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Not equal to" { if($Item_Value -ne $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Greater than or equal to" { if($Item_Value -ge $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";}}
                                            "Greater than" { if($Item_Value -gt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than" { if($Item_Value -lt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than or equal to" { if($Item_Value -le $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            Default { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                        }
                                    }
                                    "Version"
                                    {
                                        [version]$Item_Value = Get-ItemPropertyValue -Path Registry::HKEY_USERS\$key -Name "$Name"
                                        [version]$Test_Value = $Value
                                        switch ($Operator)
                                        {
                                            "Equals" { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Not equal to" { if($Item_Value -ne $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Greater than or equal to" { if($Item_Value -ge $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";}}
                                            "Greater than" { if($Item_Value -gt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than" { if($Item_Value -lt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            "Less than or equal to" { if($Item_Value -le $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                            Default { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                        }
                                    }
                                }
                            }
                            else
                            {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key Name: $Name";}
                        }
                        else
                        {$this.Compliant = $false;$this.Result = "$ltype check as not found $Target`\$key"}
                    }
                    "ALL_USERS"
                    {
                        [bool]$each_asit = $true;
                        [string[]]$error_stack = @()
                        foreach($UKey in Get-ChildItem Registry::HKEY_USERS)
                        {
                            if($UKey.Name -notlike "*HKEY_USERS\.DEFAULT*" -and $UKey.Name -notlike "*_Classes" -and $UKey.Name.Length -gt 30)
                            {
                                $profilekey = $UKey.Name
                                if(-not (Test-Path Registry::$profilekey`\$key))
                                {
                                    $each_asit = $false;
                                    $error_stack += "$profilekey`\$key";
                                }
                                else
                                {
                                    if(-not (((Get-Item Registry::$profilekey`\$key).Property) -eq $Name))
                                    {$each_asit = $false;$error_stack += "$Target`\$key => $Name";}
                                    else
                                    {
                                        switch ($Value_Type)
                                        {
                                            "String"
                                            {
                                                [string]$Item_Value = Get-ItemPropertyValue -Path Registry::$profilekey`\$key -Name "$Name"
                                                [string]$Test_Value = $Value
                                                if($Item_Value -like "$Test_Value"){$this.Compliant = $true;}
                                                else{$this.Compliant = $false;$this.Result = "This $ltype check as not found $Target`\$key Name: $Name Value: $Test_Value"}
                                            }
                                            "Integer"
                                            {
                                                [int]$Item_Value = Get-ItemPropertyValue -Path Registry::$profilekey`\$key -Name "$Name"
                                                [int]$Test_Value = $Value
                                                switch ($Operator)
                                                {
                                                    "Equals" { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    "Not equal to" { if($Item_Value -ne $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    "Greater than or equal to" { if($Item_Value -ge $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";}}
                                                    "Greater than" { if($Item_Value -gt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    "Less than" { if($Item_Value -lt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    "Less than or equal to" { if($Item_Value -le $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    Default { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                }
                                            }
                                            "Version"
                                            {
                                                [version]$Item_Value = Get-ItemPropertyValue -Path Registry::$profilekey`\$key -Name "$Name"
                                                [version]$Test_Value = $Value
                                                switch ($Operator)
                                                {
                                                    "Equals" { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    "Not equal to" { if($Item_Value -ne $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    "Greater than or equal to" { if($Item_Value -ge $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";}}
                                                    "Greater than" { if($Item_Value -gt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    "Less than" { if($Item_Value -lt $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    "Less than or equal to" { if($Item_Value -le $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                    Default { if($Item_Value -eq $Test_Value){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype do not match $Item_Value $Operator $Test_Value";} }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if($each_asit -eq $true)
                        {
                            $this.Compliant = $true;
                        }
                        else
                        {
                            $this.Compliant = $false;
                            [string]$string_error = ([string]($error_stack).Replace("`n",";"));
                            $this.Result = "All the folowing $ltype key are missing on device $string_error" 
                        }
                    }
                    Default {$this.Result = "The $ltype check required to specify a Target: HKEY_LOCAL_MACHINE, HKEY_CURRENT_USER, HKEY_USERS, ALL_USERS"}
                }
            }
        }
    }
    [void]TestApplication([string]$Product_Code,[string]$Name,[string]$Version,[string]$Operator)
    {
        $this.Type = "Application"
        $ltype = $this.Type;

        if($Product_Code.Length -gt 1)
        {
            if($Version.Length -gt 1)
            {
                if($Product_Code.Split("-").Count -gt 4 -and $Product_Code.Length -gt 36 -and $Product_Code -like "{*" -and $Product_Code -like "*}")
                {
                    $Application = (Get-CimInstance -ClassName Win32_Product -Filter "IdentifyingNumber LIKE '$Product_Code'");
                    if([int]([string]($Application.IdentifyingNumber).Length) -gt 1)
                    {
                        [version]$Product_Vesion = $Application.Version;
                        [version]$Test_Version = $Version;
                        [string]$AppName = $Application.Name
                        switch ($Operator)
                        {
                            "Equals" { if($Product_Vesion -eq $Test_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype $AppName - $Product_Code do not match version $Product_Vesion $Operator $Test_Version";} }
                            "Not equal to" { if($Product_Vesion -ne $Test_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype $AppName - $Product_Code do not match version $Product_Vesion $Operator $Test_Version";} }
                            "Greater than or equal to" { if($Product_Vesion -ge $Test_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype $AppName - $Product_Code do not match version $Product_Vesion $Operator $Test_Version";}}
                            "Greater than" { if($Product_Vesion -gt $Test_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype $AppName - $Product_Code do not match version $Product_Vesion $Operator $Test_Version";} }
                            "Less than" { if($Product_Vesion -lt $Test_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype $AppName - $Product_Code do not match version $Product_Vesion $Operator $Test_Version";} }
                            "Less than or equal to" { if($Product_Vesion -le $Test_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype $AppName - $Product_Code do not match version $Product_Vesion $Operator $Test_Version";} }
                            Default { if($Product_Vesion -eq $Test_Version){$this.Compliant = $true;}else{$this.Compliant = $false; $this.Result = "$ltype $AppName - $Product_Code do not match version $Product_Vesion $Operator $Test_Version";} }
                        }
                    }
                    else
                    {
                        $this.Compliant = $false;    
                        $this.Result = "$ltype was not found using the product code: $Product_Code"
                    }
                }
                else 
                {
                    $this.Compliant = $false
                    $this.Result = "$ltype check can't parse $Product_Code because is not a valid product code"
                }
            }
            else
            {
                if($Product_Code.Split("-").Count -gt 4 -and $Product_Code.Length -gt 36 -and $Product_Code -like "{*" -and $Product_Code -like "*}")
                {
                    $Application = (Get-CimInstance -ClassName Win32_Product -Filter "IdentifyingNumber LIKE '$Product_Code'");
                    if([int]([string]($Application.IdentifyingNumber).Length) -gt 1)
                    {
                        $this.Compliant = $true;
                    }
                    else
                    {
                        $this.Compliant = $false;    
                        $this.Result = "$ltype was not found using the product code: $Product_Code"
                    }
                }
                else 
                {
                    $this.Compliant = $false
                    $this.Result = "$ltype check can't parse $Product_Code because is not a valid product code"
                }
            }

        }
        if($Name.Length -gt 1)
        {
            if($Version.Length -gt 1)
            {
                $Application = (Get-CimInstance -ClassName Win32_Product -Filter "IdentifyingNumber LIKE '$Name'");
            }
            else
            {
                $Application = (Get-CimInstance -ClassName Win32_Product -Filter "Name LIKE '$Name'");
                if([int]([string]($Application.IdentifyingNumber).Length) -gt 1)
                {
                    $this.Compliant = $true;
                }
                else
                {
                    $this.Compliant = $false;
                    $this.Result = "$ltype was not found using the name: $Name"
                }
            }
        }

    }
    [void]TestScript([scriptblock]$Script_Block,[string]$Result_Variable,[string]$Type)
    {
        $this.Type = $Type;
        [bool]$_Result = Invoke-Command -ScriptBlock $Script_Block
        $this.Compliant = $_Result
        $GlobalVar = "`$Global:$Result_Variable"
        $this.Result = (Invoke-Expression($GlobalVar))
    }
}
class DetectionMethodGroup {
    [bool]$Compliants
    [DetectionMethod[]]$Methods
    [bool] TestDetectionMethod()
    {
        foreach($Method in $this.Methods)
        {
            if($Method.Compliant)
            {
                $this.Compliants = $true;
            }
            else 
            {
                $this.Compliants = $false;
                break;
            }
        }
        return $this.Compliants
    }
    [void] AddDetectionMethod([DetectionMethod]$DetectionMethod){$this.Methods += $DetectionMethod;}
}
function Start-DetectionMethod
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$ApplicationName,
        [Parameter(Mandatory = $true)]
        [scriptblock]$DetectionMethodScript
    )

    [DetectionMethodGroup]$Global:DetectionGroup = New-Object DetectionMethodGroup
    $Global:DetectionGroup.Compliants = $null;
    $Global:DetectionGroup.Methods = $null;
    [string]$Today = Get-Date -Format "dd_MM_yyyy hh_mm_ss tt";
    if(-not (Test-Path -Path "C:\LogFiles" -PathType Container)){New-Item -Path "C:\LogFiles" -ItemType Directory -Force;}
    if(-not (Test-Path -Path "C:\LogFiles\$ApplicationName" -PathType Container)){New-Item -Path "C:\LogFiles\$ApplicationName" -ItemType Directory -Force;}
    Invoke-Command -ScriptBlock $DetectionMethodScript;
    Test-DetectionMethod -LogPath "C:\LogFiles\$ApplicationName`\$Today`.log";

}
function Test-DetectionMethod([string]$LogPath)
{
    if([string]$Global:DetectionGroup.TestDetectionMethod() -notlike "*False*")
    {
        Write-Host "Application is Install" -ForegroundColor Green;
        foreach($obj in $Global:DetectionGroup.Methods)
        {
            "-------------------------------------------------" | Out-File -FilePath "$LogPath" -Encoding utf8 -Append -Force
            $obj.Type | Out-File -FilePath "$LogPath" -Encoding utf8 -Append -Force
            $obj.Result | Out-File -FilePath "$LogPath" -Encoding utf8 -Append -Force
            "-------------------------------------------------`n" | Out-File -FilePath "$LogPath" -Encoding utf8 -Append -Force
            "Application is Install" | Out-File -FilePath "$LogPath" -Encoding utf8 -Append -Force
            exit(0)
        }
    }
    else
    {
        $err = $Global:DetectionGroup.Methods[$Global:DetectionGroup.Results.Count-1].Result;
        $type = $Global:DetectionGroup.Methods[$Global:DetectionGroup.Results.Count-1].Type;
        "Application is still not install`nType: $type`n Error: $err" | Out-File -FilePath "$LogPath" -Encoding utf8 -Append -Force
        exit(404)
    }
    
}
function Add-Folder
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [Parameter(Mandatory = $false)]
        [string]
        $Date_Created,
        [Parameter(Mandatory = $false)]
        [string]
        $Date_Modified,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Equals', 'Not equal to', 'Greater than or equal to','Greater than','Less than','Less than or equal to')]
        [string]$Operator
    )
   
    if($Date_Created.Length -lt 1 -and $Date_Modified.Length -lt 1)
    {
        $_METHOD = New-Object DetectionMethod;
        $_METHOD.TestFolder($Path,$null,$null,$null);
        $Global:DetectionGroup.AddDetectionMethod($_METHOD);
    }
    else
    {
        if($Date_Created.Length -gt 1)
        {
            $_METHOD = New-Object DetectionMethod;
            $_METHOD.TestFolder($Path,$Date_Created,$null,$Operator);
            $Global:DetectionGroup.AddDetectionMethod($_METHOD);
        }
        if($Date_Modified.Length -gt 1)
        {
            $_METHOD = New-Object DetectionMethod;
            $_METHOD.TestFolder($Path,$null,$Date_Modified,$Operator);
            $Global:DetectionGroup.AddDetectionMethod($_METHOD);
        } 
    }
}
function Add-File
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $Path,
        [Parameter(Mandatory = $false)]
        [string]
        $Date_Created,
        [Parameter(Mandatory = $false)]
        [string]
        $Date_Modified,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Equals', 'Not equal to', 'Greater than or equal to','Greater than','Less than','Less than or equal to')]
        [string]$Operator,
        [Parameter(Mandatory=$false)]
        [string]$Version,
        [Parameter(Mandatory=$false)]
        [string]$Major,
        [Parameter(Mandatory=$false)]
        [string]$Minor,
        [Parameter(Mandatory=$false)]
        [string]$Build,
        [Parameter(Mandatory=$false)]
        [string]$BuildExt,
        [Parameter(Mandatory=$false)]
        [ValidateSet('File', 'Product')]
        [string]$Version_Target,
        [Parameter(Mandatory=$false)]
        [string]$Size,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Gb', 'Mb','Kb','Byte')]
        [string]$Size_Target
    )
    
    if($Date_Created.Length -lt 1 -and $Date_Modified.Length -lt 1 -and $Size.Length -lt 1 -and $Version.Length -lt 1 -and $Minor.Length -lt 1 -and $Major.Length -lt 1 -and $Build.Length -lt 1 -and $BuildExt.Length -lt 1)
    {
        $_METHOD = New-Object DetectionMethod;
        $_METHOD.TestFile($Path,$null,$null,$null,$null,$null);
        $Global:DetectionGroup.AddDetectionMethod($_METHOD);
    }
    else
    {
        if($Date_Created.Length -gt 1)
        {
            $_METHOD = New-Object DetectionMethod;
            $_METHOD.TestFile($Path,$Date_Created,$null,$Operator,$null,$null);
            $Global:DetectionGroup.AddDetectionMethod($_METHOD);
        }
        if($Date_Modified.Length -gt 1)
        {
            $_METHOD = New-Object DetectionMethod;
            $_METHOD.TestFile($Path,$null,$Date_Modified,$Operator,$null,$null);
            $Global:DetectionGroup.AddDetectionMethod($_METHOD);
        } 
        if($Size.Length -ge 1)
        { 
            $_METHOD = New-Object DetectionMethod;
            switch ($Size_Target) {
                "Gb" { [string]$_Size = [string]([int]$Size*1000000000);$_METHOD.TestFile($Path,$null,$null,$Operator,$null,$_Size); }
                "Mb"{ [string]$_Size = [string]([int]$Size*1000000);$_METHOD.TestFile($Path,$null,$null,$Operator,$null,$_Size); }
                "Kb"{ [string]$_Size = [string]([int]$Size*1000);$_METHOD.TestFile($Path,$null,$null,$Operator,$null,$_Size); }
                "Byte"{ $_METHOD.TestFile($Path,$null,$null,$Operator,$null,$Size); }
                Default { $_METHOD.TestFile($Path,$null,$null,$Operator,$null,$Size);}
            }
            $Global:DetectionGroup.AddDetectionMethod($_METHOD);
        }
        if($Version.Length -gt 1)
        {
            $_METHOD = New-Object DetectionMethod;
            if($Version_Target.Length -lt 2){$Version_Target = "File";}
            $Set_Of_Version = @("Full",$Version,$Version_Target)
            $_METHOD.TestFile($Path,$null,$null,$Operator,$Set_Of_Version,$null);
            $Global:DetectionGroup.AddDetectionMethod($_METHOD);
            
        }
        else
        {
            if($Version_Target.Length -lt 2){$Version_Target = "File";}
            if($Major.Length -ge 1)
            {
                $_METHOD = New-Object DetectionMethod;
                $Set_Of_Version = @("Major",$Major,$Version_Target)
                $_METHOD.TestFile($Path,$null,$null,$Operator,$Set_Of_Version,$null);
                $Global:DetectionGroup.AddDetectionMethod($_METHOD);
            }
            if($Minor.Length -ge 1)
            {
                $_METHOD = New-Object DetectionMethod;
                $Set_Of_Version = @("Minor",$Minor,$Version_Target)
                $_METHOD.TestFile($Path,$null,$null,$Operator,$Set_Of_Version,$null);
                $Global:DetectionGroup.AddDetectionMethod($_METHOD);
            }
            if($Build.Length -ge 1)
            {
                $_METHOD = New-Object DetectionMethod;
                $Set_Of_Version = @("Build",$Build,$Version_Target);
                $_METHOD.TestFile($Path,$null,$null,$Operator,$Set_Of_Version,$null);
                $Global:DetectionGroup.AddDetectionMethod($_METHOD);
            }
            if($BuildExt.Length -ge 1)
            {
                $_METHOD = New-Object DetectionMethod;
                $Set_Of_Version = @("BuildExt",$BuildExt,$Version_Target);
                $_METHOD.TestFile($Path,$null,$null,$Operator,$Set_Of_Version,$null);
                $Global:DetectionGroup.AddDetectionMethod($_METHOD);
            }
        }
    }
}
function Add-Registry {
    param (
        [Parameter(Mandatory=$true)]
        [ValidateSet('HKEY_LOCAL_MACHINE', 'HKEY_CURRENT_USER', 'HKEY_USERS','ALL_USERS')]
        $Target,
        [Parameter(Mandatory = $true)]
        [string]
        $Key,
        [Parameter(Mandatory = $false)]
        [string]
        $Name,
        [Parameter(Mandatory = $false)]
        [string]
        $Value,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Equals', 'Not equal to', 'Greater than or equal to','Greater than','Less than','Less than or equal to')]
        [string]$Operator,
        [Parameter(Mandatory=$false)]
        [ValidateSet('String', 'Integer', 'Version')]
        $Value_Type
    )
    if($Name.Length -lt 1)
    {
        $_METHOD = New-Object DetectionMethod;
        $_METHOD.TestRegistry($Target,$Key,$null,$null,$null,$null);
        $Global:DetectionGroup.AddDetectionMethod($_METHOD);
    }
    else
    {
        if($Value.Length -lt 1)
        {
            $_METHOD = New-Object DetectionMethod;
            $_METHOD.TestRegistry($Target,$Key,$Name,$null,$null,$null);
            $Global:DetectionGroup.AddDetectionMethod($_METHOD);
        }
        else
        {
            if($Value_Type.Length -lt 1){$Value_Type = "String"}
            $_METHOD = New-Object DetectionMethod;
            $_METHOD.TestRegistry($Target,$Key,$Name,$Value,$Operator,$Value_Type);
            $Global:DetectionGroup.AddDetectionMethod($_METHOD);    
        }
            

    }
}
function Add-Application {
    param (
        [Parameter(Mandatory=$false)]
        [string]
        $Product_Code,
        [Parameter(Mandatory=$false)]
        [string]
        $Name,
        [Parameter(Mandatory=$false)]
        [string]
        $Version,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Equals', 'Not equal to', 'Greater than or equal to','Greater than','Less than','Less than or equal to')]
        [string]$Operator
    )
    if($Product_Code.Length -gt 1)
    {
        $_METHOD = New-Object DetectionMethod;
        $_METHOD.TestApplication($Product_Code,$null,$null,$null);
        $Global:DetectionGroup.AddDetectionMethod($_METHOD);
    }

    if($Name.Length -gt 1)
    {
        $_METHOD = New-Object DetectionMethod;
        $_METHOD.TestApplication($null,$Name,$null,$null);
        $Global:DetectionGroup.AddDetectionMethod($_METHOD);
    }

    if($Version.Length -gt 1)
    {
        $_METHOD = New-Object DetectionMethod;
        $_METHOD.TestApplication($Product_Code,$null,$Version,$Operator);
        $Global:DetectionGroup.AddDetectionMethod($_METHOD);
    }
}
function Add-Script {
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Type,
        [Parameter(Mandatory = $true)]
        [scriptblock]$Script,
        [Parameter(Mandatory = $true)]
        [string]$Result_Global_Variable_Name
    )

    $_METHOD = New-Object DetectionMethod;
    $_METHOD.TestScript($Script,$Result_Global_Variable_Name,$Type);
    $Global:DetectionGroup.AddDetectionMethod($_METHOD);
}

Export-ModuleMember -Function @("Start-DetectionMethod","Add-Folder","Add-File","Add-Registry","Add-Application","Add-Script","Test-DetectionMethod")