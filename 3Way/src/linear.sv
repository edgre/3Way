module linear(
  input  logic [95:0] iword,
  output logic [95:0] oword
);

logic [31:0] y0, y1, y2, x0, x1, x2;

/*always @(x) begin
x0 = x[31:0];
x1 = x[63:32];
x2 = x[95:64];
y0 = x0 ^ (x0>>16) ^ (x1<<16) ^ (x1>>16) ^ (x2<<16) ^ (x1>>24) ^ (x2<<8) ^ (x2>>8) ^ (x0<<24) ^ (x2>>16) ^ (x0<<16) ^ (x2>>24) ^ (x0<<8);
y1 = x1 ^ (x1>>16) ^ (x2<<16) ^ (x2>>16) ^ (x0<<16) ^ (x2>>24) ^ (x0<<8) ^ (x0>>8) ^ (x1<<24) ^ (x0>>16) ^ (x1<<16) ^ (x0>>24) ^ (x1<<8);
y2 = x2 ^ (x2>>16) ^ (x0<<16) ^ (x0>>16) ^ (x1<<16) ^ (x0>>24) ^ (x1<<8) ^ (x1>>8) ^ (x2<<24) ^ (x1>>16) ^ (x2<<16) ^ (x1>>24) ^ (x2<<8);
y = {y2, y1, y0};
end*/

assign oword = iword ^ (iword << 8) ^ (iword << 16) ^ (iword << 24) ^ (iword << 40) ^ (iword << 48) ^ (iword << 80) ^ iword[95:88] ^ iword[95:80] ^ iword[95:72] ^ iword[95:56] ^ iword[95:48] ^ iword[95:16];  

endmodule
