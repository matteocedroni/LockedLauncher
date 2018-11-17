#RequireAdmin

#include <AutoItConstants.au3>
#include <File.au3>
#include <WinAPIFiles.au3>
#include <Misc.au3>

_Singleton(@ScriptName)

Global $unlockOnWindow
Global $unlockOnWindowTimeout
Global $unlockOnWindowDelay
Global $unlockAfter
Global $audibleLockStatusChange

Global $iLaunchedPid

Main()

Func Main()
   Init()

   If Not IsAdmin() Then LogMessage("working without admin rights; lock logic will not work")

   LockInput()

   DoLaunch()

   ; Unlock behavior: Window based OR time based
   If Not $unlockOnWindow = "" Then
	  LogMessage("unlock behavior: on target window")
	  $hWin = WinWaitActive($unlockOnWindow, "", $unlockOnWindowTimeout)
	  if $hWin<>0 Then
		 LogMessage("target window found!")
		 Sleep($unlockOnWindowDelay * 1000)
	  EndIf
   Else
	  LogMessage("unlock behavior: fixed delay")
	  Sleep($unlockAfter * 1000)
   EndIf

   UnLockInput()

   ProcessWaitClose($iLaunchedPid)
   LogMessage("end")
EndFunc

; Init parameters
Func Init()
   ; unlock on window
   $unlockOnWindow = IniRead(@ScriptDir & "\lockedLauncher.ini", "General", "unlockOnWindow", "")
   ; unlock on window delay
   $unlockOnWindowDelay = Number(IniRead(@ScriptDir & "\lockedLauncher.ini", "General", "unlockOnWindowDelay", "5"))
   ; unlock on window timeout
   $unlockOnWindowTimeout = Number(IniRead(@ScriptDir & "\lockedLauncher.ini", "General", "unlockOnWindowTimeout", "50"))

   ; fixed unlock delay
   $unlockAfter = Number(IniRead(@ScriptDir & "\lockedLauncher.ini", "General", "unlockAfter", "15"))

   ; audible lock/unlock
   $audibleLockStatusChange = IniRead(@ScriptDir & "\lockedLauncher.ini", "General", "audibleLockStatusChange", "False")
EndFunc

; Disable user input (mouse and keyboard)
Func LockInput()
   $iBlockResult = BlockInput($BI_DISABLE)
   if $audibleLockStatusChange = "True" Then Beep(500, 500)
   LogMessage("input disabled: " & $iBlockResult)
EndFunc

; Enable user input (mouse and keyboard)
Func UnLockInput()
   $iBlockResult = BlockInput($BI_ENABLE)
   if $audibleLockStatusChange = "True" Then Beep(1000, 500)
   LogMessage("input enabled: " & $iBlockResult)
EndFunc

; Launch logic
Func DoLaunch()
   Log("invoke: " & $CmdLineRaw)
   $iLaunchedPid = Run($CmdLineRaw)
   LogMessage("invoked, pid: " & $iLaunchedPid)
EndFunc

Func LogMessage($logMessage)
   _FileWriteLog(@ScriptDir & "\lockedLauncher.log", $logMessage)
EndFunc