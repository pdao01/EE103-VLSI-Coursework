.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
* .option post
.option CAPTAB=1 *Measure the input Capacitance at all nodes
.global vdd gnd

*define model
.model n105 nmos level=54
.model p105 pmos level=54

*source declaration
vvdd vdd 0 vdd *syntax:vname pos_node neg_node voltage_value
vgnd gnd 0 0v

.param vdd = 1.05
.param l = 100n
.param w_n = 300n
.param w_p = 600n

*The goal is to create an inverter chain that contains multiple different CMOS, 
*this use sub0circuits command
*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)

*Inverter chain 1: 1 Inverter
M1_1 vo1 vi gnd gnd n105 W=w_n L=l
M1_2 vo1 vi vdd vdd p105 W=w_p L=l
********************************************************************************
*Question 1c,d
*Inverter chain 2: 2 Inverters
*Inverter 1
.subckt inv2_1 vi vo2_1
M2_1 vo2_1 vi gnd gnd n105 W=w_n L=l
M2_2 vo2_1 vi vdd vdd p105 W=w_p L=l
.ends

*Inverter 2
.subckt inv2_2 vo2_1 vo2
M2_3 vo2 vo2_1 gnd gnd n105 W=w_n L=l
M2_4 vo2 vo2_1 vdd vdd p105 W=w_p L=l
.ends

X2_1 vi vo2_1 inv2_1
X2_2 vo2_1 vo2 inv2_2
********************************************************************************

*Inverter chain 3: 3 Inverters
*Inverter 1
.subckt inv3_1 vi vo3_1
M3_1 vo3_1 vi gnd gnd n105 W=w_n L=l
M3_2 vo3_1 vi vdd vdd p105 W=w_p L=l
.ends

*Inverter 2
.subckt inv3_2 vo3_1 vo3_2
M3_3 vo3_2 vo3_1 gnd gnd n105 W=w_n L=l
M3_4 vo3_2 vo3_1 vdd vdd p105 W=w_p L=l
.ends

*Inverter 3
.subckt inv3_3 vo3_2 vo3
M3_5 vo3 vo3_2 gnd gnd n105 W=w_n L=l
M3_6 vo3 vo3_2 vdd vdd p105 W=w_p L=l
.ends

X3_1 vi vo3_1 inv3_1
X3_2 vo3_1 vo3_2 inv3_2
X3_3 vo3_2 vo3 inv3_3
********************************************************************************

*Inverter chain 4: 4 Inverters
*Inverter 1
.subckt inv4_1 vi vo4_1
M4_1 vo4_1 vi gnd gnd n105 W=w_n L=l
M4_2 vo4_1 vi vdd vdd p105 W=w_p L=l
.ends

*Inverter 2
.subckt inv4_2 vo4_1 vo4_2
M4_3 vo4_2 vo4_1 gnd gnd n105 W=w_n L=l
M4_4 vo4_2 vo4_1 vdd vdd p105 W=w_p L=l
.ends

*Inverter 3
.subckt inv4_3 vo4_2 vo4_3
M4_5 vo4_3 vo4_2 gnd gnd n105 W=w_n L=l
M4_6 vo4_3 vo4_2 vdd vdd p105 W=w_p L=l
.ends

*Inverter 4
.subckt inv4_4 vo4_3 vo4
M4_7 vo4 vo4_3 gnd gnd n105 W=w_n L=l
M4_8 vo4 vo4_3 vdd vdd p105 W=w_p L=l
.ends

X4_1 vi vo4_1 inv4_1
X4_2 vo4_1 vo4_2 inv4_2
X4_3 vo4_2 vo4_3 inv4_3
X4_4 vo4_3 vo4 inv4_4
********************************************************************************

.param trf = 4p
.param del = 2u
.param per = 10u
.param pw = 5u

cload1 vo1 gnd 175.2256f
cload2 vo2 gnd 175.2256f
cload3 vo3 gnd 175.2256f
cload4 vo4 gnd 175.2256f

*define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per

*Set up an optimization model
*Syntax: .MODEL ModelName OPT …
* .model opt1 opt 

*Define the parameter to be optimized
*Syntax: .PARAM parameter=OPTxxx (init., min, max)
* .param w_p = OPTrange(400n, 200n, 1000n) 

* .dc vinput 0 1.05 0.01 sweep optimize=optrange Results=wid Model=opt1
* .measure DC wid FIND V(vi) WHEN V(vo1)='0.5*vdd' goal='vdd/2'
.tran 1p 30u

*tell the optimization goal
*Syntax: .measure <MeasureName> <MeasureClause> GOAL=<GoalValue>
.measure tran tphl1 trig v(vi) val='vdd*0.5' rise=2 targ v(vo1) val='vdd*0.5' fall=2 *output from high to low
.measure tran tplh1 trig v(vi) val='vdd*0.5' fall=2 targ v(vo1) val='vdd*0.5' rise=2 *output from low high
.measure tran tpd1 param='(tphl1+tplh1)/2'
* .measure tran tpd1 param='(tphl1+tplh1)/2' GOAL=0
*.measure tran tdiff param='abs(tplh1-tphl1)' GOAL=0

*Question 1c,d
.measure tran tphl2 trig v(vi) val='vdd*0.5' fall=2 targ v(vo2) val='vdd*0.5' fall=2
.measure tran tplh2 trig v(vi) val='vdd*0.5' rise=2 targ v(vo2) val='vdd*0.5' rise=2
.measure tran tpd2 param='(tphl2+tplh2)/2'

.measure tran tphl3 trig v(vi) val='vdd*0.5' rise=2 targ v(vo3) val='vdd*0.5' fall=2
.measure tran tplh3 trig v(vi) val='vdd*0.5' fall=2 targ v(vo3) val='vdd*0.5' rise=2
.measure tran tpd3 param='(tphl3+tplh3)/2'

.measure tran tphl4 trig v(vi) val='vdd*0.5' fall=2 targ v(vo4) val='vdd*0.5' fall=2
.measure tran tplh4 trig v(vi) val='vdd*0.5' rise=2 targ v(vo4) val='vdd*0.5' rise=2
.measure tran tpd4 param='(tphl4+tplh4)/2' 

*Sum up in analysis method
*Syntax: .Tran <Step> <Period> Sweep Optimize=OPTxxx Results=measure Model=Optmod
* .tran 1p '3*per' sweep optimize=OPTrange RESULTS=tdiff MODEL=OPT1
* .tran 1p '3*per' sweep optimize=OPTrange RESULTS=tpd1 MODEL=OPT1

.end