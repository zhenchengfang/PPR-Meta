function PPR(SeqFile,ResultFile,t,tmp)
if nargin==2
    t='0';
end

%load('double_index.mat');
%load('delete_index.mat');
t=str2num(t);

%disp('Importing sequences...')
data=fastaread(SeqFile);

%%%data preprocessing%%%
%disp('Data preprocessing...')
for i=1:1:size(data,1)
    seq=data(i).Sequence;
    seq=upper(seq);
    seq=adjust_uncertain_nt(seq);
    data(i).Sequence=seq;
    %disp(i)
end
%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Sequence sorting%%%
Group_A=[];
Group_B=[];
Group_C=[];
Group_L=[];
cA=1;
cB=1;
cC=1;
cL=1;
for i=1:1:size(data,1)
    seq=data(i).Sequence;
    L=size(seq,2);
    if L<=400
        Group_A(cA,1).Header=data(i).Header;
        Group_A(cA,1).Sequence=seq;
        Group_A(cA,1).Length=L;
        Group_A(cA,1).Index=i;
        cA=cA+1;
    elseif L>=401 && L<=800
        Group_B(cB,1).Header=data(i).Header;
        Group_B(cB,1).Sequence=seq;
        Group_B(cB,1).Length=L;
        Group_B(cB,1).Index=i;
        cB=cB+1;
    elseif L>=801 && L<=4999
        Group_C(cC,1).Header=data(i).Header;
        Group_C(cC,1).Sequence=seq;
        Group_C(cC,1).Length=L;
        Group_C(cC,1).Index=i;
        cC=cC+1;
    elseif L>=5000
        Group_L(cL,1).Header=data(i).Header;
        Group_L(cL,1).Sequence=seq;
        Group_L(cL,1).Length=L;
        Group_L(cL,1).Index=i;
        cL=cL+1;
    end
    data(i).Header=[];
    data(i).Sequence=[];
    %disp(i)
end
clear data
%%%%%%%%%%%%%%%%%%%%%%%

%%%predict Group_A%%%
disp(' ')
%disp('Predicting')
if ~isempty(Group_A)
    nt_onehot=zeros(4,800*size(Group_A,1),'int8');
    for i=1:1:size(Group_A,1)
        nt_onehot(:,(i-1)*800+1:i*800)=nt2onehot(Group_A(i).Sequence,400);
    end
    save([pwd,'/',tmp,'nt_onehot.mat'],'nt_onehot','-v7.3')
    clear nt_onehot
    
    condon_onehot=zeros(64,798*size(Group_A,1),'int8');
    for i=1:1:size(Group_A,1)
        condon_onehot(:,(i-1)*798+1:i*798)=condon2onehot(Group_A(i).Sequence,400);
        Group_A(i,1).Sequence=[];
    end
    save([pwd,'/',tmp,'condon_onehot.mat'],'condon_onehot','-v7.3')
    clear condon_onehot
    
    csvwrite([pwd,'/',tmp,'nt_length.csv'],800);
    csvwrite([pwd,'/',tmp,'condon_length.csv'],798);
    
    cmd=['python ',pwd,'/predict.py ',pwd,'/model_a.h5 ',pwd,'/',tmp];unix(cmd);
    delete([pwd,'/',tmp,'nt_length.csv']);
    delete([pwd,'/',tmp,'condon_length.csv']);
    delete([pwd,'/',tmp,'nt_onehot.mat']);
    delete([pwd,'/',tmp,'condon_onehot.mat']);
        
    predict=dlmread([pwd,'/',tmp,'predict.csv']);
    delete([pwd,'/',tmp,'predict.csv']);
    
    for i=1:1:size(Group_A,1)
        Group_A(i,1).phage_score=predict(i,1);
        Group_A(i,1).chromosome_score=predict(i,2);
        Group_A(i,1).plasmid_score=predict(i,3);
    end
    clear predict;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%predict Group_B%%%
disp(' ')
if ~isempty(Group_B)
    nt_onehot=zeros(4,1600*size(Group_B,1),'int8');
    for i=1:1:size(Group_B,1)
        nt_onehot(:,(i-1)*1600+1:i*1600)=nt2onehot(Group_B(i).Sequence,800);
    end
    save([pwd,'/',tmp,'nt_onehot.mat'],'nt_onehot','-v7.3')
    clear nt_onehot
        
    condon_onehot=zeros(64,1596*size(Group_B,1),'int8');
    for i=1:1:size(Group_B,1)
        condon_onehot(:,(i-1)*1596+1:i*1596)=condon2onehot(Group_B(i).Sequence,800);
        Group_B(i,1).Sequence=[];
    end
    save([pwd,'/',tmp,'condon_onehot.mat'],'condon_onehot','-v7.3')
    clear condon_onehot
        
    csvwrite([pwd,'/',tmp,'nt_length.csv'],1600);
    csvwrite([pwd,'/',tmp,'condon_length.csv'],1596);
        
    cmd=['python ',pwd,'/predict.py ',pwd,'/model_b.h5 ',pwd,'/',tmp];unix(cmd);
    delete([pwd,'/',tmp,'nt_length.csv']);
    delete([pwd,'/',tmp,'condon_length.csv']);
    delete([pwd,'/',tmp,'nt_onehot.mat']);
    delete([pwd,'/',tmp,'condon_onehot.mat']);
        
    predict=dlmread([pwd,'/',tmp,'predict.csv']);
    delete([pwd,'/',tmp,'predict.csv']);
    
    for i=1:1:size(Group_B,1)
        Group_B(i,1).phage_score=predict(i,1);
        Group_B(i,1).chromosome_score=predict(i,2);
        Group_B(i,1).plasmid_score=predict(i,3);
    end
    clear predict;
end
%%%%%%%%%%%%%%%%%%%%%%%

%%%predict Group_C%%%
disp(' ')
if ~isempty(Group_C)
    nt_onehot=zeros(4,2400*size(Group_C,1),'int8');
    for i=1:1:size(Group_C,1)
        nt_onehot(:,(i-1)*2400+1:i*2400)=nt2onehot(Group_C(i).Sequence,1200);      
    end
    save([pwd,'/',tmp,'nt_onehot.mat'],'nt_onehot','-v7.3')
    clear nt_onehot
    
    condon_onehot=zeros(64,2400*size(Group_C,1),'int8');
    for i=1:1:size(Group_C,1)
        condon_onehot(:,(i-1)*2400+1:i*2400)=condon2onehot(Group_C(i).Sequence,1200);
        Group_C(i).Sequence=[];
    end
    save([pwd,'/',tmp,'condon_onehot.mat'],'condon_onehot','-v7.3')
    clear condon_onehot
    
    csvwrite([pwd,'/',tmp,'nt_length.csv'],2400);
    csvwrite([pwd,'/',tmp,'condon_length.csv'],2400);
    
    cmd=['python ',pwd,'/predict.py ',pwd,'/model_c.h5 ',pwd,'/',tmp];unix(cmd);
    delete([pwd,'/',tmp,'nt_length.csv']);
    delete([pwd,'/',tmp,'condon_length.csv']);
    delete([pwd,'/',tmp,'nt_onehot.mat']);
    delete([pwd,'/',tmp,'condon_onehot.mat']);
    
    predict=dlmread([pwd,'/',tmp,'predict.csv']);
    delete([pwd,'/',tmp,'predict.csv']);
    
    for i=1:1:size(Group_C,1)
        Group_C(i,1).phage_score=predict(i,1);
        Group_C(i,1).chromosome_score=predict(i,2);
        Group_C(i,1).plasmid_score=predict(i,3);
    end
    clear predict;
end
%%%%%%%%%%%%%%%%%

%%%predict Group_L%%%
disp(' ')
if ~isempty(Group_L)
    kmer=zeros(2080,size(Group_L,1));
    for i=1:1:size(Group_L,1)
        kmer(:,i)=cal_6mer(Group_L(i).Sequence,double_index,delete_index);
        Group_L(i).Sequence=[];
    end
    save kmer kmer -v7.3
    clear kmer
    
    
    cmd='python predict_L.py model_l.h5';unix(cmd);
    delete('kmer.mat');
    
    predict=dlmread('predict.csv');
    delete('predict.csv');
    
    for i=1:1:size(Group_L,1)
        Group_L(i,1).phage_score=predict(i,1);
        Group_L(i,1).chromosome_score=predict(i,2);
        Group_L(i,1).plasmid_score=predict(i,3);
    end
    clear predict
end
%%%%%%%%%%%%%%%%%%%%

Group=[Group_A;Group_B;Group_C;Group_L];
clear Group_A; clear Group_B; clear Group_C; clear Group_L;
[m,n]=sort([Group.Index]);
Group=Group(n(:));


for i=1:1:size(Group,1)
    scores=[Group(i,1).phage_score,Group(i,1).chromosome_score,Group(i,1).plasmid_score];
    [x,y]=max(scores);
    if y==1 && x>=t
        Group(i,1).Possible_source='phage';
    elseif y==3 && x>=t
        Group(i,1).Possible_source='plasmid';
    else
        Group(i,1).Possible_source='chromosome';
    end
end

            

for i=1:1:size(Group,1)
    result{i,1}=Group(i,1).Header;
    result{i,2}=Group(i,1).Length;
    result{i,3}=Group(i,1).phage_score;
    result{i,4}=Group(i,1).chromosome_score;
    result{i,5}=Group(i,1).plasmid_score;
    result{i,6}=Group(i,1).Possible_source;
end

result=cell2table(result,'VariableNames',{'Header','Length','phage_score','chromosome_score','plasmid_score','Possible_source'});
writetable(result,ResultFile);

disp(' ')
%disp('Finished.')  