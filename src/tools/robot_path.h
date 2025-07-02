#ifndef ROBOT_PATH_H
#define ROBOT_PATH_H

#include "Types.h"

// Robot path point structure
struct RobotPathPoint {
    Vector3 position;    // [x, y, z]
    Matrix33 rotation;   // 3x3 rotation matrix
    
    RobotPathPoint() {
        position.setZero();
        rotation.setIdentity();
    }
    
    RobotPathPoint(const Vector3& pos, const Matrix33& rot) 
        : position(pos), rotation(rot) {}
};

// Robot path container
class RobotPath {
public:
    std::vector<RobotPathPoint> path_points;
    
    // Load robot path from file
    // Format: [x, y, z, r11, r12, r13, r21, r22, r23, r31, r32, r33] per line
    bool loadFromFile(const std::string& filename);
    
    // Save robot path to file
    bool saveToFile(const std::string& filename) const;
    
    // Get positions as Matrix3X for integration with existing code
    Matrix3X getPositions() const;
    
    // Set positions from Matrix3X (after deformation)
    void setPositions(const Matrix3X& positions);
    
    // Apply SE(3) transformations to path points
    void applyTransformations(const std::vector<Affine3>& transforms);
    
    // Get number of path points
    size_t size() const { return path_points.size(); }
    
    // Clear all path points
    void clear() { path_points.clear(); }
    
    // Add a path point
    void addPoint(const RobotPathPoint& point) { path_points.push_back(point); }
    
    // Get path point by index
    const RobotPathPoint& getPoint(size_t index) const { return path_points[index]; }
    RobotPathPoint& getPoint(size_t index) { return path_points[index]; }
};

// Utility functions for SE(3) projection
Matrix33 projectToSO3(const Matrix33& matrix);
Affine3 projectToSE3(const Matrix33& rotation, const Vector3& translation);

#endif // ROBOT_PATH_H