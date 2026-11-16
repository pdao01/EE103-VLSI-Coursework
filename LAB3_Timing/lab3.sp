Inverter

*library file
.lib '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/tech/hspice/saed32nm.lib' TT
.include '/usr/cots/synopsys/UniversityLibrary/SAED32_EDK/lib/stdcell_rvt/hspice/saed32nm_rvt.spf'

*post the results
*.option post
.global vdd gnd

*define model
.model n105 nmos level=54
.model p105 pmos level=54

*source declaration
vvdd vdd 0 vdd *syntax:vname pos_node neg_node voltage_value
vgnd gnd 0 0v

M1 vo vi gnd gnd n105 W=w_n L=l_n
M2 vo vi vdd vdd p105 W=w_p L=l_p

*Load inverters
*syntax: Model_name Drain Gate Source Bulk Model (Width; Length; etc.)
M3 vo1 vo gnd gnd n105 W=300n L=l_n
M4 vo1 vo vdd vdd p105 W=600n L=l_p

M3 vo2 vo gnd gnd n105 W=300n L=l_n
M4 vo2 vo vdd vdd p105 W=600n L=l_p

*define parameters
.param vdd = 1.05
.param l_n = 100n
.param l_p = 100n
.param w_n = 300n
.param w_p = 600n
.param trf = 6p *initial rise/fall time of the transient source
.param del = 1u
.param pw = 1u
.param per = 2u

*define analysis voltage
vinput vi gnd pulse 0 vdd del trf trf pw per
.tran 1p 6u

.measure tran outrise
+trig v(vo) val='vdd*0.1' rise=2
+targ v(vo) val='vdd*0.9' rise=2

.measure tran outfall
+trig v(vo) val='vdd*0.9' fall=2
+targ v(vo) val='vdd*0.1' fall=2

.measure tran tphl
+trig v(vi) val='vdd*0.5' rise=2
+targ v(vo) val='vdd*0.5' fall=2

.measure tran tplh
+trig v(vi) val='vdd*0.5' fall=2
+targ v(vo) val='vdd*0.5' rise=2

.measure tran tp PARAM='(tphl+tplh)/2'
.measure tran wn_used PARAM='w_n'
.measure tran wp_used PARAM='w_p'

*Question 3:
*VIN vi 0 DC 0
*.dc VIN 0 vdd 0.01 sweep w_p 100n 1000n 100n
*.probe dc V(vi) V(vo)

*Question 5:
*.alter
*.param vdd = 0.5
*.alter
*.param vdd = 0.6
*.alter
*.param vdd = 0.7
*.alter
*.param vdd = 0.8
*.alter
*.param vdd = 0.9
*.alter
*.param vdd = 1.0

*Question 6:
.alter
.param w_n = 300n
.param w_p = 600n

.alter
.param w_n = 600n
.param w_p = 1200n

.alter
.param w_n = 900n
.param w_p = 1800n

.alter
.param w_n = 1200n
.param w_p = 2400n

.alter
.param w_n = 1500n
.param w_p = 3000n

.alter
.param w_n = 1800n
.param w_p = 3600n

.end