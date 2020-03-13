$files = (Get-ChildItem 'N:\Photos\Crawley Photo Library Export' -Recurse -File -Exclude ".*")
$target = "N:\Photos\Archive\"

foreach ($file in $files) {
    $createdDate = (Get-Date $file.CreationTime)
    $modifiedDate = (Get-Date $file.LastWriteTime)

    # Extract EXIF taken date
    $exifDate = (./exiftool.exe -T -d "%Y-%m-%d %H:%M:%S" -createdate $file.FullName) | Out-String
    if ($exifDate -as [DateTime]) {
        $createdDate = (Get-Date $exifDate)
    }

    # Build target file path
    $destination = $target + $createdDate.Year + "\" + "$("{0:d2}" -f $createdDate.Month)" + "\" + $file.Name

    #  If this file doesn't already exist
    if (!(Test-Path -Path $destination)) {
        # Touch to create the directory structure
        New-Item -ItemType File -Path $destination -Force

        # Copy and update the timestamps to match the original
        Copy-Item $file.FullName -Destination $destination
        (Get-ChildItem $destination).CreationTime = $createdDate
        (Get-ChildItem $destination).LastWriteTime = $modifiedDate
    }
}
