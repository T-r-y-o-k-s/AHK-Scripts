#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
CoordMode, Mouse, Screen
#SingleInstance, Force

#Persistent  
SetBatchLines,-1

If !A_IsCompiled {
	Run, "%A_ScriptDir%\Remove Activation Overlay.exe"
	ExitApp
} else {
	TrayMenu()
	Sleep, 2147483647 ; sleep 24 days to call ModeProcessHacker() only when requested via tray menu
	
}

TrayMenu()
{ ;{
	RAO := "Remove Activation Overlay"
	Menu, Tray, Icon, %A_AppData%\..\Icons\SHELL32.DLL_blocked.ico, 1
	Menu, Tray, Tip, %RAO%
	Menu, Tray, NoStandard
	StringLeft, title_1, RAO, 6
	StringRight, title_2_3, RAO, 18
	Menu, Tray, Add, %title_1% Windows' %title_2_3%, MenuHandler_Title
	Menu, Tray, Default, 1&
	Menu, Tray, Add
	Menu, Tray, Add, Edit the Script, MenuHandler_Edit
	Menu, Tray, Add, Recompile the Script, MenuHandler_Recompile
	Menu, Tray, Add, Open the Folder containing the Script, MenuHandler_Folder
	Menu, Tray, Add
	Menu, Tray, Add, Exit, MenuHandler_Exit	
	return
}

MenuHandler_Title:
BlockInput, Send
BlockInput, MouseMove
MouseGetPos, posx, posy
ModeProcessHacker(0)
MouseMove, posx, posy, 0
BlockInput, Default
BlockInput, MouseMoveOff
return
MenuHandler_Reload:
Reload
return
MenuHandler_Edit:
Edit
return
MenuHandler_Recompile:
RegRead InstallDir, HKLM\SOFTWARE\AutoHotkey, InstallDir
StringLeft, noext, A_ScriptFullPath, StrLen(A_ScriptFullPath)-4
Run, %InstallDir%\Compiler\Ahk2Exe.exe 
/in "%noext%".ahk 
/icon %A_AppData%\..\Icons\SHELL32.DLL_blocked.ico 
/compress 1
return
MenuHandler_Folder:
Run, explorer.exe "%A_ScriptDir%"
return
MenuHandler_Exit:
ExitApp
return
;}
	
ModeProcessHacker(sleeptime) ; sleeptime = time between function call and running ProcessHacker
{
	Process, Close, ProcessHacker.exe
	Sleep, sleeptime
	Run, "C:\Users\Admin\AppData\Programme\Process Hacker 2\ProcessHacker.exe"
	;Update()
		
	Sleep, 500
	WinActivate, Process Hacker [DESKTOP-MRB3Q41\Admin]
	
	; search for explorer
	Send, ^k
	Send, explorer.exe
	Send, {Tab}
		
	WinActivate, Process Hacker [DESKTOP-MRB3Q41\Admin]
	
	; open "Windows" from sub-contextmenu
	Send, {Down 5}
	Send, {AppsKey}
	Send, {Down 11}
	Send, {Right 1}
	Send, {Down 11}
	Send, {Enter}
	
	; select "Worker Window" and make it invisible
	Send, {Down 1}
	Send, Worker Window
	Send, {AppsKey}
	Send, {Down 6}
	Send, {Enter}
	Send, {Escape 2}
	
	Update()
}

Update()
{	; update tray icons
	SystemCursor("Toggle")
	MouseMove, 1550, 1050, 0
	MouseMove, 1670, 1050, 20
	SystemCursor("Toggle")	
}	

SystemCursor(OnOff=1)   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
{
	static AndMask, XorMask, $, h_cursor
       ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
       ,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13    ; blank cursors
       ,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13    ; handles of default cursors
	if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
	{
		$ := "h"                                       ; active default cursors
		VarSetCapacity( h_cursor,4444, 1 )
		VarSetCapacity( AndMask, 32*4, 0xFF )
		VarSetCapacity( XorMask, 32*4, 0 )
		system_cursors := "32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650"
		StringSplit c, system_cursors, `,
		Loop %c0%
		{
			h_cursor   := DllCall( "LoadCursor", "Ptr",0, "Ptr",c%A_Index% )
			h%A_Index% := DllCall( "CopyImage", "Ptr",h_cursor, "UInt",2, "Int",0, "Int",0, "UInt",0 )
			b%A_Index% := DllCall( "CreateCursor", "Ptr",0, "Int",0, "Int",0
               , "Int",32, "Int",32, "Ptr",&AndMask, "Ptr",&XorMask )
		}
	}
	if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
		$ := "b"  ; use blank cursors
	else
		$ := "h"  ; use the saved cursors
	
	Loop %c0%
	{
		h_cursor := DllCall( "CopyImage", "Ptr",%$%%A_Index%, "UInt",2, "Int",0, "Int",0, "UInt",0 )
		DllCall( "SetSystemCursor", "Ptr",h_cursor, "UInt",c%A_Index% )
	}
}