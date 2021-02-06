
#pragma once

#include <string>
#include <vector>

class RBDirectory {
public:
    RBDirectory();

    void AddPath(std::string path);
    void RemovePath();

private:
    void Read();
    std::string BuildPath();

private:
    std::vector<std::string> m_path;
    std::vector<std::string> m_files;
};

