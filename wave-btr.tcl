# wave.tcl: TCL script for GTKWave simulator with signal definitions 
# Author(s): Lukas Kekely (ikekely@fit.vutbr.cz)

gtkwave::/Edit/Insert_Comment "Main Interface"
gtkwave::addSignalsFromList [list clk rst]
gtkwave::addSignalsFromList [list din_state]
gtkwave::/Edit/Color_Format/Blue
gtkwave::addSignalsFromList [list state next_state din dout dout_vld START_24 MSDIN SDIN SAMPLE LASTBIT START_RST CNT_RST MEM_RST START_CNT CLK_CNT ADRESS DMX_VALUE DMX_ENABLE]
gtkwave::/Edit/Insert_Blank

gtkwave::/Edit/Insert_Comment "Other Signals"
gtkwave::addSignalsFromList [list MSDIN SDIN SAMPLE]
         # <<< TODO: Insert 'gtkwave::addSignalsFromList' for your signals here.

gtkwave::/Edit/UnHighlight_All
gtkwave::/Time/Zoom/Zoom_Best_Fit
