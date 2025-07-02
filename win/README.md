# SPARE Windows 版本使用说明

## 概述

SPARE (Symmetrized Point-to-Plane Distance for Robust Non-Rigid Registration) 是一个基于嵌入式变形图节点的非刚性点云配准工具，现已扩展支持机器人末端执行器路径调整功能。

## 功能特性

### 🔧 核心功能
- **非刚性点云配准**: 使用对称点到平面距离进行鲁棒的非刚性配准
- **机器人路径调整**: 将机器人末端执行器路径作为特殊变形图节点进行调整
- **ARAP变换**: 使用As-Rigid-As-Possible算法计算最优变换
- **SE(3)投影**: 确保输出变换为有效的刚体变换

### 🤖 机器人路径功能
- 机器人路径点作为特殊节点集成到变形图中
- ARAP算法计算所有节点（包括机器人路径节点）的最优变换
- SE(3)投影使用SVD分解确保有效的刚体变换
- 支持六维路径（位置+旋转矩阵）的调整

## Windows 编译安装

### 方法一：使用预编译的依赖库（推荐）

#### 系统要求
- Windows 10/11 (64位)
- Visual Studio 2019/2022 或 MinGW-w64
- CMake 3.10 或更高版本
- Git

#### 依赖库安装

1. **安装 vcpkg (推荐)**
   ```cmd
   git clone https://github.com/Microsoft/vcpkg.git
   cd vcpkg
   .\bootstrap-vcpkg.bat
   .\vcpkg integrate install
   ```

2. **安装依赖库**
   ```cmd
   .\vcpkg install eigen3:x64-windows
   .\vcpkg install openmesh:x64-windows
   ```

#### 编译步骤

1. **克隆项目**
   ```cmd
   git clone https://github.com/LonghaiZHAO/spare.git
   cd spare
   ```

2. **创建构建目录**
   ```cmd
   mkdir build
   cd build
   ```

3. **配置CMake**
   ```cmd
   cmake .. -DCMAKE_TOOLCHAIN_FILE=[vcpkg根目录]/scripts/buildsystems/vcpkg.cmake -DCMAKE_BUILD_TYPE=Release
   ```

4. **编译**
   ```cmd
   cmake --build . --config Release
   ```

5. **生成可执行文件**
   编译完成后，在 `build/Release/` 目录下会生成 `spare.exe`

### 方法二：使用MinGW-w64

#### 安装MinGW-w64

1. 下载并安装 [MSYS2](https://www.msys2.org/)
2. 在MSYS2终端中安装工具链：
   ```bash
   pacman -S mingw-w64-x86_64-gcc
   pacman -S mingw-w64-x86_64-cmake
   pacman -S mingw-w64-x86_64-eigen3
   pacman -S mingw-w64-x86_64-openmesh
   ```

#### 编译步骤

1. **在MSYS2 MinGW64终端中执行**
   ```bash
   git clone https://github.com/LonghaiZHAO/spare.git
   cd spare
   mkdir build && cd build
   cmake .. -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Release
   mingw32-make -j4
   ```

## 使用说明

### 命令行格式

SPARE支持多种命令行格式，具体取决于是否使用机器人路径功能：

#### 1. 原始功能（不含机器人路径）
```cmd
spare.exe <源点云文件> <目标点云文件> <输出路径>
```

**示例：**
```cmd
spare.exe source.obj target.obj output
```

#### 2. 原始功能（带参数）
```cmd
spare.exe <源点云文件> <目标点云文件> <输出路径> <半径> <正则化权重> <旋转权重> <ARAP粗糙权重> <ARAP精细权重> <是否归一化>
```

**示例：**
```cmd
spare.exe source.obj target.obj output 10 0.01 1e-4 500 200 1
```

#### 3. 机器人路径功能（5参数）
```cmd
spare.exe <源点云文件> <机器人路径文件> <目标点云文件> <输出路径>
```

**示例：**
```cmd
spare.exe source.obj robot_path.txt target.obj output
```

#### 4. 机器人路径功能（11参数）
```cmd
spare.exe <源点云文件> <机器人路径文件> <目标点云文件> <输出路径> <半径> <正则化权重> <旋转权重> <ARAP粗糙权重> <ARAP精细权重> <是否归一化>
```

**示例：**
```cmd
spare.exe source.obj robot_path.txt target.obj output 10 0.01 1e-4 500 200 1
```

### 参数说明

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| 半径 | 浮点数 | 10 | 变形图节点半径 |
| 正则化权重 | 浮点数 | 0.01 | 平滑正则化权重 |
| 旋转权重 | 浮点数 | 1e-4 | 旋转约束权重 |
| ARAP粗糙权重 | 浮点数 | 500 | 粗糙阶段ARAP权重 |
| ARAP精细权重 | 浮点数 | 200 | 精细阶段ARAP权重 |
| 是否归一化 | 整数 | 1 | 是否对点云进行归一化 (0=否, 1=是) |

### 文件格式

#### 点云文件格式
支持 `.obj` 格式的三角网格文件。

#### 机器人路径文件格式
机器人路径文件为文本格式，每行表示一个路径点：

```
# 注释行以 # 开头
x y z r11 r12 r13 r21 r22 r23 r31 r32 r33
```

**格式说明：**
- `x, y, z`: 机器人末端执行器的位置坐标
- `r11, r12, r13, r21, r22, r23, r31, r32, r33`: 3×3旋转矩阵的元素（按行排列）

**示例文件：**
```
# 机器人路径文件示例
# 格式: [x, y, z, r11, r12, r13, r21, r22, r23, r31, r32, r33]
0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
0.1 0.0 0.0 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
0.2 0.0 0.0 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
```

### 输出文件

程序会在指定的输出路径生成以下文件：

1. **`<输出路径>_res.ply`**: 变形后的源点云文件
2. **`<输出路径>_newpath.txt`**: 调整后的机器人路径文件（仅在使用机器人路径功能时生成）

## 使用示例

### 示例1：基本点云配准
```cmd
# 基本配准（使用默认参数）
spare.exe data/source.obj data/target.obj results/basic_registration

# 输出文件：
# - results/basic_registration_res.ply
```

### 示例2：带参数的点云配准
```cmd
# 自定义参数配准
spare.exe data/source.obj data/target.obj results/custom_registration 15 0.02 2e-4 600 250 1

# 输出文件：
# - results/custom_registration_res.ply
```

### 示例3：机器人路径调整
```cmd
# 基本机器人路径调整
spare.exe data/source.obj data/robot_path.txt data/target.obj results/robot_adjustment

# 输出文件：
# - results/robot_adjustment_res.ply
# - results/robot_adjustment_newpath.txt
```

### 示例4：带参数的机器人路径调整
```cmd
# 自定义参数的机器人路径调整
spare.exe data/source.obj data/robot_path.txt data/target.obj results/custom_robot_adjustment 12 0.015 1.5e-4 550 220 1

# 输出文件：
# - results/custom_robot_adjustment_res.ply
# - results/custom_robot_adjustment_newpath.txt
```

## 算法原理

### 非刚性配准算法
1. **初始化**: 构建源点云的变形图
2. **节点采样**: 在源点云上均匀采样变形图节点
3. **机器人路径集成**: 将机器人路径点作为特殊节点添加到变形图中
4. **ARAP优化**: 使用As-Rigid-As-Possible算法优化节点变换
5. **SE(3)投影**: 将机器人路径节点的变换投影到SE(3)群
6. **路径更新**: 应用投影后的变换到机器人路径

### SE(3)投影算法
```
对于每个机器人路径节点的变换矩阵T：
1. 提取旋转部分R和平移部分t
2. 使用SVD分解将R投影到SO(3)群：R = U * V^T
3. 构造有效的SE(3)变换：T_projected = [R_projected, t; 0, 1]
```

## 性能优化建议

### 参数调优
- **半径**: 较大的半径提供更平滑的变形，但可能丢失细节
- **正则化权重**: 较高的值产生更平滑的结果
- **ARAP权重**: 平衡配准精度和变形平滑性

### 数据预处理
- 确保点云已正确对齐和缩放
- 移除噪声和离群点
- 使用适当的网格分辨率

## 故障排除

### 常见问题

#### 1. "Error: Some points cannot be covered under the specified radius"
**解决方案**: 增加半径参数值
```cmd
spare.exe source.obj robot_path.txt target.obj output 15 0.01 1e-4 500 200 1
```

#### 2. 程序运行时间过长
**解决方案**: 
- 减少点云复杂度
- 增加半径参数
- 降低ARAP权重

#### 3. 配准结果不理想
**解决方案**:
- 调整正则化权重
- 修改ARAP权重比例
- 检查输入点云质量

#### 4. 机器人路径文件格式错误
**解决方案**:
- 确保每行有12个数值
- 检查旋转矩阵的正交性
- 移除空行和无效字符

### 调试模式
如果遇到问题，可以在命令行中添加详细输出：
```cmd
spare.exe source.obj robot_path.txt target.obj output > debug.log 2>&1
```

## 技术支持

### 文档和资源
- **项目主页**: https://github.com/LonghaiZHAO/spare
- **原始论文**: "SPARE: Symmetrized Point-to-Plane Distance for Robust Non-Rigid Registration"
- **机器人路径功能文档**: `ROBOT_PATH_README.md`
- **实现细节**: `IMPLEMENTATION_SUMMARY.md`

### 联系方式
如有技术问题或建议，请通过GitHub Issues提交。

## 版本信息

- **当前版本**: 2.0 (包含机器人路径调整功能)
- **兼容性**: Windows 10/11 (64位)
- **编译器支持**: Visual Studio 2019+, MinGW-w64
- **依赖库**: Eigen3, OpenMesh

## 许可证

本项目遵循原始SPARE项目的许可证条款。

---

**注意**: 本文档描述的是扩展版本的SPARE，包含了机器人末端执行器路径调整功能。如果您只需要原始的点云配准功能，可以忽略机器人路径相关的参数和文件。