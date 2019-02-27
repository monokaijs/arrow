Func _FindIP($domain)
	Return TCPNameToIP($domain)
EndFunc   ;==>_FindIP

Func _UnblockAllIP()
	$block_count = RegRead("HKEY_CURRENT_USER\SOFTWARE\Blocker", "BlockCount")
	For $i = 1 To $block_count
		If RegRead("HKEY_CURRENT_USER\SOFTWARE\Blocker", "Block_" & $i) <> "" Then
			Run(@ComSpec & ' /C netsh advfirewall firewall delete rule name="iBlock_' & $i & '"', "", @SW_HIDE)
			RegWrite("HKEY_CURRENT_USER\SOFTWARE\Blocker", "Block_" & $i, "REG_SZ", "")
		EndIf
	Next
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Blocker", "BlockCount", "REG_SZ", 0)
EndFunc   ;==>_UnblockAllIP

Func _BlockWeb($domain, $dir = "out")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Blocker", "BlockCount", "REG_SZ", RegRead("HKEY_CURRENT_USER\SOFTWARE\Blocker", "BlockCount") + 1)
	$block_count = RegRead("HKEY_CURRENT_USER\SOFTWARE\Blocker", "BlockCount")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Blocker", "Block_" & $block_count, "REG_SZ", $domain)
	Return Run(@ComSpec & ' /C netsh advfirewall firewall add rule name="iBlock_' & $block_count & '" interface=any dir=' & $dir & " action=block remoteip=" & _FindIP($domain), "", @SW_HIDE)
EndFunc   ;==>_BlockWeb

Func _UnblockIP($rule_ip)
	Run(@ComSpec & ' /C netsh advfirewall firewall delete rule remoteip="' & $rule_ip & '"', "", @SW_HIDE)
EndFunc   ;==>_UnblockIP

Func __StringEncrypt($i_Encrypt, $s_EncryptText, $s_EncryptPassword, $i_EncryptLevel = 1)
	Local $RET, $sRET = "", $iBinLen, $iHexWords

	; Sanity check of parameters
	If $i_Encrypt <> 0 And $i_Encrypt <> 1 Then
		SetError(1)
		Return ''
	ElseIf $s_EncryptText = '' Or $s_EncryptPassword = '' Then
		SetError(1)
		Return ''
	EndIf
	If Number($i_EncryptLevel) <= 0 Or Int($i_EncryptLevel) <> $i_EncryptLevel Then $i_EncryptLevel = 1

	; Encrypt/Decrypt
	If $i_Encrypt Then
		; Encrypt selected
		$RET = $s_EncryptText
		For $n = 1 To $i_EncryptLevel
			If $n > 1 Then $RET = Binary(Random(0, 2 ^ 31 - 1, 1)) & $RET & Binary(Random(0, 2 ^ 31 - 1, 1)) ; prepend/append random 32bits
			$RET = rc4($s_EncryptPassword, $RET) ; returns binary
		Next

		; Convert to hex string
		$iBinLen = BinaryLen($RET)
		$iHexWords = Int($iBinLen / 4)
		If Mod($iBinLen, 4) Then $iHexWords += 1
		For $n = 1 To $iHexWords
			$sRET &= Hex(BinaryMid($RET, 1 + (4 * ($n - 1)), 4))
		Next
		$RET = $sRET
	Else
		; Decrypt selected
		; Convert input string to primary binary
		$RET = Binary("0x" & $s_EncryptText) ; Convert string to binary

		; Additional passes, if required
		For $n = 1 To $i_EncryptLevel
			If $n > 1 Then
				$iBinLen = BinaryLen($RET)
				$RET = BinaryMid($RET, 5, $iBinLen - 8) ; strip random 32bits from both ends
			EndIf
			$RET = rc4($s_EncryptPassword, $RET)
		Next
		$RET = BinaryToString($RET)
	EndIf

	; Return result
	Return $RET
EndFunc   ;==>__StringEncrypt
Func rc4($key, $value)
	Local $S[256], $i, $j, $c, $t, $x, $y, $output
	Local $keyLength = BinaryLen($key), $valLength = BinaryLen($value)
	For $i = 0 To 255
		$S[$i] = $i
	Next
	For $i = 0 To 255
		$j = Mod($j + $S[$i] + Dec(StringTrimLeft(BinaryMid($key, Mod($i, $keyLength) + 1, 1), 2)), 256)
		$t = $S[$i]
		$S[$i] = $S[$j]
		$S[$j] = $t
	Next
	For $i = 1 To $valLength
		$x = Mod($x + 1, 256)
		$y = Mod($S[$x] + $y, 256)
		$t = $S[$x]
		$S[$x] = $S[$y]
		$S[$y] = $t
		$j = Mod($S[$x] + $S[$y], 256)
		$c = BitXOR(Dec(StringTrimLeft(BinaryMid($value, $i, 1), 2)), $S[$j])
		$output = Binary($output) & Binary('0x' & Hex($c, 2))
	Next
	Return $output
EndFunc   ;==>rc4

Func read_cf($array, $index)
	For $i = 0 To UBound($array) - 1
		If ($array[$i][0] = $index) Then
			Return $array[$i][1]
		EndIf
	Next
EndFunc   ;==>read_cf

Func _GetNetworkConnect()
	If _INetGetSource("http://api.arrow.edu.vn/api.php?action=is_online") = "1" Then
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>_GetNetworkConnect

Func StorageRead($cfname)
	$data = RegRead("HKEY_CURRENT_USER\SOFTWARE\Sentry", $cfname)
	If @error Then
		Return ""
	Else
		;show_debug($cfname & ": " & BinaryToString(_Crypt_DecryptData(String($data), $crypt_password, $CALG_AES_256)) & @CRLF)
		Return $data
	EndIf
;~ 	Return (RegRead("HKEY_CURRENT_USER\SOFTWARE\Sentry", $cfname))
EndFunc   ;==>StorageRead

Func StorageWrite($cfname, $cfvalue)
	;show_debug($cfname & ': ' & $cfvalue & @CRLF)
;~ 	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Sentry", _Base64Encode(String($cfname)), "REG_SZ", _Base64Encode(String($cfvalue)))
;~ 	Return (RegWrite("HKEY_CURRENT_USER\SOFTWARE\Sentry", _Crypt_EncryptData($cfname, $crypt_password, $CALG_AES_256), "REG_SZ", _Crypt_EncryptData($cfvalue, $crypt_password, $CALG_AES_256)))
	Return (RegWrite("HKEY_CURRENT_USER\SOFTWARE\Sentry", $cfname, "REG_SZ", $cfvalue))
EndFunc   ;==>StorageWrite

Func _LockObject($sObj)
	If FileExists($sObj) = 0 Then Return SetError(1, 0, -1)
	RunWait('"' & @ComSpec & '" /c cacls.exe "' & $sObj & '" /E /P "' & @UserName & '":R', '', @SW_HIDE)
EndFunc   ;==>_LockObject

Func _UnlockObject($sObj)
	If FileExists($sObj) = 0 Then Return SetError(1, 0, -1)
	RunWait('"' & @ComSpec & '" /c cacls.exe "' & $sObj & '" /E /P "' & @UserName & '":F', '', @SW_HIDE)
EndFunc   ;==>_UnlockObject

#cs

	Func _reset_host_file()
	_UnblockAllIP()
	For $index = 1 To StorageRead("CBlockCustomCount")
	$site = StorageRead("CBlockSite_" & $index)
	If $site <> "" Then
	_BlockWeb($site)
	EndIf
	Next
	EndFunc   ;==>_reset_host_file

#ce

Func _reset_host_file()
	$fh = FileOpen($host_file_path, 8 + 2)
	For $index = 1 To StorageRead("CBlockCustomCount")
		$site = StorageRead("CBlockSite_" & $index)
		If $site <> "" Then
			FileWriteLine($fh, "127.0.0.1 " & $site)
		EndIf
	Next
	FileClose($fh)
	StorageWrite("host_file_timestamp", FileGetTime($host_file_path, 0, 1))
EndFunc   ;==>_reset_host_file

Func _GUICtrlListView_CreateArray($hListView, $sDelimeter = '|')
	Local $iColumnCount = _GUICtrlListView_GetColumnCount($hListView), $iDim = 0, $iItemCount = _GUICtrlListView_GetItemCount($hListView)
	If $iColumnCount < 3 Then
		$iDim = 3 - $iColumnCount
	EndIf
	If $sDelimeter = Default Then
		$sDelimeter = '|'
	EndIf

	Local $aColumns = 0, $aReturn[$iItemCount + 1][$iColumnCount + $iDim] = [[$iItemCount, $iColumnCount, '']]
	For $i = 0 To $iColumnCount - 1
		$aColumns = _GUICtrlListView_GetColumn($hListView, $i)
		$aReturn[0][2] &= $aColumns[5] & $sDelimeter
	Next
	$aReturn[0][2] = StringTrimRight($aReturn[0][2], StringLen($sDelimeter))

	For $i = 0 To $iItemCount - 1
		For $j = 0 To $iColumnCount - 1
			$aReturn[$i + 1][$j] = _GUICtrlListView_GetItemText($hListView, $i, $j)
		Next
	Next
	Return SetError(Number($aReturn[0][0] = 0), 0, $aReturn)
EndFunc   ;==>_GUICtrlListView_CreateArray

Func Wrong_mode_alert()
	_Metro_MsgBox(16, "Lỗi", "Tính năng không được hỗ trợ trong chế độ Trực tuyến, để thay đổi các thiết lập này vui lòng sử dụng trình điều khiển từ Web hoặc Ứng dụng.")
EndFunc   ;==>Wrong_mode_alert

Func show_debug($diag)
	ConsoleWrite($diag)
EndFunc   ;==>show_debug

Func _Arrow_StartWithWin($enable = 1)
	If (@Compiled) Then
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run", "arrow", "REG_SZ", @ScriptDir & '\arrow.exe')
	EndIf
EndFunc   ;==>_Arrow_StartWithWin

Func _GetSourceAsync($url)
	$sFilePath = @TempDir & "\" & TimerInit() & "_temp.pkg"
	$request = InetGet($url, $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	Do
		Sleep(250)
	Until InetGetInfo($request, $INET_DOWNLOADCOMPLETE)
	$dataReturned = FileRead($sFilePath)
	FileDelete($sFilePath)
	Return ($dataReturned)
EndFunc   ;==>_GetSourceAsync

Func _End_Session()
	If @Compiled Then
		Shutdown(8 + 16)
	Else
		MsgBox(64, 'Het gio', 'het gio')
		Exit
	EndIf
EndFunc   ;==>_End_Session

Func startup_open_step($step)
	For $i = 0 To UBound($startup_steps_form) - 1
		GUISetState(@SW_HIDE, $startup_steps_form[$i])
	Next
	GUISetState(@SW_SHOW, $startup_steps_form[$step])
	GUISwitch($startup_steps_form[$step])
EndFunc   ;==>startup_open_step

Func _OIG_IsFocused($h_Wnd, $i_ControlID) ; Check if a control has focus.
	Return ControlGetHandle($h_Wnd, '', $i_ControlID) = ControlGetHandle($h_Wnd, '', ControlGetFocus($h_Wnd))
EndFunc   ;==>_OIG_IsFocused

Func _INetGetSourceEx($s_URL, $bString = True)
	Local $sString = InetRead($s_URL, 1)
	Local $nError = @error, $nExtended = @extended
	If $bString Then $sString = BinaryToString($sString, 4)
	Return SetError($nError, $nExtended, $sString)
EndFunc   ;==>_INetGetSourceEx
