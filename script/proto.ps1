param(
    [string]$gitUrl = "https://github.com/jfree/jfreechart",
    [int]$percentage = 1
)

Clear-Host
Set-Location $PSScriptRoot

# for file generation
$date = Get-Date -Format "dd/MM/yyyy_hh_mm_ss"

$csvOutput = "output_$date.csv"

Remove-Item repo -Force -confirm:$false -Recurse > $quiet
mkdir repo -force > $quiet
Set-Location repo
git clone $gitUrl
Set-Location 'jfreechart'

# va chercher la liste des versions dans l'historique
$id_version = git rev-list master

$data = @()

# Ramdomize a percentage of id_versions to use
$percentage_number = [math]::Round($id_Version.Count * ($percentage/100))
$randomIdList = Get-Random -Count $percentage_number -InputObject (1..$id_version.Count) | Sort-Object

Write-Output "Ramdom sample size: $($randomIdList.Count)"

For ($i=0; $i -lt $randomIdList.Length; $i++) {

  # Colonne pour l'id de révision
  $item = New-Object PSObject
  $item | Add-Member -type NoteProperty -Name "id_version" -Value $id_version[$randomIdList[$i]]

  # Importe la bonne révision
  git reset --hard $item.id_version --quiet

  # Colonne pour le calcul NC
  $item | Add-Member -type NoteProperty -Name "NC" -Value ((Get-ChildItem -Recurse -File | Group-Object Extension -NoElement  | Sort-Object Count -Descending | Where-Object {$_.Name -eq '.java'}).Count)

  # Calcul des métrics, produit le fichier classes.csv
  java -jar .\..\..\tp1-2.jar "..\..\repo"
  $classesResults = Import-csv -path .\classes.csv -delimiter ','

  # Colonne pour le calcul mWMC
  $item | Add-Member -type NoteProperty -Name "mWMC" -Value ($classesResults | Select-Object -expandproperty WMC | Measure-Object -Average).Average

  # Colonne pour le calcul mcBC
  $item | Add-Member -type NoteProperty -Name "mcBC" -Value ($classesResults | Select-Object -expandproperty classe_BC | Measure-Object -Average).Average

  # Log à l'écran pour suivre l'avancement
  Write-Output $item
  Write-Output "$($randomIdList[$i])/$($id_version.Length) (#$i)"

  # Ajout dans la liste analysée
  $data += $item
}

# Export en CSV de l'analyse
$data | Export-Csv -Path "..\..\$csvOutput" -NoTypeInformation