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

  //calculam indexul erorii

  error_index[0] = in[1] + in[3] + in[5] + in[7] + in[9] + in[11] + in[13] + in[15];
  error_index[1] = in[2] + in[3] + in[6] + in[7] + in[10] + in[11] + in[14] + in[15];
  error_index[2] = in[4] + in[5] + in[6] + in[7] + in[12] + in[13] + in[14] + in[15];
  error_index[3] = in[8] + in[9] + in[10] + in[11] + in[12] + in[13] + in[14] + in[15];

  //calculul paritatii intr-o variabila pentru usurinta in scriere

  correction_parity = in[1] ^ in[2] ^ in[3] ^ in[4] ^ in[5] ^ in[6] ^ in[7] ^ in[8] ^ in[9] ^ in[10] ^ in[11] ^ in[12] ^ in[13] ^ in[14] ^ in[15];

  if(error_index == 4'b0000) begin            //cazul in care nu exista nicio eroare

    if(correction_parity == in[16]) begin     //subcaz in care paritatea coincide
      error = 0;                              //astfel iesirea ramane nemodificata
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
    end
    else begin                                 // subcaz in care paritatea nu coincide
      error = 1;                               //eroare pe 2 biti. iesirea ramane nemodificata
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
    end
  end
  else begin                                  //trecem pe cazul in care indexul e diferit de 0

    if(correction_parity == in[16]) begin     //subcazul in care paritatea coincide
      error = 1;                              //eroare pe 2 biti. ramane nemodificat
      uncorrectable = 1;
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
    end else begin                              //subcazul in care paritatea diferita
      error = 1;                                //eroare pe 1 bit. se vor face modificarile aferente
      uncorrectable = 0;                        //valorilor de in (corectia efectiva), apoi alocare la out

      IN = in;
      IN[error_index] = !IN[error_index];
      out[0] = IN[3];
      out[1] = IN[5];
      out[2] = IN[6];
      out[3] = IN[7];
      out[4] = IN[9];
      out[5] = IN[10];
      out[6] = IN[11];
      out[7] = IN[12];
      out[8] = IN[13];
      out[9] = IN[14];
      out[10] = IN[15];
    end
  end

end

endmodule