*library file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
.option post
.GLOBAL gnd vdd

vvdd vdd 0 1.1
vgnd gnd 0 0

.param vdd = 1.1
.param vdd_N = -1.1
.param l_n = 100n
.param l_p = 100n

vgs_n g_n gnd vdd *connect + to g and - to gnd and assign value 1.1
vds_n d_n gnd vdd
vbs_n b_n gnd 0

vgs_p g_p vdd vdd_N *connect + to g and - to gnd and assign value 1.1
vds_p d_p vdd vdd_N
vbs_p b_p vdd 0

.model n105 nmos level=54
M1 d_n g_n gnd b_n n105 W=300n L=l_n 

.model p105 pmos level=54
M2 d_p g_p vdd b_p p105 W=300n L=l_p

*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)

*Part 1: Ids vs. Vgs (sw0 and sw1)
*.dc vgs_n 0 1.1 0.01 sweep vds_n 0 1.1 0.2
*.dc vgs_p -1.1 0 0.01 sweep vds_p -1.1 0 0.2

*Part 2: Ids vs. Vds (sw2 and sw3)
*.dc vds_n 0 1.1 0.01 sweep vgs_n 0 1.1 0.2
*.dc vds_p -1.1 0 0.01 sweep vgs_p -1.1 0 0.2

*Part 3: Sub-threshold swing (sw4 and sw5)
*.dc vgs_n 0 1.1 0.01 sweep vds_n 0 1.1 1.1
*.dc vgs_p -1.1 0 0.01 sweep vds_p -1.1 0 1.1

*Part 4: Body effect (sw6 and sw7)
*.dc vbs_n -1.1 1.1 0.01
*.dc vbs_p -1.1 1.1 0.01

*Part 5: DIBL Vds vs. Vth (sw8 and sw9)
*.dc vds_n 0 1.1 0.01 
*.dc vds_p -1.1 0 0.01 

*Part 6: DIBL Length vs. Vth (sw10 and sw11)
*M1 d g gnd b n105 W=300n L=l_n
*.dc l_n 50n 200n 1n
*.dc l_p 50n 200n 1n

*Part 7: Temp vs. Vth (sw12)
.dc temp -55 125 5

.PROBE DC i(M1) *probe transistor current (Ids)
.PROBE DC i(M2)
.PROBE lv9(M1) *probe threshold voltage (Vt) --> for body effect
.PROBE lv9(M2)
.PRINT lv9(M1) *print and store all the swept threshold voltage value in .lis
.end