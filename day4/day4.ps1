param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$answer1 = "";
$answer2 = ""; 

$in = get-content $(join-path `
	$psscriptroot `
	$file)


# 35 is wrong!!!!!@!!
# 139 is too low!!!!!!!!! 
# someone elses answer somehow?????
# 1460 is too whatever!!!!!!!!! wrong!
# 1467 phew..

$directions = @(
    #  row, col
	@( 1, 0), # up
	@(-1, 0), # down
	@( 0,-1), # left
	@( 0, 1), # right

	# diag
	@( 1, 1), # upright
	@( 1,-1), # upleft
	@(-1, 1), # downright
	@(-1,-1)  # downleft
);

[int64]$total = 0;
#part1...take2
function part1($grid) {
	for ($row = 0; $row -lt $grid.length; $row++) {
		$rowchars = $grid[$row].ToCharArray();
		for ($col = 0; $col -lt $rowchars.length; $col++) {
			$cell = $rowchars[$col];
			if ($cell -eq "@") {
				$nbrs = count_neighbors -grid $grid -rowidx $row -colidx $col;
				# write-host $nbrs
				if ($nbrs -lt 4) {
					$total += 1;
				}
			}
		}
	}
	write-host $total
}

function count_neighbors() {
	param(
		$grid,
		[int]$rowidx,
		[int]$colidx
	)

	$cnt = 0;
	foreach ($dir in $directions) {
		$newrow = $dir[0] + $rowidx;
		$newcol = $dir[1] + $colidx;
		# write-host "newrow $newrow"
		# write-host "newcol $newcol"
		if ($newrow -lt 0 -or $newcol -lt 0 `
			-or $newrow -gt $($grid[0].ToCharArray().length - 1)`
			-or $newcol -gt $($grid[0].ToCharArray().length - 1)) 
		{
			# write-host "continue??"
			continue;	
		}
		if ($grid[$newrow][$newcol] -eq "@") 
		{
			# write-host "ornot??"
			$cnt += 1;	
		}
	}

	$cnt
}

part1($in);

#part2
foreach($line in $in) {
}

write-host "answer2: $answer2"

