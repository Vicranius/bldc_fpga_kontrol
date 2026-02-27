`timescale 1ns / 1ps //1 nanosaniye

module tb_bldc_comutation();

    // Stm32 den gelecek sinyalleri simule edilmesi
    reg clk;
    reg enable;
    reg dir;
    reg pwm_in;
    reg [2:0] hall_sensor;

    // Mosa gidenler 
    wire uh, ul, vh, vl, wh, wl;

    //UUT - Unit Under Test
    bldc_comutation uut (
        .clk(clk),
        .enable(enable),
        .dir(dir),
        .pwm_in(pwm_in),
        .hall_sensor(hall_sensor),
        .uh(uh), .ul(ul),
        .vh(vh), .vl(vl),
        .wh(wh), .wl(wl)
    );

    always #10 clk = ~clk; //50MHz 20nS periyot

    always #250 pwm_in = ~pwm_in; //sanal PWM

    // Waveform
    initial begin
        clk = 0;
        enable = 0;
        dir = 1;       // Ileri yon
        pwm_in = 0;
        hall_sensor = 3'b000;
		  
        #1000;// delay
        enable = 1;

        hall_sensor = 3'b101; #5000; // Adım 1
        hall_sensor = 3'b100; #5000; // Adım 2
        hall_sensor = 3'b110; #5000; // Adım 3
        hall_sensor = 3'b010; #5000; // Adım 4
        hall_sensor = 3'b011; #5000; // Adım 5
        hall_sensor = 3'b001; #5000; // Adım 6

        // Acil stop
        enable = 0;
        #2000;

        $stop;
    end

endmodule