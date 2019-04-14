set opt(chan)		Channel/WirelessChannel
set opt(prop)		Propagation/TwoRayGround
set opt(netif)		Phy/WirelessPhy
# set opt(mac)            Mac/802_11                   ;# MAC type
set opt(mac)            Mac/SMAC                   ;# MAC type
set opt(ifq)		Queue/DropTail/PriQueue
set opt(ll)		LL
set opt(ant)            Antenna/OmniAntenna

set opt(x)		800	;# X dimension of the topography
set opt(y)		800		;# Y dimension of the topography
set opt(cp)		"../mobility/scene/cbr-50-10-4-512"
set opt(sc)		"../mobility/scene/scen-670x670-50-600-20-0"

set opt(ifqlen)		100		;# max packet in ifq
set opt(nn)		10		;# number of nodes
set opt(seed)		0.0
set opt(stop)		600.0		;# simulation time
set opt(tr)		MyTest.tr	;# trace file
set opt(nam)		MyTest.nam	;# animation file
set opt(rp)             AODV       ;# routing protocol script
set opt(lm)             "off"           ;# log movement
set opt(agent)          Agent/DSDV
set opt(energymodel)    EnergyModel     ;
#set opt(energymodel)    RadioModel     ;
set opt(radiomodel)    	RadioModel     ;
set opt(initialenergy)  1000            ;# Initial energy in Joules
#set opt(logenergy)      "on"           ;# log energy every 150 seconds

Mac/SMAC set syncFlag_ 1

Mac/SMAC set dutyCycle_ 10

Phy/WirelessPhy set CSThresh_ 1.559e-11
Phy/WirelessPhy set RXThresh_ 1.76149e-10
Antenna/OmniAntenna set X_ 0
Antenna/OmniAntenna set Y_ 0
Antenna/OmniAntenna set Z_ 1.5 
Antenna/OmniAntenna set Gt_ 1.0
Antenna/OmniAntenna set Gr_ 1.0

# Initialize the SharedMedia interface with parameters to make
# it work like the 914MHz Lucent WaveLAN DSSS radio interface
Phy/WirelessPhy set CPThresh_ 10.0
Phy/WirelessPhy set Pt_ 0.28183815
Phy/WirelessPhy set freq_ 914e+6
Phy/WirelessPhy set L_ 1.0  

set ns_		[new Simulator]
set topo	[new Topography]
set tracefd	[open $opt(tr) w]
set namtrace    [open $opt(nam) w]
set prop	[new $opt(prop)]

$topo load_flatgrid $opt(x) $opt(y)
ns-random 1.0
$ns_ trace-all $tracefd
$ns_ namtrace-all $namtrace
$ns_ namtrace-all-wireless $namtrace 500 500

#
# Create god
#
set god_ [create-god $opt(nn)]
proc UniformErr {} {
	set err [new ErrorModel]
	$err unit bits
	$err set rate_ 0
	$err ranvar [new RandomVariable/Uniform]
	$err drop-target [new Agent/Null]
	return $err
}


#global node setting

        $ns_ node-config -adhocRouting DumbAgent \
			 -llType $opt(ll) \
			 -macType $opt(mac) \
			 -ifqType $opt(ifq) \
			 -ifqLen $opt(ifqlen) \
			 -antType $opt(ant) \
			 -propType $opt(prop) \
			 -phyType $opt(netif) \
			 -channelType $opt(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace ON \
			 -energyModel $opt(energymodel) \
			 -idlePower 1.0 \
			 -rxPower 1.0 \
			 -txPower 1.0 \
          		 -sleepPower 0.001 \
          		 -transitionPower 0.2 \
          		 -transitionTime 0.005 \
			 -initialEnergy 1000 \
			  -IncomingErrProc UniformErr

	
	$ns_ set WirelessNewTrace_ ON
#set AgentTrace			ON
#set RouterTrace		OFF
#set MacTrace			ON

	for {set i 0} {$i < $opt(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
	}
	
#	$node_(1) set agentTrace ON	 
#	$node_(1) set macTrace ON
#	$node_(1) set routerTrace ON		 	
#	$node_(0) set macTrace ON
#	$node_(0) set agentTrace ON	 
#	$node_(0) set routerTrace ON

$node_(2) set X_  374.9241400324
$node_(2) set Y_ 209.275089067788
$node_(2) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(2) 20
$node_(1) set X_ 162.805718197857
$node_(1) set Y_ 333.918089067788
$node_(1) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(1) 20
$node_(0) set X_ 217.744569157453
$node_(0) set Y_ 235.918089067788
$node_(0) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(0) 20

$node_(3) set X_ 82.543912601456
$node_(3) set Y_ 186.918089067788
$node_(3) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(3) 20
$node_(4) set X_ 311.805718197857
$node_(4) set Y_ 141.918089067788
$node_(4) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(4) 20
$node_(5) set X_ 261.744569157453
$node_(5) set Y_ 326.918089067788
$node_(5) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(5) 20

$node_(6) set X_  176.543912601456
$node_(6) set Y_ 155.918089067788
$node_(6) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(6) 20
$node_(7) set X_ 310.805718197857
$node_(7) set Y_ 237.918089067788
$node_(7) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(7) 20
$node_(8) set X_ 132.744569157453
$node_(8) set Y_ 262.918089067788
$node_(8) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(8) 20

$node_(9) set X_ 344.744569157453
$node_(9) set Y_ 305.918089067788
$node_(9) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(9) 20

# $god_ set-dist 0 1 2
# $god_ set-dist 0 2 1
# $god_ set-dist 1 2 1

#  $ns_ at 5.000000000000 "$node_(0) setdest 201.543912601456 228.918089067788 0.000000000000"
#  $ns_ at 5.000000000000 "$node_(1) setdest 230.805718197857 228.918089067788 0.000000000000"
#  $ns_ at 5.000000000000 "$node_(2) setdest 263.744569157453 228.918089067788 0.000000000000"

Agent/UDP set packetSize_ 2000

for {set j 1} {$j < $opt(nn) } {incr j} {

	set udp_($j) [new Agent/UDP]
	$ns_ attach-agent $node_($j) $udp_($j)
	set null_($j) [new Agent/Null]
	$ns_ attach-agent $node_(0) $null_($j)
	set cbr_($j) [new Application/Traffic/CBR]
	# $cbr_($i) set rate_ 10Kb
	$cbr_($j) set packetSize_ 50
	$cbr_($j) set interval_ 10.0
	$cbr_($j) set random_ 1
	$cbr_($j) set maxpkts_ 50000
	$cbr_($j) attach-agent $udp_($j)
	$ns_ connect $udp_($j) $null_($j)
	
}
# set t 0
# set time 50.00
for {set k 1} {$k < $opt(nn) } {incr k} {
	# $t = $t + 5
	# $time =
	# $ns_ at [expr 50.00 + ($k*5)] "$cbr_($k) start"
	# $ns_ at [expr 500.00 + ($k*5)] "$cbr_($k) stop"
	$ns_ at 50 "$cbr_($k) start"
	$ns_ at 550 "$cbr_($k) stop"
}

#$ns_ at 177.000		"$node_(0) set ifqLen"


#
# Tell all the nodes when the simulation ends
#
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop) "$node_($i) reset";
}
$ns_ at $opt(stop) "puts \"NS EXITING...\" ; $ns_ halt"

# set b [$node_(0) set mac_(0)]
# #set c [$b set freq_]
# set d [Mac/SMAC set syncFlag_]

set e [$node_(0) set netif_(0)]
 
#set c [$e set L_]
set c [Mac/SMAC set dutyCycle_]
#puts $tracefd "M 0.0 nn $opt(nn) x $opt(x) y $opt(y) rp $opt(rp)"
#puts $tracefd "M 0.0 sc $opt(sc) cp $opt(cp) seed $opt(seed)"
#puts $tracefd "M 0.0 prop $opt(prop) ant $opt(ant)"
#puts $tracefd "V $b : $c : $d :"
puts "Starting Simulation..."
$ns_ run
