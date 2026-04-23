/* uart_hello.v - "Hello EBAZ4205\r\n" sender, 9600 baud, CLK=50MHz */

module uart_hello (
    input  CLK,
    output UART_TX
);

localparam MSG_LEN = 16;

// ROM: "Hello EBAZ4205\r\n"
function [7:0] rom_data;
    input [3:0] addr;
    case (addr)
        4'd0:  rom_data = 8'h48; // 'H'
        4'd1:  rom_data = 8'h65; // 'e'
        4'd2:  rom_data = 8'h6C; // 'l'
        4'd3:  rom_data = 8'h6C; // 'l'
        4'd4:  rom_data = 8'h6F; // 'o'
        4'd5:  rom_data = 8'h20; // ' '
        4'd6:  rom_data = 8'h45; // 'E'
        4'd7:  rom_data = 8'h42; // 'B'
        4'd8:  rom_data = 8'h41; // 'A'
        4'd9:  rom_data = 8'h5A; // 'Z'
        4'd10: rom_data = 8'h34; // '4'
        4'd11: rom_data = 8'h32; // '2'
        4'd12: rom_data = 8'h30; // '0'
        4'd13: rom_data = 8'h35; // '5'
        4'd14: rom_data = 8'h0D; // '\r'
        4'd15: rom_data = 8'h0A; // '\n'
        default: rom_data = 8'h00;
    endcase
endfunction

// ~2 sec delay between messages: 2^26 / 33.333MHz = 2.013s
reg [25:0] delay_cnt = 26'd0;
reg [3:0]  char_idx  = 4'd0;
reg        uart_send = 1'b0;
reg [7:0]  uart_data = 8'd0;
wire       uart_ready;

UART_TX_CTRL u_uart_tx (
    .SEND    (uart_send),
    .DATA    (uart_data),
    .CLK     (CLK),
    .READY   (uart_ready),
    .UART_TX (UART_TX)
);

localparam S_LOAD = 2'd0;
localparam S_SEND = 2'd1;
localparam S_WAIT = 2'd2;

reg [1:0] state = S_LOAD; // send immediately on startup

always @(posedge CLK) begin
    uart_send <= 1'b0;
    case (state)
        S_LOAD: begin
            if (uart_ready) begin
                uart_data <= rom_data(char_idx);
                uart_send <= 1'b1;
                state     <= S_SEND;
            end
        end
        S_SEND: begin
            if (uart_ready) begin
                if (char_idx == MSG_LEN - 1) begin
                    char_idx  <= 4'd0;
                    delay_cnt <= 26'd0;
                    state     <= S_WAIT;
                end else begin
                    char_idx <= char_idx + 1;
                    state    <= S_LOAD;
                end
            end
        end
        S_WAIT: begin
            if (delay_cnt == 26'h3FF_FFFF) begin
                state <= S_LOAD;
            end else
                delay_cnt <= delay_cnt + 1;
        end
    endcase
end

endmodule
