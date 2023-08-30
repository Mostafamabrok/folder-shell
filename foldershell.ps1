function Introduction {
    #The introduction function. Introduces the program and asks the user what action to take.
    Write-Host "Folder-Shell, Developed by MST Studios`n"
    Write-Host "What would you like to do? (Enter the number of the respective action.)`n"
    Write-Host "1-Sort Files in a Given directory"
    Write-Host "2-Move a File"
    Write-Host "3-Change Saved Directories"
    Write-Host "4-Close Application`n"

    $chosen_action=Read-Host "Action"

    if ($chosen_action -eq 1){SortFiles}
    if ($chosen_action -eq 2){SendFiles}
    if ($chosen_action -eq 3){ChangeFileConfig}
    if ($chosen_action -eq 4){Write-Host "Closing..."}

    else{Write-Host "INVALID ARGUMENT, PLEASE ENTER A VALID ARGUMENT`n"; Introduction}
}

function SortFiles { 
    #This function sorts files in a directory inputed by the user.
    Write-Host "Input the path you would like to be sorted:"
    $inputpath=Read-Host
    $sortedpath=Get-Childitem $inputpath

    foreach ($file in $sortedpath) {
        $filename=$file.FullName
        $extension=[IO.Path]::GetExtension($filename)
        mkdir "$inputpath\$extension\" -ErrorAction SilentlyContinue
        Move-Item -Path "$filename" -Destination "$inputpath\$extension\"
    }    
}

function SendFiles{
    $SendSource=Read-Host "Enter the path of the file you'd like to send."
    $ManualOrAuto=Read-Host "Would you like to use one of your saved directories? (y/n)"

    if ($ManualOrAuto -eq "y"){
        $sendfiletextcontent=Get-Content -Path SavedDestinations.txt
        Write-Host $sendfiletextcontent
        $chosen_saved_directory=Read-Host "Chose a Path"

        foreach ($pathname in $sendfiletextcontent){
            if ($pathname -like "*$chosen_saved_directory-*"){
                $final_send_choice=($pathname).trim("$chosen_saved_directory-}")
            }
        } 
        
        Move-Item -Path $SendSource -Destination $final_send_choice
    }

    if ($ManualOrAuto -eq "n"){
        $SendDestination=Read-Host "Enter Where you'd like it to be sent"
        Move-Item -Path $SendSource -Destination $SendDestination
    }
}

function ChangeFileConfig{
    Write-Host "Would you like to view, add, delete your saved locations? (deleting is currently not working) (v/a/d)"
    $config_chosen_action=Read-Host

    if ($config_chosen_action -eq "v"){
        Get-Content -Path SavedDestinations.txt
    }

    if ($config_chosen_action -eq "a"){
        if (Test-Path SavedDestinations.txt){
            $config_length=Get-Content SavedDestinations.txt | Measure-Object -Line | Select-Object Lines
            $content_to_be_added=Read-Host
            ("$config_length-").trim("L","i","n","e","s", "{", "}", "@","=")+$content_to_be_added >> SavedDestinations.txt
        }
        else{
            $content_to_be_added=Read-Host "Enter a path you'd like to save:"
            "0}-$content_to_be_added" >> SavedDestinations.txt
        }
    }

}

#Next Thing to be added: A way to navigate folders

Introduction