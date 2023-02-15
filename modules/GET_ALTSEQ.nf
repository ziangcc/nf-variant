process GET_ALTSEQ {
  publishDir "${params.outdir}/test"

  input:
  path(intervals_with_variant_details)
  path(input_temp1)
  path(chr_file)
  val(chr)

  output:
  path("new_all_variants.chr${chr}.txt"), emit: samples
  path("chr${chr}.fa.bz")
  path("input_temp1.chr${chr}.vcf.gz")
  val(chr)

  script:
  """
  zcat < ${chr_file} | bgzip -c > chr${chr}.fa.bz
  
  bgzip ${input_temp1} 
  tabix input_temp1.chr${chr}.vcf.gz

  awk -v chr=${chr} '{
	print "now processing record  "\$1" "\$2" "\$3 > "/dev/stderr"
	split(\$NF,samples,",")
	for (i = 1; i <= length(samples); i++) {
        	cmd_aa_1 = "samtools faidx chr${chr}.fa.bz chr${chr}:"\$2"-"\$3" | bcftools consensus input_temp1.chr${chr}.vcf.gz  --sample " samples[i] " --haplotype 1  | tail -1" ;
        	cmd_aa_2 = "samtools faidx chr${chr}.fa.bz chr${chr}:"\$2"-"\$3" | bcftools consensus input_temp1.chr${chr}.vcf.gz  --sample " samples[i] " --haplotype 2  | tail -1" ;
                cmd_aa_1 | getline aa_1;
                cmd_aa_2 | getline aa_2;
                aa_1 = toupper(aa_1)
                aa_2 = toupper(aa_2)
		if (\$4 != aa_1) {printf \$1"\\t"\$2"\\t"\$3"\\t"\$4"\\t"\$5"\\t"aa_1"\\t"samples[i]"\\n"}
		if (\$4 != aa_2 && aa_2 != aa_1) {printf \$1"\\t"\$2"\\t"\$3"\\t"\$4"\\t"\$5"\\t"aa_2"\\t"samples[i]"\\n"}
	}
}' ${intervals_with_variant_details} > new_all_variants.chr${chr}.txt
  """
}
//awk -v chr=${chr} -f ${awkfile} ${intervals_with_variant_details} > new_all_variants.${chr}.txt