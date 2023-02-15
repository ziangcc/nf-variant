{
	print "now processing record  "$1" "$2" "$3 > "/dev/stderr" # write current record to stderr
	split($NF,samples,",") # get samplenames that have alt allele anywhere in this sequence
	for (i = 1; i <= length(samples); i++) {
	# create command to get alt allele sequence. 
        	cmd_aa_1 = "samtools faidx chr${chr}.fa.bz chr${chr}:"$2"-"$3" | bcftools consensus input_temp1.chr${chr}.vcf.gz  --sample " samples[i] " --haplotype 1  | tail -1" ;
        	cmd_aa_2 = "samtools faidx chr${chr}.fa.bz chr${chr}:"$2"-"$3" | bcftools consensus input_temp1.chr${chr}.vcf.gz  --sample " samples[i] " --haplotype 2  | tail -1" ;
                cmd_aa_1 | getline aa_1; # execute sequence
                cmd_aa_2 | getline aa_2; # execute sequence
                aa_1 = toupper(aa_1)
                aa_2 = toupper(aa_2)
		if ($4 != aa_1) {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"aa_1"\t"samples[i]"\n"} # if sequence is different from ref (which it has to be), print the line along with sample name which is in loop
		if ($4 != aa_2 && aa_2 != aa_1) {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"aa_2"\t"samples[i]"\n"} # if sequence is different from ref (which it has to be), print the line along with sample name which is in loop
	}
}