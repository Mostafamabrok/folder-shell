function Introduction {
    #The introduction function. Introduces the program and asks the user what action to take.
    Write-Host "Folder-Shell, Developed by MSTF Studios`n" -ForegroundColor White
    Write-Host "What would you like to do? (Enter the number of the respective action.)`n"
    Write-Host "1-Check a File or Folder's Properties"
    Write-Host "2-Move a File"
    Write-Host "3-Sort Files in a Given Directory"
    Write-Host "4-Delete all files in a given directory"
    Write-Host "5-Change or view Saved destinations."
    Write-Host "6-Close Application`n"

    $chosen_action=Read-Host "Action"

    if ($chosen_action -eq 1){CheckFileFolder}
    elseif ($chosen_action -eq 2){SendFiles}
    elseif ($chosen_action -eq 3){SortFiles}
    elseif ($chosen_action -eq 4){DeleteDirectory}
    elseif ($chosen_action -eq 5){ChangeFileConfig}
    elseif ($chosen_action -eq 6){Write-Host "Closing program..."; exit}

    else{Write-Host "'$chosen_action' is not a valid action. Please enter a number for a valid action. Only Enter a number, No spaces."}

    Introduction
}

function CheckFileFolder{
    $desired_check=Read-Host "Enter the path of the folder or file you'd like to check"
    Write-Host "Displaying info..."
    Get-Item $desired_check
    $enderman=Read-Host "Ok?"
    if ($enderman -eq "yes"){Write-Host "Why?"} #This is used to make sure that the user can keep the info on the screen.
}

function DeleteDirectory {
    $ManualOrAuto=Read-Host "Would you like to use one of your saved directory? (y/n)"
    if ($ManualOrAuto -eq "y"){
        Get-Content SavedDestinations.txt
        $chosen_saved_directory=Read-Host "Chose a path"

        foreach($pathname in Get-Content SavedDestinations.txt){
            if ($pathname -like "*$chosen_saved_directory*"){$directory_to_delete=($pathname).trim("$chosen_saved_directory-}")}
        }
    }

    if ($ManualOrAuto -eq "n"){$directory_to_delete=Read-Host "What Directory Would you like to empty? (Enter a Full path)"}
    
    foreach ($file in (Get-ChildItem $directory_to_delete).FullName){Remove-Item $file}
}

function SortFiles {
    $sort_type=Read-Host "Would you like to sort by file type, size, date of modification, or name feature? (t/s/d/n)"
    if ($sort_type -eq "t"){
        #This function sorts files in a directory inputed by the user and moves them into seperate folders based on their extension (file type).   
        Write-Host "Sorting by type."
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

    if ($sort_type -eq "s"){Write-Host "This Feature is currently being worked on."}
    if ($sort_type -eq "d"){Write-Host "This Feature is currently being worked on."}

    if ($sort_type -eq "n"){ #This sorts based on a special feature in a files name
        $path_tobe_sorted=Read-Host "Input the path you would like to be sorted"
        $name_feature=Read-Host "Input the name feature of your desired files to sort. (Special thing in their name)"
        mkdir "$path_tobe_sorted\$name_feature"
        Get-ChildItem $path_tobe_sorted | ForEach-Object {if ($_.Name -like "*$name_feature*"){Move-Item -Path $_.FullName -Destination "$path_tobe_sorted\$name_feature"}} -ErrorAction SilentlyContinue
    }
}

function SendFiles{
    $SendSource=Read-Host "Enter the path of the file you'd like to send."
    $ManualOrAuto=Read-Host "Would you like to use one of your saved directories? (y/n)"

    if ($ManualOrAuto -eq "y"){ #If the user choses to use one of their saved directories, execute these commands.
        $sendfiletextcontent=Get-Content -Path SavedDestinations.txt #This is the content of SavedDestinations.txt.
        Write-Host $sendfiletextcontent #This writes that content.
        $chosen_saved_directory=Read-Host "Chose a Path"

        foreach ($pathname in $sendfiletextcontent){ #This checks every saved directory if it matches the directory the user wants to send a file to.
            if ($pathname -like "*$chosen_saved_directory-*"){
                $final_send_choice=($pathname).trim("$chosen_saved_directory-}") #This creates the pathname that is used to send the file
            }
        } 
        
        Move-Item -Path $SendSource -Destination $final_send_choice #This line moves the file.
    }

    if ($ManualOrAuto -eq "n"){ #This function just takes where a file is and where to send it.
        $SendDestination=Read-Host "Enter Where you'd like it to be sent"
        Move-Item -Path $SendSource -Destination $SendDestination
    }
}

function ChangeFileConfig{
    Write-Host "Would you like to view, add, delete your saved locations? (v/a/d)"
    $config_chosen_action=Read-Host

    if ($config_chosen_action -eq "v"){ #If the user choses to view their saved directories.
        Get-Content -Path SavedDestinations.txt
    }

    if ($config_chosen_action -eq "a"){ #If the User choses to add to their saved directories.
        if (Test-Path SavedDestinations.txt){
            $config_length=Get-Content SavedDestinations.txt | Measure-Object -Line | Select-Object Lines #This variable has the amount of lines in Saved Destinations (saved directory amount).
            $content_to_be_added=Read-Host "Enter a path you'd like to save"
            if (Test-Path $content_to_be_added){("$config_length-").trim("L","i","n","e","s", "{", "}", "@","=")+$content_to_be_added >> SavedDestinations.txt} #Trim $configlength to a usable variable.
            #This checks if the path the user is trying to add is actually there. If not, It writes a message saying that the path is invalid.
            else{Write-Host "INVALID PATH, PLEASE ENTER A VALID PATH"}
        }
        else{
            $content_to_be_added=Read-Host "Enter a path you'd like to save"
            if (Test-Path $content_to_be_added){"0}-$content_to_be_added" >> SavedDestinations.txt}
            else{Write-Host "INVALID PATH, PLEASE ENTER A VALID PATH"} #This also checks if the path exists, and writes a message if not.
        }
    }

    if ($config_chosen_action -eq "d"){Remove-Item SavedDestinations.txt; Write-Host "Content Deleted"} #This Deletes SavedDestination.txt.
}

$restricted_paths=@("C:\", "C:\Users", "C:\Users", "C:\Users\$env:UserName\", "C:\Windows", "C:\Windows\System32") #This is a list of directories not to be modified. There will be future additons to this array in the future.

Introduction #This starts the program itself.