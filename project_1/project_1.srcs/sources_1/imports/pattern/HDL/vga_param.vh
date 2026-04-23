/* Copyright(C) 2020 Cobac.Net All Rights Reserved. */
/* chapter: ��2�͂ȂǕ\����H�������e��    */
/* project: pattern, chardisp, dipslay�Ȃ� */
/* outline: VGA�p�p�����[�^                */

/* 1280x720@60Hz (Input=50MHz, PCK=74.25MHz, VCO=742.5MHz) */
/* 640x480 original: HPERIOD=800,HFRONT=16,HWIDTH=96,HBACK=48, VPERIOD=525,VFRONT=10,VWIDTH=2,VBACK=33 */
/* 640x480 sync polarity: HS=Negative, VS=Negative */
/* 1280x720 sync polarity: HS=Positive, VS=Positive (CEA-861) */
localparam HPERIOD = 11'd1650;
localparam HFRONT  = 11'd110;
localparam HWIDTH  = 11'd40;
localparam HBACK   = 11'd220;

localparam VPERIOD = 10'd750;
localparam VFRONT  = 10'd5;
localparam VWIDTH  = 10'd5;
localparam VBACK   = 10'd20;

localparam HS_POL  = 1'b1;  // 1=Positive, 0=Negative
localparam VS_POL  = 1'b1;  // 1=Positive, 0=Negative
