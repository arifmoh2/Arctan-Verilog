@echo off
REM ****************************************************************************
REM Vivado (TM) v2018.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Thu Jul 19 13:56:53 -0400 2018
REM SW Build 2188600 on Wed Apr  4 18:40:38 MDT 2018
REM
REM Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
call xelab  -wto e7da9da051d548ed838d83cad19a4d46 --incr --debug typical --relax --mt 2 -L xbip_utils_v3_0_9 -L c_reg_fd_v12_0_5 -L xbip_dsp48_wrapper_v3_0_4 -L xbip_pipe_v3_0_5 -L xbip_dsp48_addsub_v3_0_5 -L xbip_addsub_v3_0_5 -L c_addsub_v12_0_12 -L xbip_bram18k_v3_0_5 -L mult_gen_v12_0_14 -L axi_utils_v2_0_5 -L cordic_v6_0_14 -L xil_defaultlib -L floating_point_v7_0_15 -L xbip_dsp48_mult_v3_0_5 -L xbip_dsp48_multadd_v3_0_5 -L div_gen_v5_1_13 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot test_atan_behav xil_defaultlib.test_atan xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
