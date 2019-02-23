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
#include "../UDF/HTTP.au3"
#include "../UDF/Json.au3"
#include "../UDF/MetroGUI_UDF.au3"
#include "../UDF/_GUIDisable.au3"
#include "../UDF/md5.au3"
#include "../UDF/Notify.au3"

_Crypt_Startup()
Global $crypt_password = "visor_vn"
Global $email, $password
Global $strict_type, $strict_start_hour, $strict_end_hour, $strict_end_minute, $strict_start_minute, $strict_duration
Global $web_block, $web_custom_block[0], $web_block_porn, $web_block_game
Global $custom_block_title[0], $custom_block_app[0]
Global $limit_timer, $limit_timer_duration, $limit_timer_start, $limit_timer_end
Global $subgui_list, $btn_clear, $btn_view, $btn_add, $btn_del
Global $subgui_block_gambit_check, $subgui_block_game_check, $subgui_block_porn_check, $subgui_block_social_check
Global $aLines
Global $connected, $deviceID, $day_number, $mode, $gui_capturescreen_check, $gui_mode_toggle
Global $gui_log_his_check, $gui_upload_data_check, $gui_show_splash_check, $gui_run_with_win_check, $gui_block_app_check
Global $gui_block_title_check, $gui_block_web_check, $gui_capturescreen_check, $gui_mode_toggle, $gui_defend_toggle
Global $gui_radio_limit_type1, $gui_radio_limit_type2, $gui_radio_limit_type3
Global $SplashGUI

Global $gui_open = False
Global $waiting_online = False
Const $screenshots_path = @DocumentsCommonDir & "\wshots"
Const $host_file_path = @WindowsDir & "\System32\drivers\etc\hosts"
Const $app_name = "Visor"

_Metro_EnableHighDPIScaling()
_SetTheme("DarkTeal")
$main_gui = _Metro_CreateGUI("Arrow WatcherEyes", 500, 420, -1, -1, False)
;Add/create control buttons to the GUI
$Control_Buttons = _Metro_AddControlButtons(True, True, True, True, True) ;CloseBtn = True, MaximizeBtn = True, MinimizeBtn = True, FullscreenBtn = True, MenuBtn = True
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MAXIMIZE_BUTTON = $Control_Buttons[1]
$GUI_RESTORE_BUTTON = $Control_Buttons[2]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
$GUI_FULLSCREEN_BUTTON = $Control_Buttons[4]
$GUI_FSRestore_BUTTON = $Control_Buttons[5]
$GUI_MENU_BUTTON = $Control_Buttons[6]
$gui_btn_list_blocked_web = _Metro_CreateButton("Web bị cấm", 32, 148, 128, 40)
$gui_btn_list_blocked_web_type = _Metro_CreateButton("Loại web bị cấm", 170, 148, 128, 40)
$gui_btn_list_blocked_app = _Metro_CreateButton("Ứng dụng cấm", 32, 198, 128, 40)
$gui_btn_list_blocked_title = _Metro_CreateButton("Tiêu đề cấm", 170, 198, 128, 40)
$gui_btn_list_screenshots = _Metro_CreateButton("Ảnh chụp màn hình đã lưu", 32, 248, 266, 40)

$gui_defend_toggle = _Metro_CreateToggle("Tự bảo vệ", 330, 66, 240, 30)
$gui_mode_toggle = _Metro_CreateOnOffToggle("Trực tuyến", "Ngoại tuyến", 330, 96, 240, 30)

$gui_capturescreen_check = _Metro_CreateCheckboxEx2("Chụp màn hình", 330, 138, 160, 30)
$gui_block_web_check = _Metro_CreateCheckboxEx2("Chặn web", 330, 168, 120, 30)
$gui_block_title_check = _Metro_CreateCheckboxEx2("Chặn tiêu đề", 330, 198, 140, 30)
$gui_block_app_check = _Metro_CreateCheckboxEx2("Chặn ứng dụng", 330, 228, 160, 30)
$gui_run_with_win_check = _Metro_CreateCheckboxEx2("Tự động bật", 330, 258, 140, 30)
$gui_show_splash_check = _Metro_CreateCheckboxEx2("Hiện cảnh báo", 330, 288, 160, 30)
$gui_upload_data_check = _Metro_CreateCheckboxEx2("Lưu thông tin", 330, 318, 160, 30)
$gui_log_his_check = _Metro_CreateCheckboxEx2("Ghi lịch sử", 330, 348, 160, 30)

$gui_radio_limit_type1 = _Metro_CreateRadioEx("1", "Tắt giới hạn", 32, 300, 220, 30)
$gui_radio_limit_type2 = _Metro_CreateRadioEx("1", "Giới hạn theo thời lượng", 32, 330, 220, 30)
$gui_radio_limit_type3 = _Metro_CreateRadioEx("1", "Giới hạn theo mốc thời gian", 32, 360, 220, 30)

$gui_banner_pic = GUICtrlCreatePic(@TempDir & "\arrow_x_banner.jpg", 32, 32, 274, 96)




