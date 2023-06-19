/*
A wrapper that wraps a DDS waveform_gen module 
to provide different waves, given some input data, 
and mode selection.

Uses sine as a carrier wave. 

BPSK -  data[0] => sine (phase shift = 0)
       !data[0] => ~sine (phase shift = 180)

QPSK - data = 00 => sine + cosine (phase shift = 315)
       data = 01 => sine - cosine (phase shift = 45)
       data = 10 => -sine + cosine (phase shift = 225)
       data = 11 => -sine - cosine (phase shift = 135)
*/

module DDS
#(
    /* Frequencies in Hz */
    parameter FREQ_HI =  5,             /* Frequency for "1" for FSK*/
    parameter FREQ_MID = 3,             /* Frequency for ASK, BPSK, QPSK */ 
    parameter FREQ_LO = 1,              /* Frequency for "0" for FSK */
    parameter FREQ_CLK = 50_000_000,    /* Sample Frequency, default 50Mhz*/
    
    /* Codes for different outputs */
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
    input logic clk,
    input logic rst, 
    input logic en,
    /*data[0] for FSK/ASK/BPSK,  data[1:0] for QPSK*/
    input logic [1:0] data,
    input logic [2:0] mode,
    output logic signed [11:0] wave
);

    /* Calculate phase_inc for various frequencies*/
    localparam [64:0] PHASE_INC_LO = ((FREQ_LO * (2**32)) / FREQ_CLK);
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

    /* Choose phase_inc depending on mode, and data for FSK*/
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

    /* Select output encoding based on mode and data */
    logic signed [12:0] qpsk_wave;
    always_comb begin
        case(data[1:0])
            2'b00: qpsk_wave = (sine + cosine);
            2'b01: qpsk_wave = (sine + ~cosine);
            2'b10: qpsk_wave = (~sine + cosine);
            2'b11: qpsk_wave = (~sine + ~cosine);
        endcase
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
            QPSK: wave = qpsk_wave[12:1];
        endcase
    end

    
endmodule