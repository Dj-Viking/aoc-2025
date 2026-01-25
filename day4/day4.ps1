param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$answer1 = "";
$answer2 = ""; 

$in = get-content $(join-path `
	$psscriptroot `
	$file)

#part1
foreach($line in $in) {
}

write-host "$answer1"

#part2
foreach($line in $in) {
}

write-host "answer2: $answer2"

