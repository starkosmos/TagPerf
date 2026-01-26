#!/bin/sh

dirs=" \
simpoint/gcc/1 \
simpoint/gcc/2 \
simpoint/gcc/3 \
simpoint/gcc/4 \
simpoint/gcc/5 \
simpoint/gcc/6 \
simpoint/gcc/7 \
simpoint/gcc/8 \
simpoint/gcc/9 \
simpoint/omnetpp/1 \
simpoint/omnetpp/2 \
simpoint/omnetpp/3 \
simpoint/omnetpp/4 \
simpoint/sjeng/1 \
simpoint/sjeng/2 \
simpoint/sjeng/3 \
simpoint/sjeng/4 \
simpoint/sjeng/5 \
simpoint/sjeng/6 \
simpoint/sjeng/7 \
simpoint/sjeng/8 \
simpoint/sjeng/9 \
simpoint/sjeng/10 \
simpoint/xalancbmk/1 \
simpoint/xalancbmk/2 \
simpoint/xalancbmk/3 \
simpoint/xalancbmk/4 \
simpoint/xalancbmk/5 \
simpoint/xalancbmk/6 \
simpoint/xalancbmk/7 \
simpoint/xalancbmk/8 \
simpoint/xalancbmk/9 \
simpoint/xalancbmk/10 \
simpoint/xalancbmk/11 \
"

if [ -z "$1" ]; then
    echo "Usage: $0 DEST_DIR" >&2
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: destination directory '$1' does not exist." >&2
    exit 1
fi

for d in $dirs; do
    [ -d "$d" ] || continue
    cp "${d%/}/m5out/stats.txt" "$1/$(basename "$(dirname "${d%/}")")-$(basename "${d%/}").txt"
done
