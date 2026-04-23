/* Copyright(C) 2020 Cobac.Net All Rights Reserved. */
/* chapter: ��2��                                */
/* project: pattern                              */
/* outline: �p�^�[���\����H��HDMI�o�͗p�ŏ�K�w */

module pattern_hdmi(
    input           CLK,
    // input           RST,  // V13=DDR DQS핀, PL에서 사용 불가 (항상 HIGH → 리셋 고정)
    output          HDMI_CLK_N, HDMI_CLK_P,
    output  [2:0]   HDMI_N, HDMI_P
);

wire [7:0] VGA_R,  VGA_G,  VGA_B;
wire       VGA_HS, VGA_VS, VGA_DE;
wire       PCK;

/* �p�^�[���\����H��ڑ� */
pattern pattern(
    .CLK    (CLK),
    .RST    (1'b0),  // RST 제거, 항상 리셋 해제
    .VGA_R  (VGA_R),
    .VGA_G  (VGA_G),
    .VGA_B  (VGA_B),
    .VGA_HS (VGA_HS),
    .VGA_VS (VGA_VS),
    .VGA_DE (VGA_DE),
    .PCK    (PCK)
);

/* HDMI�M������IP��ڑ� */
rgb2dvi #(
    .kClkPrimitive("MMCM"),
    //.kClkRange  (5)  // 640x480: 25MHz <= fPCK < 30MHz
    //.kClkRange  (4)  // 800x600: 30MHz <= fPCK < 40MHz, VCO=40*20=800MHz
    .kClkRange  (2)  // 1280x720: 60MHz <= fPCK < 120MHz, VCO=74.583*10=745.8MHz
    )
  rgb2dvi (
    .PixelClk   (PCK),
    .TMDS_Clk_n (HDMI_CLK_N),
    .TMDS_Clk_p (HDMI_CLK_P),
    .TMDS_Data_n(HDMI_N),
    .TMDS_Data_p(HDMI_P),
    .aRst       (1'b0),  // RST 제거, 항상 리셋 해제
    .vid_pData  ({VGA_R, VGA_B, VGA_G}),
    .vid_pHSync (VGA_HS),
    .vid_pVDE   (VGA_DE),
    .vid_pVSync (VGA_VS)
);

endmodule
