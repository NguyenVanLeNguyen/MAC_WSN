$str=$ARGV[0];
$node = "0";
if($str =~ /^\[$node/){
	print STDOUT "yup \n";
}
else{
	print STDOUT "no \n";
}

