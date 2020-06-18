
`define FWIDTH 3

module FIFO_tb();
reg clk, rst, wr_en, rd_en ;
reg[7:0] f_in;
reg[7:0] tempdata;
wire [7:0] f_out;
wire [`FWIDTH :0] f_counter;

FIFO ff( .clk(clk), .rst(rst), .f_in(f_in), .f_out(f_out), 
         .wr_en(wr_en), .rd_en(rd_en), .f_empty(f_empty), 
         .f_full(f_full), .f_counter(f_counter) );

initial
begin
   clk = 0;
   rst = 1;
        rd_en = 0;
        wr_en = 0;
        tempdata = 0;
        f_in = 0;


        #15 rst = 0;
  
        push(1);
        fork
           push(2);
           pop(tempdata);
        join              //push and pop together   
        push(10);
        push(20);
        push(30);
        push(40);
        push(50);
        push(60);
        push(70);
        push(80);
        push(90);
        push(100);
        push(110);
        push(120);
        push(130);

        pop(tempdata);
        push(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
   push(140);
        pop(tempdata);
        push(tempdata);//
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        pop(tempdata);
        push(5);
        pop(tempdata);
end

always
   #5 clk = ~clk;

task push;
input[7:0] data;


   if( f_full )
            $display("---Cannot push: Buffer Full---");
        else
        begin
           $display("Pushed ",data );
           f_in = data;
           wr_en = 1;
                @(posedge clk);
                #1 wr_en = 0;
        end

endtask

task pop;
output [7:0] data;

   if( f_empty )
            $display("---Cannot Pop: Buffer Empty---");
   else
        begin

     rd_en = 1;
          @(posedge clk);

          #1 rd_en = 0;
          data = f_out;
           $display("-------------------------------Poped ", data);

        end
endtask

endmodule
