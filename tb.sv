class EthPacket;

rand int unsigned len;
rand byte payload[];

constraint len_c { len inside {[4:8]}; }
constraint size_c { payload.size()==len; }

endclass


module tb;

EthPacket p=new();

covergroup pkt_cg;
    coverpoint p.len {
        bins sizes[] = {[4:8]};
    }
endgroup

pkt_cg cg=new();

initial begin
    $shm_open("waves.shm");
    $shm_probe("AS");

    repeat(50) begin
        assert(p.randomize());
        cg.sample();

        $display("LEN=%0d DATA=%p",p.len,p.payload);
    end

    $display("Coverage=%0.2f%%",cg.get_inst_coverage());
    $finish;
end

endmodule
