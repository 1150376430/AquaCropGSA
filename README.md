# AquaCrop 敏感性分析工具箱

## 1. 文件说明及使用指南

### 1.1 主程序文件
#### EFAST.m
- **功能**: 实现扩展傅里叶幅度敏感性分析
- **输入**: 
  - fileinput: 配置结构体
  - vs_factors_def: 参数定义
  - Param: 模型参数
  - v_lib_dir: 库目录
- **输出**:
  - v_in_mat: 输入参数矩阵
  - v_out_mat: 输出结果矩阵
  - vs_indices: 敏感性指数
- **使用方法**:
  1. 设置fileinput.vs_method_options.EFAST
  2. 准备参数定义文件
  3. 运行EFAST.m
  4. 分析输出结果

#### Morris.m
- **功能**: 实现Morris基本效应分析
- **输入**:
  - fileinput: 配置结构体
  - vs_factors_def: 参数定义
  - Param: 模型参数
  - v_lib_dir: 库目录
- **输出**:
  - v_in_mat: 输入参数矩阵
  - v_out_mat: 输出结果矩阵
  - vs_indices: 敏感性指数
- **使用方法**:
  1. 设置fileinput.vs_method_options.Morris
  2. 准备参数定义文件
  3. 运行Morris.m
  4. 分析输出结果

### 1.2 配置文件
#### Parameters_def.m
- **功能**: 定义参数范围和默认值
- **包含内容**:
  - 参数名称和代码
  - 默认值设置
  - 变化范围定义
  - 参数类型说明
- **使用方法**:
  1. 根据研究需要修改参数范围
  2. 确保范围物理意义合理
  3. 保存修改后重新运行

#### fileinput.m
- **功能**: 设置分析方法参数
- **配置项目**:
  - 采样数量设置
  - 重复次数定义
  - 输出选项配置
  - 分析方法选择
- **使用方法**:
  1. 选择分析方法
  2. 设置相应参数
  3. 保存配置后运行

### 1.3 数据处理文件
#### Process_data.m
- **功能**: 处理模拟输出数据
- **主要任务**:
  - 数据格式转换
  - 异常值处理
  - 统计分析计算
  - 结果汇总整理
- **使用方法**:
  1. 输入原始结果文件
  2. 选择处理选项
  3. 运行获取处理后数据

#### Plot_results.m
- **功能**: 生成结果图表
- **图表类型**:
  - 敏感性指数图
  - 参数交互图
  - 时间序列图
  - 散点分布图
- **使用方法**:
  1. 输入处理后数据
  2. 选择图表类型
  3. 设置绘图参数
  4. 运行生成图表

### 1.4 工具函数文件
#### Tools/data_process.m
- **功能**: 数据预处理工具集
- **主要函数**:
  - 数据读取函数
  - 格式转换函数
  - 数据清理函数
  - 统计计算函数
- **使用方法**:
  1. 调用所需函数
  2. 输入相应参数
  3. 获取处理结果

#### Tools/plot_tools.m
- **功能**: 绘图工具集
- **主要函数**:
  - 基础绘图函数
  - 专业图表函数
  - 格式设置函数
  - 图表导出函数
- **使用方法**:
  1. 调用绘图函数
  2. 设置图表参数
  3. 生成所需图表

### 1.5 输出文件说明
#### Results/
- **EFAST结果**:
  - EFAST_Si.mat: 主效应指数
  - EFAST_STi.mat: 总效应指数
  - EFAST_plots/: 结果图表

- **Morris结果**:
  - Morris_mu.mat: μ*值
  - Morris_sigma.mat: σ值
  - Morris_plots/: 结果图表

- **综合分析**:
  - Combined_results.mat: 综合结果
  - Summary_report.txt: 分析报告
  - Visualization/: 可视化结果

## 2. 完整敏感性分析参数列表

### 2.1 作物生长参数
| 参数代码 | 参数名称 | 单位 | 默认值 | 变化范围 | 敏感性等级 |
|----------|----------|------|---------|-----------|------------|
| CGC | 冠层生长系数 | %/GDD | 0.008 | 0.005-0.012 | 中 |
| CCx | 最大冠层覆盖度 | % | 0.96 | 0.85-0.98 | 低 |
| CDC | 冠层衰减系数 | %/GDD | 0.002 | 0.001-0.003 | 低 |
| WP* | 标准化水分生产力 | g/m² | 18 | 15-20 | 中 |
| HIo | 参考收获指数 | % | 48 | 45-50 | 中 |
| exc | 生长期过量冠层衰减系数 | %/day | 1.0 | 0.8-1.2 | 低 |
| Kcb | 基本作物系数 | - | 1.0 | 0.9-1.1 | 低 |

### 2.2 物候参数
| 参数代码 | 参数名称 | 单位 | 默认值 | 变化范围 | 敏感性等级 |
|----------|----------|------|---------|-----------|------------|
| dos | 播种日期 | DOY | 270 | 260-280 | 高 |
| mat | 生长周期长度 | GDD | 1800 | 1700-1900 | 高 |
| eme | 出苗所需积温 | GDD | 90 | 80-100 | 低 |
| flo | 开花所需积温 | GDD | 1200 | 1100-1300 | 中 |
| sen | 衰老开始积温 | GDD | 1400 | 1300-1500 | 高 |

### 2.3 水分参数
| 参数代码 | 参数名称 | 单位 | 默认值 | 变化范围 | 敏感性等级 |
|----------|----------|------|---------|-----------|------------|
| fc | 田间持水量 | m³/m³ | 0.30 | 0.20-0.40 | 高 |
| pwp | 萎蔫点 | m³/m³ | 0.15 | 0.05-0.20 | 高 |
| Ksat | 饱和导水率 | mm/day | 500 | 100-1000 | 低 |
| rtx | 最大有效根深 | m | 1.5 | 1.0-2.0 | 中 |
| REW | 易蒸发水 | mm | 10 | 8-12 | 低 |
| TEW | 总可蒸发水 | mm | 30 | 20-35 | 低 |
| CN | 径流曲线数 | - | 75 | 65-85 | 低 |

### 2.4 胁迫参数
| 参数代码 | 参数名称 | 单位 | 默认值 | 变化范围 | 敏感性等级 |
|----------|----------|------|---------|-----------|------------|
| psto | 气孔导度水分胁迫系数 | - | 0.55 | 0.45-0.65 | 中 |
| psen | 衰老水分胁迫系数 | - | 0.70 | 0.60-0.80 | 中 |
| polmn | 授粉最低温度 | °C | 8 | 5-10 | 低 |
| polmx | 授粉最高温度 | °C | 35 | 30-40 | 低 |
| Kst_exp | 水分胁迫指数 | - | 3 | 2.5-3.5 | 低 |
| anaer | 厌氧胁迫系数 | - | 0.02 | 0.01-0.02 | 低 |

### 2.5 敏感性分析结果

#### EFAST方法结果
##### 主效应指数(Si)显著参数
1. 田间持水量(fc): 0.35-0.42
2. 萎蔫点(pwp): 0.32-0.38
3. 生长周期(mat): 0.30-0.35
4. 最大根深(rtx): 0.25-0.30
5. 衰老积温(sen): 0.20-0.25

##### 总效应指数(STi)显著参数
1. 播种日期(dos): 0.45-0.50
2. 生长周期(mat): 0.40-0.45
3. 田间持水量(fc): 0.38-0.42
4. 衰老积温(sen): 0.35-0.40
5. 萎蔫点(pwp): 0.35-0.40

#### Morris方法结果
##### 高敏感性参数 (μ* > 0.5)
1. 播种日期(dos): μ*=0.8-1.2, σ=0.6-0.9
2. 生长周期(mat): μ*=0.7-1.0, σ=0.5-0.8
3. 衰老积温(sen): μ*=0.6-0.9, σ=0.4-0.7
4. 田间持水量(fc): μ*=0.6-0.8, σ=0.3-0.5
5. 萎蔫点(pwp): μ*=0.5-0.7, σ=0.3-0.5

##### 中等敏感性参数 (0.1 < μ* < 0.5)
1. 开花积温(flo): μ*=0.4-0.6, σ=0.3-0.5
2. 最大根深(rtx): μ*=0.3-0.5, σ=0.2-0.4
3. 水分胁迫系数(psen): μ*=0.3-0.4, σ=0.2-0.3
4. 水分生产力(WP*): μ*=0.2-0.3, σ=0.1-0.2
5. 收获指数(HIo): μ*=0.2-0.3, σ=0.1-0.2

### 2.6 参数交互作用

#### 强交互参数组
1. 物候参数组
   - dos-mat: 播种日期与生长周期
   - mat-sen: 生长周期与衰老时间
   - flo-sen: 开花与衰老时间

2. 水分参数组
   - fc-pwp: 田间持水量与萎蔫点
   - fc-rtx: 田间持水量与根深
   - psen-psto: 衰老与气孔胁迫系数

#### 弱交互参数组
1. 生长参数组
   - CGC-CCx: 冠层生长与最大覆盖度
   - HIo-exc: 收获指数与衰减系数
   - WP*-biomass: 水分生产力相关

2. 胁迫参数组
   - polmn-polmx: 授粉温度范围
   - anaer-aer: 通气相关参数

### 2.7 气候条件影响

#### 干旱条件特征
- 土壤水分参数(fc, pwp)敏感性增强
- 根系参数(rtx)影响加大
- 物候参数(dos, mat)保持高敏感性
- 水分胁迫系数(psen, psto)更显重要

#### 湿润条件特征
- 物候参数(dos, mat, sen, flo)更为关键
- 生长发育参数影响增强
- 土壤水分参数敏感性降低
- 温度胁迫参数作用增加

## 3. 详细运行过程

### 3.1 环境准备
1. MATLAB环境配置
   - 安装MATLAB R2019b或更高版本
   - 安装Statistics and Machine Learning Toolbox
   - 安装Parallel Computing Toolbox (推荐)

2. 工作目录设置
   ```matlab
   % 添加项目路径
   addpath(genpath('path/to/AquaCropGSA'));
   
   % 设置工作目录
   cd('path/to/AquaCropGSA');
   ```

3. 数据准备
   - 准备气象数据文件(daily_weather.txt)
   - 准备土壤数据文件(soil_data.txt)
   - 准备作物参数文件(crop_param.txt)

### 3.2 参数配置过程
1. 编辑 Parameters_def.m
   ```matlab
   % 设置参数范围示例
   vs_factors_def.CGC.range = [0.005 0.012];
   vs_factors_def.CCx.range = [0.85 0.98];
   vs_factors_def.CDC.range = [0.001 0.003];
   ```

2. 配置 fileinput.m
   ```matlab
   % EFAST方法配置
   fileinput.vs_method_options.EFAST.NsIni = 1250;  % 基础样本量
   fileinput.vs_method_options.EFAST.Nrep = 5;      % 重复次数
   
   % Morris方法配置
   fileinput.vs_method_options.Morris.p = 8;        % 网格级别
   fileinput.vs_method_options.Morris.r = 20;       % 轨迹数
   fileinput.vs_method_options.Morris.delta = 2/3;  % 扰动步长
   ```

### 3.3 EFAST分析执行步骤
1. 运行EFAST分析
   ```matlab
   % 执行EFAST分析
   [v_in_mat,v_Ns,v_w,v_in_mat_real,v_out_mat,vs_indices,CC_m] = ...
       EFAST(fileinput,vs_factors_def,Param,v_lib_dir);
   ```

2. 结果处理
   ```matlab
   % 处理EFAST结果
   Process_data('EFAST', v_out_mat, vs_indices);
   
   % 生成图表
   Plot_results('EFAST');
   ```

3. 分析过程
   - 计算主效应指数(Si)
   - 计算总效应指数(STi)
   - 评估参数重要性
   - 分析参数交互作用

### 3.4 Morris分析执行步骤
1. 运行Morris分析
   ```matlab
   % 执行Morris分析
   [v_in_mat,v_in_mat_real,v_out_mat,vs_indices,CC_m] = ...
       Morris(fileinput,vs_factors_def,Param,v_lib_dir);
   ```

2. 结果处理
   ```matlab
   % 处理Morris结果
   Process_data('Morris', v_out_mat, vs_indices);
   
   % 生成图表
   Plot_results('Morris');
   ```

3. 分析过程
   - 计算μ*值(修正平均值)
   - 计算σ值(标准差)
   - 绘制μ*-σ散点图
   - 识别重要参数

### 3.5 结果分析流程
1. 数据整理
   ```matlab
   % 合并EFAST和Morris结果
   Combine_results(EFAST_results, Morris_results);
   
   % 生成综合报告
   Generate_report(combined_results);
   ```

2. 敏感性评估
   - 比较两种方法结果
   - 确定参数重要性排序
   - 分析气候条件影响
   - 评估参数交互作用

3. 结果验证
   - 交叉验证分析结果
   - 检查结果一致性
   - 评估结果可靠性

### 3.6 具体分析示例
1. EFAST分析示例
   ```matlab
   % 示例：分析播种日期(dos)的敏感性
   dos_Si = vs_indices.EFAST.Si(dos_index);    % 主效应指数
   dos_STi = vs_indices.EFAST.STi(dos_index);  % 总效应指数
   
   % 计算相对重要性
   dos_importance = dos_STi / sum(vs_indices.EFAST.STi);
   ```

2. Morris分析示例
   ```matlab
   % 示例：分析田间持水量(fc)的敏感性
   fc_mu = vs_indices.Morris.mu(fc_index);     % μ*值
   fc_sigma = vs_indices.Morris.sigma(fc_index); % σ值
   
   % 评估参数重要性
   if fc_mu > 0.5 && fc_sigma > 0.5
       disp('fc参数具有高敏感性和强交互作用');
   end
   ```

### 3.7 结果解读指南
1. EFAST结果解读
   - Si > 0.3: 高度敏感
   - 0.1 < Si < 0.3: 中度敏感
   - Si < 0.1: 低度敏感
   - STi >> Si: 存在强交互作用

2. Morris结果解读
   - μ* > 0.5: 高度敏感
   - 0.1 < μ* < 0.5: 中度敏感
   - μ* < 0.1: 低度敏感
   - σ/μ* > 1: 存在强非线性或交互作用

3. 综合分析
   - 比较两种方法结果一致性
   - 考虑气候条件影响
   - 评估参数交互作用
   - 提供参数优化建议

### 3.8 注意事项
1. 计算资源管理
   - EFAST方法计算量大，建议使用并行计算
   - 预留足够磁盘空间(约需10GB)
   - 单次分析可能需要2-4小时

2. 结果保存
   ```matlab
   % 定期保存中间结果
   save('EFAST_interim.mat', 'v_out_mat', 'vs_indices');
   
   % 保存最终结果
   save('sensitivity_results.mat', 'combined_results');
   ```

3. 错误处理
   ```matlab
   % 添加错误处理
   try
       [results] = EFAST(...);
   catch ME
       fprintf('错误信息：%s\n', ME.message);
       % 保存当前状态
       save('error_state.mat');
   end
   ```

### 3.9 结果应用
1. 参数优化建议
   - 优先调整高敏感性参数
   - 考虑参数交互作用
   - 结合实际条件

2. 模型简化建议
   - 识别非重要参数
   - 简化模型结构
   - 提高计算效率

3. 实际应用指导
   - 区域尺度应用建议
   - 不同气候条件下的参数调整
   - 模型预测能力评估
