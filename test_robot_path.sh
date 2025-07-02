#!/bin/bash

echo "Testing SPARE with robot path functionality..."

# Test 1: Original functionality (without robot path)
echo "Test 1: Original functionality"
./build/spare data/test1/source.obj data/test1/target.obj data/test1/test_original > test1.log 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Test 1 passed: Original functionality works"
else
    echo "✗ Test 1 failed: Original functionality broken"
fi

# Test 2: Robot path functionality (5 parameters)
echo "Test 2: Robot path functionality (5 parameters)"
./build/spare data/test1/source.obj data/test1/robot_path.txt data/test1/target.obj data/test1/test_robot > test2.log 2>&1
if [ $? -eq 0 ] && [ -f "data/test1/test_robot_newpath.txt" ]; then
    echo "✓ Test 2 passed: Robot path functionality works"
else
    echo "✗ Test 2 failed: Robot path functionality broken"
fi

# Test 3: Robot path functionality with parameters (11 parameters)
echo "Test 3: Robot path functionality with parameters (11 parameters)"
./build/spare data/test1/source.obj data/test1/robot_path.txt data/test1/target.obj data/test1/test_robot_params 10 0.01 1e-4 500 200 1 > test3.log 2>&1
if [ $? -eq 0 ] && [ -f "data/test1/test_robot_params_newpath.txt" ]; then
    echo "✓ Test 3 passed: Robot path with parameters works"
else
    echo "✗ Test 3 failed: Robot path with parameters broken"
fi

# Test 4: Complex robot path
echo "Test 4: Complex robot path"
./build/spare data/test1/source.obj data/test1/complex_robot_path.txt data/test1/target.obj data/test1/test_complex > test4.log 2>&1
if [ $? -eq 0 ] && [ -f "data/test1/test_complex_newpath.txt" ]; then
    echo "✓ Test 4 passed: Complex robot path works"
else
    echo "✗ Test 4 failed: Complex robot path broken"
fi

echo "All tests completed!"