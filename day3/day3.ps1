param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$joltages = @();
$maxjts = @();

$in = get-content $(join-path `
	$psscriptroot `
	$file)

#part1
foreach($line in $in) {
	$joltages = @();
	write-host "======line"
	write-host $line
	$chrs = $line.tochararray()
	$chrs | foreach-object {
		$joltages += [int]($_.tostring());
	}

	<#
#   In 811111111111119, 
#	you can make the largest joltage possible by turning on the 
#	batteries labeled 8 and 9, 
#	producing 89 jolts.
	#>
	$bats = @() 
	:connecting for ($i = 0; $i -lt $joltages.length; $i++) 
	{
		$bat = $joltages[$i];
		if ($bats.length -eq 0) 
		{
			$bats += $bat;
			continue connecting;
		}

		if ($bats.length -eq 1 `
		-and $bat -gt $bats[0]) 
		{
			$bats[0] = $bat;
			continue connecting;
		} 

		if ($bats.length -eq 1 `
		-and $bat -lt $bats[0]) 
		{
			$bats += $bat;
			continue connecting;
		}

		#  4       4(reset)  |  7 and not the end!
		#  7       ( )       |  8
		#  7        8
		if ($bats.length -eq 2 `
		-and $bats[0] -lt $bat `
		-and $bats[0] -le $bats[1] `
		-and $i -ne $joltages.length - 1) 
		{
			$bats = @($bat, 0)
			continue connecting;
		}

		if ($bats.length -eq 2 `
		-and $bats[1] -lt $bat `
		-and $bats[0] -ge $bats[1]) 
		{
			$bats[1] = $bat
			continue connecting;
		}
		<#
        818181911112111
		at the end?
		#>
		if ($bats.length -eq 2 `
		-and $bats[1] -lt $bat `
		-and $bats[0] -ge $bats[1] `
		-and $i -eq $joltages.length - 1) 
		{
			$bats[1] = $bat;
			continue connecting;
		}
		
	}

	$maxjts += [int]($($bats -join ""))

	write-host "=====maxjts"
	write-host $maxjts
}

$sum = 0;

$maxjts | ForEach-Object {
	$sum += $_;
}

# 16738 too low
write-host "answer1: $sum"


