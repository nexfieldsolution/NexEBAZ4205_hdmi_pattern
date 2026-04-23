/* Copyright(C) 2020 Cobac.Net All Rights Reserved. */
/* chapter: ��2��            */
/* project: pattern          */
/* outline: �p�^�[���\����H */

module pattern(
    input               CLK,
    input               RST,
    output  reg [7:0]   VGA_R, VGA_G, VGA_B,
    output              VGA_HS, VGA_VS,
    output  reg         VGA_DE,
    output              PCK
);

/* VGA(640�~480)�p�p�����[�^�ǂݍ��� */
`include "vga_param.vh"

localparam HSIZE = 10'd80;
localparam VSIZE = 10'd120;

/* �����M���쐬��H�̐ڑ� */
wire    [10:0]  HCNT;
wire    [9:0]   VCNT;

syncgen syncgen(
    .CLK    (CLK),
    .RST    (RST),
    .PCK    (PCK),
    .VGA_HS (VGA_HS),
    .VGA_VS (VGA_VS),
    .HCNT   (HCNT),
    .VCNT   (VCNT)
);

/* RGB�o�͂��쐬 */
wire [10:0] HBLANK = HFRONT + HWIDTH + HBACK;
wire [9:0] VBLANK = VFRONT + VWIDTH + VBACK;

wire disp_enable = (VBLANK <= VCNT)
                && (HBLANK-10'd1 <= HCNT) && (HCNT < HPERIOD-10'd1);

wire [2:0] rgb_0 = (HCNT-HBLANK+10'd1)/HSIZE;
wire [2:0] rgb_1 = (((VCNT-VBLANK)/VSIZE)&1)==0 ? 3'd7-rgb_0: rgb_0;

always @( posedge PCK ) begin
    if ( RST )
        {VGA_R, VGA_G, VGA_B} <= 24'h0;
    else if ( disp_enable )
        {VGA_R, VGA_G, VGA_B} <=
                    { {8{rgb_1[2]}}, {8{rgb_1[1]}}, {8{rgb_1[0]}} };
    else
        {VGA_R, VGA_G, VGA_B} <= 24'h0;
end

/* disp_enable��1�N���b�N�x�点��VGA_DE���쐬 */
always @( posedge PCK ) begin
    if ( RST )
        VGA_DE <= 1'b0;
    else
        VGA_DE <= disp_enable;
end

endmodule
