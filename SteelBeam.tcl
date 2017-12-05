wipe
puts "System"

model basic -ndm 3 -ndf 6
# # 结构尺寸
# set width 50
# set height 200
# 节点
puts "restrain"
node 1 0.0 0.0 0.0
node 2 3000.0 0.0 0.0
node 3 500.0 0.0 0.0 
node 4 1000.0 0.0 0.0
node 5 1500.0 0.0 0.0
node 6 2000.0 0.0 0.0
node 7 2500.0 0.0 0.0

puts "nodes"
# 两端简支.整体坐标，ux,uy,uz,rx,ry,rz
fix 1 1 1 1 1 0 1
fix 2 0 1 1 1 0 1
fix 3 0 1 0 1 0 1
fix 4 0 1 0 1 0 1
fix 5 0 1 0 1 0 1
fix 6 0 1 0 1 0 1
fix 7 0 1 0 1 0 1
puts "material"
# 硬化系数为0.00001，屈服段基本水平
uniaxialMaterial Steel01 1 235 200000 0.00001

set sectionWidth 50
set sectionDepth 200

set y1 [expr $sectionWidth/2.0]
set z1 [expr $sectionDepth/2.0]
section Fiber 1  {
	# 矩形分割：材料号，y方向分为1，z方向分为10(条带)，起点y、z，终点y、z（起点终点为矩形的对角点，原点在整个截面的中心）
	patch rect 1 10 10 [expr -$y1] [expr -$z1] [expr $y1] [expr $z1]
}

puts "transformation"
# 定义梁柱单元的局部坐标轴：编号，输入2轴的轴矢量（单位矢量）
geomTransf Linear 1 0.0 0.0 1.0
puts "element"
#沿单元长度有5个积分点？
set np 5
# 单元号，节点1，节点2，积分数，截面号，局部坐标轴的编号
# element nonlinearBeamColumn 1 1 3 $np 1 1
# element nonlinearBeamColumn 2 3 4 $np 1 1
# element nonlinearBeamColumn 3 4 5 $np 1 1
# element nonlinearBeamColumn 4 5 6 $np 1 1
# element nonlinearBeamColumn 5 6 7 $np 1 1
# element nonlinearBeamColumn 6 7 2 $np 1 1
# new command is forceBeamColumn
element forceBeamColumn 1 1 3 $np 1 1
element forceBeamColumn 2 3 4 $np 1 1
element forceBeamColumn 3 4 5 $np 1 1
element forceBeamColumn 4 5 6 $np 1 1
element forceBeamColumn 5 6 7 $np 1 1
element forceBeamColumn 6 7 2 $np 1 1

puts "recorder"
recorder Node -file node5.out -time -node 5 -dof 3 disp

puts "loading"
# 跨中集中力
set P 100
pattern Plain 1 Linear  {
	load 5 0.0 0.0 [expr -$P] 0.0 0.0 0.0
}

puts "analysis"
# 约束边界处理：：
constraints Plain
numberer RCM
# 矩阵带宽处理采用一般的方法（General）
system BandGeneral
# 收敛准则
test NormDispIncr 1.0e-12 10 3
# 非线性算法：牛顿
algorithm Newton
# 位移控制，监测节点5，自由度3（整体坐标），每步位移向下0.1mm
integrator DisplacementControl 5 3 -0.1
analysis Static
# 100步，最终的位移为0.1×100=10mm
analyze 300

print node 5
# print ele 1
