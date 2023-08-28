Write-Host "Folder-Shell, Developed by MST Studios"
Write-Host "Input the path you would like to be sorted:"
$inputpath=Read-Host
$sortedpath=Get-Childitem $inputpath
foreach ($file in $sortedpath) {
    $filename=$file.FullName
    echo $filename
}
