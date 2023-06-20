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

    parameter CYCLE = 900;

    DDS #(.FREQ_CLK(300)) DUT 
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

    task testop(int operation, int inp);
        mode = operation;
        data = inp;
        #CYCLE;
    endtask

    initial begin 
        en = 1'b1;
        rst = 1'b1;
        data = 2'b00;
        mode = SINE;

        #2;
        rst = 1'b0;
        #2;

        testop(SINE, 0);
        testop(SQUARE, 0);
        testop (SAW, 0);
        testop (ASK, 0);
        testop (ASK, 1);
        testop (BPSK, 0);
        testop (BPSK, 1);
        testop (FSK, 0);
        testop (FSK, 1);
        testop (QPSK, 0);
        testop (QPSK, 1);
        testop(QPSK, 2);
        testop(QPSK, 3);

        $stop;
    end

endmodule



