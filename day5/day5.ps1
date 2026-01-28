param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$in = get-content $(join-path `
	$psscriptroot `
	$file)

#part1
$ranges = [system.collections.arraylist]@();
#ranges can overlap
$is_ranges = $true
$fresh_cnt = [int64](0);

foreach ($line in $in) {
	if ($line -eq [string]::empty) {
		$is_ranges = $false;
	}

	#looking at id ranges
	if ($is_ranges -eq $true) {
		$split = $line.split("-");
		$ranges.add(@(
			  [int64]($split[0]), 
			  [int64]($split[1])
			)
		) | out-null;
	}

	#looking at single ids
	if ($is_ranges -eq $false) {
		$num = [int64]$line;
		:range foreach ($range in $ranges) {
			if ($num -ge $range[0] -and `
				$num -le $range[1]
			){
				$fresh_cnt += 1;
				break range;
			}

		}
	}
}
write-host $fresh_cnt

#part2
