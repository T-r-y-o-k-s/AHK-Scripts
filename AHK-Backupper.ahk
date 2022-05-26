#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force

now := A_DD . "." . A_MM . "." . A_YYYY . ", " . A_Hour . "։" . A_Min . "։" . A_Sec
StringLeft, now_no_s, now, StrLen(now)-3

StringRight, ext, A_ScriptName, 4
switch ext 
{
	case ".ahk":
		Menu, Tray, Icon, backup-white-all.ico, 1, 1
	case ".exe":
		Menu, Tray, Icon, %A_ScriptFullPath%, 1, 1
}

switch A_DD {
	case 1: ; once a month
	{
		Gosub, MozBackup
		Gosub, OopsAllModsBU
		Gosub, minecraftBU
		Gosub, SelectFolder
		Gosub, edit❓
		return
	}
	
	case 8: ; week 1 done
	{
		Gosub, MozBackup
		Gosub, SelectFolder
		Gosub, edit❓
		return
	}
	
	case 15: ; twice a month, week 2 done
	{
		Gosub, MozBackup
		Gosub, OopsAllModsBU
		Gosub, SelectFolder
		Gosub, edit❓
		return
	}
	
	case 22: ; week 3 done
	{
		Gosub, MozBackup
		Gosub, SelectFolder
		Gosub, edit❓
		return
	}
	
	case 29: ; week 4 done
	{
		Gosub, MozBackup
		Gosub, SelectFolder
		Gosub, edit❓
		return
	}
	
	default:
	{
		;Gosub, MozBackup
		;Gosub, OopsAllModsBU
		;Gosub, minecraftBU
		;Gosub, SelectFolder
		;Gosub, edit❓
		ExitApp
	}
}

SelectFolder:
{
	MsgBox, 4, AHK-Backup (%now_no_s%), Copy another folder?
	IfMsgBox, No
		return
	
	FileSelectFolder, SourceFolder, , 3, Select the folder to copy
	if SourceFolder =
		return ; Otherwise, continue.
	FileSelectFolder, TargetFolder, , 3, Select the folder IN WHICH to create the duplicate folder.
	if TargetFolder =
		return ; Otherwise, continue.
	MsgBox, 4, AHK-Backup (%now_no_s%), A copy of the folder "%SourceFolder%" will be put into "%TargetFolder%".  Continue?
	IfMsgBox, No
		return
	SplitPath, SourceFolder, SourceFolderName  ; Extract only the folder name from its full path.
	FileCopyDir, %SourceFolder%, %TargetFolder%\%SourceFolderName%
	if ErrorLevel
		MsgBox, , AHK-Backup (%now_no_s%), The folder could not be copied, perhaps because a folder of that name already exists in "%TargetFolder%".
	
	Goto, SelectFolder
}

MozBackup:
{
	MsgBox, 4, AHK-Backup (%now%), Run MozBackup?
	IfMsgBox, Yes
		RunWait, MozBackup\MozBackup.exe
	return
}

OopsAllModsBU:
{
	;MsgBox, 4, AHK-Backup (%now_no_s%), Backup Oops`, All Mods?
	;IfMsgBox, Yes
		;FileCopyDir, C:\Users\Admin\AppData\Roaming\.minecraft\versions\Oops`, All Mods! OopsAllMods_v1.1.1, F:\MC BU\OopsAllModsBU\%now%
	return
}

minecraftBU:
{
	MsgBox, 4, AHK-Backup (%now_no_s%), Backup .minecraft?
	IfMsgBox, Yes
		FileCopyDir, C:\Users\Admin\AppData\Roaming\.minecraft, F:\MC BU\.minecraftBU\%now%
	return
}

edit❓:
{
	MsgBox, 4, AHK-Backup (%now%), Edit this script?
	IfMsgBox, Yes
		Edit
	return
}