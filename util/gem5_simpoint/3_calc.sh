#!/bin/sh

[ -n "$1" ] || { echo "Usage: $0 <dir>" >&2; exit 1; }

echo "BENCH     | MPKI   | Misprediction Rate"

v1=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-1.txt")
v2=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-2.txt")
v3=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-3.txt")
v4=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-4.txt")
v5=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-5.txt")
v6=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-6.txt")
v7=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-7.txt")
v8=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-8.txt")
v9=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/gcc-9.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}
# gcc_mis_ind=$(echo "scale=4; ($v1*19 + $v2*17 + $v3*16 + $v4*11 + $v5*6 + $v6*4 + $v7*2 + $v8*1 + $v9*1)/77" | bc)
gcc_mis_ind=$(echo "scale=4; ($v1*19 + $v2*17 + $v3*16 + $v4*11 + $v5*6 + $v7*2 + $v8*1 + $v9*1)/73" | bc)
v1=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-1.txt")
v2=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-2.txt")
v3=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-3.txt")
v4=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-4.txt")
v5=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-5.txt")
v6=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-6.txt")
v7=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-7.txt")
v8=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-8.txt")
v9=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/gcc-9.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}
# gcc_mis_call=$(echo "scale=4; ($v1*19 + $v2*17 + $v3*16 + $v4*11 + $v5*6 + $v6*4 + $v7*2 + $v8*1 + $v9*1)/77" | bc)
gcc_mis_call=$(echo "scale=4; ($v1*19 + $v2*17 + $v3*16 + $v4*11 + $v5*6 + $v7*2 + $v8*1 + $v9*1)/73" | bc)
v1=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-1.txt")
v2=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-2.txt")
v3=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-3.txt")
v4=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-4.txt")
v5=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-5.txt")
v6=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-6.txt")
v7=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-7.txt")
v8=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-8.txt")
v9=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/gcc-9.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}
# gcc_com_ind=$(echo "scale=4; ($v1*19 + $v2*17 + $v3*16 + $v4*11 + $v5*6 + $v6*4 + $v7*2 + $v8*1 + $v9*1)/77" | bc)
gcc_com_ind=$(echo "scale=4; ($v1*19 + $v2*17 + $v3*16 + $v4*11 + $v5*6 + $v7*2 + $v8*1 + $v9*1)/73" | bc)
v1=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-1.txt")
v2=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-2.txt")
v3=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-3.txt")
v4=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-4.txt")
v5=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-5.txt")
v6=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-6.txt")
v7=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-7.txt")
v8=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-8.txt")
v9=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/gcc-9.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}
# gcc_com_call=$(echo "scale=4; ($v1*19 + $v2*17 + $v3*16 + $v4*11 + $v5*6 + $v6*4 + $v7*2 + $v8*1 + $v9*1)/77" | bc)
gcc_com_call=$(echo "scale=4; ($v1*19 + $v2*17 + $v3*16 + $v4*11 + $v5*6 + $v7*2 + $v8*1 + $v9*1)/73" | bc)

echo "gcc       | \
$(printf "%.4f\n" $(echo "scale=4; ($gcc_mis_ind + $gcc_mis_call)*1000/(200000000)" | bc)) | \
$(echo "scale=4; $gcc_mis_ind + $gcc_mis_call" | bc)/$(echo "scale=4; $gcc_com_ind + $gcc_com_call" | bc)=\
$(if [ "$(echo "$gcc_com_ind + $gcc_com_call" | bc)" != "0" ]; \
    then printf "%.4f\n" $(echo "scale=4; ($gcc_mis_ind + $gcc_mis_call)*100/($gcc_com_ind + $gcc_com_call)" | bc); \
    else echo "N/A"; fi)"


v1=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/omnetpp-1.txt")
v2=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/omnetpp-2.txt")
v3=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/omnetpp-3.txt")
v4=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/omnetpp-4.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}
omn_mis_ind=$(echo "scale=4; ($v1*51 + $v2*44 + $v3*2 + $v4*1)/95" | bc)
v1=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/omnetpp-1.txt")
v2=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/omnetpp-2.txt")
v3=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/omnetpp-3.txt")
v4=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/omnetpp-4.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}
omn_mis_call=$(echo "scale=4; ($v1*51 + $v2*44 + $v3*2 + $v4*1)/95" | bc)
v1=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/omnetpp-1.txt")
v2=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/omnetpp-2.txt")
v3=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/omnetpp-3.txt")
v4=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/omnetpp-4.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}
omn_com_ind=$(echo "scale=4; ($v1*51 + $v2*44 + $v3*2 + $v4*1)/95" | bc)
v1=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/omnetpp-1.txt")
v2=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/omnetpp-2.txt")
v3=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/omnetpp-3.txt")
v4=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/omnetpp-4.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}
omn_com_call=$(echo "scale=4; ($v1*51 + $v2*44 + $v3*2 + $v4*1)/95" | bc)

echo "omnetpp   | \
$(printf "%.4f\n" $(echo "scale=4; ($omn_mis_ind + $omn_mis_call)*1000/(200000000)" | bc)) | \
$(echo "scale=4; $omn_mis_ind + $omn_mis_call" | bc)/$(echo "scale=4; $omn_com_ind + $omn_com_call" | bc)=\
$(if [ "$(echo "$omn_com_ind + $omn_com_call" | bc)" != "0" ]; \
    then printf "%.4f\n" $(echo "scale=4; ($omn_mis_ind + $omn_mis_call)*100/($omn_com_ind + $omn_com_call)" | bc); \
    else echo "N/A"; fi)"


v1=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-1.txt")
v2=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-2.txt")
v3=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-3.txt")
v4=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-4.txt")
v5=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-5.txt")
v6=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-6.txt")
v7=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-7.txt")
v8=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-8.txt")
v9=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-9.txt")
v10=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-10.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}; v10=${v10:-0};
sje_mis_ind=$(echo "scale=4; ($v1*16 + $v2*15 + $v3*15 + $v4*12 + $v5*10 + $v6*9 + $v7*7 + $v8*5 + $v9*3 + $v10*2)/94" | bc)
v1=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-1.txt")
v2=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-2.txt")
v3=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-3.txt")
v4=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-4.txt")
v5=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-5.txt")
v6=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-6.txt")
v7=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-7.txt")
v8=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-8.txt")
v9=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-9.txt")
v10=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/sjeng-10.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}; v10=${v10:-0};
sje_mis_call=$(echo "scale=4; ($v1*16 + $v2*15 + $v3*15 + $v4*12 + $v5*10 + $v6*9 + $v7*7 + $v8*5 + $v9*3 + $v10*2)/94" | bc)
v1=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-1.txt")
v2=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-2.txt")
v3=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-3.txt")
v4=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-4.txt")
v5=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-5.txt")
v6=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-6.txt")
v7=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-7.txt")
v8=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-8.txt")
v9=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-9.txt")
v10=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/sjeng-10.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}; v10=${v10:-0};
sje_com_ind=$(echo "scale=4; ($v1*16 + $v2*15 + $v3*15 + $v4*12 + $v5*10 + $v6*9 + $v7*7 + $v8*5 + $v9*3 + $v10*2)/94" | bc)
v1=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-1.txt")
v2=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-2.txt")
v3=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-3.txt")
v4=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-4.txt")
v5=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-5.txt")
v6=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-6.txt")
v7=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-7.txt")
v8=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-8.txt")
v9=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-9.txt")
v10=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/sjeng-10.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}; v10=${v10:-0};
sje_com_call=$(echo "scale=4; ($v1*16 + $v2*15 + $v3*15 + $v4*12 + $v5*10 + $v6*9 + $v7*7 + $v8*5 + $v9*3 + $v10*2)/94" | bc)

echo "sjeng     | \
$(printf "%.4f\n" $(echo "scale=4; ($sje_mis_ind + $sje_mis_call)*1000/(200000000)" | bc)) | \
$(echo "scale=4; $sje_mis_ind + $sje_mis_call" | bc)/$(echo "scale=4; $sje_com_ind + $sje_com_call" | bc)=\
$(if [ "$(echo "$sje_com_ind + $sje_com_call" | bc)" != "0" ]; \
    then printf "%.4f\n" $(echo "scale=4; ($sje_mis_ind + $sje_mis_call)*100/($sje_com_ind + $sje_com_call)" | bc); \
    else echo "N/A"; fi)"


v1=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-1.txt")
v2=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-2.txt")
v3=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-3.txt")
v4=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-4.txt")
v5=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-5.txt")
v6=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-6.txt")
v7=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-7.txt")
v8=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-8.txt")
v9=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-9.txt")
v10=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-10.txt")
v11=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-11.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}; v10=${v10:-0}; v11=${v11:-0};
xal_mis_ind=$(echo "scale=4; ($v1*20 + $v2*19 + $v3*14 + $v4*14 + $v5*7 + $v6*7 + $v7*4 + $v8*3 + $v9*3 + $v10*3 + $v11*1)/95" | bc)
v1=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-1.txt")
v2=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-2.txt")
v3=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-3.txt")
v4=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-4.txt")
v5=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-5.txt")
v6=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-6.txt")
v7=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-7.txt")
v8=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-8.txt")
v9=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-9.txt")
v10=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-10.txt")
v11=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-11.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}; v10=${v10:-0}; v11=${v11:-0};
xal_mis_call=$(echo "scale=4; ($v1*20 + $v2*19 + $v3*14 + $v4*14 + $v5*7 + $v6*7 + $v7*4 + $v8*3 + $v9*3 + $v10*3 + $v11*1)/95" | bc)
v1=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-1.txt")
v2=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-2.txt")
v3=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-3.txt")
v4=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-4.txt")
v5=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-5.txt")
v6=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-6.txt")
v7=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-7.txt")
v8=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-8.txt")
v9=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-9.txt")
v10=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-10.txt")
v11=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$1/xalancbmk-11.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}; v10=${v10:-0}; v11=${v11:-0};
xal_com_ind=$(echo "scale=4; ($v1*20 + $v2*19 + $v3*14 + $v4*14 + $v5*7 + $v6*7 + $v7*4 + $v8*3 + $v9*3 + $v10*3 + $v11*1)/95" | bc)
v1=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-1.txt")
v2=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-2.txt")
v3=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-3.txt")
v4=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-4.txt")
v5=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-5.txt")
v6=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-6.txt")
v7=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-7.txt")
v8=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-8.txt")
v9=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-9.txt")
v10=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-10.txt")
v11=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$1/xalancbmk-11.txt")
v1=${v1:-0}; v2=${v2:-0}; v3=${v3:-0}; v4=${v4:-0}; v5=${v5:-0}; v6=${v6:-0}; v7=${v7:-0}; v8=${v8:-0}; v9=${v9:-0}; v10=${v10:-0}; v11=${v11:-0};
xal_com_call=$(echo "scale=4; ($v1*20 + $v2*19 + $v3*14 + $v4*14 + $v5*7 + $v6*7 + $v7*4 + $v8*3 + $v9*3 + $v10*3 + $v11*1)/95" | bc)

echo "xalancbmk | \
$(printf "%.4f\n" $(echo "scale=4; ($xal_mis_ind + $xal_mis_call)*1000/(200000000)" | bc)) | \
$(echo "scale=4; $xal_mis_ind + $xal_mis_call" | bc)/$(echo "scale=4; $xal_com_ind + $xal_com_call" | bc)=\
$(if [ "$(echo "$xal_com_ind + $xal_com_call" | bc)" != "0" ]; \
    then printf "%.4f\n" $(echo "scale=4; ($xal_mis_ind + $xal_mis_call)*100/($xal_com_ind + $xal_com_call)" | bc); \
    else echo "N/A"; fi)"

echo "overall   | \
$(printf "%.4f\n" $(echo "scale=4; (\
    $gcc_mis_ind + $gcc_mis_call + \
    $omn_mis_ind + $omn_mis_call + \
    $sje_mis_ind + $sje_mis_call + \
    $xal_mis_ind + $xal_mis_call)*1000/(200000000*4)" | bc)) | - \
"
