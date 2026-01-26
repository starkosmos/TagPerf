#!/bin/sh

[ -n "$1" ] || { echo "Usage: $0 <dir>" >&2; exit 1; }

echo "MPKI   | BENCH"

for d in $1/*; do
    mis_ind=$(awk '/mispredicted_0::IndirectUncond/ {print $2; exit}' "$d")
    mis_call=$(awk '/mispredicted_0::CallIndirect/ {print $2; exit}' "$d")
    com_ind=$(awk '/committed_0::IndirectUncond/ {print $2; exit}' "$d")
    com_call=$(awk '/committed_0::CallIndirect/ {print $2; exit}' "$d")
    mis_ind=${mis_ind:-0}; mis_call=${mis_call:-0}; com_ind=${com_ind:-0}; com_call=${com_call:-0}
    echo "$(printf "%.4f\n" $(echo "scale=4; ($mis_ind + $mis_call)*1000/(200000000)" | bc)) | $(basename $d)"
done