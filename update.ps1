$env:CORONA = 'D:\Users\jan\Documents\corona\Corona'
cd $env:CORONA

if (-not (Test-Path "archive_ard")) { new-item -Name "archive_ard" -ItemType directory }
if (-not (Test-Path "archive_v2")) { new-item -Name "archive_v2" -ItemType directory }
if (-not (Test-Path "series")) { new-item -Name "series" -ItemType directory }

pipenv run gsutil rsync -d -r gs://brdata-public-data/rki-corona-archiv/ ard-data
cd $env:CORONA/ard-data/2_parsed
pipenv run python $env:CORONA/convertARD.py -d $env:CORONA/archive_ard/ *.xz

cd $env:CORONA/archive_ard/
pipenv run python $env:CORONA/unify.py -d $env:CORONA/archive_v2 $env:CORONA/archive_ard/NPGEO-RKI-*.csv

cd $env:CORONA
pipenv run python $env:CORONA/database.py -d $env:CORONA/series
