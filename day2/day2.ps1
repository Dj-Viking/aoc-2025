param(
    [string]$file = "sample"
)

$in = get-content $(join-path $psscriptroot $file);
$ranges = $in.split(",");

$invalidIds = [System.Collections.ArrayList]@();

# add invalid id in the range
# between lower and upper
# including lower or upper too
function get-invalid {
    [OutputType([void])]
    param(
        [parameter(position = 0)]
        [int64]$id
    )
    $isinvalid = $false;

    # todo: check criteria for id
    # if it is invalid
    # if a sequence is repeated in the nnumber
    # 55, 123123, 2323, all invalid
    $idstr = $id.ToString()

    if ($idstr.Length % 2 -eq 0) {
        $firsthalf = $idstr[0..$(($idstr.length / 2) - 1)] -join "";
        $lasthalf = $idstr[$($($idstr.length / 2))..$($idstr.Length - 1)] -join "";
        if ($firsthalf -eq $lasthalf) {
            write-host "invalid! $id"
            $isinvalid = $true;
        }
    } 

    if ($isinvalid) {
        $invalidIds.Add($id) | out-null;
    }
}

foreach ($range in $ranges) {
    [string]$r = $range;

    $lower = [int64]($r.split("-")[0])
    $upper = [int64]($r.split("-")[1])

    for ($i = $lower; $i -le $upper; $i++) {
        get-invalid $i
    }
}


$answer1 = 0;

for ($i = 0; $i -lt $invalidIds.count; $i++) {
    $answer1 += $invalidIds[$i];
}

write-host "part 1 $answer1";