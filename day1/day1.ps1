param(
	[string]$file = "sample"
)

$dial = 50;

$input = get-content -path $file;

$timescrossedzerogoingleft = 0;

foreach ($line in $input) {
	[string]$l = $line;
	$direction = $l[0]
	
	$dist = [int]($l[1..$l.length] -join "");

	# write-host "direction $direction"
	# write-host "distance from current $dist"

	# past 99 starts over at 0
	# past 0 starts over at 99
	switch ($direction) {
		"L" { 
			# toward lower numbers
			$dial -= $dist;
			while ($dial -lt 0) {
				$dial += 100;
			}
		}
		"R" { 
			# toward higher numbers
			$dial = ($dial + $dist) % 100
		}
	}

	# write-host "dial now $dial"

	if ($dial -eq 0) {
		$timescrossedzerogoingleft++;
	}

	$prevdirection = $direction

}

# 24 was wrong!!
# 19 was wrong!!
# 583 is too low

write-host "part 1 $timescrossedzerogoingleft";
