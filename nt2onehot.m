function sequence_onehot=nt2onehot(seq,L)
r_seq=seqrcomplement(seq);

seq=upper(seq);
seq=adjust_uncertain_nt(seq);

r_seq=upper(r_seq);
r_seq=adjust_uncertain_nt(r_seq);

fw_onehot=int8(zeros(L,4));
for i=1:1:min(L,size(seq,2))
    if seq(i)=='A'
        fw_onehot(i,:)=[0,0,0,1];
    elseif seq(i)=='C'
        fw_onehot(i,:)=[0,0,1,0];
    elseif seq(i)=='G'
        fw_onehot(i,:)=[0,1,0,0];
    elseif seq(i)=='T'
        fw_onehot(i,:)=[1,0,0,0];
    else
        disp('error')
    end
end

bw_onehot=int8(zeros(L,4));
for i=1:1:min(L,size(r_seq,2))
    if r_seq(i)=='A'
        bw_onehot(i,:)=[0,0,0,1];
    elseif r_seq(i)=='C'
        bw_onehot(i,:)=[0,0,1,0];
    elseif r_seq(i)=='G'
        bw_onehot(i,:)=[0,1,0,0];
    elseif r_seq(i)=='T'
        bw_onehot(i,:)=[1,0,0,0];
    else
        disp('error')
    end
end

fw_onehot=fw_onehot';
bw_onehot=bw_onehot';
sequence_onehot=[fw_onehot,bw_onehot];