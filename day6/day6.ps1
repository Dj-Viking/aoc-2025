param(
	[parameter(position = 0)]
	[string]$file = "sample"
)

$in = get-content $(join-path `
	$psscriptroot `
	$file)

#part1
# 
write-host $($in.length)

# all rows have same amount of numbers for the input (1000)
# always 5 rows for input
# always 4 rows for sample
# columns have a signed operation for them all
# what is sum of all the column results?
for ($i = 0; $i -lt $in.length;$i++) {
	write-host $($in[$i].split(" ", [stringsplitoptions]::removeemptyentries).length)
}
#part2
