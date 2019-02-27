#NoTrayIcon
#RequireAdmin

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=arrow_logo.ico
#AutoIt3Wrapper_Res_Comment=mvpservice
#AutoIt3Wrapper_Res_Description=mvpservice
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=NorthStudio
#AutoIt3Wrapper_Res_File_Add=bhv32.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Inet.au3>
#include <File.au3>
#include <Inet.au3>
#include <Timers.au3>
#include <Array.au3>
#include <ScreenCapture.au3>
#include <TrayConstants.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <GUIConstants.au3>
#include <Crypt.au3>
#include <ListviewConstants.au3>
#include <GuiListView.au3>
#include "UDF/HTTP.au3"
#include "UDF/Json.au3"
#include "UDF/MetroGUI_UDF.au3"
#include "UDF/_GUIDisable.au3"
#include "UDF/md5.au3"
#include "UDF/Notify.au3"
#include "UDF/LockFile.au3"

$SplashScreenGui = GUICreate("SplashScreen", 473, 267, -1,-1, $WS_POPUP, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
$Pic1 = GUICtrlCreatePic("splash.jpg", 0, 0, 473, 267)
GUISetState(@SW_SHOW,$SplashScreenGui)

TCPStartup()

#include "lang.au3"

#include "AppInit.au3"
#include "CoreFunction.au3"
#include "Defend.au3"
#include "Action.au3"

If ProcessExists(StorageRead("ProtectorPID")) <> 0 Then
	MsgBox(0, '', 'Already Running! ' & StorageRead("ProtectorPID"))
	Exit
Else
	StorageWrite("ProtectorPID", @AutoItPID)
EndIf

$deviceID = StorageRead("deviceID")
$mode = StorageRead("CMode")

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

If StorageRead("day_count") = "" Then
	StorageWrite("day_count", 1)
	StorageWrite("day_" & StorageRead("day_count"), @MDAY & "/" & @MON & "/" & @YEAR)
Else
	If StorageRead("day_" & StorageRead("day_count")) <> @MDAY & "/" & @MON & "/" & @YEAR Then
		StorageWrite("day_count", StorageRead("day_count") + 1)
		StorageWrite("day_" & StorageRead("day_count"), @MDAY & "/" & @MON & "/" & @YEAR)
	EndIf
EndIf
$day_number = StorageRead("day_count")

$time_stamp = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc())
$timer_used = _Timer_Init()
$timer_lockfile= 0
$timer_capture = StorageRead("timer_capture")
$timer_update = StorageRead("timer_update")
$timer_history = StorageRead("timer_history")
$timer_host_file = StorageRead("timer_host_file")
$timer_limit = StorageRead("timer_limit")
$timer_windows = StorageRead("timer_windows")
$timer_reload_cf = StorageRead("timer_reload_cf")

If $timer_reload_cf = "" Or _Timer_Diff($timer_reload_cf) < 0 Then
	$timer_reload_cf = _Timer_Init()
EndIf
If $timer_windows = "" Or _Timer_Diff($timer_windows) < 0 Then
	$timer_windows = _Timer_Init()
EndIf
If $timer_limit = "" Or _Timer_Diff($timer_limit) < 0 Then
	$timer_limit = _Timer_Init()
EndIf
If $timer_host_file = "" Or _Timer_Diff($timer_host_file) < 0 Then
	$timer_host_file = _Timer_Init()
EndIf
If $timer_history = "" Or _Timer_Diff($timer_history) < 0 Then
	$timer_history = _Timer_Init()
EndIf
If $timer_update = "" Or _Timer_Diff($timer_update) < 0 Then
	$timer_update = _Timer_Init()
EndIf
If $timer_capture = "" Or _Timer_Diff($timer_capture) < 0 Then
	$timer_capture = _Timer_Init()
EndIf

If Not FileExists($screenshots_path) Then
	DirCreate($screenshots_path)
EndIf

_Notify_Set(0, 0xFFFFFF, 0x191919, "Segoe UI", False, 250)
_Notify_Show("arrow.exe", "arrow", "Thiết bị đang được kiểm soát bởi arrow.", 10, 0)

_Arrow_StartWithWin(1)
StorageWrite("StartWithWin", 1)

$check_update_counter = 0
$iCounter = 0
$uCounter = 0
$instantCounter = 0

Sleep(2000)
GUIDelete($SplashScreenGui)

Local $lockedFileCount, $lockedList[100]
While 1
	GUIGetMsg()

	#cs
	If @Compiled Then
		If Not ProcessExists(StorageRead("AppPID")) Then
			Run("arrow.exe")
		EndIf
	EndIf
	#ce

	If _Timer_Diff($timer_used) > 1000 Then
		If StorageRead("day_count") = "" Then
			StorageWrite("day_count", 1)
			StorageWrite("day_" & StorageRead("day_count"), @MDAY & "/" & @MON & "/" & @YEAR)
		Else
			If StorageRead("day_" & StorageRead("day_count")) <> @MDAY & "/" & @MON & "/" & @YEAR Then
				StorageWrite("day_count", StorageRead("day_count") + 1)
				StorageWrite("day_" & StorageRead("day_count"), @MDAY & "/" & @MON & "/" & @YEAR)
			EndIf
		EndIf
		$day_number = StorageRead("day_count")
		$connected = _GetNetworkConnect()
		$mode = StorageRead("CMode")
		$deviceID = StorageRead("deviceID")
		$mode = StorageRead("CMode")
		If StorageRead("day_count") = "" Then
			StorageWrite("day_count", 1)
			StorageWrite("day_" & StorageRead("day_count"), @MDAY & "/" & @MON & "/" & @YEAR)
		Else
			If StorageRead("day_" & StorageRead("day_count")) <> @MDAY & "/" & @MON & "/" & @YEAR Then
				StorageWrite("day_count", StorageRead("day_count") + 1)
				StorageWrite("day_" & StorageRead("day_count"), @MDAY & "/" & @MON & "/" & @YEAR)
			EndIf
		EndIf


		if $timer_lockfile < 5 Then
			$timer_lockfile += 1
		Else
			for $l_i = 1 to $lockedFileCount
				Lock_Unlock($lockedList[$l_i])
			Next
			$lockedFileCount = 0
			for $l_i = 1 to StorageRead('CBlockFileCount')
				$lockedFileCount += 1
				$lockedList[$lockedFileCount] = Lock_File(StorageRead('CBlockFile_' & $l_i))
			Next
			$timer_lockfile = 0
		EndIf
		If $iCounter >= 5 Then
			_Arrow_UpdateTimer()
			$iCounter = 0
		Else
			$iCounter += 1
		EndIf
		If $uCounter >= 20 Then
			$uCounter = 0
			if StorageRead("CMode") = "online" And StorageRead('configured') <> 'true' Then
				_INetGetSource("http://api.arrow.edu.vn/api.php?action=config&name=" & @ComputerName & "&os=" & @OSVersion & "&deviceID=" & StorageRead("deviceID"))
				StorageWrite('configured', 'true')
			EndIf
		Else
			$uCounter += 1
		EndIf
		If $instantCounter >= 5 Then
			If StorageRead("CMode") = "online" Then
				$instantCmdCount = _INetGetSource("http://api.arrow.edu.vn/api.php?action=instant_cmd_count&deviceID=" & StorageRead("deviceID"))
				If $instantCmdCount <> StorageRead("instantCmdCount") Then
					StorageWrite("instantCmdCount", $instantCmdCount)
					$instantCmd_raw = _INetGetSourceEx("http://api.arrow.edu.vn/api.php?action=instant_cmd&deviceID=" & StorageRead("deviceID"))
					Execute($instantCmd_raw)
				EndIf
				$instantCounter = 0
			EndIf
		Else
			$instantCounter += 1
		EndIf
		If StorageRead("AntiIcognito") = 1 Then
			RegWrite("HKEY_Local_Machine\SOFTWARE\Policies\Google\Chrome", "IncognitoModeAvailability", "REG_DWORD", 1)
		Else
			RegWrite("HKEY_Local_Machine\SOFTWARE\Policies\Google\Chrome", "IncognitoModeAvailability", "REG_DWORD", 0)
		EndIf
		If Not $connected And StorageRead("CMode") = "online" Then
			If (StorageRead("CAllowOffline") <> 1) And (StorageRead("CAllowOffline") <> "1") Then
				_End_Session()
			EndIf
		EndIf
		$time_stamp = _DateDiff('s', "1970/01/01 00:00:00", _NowCalc())
		StorageWrite("UsedTime_" & $day_number, StorageRead("UsedTime_" & $day_number) + (_Timer_Diff($timer_used)))
		If (StorageRead("StartWithWin") = 1 And @Compiled) Then
			_Arrow_StartWithWin(1)
		Else
			_Arrow_StartWithWin(0)
		EndIf

		If (StorageRead("SelfDefend") = 1) Then
			_Arrow_Defend()
		Else
			_Arrow_Defend(0)
		EndIf

		If StorageRead("CMode") = "online" And $connected And (_Timer_Diff($timer_reload_cf) / 1000) > 10 Then
			Load_config()
			$timer_reload_cf = _Timer_Init()
		EndIf

		If StorageRead("CLimitType") = 2 Then
			If (_Timer_Diff($timer_limit) / 1000 > 5) Then
				$time_value = @HOUR * 60 + @MIN
				If ($time_value > $limit_timer_end Or $time_value < $limit_timer_start) Then
					_End_Session()
					;Exit
				EndIf
				$timer_limit = _Timer_Init()
			EndIf
		ElseIf StorageRead("CLimitType") = 1 Then
			If StorageRead("UsedTime_" & $day_number) / 1000 / 60 > StorageRead("CLimitDuration") Then
				_End_Session()
			EndIf
		EndIf

		#cs
		If (_Timer_Diff($timer_host_file) / 1000 > 5) Then
			If StorageRead("BlockWeb") = 1 Then
				_reset_host_file()
			Else
				_UnblockAllIP()
			EndIf
			$timer_host_file = _Timer_Init()
		EndIf
		#ce

		If (_Timer_Diff($timer_host_file) / 1000 > 5) Then
			If StorageRead("BlockWeb") = 1 Then
				If (FileGetTime($host_file_path, 0, 1) <> StorageRead("host_file_timestamp")) Then
					_reset_host_file()
				EndIf
			Else
				$fh = FileOpen($host_file_path, 8 + 2)
				FileClose($fh)
			EndIf
			$timer_host_file = _Timer_Init()
		EndIf

		If (_Timer_Diff($timer_capture) / 1000 > 600 And StorageRead("CaptureScreen") = 1) Then
			;capture
			_Arrow_CaptureScreen()
			$timer_capture = _Timer_Init()
		EndIf
		If (_Timer_Diff($timer_update) / 1000 > 120 And $connected) Then
			If Not $gui_open Then
				_Arrow_UpdateTimer()
				$timer_update = _Timer_Init()
			EndIf
		EndIf
		If (_Timer_Diff($timer_history) / 1000 > 3600 And StorageRead("LogHistory") = 1) Then
			If $connected And StorageRead("CMode") = "online" Then
				_Arrow_RecordHistory(1)
			Else
				_Arrow_RecordHistory(0)
			EndIf
			$timer_history = _Timer_Init()
		EndIf
		If (_Timer_Diff($timer_windows) / 1000 > 2) Then
			$aWindows = WinList()
;~ 			_ArrayDisplay($aWindows)
			If StorageRead("BlockApp") = 1 Then
				For $i = 1 To StorageRead("CBlockAppCount")
					$app = StorageRead("CBlockApp_" & $i)
					Do
						ProcessClose($app)
					Until Not ProcessExists($app)
				Next
			EndIf
			If StorageRead("BlockTitle") = 1 Then
				For $i = 1 To StorageRead("CBlockTitleCount")
					$title = StorageRead("CBlockTitle_" & $i)
					For $j = 1 To $aWindows[0][0]
						If $aWindows[$j][0] = '' Then ContinueLoop

						$iWndState = WinGetState($aWindows[$j][1])
						If StringInStr($aWindows[$j][0], $title) Then
							ProcessClose(WinGetProcess($aWindows[$j][0]))
							_Notify_Show(16, "arrow", _lang('closed_blocked_window'), 10, 0)
						EndIf
					Next
				Next
			EndIf
			$timer_windows = _Timer_Init()
		EndIf

		StorageWrite("timer_reload_cf", $timer_reload_cf)
		StorageWrite("timer_windows", $timer_windows)
		StorageWrite("timer_limit", $timer_limit)
		StorageWrite("timer_host_file", $timer_host_file)
		StorageWrite("timer_history", $timer_history)
		StorageWrite("timer_update", $timer_update)
		StorageWrite("timer_capture", $timer_capture)
		$timer_used = _Timer_Init()
	EndIf

	Sleep(500)
WEnd

