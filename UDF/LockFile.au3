#include-once

; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w 7
; #INDEX# =======================================================================================================================
; Title .........: Lock_File
; AutoIt Version : v3.3.10.0 or higher
; Language ......: English
; Description ...: Lock a file to the current process only. Any attempts to interact with the file by another process will fail
; Note ..........:
; Author(s) .....: guinness
; Remarks .......: The locked file handle must be closed with the Lock_Unlock() function after use
; ===============================================================================================================================

; #INCLUDES# =========================================================================================================
#include <WinAPI.au3>

; #GLOBAL VARIABLES# =================================================================================================
; None

; #CURRENT# =====================================================================================================================
; Lock_Erase: Erase the contents of a locked file
; Lock_File: Lock a file to the current process only
; Lock_Read: Read data from a locked file
; Lock_Reduce: Reduce the locked file by a certain percentage
; Lock_Write: Write data to a locked file
; Lock_Unlock: Unlock a file so other processes can interact with it
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; None
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: Lock_Erase
; Description ...: Erase the contents of a locked file
; Syntax ........: Lock_Erase($hFile)
; Parameters ....: $hFile               - Handle returned by Lock_File()
; Return values .: Success - True
;                  Failure - False, use _WinAPI_GetLastError() to get additional details
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func Lock_Erase($hFile)
	_WinAPI_SetFilePointer($hFile, $FILE_BEGIN)
	Return _WinAPI_SetEndOfFile($hFile)
EndFunc   ;==>Lock_Erase

; #FUNCTION# ====================================================================================================================
; Name ..........: Lock_File
; Description ...: Lock a file to the current process only
; Syntax ........: Lock_File($sFilePath[, $bCreateNotExist = False])
; Parameters ....: $sFilePath           - Filepath of the file to lock
;                  $bCreateNotExist     - [optional] Create the file if it doesn't exist (True) or don't create (False). Default is False
; Return values .: Success - Handle of the locked file
;                  Failure - Zero and sets @error to non-zero. Call _WinAPI_GetLastError() to get extended error information
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func Lock_File($sFilePath, $bCreateNotExist = False)
	Return _WinAPI_CreateFile($sFilePath, BitOR($CREATE_ALWAYS, (IsBool($bCreateNotExist) And $bCreateNotExist ? $CREATE_NEW : 0)), BitOR($FILE_SHARE_WRITE, $FILE_SHARE_DELETE), 0, 0, 0) ; Creation = 2, Access = 2 + 4, Sharing = 0, Attributes = 0, Security = 0
EndFunc   ;==>Lock_File

; #FUNCTION# ====================================================================================================================
; Name ..........: Lock_Read
; Description ...: Read data from a locked file
; Syntax ........: Lock_Read($hFile)
; Parameters ....: $hFile               - Handle returned by Lock_File()
;                  $iBinaryFlag               - [optional] Flag value to pass to BinaryToString(). Default is $SB_UTF8. See BinaryToString() documentation for more details
; Return values .: Success - Data read from the file
;                  Failure - Empty string and sets @error to non-zero
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func Lock_Read($hFile, $iBinaryFlag = $SB_UTF8)
	Local $iFileSize = _WinAPI_GetFileSizeEx($hFile) + 1, _
			$sText = ''
	Local $tBuffer = DllStructCreate('byte buffer[' & $iFileSize & ']')
	_WinAPI_SetFilePointer($hFile, $FILE_BEGIN)
	_WinAPI_ReadFile($hFile, DllStructGetPtr($tBuffer), $iFileSize, $sText)

	Return SetError(@error, 0, BinaryToString(DllStructGetData($tBuffer, 'buffer'), $iBinaryFlag))
EndFunc   ;==>Lock_Read

; #FUNCTION# ====================================================================================================================
; Name ..........: Lock_Reduce
; Description ...: Reduce the locked file by a certain percentage
; Syntax ........: Lock_Reduce($hFile, $iPercentage)
; Parameters ....: $hFile               - Handle returned by Lock_File()
;                  $iPercentage         - A percentage value to reduce the file by
; Return values .: Success - True
;                  Failure - False. Use _WinAPI_GetLastError() to get additional details
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func Lock_Reduce($hFile, $iPercentage)
	If Not IsInt($iPercentage) Then $iPercentage = Int($iPercentage)
	If $iPercentage > 0 And $iPercentage < 100 Then
		Local $iFileSize = _WinAPI_GetFileSizeEx($hFile) * ($iPercentage / 100)
		_WinAPI_SetFilePointer($hFile, $iFileSize)
		Return _WinAPI_SetEndOfFile($hFile)
	EndIf

	Return Lock_Erase($hFile)
EndFunc   ;==>Lock_Reduce

; #FUNCTION# ====================================================================================================================
; Name ..........: Lock_Write
; Description ...: Write data to a locked file
; Syntax ........: Lock_Write($hFile, $sText)
; Parameters ....: $hFile               - Handle returned by Lock_File()
;                  $sText               - Data to be written to the locked file
; Return values .: Success - Number of bytes written to the file
;                  Failure - 0 and sets @error to non-zero
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func Lock_Write($hFile, $sText)
	Local $iFileSize = _WinAPI_GetFileSizeEx($hFile), _
			$iLength = StringLen($sText)
	Local $tBuffer = DllStructCreate('byte buffer[' & $iLength & ']')
	DllStructSetData($tBuffer, 'buffer', $sText)
	_WinAPI_SetFilePointer($hFile, $iFileSize)
	Local $iWritten = 0
	_WinAPI_WriteFile($hFile, DllStructGetPtr($tBuffer), $iLength, $iWritten)

	Return SetError(@error, @extended, $iWritten) ; Number of bytes written
EndFunc   ;==>Lock_Write

; #FUNCTION# ====================================================================================================================
; Name ..........: Lock_Unlock
; Description ...: Unlock a file so other applications can interact with it
; Syntax ........: Lock_Unlock($hFile)
; Parameters ....: $hFile               - Handle returned by Lock_File()
; Return values .: Success - True
;                  Failure - False
; Author ........: guinness
; Example .......: Yes
; ===============================================================================================================================
Func Lock_Unlock($hFile)
	Return _WinAPI_CloseHandle($hFile)
EndFunc   ;==>Lock_Unlock
