process FIND_VARIANTS {
  publishDir "${params.outdir}/test"
  input:
  path(input_temp1)
  val(chr)

  output:
  path("variants_in_input.tmp.${chr}.txt"), emit: samples

  script:
  """
  sed '/##/d' ${input_temp1} | awk -F"\\t" '/^#CHROM/ { split(\$0, header, "\\t") }
        !/^#CHROM/ {
                samplecount=0;
		        samplenames=""
                printf \$1"\\t"\$2"\\t"\$2"\\t";
                for (i = 10; i <= NF; i ++) {
			        split(\$i,arr,":")
                	if (arr[1] == "1" || arr[1] == "0\\|1" || arr[1] == "1\\|0" || arr[1] == "1\\|1" ) {
                		samplecount ++;
				if (samplenames == "") { samplenames = header[i] } else {samplenames = samplenames","header[i]}
                    }
                }
                printf samplenames"\\t"samplecount"\\n"
        }' > variants_in_input.tmp.${chr}.txt 
  """
}