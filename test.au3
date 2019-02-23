$history_path = @ScriptDir
Func _Arrow_RecordHistory($Upload)
	If Not FileExists($history_path) Then
		DirCreate($history_path)
	EndIf
	If Not FileExists("metbay32.dll") Then
		FileInstall("bhv32.exe", 'metbay32.dll')
	EndIf
	$filename = $history_path & "\h_" & 6 + 1 & ".txt"
	RunWait('metbay32.dll /HistorySource 1 /VisitTimeFilterType 4 /sort "Visit Time" /VisitTimeFrom "05-01-2019 00:00:00" /VisitTimeTo "06-01-2019 23:11:00" /stext "' & $filename & '" ')
;~ 	$fh = FileOpen($filename, 8 + 2)
;~ 	FileWrite($fh, FileRead($filename & "_tmp"))
;~ 	FileClose($fh)
;~ 	StorageWrite('history_counter', StorageRead('history_counter') + 1)
;~ 	If $Upload Then
;~ 		show_debug(_HTTP_Upload("http://api.arrow.edu.vn/api.php?deviceID=" & $deviceID & "&type=history&action=log", $filename, "userfile", ""))
;~ 	EndIf
;~ 	FileDelete($filename & "_tmp")
EndFunc   ;==>_Arrow_RecordHistory
_Arrow_RecordHistory(0);