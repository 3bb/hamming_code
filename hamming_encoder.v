module hamming_encoder(output[16:1] out, input[10:0] in);

xor(out[1], in[0], in[1], in[3], in[4], in[6], in[8], in[10]); //p1
xor(out[2], in[0], in[2], in[3], in[5], in[6], in[9], in[10]); //p2
assign out[3] = in[0];
xor(out[4], in[1], in[2], in[3], in[7], in[8], in[9], in[10]); //p3
assign out[5] = in[1];
assign out[6] = in[2];
assign out[7] = in[3];
xor(out[8], in[4], in[5], in[6], in[7], in[8], in[9], in[10]); //p4
assign out[9] = in[4];
assign out[10] = in[5];
assign out[11] = in[6];
assign out[12] = in[7];
assign out[13] = in[8];
assign out[14] = in[9];
assign out[15] = in[10];
assign out[16] = out[1] + out[2] + out[3] + out[4] + out[5] + out[6] + out[7] + out[8] + out[9] + out[10] + out[11] + out[12] + out[13] + out[14] + out[15];

endmodule