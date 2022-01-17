@echo off

set samba_server=192.168.15.15

if "|%username_override%|" == "||" set username_override=%username%

cd %temp%

goto tryLogin

:repete
timeout 2

:tryLogin

if exist \\%samba_server%\netlogon\%username_override%.cmd goto doLoginNetlogon
if not exist \\%samba_server%\Pessoal\%username_override%.cmd goto repete

\\%samba_server%\Pessoal\%username_override%.cmd
goto :fim

:doLoginNetlogon
\\%samba_server%\netlogon\%username_override%.cmd

:fim
