process SPLIT_CASFILE {
  publishDir "${params.outdir}/test"

  input:
  path(cas_out)
  val(chr)

  output:
  path("casoffinder_out.chr${chr}.txt"), emit: samples
  val(chr)

  script:
  """
  awk -v chr1=${chr} '{ if (\$6 == chr1) print }' ${cas_out} > casoffinder_out.chr${chr}.txt
  """
}