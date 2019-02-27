function adjust_seq=adjust_uncertain_nt(seq)
adjust_seq=seq;
for i=1:1:size(adjust_seq,2)
    if adjust_seq(i)=='N'
        adjust_seq(i)='G';
    elseif adjust_seq(i)=='X'
        adjust_seq(i)='A';
    elseif adjust_seq(i)=='H'
        adjust_seq(i)='T';
    elseif adjust_seq(i)=='M'
        adjust_seq(i)='C';
    elseif adjust_seq(i)=='K'
        adjust_seq(i)='G';
    elseif adjust_seq(i)=='D'
        adjust_seq(i)='A';
    elseif adjust_seq(i)=='R'
        adjust_seq(i)='G';
    elseif adjust_seq(i)=='Y'
        adjust_seq(i)='T';
    elseif adjust_seq(i)=='S'
        adjust_seq(i)='C';
    elseif adjust_seq(i)=='W'
        adjust_seq(i)='A';
    elseif adjust_seq(i)=='B'
        adjust_seq(i)='C';
    elseif adjust_seq(i)=='V'
        adjust_seq(i)='G';
    end
end