param(
	[parameter(position = 0)]
	[string]$file = "sample",
	[switch]$part2 = $false
)

$joltages = @();
$maxjts = @();
$maxjts2 = @();

$in = get-content $(join-path `
	$psscriptroot `
	$file)

$reset_arr = [system.collections.arraylist]@(0,0,0,0,0,0,0,0,0,0,0,0);

$bats = $reset_arr 
#part1
foreach($line in $in) {
	$joltages = @();
	$bats = $reset_arr; 
	# write-host "======line"
	# write-host $line
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
	write-host "[$bats]"
	:firstpass for ($i = 0; $i -le $joltages.length; $i++) 
	{
	write-host "bats begin loop [$bats]"
		$bat = $joltages[$i];
		
		if ($part2) {
			if ($bats[-1] -eq 0 `
			-and $bats[$i] -lt $bat `
			-and $i -ne $joltages.length - 1) 
			{
				foreach ($b in $bats) {

				}
				if ($bats[$prev_idx] -ge $bat) 
				{
					$bats = $reset_arr;
					# current set first as $bat
					$bats.removeat(0);
					$bats.insert(0, $bat);
					$prev_idx -= 1;
				} else {
					$bats.removeat($i)
					$bats.insert($i, $bat)
				}
			} elseif ($bats[-1] -ne 0 `
			-and $bats[-1] -lt $bat `
			-and $i -le $joltages.length) 
			{
				$bats.removeat(11)
				$bats.insert(11, $bat)
				write-host "inserted [$bats]"

			# here need to reset the bats collection
			# if incoming number is greater
			# than all the previous numbers we collected
			} elseif ($bats[-1] -eq 0 `
			-and $bats[$prev_idx] -lt $bat `
			-and $i -le $joltages.length) 
			{
				$bats.removerange($prev_idx)
				$bats.insert($prev_idx, $bat)
				write-host "inserted [$bats]"
			}
		}
		$prev_idx += 1;
		if ($prev_idx -ge 12) {
			$prev_idx = 11;
		}
	}
	#separating part1 loop since it's different
	:firstpassagain for ($i = 0; $i -lt $joltages.length - 1; $i++) 
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
	write-host "final [$bats] $($bats.count)"

	$jt = $($joltages[$first_idx] * 10 
		+ $joltages[$second_idx]
	)

	$jt2 = 0
	if ($part2) {
		$jt2 = [int64]($bats -join "");
	}

	$maxjts  += $jt
	$maxjts2 += $jt2;

	# write-host "=====maxjts"
	# write-host $maxjts
	write-host "=====maxjts2"
	write-host $maxjts2
}

$sum  = 0;
$sum2 = 0;

$maxjts | ForEach-Object { $sum += $_; }
$maxjts2 | ForEach-Object { $sum2 += $_; }

# 16738 too low
write-host "answer1: $sum"

if ($part2) {
	# 249221472 too low
	write-host "answer2: $sum2"
}
