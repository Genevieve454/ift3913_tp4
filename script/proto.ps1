Clear-Host

# for file generation
$date = Get-Date -Format "dd/MM/yyyy_hh_mm_ss"

$gitUrl = "https://github.com/jfree/jfreechart"
$csvOutput = "output_$date.csv"

mkdir repo
Set-Location repo
git clone $gitUrl
Set-Location 'jfreechart'

# va chercher la liste des versions dans l'historique
$id_version = git rev-list master

$data = @()

For ($i=0; $i -lt $id_version.Length; $i++) {

  $item = New-Object PSObject
  $item | Add-Member -type NoteProperty -Name "id_version" -Value $id_version[$i]

  git reset --hard $item.id_version --quiet

  $item | Add-Member -type NoteProperty -Name "NC" -Value ((Get-ChildItem -Recurse -File | Group-Object Extension -NoElement  | Sort-Object Count -Descending | Where-Object {$_.Name -eq '.java'}).Count)

  Write-Output $item
  Write-Output "$i/$($id_version.Length)"
  $data += $item
}

$data | Export-Csv -Path "..\..\$csvOutput" -NoTypeInformation