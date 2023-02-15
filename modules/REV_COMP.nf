process GETREVCOMP {
  publishDir "${params.outdir}/test"

  input:
  path(samples)
  val(chr)

  output:
  path("input_regions.chr${chr}.txt"), emit: samples

  script:
  """
  getrevcomp.R $samples input_regions.chr${chr}.txt
  """
}