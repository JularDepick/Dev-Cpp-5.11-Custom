; ==============================================
; Dev-C++ 5.11 + TDM-GCC 10.3.0 安装脚本
; ==============================================
Unicode True
RequestExecutionLevel admin
SetCompressor /SOLID lzma
SetDatablockOptimize ON

Icon "icon.ico"
UninstallIcon "icon.ico"
OutFile "Dev-Cpp-5.11-Custom-Setup.exe"

!define APP_NAME "Dev-Cpp-5.11-Custom"
!define INSTALL_DIR_NAME "Dev-Cpp-5.11"

InstallDir "C:\Program Files\${INSTALL_DIR_NAME}"

!include "MUI2.nsh"
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "WordFunc.nsh"
!include "FileFunc.nsh"

Name "${APP_NAME}"
Caption "${APP_NAME} 安装程序"
UninstallCaption "${APP_NAME} 卸载程序"
BrandingText " "

; ==============================================
; 界面文本
; ==============================================
!define MUI_WELCOMEPAGE_TITLE "欢迎安装 ${APP_NAME}"
!define MUI_WELCOMEPAGE_TEXT "本安装包集成Dev-C++5.11编辑器和TDM-GCC-10.3.0编译器$\r$\n一键安装，开箱即用。"
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "选择安装根目录："

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE DirectoryLeave
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
Page custom CustomPageCreate CustomPageLeave
!insertmacro MUI_PAGE_INSTFILES

; 卸载页面
UninstPage custom un.CustomPageCreate un.CustomPageLeave
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "SimpChinese"

; ==============================================
; 变量
; ==============================================
Var Checkbox_Shortcut
Var UninstallCheckbox_DeleteConfig
Var ShortcutChecked

; ==============================================
; 日志宏
; ==============================================
!macro LogMsg msg
  DetailPrint "${msg}"
!macroend

!macro un.LogMsg msg
  DetailPrint "${msg}"
!macroend

; ==============================================
; 自动补全安装目录
; ==============================================
Function DirectoryLeave
  StrCpy $0 $INSTDIR
  Push $0
  Push "${INSTALL_DIR_NAME}"
  Call IsDirEndsWith
  Pop $1
  ${If} $1 == 0
    StrCpy $INSTDIR "$INSTDIR\${INSTALL_DIR_NAME}"
    !insertmacro LogMsg "安装目录已自动补全为: $INSTDIR"
  ${EndIf}
FunctionEnd

Function IsDirEndsWith
  Exch $1
  Exch $0
  Push $2
  Push $3
  StrLen $2 $1
  StrLen $3 $0
  IntOp $3 $3 - $2
  StrCpy $0 $0 $2 $3
  StrCmp $0 $1 0 +2
  StrCpy $2 1
  StrCmp $2 1 0 +2
  StrCpy $2 0
  Pop $3
  Pop $0
  Pop $1
  Exch $2
FunctionEnd

; ==============================================
; 自定义页面：快捷方式选项
; ==============================================
Function CustomPageCreate
  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}
  ${NSD_CreateCheckbox} 0 0 100% 12u "创建Dev-C++桌面快捷方式"
  Pop $Checkbox_Shortcut
  ${NSD_Check} $Checkbox_Shortcut   ; 默认选中
  nsDialogs::Show
FunctionEnd

Function CustomPageLeave
  ; 页面离开前将复选框状态保存到全局变量
  ${NSD_GetState} $Checkbox_Shortcut $ShortcutChecked
FunctionEnd

; ==============================================
; 卸载自定义页面：是否删除配置文件
; ==============================================
Function un.CustomPageCreate
  nsDialogs::Create 1018
  Pop $0
  ${If} $0 == error
    Abort
  ${EndIf}
  ${NSD_CreateLabel} 0 0 100% 12u "卸载时可选择保留或删除用户配置文件："
  Pop $1
  ${NSD_CreateCheckbox} 0 15u 100% 12u "删除用户配置文件 (%APPDATA%\Dev-Cpp)（默认不删除）"
  Pop $UninstallCheckbox_DeleteConfig
  ${NSD_Uncheck} $UninstallCheckbox_DeleteConfig
  nsDialogs::Show
FunctionEnd
Function un.CustomPageLeave
  ; 卸载自定义页面的状态可以直接在 Section 中读取，因为 MUI_UNPAGE_CONFIRM 后控件仍存在
  ; 这里不需要保存到变量
FunctionEnd

; ==============================================
; 逐行替换 devcpp.ini 占位符
; ==============================================
Function ProcessIni
  StrCpy $R0 "$INSTDIR"
  StrCpy $R1 "$INSTDIR\TDM-GCC-10.3.0"
  StrCpy $9 "@[DEVCPP_PATH]"
  StrCpy $8 "@[GCC_PATH]"

  IfFileExists "$APPDATA\Dev-Cpp\devcpp.ini" 0 missing_ini

  GetTempFileName $R2
  FileOpen $0 "$APPDATA\Dev-Cpp\devcpp.ini" r
  IfErrors open_error
  FileOpen $1 $R2 w
  IfErrors open_error

  loop_read:
    FileRead $0 $2
    IfErrors done_read
    ${WordReplace} $2 $9 $R0 "+" $3
    ${WordReplace} $3 $8 $R1 "+" $4
    FileWrite $1 $4
    Goto loop_read
  done_read:
  FileClose $0
  FileClose $1

  Delete "$APPDATA\Dev-Cpp\devcpp.ini"
  Rename $R2 "$APPDATA\Dev-Cpp\devcpp.ini"
  !insertmacro LogMsg "   devcpp.ini 占位符替换成功"
  Return

open_error:
  !insertmacro LogMsg "   错误：无法打开 devcpp.ini"
  Return
missing_ini:
  !insertmacro LogMsg "   错误：devcpp.ini 不存在！请检查 Files\Dev-Cpp-5.11\CustomConfigTemplate 目录"
FunctionEnd

; ==============================================
; 安装主逻辑
; ==============================================
Section "Main"
  !insertmacro LogMsg "开始安装 ${APP_NAME}"

  !insertmacro LogMsg "1. 复制 Dev-C++ 主程序与编译器..."
  SetOutPath "$INSTDIR"
  File /r "Files\Dev-Cpp-5.11\*.*"
  !insertmacro LogMsg "   完成"

  !insertmacro LogMsg "2. 准备用户配置目录..."
  CreateDirectory "$APPDATA\Dev-Cpp"
  SetOutPath "$APPDATA\Dev-Cpp"
  File /r "Files\Dev-Cpp-5.11\CustomConfigTemplate\*.*"
  !insertmacro LogMsg "   配置模板复制完成"

  !insertmacro LogMsg "3. 处理 devcpp.ini 占位符..."
  Call ProcessIni

  !insertmacro LogMsg "4. 生成卸载程序..."
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  !insertmacro LogMsg "   完成"

  ; 注意：Main Section 最后不要再输出“安装完成”，留给 Post Section 统一显示
SectionEnd

; ==============================================
; 安装后操作：创建快捷方式（基于保存的状态）
; ==============================================
Section -Post
  ${If} $ShortcutChecked == ${BST_CHECKED}
    !insertmacro LogMsg "5. 创建桌面快捷方式（仅当前用户）..."
    CreateShortCut "$DESKTOP\Dev-C++.lnk" "$INSTDIR\devcpp.exe"
    ${If} ${FileExists} "$DESKTOP\Dev-C++.lnk"
      !insertmacro LogMsg "   桌面快捷方式已创建: $DESKTOP\Dev-C++.lnk"
    ${Else}
      !insertmacro LogMsg "   警告：快捷方式创建失败，请手动创建"
    ${EndIf}
  ${Else}
    !insertmacro LogMsg "5. 未选择创建快捷方式，跳过"
  ${EndIf}

  !insertmacro LogMsg "安装完成，窗口将保留在此页面"
SectionEnd

; ==============================================
; 卸载逻辑
; ==============================================
Section Uninstall
  !insertmacro un.LogMsg "开始卸载..."
  !insertmacro un.LogMsg "删除程序目录 $INSTDIR"
  RMDir /r "$INSTDIR"
  !insertmacro un.LogMsg "程序目录已删除"

  ${NSD_GetState} $UninstallCheckbox_DeleteConfig $1
  ${If} $1 == ${BST_CHECKED}
    !insertmacro un.LogMsg "删除用户配置文件 $APPDATA\Dev-Cpp"
    RMDir /r "$APPDATA\Dev-Cpp"
    !insertmacro un.LogMsg "用户配置文件已删除"
  ${Else}
    !insertmacro un.LogMsg "保留用户配置文件"
  ${EndIf}

  Delete "$DESKTOP\Dev-C++.lnk"
  !insertmacro un.LogMsg "卸载完成"
SectionEnd