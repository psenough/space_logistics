@echo OFF

cd /d "%~dp0"

start ticbuild build

"..\tic80_bin\tic80-v1.0-win-pro\tic80.exe" ".\build\release-bin\space_logistics.tic" 

REM python ./assemble_chunks.py

REM "..\tic80_bin\tic80-v1.0-win-pro\tic80.exe" space_logistics.tic 