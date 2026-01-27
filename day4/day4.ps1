param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$answer1 = "";
$answer2 = ""; 

$in = get-content $(join-path `
	$psscriptroot `
	$file)

$directions = @(
    #  y, x
	@( 1, 0), # up
	@(-1, 0), # down
	@( 0,-1), # left
	@( 0, 1), # right

	# diag
	@( 1, 1), # upright
	@( 1,-1), # upleft
	@(-1, 1), # downright
	@(-1,-1)  # downleft
)

$floor = [system.collections.arraylist]@();

for ($i = 0; $i -lt $in.length; $i++) {
	$temp = [system.collections.arraylist]@();
	$floor.add($temp) | out-null;
}

$tp_count = 0;

class Point {
	$x = 0;
	$y = 0;
	$tp_sym = "@";
	$sym   = "."
	$marked = $false

	Point($sym, $y, $x) {
		$this.x = $x;
		$this.y = $y;
		$this.sym = $sym;
	}

	[bool]CheckDir($dir, $floor) {

		$movey = $dir[0] + $this.y;
		$movex = $dir[1] + $this.x;

		$is_tp = $false;

		# may go OOB! and powershell can negative index lists
		# so what may seem out of bounds is just wrapped around
		if ($movey -lt $floor.count `
			-and $movey -ge 0 `
			-and $movex -lt $floor[0].count `
			-and $movex -ge 0
		) {
			if ($floor[$movey][$movex].sym -eq $this.tp_sym) {
				$is_tp = $true;
			}
		}

		return $is_tp;
	}

	# if fewer than 4 toilet paper nbors mark the point
	[void]CheckNbors($floor, $directions) {
		$cnt = 0;
		if ($this.sym -eq $this.tp_sym) {
			foreach ($dir in $directions) {
				$istp = $this.CheckDir($dir, $floor);
				if ($istp) {
					$cnt += 1;
				}
			}
		}
		if ($cnt -gt 0 -and $cnt -lt 4) {
			$this.marked = $true;
		}
	}
}

#part1

# parse in the points from file
for ($y = 0; $y -lt $in.length; $y++) 
{
	$pts = [system.collections.arraylist]@();

	$charrarr = $in[$y].ToCharArray();
	for ($x = 0; $x -lt $charrarr.length; $x++) 
	{
		$pt = [Point]::new($charrarr[$x], $y, $x);
		$pts.add($pt) | out-null;
	}

	$floor[$y] = $pts;
}

# check nbors
for ($y = 0; $y -lt $floor.count; $y++) 
{
	for ($x = 0; $x -lt $floor[0].count; $x++) 
	{
		$pt = $floor[$y][$x];
		$floor[$y][$x].CheckNbors($floor, $directions);
	}
}

# count tp marked as accessible
for ($y = 0; $y -lt $floor[0].count; $y++) 
{
	for ($x = 0; $x -lt $floor[0].count; $x++) 
	{
		$pt = $floor[$y][$x];
		if ($pt.marked) { 
			$tp_count += 1;
		}
	}
}

for ($y = 0; $y -lt $floor.count; $y++) {
	for ($x = 0; $x -lt $floor[$y].count; $x++) {
		$pt = $floor[$y][$x];
		write-host "$(if ($pt.marked) {
				"x"
			} else {
				$pt.sym
			})" -nonewline
	}

	write-host ""
}

write-host "$($floor.count)";
write-host "$($floor[0].count)";


$answer1 = $tp_count;
# 35 is wrong!!!!!@!!
# 139 is too low!!!!!!!!! 
# someone elses answer somehow?????
# 1460 is too whatever!!!!!!!!! wrong!
write-host "$answer1"

#part2
foreach($line in $in) {
}

write-host "answer2: $answer2"

