`resetall
`timescale 1ns/1ps

`define	HALF_CYCLE 						5            //Modified your clock cycle here
`define	CYCLE							(`HALF_CYCLE*2)	 //If cycle time is set shorter than critical path, then your test will fail
`define	REG_SETUP_TIME					0.581
`define REG_DELAY						0.441

module test;

	reg   [3:0] Amem[100:1];	
	reg		[6:0]	Bmem[100:1];
	reg   [5:0] Cmem[100:1];
	reg	[14:0] ANSmem[100:1];
	reg	clk,rst;
	wire  [3:0] A;
	wire  [6:0] B;
	wire  [5:0] C;
	wire  [14:0] D;
	integer i;
	integer	err_cnt,errnum;	

  assign #(`REG_DELAY+`REG_SETUP_TIME) A=Amem[i];
  assign #(`REG_DELAY+`REG_SETUP_TIME) B=Bmem[i];
  assign #(`REG_DELAY+`REG_SETUP_TIME) C=Cmem[i];
 
	wire [50:0] DOQE_ppl_num;
	
  DOQE_ppl PPL(.clk(clk), .rst(rst), .A(A), .B(B), .C(C), .D(D), .DOQE_ppl_num(DOQE_ppl_num));

	initial
	begin
		clk = 1'b1;
		rst = 1'b1;
		i=0;
		err_cnt=32'd0;
		# 1
		rst = 1'b0;
		# (`HALF_CYCLE)
		rst = 1'b1;
	end

	always # (`HALF_CYCLE)
	begin
		clk = ~clk;
	end
	
	initial
	begin	
	  $readmemb("A.dat", Amem);       
		$readmemb("B.dat", Bmem);       
		$readmemb("C.dat", Cmem);     
		$readmemb("answer.dat",ANSmem);		  	
		$dumpfile("DOQE_ppl.fsdb");
    $dumpvars;
 	end

	always @(posedge clk)
	begin
		   i=i+1;
	end

  always @(posedge clk)
  begin
     if((i>=3) && (i<=102))
     begin
        #(`CYCLE-`REG_DELAY-`REG_SETUP_TIME);
     		if(~(D===ANSmem[i-2]))
      	   err_cnt=err_cnt+32'd1;                              	
 	 end
 	 if(i==103)
 	   begin
 	   		if(err_cnt==32'd0)
     			$display("Congratulations! Your score is 45!\n");
		    else
		    begin
		      $display("There are %d errors.\n", err_cnt);
		      $display("Your score is %f.\n", 45-err_cnt*0.4);		
		    end
				errnum=DOQE_ppl_num;
				$display("Number : %d.\n", errnum);
 		    $finish;	   
     end  	   
  end     
     


endmodule
