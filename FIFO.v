`define FWIDTH 3    // FSIZE = 16 -> FWIDTH = 4, no. of bits to be used in pointer
`define FSIZE ( 1<<`FWIDTH )

module FIFO( clk, rst, f_in, f_out, wr_en, rd_en, f_empty, f_full, f_counter );

input                 rst, clk, wr_en, rd_en;   
// reset, system clock, write enable and read enable.
input [7:0]           f_in;                   
// data input to be pushed to buffer
output[7:0]           f_out;                  
// port to output the data using pop.
output                f_empty, f_full;      
// buffer empty and full indication 
output[`FWIDTH :0] f_counter;             
// number of data pushed in to buffer   

reg[7:0]              f_out;
reg                   f_empty, f_full;
reg[`FWIDTH :0]    f_counter;
reg[`FWIDTH -1:0]  rd_ptr, wr_ptr;           // pointer to read and write addresses  
reg[7:0]              f_mem[`FSIZE -1 : 0]; //  

always @(f_counter)
begin
   f_empty = (f_counter==0);
   f_full = (f_counter== `FSIZE);

end

always @(posedge clk or posedge rst)
begin
   if( rst )
       f_counter <= 0;

   else if( (!f_full && wr_en) && ( !f_empty && rd_en ) )
       f_counter <= f_counter;

   else if( !f_full && wr_en )
       f_counter <= f_counter + 1;

   else if( !f_empty && rd_en )
       f_counter <= f_counter - 1;
   else
      f_counter <= f_counter;
end

always @( posedge clk or posedge rst)
begin
   if( rst )
      f_out <= 0;
   else
   begin
      if( rd_en && !f_empty )
         f_out <= f_mem[rd_ptr];

      else
         f_out <= f_out;

   end
end

always @(posedge clk)
begin

   if( wr_en && !f_full )
      f_mem[ wr_ptr ] <= f_in;

   else
      f_mem[ wr_ptr ] <= f_mem[ wr_ptr ];
end

always@(posedge clk or posedge rst)
begin
   if( rst )
   begin
      wr_ptr <= 0;
      rd_ptr <= 0;
   end
   else
   begin
      if( !f_full && wr_en )    wr_ptr <= wr_ptr + 1;
          else  wr_ptr <= wr_ptr;

      if( !f_empty && rd_en )   rd_ptr <= rd_ptr + 1;
      else rd_ptr <= rd_ptr;
   end

end
endmodule
