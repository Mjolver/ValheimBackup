@ECHO OFF
SET ScriptDirectory=%~dp0\Script\
SET PowerShellScriptPath=%ScriptDirectory%ValheimBackup.ps1
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& {Start-Process PowerShell -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File ""%PowerShellScriptPath%""' -Verb RunAs}";