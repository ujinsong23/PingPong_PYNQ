-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2.2 (win64) Build 3118627 Tue Feb  9 05:14:06 MST 2021
-- Date        : Mon Dec 13 14:52:31 2021
-- Host        : DESKTOP-J9SD0U4 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_HDMI_TOP_0_3_stub.vhdl
-- Design      : design_1_HDMI_TOP_0_3
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  Port ( 
    CLK : in STD_LOGIC;
    RST_BTN : in STD_LOGIC;
    btn1 : in STD_LOGIC;
    btn2 : in STD_LOGIC;
    restart : in STD_LOGIC;
    hdmi_tx_cec : inout STD_LOGIC;
    hdmi_tx_hpd : in STD_LOGIC;
    hdmi_tx_rscl : inout STD_LOGIC;
    hdmi_tx_rsda : inout STD_LOGIC;
    hdmi_tx_clk_n : out STD_LOGIC;
    hdmi_tx_clk_p : out STD_LOGIC;
    hdmi_tx_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    hdmi_tx_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    clk_lock : out STD_LOGIC;
    de : out STD_LOGIC;
    led : out STD_LOGIC;
    state_led : out STD_LOGIC_VECTOR ( 2 downto 0 )
  );

end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture stub of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "CLK,RST_BTN,btn1,btn2,restart,hdmi_tx_cec,hdmi_tx_hpd,hdmi_tx_rscl,hdmi_tx_rsda,hdmi_tx_clk_n,hdmi_tx_clk_p,hdmi_tx_n[2:0],hdmi_tx_p[2:0],clk_lock,de,led,state_led[2:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "HDMI_TOP,Vivado 2020.2.2";
begin
end;
