param(
	[string]$file = "sample"
)

$input = get-content -path $file;

foreach ($line in $input) {
	write-host $line
}
