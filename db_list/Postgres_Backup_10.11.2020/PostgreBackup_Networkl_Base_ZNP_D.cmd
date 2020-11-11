@ECHO OFF

setlocal

rem ��������� ���������� ����������� ����

SET VPGBIN=C:\Program Files\PostgreSQL\9.5\bin

set VPGHOST=localhost
set VPGPORT=5432
set VPGUSER=postgres

rem -----����� �������� ������ ���������� ������

rem set PGPASSWORD=napusoVelbom3!
set VPGPASSWORD=no-password
set VPGFORMAT=custom
rem ��� ���� ��� ������� �������� ��������� �����
set NAMEBASE=ZNP_D
rem ��� ����� ������ � ������� �������� ��������� �����
set NAMEFILE=%NAMEBASE%_

rem ��������� ���������� �������� ���������

set VBACKUP_RESURS=\\1408\backup
set VCATALOG_BACKUP=Postgres_Test
set VDISK=r:
set NAME_USER=admgko
set PASSWORD_USER=K!123456

rem �������� ����������� � �������� �������, ������� ������ ������ ���� ������ ����������� ��� ������� ���� R
dir %VDISK%
if not %ERRORLEVEL%==0 net use %VDISK% %VBACKUP_RESURS% /user:%NAME_USER% %PASSWORD_USER%
if not %ERRORLEVEL%==0 goto UPS1
set VDISK=%VDISK%\
cd /d %VDISK%

rem ���� �� ������� ��� �������� ��� ���������� ����������� - ��� �������
if not exist %VCATALOG_BACKUP% md %VCATALOG_BACKUP%
set VCATALOG_BACKUP=%VDISK%%VCATALOG_BACKUP%
cd %VCATALOG_BACKUP%

rem ������� � ������� ������ (VCATALOG_BACKUP) �������� ������� ����� ��������������� ���� � ������

rem �������� � ������������ ����� ���
set SLASH=\
set VYEAR=%date:~-4%
set VCATYEAR=%VCATALOG_BACKUP%%SLASH%%VYEAR%
if not exist %VCATYEAR% md %VCATYEAR%
cd %VCATYEAR%

rem �������� � ������������ ����� ����� � ����� ���
set SLASH=\
set VMONTH=%date:~-7%
set VMONTH2=%VMONTH:~0,2%
if not exist %VMONTH2% md %VMONTH2%
set VCATMONTH=%VCATYEAR%%SLASH%%VMONTH2%
cd %VCATMONTH%

rem ������������ ����� ����� ������ � ��������� � ���� � �������
set VDATE=%date:~-10%
set VTIME=%time:~0,-3%
set VTIME=%VTIME::=.%
set VTIME=%VTIME: =%
set TYPEFILE=.backup
set VNAMEFILE=%NAMEFILE%%VDATE%_%VTIME%%TYPEFILE%

rem �������� ������� ����� ����� ������
set VNAMEFILE=%VCATMONTH%%SLASH%%VNAMEFILE%

rem �������� ����� ���-����� � ��������� � ���� � �������
set LOGNAME=backuplog_
set LOGTYPE=.txt
set LOGNAME=%LOGNAME%%VDATE%_%VTIME%%LOGTYPE%
rem �������� ������� ����� ���-�����
set LOGNAME=%VCATMONTH%%SLASH%%LOGNAME%

echo --------------------------- begin copy base
rem ����������� ����
call "%VPGBIN%\pg_dump.exe" --host %VPGHOST% --port %VPGPORT% --username "%VPGUSER%" --%VPGPASSWORD% --format %VPGFORMAT% --blobs --verbose --file "%VNAMEFILE%" "%NAMEBASE%"  2>%LOGNAME%

rem ������ ���� ����������, � ������ ������ �������� ����� � ����� ������ � �������� ������������ �����
IF NOT %ERRORLEVEL%==0 GOTO ErrorBackup
GOTO OkBackup
:ErrorBackup
set ERROR_TEXT=%ERRORLEVEL%
rem �������� ����� ����� � ����� ������ � ��������� � ���� � �������
set ERRORNAME=errorcode_
set ERRORTYPE=.txt
set ERRTXT=%ERRORNAME%%VDATE%_%VTIME%%ERRORTYPE%
rem �������� ������� ����� ����� � ����� ������
set ERRTXT=%VCATMONTH%%SLASH%%ERRTXT%
echo %EERROR_TEXT% > %ERRTXT%
del %VNAMEFILE%
:OkBackup

goto NORMAL
:UPS1
echo ----Nedostupen setevoy resurs
set NAME_ERROR_FILE=C:\Users\%NAME_USER%\Desktop\OSHIBKA kopirovaniya basy.txt
echo %date% %time% ---Nedostupen setevoy resurs >> %NAME_ERROR_FILE%
goto NORMAL


:NORMAL
endlocal
@echo on
timeout /T 160

