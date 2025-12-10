param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$joltages = @();
$maxjts = @();
$maxjts2 = @();

$in = get-content $(join-path `
	$psscriptroot `
	$file)

#part1
foreach($line in $in) {
	$joltages = @();
	$line.tochararray() | foreach-object {
		$joltages += [int]($_.tostring());
	}

	<#
#   In 811111111111119, 
#	you can make the largest joltage possible by turning on the 
#	batteries labeled 8 and 9, 
#	producing 89 jolts.
	#>
	$first_idx = 0;
	$second_idx = 1;
	$prev_idx = 0;
	:firstpass for ($i = 0; $i -le $joltages.length; $i++) 
	{
		$bat = $joltages[$i];
		if ($prev_idx -ge 12) {
			$prev_idx = 11;
		}
	}
	#separating part1 loop since it's different
	:firstpass for ($i = 0; $i -lt $joltages.length - 1; $i++) 
	{
		$bat = $joltages[$i];
		if ($bat -gt $joltages[$first_idx]) {
			$first_idx = $i
		}
	}

	$second_idx = $first_idx + 1;
	:secondpass for ($i = $first_idx + 1; $i -lt $joltages.length; $i++) 
	{
		$bat = $joltages[$i];
		if ($bat -gt $joltages[$second_idx]) {
			$second_idx = $i
		}
	}

	$jt = $($joltages[$first_idx] * 10 
		+ $joltages[$second_idx]
	)


	$maxjts  += $jt

	# write-host "=====maxjts"
	# write-host $maxjts
}

$sum  = 0;

$maxjts | ForEach-Object { $sum += $_; }

# 16738 too low
write-host "answer1: $sum"

#part2

$sum2 = 0;
