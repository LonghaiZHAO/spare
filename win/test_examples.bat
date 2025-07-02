@echo off
echo ========================================
echo SPARE Windows 版本测试脚本
echo ========================================
echo.

REM Check if spare.exe exists
if not exist "spare.exe" (
    echo 错误: 找不到 spare.exe 文件
    echo 请确保 spare.exe 在当前目录中
    pause
    exit /b 1
)

REM Check if test data exists
if not exist "data\test1\src.obj" (
    echo 错误: 找不到测试数据文件
    echo 请确保 data 目录包含测试文件
    pause
    exit /b 1
)

echo 创建输出目录...
if not exist "test_output" mkdir test_output

echo.
echo ========================================
echo 测试1: 传统点云配准（默认参数）
echo ========================================
echo 命令: spare.exe data\test1\src.obj data\test1\tar.obj test_output\basic_test
spare.exe data\test1\src.obj data\test1\tar.obj test_output\basic_test
if %ERRORLEVEL% NEQ 0 (
    echo 测试1失败！
) else (
    echo 测试1成功！生成文件: test_output\basic_test_res.ply
)

echo.
echo ========================================
echo 测试2: 机器人路径调整（简单路径）
echo ========================================
echo 命令: spare.exe data\test1\src.obj examples\simple_robot_path.txt data\test1\tar.obj test_output\robot_simple
spare.exe data\test1\src.obj examples\simple_robot_path.txt data\test1\tar.obj test_output\robot_simple
if %ERRORLEVEL% NEQ 0 (
    echo 测试2失败！
) else (
    echo 测试2成功！
    echo   - 生成变形点云: test_output\robot_simple_res.ply
    if exist "test_output\robot_simple_newpath.txt" (
        echo   - 生成调整路径: test_output\robot_simple_newpath.txt
    )
)

echo.
echo ========================================
echo 测试3: 机器人路径调整（复杂路径）
echo ========================================
echo 命令: spare.exe data\test1\src.obj examples\complex_robot_path.txt data\test1\tar.obj test_output\robot_complex
spare.exe data\test1\src.obj examples\complex_robot_path.txt data\test1\tar.obj test_output\robot_complex
if %ERRORLEVEL% NEQ 0 (
    echo 测试3失败！
) else (
    echo 测试3成功！
    echo   - 生成变形点云: test_output\robot_complex_res.ply
    if exist "test_output\robot_complex_newpath.txt" (
        echo   - 生成调整路径: test_output\robot_complex_newpath.txt
    )
)

echo.
echo ========================================
echo 测试4: 机器人路径调整（自定义参数）
echo ========================================
echo 命令: spare.exe data\test1\src.obj examples\simple_robot_path.txt data\test1\tar.obj test_output\robot_params 10 0.01 1e-4 500 200 1
spare.exe data\test1\src.obj examples\simple_robot_path.txt data\test1\tar.obj test_output\robot_params 10 0.01 1e-4 500 200 1
if %ERRORLEVEL% NEQ 0 (
    echo 测试4失败！
) else (
    echo 测试4成功！
    echo   - 生成变形点云: test_output\robot_params_res.ply
    echo   - 生成调整路径: test_output\robot_params_newpath.txt
)

echo.
echo ========================================
echo 测试结果总结
echo ========================================
echo.
echo 在 test_output\ 目录中生成的输出文件:
dir test_output\*.* /b
echo.
echo 所有测试完成！
echo.
echo 说明:
echo - .ply 文件可以用 MeshLab 等3D查看器打开
echo - _newpath.txt 文件包含调整后的机器人路径
echo - 如有问题，请查看 README.md 获取详细说明
echo.
pause