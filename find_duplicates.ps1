$target = "N:\Photos\Crawley Photo Library Export\"
$folders = (Get-ChildItem $target -Recurse -Directory)

# Create log file
$output = $target + "duplicates.csv"
Add-Content $output 'Original,Duplicate'

foreach ($folder in $folders) {
    echo "Checking folder $($folder.FullName)"

    # Create hash table for files in this folder
    $hashtable = @{}

    $files = (Get-ChildItem -Path $folder.FullName -File | Sort-Object -Descending)
    foreach ($file in $files) {
        # Get a hash for this file
        $path = $file.FullName
        $hash = (Get-FileHash $path | Select -ExpandProperty Hash)

        # Check if we've seen this hash before
        if (!($hashTable.containsKey($hash))) {
            # First time we've seen this hash
            $hashTable += @{$hash = $path}
        } else {
            # This is a duplicate file
            echo "Found duplicate: $($path)"
            Add-Content $output "$($hashTable[$hash]),$($path)"
        }
    }
}