module bldc_comutation (
    input wire clk,               
    input wire enable,            
    input wire dir,  // direction
    input wire pwm_in,            
    input wire [2:0] hall_sensor, // Hall sensorleri (H3, H2, H1)
    
    // Mos a gidecek 6 cikis
    output reg uh, output reg ul,
    output reg vh, output reg vl,
    output reg wh, output reg wl
);

    always @(posedge clk) begin // Her clockta kontrol
        if (!enable) begin
            {uh, ul, vh, vl, wh, wl} <= 6'b000000;
        end else begin
            if (dir == 1'b1) begin
                //Ileri yon 6 step 120 derece
                case (hall_sensor)
                    3'b101: {uh, ul, vh, vl, wh, wl} <= {pwm_in, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0}; // U+, V-
                    3'b100: {uh, ul, vh, vl, wh, wl} <= {pwm_in, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1}; // U+, W-
                    3'b110: {uh, ul, vh, vl, wh, wl} <= {1'b0, 1'b0, pwm_in, 1'b0, 1'b0, 1'b1}; // V+, W-
                    3'b010: {uh, ul, vh, vl, wh, wl} <= {1'b0, 1'b1, pwm_in, 1'b0, 1'b0, 1'b0}; // V+, U-
                    3'b011: {uh, ul, vh, vl, wh, wl} <= {1'b0, 1'b1, 1'b0, 1'b0, pwm_in, 1'b0}; // W+, U-
                    3'b001: {uh, ul, vh, vl, wh, wl} <= {1'b0, 1'b0, 1'b0, 1'b1, pwm_in, 1'b0}; // W+, V-
                    default: {uh, ul, vh, vl, wh, wl} <= 6'b000000; //stop
                endcase
            end else begin // geri yon icin 
                {uh, ul, vh, vl, wh, wl} <= 6'b000000;
            end
        end
    end
endmodule