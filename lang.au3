#Region ;**** Make something awesome ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=lang.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=My Autoit Project..
#AutoIt3Wrapper_Res_Description=AutoitTutorial
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=autoittutorial123@gmail.com
#EndRegion ;**** Make something awesome ****
Func _lang($str)
	$curlang = StorageRead('lang')
	Switch ($str)
		Case 'alert'
			Return $curlang = 'vi' ? 'Thông báo:' : 'Notice'
		Case 'install_success'
			Return $curlang = 'vi' ? "Đã cài đặt thành công!" : "Successfully installed!"
		Case 'error_occured'
			Return $curlang = 'vi' ? "Đã có lỗi xảy ra!" : "Error occured!"
		Case 'error'
			Return $curlang = 'vi' ? "Lỗi" : "Error"
		Case 'startup_error_occured'
			Return $curlang = 'vi' ? "Đã có lỗi khởi động xảy ra!" : "Error occured while software startup!"
		Case 'home'
			Return $curlang = 'vi' ? "Trang chủ" : "Home"
		Case 'analytics'
			Return $curlang = 'vi' ? "Thống kê" : "Analytics"
		Case 'settings'
			Return $curlang = 'vi' ? "Cài đặt" : "Settings"
		Case 'time_strict'
			Return $curlang = 'vi' ? "Giới hạn thời gian" : "Strict Time"
		Case 'monitoring'
			Return $curlang = 'vi' ? "Giám sát sử dụng" : "Monitoring"
		Case 'block_websites'
			Return $curlang = 'vi' ? "Chặn Websites" : "Block Websites"
		Case 'block_apps'
			Return $curlang = 'vi' ? "Chặn Phần mềm" : "Block Applications"
		Case 'block_titles'
			Return $curlang = 'vi' ? "Chặn Tiêu đề" : "Block Titles"
		Case 'about'
			Return $curlang = 'vi' ? "Thông tin" : "About"
		Case 'close'
			Return $curlang = 'vi' ? "Đóng" : "Close"
		Case 'used_today'
			Return $curlang = 'vi' ? "Hôm nay bạn đã sử dụng: " : "Today you have used: "
		Case 'hour'
			Return $curlang = 'vi' ? "giờ" : "hours"
		Case 'minute'
			Return $curlang = 'vi' ? "phút" : "minutes"
		Case 'done'
			Return $curlang = 'vi' ? "Hoàn tất" : "Done"
		Case 'saved_settings'
			Return $curlang = 'vi' ? "Đã lưu thiết lập!" : "Settings has been saved!"
		Case 'allow_time_must_more_than_15_mins'
			Return $curlang = 'vi' ? "Thời gian cho phép sử dụng phải nhiều hơn 15 phút!" : "Time of usage must more than 15 minutes."
		Case 'failed'
			Return $curlang = 'vi' ? "Không thành công" : "Failed"
		Case 'must_have_internet'
			Return $curlang = 'vi' ? "Yêu cầu thiết bị có kết nối mạng để bật chế độ Trực tuyến." : "Computer must have an active Internet Connection to turn on Online mode."
		Case 'deleted_screenshots'
			Return $curlang = 'vi' ? "Đã xóa sạch dữ liệu màn hình!" : "Deleted all saved screenshots."
		Case 'personal_code_input'
			Return $curlang = 'vi' ? "Nhập mã cá nhân" : "Personal Code"
		Case 'personal_code_desc'
			Return $curlang = 'vi' ? "Mã cá nhân giúp xác thực thiết bị với hệ thống. Tuy cập https://arrow.nstudio.pw để lấy mã cá nhân." : "Personal Code help us to recognize your Device in our Network that help you to manage your own Devices. Visit https://arrow.nstudio.pw to take yours."
		Case 'take_code'
			Return $curlang = 'vi' ? "Lấy mã" : "Take Code"
		Case 'cancel'
			Return $curlang = 'vi' ? "Hủy" : "Cancel"
		Case 'done_mode_config'
			Return $curlang = 'vi' ? "Đã thiết lập thành công. Từ bây giờ, bạn có thể chuyển qua chế độ Trực tuyến để điều khiển từ xa." : "Successfully saved. Now you can change to Online mode to use Remote control feature."
		Case 'choose_install_folder'
			Return $curlang = 'vi' ? "Chọn thư mục cài" : "Please choose installation directory"
		Case 'notice'
			Return $curlang = 'vi' ? "Thông báo" : "Notice"
		Case 'input_blocked_site_url'
			Return $curlang = 'vi' ? "Nhập địa chỉ website muốn cấm:" : "Input blocked website's address:"
		Case 'blocked'
			Return $curlang = 'vi' ? "Đã chặn " : "Blocked "
		Case 'input_blocked_app_name'
			Return $curlang = 'vi' ? "Nhập tên ứng dụng muốn cấm. Ví dụ: garena.exe" : "Input blocked application's name. Ex: garena.exe"
		Case 'closed_blocked_window'
			Return $curlang = 'vi' ? "Đã đóng cửa sổ bị cấm" : "Closed blocked window"
		Case 'cleared_browsing_data'
			Return $curlang = 'vi' ? "Đã xóa sạch dữ liệu duyệt web đã lưu!" : "Cleared browsing data."
		Case 'input_block_title'
			Return $curlang = 'vi' ? "Nhập cụm từ của tiêu đề muốn cấm: " : "Input tilte to be blocked: "
		Case 'blocked_title_contain'
			Return $curlang = 'vi' ? "Đã chặn các cửa số có tiêu đề chứa: " : "Blocked windows' title contain: "
		Case 'home_mode_online'
			Return $curlang = 'vi' ? "Chế độ trực tuyến được bật" : "Online mode activated"
		Case 'home_mode_offline'
			Return $curlang = 'vi' ? "Chế độ ngoại tuyến" : "Offline mode"
		Case Else
			Return $str
	EndSwitch
EndFunc   ;==>_lang
