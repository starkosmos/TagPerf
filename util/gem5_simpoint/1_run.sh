#!/bin/sh

runcmd="../../../../build/ALL/gem5.opt ../../../se.py ../../readckpt_new.riscv"

cd simpoint/gcc/1
$runcmd ../simpoint1_gcc_nckpt_42600000000_len_1200000000_warmup_1000000000_weight19.info ../gcc.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/gcc/2
$runcmd ../simpoint2_gcc_nckpt_47800000000_len_1200000000_warmup_1000000000_weight17.info ../gcc.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/gcc/3
$runcmd ../simpoint3_gcc_nckpt_61400000000_len_1200000000_warmup_1000000000_weight16.info ../gcc.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/gcc/4
$runcmd ../simpoint4_gcc_nckpt_53800000000_len_1200000000_warmup_1000000000_weight11.info ../gcc.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/gcc/5
$runcmd ../simpoint5_gcc_nckpt_36800000000_len_1200000000_warmup_1000000000_weight6.info ../gcc.riscv >out.txt 2>err.txt &
cd - > /dev/null
# cd simpoint/gcc/6
# $runcmd ../simpoint6_gcc_nckpt_74400000000_len_1200000000_warmup_1000000000_weight4.info ../gcc.riscv >out.txt 2>err.txt &
# cd - > /dev/null
cd simpoint/gcc/7
$runcmd ../simpoint7_gcc_nckpt_2600000000_len_1200000000_warmup_1000000000_weight2.info ../gcc.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/gcc/8
$runcmd ../simpoint8_gcc_nckpt_44200000000_len_1200000000_warmup_1000000000_weight1.info ../gcc.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/gcc/9
$runcmd ../simpoint9_gcc_nckpt_45800000000_len_1200000000_warmup_1000000000_weight1.info ../gcc.riscv >out.txt 2>err.txt &
cd - > /dev/null

cd simpoint/omnetpp/1
$runcmd ../simpoint1_omnetpp_nckpt_299000000000_len_1200000000_warmup_1000000000_weight51.info ../omnetpp.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/omnetpp/2
$runcmd ../simpoint2_omnetpp_nckpt_428000000000_len_1200000000_warmup_1000000000_weight44.info ../omnetpp.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/omnetpp/3
$runcmd ../simpoint3_omnetpp_nckpt_12400000000_len_1200000000_warmup_1000000000_weight2.info ../omnetpp.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/omnetpp/4
$runcmd ../simpoint4_omnetpp_nckpt_21400000000_len_1200000000_warmup_1000000000_weight1.info ../omnetpp.riscv >out.txt 2>err.txt &
cd - > /dev/null

cd simpoint/sjeng/1
$runcmd ../simpoint1_sjeng_nckpt_1372000000000_len_1200000000_warmup_1000000000_weight16.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/2
$runcmd ../simpoint2_sjeng_nckpt_1821200000000_len_1200000000_warmup_1000000000_weight15.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/3
$runcmd ../simpoint3_sjeng_nckpt_521800000000_len_1200000000_warmup_1000000000_weight15.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/4
$runcmd ../simpoint4_sjeng_nckpt_1592600000000_len_1200000000_warmup_1000000000_weight12.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/5
$runcmd ../simpoint5_sjeng_nckpt_279000000000_len_1200000000_warmup_1000000000_weight10.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/6
$runcmd ../simpoint6_sjeng_nckpt_315000000000_len_1200000000_warmup_1000000000_weight9.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/7
$runcmd ../simpoint7_sjeng_nckpt_1260400000000_len_1200000000_warmup_1000000000_weight7.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/8
$runcmd ../simpoint8_sjeng_nckpt_897200000000_len_1200000000_warmup_1000000000_weight5.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/9
$runcmd ../simpoint9_sjeng_nckpt_160000000000_len_1200000000_warmup_1000000000_weight3.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/sjeng/10
$runcmd ../simpoint10_sjeng_nckpt_2670000000000_len_1200000000_warmup_1000000000_weight2.info ../sjeng.riscv >out.txt 2>err.txt &
cd - > /dev/null

cd simpoint/xalancbmk/1
$runcmd ../simpoint1_xalancbmk_nckpt_640800000000_len_1200000000_warmup_1000000000_weight20.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/2
$runcmd ../simpoint2_xalancbmk_nckpt_171400000000_len_1200000000_warmup_1000000000_weight19.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/3
$runcmd ../simpoint3_xalancbmk_nckpt_761400000000_len_1200000000_warmup_1000000000_weight14.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/4
$runcmd ../simpoint4_xalancbmk_nckpt_751600000000_len_1200000000_warmup_1000000000_weight14.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/5
$runcmd ../simpoint5_xalancbmk_nckpt_713800000000_len_1200000000_warmup_1000000000_weight7.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/6
$runcmd ../simpoint6_xalancbmk_nckpt_70400000000_len_1200000000_warmup_1000000000_weight7.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/7
$runcmd ../simpoint7_xalancbmk_nckpt_221000000000_len_1200000000_warmup_1000000000_weight4.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/8
$runcmd ../simpoint8_xalancbmk_nckpt_9000000000_len_1200000000_warmup_1000000000_weight3.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/9
$runcmd ../simpoint9_xalancbmk_nckpt_351200000000_len_1200000000_warmup_1000000000_weight3.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/10
$runcmd ../simpoint10_xalancbmk_nckpt_641200000000_len_1200000000_warmup_1000000000_weight3.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
cd simpoint/xalancbmk/11
$runcmd ../simpoint11_xalancbmk_nckpt_507800000000_len_1200000000_warmup_1000000000_weight1.info ../xalancbmk.riscv >out.txt 2>err.txt &
cd - > /dev/null
