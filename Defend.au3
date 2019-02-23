Func _Arrow_Defend($enable = 1)
	If $enable Then
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "REG_DWORD", 1)
		RegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System", "DisableCMD", "REG_DWORD", 2)
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Control Panel\International", "DisableCMD", "REG_DWORD", 1)
		RegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Control Panel\International", "DisableCMD", "REG_DWORD", 1)
	Else
		RegWrite("HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "REG_DWORD", 0)
		RegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\System", "DisableCMD", "REG_DWORD", 0)
		RegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Control Panel\International", "DisableCMD", "REG_DWORD", 0)
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Control Panel\International", "DisableCMD", "REG_DWORD", 0)
	EndIf
EndFunc   ;==>_Arrow_Defend
