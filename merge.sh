#!/bin/bash
rm uart_rx.vhd
for src in cmp.vhd  cnt.vhd  demux1to8.vhd  dffx.vhd  uart_rx-main.vhd; do
    cat "$src" >> uart_rx.vhd
done
echo 
