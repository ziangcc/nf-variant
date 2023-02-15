process INTERSECT {
  publishDir "${params.outdir}/test"

  input:
  path(input_regions)
  path(variants_in_input)
  val(chr)

  output:
  path("intervals_with_variant_details.chr${chr}.bed"), emit: samples

  script:
  """
  bedtools intersect -a ${input_regions} -b ${variants_in_input} -wao > intersect_temp.chr${chr}.txt 
  modify_format.R intersect_temp.chr${chr}.txt ${variants_in_input} modified_temp.txt
  sort modified_temp.txt -k1,1 -k2,2n | bedtools groupby -g 1,2,3,4,5 -c 8,10,9 -o collapse,collapse,distinct -delim , | grep -v "\\-1" > intervals_with_variant_details.chr${chr}.bed
  """
}