function condon_onehot=condon2onehot(seq,L)
r_seq=seqrcomplement(seq);

seq=upper(seq);
seq=adjust_uncertain_nt(seq);

r_seq=upper(r_seq);
r_seq=adjust_uncertain_nt(r_seq);

condon_fw1=int8(zeros(floor(L/3),64));
condon_fw2=int8(zeros(floor(L/3),64));
condon_fw3=int8(zeros(floor(L/3),64));
n=1;
for i=1:3:min(L,size(seq,2))-4
    ii=i;
    index=nt2num(seq(ii))*(4^2)+nt2num(seq(ii+1))*(4^1)+nt2num(seq(ii+2))+1;
    condon_fw1(n,index)=1;
    ii=i+1;
    index=nt2num(seq(ii))*(4^2)+nt2num(seq(ii+1))*(4^1)+nt2num(seq(ii+2))+1;
    condon_fw2(n,index)=1;
    ii=i+2;
    index=nt2num(seq(ii))*(4^2)+nt2num(seq(ii+1))*(4^1)+nt2num(seq(ii+2))+1;
    condon_fw3(n,index)=1;
    n=n+1;
end

condon_bw1=int8(zeros(floor(L/3),64));
condon_bw2=int8(zeros(floor(L/3),64));
condon_bw3=int8(zeros(floor(L/3),64));
n=1;
for i=1:3:min(L,size(r_seq,2))-4
    ii=i;
    index=nt2num(r_seq(ii))*(4^2)+nt2num(r_seq(ii+1))*(4^1)+nt2num(r_seq(ii+2))+1;
    condon_bw1(n,index)=1;
    ii=i+1;
    index=nt2num(r_seq(ii))*(4^2)+nt2num(r_seq(ii+1))*(4^1)+nt2num(r_seq(ii+2))+1;
    condon_bw2(n,index)=1;
    ii=i+2;
    index=nt2num(r_seq(ii))*(4^2)+nt2num(r_seq(ii+1))*(4^1)+nt2num(r_seq(ii+2))+1;
    condon_bw3(n,index)=1;
    n=n+1;
end

condon_fw1=condon_fw1';
condon_fw2=condon_fw2';
condon_fw3=condon_fw3';
condon_bw1=condon_bw1';
condon_bw2=condon_bw2';
condon_bw3=condon_bw3';
condon_onehot=[condon_fw1,condon_fw2,condon_fw3,condon_bw1,condon_bw2,condon_bw3];