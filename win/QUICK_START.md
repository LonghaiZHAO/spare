# SPARE Windows 快速开始指南

## 🚀 快速安装和使用

### 1. 系统要求
- Windows 10/11 (64位)
- 至少 4GB 可用磁盘空间
- 网络连接（用于下载依赖库）

### 2. 一键安装（推荐）

#### 方法A：使用vcpkg（推荐）
```cmd
# 1. 安装vcpkg
git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg
cd C:\vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install

# 2. 克隆项目
git clone https://github.com/LonghaiZHAO/spare.git
cd spare\win

# 3. 运行构建脚本
.\build_windows.bat
```

#### 方法B：使用PowerShell
```powershell
# 以管理员身份运行PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 克隆项目
git clone https://github.com/LonghaiZHAO/spare.git
cd spare\win

# 运行PowerShell构建脚本
.\build_windows.ps1
```

### 3. 验证安装
```cmd
cd build\Release
spare.exe --help
```

### 4. 运行测试示例
```cmd
# 在win目录下运行
.\test_examples.bat
```

## 📖 基本使用

### 最简单的使用方式

#### 1. 基本点云配准
```cmd
spare.exe source.obj target.obj output
```

#### 2. 机器人路径调整
```cmd
spare.exe source.obj robot_path.txt target.obj output
```

### 示例文件

项目提供了示例文件：
- `examples\robot_path_simple.txt` - 简单直线路径
- `examples\robot_path_complex.txt` - 复杂旋转路径

### 输出文件
- `output_res.ply` - 变形后的点云
- `output_newpath.txt` - 调整后的机器人路径（如果使用了机器人路径功能）

## 🔧 常见问题解决

### 问题1：vcpkg安装失败
**解决方案**：
```cmd
# 确保网络连接正常，重新安装
rmdir /s C:\vcpkg
git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg
cd C:\vcpkg
.\bootstrap-vcpkg.bat
```

### 问题2：编译错误
**解决方案**：
```cmd
# 清理并重新构建
cd spare\win
rmdir /s build
.\build_windows.bat
```

### 问题3：运行时错误 "半径过小"
**解决方案**：
```cmd
# 增加半径参数
spare.exe source.obj robot_path.txt target.obj output 15 0.01 1e-4 500 200 1
```

## 📞 获取帮助

- **详细文档**: 查看 `README.md`
- **GitHub Issues**: https://github.com/LonghaiZHAO/spare/issues
- **示例测试**: 运行 `test_examples.bat`

## 🎯 下一步

1. 阅读完整的 `README.md` 了解所有功能
2. 尝试使用自己的数据文件
3. 调整参数以获得最佳结果
4. 查看 `ROBOT_PATH_README.md` 了解机器人路径功能的详细信息

---

**提示**: 如果您是第一次使用，建议先运行测试示例以确保一切正常工作。