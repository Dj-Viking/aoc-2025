param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$in = get-content $(join-path `
	$psscriptroot `
	$file)

#part1
# 

# all rows have same amount of numbers for the input (1000)
for ($i = 0; $i -lt $in.length;$i++) {
	# write-host $in[$i]
	# write-host $($in[$i].split(" ", [stringsplitoptions]::removeemptyentries).length)
}

$rows = 0;

# always 5 rows for input
if ($file -eq "input") {
	$rows = 5;
}

# always 4 rows for sample
if ($file -eq "sample") {
	$rows = 4;
}

$cols = [system.collections.arraylist]@();

$len = $($in[0].split(" ", [stringsplitoptions]::removeemptyentries).length);
for ($l = 0; $l -lt $len; $l++) 
{
	$temp = [system.collections.arraylist]@();
	for ($r = 0; $r -lt $rows; $r++) {
		# write-host "$($in[$r].length)";

		# write-host "r: $r - l: $l - len: $len"

		$item = $($in[$r].split(" ",[stringsplitoptions]::removeemptyentries)[$l]);
		# write-host "$($in[$r].length)";
		$temp.add($($item)) | out-null;
		# write-host $temp
		# read-host "press enter"
	}
	$cols.add($temp) | out-null;
}
$sum = 0;
foreach ($col in $cols) {
	# write-host "len: $($col.count) -> col: $col"
	$op   = $col[$col.count - 1];
	$nums = $col[0..$($col.count - 2)];

	[int64]$acc = [int64]($nums[0]);
	for ($n=1;$n -lt $nums.length;$n++) {
		# write-host "operating on $nums with $op"
		switch($op) {
			"*"     {$acc *= [int64]($nums[$n])}
			"+"     {$acc += [int64]($nums[$n])}
		}
	}

	# write-host "$sum => $acc";
	$sum += $acc;
}
# 6417093966513 too low!!!
# 6417439773370 yayy! all due to int64 casting! 
write-host "part1: $sum"
# columns have a signed operation for them all
# what is sum of all the column results?

#part2

# now operating on individual columns 
# in right-to-left 
# order
# but also top to bottom of that column of numbers
<#           3  2  1
123|328| 51|(6){4} 
 45|64 |387|(2){3} 
  6|98 |215|(3){1}[4]
*   +   *   +  

first calculation would be [4] + {431} + (623)

need to preserve the spacing for the parsing here now..
there are at most 4 columns for input including spaces

and 3 columns for sample

negative indexing in powershell can be helpful here
to do a reverse lookup of the char array to know 
what number to parse from right to left for each column

#>
# numbers + space delimiter
$colWidth = 0;
if ($file -eq "input") {
	$colWidth = 5;
} else {
	$colWidth = 4;
}

$cols = $null 
$grid = [system.collections.arraylist]@()
for ($r = 0;$r -lt $rows;$r++) {
	$temp = [system.collections.arraylist]@();
	$grid.add($temp) | out-null;
}

for ($r = 0; $r -lt $in.length;$r++) {
	$rowchars = $in[$r].tochararray();
	for ($c = 0; $c -lt $rowchars.length;$c++) {
		$grid[$r].add($rowchars[$c]) | out-null;
	}
}

function dumpgrid {
	write-host "$($($grid.count * $grid[0].count) / $colWidth)"
	$stack = 0;

	for ($loc = $($grid.count * $grid[0].count / $colWidth); 
	     $loc -ge 0;
		 $null) 
	{
		for ($r = 0; $r -lt $grid.count; $r++) 
		{
			$row = "";

			for ($c = 0; $c -lt $grid[0].count; $c++) {
				if ($loc -eq $c -and ($c - $loc) % $colWidth -eq 0) {
					$row += "[$($grid[$r][$loc])]"
				} else {
					$row += $grid[$r][$c]
				}
			}
			write-host "stack $stack - r $r - loc $loc - $row"

		}
		read-host "skjdf";
		$loc--;
		$stack++;
		if ($loc % $colWidth -eq 0) {
			$stack = 0;
		}
	}
}

dumpgrid
# get the signs for each column
# gather the columns together as list of columns
# cols
# @(
#     col
#     @(
#       rows
#       @(
#         # reverse order of section
#         row@(|123 ... ... 123|)
#         row@(|12  ..  ..   23|)
#         row@(|  1  ..  ..  2 |)
#         op,
#       )
#       rows
#       @(...)
#     )
#     col
#     @(...)
# )
#

# read right to left, top to bottom
# by reverse order of the rows
# and reverse order of the column

