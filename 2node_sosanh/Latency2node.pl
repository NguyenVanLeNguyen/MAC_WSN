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
$flag = 0;
open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
@x = split(' ');
#checking if the event corresponds to a reception

if($x[1] > 100){



	if ($x[0] eq 's'  && $x[23] =~ /^$tonode/ && $x[3] eq 'AGT' && $x[22] =~ /^\[$sendnode/ ) {
		$pkts_=  $x[5];	
		
		if(!$send[$pkts_]){
			$send[$pkts_] = $x[1];
			$max_pktid = $pkts_ if ($max_pktid < $pkts_);
			#print STDOUT "$pkts_ send: $send[$pkts_]  ";
		}
		
	}
	if ($x[0] eq 'r'  && $x[23] =~ /^$tonode/ && $x[3] eq 'AGT' && $x[22] =~ /^\[$sendnode/ ) {
		$pktr_=  $x[5];
		$recv[$pktr_] = $x[1];
		$num++;
		#print STDOUT "$pktr_ recv: $recv[$pktr_] \n";
	}

}
}
$result;
$delay = 0;
# print STDOUT "max_pktid: $max_pktid \n";
for ($count = 0; $count <= $max_pktid; $count ++) {
	# print STDOUT "$count $send[$count]  $recv[$count] \n";
	if ($send[$count] !=0 && $recv[$count] != 0) {
	$send_ = $send[$count];
	$recv_ = $recv[$count];
	$delay = $delay + ($recv_ - $send_);
	# print STDOUT "$count recv: $recv_ - $send_ \n";
	}
}
$avg_delay = $delay / $num;
#print STDOUT "delay  $delay \n";
#print STDOUT "num  $num \n";
print STDOUT "Avg delay( src node = $sendnode; \
dst node = $tonode) = $avg_delay(s)\n";
# ------------------------------

close DATA;
exit(0);
