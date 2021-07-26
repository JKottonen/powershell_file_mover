#!/bin/sh
function copyItems() {
    mkdir > $null 'allFiles'
    Write-Output "KOPIOIDAAN"
    Copy-Item -Path '.\*\*' -Destination '.\allFiles'
    Clear-Host
    Write-Output "Kaikki kuvat kopioitu"
}

function iterateItems() {
    Clear-Host
    Write-Output "LAJITELLAAN"
    $filesIterated = 0
    $filesNotDated = 0
    $files = Get-ChildItem ".\allFiles\*"
    foreach ($f in $files){
        $filesIterated += 1
        $outfile = $f.Name

        if($f.Name -match '[0-9]{8}') {
            $dateString = $Matches[0]

            $year = $dateString.SubString(0,4)
            $month = $dateString.SubString(4,2)
            #$day = $dateString.SubString(6,2)
            $month = numberToMonth($month)

            mkdir > $null ".\allFiles\$year" -ErrorAction SilentlyContinue
            mkdir > $null ".\allFiles\$year\$month" -ErrorAction SilentlyContinue
            Move-Item -Path ".\allFiles\$outfile" -Destination ".\allFiles\$year\$month"
        }
        else {
            $filesNotDated += 1
        }
    }
    $filesManaged = $filesIterated - $filesNotDated
    Clear-Host
    Write-Output "$filesIterated tiedostoa käsitelty"
    Write-Output  "$filesManaged tiedostoa lajiteltu"
    Write-Output "$filesNotDated tiedostoa ei löytänyt paikkaansa"
}

function numberToMonth($number) {
    switch ($number) {
        '01' { return "Tammikuu" }
        '02' { return "Helmikuu" }
        '03' { return "Maaliskuu" }
        '04' { return "Huhtikuu" }
        '05' { return "Toukokuu" }
        '06' { return "Kesäkuu" }
        '07' { return "Heinäkuu" }
        '08' { return "Elokuu" }
        '09' { return "Syyskuu" }
        '10' { return "Lokakuu" }
        '11' { return "Marraskuu" }
        '12' { return "Joulukuu"}
        Default { return "Persekuu" }
    }
}

# MAIN
Write-Output 'Aloitetaan tiedostojen kopiointi'
Read-Host -Prompt  'Paina enter'
copyItems
Write-Output 'Aloitetaan kopioitujen tiedostojen lajittelu. Jos tiedostoja on 11 000, saattaa hetki mennä.'
Read-Host -Prompt 'Paina enter'
iterateItems
Read-Host -Prompt 'Paina enter'