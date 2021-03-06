set opt(chan)		Channel/WirelessChannel
set opt(prop)		Propagation/TwoRayGround
set opt(netif)		Phy/WirelessPhy
# set opt(mac)            Mac/802_11                   ;# MAC type
set opt(mac)            Mac/SMAC                   ;# MAC type
set opt(ifq)		Queue/DropTail/PriQueue
set opt(ll)		LL
set opt(ant)            Antenna/OmniAntenna

set opt(x)		800	;# X dimension of the  topography
set opt(y)		800		;# Y dimension of the topography
set opt(cp)		"../mobility/scene/cbr-50-10-4-512"
set opt(sc)		"../mobility/scene/scen-670x670-50-600-20-0"

set opt(ifqlen)		50	;# max packet in ifq
set opt(nn)		4		;# number of nodes
set opt(seed)		0.0
set opt(stop)		500.0		;# simulation time
# set opt(tr)		MyTest.tr	;# trace file
# set opt(nam)		MyTest.nam	;# animation file
set opt(tr)		../Trace/SMACtrace-4node-10.tr	;# trace file
set opt(nam)		../Trace/SMACnam.nam	;# animation file
set opt(rp)             DumbAgent       ;# routing protocol script
set opt(lm)             "off"           ;# log movement
set opt(agent)        Agent/DSDV;
set opt(energymodel)    EnergyModel    ;
#set opt(energymodel)    RadioModel     ;
set opt(radiomodel)    	RadioModel     ;
set opt(initialenergy)  1000            ;# Initial energy in Joules
#set opt(logenergy)      "on"           ;# log energy every 150 seconds

set opt(ratecbr) 0.5Kb

Mac/SMAC set syncFlag_ 1

Mac/SMAC set dutyCycle_ 10

set ns_		[new Simulator]
set topo	[new Topography]
set tracefd	[open $opt(tr) w]
set namtrace    [open $opt(nam) w]
set prop	[new $opt(prop)]

$topo load_flatgrid $opt(x) $opt(y)
ns-random 1.0
$ns_ trace-all $tracefd
$ns_ namtrace-all-wireless $namtrace $opt(x) $opt(y)

#
# Create god
#
#
set god_ [create-god $opt(nn)]
proc UniformErr {} {
	set err [new ErrorModel]
	$err unit pkt
	$err set rate_ 0.1
	$err ranvar [new RandomVariable/Uniform]
	$err drop-target [new Agent/Null]
	return $err
}
#global node setting

       $ns_ node-config -adhocRouting $opt(rp) \
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
						-initialEnergy $opt(initialenergy)
						# -IncomingErrProc UniformErr

	$ns_ set WirelessNewTrace_ ON
#set AgentTrace			ON
#set RouterTrace		OFF
#set MacTrace			ON

	for {set i 0} {$i < $opt(nn) } {incr i} {
		set node_($i) [$ns_ node]
		$node_($i) random-motion 0		;# disable random motion
	}



# set udp_(0) [new Agent/UDP]
# $ns_ attach-agent $node_(0) $udp_(0)
# set null_(0) [new Agent/Null]
# $ns_ attach-agent $node_(1) $null_(0)
# set cbr_(0) [new Application/Traffic/CBR]
# $cbr_(0) set rate_ 449Kb
# $cbr_(0) set packetSize_ 512

# $cbr_(0) set random_ 1
# $cbr_(0) set maxpkts_ 50000
# $cbr_(0) attach-agent $udp_(0)
# $ns_ connect $udp_(0) $null_(0)
# $ns_ at 50.0 "$cbr_(0) start"
# 4 connecting to 5 at time 107.69501429409489
#
$node_(2) set X_ 199.039549003408
$node_(2) set Y_ 474.789092300025
$node_(2) set Z_ 0.000000000000
$node_(1) set X_ 339.390873576818
$node_(1) set Y_ 46.239510317756
$node_(1) set Z_ 0.000000000000
$node_(0) set X_ 189.082960404748
$node_(0) set Y_ 232.448018127863
$node_(0) set Z_ 0.000000000000
$node_(3) set X_ 48.155010291897
$node_(3) set Y_ 33.873263151766
$node_(3) set Z_ 0.000000000000
$god_ set-dist 0 1 2
$god_ set-dist 0 2 1
$god_ set-dist 0 3 3
$god_ set-dist 1 2 1
$god_ set-dist 1 3 1
$god_ set-dist 2 3 2
$ns_ at 5.000000000000 "$node_(0) setdest 201.543912601456 260.918089067788 0.000000000000"
$ns_ at 5.000000000000 "$node_(1) setdest 401.805718197857 377.307024146398 0.000000000000"
$ns_ at 5.000000000000 "$node_(2) setdest 363.744569157453 109.122403365900 0.000000000000"
$ns_ at 5.000000000000 "$node_(3) setdest 484.836446860801 509.936253762976 0.000000000000"

set udp_(0) [new Agent/UDP]
$ns_ attach-agent $node_(1) $udp_(0)
set null_(0) [new Agent/Null]
$ns_ attach-agent $node_(0) $null_(0)
set cbr_(0) [new Application/Traffic/CBR]
$cbr_(0) set packetSize_ 512
# $cbr_(0) set interval_ 1.6666666666666667
$cbr_(0) set rate_ $opt(ratecbr)
$cbr_(0) set random_ 1
$cbr_(0) set maxpkts_ 500000
$cbr_(0) attach-agent $udp_(0)
$ns_ connect $udp_(0) $null_(0)
#

$ns_ at 50.0 "$cbr_(0) start"

#
# 0 connecting to 1 at time 112.66623783515126
#
set udp_(1) [new Agent/UDP]
$ns_ attach-agent $node_(2) $udp_(1)
set null_(1) [new Agent/Null]
$ns_ attach-agent $node_(0) $null_(1)
set cbr_(1) [new Application/Traffic/CBR]
$cbr_(1) set packetSize_ 512
# $cbr_(1) set interval_ 1.6666666666666667
$cbr_(1) set rate_ $opt(ratecbr)
$cbr_(1) set random_ 1
$cbr_(1) set maxpkts_ 500000
$cbr_(1) attach-agent $udp_(1)
$ns_ connect $udp_(1) $null_(1)
$ns_ at 50.00 "$cbr_(1) start"
# #
# # 5 connecting to 3 at time 84.456630639944521
# #
set udp_(2) [new Agent/UDP]
$ns_ attach-agent $node_(3) $udp_(2)
set null_(2) [new Agent/Null]
$ns_ attach-agent $node_(0) $null_(2)
 
set pareto2 [new Application/Traffic/Pareto]
$pareto2 set packetSize_ 210
$pareto2 set burst_time_ 500ms
$pareto2 set idle_time_ 500ms
$pareto2 set rate_ 200k
$pareto2 set shape_ 1.5
$pareto2 attach-agent $s2

$ns_ connect $udp_(2) $null_(2)
$ns_ at 84.456630639944521 "$cbr_(2) start"


#$ns_ at 177.000		"$node_(0) set ifqLen"


#
# Tell all the nodes when the simulation ends
#
for {set i 0} {$i < $opt(nn) } {incr i} {
    $ns_ at $opt(stop) "$node_($i) reset";
}
$ns_ at $opt(stop) "puts \"NS EXITING...\" ; $ns_ halt"


#puts $tracefd "M 0.0 nn $opt(nn) x $opt(x) y $opt(y) rp $opt(rp)"
#puts $tracefd "M 0.0 sc $opt(sc) cp $opt(cp) seed $opt(seed)"
#puts $tracefd "M 0.0 prop $opt(prop) ant $opt(ant)"
#puts $tracefd "V $b : $c : $d :"
puts "Starting Simulation..."
$ns_ run
