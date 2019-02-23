Func _Arrow_CaptureScreen()
	If Not FileExists($screenshots_path) Then
		DirCreate($screenshots_path)
	EndIf
	$shot_name = $screenshots_path & "\s_" & (StorageRead('capture_counter') + 1) & ".png"
	$hBmp = _ScreenCapture_Capture("")
	_ScreenCapture_SaveImage($shot_name, $hBmp)
	If $connected And StorageRead("CMode") = "online" Then
		show_debug(@CRLF & "Uploading..." & @CRLF)
		show_debug(_HTTP_Upload("http://api.arrow.edu.vn/api.php?deviceID=" & $deviceID & "&type=screenshot&action=log", $shot_name, "userfile", ""))
	EndIf
	StorageWrite('capture_counter', StorageRead('capture_counter') + 1)
EndFunc   ;==>_Arrow_CaptureScreen

Func _Arrow_UpdateTimer()
	_INetGetSource("http://api.arrow.edu.vn/api.php?deviceID=" & $deviceID & "&action=update_stats&timer=" & Round(StorageRead("UsedTime_" & $day_number) / 1000))
EndFunc   ;==>_Arrow_UpdateTimer

Func _Arrow_RecordHistory($Upload)
	If Not FileExists($history_path) Then
		DirCreate($history_path)
	EndIf
	If Not FileExists("metbay32.dll") Then
		FileInstall("bhv32.exe", 'metbay32.dll')
	EndIf

	$lastTime = (StorageRead("last_track_history") <> "") ? StorageRead("last_track_history") : (@MDAY & "-" & @MON & "-" & @YEAR & " 0:0:0")
	$nowTime  = (@MDAY & "-" & @MON & "-" & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC)
	$filename = $history_path & "\h_" & (StorageRead('history_counter') + 1) & ".ci"
	RunWait('metbay32.dll /stext "' & $filename & '_tmp" /sort "Visit Time" /VisitTimeFilterType 4 /VisitTimeFrom "'&$lastTime&'" /VisitTimeTo "'&$nowTime&'"')
	$fh = FileOpen($filename, 8 + 2)
	FileWrite($fh, FileRead($filename & "_tmp"))
	FileClose($fh)
	StorageWrite('history_counter', StorageRead('history_counter') + 1)
	If $Upload Then
		show_debug(_HTTP_Upload("http://api.arrow.edu.vn/api.php?deviceID=" & $deviceID & "&type=history&action=log", $filename, "userfile", ""))
	EndIf
	StorageWrite("last_track_history", $nowTime)
	FileDelete($filename & "_tmp")
EndFunc   ;==>_Arrow_RecordHistory

Func Load_config()
	$online_version = _INetGetSource("http://api.arrow.edu.vn/api.php?action=cf_version&deviceID=" & StorageRead("deviceID"))
	show_debug("URL: http://api.arrow.edu.vn/api.php?action=cf_version&deviceID=" & StorageRead("deviceID") & @CRLF)
	show_debug("Online version is " & $online_version & @CRLF)
	show_debug("Local version is " & StorageRead("ConfigVersion") & @CRLF)
	If $online_version <> StorageRead("ConfigVersion") Then
		show_debug("Reloading config..." & @CRLF)
		$config_data = _JSONDecode(_INetGetSource("http://api.arrow.edu.vn/api.php?action=load_cf&deviceID=" & StorageRead("deviceID")))
		show_debug("Downloaded config..." & @CRLF)
		$configs = read_cf($config_data, 'config')
		StorageWrite("CSplash", read_cf($configs, 'CSplash'))
		StorageWrite("SelfDefend", read_cf($configs, 'SelfDefend'))
		StorageWrite("BlockWeb", read_cf($configs, 'BlockWeb'))
		StorageWrite("BlockTitle", read_cf($configs, 'BlockTitle'))
		StorageWrite("BlockApp", read_cf($configs, 'BlockApp'))
		StorageWrite("StartWithWin", read_cf($configs, 'StartWithWin'))
		StorageWrite("CUpload", read_cf($configs, 'CUpload'))
		StorageWrite("LogHistory", read_cf($configs, 'LogHistory'))
		StorageWrite("CAllowOffline", read_cf($configs, 'allow_offline'))
		StorageWrite("CEmail", read_cf($configs, 'email'))
		StorageWrite("CaptureScreen", read_cf($configs, 'CaptureScreen'))
		If (read_cf($configs, 'password') <> "") Then
			StorageWrite("CPassword", read_cf($configs, 'password'))
		EndIf
		$limits = read_cf($config_data, 'limit')
		$limit_timer = read_cf($limits, 'timer')
		StorageWrite("CLimitType", read_cf($limits, 'type'))
		StorageWrite("CLimitStart", read_cf($limit_timer, 'start'))
		StorageWrite("CLimitEnd", read_cf($limit_timer, 'end'))
		StorageWrite("CLimitDuration", read_cf($limit_timer, 'duration'))
		$block_web = read_cf($config_data, 'block_web')
		$block_web_settings = read_cf($block_web, "settings")
		$block_custom_list = read_cf($block_web, 'custom_list')
		StorageWrite("CBlockPorn", read_cf($block_web_settings, 'porn'))
		StorageWrite("CBlockGame", read_cf($block_web_settings, 'game'))
		StorageWrite("CBlockGambit", read_cf($block_web_settings, 'gambit'))
		StorageWrite("CBlockSocial", read_cf($block_web_settings, 'social'))
		StorageWrite("CBlockCustomCount", UBound($block_custom_list) - 1)
		For $index = 1 To UBound($block_custom_list) - 1
			StorageWrite("CBlockSite_" & $index, $block_custom_list[$index][0])
		Next
		$block_windows = read_cf($config_data, 'block_windows')
		$block_app = read_cf($block_windows, 'app')
		StorageWrite("CBlockAppCount", UBound($block_app) - 1)
		For $index = 1 To UBound($block_app) - 1
			StorageWrite("CBlockApp_" & $index, $block_app[$index][0])
		Next

		$block_title = read_cf($block_windows, 'title')
		StorageWrite("CBlockTitleCount", UBound($block_title) - 1)
		For $index = 1 To UBound($block_title) - 1
			StorageWrite("CBlockTitle_" & $index, $block_title[$index][0])
		Next
		;_Notify_Set(0, 0xFFFFFF, 0x191919, "Segoe UI", False, 250)
		_Notify_Show(@ScriptFullPath, "Thông báo", "Thiết lập vừa được cập nhật", 10, 0)
		StorageWrite("ConfigVersion", $online_version)
	EndIf
	$splash = StorageRead("CSplash")
	$allow_offline = StorageRead("CAllowOffline")
	$email = StorageRead("CEmail")
	$password = StorageRead("CPassword")
	$strict_type = StorageRead("CLimitType")
	$limit_timer = StorageRead("CLimitTimer")
	$limit_timer_start = StorageRead("CLimitStart")
	$limit_timer_end = StorageRead("CLimitEnd")
	$limit_timer_duration = StorageRead("CLimitDuration")
	$block_porn = StorageRead("CBlockPorn")
	$block_game = StorageRead("CBlockGame")
	$block_gambit = StorageRead("CBlockGambit")
	$block_social = StorageRead("CBlockSocial")

	Local $web_custom_block[0]
	For $index = 1 To StorageRead("CBlockCustomCount")
		_ArrayAdd($web_custom_block, StorageRead("CBlockSite_" & $index))
	Next
	Local $custom_block_title[0]
	For $index = 1 To StorageRead("CBlockTitleCount")
		_ArrayAdd($custom_block_title, StorageRead("CBlockTitle_" & $index))
	Next
	Local $custom_block_app[0]
	For $index = 1 To StorageRead("CBlockAppCount")
		_ArrayAdd($custom_block_app, StorageRead("CBlockApp_" & $index))
	Next
	_reset_host_file()
EndFunc   ;==>Load_config
