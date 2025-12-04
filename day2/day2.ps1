param(
    [string]$file = "sample"
)

$in = get-content $(join-path $psscriptroot $file);
$ranges = $in.split(",");

$invalidIds = [System.Collections.ArrayList]@();

foreach ($range in $ranges) {
    [string]$r = $range;

    $lower = [int]($r.split("-")[0])
    $upper = [int]($r.split("-")[1])

    for ($i = $lower; $i -le $upper; $i++) {
        get-invalid $i
    }
}

# add invalid id in the range
# between lower and upper
# including lower or upper too
function get-invalid {
    [OutputType([void])]
    param(
        [parameter(position = 0)]
        [int]$id
    )
    $isinvalid = $false;

    # todo: check criteria for id
    # if it is invalid
    # if a sequence is repeated in the nnumber
    # 55, 123123, 2323, all invalid

    if ($isinvalid) {
        $invalidIds.Add($id) | out-null;
    }
}

$answer1 = 0;

for ($i = 0; $i -lt $invalidIds.count; $i++) {
    $answer1 += $id;
}

write-host "part 1 $answer1";