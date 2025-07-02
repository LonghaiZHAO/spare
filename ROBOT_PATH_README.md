# Robot End-Effector Path Adjustment Feature

This document describes the robot end-effector path adjustment functionality added to the SPARE non-rigid point cloud registration project.

## Overview

The enhanced SPARE system can now adjust robot end-effector paths based on non-rigid deformation computed from point cloud registration. Robot path points are integrated as special deformation graph nodes, and their transformations are computed using the As-Rigid-As-Possible (ARAP) algorithm, then projected to SE(3) group to maintain valid rigid transformations.

## Usage

### Command Line Interface

The program now supports two additional command line formats:

#### 1. With Robot Path (5 parameters)
```bash
./spare <srcFile> <srcPathFile> <tarFile> <outPath>
```

#### 2. With Robot Path and Parameters (11 parameters)
```bash
./spare <srcFile> <srcPathFile> <tarFile> <outPath> <radius> <w_reg> <w_rot> <w_arap_c> <w_arap_f> <use_normalize>
```

#### 3. Original Functionality (unchanged)
```bash
./spare <srcFile> <tarFile> <outPath>
./spare <srcFile> <tarFile> <outPath> <radius> <w_reg> <w_rot> <w_arap_c> <w_arap_f> <use_normalize>
```

### Parameters

- `<srcFile>`: Source point cloud file (.obj format)
- `<srcPathFile>`: Robot path file (text format, see below)
- `<tarFile>`: Target point cloud file (.obj format)
- `<outPath>`: Output directory path
- `<radius>`: Deformation graph node radius (default: 10)
- `<w_reg>`: Regularization weight (default: 0.01)
- `<w_rot>`: Rotation weight (default: 1e-4)
- `<w_arap_c>`: ARAP weight for coarse stage (default: 500)
- `<w_arap_f>`: ARAP weight for fine stage (default: 200)
- `<use_normalize>`: Whether to normalize (default: 1)

## Robot Path File Format

The robot path file should be a text file with the following format:

```
# Comments start with #
x y z r11 r12 r13 r21 r22 r23 r31 r32 r33
```

Where:
- `x, y, z`: Position coordinates of the robot end-effector
- `r11, r12, r13, r21, r22, r23, r31, r32, r33`: Elements of the 3x3 rotation matrix in row-major order

### Example Robot Path File

```
# Robot path file
0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
0.1 0.0 0.0 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
0.2 0.0 0.0 1.0 0.0 0.0 0.0 1.0 0.0 0.0 0.0 1.0
```

## Output

When robot path functionality is used, the program generates:

1. `<outPath>_res.ply`: Deformed source point cloud (same as original functionality)
2. `<outPath>_newpath.txt`: Adjusted robot path file with the same format as input

## Algorithm Details

1. **Integration**: Robot path points are added as special nodes to the deformation graph
2. **ARAP Computation**: The ARAP algorithm computes optimal transformations for all nodes, including robot path nodes
3. **SE(3) Projection**: Robot path transformations are projected to SE(3) group using SVD to ensure valid rigid transformations
4. **Path Update**: The projected transformations are applied to the original robot path points

## Implementation Files

- `src/tools/robot_path.h/cpp`: Robot path data structure and SE(3) utilities
- `src/NonRigidreg.h/cpp`: Extended with robot path support
- `src/Registration.h`: Updated to include robot path functionality
- `src/main.cpp`: Modified command line parsing and workflow

## Testing

Run the test script to verify all functionality:

```bash
./test_robot_path.sh
```

This will test:
1. Original functionality (without robot path)
2. Robot path functionality (5 parameters)
3. Robot path functionality with parameters (11 parameters)
4. Complex robot path with different orientations

## Notes

- The original SPARE functionality remains unchanged when robot path files are not provided
- Robot path nodes are treated as special deformation graph nodes with identity initial transformations
- SE(3) projection ensures that the output transformations are valid rigid body transformations
- The system automatically handles different numbers of robot path points