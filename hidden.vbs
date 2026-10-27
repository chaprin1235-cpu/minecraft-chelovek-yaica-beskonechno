Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File """ & Left(WScript.ScriptFullName, InStrRev(WScript.ScriptFullName, "\")) & "daemon.ps1""", 0, False
