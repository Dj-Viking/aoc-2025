param(
	[string]$file = "sample"
)

$dial = 50;

$in = get-content -path $(join-path $psscriptroot $file);

$timescrossedzerogoingleft = 0;

foreach ($line in $in) {
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

}

# 24 was wrong!!
# 19 was wrong!!
# 583 is too low

write-host "part 1 $timescrossedzerogoingleft";

$dial = 50;

$timescrossedzero = 0;

# part 2 check every movement tick if we crossed
# zero
foreach ($line in $in) {
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
			for ($i = 0; $i -lt $dist; $i++) {
				$dial -= 1;
				if ($dial -eq 0) {
					$timescrossedzero++;	
				}
				while ($dial -lt 0) {
					$dial += 100;
				}
			}
		}
		"R" { 
			# toward higher numbers
			for ($i = 0; $i -lt $dist; $i++) {
				$dial = ($dial + 1) % 100;
				if ($dial -eq 0) {
					$timescrossedzero++;
				}

			}
		}
	}

	# write-host "dial now $dial"
}


# 2300 is too low
write-host "part 2 $timescrossedzero";