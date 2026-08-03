@ECHO OFF

setlocal

cd "C:\Users\Utilizador\AppData\Roaming\com.nesbox.tic\TIC-80\x\ticmctile_v2.4\"

REM dir

REM FOR %%f IN (%~dp0\*.gif) DO (
REM echo Converting: %%f
REM python ".\ticmctile.py" "%%f" -o "%~dp0\%%~nf.lua" -f -m rle -k -s
REM )


FOR %%f IN (%~dp0\*.png) DO (
echo Converting: %%f
python ".\ticmctile.py" "%%f" -o "%~dp0\%%~nf.lua" -f -m rle -s
)

endlocal

python ".\ticpanel.py" "BgDitterExtended.png"

python ".\ticpanel.py" "LogoBackdropExtended.png"
