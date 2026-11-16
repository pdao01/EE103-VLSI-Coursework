Inverter

*library file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.GLOBAL gnd vdd

vvdd vdd 0 1.1
vgnd gnd 0 0
vgs_n g_n gnd 1.1
vds_n d_n gnd 1.1
vbs_n b_n gnd 1.1
vgs_p g_p vdd -1.1
vds_p d_p vdd -1.1
vbs_p b_p vdd -1.1

.model n105 nmos level=54
.model p105 pmos level=54

M1 d_n g_n gnd b_n n105 W=300n L=100n
M2 d_p g_p vdd b_p p105 W=300n L=100n
*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)



      
*.dc vgs_n 0 1.1 0.01 sweep vds_n 0 1.1 0.2         *Ids vs Vds
*.dc vgs_n 0 1.05 0.01                               *vgs vs ids  sub threshhold	  
*.dc temp -55 125 5

*M1 d g gnd b n105 W=300n L=l_n
*.dc l_n 20n 150n 1n

.dc vbs_n -1.1 1.1 0.05
.dc vbs_p -1.1 1.1 0.05

.PROBE DC i(M1)                              *probe transistor current (Ids)
.PROBE DC i(M2)   
.PROBE lv9(M1)                                *probe threshold voltage  (Vt)
.PROBE lv9(M2) 
.PRINT lv9(M1)                                  *print and store all the swept threshold voltage value in .lis file
.end