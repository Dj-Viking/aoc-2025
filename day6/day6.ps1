using namespace System.Collections;
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

$cols = [arraylist]@();

$len = $($in[0].split(" ", [stringsplitoptions]::removeemptyentries).length);
for ($l = 0; $l -lt $len; $l++) 
{
	$temp = [arraylist]@();
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
$colWidth = $(if ($file -eq "input") {
	5
} else {
	4
});

class Section {
	$op = ""
	$digits = [arraylist]@()
	$complete = $false

	[void]Update($num_columns, $rows, $sectioncount) {
		write-host "columns count $($num_columns.count)"

		if ("+" -in $num_columns -or "*" -in $num_columns) {
			$this.op = $($num_columns | ? { $_ -match "\*" -or $_ -match "\+" })[0]
		}

		$nms = $($num_columns | ? { $_ -match "\d" })

		if ($nms.count -eq 1) {
			$nms = $nms.ToString()
		} else {
			$numstr = ""
			for ($i = 0; $i -lt $nms.Length;$i++) 
			{
				$numstr += $nms[$i];
			}
			$nms = $numstr;
		} 
		$this.digits.add([int64]($nms)) | out-null;

		write-host "digits $($this.digits | % { write-host $_})"

		write-host "op $($this.op)"
		write-host "digits [$($this.digits)] len $($this.digits.count)"

		if ($this.digits.Count -eq $($rows - 1) -and $($this.op -eq "*" -or $this.op -eq "+")) {
			$this.complete = $true;
		}
	}

	Section() {}

	static DebugSections($sections) {
		for ($i = 0; $i -lt $sections.list.count;$i++) {
			write-host "section $i oop is $($sections.list[$i].op)"
			write-host "section $i list $($sections.list[$i].digits | % {write-host $_})";
		}
	}
}

$sections = @{
	finished = $false
	list = [arraylist]@()
}
$_grid = [arraylist]@()
for ($r = 0;$r -lt $rows;$r++) {
	$temp = [arraylist]@();
	$_grid.add($temp) | out-null;
}


for ($r = 0; $r -lt $in.length;$r++) {
	$rowchars = $in[$r].tochararray();
	for ($c = 0; $c -lt $rowchars.length;$c++) {
		$_grid[$r].add($rowchars[$c]) | out-null;
	}
}

function part2 {

	:dude while ($true)  {
		if ($sections.finished)  {
			break dude;
		}
		$section = [Section]::new();
		$rowstr = $_grid[0] -join "";
		$rowstrsplit = $rowstr.split(" ", [stringsplitoptions]::removeemptyentries);
		$sectioncount = $rowstrsplit.length;
		read-host "sectioncount $($sectioncount)"
		# not sure how to fix getting it not looping forever....
		# something is wrong here
		:section for ($c = 0; $c -le $sectioncount;$c++) {
			# here might be spaces or the end of the section
			# list
			if ($section.complete) {
				$null = $sections.list.add($section);
				$section = [Section]::new();

				[Section]::DebugSections($sections);
				write-host "$($sections.list.count)";
				# read-host "continue to next section";
				continue section;
			}
			# todo not reaching the end to set sections finished...

			# todo input has 5 items!!!
			# $item0 = $_grid[$_grid.count - 5][$c]
			$item1 = $_grid[$($_grid.count - 4)][$c]
			$item2 = $_grid[$($_grid.count - 3)][$c]
			$item3 = $_grid[$($_grid.count - 2)][$c]
			$item4 = $_grid[$($_grid.count - 1)][$c]
			
			write-host "in the Section "
			write-host "item1 [$item1]"
			write-host "item2 [$item2]"
			write-host "item3 [$item3]"
			write-host "item4 [$item4]"

			write-host "make section"

			# read-host "check section stuff"

			#make up section
			$num_columns = [arraylist]@(
				# todo
				# $item0,
				$item1,
				$item2,
				$item3,
				$item4
			);
			$section.Update($num_columns, $num_columns.count, $sectioncount);
		}

		$rowstr = $_grid[0] -join ""
		$splitrowstr = $rowstr.split(" ", [stringsplitoptions]::removeemptyentries);
		write-host "what is length of row $($_grid[0].count) sectioncount: $($splitrowstr.length) and col width $($colWidth)" # read-host "continue to next section"; $opoffset = 1
		$opoffset = 1;
		if ($sections.list.count -eq $splitrowstr.length){
			$sections.finished = $true;
			# todo
			# read-host "get answer from all sections!";
		}

	}
}

function parsegrid {
	write-host "$($($_grid.count * $_grid[0].count) / $colWidth)"
	$stack = 0;

	for ($loc = $($_grid.count * $_grid[0].count / $colWidth);
	     $loc -ge 0;
		 $null)
	{
		for ($r = 0; $r -lt $_grid.count; $r++) 
		{
			$row = "";
			for ($c = 0; $c -lt $_grid[0].count; $c++) 
			{
				# if all items are empty skip the iteration of collecting the column information
				if ($loc -eq $c -and ($c - $loc) % $colWidth -eq 0) {
					#digit
					if ($r -eq 0) {
						write-host "r is 0 $r - c:$c - item:$($_grid[$r][$c])"
					}
					#digit
					if ($r -eq 1) {
						write-host "r is 1 $r - c:$c - item:$($_grid[$r][$c])"
					}
					#digit
					if ($r -eq 2) {
						write-host "r is 2 $r - c:$c - item:$($_grid[$r][$c])"
					}
					#op
					if ($r -eq 3) {
						write-host "r is 3 $r - c:$c - item:$($_grid[$r][$c])"
					}
					$row += "[$($_grid[$r][$loc])]"
				} else {
					$row += $_grid[$r][$c]
				}
			}
			write-host "stack $stack - r $r - loc $loc - $row"

		}
		$loc--;
		$stack++;
		if ($loc % $colWidth -eq 0) {
			$stack = 0;
		}
	}
}
part2

# NOTE: colwidth assumes each "section" is the same width and in the input it isn't all the same
# some of the sections are 4 columns wide and some are 5, could be either one

# read right to left, top to bottom
# by reverse order of the rows
# and reverse order of the column
# parsegrid

