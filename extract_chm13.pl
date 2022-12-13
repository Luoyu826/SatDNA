#open f,'blast_chm13v2.tab';
open f,'blast_beta_chm13.tab';
open o,'>extract_beta_chm13.fas';
while(<f>){
	#print $_;
	@mat=split /\t/;
	#if($mat[3]>140 && $mat[11]<1E-11){ #for alpha
	if($mat[3]>67 && $mat[11]<1E-9){ 

		if($mat[0] ne $last_query){
			#print "length=$#a\n";
								#print "array size $#a\n";
			&sort_write();
						  #print "array size $#a\n";
			push @a,[@mat];
		}else{
			push @a,[@mat];
		}					#print "length= $#a\n";
			$last_query=$mat[0];

	}
	if(eof(f)){
					#print "array size $#a\n";
		&sort_write();
					#print "array size $#a EOF\n";
	}		
}
close f;

sub ReC{ # function for reverse complement.     
    $_=$_[0];
    if(m/&/){
	print 'Sequence can not contain "&" !'."\n";
	last;	    
    }           
    s/a/&/g; s/t/a/g; s/&/t/g;    
    s/g/&/g; s/c/g/g; s/&/c/g; 
    s/A/&/g; s/T/A/g; s/&/T/g;    
    s/G/&/g; s/C/G/g; s/&/C/g;    
    reverse($_);   
}

sub sort_write(){
	#@a=sort {$a->[0] cmp $b->[0] || $a->[6] <=> $b->[6] || $b->[12] <=> $a->[12]} @a;
	@a=sort {$a->[6] <=> $b->[6] || $b->[12] <=> $a->[12]} @a;
	$end0=0;
		for(@a){
		#print "$_\n";
			$id=${$_}[0];
			$len=${$_}[3];
			$e=${$_}[11];
			$strand=${$_}[8];
			$start=${$_}[6];
			$end=${$_}[7];
			$seq=${$_}[13];
			$seq =ReC($seq) if $strand eq 'minus';
		
			#if($e<1E-11 && $len>140){
				#if($id ne $id0){
					#$n++;$end0=0;
					#print o ">$ver\_$id\_$start-$end\_$n\n";
			  	#print o "$seq\n";
					#$id0=$id; $end0=$end;
				#}else{
					if($start>$end0 - 2){
						$n++;
						print o ">$ver$strand$id\_$start-$end\_$n\n";
						print o "$seq\n";
						$end0=$end;
					}
				#}
			#}
	
	
		}
		@a=();
}