process GETREGION {

  publishDir "${params.outdir}/test"
  input:
  path(genome)
  path(input_regions)
  val(chr)

  output:
  path("input_temp1.chr${chr}.vcf"), emit: samples

  script:
  """
  bcftools view /Users/ziangchen/DeskTop/1K_genome/CCDG_chr${chr}.vcf.gz -i 'TYPE="snp" & INFO/AC>0' --regions-file ${input_regions} > input_temp1.chr${chr}.vcf
  """
}