process ZIP {
  publishDir "${params.outdir}/test"

  input:
  path(input_temp1)
  val(chr)

  output:
  path("input_temp1.chr${chr}.vcf.gz"), emit: samples

  script:
  """
  bgzip ${input_temp1}
  tabix input_temp1.chr${chr}.vcf.gz
  """
}