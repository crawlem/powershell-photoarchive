$target = "N:\Photos\Crawley Photo Library Export\"
$csvFile = (Import-CSV "$($target)duplicates.csv")

foreach ($line in $csvFile) {
    $path = $line.Duplicate
    if ((Test-Path -Path $path)) {
        echo "Deleting $($path)"
        Remove-Item -Path $path
    }
}