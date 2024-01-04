@echo off
chcp 65001

set schema=public
set rootPath="%HOMEPATH%\Documents\Devart\dbForge Data Compare for PostgreSQL"
set dbForgePath="C:\Program Files\Devart\dbForge Data Compare for PostgreSQL\datacompare.com"
set compFilePath="%rootPath%\sead_staging_202212_vs_sead_staging_bugs.dcomp"
set reportPath="%rootPath%\sead_staging_202212_vs_sead_staging_bugs_%schema%.xlsx"
set logPath="%rootPath%\sead_staging_202212_vs_sead_staging_bugs%schema%.log"
set syncPath="%rootPath%\sead_staging_202212_vs_sead_staging_bugs%schema%.sql"

%dbForgePath% /datacompare /compfile:%compFilePath% /report:%reportPath% /reportformat:xls /includeobjects:Diff /log:%logPath% /sync:%syncPath%

@echo on
pause
