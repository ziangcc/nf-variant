#!/usr/bin/env nextflow

nextflow.enable.dsl=2

VERSION="0.1.1"

// Shared modules
include { SPLIT_CASFILE }         from './modules/SPLIT_CASFILE.nf'
include { GETREVCOMP }         from './modules/REV_COMP.nf'
include { GETREGION }         from './modules/GET_REGION.nf'
include { FIND_VARIANTS }         from './modules/FIND_VARIANTS.nf'
include { INTERSECT }         from './modules/FIND_INTERSECT.nf'
include { GET_ALTSEQ }         from './modules/GET_ALTSEQ.nf'
//include { ZIP }         from './modules/ZIP.nf'
//include { GROUP }         from './modules/new_GROUP.nf'
//include { MODIFY }         from './modules/new_MODIFY.nf'

// Workflows
workflow {

  chr_num = params.chr_num
  GETREVCOMP(SPLIT_CASFILE( params.cas_output, chr_num ))
  GETREGION(params.genome_file, GETREVCOMP.out.samples, chr_num)
  FIND_VARIANTS(GETREGION.out.samples, chr_num)
  INTERSECT(GETREVCOMP.out.samples, FIND_VARIANTS.out.samples, chr_num)
  GET_ALTSEQ(INTERSECT.out.samples, GETREGION.out.samples,"$PWD/chr${chr_num}.fa.gz",chr_num)
}