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
			#accessible
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
function count_neighbors2() {
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
			-or $newrow -gt $($grid[0].count - 1)`
			-or $newcol -gt $($grid[0].count - 1)) 
		{
			# write-host "continue??"
			continue;	
		}
		if ($grid[$newrow][$newcol].chr -eq "@") 
		{
			# write-host "ornot??"
			$cnt += 1;	
		}
	}

	$cnt
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

# may have to remake the pint class for part 2 if i'm
# needing to modify the original plot of toilet paper rolls

class Point {
	$chr = "."
	$marked = $false

	Point($chr) {
		$this.chr = $chr;
	}

	[string]ToString() { return $this.chr; }

	[void]Mark() {
		$this.marked = $true;
	}
}

$ptgrid = [system.collections.arraylist]@();

function initptgrid($grid) {
	for ($row = 0; $row -lt $grid.length; $row++) {
		$pts = [system.collections.arraylist]@();
		$rowchars = $grid[$row].ToCharArray();
		for ($col = 0; $col -lt $rowchars.length; $col++) {
			$cell = $rowchars[$col];
			$pts.add([Point]::new($cell)) | out-null;
		}
		$ptgrid.add($pts) | out-null;
	}
}

initptgrid($in);

function GetMarked() {
	$cnt = 0;
	
	for ($row = 0; $row -lt $ptgrid.count; $row++) {
		foreach ($pt in $ptgrid[$row]) {
			if ($pt.chr -eq "@" -and $pt.marked) {
				$cnt += 1;
				$pt.chr = ".";
			}
		}
	}

	$cnt
}

$removed = 0;
#part2
function part2($grid) 
{
	do {
		for ($row = 0; $row -lt $grid.count; $row++) {
			for ($col = 0; $col -lt $grid[$row].count; $col++) 
			{
				[Point]$pt = $grid[$row][$col];

				#accessible
				if ($pt.chr -eq "@") 
				{
					$nbrs = count_neighbors2 -grid $grid -rowidx $row -colidx $col;
					# if accessible mark to be removed
					if ($nbrs -lt 4) {
						# mark for removal
						$removed += 1;
						$grid[$row][$col].Mark()
					}
				}
			}
		}
	} while($(GetMarked -eq 0));

	write-host $removed
}

#8484 first try woohoo!!
part2($ptgrid);


