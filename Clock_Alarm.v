module Clock_Alarm
(
    input clk,
    input reset,
    input Set_Clock,
//    input Set_Alarm,
//    input Alarm_Off,
	 input MIN,
	 input enable,
   
//    output Alarm_Out,
    output a_s_u, b_s_u, c_s_u, d_s_u, e_s_u, f_s_u, g_s_u,
    output a_s_t, b_s_t, c_s_t, d_s_t, e_s_t, f_s_t, g_s_t,
    output a_m_u, b_m_u, c_m_u, d_m_u, e_m_u, f_m_u, g_m_u,
    output a_m_t, b_m_t, c_m_t, d_m_t, e_m_t, f_m_t, g_m_t,
    output a_h_u, b_h_u, c_h_u, d_h_u, e_h_u, f_h_u, g_h_u,
    output a_h_t, b_h_t, c_h_t, d_h_t, e_h_t, f_h_t, g_h_t
);

localparam SECONDS = 10;
localparam MINUTES = 6;
localparam HOURS = 3;
localparam WORD_LENGTH = 4;

wire [3:0] counter_s_u;
wire [3:0] set_s_u_clk;
wire [3:0] set_s_u_clk_wire;
wire [3:0] counter_s_u_wire;
wire [2:0] counter_s_t;
wire [2:0] set_s_t_clk;
wire [2:0] set_s_t_clk_wire;
wire [2:0] counter_s_t_wire;
wire [3:0] counter_m_u;
wire [2:0] counter_m_t;
wire [1:0] counter_h_u;
wire [1:0] counter_h_t;
wire flag_m_u_wire;
wire flag_m_t_wire;
wire s_u_wire;
wire s_t_wire;
wire m_u_wire;
wire m_t_wire;
wire h_u_wire;
wire h_t_wire;
wire clock_signal;
wire shot_wire;
wire set_min;
wire Set_Clock_wire;

assign Set_Clock_wire = ~Set_Clock;
assign set_min = MIN;

Clock_Divider
#(
	// Parameter Declarations
	.FREQUENCY(10),
	.REFERENCE_CLOCK(50_000_000)
)
Clock_Hz
(
	// Input Ports
	.clk_FPGA(clk),
	.reset(reset),
	
	// Output Ports
	.clock_signal(clock_signal)
)
;

Control
Contro_Clock
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.Start(Set_Clock_wire),

	// Output Ports
	.Shot(shot_wire)
)
;

Counter_With_Parameter
#(
	// Parameter Declarations
	.MAXIMUM_VALUE(SECONDS)
)
Increase_Minutes_U
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.enable(MIN),
	
	// Output Ports
	.flag(flag_m_u_wire),
	.counter(counter_s_u_wire)
)
;

Multiplexer2to1
#(
	.N_BITS(SECONDS)
)
Mux_Set_Clk_M_U
(
	// Input Ports
	.Selector(Set_Clock_wire),
	.Data_0(5),
	.Data_1(counter_s_u_wire),
	
	// Output Ports
	.Mux_Output(set_s_u_clk_wire)

)
;
/*
Register_With_Enable
#(
	.WORD_LENGTH(SECONDS)
)
Reg_Set_Clk_M_U
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.enable(shot_wire),
	.Data_Input(set_s_u_clk),

	// Output Ports
	.Data_Output(set_s_u_clk_wire)
);
*/
Counter_With_Parameter
#(
	// Parameter Declarations
	.MAXIMUM_VALUE(MINUTES)
)
Increase_Minutes_T
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.enable(MIN & flag_m_u_wire),
	
	// Output Ports
	.flag(),
	.counter(counter_s_t_wire)
);

Multiplexer2to1
#(
	.N_BITS(MINUTES)
)
Mux_Set_Clk_M_T
(
	// Input Ports
	.Selector(Set_Clock_wire),
	.Data_0(3),
	.Data_1(counter_s_t_wire),
	
	// Output Ports
	.Mux_Output(set_s_t_clk_wire)

);
/*
Register_With_Enable
#(
	.WORD_LENGTH(MINUTES)
)
Reg_Set_Clk_M_T
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.enable(shot_wire),
	.Data_Input(set_s_t_clk),

	// Output Ports
	.Data_Output(set_s_t_clk_wire)
);
*/
Counter_A_D
#(
	// Parameter Declarations
	.MAXIMUM_VALUE(SECONDS)
)
Counter_Seconds_Units
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.enable(enable),
	.start(shot_wire),
	.set_counter(5),
	
	// Output Ports
	.flag(s_u_wire),
	.counter(counter_s_u)
)
;

Counter_A_D
#(
	// Parameter Declarations
	.MAXIMUM_VALUE(MINUTES)
)
Counter_Seconds_Tens
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.enable(enable & s_u_wire),
	.start(shot_wire),
	.set_counter(2),
	
	// Output Ports
	.flag(s_t_wire),
	.counter(counter_s_t)
)
;

Counter_A_D
#(
	// Parameter Declarations
	.MAXIMUM_VALUE(SECONDS)
)
Counter_Minutes_Units
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.enable(enable & s_u_wire & s_t_wire),
	.start(shot_wire),
	.set_counter(set_s_u_clk_wire),
	
	// Output Ports
	.flag(m_u_wire),
	.counter(counter_m_u)
)
;

Counter_A_D
#(
	// Parameter Declarations
	.MAXIMUM_VALUE(MINUTES)
)
Counter_Minutes_Tens
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.enable(enable & s_u_wire & s_t_wire & m_u_wire),
	.start(shot_wire),
	.set_counter(set_s_t_clk_wire),
	
	// Output Ports
	.flag(m_t_wire),
	.counter(counter_m_t)
)
;

Counter_A_D
#(
	// Parameter Declarations
	.MAXIMUM_VALUE(WORD_LENGTH)
)
Counter_Hours_Units
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.start(shot_wire),
	.set_counter(2),
	.enable(enable & s_u_wire & s_t_wire & m_u_wire & m_t_wire),
	
	// Output Ports
	.flag(h_u_wire),
	.counter(counter_h_u)
)
;

Counter_A_D
#(
	// Parameter Declarations
	.MAXIMUM_VALUE(HOURS)
)
Counter_Hour_Tens
(
	// Input Ports
	.clk(clock_signal),
	.reset(reset),
	.start(shot_wire),
	.set_counter(1),
	.enable(enable & s_u_wire & s_t_wire & m_u_wire & m_t_wire & h_u_wire),
	
	// Output Ports
	.flag(),
	.counter(counter_h_t)
)
;

BCD_to_7Seg_Table
BCD_S_U
(
	// Input Ports
	.bcd(counter_s_u),
	
	// Output Ports
	.a(a_s_u), 
	.b(b_s_u), 
	.c(c_s_u),
	.d(d_s_u), 
	.e(e_s_u), 
	.f(f_s_u), 
	.g(g_s_u)
)
;

BCD_to_7Seg_Table
BCD_S_T
(
	// Input Ports
	.bcd({1'b0,counter_s_t}),
	
	// Output Ports
	.a(a_s_t), 
	.b(b_s_t), 
	.c(c_s_t),
	.d(d_s_t), 
	.e(e_s_t), 
	.f(f_s_t), 
	.g(g_s_t)
)
;	

BCD_to_7Seg_Table
BCD_M_U
(
	// Input Ports
	.bcd(counter_m_u),
	
	// Output Ports
	.a(a_m_u), 
	.b(b_m_u), 
	.c(c_m_u),
	.d(d_m_u), 
	.e(e_m_u), 
	.f(f_m_u), 
	.g(g_m_u)
)
;

BCD_to_7Seg_Table
BCD_M_T
(
	// Input Ports
	.bcd({1'b0,counter_m_t}),
	
	// Output Ports
	.a(a_m_t), 
	.b(b_m_t), 
	.c(c_m_t),
	.d(d_m_t), 
	.e(e_m_t), 
	.f(f_m_t), 
	.g(g_m_t)
)
;	

BCD_to_7Seg_Table
BCD_H_U
(
	// Input Ports
	.bcd({2'b00,counter_h_u}),
	
	// Output Ports
	.a(a_h_u), 
	.b(b_h_u), 
	.c(c_h_u),
	.d(d_h_u), 
	.e(e_h_u), 
	.f(f_h_u), 
	.g(g_h_u)
)
;

BCD_to_7Seg_Table
BCD_H_T
(
	// Input Ports
	.bcd({2'b00,counter_h_t}),
	
	// Output Ports
	.a(a_h_t), 
	.b(b_h_t), 
	.c(c_h_t),
	.d(d_h_t), 
	.e(e_h_t), 
	.f(f_h_t), 
	.g(g_h_t)
)
;

endmodule 