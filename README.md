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

## 参数说明 | Parameters

### 关键参数列表

本工具箱分析的AquaCrop模型关键参数包括：

1. 作物生长参数：
   - CDC: 冠层生长系数
   - CGC: 冠层衰减系数
   - CCx: 最大冠层覆盖度
   - Kcb: 基本作物系数
   - WP*: 标准化水分生产力

2. 土壤水分参数：
   - CN: 径流曲线数
   - REW: 易蒸发水
   - TEW: 总可蒸发水
   - θFC: 田间持水量
   - θPWP: 永久枯萎点
   - Ksat: 饱和导水率

3. 根系参数：
   - Zmin: 最小有效根深
   - Zmax: 最大有效根深
   - PexpZ: 根系扩展形状系数

### 完整参数列表

#### 作物生长参数
| 参数 | 描述 | 单位 | 典型范围 |
|------|------|------|----------|
| CDC | 冠层衰减系数 | %/GDD | 0.001-0.003 |
| CGC | 冠层生长系数 | %/GDD | 0.005-0.012 |
| CCx | 最大冠层覆盖度 | % | 0.85-0.98 |
| CCo | 初始冠层覆盖度 | % | 0.01-0.05 |
| Kcb | 基本作物系数 | - | 0.9-1.1 |
| WP* | 标准化水分生产力 | g/m² | 15-20 |
| Tbase | 基本温度 | °C | 8-10 |
| Tupper | 上限温度 | °C | 35-40 |
| Emergence | 出苗所需积温 | GDD | 80-100 |
| Senescence | 衰老开始积温 | GDD | 1300-1500 |
| Maturity | 成熟所需积温 | GDD | 1700-1900 |
| HIo | 参考收获指数 | % | 45-50 |
| exc | 生长期过量冠层衰减系数 | %/day | 0.8-1.2 |
| p(upper) | 上层土壤水分耗竭系数 | - | 0.10-0.15 |
| p(lower) | 下层土壤水分耗竭系数 | - | 0.45-0.55 |
| KcTop | 最大作物系数 | - | 1.0-1.2 |
| fage | 衰老作用系数 | %/day | 0.10-0.15 |

#### 土壤水分参数
| 参数 | 描述 | 单位 | 典型范围 |
|------|------|------|----------|
| CN | 径流曲线数 | - | 65-85 |
| θFC | 田间持水量 | m³/m³ | 0.20-0.40 |
| θPWP | 永久枯萎点 | m³/m³ | 0.05-0.20 |
| θSAT | 饱和含水量 | m³/m³ | 0.45-0.55 |
| Ksat | 饱和导水率 | mm/day | 100-1000 |
| REW | 易蒸发水 | mm | 8-12 |
| TEW | 总可蒸发水 | mm | 20-35 |
| AerDays | 通气天数 | days | 3-7 |
| evapZ | 蒸发层厚度 | m | 0.10-0.15 |
| fwcc | 地表覆盖对蒸发的影响系数 | - | 50-60 |
| fwdc | 枯枝落叶对蒸发的影响系数 | - | 50-60 |

#### 根系参数
| 参数 | 描述 | 单位 | 典型范围 |
|------|------|------|----------|
| Zmin | 最小有效根深 | m | 0.20-0.30 |
| Zmax | 最大有效根深 | m | 1.0-2.0 |
| PexpZ | 根系扩展形状系数 | - | 1.2-1.5 |
| SxTop | 上层土壤水分汲取系数 | - | 5-10 |
| SxBot | 下层土壤水分汲取系数 | - | 0.4-0.8 |
| rtx | 最大根系生长速率 | m/day | 0.010-0.015 |

#### 胁迫参数
| 参数 | 描述 | 单位 | 典型范围 |
|------|------|------|----------|
| Ks_st | 土壤盐分胁迫阈值 | dS/m | 2-3 |
| Ks_ex | 土壤盐分胁迫形状系数 | %/(dS/m) | 10-15 |
| Kst_exp | 气孔导度胁迫指数 | - | 3-5 |
| anaer | 厌氧胁迫系数 | - | 0.01-0.02 |
| polmn | 授粉最低温度 | °C | 8-10 |
| polmx | 授粉最高温度 | °C | 35-40 |
| stbio | 生物量胁迫系数 | - | 0.7-0.8 |

### 参数敏感性分析说明

敏感性分析结果的解读方法：

1. EFAST方法结果解读：
   - Si (主效应指数)：表示单个参数的直接影响
   - STi (总效应指数)：包含参数与其他参数的交互作用
   - 指数值范围：0-1，越大表示影响越显著

2. Morris方法结果解读：
   - μ* (修正平均值)：表示参数对输出的整体影响程度
   - σ (标准差)：表示参数与其他参数的交互作用或非线性效应
   - 通过μ*-σ图可视化参数重要性

3. 结果可视化：
   - 使用`Grafici_Paper.m`查看主要分析图
   - 使用`Figure_mustar_sigma.m`查看Morris方法的μ*-σ散点图
   - 根据实际分析结果对参数进行排序

### 参数校准建议

1. 校准原则：
   - 优先校准敏感性分析结果中影响较大的参数
   - 考虑参数之间的交互作用
   - 结合实际观测数据进行校准

2. 校准注意事项：
   - 参数取值应在物理意义允许的范围内
   - 考虑参数之间的相关性
   - 建议使用实测数据进行验证
   - 可能需要多次迭代优化

## 执行流程 | Execution Process

1. 前期准备：
   - 配置AquaCrop插件路径
   - 准备气象数据文件
   - 设置土壤和作物参数

2. EFAST方法执行：
   ```matlab
   % 1. 设置基本参数
   fileinput.vs_method_options.EFAST.NsIni = 1250;
   fileinput.vs_method_options.EFAST.Nrep = 5;
   
   % 2. 运行分析
   [v_in_mat,v_Ns,v_w,v_in_mat_real,v_out_mat,vs_indices,CC_m] = EFAST(...);
   
   % 3. 结果可视化
   Grafici_Paper;
   ```

3. Morris方法执行：
   ```matlab
   % 1. 设置基本参数
   fileinput.vs_method_options.p = 8;
   fileinput.vs_method_options.r = 10;
   
   % 2. 运行分析
   [v_in_mat,v_in_mat_real,v_out_mat,vs_indices,CC_m] = Morris(...);
   
   % 3. 结果可视化
   Figure_mustar_sigma;
   ```

## 输入输出说明 | Input/Output Description

### 输入文件要求
- 气象数据：daily_weather.txt
- 土壤数据：soil_data.txt
- 作物参数：crop_param.txt

### 输出结果说明
1. EFAST方法输出：
   - 主效应指数（Si）
   - 总效应指数（STi）
   - 参数交互作用分析

2. Morris方法输出：
   - μ*（修正平均值）
   - σ（标准差）
   - 参数重要性排序

## 实际应用案例 | Case Studies

### 案例1：冬小麦生长模拟
- 研究区域：华北平原
- 关注参数：CDC, CGC, CCx
- 主要发现：水分生产力对CCx最敏感

### 案例2：玉米产量预测
- 研究区域：东北平原
- 关注参数：WP*, Kcb
- 主要发现：产量对WP*最敏感

## 常见问题 | FAQ

1. Q: EFAST和Morris方法如何选择？
   A: EFAST适合深入分析，Morris适合快速筛选。

2. Q: 如何处理参数相关性？
   A: 通过设置合理的参数范围和交互项分析。

3. Q: 模拟结果不收敛怎么办？
   A: 检查参数范围设置和增加样本量。
``````
