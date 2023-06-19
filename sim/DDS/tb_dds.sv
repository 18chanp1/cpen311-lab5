`timescale 10ns/10ns

module tb_DDS ();

    logic clk, rst, en;
    logic [1:0] data;
    logic [2:0] mode;
    logic signed [11:0] wave;

    parameter SINE = 3'b000;
    parameter COSINE = 3'b001;
    parameter SQUARE = 3'b010;
    parameter SAW = 3'b011;
    parameter ASK = 3'b100;
    parameter BPSK = 3'b101;
    parameter FSK = 3'b110;
    parameter QPSK = 3'b111;

    DDS #(.FREQ_CLK(200)) DUT 
    (
        .clk(clk),
        .rst(rst),
        .en(en),
        .data(data),
        .mode(mode),
        .wave(wave)
    );

    initial begin
        forever begin
            clk = 1'b0;
            #1;
            clk = 1'b1;
            #2;
        end
    end

    initial begin 
        en = 1'b1;
        rst = 1'b1;
        data = 2'b00;
        mode = SINE;

        #2;
        rst = 1'b0;

        #400;

        mode = COSINE;

        #400; 

        mode = SQUARE;

        #400;

        mode = SAW;

        #400;

        mode = ASK;
        data = 2'b01;
        #200
        data = 2'b00;
        #200;

        mode = BPSK;
        data = 2'b00;
        #200;
        data = 2'b01;
        #200

        mode = BPSK;
        data = 2'b00;
        #200;
        data = 2'b01;
        #200

        mode = FSK;
        data = 2'b00;
        #200;
        data = 2'b01;
        #200

        mode = QPSK;
        data = 2'b00;
        #200;
        data = 2'b01;
        #200
        data = 2'b10;
        #200;
        data = 2'b11;
        #200

        $stop;
    end

endmodule



