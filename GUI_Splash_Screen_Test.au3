#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=
$SplashScreenGui = GUICreate("SplashScreen", 473, 267, -1,-1,$WS_POPUP)
$Pic1 = GUICtrlCreatePic("splash.jpg", 0, 0, 473, 267)
GUISetState(@SW_SHOW,$SplashScreenGui)
Sleep(5000)
GUISetState(@SW_HIDE,$SplashScreenGui)

$Form1 = GUICreate("Main Program", 800, 640, -1, -1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
