#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=arrow_logo.ico
#AutoIt3Wrapper_Res_Comment=Updater
#AutoIt3Wrapper_Res_Description=Updater
#AutoIt3Wrapper_Res_Fileversion=1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=NorthStudio
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Inet.au3>
#include <Crypt.au3>

Global $crypt_password = "visor_vn"
$temp_name = @TempDir & "\" & TimerInit() &".exe"
$hDownload = InetGet("http://arrow.edu.vn/versions/arrow_lastest.exe", $temp_name, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
Do
    Sleep(250)
Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)
RunWait(@ComSpec & " /c taskkill /f /im Arrow.exe /im mvpsys.dll", "", @SW_HIDE)
$error = 0
if FileExists(StorageRead("install_dir") & "\arrow.exe") Then
	if Not FileDelete(StorageRead("install_dir") & "\arrow.exe") Then
		$error = 1
	EndIf
EndIf
if FileExists(@SystemDir & "\mvpsys.dll") Then
	If not FileDelete(@SystemDir & "\mvpsys.dll") Then
		$error = 1
	EndIf
EndIf
If $error = 0 Then
	FileMove($temp_name, StorageRead("install_dir") & "\arrow.exe")
	Run(StorageRead("install_dir") & "\arrow.exe")
EndIf

Func StorageRead($cfname)
	$data = RegRead("HKEY_CURRENT_USER\SOFTWARE\Sentry", _Crypt_EncryptData(String($cfname), $crypt_password, $CALG_AES_256))
	If @error Then
		Return ""
	Else
		Return BinaryToString(_Crypt_DecryptData(String($data), $crypt_password, $CALG_AES_256))
	EndIf
EndFunc   ;==>StorageRead
