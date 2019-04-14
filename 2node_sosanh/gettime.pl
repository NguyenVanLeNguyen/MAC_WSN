$infile=$ARGV[0];
$node=$ARGV[1];
$sum=0;
$active=0;
$sleep=0;
$idle=0;
$data=0;
$ctr=0;
$sync=0;
$cr=0;
print STDOUT "infile : $infile \n";
print  STDOUT "node : $node \n";



open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
@x = split(' ');
#checking if the event corresponds to a reception
if ($x[0] eq 'active' && $x[1] =~ /^$node/){

	$active=$active+$x[2];
	# print STDOUT "$x[2] \n";

}
if ($x[0] eq 'sleep' && $x[1] =~ /^$node/){

	$sleep=$sleep+$x[2];

}
if ($x[0] eq 'timeidle'&&( $x[1] eq '3' || $x[1] eq '9') && $x[2] =~ /^$node/){ #&&( $x[1] eq '3' || $x[1] eq '9')

	$idle=$idle+$x[3];

}
if ($x[0] eq 'data' && $x[1] =~ /^$node/){

	$data=$data+$x[2];

}
if (($x[0] eq 'cts' || $x[0] eq 'rts' || $x[0] eq 'ack')  ){

	$ctr=$ctr+$x[2];

}
if ($x[0] eq 'sync' && $x[1] =~ /^$node/){

	$sync=$sync+$x[2];

}
if (($x[2] eq 'cr:' || $x[2] eq 'cr2:') && $x[0] =~ /^$node/){

	$cr=$cr+$x[3];

}
}
# ------------------------------


print STDOUT "tong thoi gian thuc = $active\n";
print STDOUT "tong thoi gian ngu = $sleep\n";
print STDOUT "tong thoi idle = $idle\n";
print STDOUT "tong thoi data = $data\n";
print STDOUT "tong thoi dieu khien = $ctr\n";
print STDOUT "tong thoi sync = $sync\n";
print STDOUT "tong thoi cr = $cr\n";
# print STDOUT "ty le = $rate\n";

close DATA;
exit(0);
