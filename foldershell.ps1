function Introduction {
    #The introduction function. Introduces the program and asks the user what action to take.
    Write-Host "Folder-Shell, Developed by MST Studios`n"
    Write-Host "What would you like to do? (Enter the number of the respective action.)"
    Write-Host "1-Sort Files in a Given directory`n"
    Write-Host "2-Move a File`n"

    $chosen_action=Read-Host "Action:"

    if ($chosen_action -eq 1){SortFiles}
    if ($chosen_action -eq 2){SendFiles}
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
    $SendDestination=Read-Host "Enter Where you'd like it to be sent"
    Move-Item -Path $SendSource -Destination $SendDestination
}

#Next feature to be added: A way to save folders as storage place
#Another important feature: A way to navigate folders

Introduction