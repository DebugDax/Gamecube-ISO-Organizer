#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <File.au3>
#include <String.au3>
#include <WinAPI.au3>

Local $nBytes = 6 ; IDs are only 6 characters
Global $path = @ScriptDir & "\games\" ; Match layout of USB Loader GX
Global $version = "1.0.0"

ConsoleWrite(@CRLF & "=== Gamecube Organizer v" & $version & " ===" & @CRLF)
ConsoleWrite(@CRLF & "Gathering file list..." & @CRLF)

$files = _FileListToArray($path, "*.iso", 1, False) ; Only ISO's. Multiple filers would require  _FileListToArrayRec()

If Not IsArray($files) Then
	ConsoleWrite("Oops! Something went wrong." & @CRLF & "No files could be found in: " & $path & @CRLF & "Exiting Program." & @CRLF)
	Exit
EndIf
If $files[0] <= 0 Then
	ConsoleWrite("Oops! The directory is empty." & @CRLF & "No files could be found in: " & $path & @CRLF & "Exiting Program. " & @CRLF)
	Exit
EndIf

ConsoleWrite(UBound($files)-1 & " files found!" & @CRLF)
ConsoleWrite("Starting loop..." & @CRLF)
Sleep(1500)

For $i = 1 To $files[0] ; Loop every ISO found
	If StringInStr($files[$i], "[") > 0 And StringInStr($files[$i], "]") > 0 Then ; Filename has the ID in title, dont need to HEX reader
		$dirName = StringReplace($files[$i], ".iso", "")
		DirCreate($path & $dirName)
		FileMove($path & $files[$i], $path & $dirName & "\game.iso")
		checkSuccess($i, $files[0], $dirName)
	Else ; Need to read ID from first 6 HEX
		$tBuffer = DllStructCreate("byte[6]") ; Create our buffer
		$file = _WinAPI_CreateFile($path & $files[$i], 2, 2) ; Open the file as read only
		_WinAPI_SetFilePointer($file, 0, 0) ; Start at the beggining
		_WinAPI_ReadFile($file, $tBuffer, 6, $nBytes) ; Read the next 6 bytes
		_WinAPI_CloseHandle($file)
		$sText = BinaryToString(DllStructGetData($tBuffer, 1)) ; Convert the binary to a readable string
		; Need to validate the ID: 6 Characters, No Spaces, AlphaNumeric, No empty 6th character
		If StringLen($sText) = 6 and StringInStr($sText, " ") = 0 and StringIsAlNum($sText) and StringIsXDigit(StringRight($sText, 1)) Then
			$dirName = StringReplace($files[$i], ".iso", "") & " [" & $sText & "]"
			DirCreate($path & $dirName)
			FileMove($path & $files[$i], $path & $dirName & "\game.iso")
			checkSuccess($i, $files[0], $dirName)
		Else
			ConsoleWrite($i & "/" & $files[0] & ": Failed To Read (" & $files[$i] & ")" & @CRLF)
		EndIf
		$tBuffer = Null ; Clear buffer to avoid memory leak
	EndIf
Next

Func checkSuccess($currentRow, $maxRows, $directoryName)
	If FileExists($path & $directoryName & "\game.iso") Then
		ConsoleWrite($currentRow & "/" & $maxRows & ": Success! (" & $directoryName & ")" & @CRLF)
	Else
		ConsoleWrite($currentRow & "/" & $maxRows & ": Failed To Copy (" & $directoryName & ")" & @CRLF)
	EndIf
EndFunc   ;==>checkSuccess