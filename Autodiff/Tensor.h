#ifndef TENSOR_H
#define TENSOR_H

#include<vector>
#include<utility>
#include<iostream>
#include<set>
#include<map>
#include <vector>

class Tensor{
    public:
    int num_dims = 2;
    int m;
    int n;
    std::vector<std::vector<double>> data;
    Tensor();
    Tensor (int m, int n);
    Tensor (int m, int n, std::vector<std::vector<double>> vals);
    Tensor transpose();
    
    void print();
    std::pair<int, int> shape();
};

Tensor matmul(Tensor a, Tensor b);
Tensor add(Tensor a, Tensor b);

#endif