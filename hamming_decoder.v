module hamming_decoder(output[10:0]  out, // mesaj corectat
                       output[3:0] error_index, // numarul bitului corectat (1-15)
                       output reg error, // 1 daca a fost detectata cel putin o eroare
                       output reg uncorrectable, // 1 daca au fost detectate doua erori
                       input[16:1] in);

reg correction_parity;
integer i;
reg out;
reg error_index;
reg error;
reg uncorrectable;


always @(*)
begin
  assign error_index[0] = in[1] + in[3] + in[5] + in[7] + in[9] + in[11] + in[13] + in[15];
  assign error_index[1] = in[2] + in[3] + in[6] + in[7] + in[10] + in[11] + in[14] + in[15];
  assign error_index[2] = in[4] + in[5] + in[6] + in[7] + in[12] + in[13] + in[14] + in[15];
  assign error_index[3] = in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15];

  if(error_index == 4'b0000) begin
    assign error = 0;
    assign uncorrectable = 0;

    assign out[0] = in[3];
    assign out[1] = in[5];
    assign out[2] = in[6];
    assign out[3] = in[7];
    assign out[4] = in[9];
    assign out[5] = in[10];
    assign out[6] = in[11];
    assign out[7] = in[12];
    assign out[8] = in[13];
    assign out[9] = in[14];
    assign out[10] = in[15];
  end else begin
    assign error = 1;
    assign uncorrectable = 0;

    for(i=1; i<=15; i=i+1) begin
      if(i == error_index) begin
        assign in[i] = !in[1];
      end
    end

    assign correction_parity = in[1] + in[2] + in[3] + in[4] + in[5] + in[6] + in[7] + in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15];

    if(correction_parity != in[16]) begin
      assign uncorrectable = 1;
    end
  end
end

endmodule