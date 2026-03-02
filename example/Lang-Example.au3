#cs ----------------------------------------------------------------------------

	 AutoIt Version: 3.3.18.0
	 Author:         Kanashius

	 Script Function:
		AutoIt Language example script.

#ce ----------------------------------------------------------------------------
#include <GUIConstantsEx.au3>
#include <GuiComboBox.au3>
#include "../Lang.au3"

; load default language => first language in lang.ini
__Lang_Load()

Local $iWidth = 400, $iHeight = 250, $iSpace = 5, $iCtrlHeight = 25

Local $hGui = GUICreate("AutoIt Language example", $iWidth, $iHeight)
Local $iCallbackWinTitle = __Lang_CreateCallback("_CallbackWinTitle")
__Lang_SetCallback($iCallbackWinTitle, "autoitLanguageExample")

Local $idMenuLang = GUICtrlCreateMenu("Language")
Global $arLanguages = __Lang_GetLanguages()
Local $idMenuLangFirst = Default
For $i=0 To UBound($arLanguages)-1
	Local $idMenuItem = GUICtrlCreateMenuItem($arLanguages[$i][1], $idMenuLang, -1, 1)
	If $i=0 Then
		GUICtrlSetState(-1, $GUI_CHECKED)
		$idMenuLangFirst = $idMenuItem
	EndIf
Next

Local $iLeft = $iSpace, $iTop = $iSpace, $iCtrlWidth = $iWidth-2*$iSpace
Local $idLabelExampleNumber = GUICtrlCreateLabel("", $iLeft, $iTop, $iCtrlWidth, $iCtrlHeight)
Local $iCallbackExampleNumber = __Lang_CreateCallback("__Lang_CallbackLabel", $idLabelExampleNumber)
__Lang_SetCallback($iCallbackExampleNumber, "exampleNumberIs", 5)

$iTop += $iCtrlHeight+$iSpace
Local $idLabelExampleOnlyEnglish = GUICtrlCreateLabel("", $iLeft, $iTop, $iCtrlWidth, $iCtrlHeight)
Local $iCallbackExampleOnlyEnglish = __Lang_CreateCallback("__Lang_CallbackLabel", $idLabelExampleOnlyEnglish)
__Lang_SetCallback($iCallbackExampleOnlyEnglish, "thisIsOnlyAvailableInEnglish")

$iTop += $iCtrlHeight+$iSpace
Local $idButton = GUICtrlCreateButton("", $iLeft, $iTop, $iCtrlWidth, $iCtrlHeight)
Local $iCallbackButton = __Lang_CreateCallback("__Lang_CallbackGuiCtrlSetData", $idButton)
__Lang_SetCallback($iCallbackButton, "setExampleNumberTo10")

$iTop += $iCtrlHeight+$iSpace
Local $idCombo = GUICtrlCreateCombo("", $iLeft, $iTop, $iCtrlWidth, $iCtrlHeight)
Local $iCallbackCombo = __Lang_CreateCallback("_CallbackCombo", $idCombo, 10)
__Lang_SetCallback($iCallbackCombo)

$iTop += $iCtrlHeight+$iSpace
Local $idLabelExampleMissingKey = GUICtrlCreateLabel("", $iLeft, $iTop, $iCtrlWidth, $iCtrlHeight)
Local $iCallbackExampleMissingKey = __Lang_CreateCallback("__Lang_CallbackLabel", $idLabelExampleMissingKey)
__Lang_SetCallback($iCallbackExampleMissingKey, "missingKeyExample")

$iTop += $iCtrlHeight+$iSpace
Local $idButtonAdd = GUICtrlCreateButton("", $iLeft, $iTop, $iCtrlWidth, $iCtrlHeight)
Local $iCallbackButtonAdd = __Lang_CreateCallback("__Lang_CallbackGuiCtrlSetData", $idButtonAdd)
__Lang_SetCallback($iCallbackButtonAdd, "addLabel")

$iTop += $iCtrlHeight+$iSpace

GUISetState(@SW_SHOW, $hGui)
Local $idLabelAdded, $iCallbackLabelAdded = Default

While True
	Local $iMsg = GUIGetMsg()
	Switch $iMsg
		Case -3
			Exit
		Case $idButton
			__Lang_SetCallback($iCallbackExampleNumber, "exampleNumberIs", 10)
		Case $idButtonAdd
			If $iCallbackLabelAdded=Default Then
				$idLabelAdded = GUICtrlCreateLabel("", $iLeft, $iTop, $iCtrlWidth, $iCtrlHeight)
				$iCallbackLabelAdded = __Lang_CreateCallback("__Lang_CallbackLabel", $idLabelAdded)
				__Lang_SetCallback($iCallbackLabelAdded, "thisLabelWasAdded")
				__Lang_SetCallback($iCallbackButtonAdd, "removeLabel")
			Else
				GUICtrlDelete($idLabelAdded)
				; delete callbacks if they are no longer used
				__Lang_DeleteCallback($iCallbackLabelAdded)
				$iCallbackLabelAdded = Default
				__Lang_SetCallback($iCallbackButtonAdd, "addLabel")
			EndIf
		Case Else
			If $idMenuLangFirst<>Default And $iMsg>=$idMenuLangFirst And $iMsg<$idMenuLangFirst+UBound($arLanguages) Then
				ConsoleWrite(__Lang_Get("switchLanguageTo", $arLanguages[$iMsg-$idMenuLangFirst][1])&@crlf)
				__Lang_Load($arLanguages[$iMsg-$idMenuLangFirst][0])
			EndIf
	EndSwitch
WEnd

Func _CallbackWinTitle($sKey, $sVal, $bRTL)
	WinSetTitle($hGui, "", $sVal)
EndFunc

Func _CallbackCombo($bRTL, $idCtrl, $iItemCount)
	Local $iStyle = __Lang__GUICtrlGetStyle($idCtrl)
	Local $iExStyle = __Lang__GUICtrlGetStyleEx($idCtrl)
	If $bRTL And Not BitAND($iExStyle, $WS_EX_RIGHT) Then
		GUICtrlSetStyle($idCtrl, $iStyle, BitOR(BitAND($iExStyle, BitNOT($WS_EX_LEFT)), $WS_EX_RIGHT))
	ElseIf Not $bRTL And Not BitAND($iStyle, $WS_EX_LEFT) Then
		GUICtrlSetStyle($idCtrl, $iStyle, BitOR(BitAND($iExStyle, BitNOT($WS_EX_RIGHT)), $WS_EX_LEFT))
	EndIf
	_GUICtrlComboBox_BeginUpdate($idCtrl)
	While _GUICtrlComboBox_GetCount($idCtrl)>0
		_GUICtrlComboBox_DeleteString($idCtrl, 0)
	WEnd
	For $i=0 To $iItemCount-1
		_GUICtrlComboBox_AddString($idCtrl, __Lang_Get("comboEntry", $i+1))
	Next
	_GUICtrlComboBox_EndUpdate($idCtrl)
EndFunc