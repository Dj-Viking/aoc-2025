param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$joltages = @();
$maxjts = @();
$maxjts2 = [system.collections.arraylist]@();

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
	$max_index = 0;
	#separating part1 loop since it's different
	:firstpass for ($i = 0; $i -lt $joltages.length - 1; $i++) 
	{
		$bat = $joltages[$i];
		if ($bat -gt $joltages[$max_index]) {
			$max_index = $i
		}
	}

	# start after the one we found previous pass
	$next_max_index = $max_index + 1;
	:secondpass for ($i = $max_index + 1; $i -lt $joltages.length; $i++) 
	{
		$bat = $joltages[$i];
		if ($bat -gt $joltages[$next_max_index]) {
			$next_max_index = $i
		}
	}

	$jt = $($joltages[$max_index] * 10 
		+ $joltages[$next_max_index]
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
[int64]$sum2 = 0;
foreach($line in $in) {
	$joltages = @();
	$maxjts2 = [system.collections.arraylist]@();
	$line.tochararray() | foreach-object {
		$joltages += [int]($_.tostring());
	}
	
	# find 12 digits
	# largest num  for all values excluding last 11 values
	# last 11 need to be included in number no search on those
	# o
	# find max value upt o index N - 11 search 2342
	#   # search : (2342) chop| 34234234278
		# max:4
	
	$max_index = 0;
	for ($needed = 11; `
		 $needed -ge 0; $needed--) 
	{

		for ($i = $max_index; `
			 $i -lt $joltages.length - $needed; $i++) 
		{
			if ($joltages[$i] -gt $joltages[$max_index]) {
				$max_index = $i;
			}
		}

		$maxjts2.add($joltages[$max_index]) | out-null;
		$max_index = $max_index + 1;

	}

	$sum2 += [int64]("$($maxjts2 -join `"`")");
}

write-host "answer2: $sum2"

