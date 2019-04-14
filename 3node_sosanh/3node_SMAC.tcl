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

set opt(ifqlen)		50		;# max packet in ifq
set opt(nn)		5		;# number of nodes
set opt(seed)		0.0
set opt(stop)		700.0		;# simulation time
set opt(tr)		3NodeSMAC.tr	;# trace file
set opt(nam)		3NodeSMAC.nam	;# animation file
set opt(rp)            DumbAgent      ;# routing protocol script
set opt(lm)             "off"           ;# log movement
set opt(agent)          Agent/DSDV
set opt(energymodel)    EnergyModel     ;
#set opt(energymodel)    RadioModel     ;
set opt(radiomodel)    	RadioModel     ;
set opt(initialenergy)  1000            ;# Initial energy in Joules
#set opt(logenergy)      "on"           ;# log energy every 150 seconds

Phy/WirelessPhy set CSThresh_ 1.559e-11
Phy/WirelessPhy set RXThresh_ 3.92405e-8
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

Mac/SMAC set syncFlag_ 1

Mac/SMAC set dutyCycle_ 20

set ns_		[new Simulator]
# $ns_ use-newtrace
set topo	[new Topography]
set tracefd	[open $opt(tr) w]
set namtrace    [open $opt(nam) w]
set prop	[new $opt(prop)]

$topo load_flatgrid $opt(x) $opt(y)
ns-random 1.0
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)
#$ns_ namtrace-all-wireless $namtrace 500 500

#
# Create god
#
#
set god_ [create-god $opt(nn)]

proc UniformErr {} {
	set err [new ErrorModel]
	$err unit pkt
	$err set rate_ 0
	$err ranvar [new RandomVariable/Uniform]
	$err drop-target [new Agent/Null]
	return $err
}

#global node setting

        $ns_ node-config -adhocRouting AODV \
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

$node_(2) set X_ 184.744912601456
$node_(2) set Y_ 261.871089067788
$node_(2) set Z_ 0.000000000000
$node_(1) set X_ 230.805718197857
$node_(1) set Y_ 228.918089067788
$node_(1) set Z_ 0.000000000000
$node_(0) set X_ 275.211569157453
$node_(0) set Y_ 185.706089067788
$node_(0) set Z_ 0.000000000000

$god_ set-dist 0 1 2
$god_ set-dist 0 2 1
$god_ set-dist 1 2 1

 $ns_ at 5.000000000000 "$node_(0) setdest 275.211569157453 185.706089067788 0.000000000000"
 $ns_ at 5.000000000000 "$node_(1) setdest 230.805718197857 228.918089067788 0.000000000000"
 $ns_ at 5.000000000000 "$node_(2) setdest 184.7449126014563  261.871089067788 0.000000000000"

$node_(3) set X_  274.412912601456
$node_(3) set Y_ 264.456089067788
$node_(3) set Z_ 0.000000000000
$node_(4) set X_ 184.098569157453
$node_(4) set Y_ 189.503089067788
$node_(4) set Z_ 0.000000000000

$god_ set-dist 3 1 4
$god_ set-dist 3 4 1
$god_ set-dist 1 4 1

 $ns_ at 5.000000000000 "$node_(3) setdest 274.412912601456 264.456089067788 0.000000000000"
 $ns_ at 5.000000000000 "$node_(4) setdest 184.098569157453 189.503089067788 0.000000000000"

Agent/UDP set packetSize_ 2000

set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(2) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
# $cbr_(0) set rate_ 1Kb
$cbr_(0) set packetSize_ 50
$cbr_(0) set interval_ 10.0
$cbr_(0) set random_ 1
$cbr_(0) set maxpkts_ 50000
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)

set udp_(1) [new Agent/UDP]
$ns_ attach-agent $node_(3) $udp_(1)
set null_(1) [new Agent/Null]
$ns_ attach-agent $node_(4) $null_(1)
set cbr_(1) [new Application/Traffic/CBR]
# $cbr_(0) set rate_ 1Kb
$cbr_(1) set packetSize_ 50
$cbr_(1) set interval_ 10.0
$cbr_(1) set random_ 1
$cbr_(1) set maxpkts_ 50000
$cbr_(1) attach-agent $udp_(1)
$ns_ connect $udp_(1) $null_(1)

$ns_ at 50.00 "$cbr_(0) start"
$ns_ at 50.00 "$cbr_(1) start"
$ns_ at 650.00 "$cbr_(0) stop"
$ns_ at 650.00 "$cbr_(1) stop"
#$ns_ at 177.000		"$node_(0) set ifqLen"


#
# Tell all the nodes when the simulation ends
#
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop) "$node_($i) reset";
}
$ns_ at $opt(stop) "puts \"NS EXITING...\" ; $ns_ halt"

set b [$node_(0) set mac_(0)]
#set c [$b set freq_]
set d [Mac/SMAC set syncFlag_]

#set e [$node_(0) set netif_(0)]
 
#set c [$e set L_]
set c [Mac/SMAC set dutyCycle_]
#puts $tracefd "M 0.0 nn $opt(nn) x $opt(x) y $opt(y) rp $opt(rp)"
#puts $tracefd "M 0.0 sc $opt(sc) cp $opt(cp) seed $opt(seed)"
#puts $tracefd "M 0.0 prop $opt(prop) ant $opt(ant)"
#puts $tracefd "V $b : $c : $d :"
puts "Starting Simulation..."
$ns_ run
