#include "robot_path.h"
#include <fstream>
#include <sstream>
#include <iostream>
#include <iomanip>

bool RobotPath::loadFromFile(const std::string& filename) {
    std::ifstream file(filename);
    if (!file.is_open()) {
        std::cerr << "Error: Cannot open robot path file: " << filename << std::endl;
        return false;
    }
    
    path_points.clear();
    std::string line;
    int line_number = 0;
    
    while (std::getline(file, line)) {
        line_number++;
        if (line.empty() || line[0] == '#') continue; // Skip empty lines and comments
        
        std::istringstream iss(line);
        std::vector<Scalar> values;
        Scalar value;
        
        while (iss >> value) {
            values.push_back(value);
        }
        
        if (values.size() != 12) {
            std::cerr << "Error: Line " << line_number << " in " << filename 
                      << " should have 12 values, but has " << values.size() << std::endl;
            return false;
        }
        
        RobotPathPoint point;
        // Position: [x, y, z]
        point.position = Vector3(values[0], values[1], values[2]);
        
        // Rotation matrix: [r11, r12, r13, r21, r22, r23, r31, r32, r33]
        point.rotation << values[3], values[4], values[5],
                          values[6], values[7], values[8],
                          values[9], values[10], values[11];
        
        path_points.push_back(point);
    }
    
    file.close();
    std::cout << "Loaded " << path_points.size() << " robot path points from " << filename << std::endl;
    return true;
}

bool RobotPath::saveToFile(const std::string& filename) const {
    std::ofstream file(filename);
    if (!file.is_open()) {
        std::cerr << "Error: Cannot create robot path file: " << filename << std::endl;
        return false;
    }
    
    file << std::fixed << std::setprecision(6);
    for (const auto& point : path_points) {
        // Write position and rotation matrix
        file << point.position(0) << " " << point.position(1) << " " << point.position(2) << " "
             << point.rotation(0,0) << " " << point.rotation(0,1) << " " << point.rotation(0,2) << " "
             << point.rotation(1,0) << " " << point.rotation(1,1) << " " << point.rotation(1,2) << " "
             << point.rotation(2,0) << " " << point.rotation(2,1) << " " << point.rotation(2,2) << std::endl;
    }
    
    file.close();
    std::cout << "Saved " << path_points.size() << " robot path points to " << filename << std::endl;
    return true;
}

Matrix3X RobotPath::getPositions() const {
    Matrix3X positions(3, path_points.size());
    for (size_t i = 0; i < path_points.size(); ++i) {
        positions.col(i) = path_points[i].position;
    }
    return positions;
}

void RobotPath::setPositions(const Matrix3X& positions) {
    if (positions.cols() != static_cast<int>(path_points.size())) {
        std::cerr << "Error: Position matrix size mismatch" << std::endl;
        return;
    }
    
    for (size_t i = 0; i < path_points.size(); ++i) {
        path_points[i].position = positions.col(i);
    }
}

void RobotPath::applyTransformations(const std::vector<Affine3>& transforms) {
    if (transforms.size() != path_points.size()) {
        std::cerr << "Error: Transform vector size mismatch" << std::endl;
        return;
    }
    
    for (size_t i = 0; i < path_points.size(); ++i) {
        // Apply transformation to position
        Vector3 new_position = transforms[i] * path_points[i].position;
        
        // Apply rotation to orientation
        Matrix33 new_rotation = transforms[i].linear() * path_points[i].rotation;
        
        path_points[i].position = new_position;
        path_points[i].rotation = new_rotation;
    }
}

Matrix33 projectToSO3(const Matrix33& matrix) {
    // Project matrix to SO(3) using SVD
    Eigen::JacobiSVD<Matrix33> svd(matrix, Eigen::ComputeFullU | Eigen::ComputeFullV);
    Matrix33 rotation = svd.matrixU() * svd.matrixV().transpose();
    
    // Ensure determinant is +1 (proper rotation)
    if (rotation.determinant() < 0) {
        Matrix33 U = svd.matrixU();
        U.col(2) *= -1;  // Flip the last column
        rotation = U * svd.matrixV().transpose();
    }
    
    return rotation;
}

Affine3 projectToSE3(const Matrix33& rotation, const Vector3& translation) {
    Affine3 transform = Affine3::Identity();
    transform.linear() = projectToSO3(rotation);
    transform.translation() = translation;
    return transform;
}