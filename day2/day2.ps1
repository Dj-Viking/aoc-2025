param(
    [string]$file = "sample"
)

$input = get-content $file;

foreach ($line in $input) {
    [string]$l = $line;
    Write-Host $l
}