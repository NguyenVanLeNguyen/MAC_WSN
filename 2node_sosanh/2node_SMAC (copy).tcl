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
set opt(nn)		2		;# number of nodes
set opt(seed)		0.0
set opt(stop)		1000.0		;# simulation time
set opt(tr)		MyTest.tr	;# trace file
set opt(nam)		MyTest.nam	;# animation file
set opt(rp)             DumbAgent       ;# routing protocol script
set opt(lm)             "off"           ;# log movement
set opt(agent)          Agent/DSDV
set opt(energymodel)    EnergyModel     ;
#set opt(energymodel)    RadioModel     ;
set opt(radiomodel)    	RadioModel     ;
set opt(initialenergy)  1000            ;# Initial energy in Joules
#set opt(logenergy)      "on"           ;# log energy every 150 seconds
Phy/WirelessPhy set RXThresh_ 2.17468e-08

Mac/SMAC set syncFlag_ 1
Mac/SMAC set selfConfigFlag_ 1
Mac/SMAC set dutyCycle_ 10
set ns_		[new Simulator]

# $ns_ use-newtrace
set topo	[new Topography]
set tracefd	[open $opt(tr) w]
set namtrace    [open $opt(nam) w]
set prop	[new $opt(prop)]

$topo load_flatgrid $opt(x) $opt(y)
# ns-random 1.0
$ns_ trace-all $tracefd
$ns_  set PhyTrace_   ON

#$ns_ namtrace-all-wireless $namtrace 500 500

#
# Create god
#
create-god $opt(nn)

proc UniformErr {} {
	set err [new ErrorModel]
	$err unit pkt
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
			 -macTrace ON \
			 -phyTrace ON\
			 -energyModel $opt(energymodel) \
			 -idlePower 1.0 \
			 -rxPower 1.2 \
			 -txPower 10.0 \
          	 -sleepPower 0.001 \
          	 -transitionPower 0.02 \
        	 -transitionTime 0.005 \
			 -initialEnergy 2000 \
			 -IncomingErrProc UniformErr

	
	$ns_ set WirelessNewTrace_ ON

	for {set i 0} {$i < $opt(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
	}
	
$node_(1) set X_ 147.805718197857
$node_(1) set Y_ 305.918089067788
$node_(1) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(1) 20
$node_(0) set X_ 166.744569157453
$node_(0) set Y_ 233.918089067788
$node_(0) set Z_ 0.000000000000
$ns_ initial_node_pos $node_(0) 20

Agent/UDP set packetSize_ 1000

set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(0) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(1) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
# $cbr_(0) set rate_ 50kb
$cbr_(0) set packetSize_ 50
$cbr_(0) set interval_ 2.866
$cbr_(0) set maxpkts_ 1000
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)




 # $ns_ at 62 "$cbr_(0) start"
 $ns_ at 41.2 "$cbr_(0) start"
 $ns_ at 49.00 "$cbr_(0) stop"
 $ns_ at 150.465005 "$cbr_(0) start"
 $ns_ at 850.00 "$cbr_(0) stop"
 # $ns_ at 650 "Mac/SMAC set dutyCycle_ 0"
#$ns_ at 177.000		"$node_(0) set ifqLen"


#
# Tell all the nodes when the simulation ends
#
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop) "$node_($i) reset";
}
$ns_ at $opt(stop) "puts \"NS EXITING...\" ; $ns_ halt"

$ns_ at $opt(stop).0001 "stop"
set b [$node_(0) set mac_(0)]
#set c [$b set freq_]
set d [Mac/SMAC set syncFlag_]

#set e [$node_(0) set netif_(0)]
 
#set c [$e set L_]
set c [Mac/SMAC set dutyCycle_]

puts "Starting Simulation..."
$ns_ run
