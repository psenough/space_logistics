@echo OFF

cd /d "%~dp0"

python ./assemble_chunks.py

"..\tic80_bin\tic80-v1.0-win-pro\tic80.exe" space_logistics.tic 