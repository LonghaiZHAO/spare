# SPARE Windows Release Notes

## Version 2.0 - Robot Path Adjustment Release

### 🎉 新功能

#### 机器人末端执行器路径调整
- **路径集成**: 机器人路径点作为特殊节点集成到变形图中
- **ARAP变换**: 使用As-Rigid-As-Possible算法计算最优变换
- **SE(3)投影**: 确保输出变换为有效的刚体变换
- **六维路径支持**: 支持位置和旋转矩阵的完整路径调整

#### 增强的命令行界面
- **向后兼容**: 保持原有功能完全不变
- **灵活参数**: 支持5参数和11参数模式
- **智能检测**: 自动识别是否使用机器人路径功能

#### Windows原生支持
- **一键安装**: 提供自动化安装脚本
- **vcpkg集成**: 使用vcpkg管理依赖库
- **多编译器支持**: 支持Visual Studio和MinGW-w64

### 📁 文件结构

```
win/
├── README.md                 # 详细使用说明
├── QUICK_START.md           # 快速开始指南
├── RELEASE_NOTES.md         # 发布说明（本文件）
├── install.bat              # 自动安装脚本
├── build_windows.bat        # 批处理构建脚本
├── build_windows.ps1        # PowerShell构建脚本
├── test_examples.bat        # 测试示例脚本
├── mingw-w64-x86_64.cmake  # MinGW交叉编译工具链
├── examples/                # 示例文件
│   ├── robot_path_simple.txt    # 简单路径示例
│   └── robot_path_complex.txt   # 复杂路径示例
└── build/                   # 构建目录（构建后生成）
    └── Release/
        └── spare.exe        # Windows可执行文件
```

### 🚀 安装方式

#### 方法1：自动安装（推荐）
```cmd
git clone https://github.com/LonghaiZHAO/spare.git
cd spare\win
.\install.bat
```

#### 方法2：手动安装
```cmd
# 1. 安装vcpkg
git clone https://github.com/Microsoft/vcpkg.git C:\vcpkg
cd C:\vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install

# 2. 构建项目
cd spare\win
.\build_windows.bat
```

### 💻 系统要求

#### 最低要求
- **操作系统**: Windows 10 (64位) 或更高版本
- **内存**: 4GB RAM
- **磁盘空间**: 2GB 可用空间
- **网络**: 用于下载依赖库

#### 推荐配置
- **操作系统**: Windows 11 (64位)
- **内存**: 8GB RAM 或更多
- **磁盘空间**: 4GB 可用空间
- **处理器**: 多核CPU（用于并行编译）

#### 软件依赖
- **Git**: 用于克隆项目和依赖库
- **CMake**: 3.10 或更高版本
- **编译器**: Visual Studio 2019+ 或 MinGW-w64

### 🔧 使用示例

#### 基本点云配准
```cmd
spare.exe source.obj target.obj output
```

#### 机器人路径调整
```cmd
spare.exe source.obj robot_path.txt target.obj output
```

#### 带参数的路径调整
```cmd
spare.exe source.obj robot_path.txt target.obj output 10 0.01 1e-4 500 200 1
```

### 📊 性能特性

#### 计算性能
- **多线程支持**: 利用多核CPU加速计算
- **内存优化**: 高效的内存管理
- **算法优化**: 优化的ARAP实现

#### 可扩展性
- **大规模点云**: 支持数万个点的点云
- **长路径**: 支持数百个路径点的机器人路径
- **参数调优**: 灵活的参数配置

### 🧪 测试覆盖

#### 功能测试
- ✅ 基本点云配准
- ✅ 机器人路径调整
- ✅ 参数化配准
- ✅ 文件I/O操作

#### 兼容性测试
- ✅ Windows 10 (64位)
- ✅ Windows 11 (64位)
- ✅ Visual Studio 2019/2022
- ✅ MinGW-w64

#### 性能测试
- ✅ 小规模数据 (<1000点)
- ✅ 中等规模数据 (1000-10000点)
- ✅ 大规模数据 (>10000点)

### 🐛 已知问题

#### 限制
1. **依赖库大小**: vcpkg安装的依赖库较大（约1GB）
2. **编译时间**: 首次编译可能需要较长时间
3. **内存使用**: 大规模数据可能需要较多内存

#### 解决方案
1. 确保有足够的磁盘空间
2. 使用多核CPU并行编译
3. 根据可用内存调整数据规模

### 🔄 更新历史

#### v2.0 (当前版本)
- ➕ 新增机器人路径调整功能
- ➕ Windows原生支持
- ➕ 自动化构建脚本
- ➕ 完整的文档和示例
- 🔧 优化算法性能
- 🔧 改进错误处理

#### v1.0 (基础版本)
- ➕ 基本非刚性点云配准
- ➕ ARAP算法实现
- ➕ Linux支持

### 📞 技术支持

#### 文档资源
- **用户手册**: `README.md`
- **快速指南**: `QUICK_START.md`
- **API文档**: `ROBOT_PATH_README.md`
- **实现细节**: `IMPLEMENTATION_SUMMARY.md`

#### 社区支持
- **GitHub Issues**: https://github.com/LonghaiZHAO/spare/issues
- **讨论区**: GitHub Discussions
- **示例代码**: `examples/` 目录

#### 报告问题
请在GitHub Issues中报告问题，并提供：
1. 操作系统版本
2. 编译器版本
3. 错误信息
4. 重现步骤

### 📄 许可证

本项目遵循原始SPARE项目的许可证条款。

### 🙏 致谢

感谢以下项目和社区的支持：
- **SPARE原始项目**: 提供了优秀的非刚性配准算法
- **Eigen**: 高性能线性代数库
- **OpenMesh**: 网格处理库
- **vcpkg**: 简化了Windows下的依赖管理
- **CMake**: 跨平台构建系统

---

**注意**: 这是SPARE项目的扩展版本，包含了机器人路径调整功能。如果您只需要原始的点云配准功能，所有原有功能保持不变。