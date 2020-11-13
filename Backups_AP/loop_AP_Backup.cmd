@echo on
FOR /F %%i  IN (db_list_non_unique.txt) DO PostgreBackup_Networkl_Base_cmd.cmd %%i
endlocal