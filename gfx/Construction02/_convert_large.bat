@ECHO OFF

FOR %%f IN (%~dp0\*.png) DO (
echo Converting: %%f
python ".\ticpanel.py" "%%f"
)
