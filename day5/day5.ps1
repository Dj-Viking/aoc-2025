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
		$id = [int64]$line;
		:range foreach ($range in $ranges) {
			if ($id -ge $range[0] -and `
				$id -le $range[1]
			){
				$fresh_cnt += 1;
				break range;
			}

		}
	}
}
write-host "part1: $fresh_cnt"

#part2
$ranges = [system.collections.arraylist]@();
# write-host $ranges
foreach ($line in $in) 
{
	if ($line -eq [string]::empty) {
		break;
	}
	#looking at all numbers in id ranges
	$split = $line.split("-");
	$ranges.add([system.collections.arraylist]@(
	  [int64]($split[0]), 
	  [int64]($split[1])
	)) | out-null;
}
[system.collections.arraylist]$sorted = $ranges | sort-object `
-property @{Expression = {$_[0][0]}}

# write-host "sorted len: $($sorted.count)"
foreach ($c in $sorted) {
	# write-host "item1 $($c[0])"
	# write-host "item2 $($c[1])"
	# write-host "===="
}


$i = 0;
while ($i -lt $sorted.count - 1) 
{
	if ($sorted[$i][1] -ge $sorted[$i + 1][0]) 
	{
		if ($sorted[$i][1] -lt $sorted[$i + 1][1])
		{
			$sorted[$i][1] = $sorted[$i + 1][1];
		}
		$sorted.remove($sorted[$i + 1]);
	} else {
		$i += 1;
	}
}

# write-host "processed $($sorted)"
foreach ($c in $sorted) {
	# write-host "item1 $($c[0])"
	# write-host "item2 $($c[1])"
	# write-host "===="
}

$result = 0;
foreach ($r in $sorted) {
	$result += [int64]($(($r[1] - $r[0]) + 1))
}
write-host "part2: $result";
