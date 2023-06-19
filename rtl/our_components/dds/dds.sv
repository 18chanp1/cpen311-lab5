module DDS
#(
    
    parameter FREQ_HI =  5, /* Frequency for "1" for FSK */
    parameter FREQ_MID = 3,  /* Frequency for ASK, BPSK, QPSK */ 
    parameter FREQ_LO = 1,  /* Frequency for "0" for FSK */
    /* Sample Frequency */
    parameter FREQ_CLK = 50_000_000,
    
    parameter SINE = 3'b000,
    parameter COSINE = 3'b001,
    parameter SQUARE = 3'b010,
    parameter SAW = 3'b011,
    parameter ASK = 3'b100,
    parameter BPSK = 3'b101,
    parameter FSK = 3'b110,
    parameter QPSK = 3'b111
)
(
    input logic clk, /* 50 Mhz */
    input logic rst, 
    input logic en,
    /*1 bit input for FSK/ASK/BPSK, 2 bits for QPSK*/
    input logic [1:0] data,
    input logic [2:0] mode,
    output logic signed [11:0] wave
);

    localparam [64:0] PHASE_INC_LO = (FREQ_LO * (2**32)) / FREQ_CLK;
    localparam [64:0] PHASE_INC_MID = ((FREQ_MID * (2**32)) / FREQ_CLK);
    localparam [64:0] PHASE_INC_HI = ((FREQ_HI * (2**32)) / FREQ_CLK);

    logic [31:0] phase_inc;
    logic signed [11:0] sine, cosine, square, saw;
    waveform_gen DDS 
    (
        .clk(clk),
        .reset(~rst),
        .en(en),
        .phase_inc(phase_inc),
        .sin_out(sine),
        .cos_out(cosine),
        .squ_out(square),
        .saw_out(saw)
    );

    always_comb begin
        if (mode == FSK)
        begin
            phase_inc = data[0] ? PHASE_INC_HI : PHASE_INC_LO;
        end
        else
        begin
            phase_inc = PHASE_INC_MID;
        end
    end 


    always_comb begin
        case (mode)
            SINE: wave = sine;
            COSINE: wave = cosine;
            SQUARE: wave = square;
            SAW: wave = saw;
            ASK: wave = data[0] ? sine : 12'b0;
            BPSK: wave = data[0] ? ~sine : sine;
            FSK: wave = sine;
            QPSK:
            begin
                case(data[1:0])
                    2'b00: wave = (sine + cosine);
                    2'b01: wave = (sine + ~cosine);
                    2'b10: wave = (~sine + cosine);
                    2'b11: wave = (~sine + ~cosine);
                endcase
            end
        endcase
    end
endmodule