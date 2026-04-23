/* Copyright(C) 2020 Cobac.Net All Rights Reserved. */
/* chapter: ��2�͂Ȃǉ�ʕ\���������e��    */
/* project: pattern, chardisp, dipslay�Ȃ� */
/* outline: �����M���쐬                   */

module syncgen(
    input               CLK,
    input               RST,
    output              PCK,
    output  reg         VGA_HS,
    output  reg         VGA_VS,
    output  reg [10:0]  HCNT,
    output  reg [9:0]   VCNT
);

/* VGA(640�~480)�p�p�����[�^�ǂݍ��� */
`include "vga_param.vh"

/* MMCM��ڑ�����PCK�𐶐� */
pckgen pckgen ( .SYSCLK(CLK), .PCK(PCK) );

/* �����J�E���^ */
wire hcntend = (HCNT==HPERIOD-11'h001);

always @( posedge PCK ) begin
    if ( RST )
        HCNT <= 10'h000;
    else if ( hcntend )
        HCNT <= 10'h000;
    else
        HCNT <= HCNT + 10'h001;
end

/* �����J�E���^ */
always @( posedge PCK ) begin
    if ( RST )
        VCNT <= 10'h000;
    else if ( hcntend ) begin
        if ( VCNT == VPERIOD - 10'h001 )
            VCNT <= 10'h000;
        else
            VCNT <= VCNT + 10'h001;
    end
end

/* �����M�� */
wire [10:0] hsstart = HFRONT - 11'h001;
wire [10:0] hsend   = HFRONT + HWIDTH - 11'h001;
wire [9:0] vsstart = VFRONT;
wire [9:0] vsend   = VFRONT + VWIDTH;

always @( posedge PCK ) begin
    if ( RST )
        VGA_HS <= ~HS_POL;
    else if ( HCNT==hsstart )
        VGA_HS <= HS_POL;
    else if ( HCNT==hsend )
        VGA_HS <= ~HS_POL;
end

always @( posedge PCK ) begin
    if ( RST )
        VGA_VS <= ~VS_POL;
    else if ( HCNT==hsstart ) begin
        if ( VCNT==vsstart )
            VGA_VS <= VS_POL;
        else if ( VCNT==vsend )
            VGA_VS <= ~VS_POL;
    end
end

endmodule
