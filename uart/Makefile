tx_tb:
	iverilog -o uart_tx_tb uart_tx_tb.v uart_tx.v 
	vvp uart_tx_tb
	gtkwave uart_tx_tb.vcd

rx_tb:
	iverilog -o uart_rx_tb uart_rx_tb.v uart_rx.v 
	vvp uart_rx_tb
	gtkwave uart_rx_tb.vcd

board:
	apio build
	apio upload