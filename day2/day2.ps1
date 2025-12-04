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

    # if a sequence is repeated in the nnumber
    # 55, 123123, 2323, all invalid
    $idstr = $id.ToString()

    # kinda slow (shrugs..)
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

# part1
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

#part2
$invalidIds = [System.Collections.ArrayList]@();
$answer2 = 0;

function get-invalid2 {
    [OutputType([void])]
    param(
        [parameter(position = 0)]
        [int64]$id
    )
    $isinvalid = $false;

    # if a sequence is repeated in the nnumber
    # and 11111, or 2222222 (odd length id)
    # 55, 123123, 2323, all invalid
    # 56|56|56 is invalid 6 chars long but 3 repeating patterns
    $idstr = $id.ToString()
    $chrs = $idstr.ToCharArray();
    $hm = @{};

    # note: maybe i can do something with sorting
    # "323232".tochararray() | sort-object

    $firsthalf = $idstr[0..$(($idstr.length / 2) - 1)] -join "";
    $lasthalf = $idstr[$($($idstr.length / 2))..$($idstr.Length - 1)] -join "";

    # even length of id
    if ($idstr.Length % 2 -eq 0 -and $firsthalf -eq $lasthalf) {
        write-host "invalid! $id"
        $isinvalid = $true;
    } 
    # still even length
    # 21|21|21|21|21
    # todo:???? first doesn't equal last half
    elseif ($idstr.Length % 2 -eq 0 -and $firsthalf -ne $lasthalf) {
        foreach ($chr in $chrs) {
            if ($null -eq $hm[$chr]) {
                $hm[$chr] = 1;
            } else {
                $hm[$chr] += 1;
            }

        }    

        write-host "id: $id"
        write-host $hm
    } 
    # odd length of id
    # also length of 9 with different pattern
    # how todo???:
    # 824|824|824
    # they don't have constantly repeating same nums
    elseif ($idstr.Length % 2 -ne 0) {
        $first = $chrs[0];
        if ($idstr -match "$first{$($chrs.Length)}") {
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
        get-invalid2 $i
    }
}

for ($i = 0; $i -lt $invalidIds.count; $i++) {
    $answer2 += $invalidIds[$i];
}

write-host "part2 $answer2"