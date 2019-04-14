$infile=$ARGV[0];
$sendnode=$ARGV[1];
$tonode=$ARGV[2];
$sum=0;
$succsess=0;


print STDOUT "infile : $infile \n";
print  STDOUT "sendnode : $sendnode \n";
print  STDOUT "tonode : $tonode \n";


open (DATA,"<$infile") || die "Can't open $infile $!";
while (<DATA>) {
@x = split(' ');
#checking if the event corresponds to a reception
if ($x[3] eq 'AGT' && $x[0] eq 'r' && $x[22] =~ /^\[$sendnode/ && $x[23] =~ /^$tonode/){

	$succsess=$succsess+1;

}
if ($x[3] eq 'AGT' && $x[0] eq 's' && $x[22] =~ /^\[$sendnode/ ) {
	$sum=$sum+1;
	
}
}
# ------------------------------
$rate=$succsess/$sum;

print STDOUT "tong so goi gui = $sum\t";
print STDOUT "so goi nha = $succsess\n";
print STDOUT "ty le = $rate\n";

close DATA;
exit(0);
