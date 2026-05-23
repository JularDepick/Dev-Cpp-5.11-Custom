# Dev-Cpp-5.11-Custom
携带TDM-GCC-10.3.0编译器的Dev-Cpp-5.11编辑器安装包。提供预设配置安装包和原版安装包。

## 初衷
- 原版的 Dev-Cpp-5.11 具有较好的简洁性和快捷性，但携带的编译器版本较低，于是我创建了这个仓库，整合Dev-Cpp-5.11编辑器和高版本编译器。
- 提供整合好的一键安装包和原版安装包。

## 适用于
- Windows_x64
- C/C++ 语言

## Releases
- `Dev-Cpp-5.11-Custom-Setup.exe` **携带TDM-GCC-10.3.0编译器的Dev-Cpp-5.11编辑器安装包**
- `Dev-Cpp 5.11 TDM-GCC 4.9.2 Setup.exe` 原版的Dev-Cpp-5.11安装包(携带TDM-GCC-4.9.2编译器)
- `Dev-Cpp 5.11 No Compiler Setup.exe` 原版的Dev-Cpp-5.11安装包(不携带编译器)
- `tdm64-gcc-10.3.0-setup.exe` TDM-GCC-10.3.0编译器安装包
- `tdm64-gcc-9.2.0-setup.exe` TDM-GCC-9.2.0编译器安装包
- `Dev-Cpp-5.11-Custom-SetupBuildPack.zip` 本项目安装包构建时资源包

## 使用指南
- 下载并运行发布包 `Dev-Cpp-5.11-Custom-Setup.exe` 运行安装即可
- 您也可以下载原版安装包，分别安装编辑器和编译器，自行配置 `%USERPROFILE/AppData/Roaming/Dev-Cpp` 下的配置文件（或在编辑器中进行配置）

## Dev-Cpp-5.11 个性化配置说明
- `CustomConfigTemplate/devcpp.ini` 提供了以下五个常用的编译器参数配置：
  - Release
  - Debug
  - Profile
  - Release-GUI
  - Precompiling

## Dev-Cpp-5.11安装包来源
- https://sourceforge.net/projects/orwelldevcpp/files/

## 编译器资源包来源
- https://github.com/jmeubank/tdm-gcc/releases/
- https://sourceforge.net/projects/tdm-gcc/files/
