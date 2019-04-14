# Type: perl Latency.pl <trace file> <sendnode> <tonode>
$infile=$ARGV[0];
$tonode=$ARGV[2];
$sendnode = $ARGV[1];
$start_time=0;
$end_time=0;
$sum=0;
print STDOUT "infile : $infile \n";
print  STDOUT "tonode : $tonode \n";

@send = (0..0);
@recv = (0..0);
$max_pktid = 0;
$num = 0;

open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
@x = split(' ');
#checking if the event corresponds to a reception
if ($x[0] eq 's'  && $x[23] =~ /^$tonode/ && $x[3] eq 'AGT' && $x[22] =~ /^\[$sendnode/ ) {
	$pkts_= substr $x[26], 1, -1;	
	
	if(!$send[$pkts_]){
		$send[$pkts_] = $x[1];
		$max_pktid = $pkts_ if ($max_pktid < $pkts_);
	}
	print STDOUT "send:$x[5] $x[1] $x[27] \n";
}
if ($x[0] eq 'r'  && $x[23] =~ /^$tonode/ && $x[3] eq 'AGT' && $x[22] =~ /^\[$sendnode/ ) {
	$pktr_= substr $x[26], 1, -1;
	$recv[$pktr_] = $x[1];
	$num++;
	print STDOUT "recv:$x[5] $x[1] $x[27]  ";
}
}
$result;
$delay = 0;

for ($count = 0; $count <= $max_pktid; $count ++) {
	if ($send[$count] && $recv[$count]) {
	$send_ = $send[$count];
	$recv_ = $recv[$count];
	$delay = $delay + ($recv_ - $send_);
	}
}
$avg_delay = $delay / $num;
print STDOUT "delay  $delay \n";
print STDOUT "num  $num \n";
print STDOUT "Avg delay( src node = $sendnode; \
dst node = $tonode) = $avg_delay(s)\n";
# ------------------------------

close DATA;
exit(0);
