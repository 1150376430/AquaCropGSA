# AquaCropGSA - AquaCrop模型全局敏感性分析工具箱

基于MATLAB的AquaCrop模型参数全局敏感性分析工具箱，使用EFAST(扩展傅里叶幅度敏感性测试)和Morris方法来识别作物生长模拟中最具影响力的参数。

## 概述 | Overview

本工具箱实现了敏感性分析方法，用于评估输入参数对AquaCrop模型输出的影响。主要关注：
- 作物产量对水分的响应
- 冠层覆盖度(CC)动态变化
- 生物量产量
- 水分生产力

## 功能特点 | Features

- 两种稳健的敏感性分析方法：
  - EFAST方法 (扩展傅里叶幅度敏感性测试)
    - 计算主效应和总效应指数
    - 处理非线性和非单调关系
  - Morris方法 (基本效应法)
    - 高效的筛选方法
    - 用较少的模拟次数识别影响参数
- 与AquaCrop模型集成
- 参数分布配置
- 自动化模拟执行
- 结果可视化
- CC和产量分析

## 系统要求 | Requirements

- MATLAB (已在R2019b或更高版本测试)
- AquaCrop插件 (v4.0)
- MATLAB统计工具箱 (用于某些分布)

## 安装说明 | Installation

1. 克隆此仓库：
bash
git clone https://github.com/eyage/AquaCropGSA.git
```

2. 将项目目录及其所有子目录添加到MATLAB路径：
```matlab
addpath(genpath('path/to/AquaCropGSA'));
```

3. 配置AquaCrop插件路径

## 目录结构 | Directory Structure

- `SensiLib/`: 敏感性分析库
  - `Code/Methods/`: EFAST和Morris方法的实现
  - `Doc/`: 文档和示例
- `Tools/`: 数据处理和分析的工具函数
- `Aquacrop_plugin/`: AquaCrop模型接口文件
- `Results/`: 模拟结果输出目录
- `Structure/`: 项目结构和配置文件

## 使用方法 | Usage

### EFAST方法
```matlab
% 配置输入参数
fileinput.vs_method_options.EFAST.NsIni = 1250;  % 样本大小
fileinput.vs_method_options.EFAST.Nrep = 5;      % 重复次数

% 运行EFAST分析
[v_in_mat,v_Ns,v_w,v_in_mat_real,v_out_mat,vs_indices,CC_m] = ...
    EFAST(fileinput,vs_factors_def,Param,v_lib_dir);
```

### Morris方法
```matlab
% 配置输入参数
fileinput.vs_method_options.p = 8;    % 网格级别数
fileinput.vs_method_options.n = 1;    % 轨迹数
fileinput.vs_method_options.r = 10;   % 重复次数
fileinput.vs_method_options.Q = 50;   % 轨迹组数

% 运行Morris分析
[v_in_mat,v_in_mat_real,v_out_mat,vs_indices,CC_m] = ...
    Morris(fileinput,vs_factors_def,Param,v_lib_dir);
```

## 结果分析 | Output Analysis

工具箱提供多个可视化脚本：
- `Grafici_Paper.m`: 生成主要分析图
  - 敏感性指数
  - 参数排序
  - 交互效应
- `Grafici_Paper_2.m`: 生成补充图
  - 时间序列分析
  - 分布图
- `Figure_mustar_sigma.m`: 绘制Morris方法的μ*-σ图

## 主要应用 | Key Applications

本工具箱已成功应用于：
- 作物产量敏感性分析
- 水分利用效率研究
- 气候变化影响评估
- 作物管理优化

## 参考文献 | References

如果您在研究中使用本工具箱，请引用：

1. 主要方法论文献：
- Campolongo, F., Cariboni, J., & Saltelli, A. (2007). An effective screening design for sensitivity analysis of large models. Environmental Modelling & Software, 22(10), 1509-1518.
- Saltelli, A., Tarantola, S., & Chan, K. S. (1999). A quantitative model-independent method for global sensitivity analysis of model output. Technometrics, 41(1), 39-56.

2. 相关应用文献：
- Xu, X., et al. (2016). Sensitivity analysis of crop growth models applied to wheat in water limited conditions. Environmental Modelling & Software, 81, 12-25.
- Confalonieri, R., et al. (2010). Sensitivity analysis of the rice model WARM in Europe: Exploring the effects of different locations, climates and methods of analysis on model sensitivity to crop parameters. Environmental Modelling & Software, 25(4), 479-488.

## 许可证 | License

本项目采用MIT许可证 - 详见LICENSE文件

## 贡献 | Contributing

欢迎贡献！请随时提交Pull Request。

## 联系方式 | Contact

如有问题和反馈，请联系：1150376430@qq.com

## 致谢 | Acknowledgments

本工作得到了敏感性分析方法及其在农业建模应用研究的支持。
```
```</rewritten_file>
