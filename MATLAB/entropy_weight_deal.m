%%初始化
close all;
clear;
clc;
%%赋分表
indicators=[3 3 2 1 2 2 2 1;2 2 1 1 1 1 1 2;
                     1 1 1 1 1 1 1 3];
%%计算各指标权重和各方案得分
[score,weight]=entropy_weight(indicators);
score=100*(1-score);