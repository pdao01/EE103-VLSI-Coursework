*library file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.temp 25
.GLOBAL gnd vdd

vvdd vdd 0 1.05
vgnd gnd 0 0

.param vdd = 1.05
.param vdd_N = -1.05
.param gnd = 0
.param w = 300n
.param l = 100n
.param t = 25

vgs_n g_n gnd vdd
vds_n d_n gnd vdd
vbs_n b_n gnd gnd

vgs_p g_p vdd vdd_N
vds_p d_p vdd vdd_N
vbs_p b_p vdd gnd

.model n105 nmos level=54
M1 d_n g_n gnd b_n n105 W=w L=l T=t

.model p105 pmos level=54
M2 d_p g_p vdd b_p p105 W=w L=l T=t

*Q1: Ids Versus Vds, Vgs: 1.05, Vds: [0,1.05]
*.dc vds_n 0 1.05 0.01 

*Q2: Velocity saturation (𝒄𝒐𝒙 ∗ 𝝂𝒔𝒂𝒕) (NMOS): Vgs: 1.05; Vds:1.05; vbs:0;
*.dc vds_n 0 1.05 1.05

*Q3: set of Saturation Voltage (𝑽𝑫𝑺𝒂𝒕) (NMOS): Vgs: 0:0.2:1.05; Vds:1.05; vbs:0
*.dc vgs_n 0 1.05 0.2
.dc vds_n 0 1.05 0.01 sweep vgs_n 0 1.05 0.2

*Q4: Sub-threshold slope factor (NMOS): Vgs: [0,1.05]; Vds: 1.05; Vbs: 0;
*.dc vgs_n 0 1.05 0.01

*Q5: Body effect (𝒌𝜸) (NMOS): Vgs:1.05; Vds:1.05; Vsb: [-1.05,1.05];
*.dc vbs_n -1.05 1.05 0.01

*Q6: Beta (β) (NMOS) (Consider the Channel Length Modulation): Vgs: 1.05; Vds: 1.05; Vbs: 0
*.dc vds_n 0 1.05 1.05

*Q7: NMOS and PMOS mobility ratio (μ𝒏/μ𝒑): 
*NMOS: Vgs: 1.05; Vds: 1.05; Vbs: 0
*.dc vds_n 0 1.05 1.05
*PMOS: Vgs: -1.05; Vds: -1.05; Vbs: 0
*.dc vds_p -1.05 0 1.05

*Q8: Critical Voltage: 𝑽𝒄 = 𝑬𝒄 ∗ 𝑳 (NMOS): Vgs: 1.05; Vds: 1.05; Vbs: 0;
*.dc vds_n 0 1.05 1.05

*Q9: 𝑰𝑫𝑺𝒂𝒕 (NMOS): Vgs: 1.05; Vds: 1.05; Vbs: 0;
*.dc vds_n 0 1.05 1.05


.PROBE DC i(M1)
.PROBE lv9(M1)
.PROBE DC i(M2)
.PROBE lv9(M2)
.PRINT i(M1)
*.PRINT i(M2)
.PRINT lv9(M1)
.PRINT lv10(M1)
*.PRINT lv9(M2)
*.PRINT lv10(M2)
*.PRINT DC Lx282(M1)
*.PRINT DC MOBEFF(M1)
.end
