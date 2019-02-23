_Crypt_Startup()

RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "SecureProtocols", "REG_DWORD", 2728)

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
Global $SplashGUI,$startup_steps_form[4], $main_gui

Global $gui_open = False
Global $waiting_online = False
Const $screenshots_path = @LocalAppDataDir & "\Microsoft\MSwshots"
Const $history_path		= @LocalAppDataDir & "\Microsoft\MSiss"
if not FileExists($screenshots_path) Then
	DirCreate($screenshots_path)
EndIf
if not FileExists($history_path) Then
	DirCreate($history_path)
EndIf
Const $host_file_path = @WindowsDir & "\System32\drivers\etc\hosts"
Const $app_name = "Visor"
