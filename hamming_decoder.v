module hamming_decoder(output reg[10:0]  out, // mesaj corectat
                       output reg[3:0] error_index, // numarul bitului corectat (1-15)
                       output reg error, // 1 daca a fost detectata cel putin o eroare
                       output reg uncorrectable, // 1 daca au fost detectate doua erori
                       input[16:1] in);

reg correction_parity;
reg[16:1] IN;

integer i;

always @(*) begin
  IN = in;

  error_index[0] = in[1] + in[3] + in[5] + in[7] + in[9] + in[11] + in[13] + in[15];
  error_index[1] = in[2] + in[3] + in[6] + in[7] + in[10] + in[11] + in[14] + in[15];
  error_index[2] = in[4] + in[5] + in[6] + in[7] + in[12] + in[13] + in[14] + in[15];
  error_index[3] = in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15];

  if(error_index == 4'b0000) begin
    error = 0;
    uncorrectable = 0;

    out[0] = in[3];
    out[1] = in[5];
    out[2] = in[6];
    out[3] = in[7];
    out[4] = in[9];
    out[5] = in[10];
    out[6] = in[11];
    out[7] = in[12];
    out[8] = in[13];
    out[9] = in[14];
    out[10] = in[15];
  end else begin
    error = 1;
    uncorrectable = 0;

    for(i=1; i<=15; i=i+1) begin
      if(i == error_index) begin
        IN[i] = !IN[i];
      end
    end

    correction_parity = IN[1] + IN[2] + IN[3] + IN[4] + IN[5] + IN[6] + IN[7] + IN[8] + IN[9] + IN[10] + IN[11] + IN[12] + IN[13] + IN[14] + IN[15];

    if(correction_parity != in[16]) begin
      uncorrectable = 1;
    end
  end
end

endmodule