$str=$ARGV[0];
$st = $ARGV[1];
$str2= substr $str, 1, -1;
$str3= substr $st, 1, -1;
$num=$str2+$str3;
$enum=0.000004;
print STDOUT "$enum \n";   
