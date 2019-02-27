function NtNum=nt2num(nt)
%%%将核酸转化为四进制数字

switch nt
    case 'A'
        NtNum=0;
    case 'C'
        NtNum=1;
    case 'G'
        NtNum=2;
    case 'T'
        NtNum=3;
    case 'N'
        NtNum=2;
    case 'X'
        NtNum=0;
    case 'H'
        NtNum=3;
    case 'M'
        NtNum=1;
    case 'K'
        NtNum=2;
    case 'D'
        NtNum=0;
    case 'R'
        NtNum=2;
    case 'Y'
        NtNum=3;
    case 'S'
        NtNum=1;
    case 'W'
        NtNum=0;
    case 'B'
        NtNum=1;
    case 'V'
        NtNum=2;
end
end