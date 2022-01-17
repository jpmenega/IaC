@echo off
cls
rem
echo "--------------------------------------------"
echo "SO.....: %OS%"
echo "Usuario: %USERNAME%"
echo "--------------------------------------------"
rem
echo "Recuperando compartilhamentos...........[OK]"
net use G: /delete /yes
net use G: \\192.168.1.201\ti /persistent:no
net use P: /delete /yes
net use P: \\192.168.1.249\publico /persistent:no
REM net use Q: /delete /yes
REM net use Q: \\192.168.1.201\publico /persistent:no
net use J: /delete /yes
net use J: \\192.168.1.249\fotos /persistent:no
net use w: /delete /yes
net use w: \\192.168.1.201\contmatic /persistent:no
rem net use v: /delete /yes
rem net use v: \\192.168.1.251\sistema\uz\nfe\arquivos\xml-enviado\69004919000150\NFe
net use m: /delete /yes
net use m: \\192.168.1.249\Marketplace /persistent:no
net use r: /delete /yes
net use r: \\192.168.1.249\Rotinas /persistent:no
net use n: /delete /yes
net use n: \\192.168.1.249\NFEs /persistent:no

rem echo "Sincronizando data e hora...............[OK]"
rem net time \\servidor /set /yes
rem echo "Configurando servidor proxy.............[OK]"
rem regedit /s \\servidor\netlogon\proxy_win7.reg
echo "Configuracoes concluidas com sucesso....[OK]"