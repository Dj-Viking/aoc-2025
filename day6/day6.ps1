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
#
#part2
