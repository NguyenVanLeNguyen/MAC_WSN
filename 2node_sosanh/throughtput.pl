# Type: perl avg_throughput_during_sim_time.pl <trace file> <flow id> <required node>
$infile=$ARGV[0];
#$flow_id=$ARGV[1];
$tonode=$ARGV[2];
$sendnode = $ARGV[1];
$start_time=0;
$end_time=0;
$sum=0;
print STDOUT "infile : $infile \n";
print  STDOUT "tonode : $tonode \n";


open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
@x = split(' ');
#checking if the event corresponds to a reception
if ($x[0] eq 'r'  && $x[23] =~ /^$tonode/ && $x[3] eq 'AGT' && $x[22] =~ /^\[$sendnode/ ) {
if ($start_time == 0) {
$start_time=$x[1];
}
$sum=$sum+$x[7];
$end_time=$x[1];
print STDOUT "se_number : $x[22] $x[23] \n";
}
}
# ------------------------------
$throughput_byte=$sum/($end_time - $start_time);
$throughput_kbit=($throughput_byte*8)/1024;
print STDOUT "start_time = $start_time\t";
print STDOUT "end_time = $end_time\n";
print STDOUT "Avg throughtput(flow  dst node =
$tonode) = $throughput_kbit(Kbps)\n\n";
close DATA;
exit(0);
