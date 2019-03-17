function PPR_Meta(SeqFile,ResultFile,t)

if nargin==2
    t='0';
end

if exist([pwd,'/tmp'],'dir')
    cmd=['rm -rf ',pwd,'/tmp'];
    unix(cmd);
end
cmd=['mkdir ',pwd,'/tmp'];
unix(cmd);
%%%%%%%%split sequence%%%%%%%%%
data=fastaread(SeqFile);
c=1;
for i=1:1:size(data,1)
    L=size(data(i).Sequence,2);
    if L<=1200 %|| L>=5000
        data_split(c,1).Header=['complete_',data(i).Header];
        data_split(c,1).Sequence=data(i).Sequence;
        c=c+1;
    else
        p1=1;
        p2=1200;
        seq=data(i).Sequence;
        sub_seq=1;
        while p1<=L
            data_split(c,1).Header=['part',num2str(sub_seq),'_',data(i).Header];
            data_split(c,1).Sequence=seq(p1:min(p2,L));
            c=c+1;
            sub_seq=sub_seq+1;
            p1=p1+1200;
            p2=p2+1200;
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%predict%%%%%%%%%
clear data
p1=1;
p2=10000;
c=1;
num=size(data_split,1);
while p1<=num
    f=data_split(p1:min(p2,num));
    fastawrite([pwd,'/tmp/file',num2str(c),'.fna'],f);
    clear f
    PPR([pwd,'/tmp/file',num2str(c),'.fna'],[pwd,'/tmp/out',num2str(c),'.csv'],t);
    cmd=['rm ',pwd,'/tmp/file',num2str(c),'.fna'];
    unix(cmd);
    c=c+1;
    p1=p1+10000;
    p2=p2+10000;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%parse result%%%%%%%%%%
clear data_split
c=c-1;
predict=[];
for i=1:1:c
    pre=readtable([pwd,'/tmp/out',num2str(i),'.csv'],'Delimiter',',');
    pre=table2cell(pre);
    predict=[predict;pre];
    cmd=['rm ',pwd,'/tmp/out',num2str(i),'.csv'];
    unix(cmd);
end

c=1;
total=size(predict,1);
for i=1:1:total
    if size(predict{i,1},2)>=9 && strcmp(predict{i,1}(1:9),'complete_')
        Group(c,1).Header=predict{i,1}(10:end);
        Group(c,1).Length=predict{i,2};
        Group(c,1).phage_score=predict{i,3};
        Group(c,1).chromosome_score=predict{i,4};
        Group(c,1).plasmid_score=predict{i,5};
        c=c+1;
    elseif strcmp(predict{i,1}(1:6),'part1_')
        cc=i;
        phage=predict{cc,3};
        chromosome=predict{cc,4};
        plasmid=predict{cc,5};
        weight=predict{cc,2};
        cc=cc+1;
        while cc<=total && ~strcmp(predict{cc,1}(1:6),'part1_') && ~strcmp(predict{cc,1}(1:6),'comple') 
            phage=[phage,predict{cc,3}];
            chromosome=[chromosome,predict{cc,4}];
            plasmid=[plasmid,predict{cc,5}];
            weight=[weight,predict{cc,2}];
            cc=cc+1;
        end
        length=sum(weight);
        weight=weight/length;
        Group(c,1).Header=predict{i,1}(7:end);
        Group(c,1).Length=length;
        Group(c,1).phage_score=sum(phage.*weight);
        Group(c,1).chromosome_score=sum(chromosome.*weight);
        Group(c,1).plasmid_score=sum(plasmid.*weight);
        c=c+1;
    end
end

t=str2num(t);
for i=1:1:size(Group,1)
    scores=[Group(i,1).phage_score,Group(i,1).chromosome_score,Group(i,1).plasmid_score];
    [x,y]=max(scores);
    if y==1
        Group(i,1).Possible_source='phage';
        if x<t
            Group(i,1).Possible_source='uncertain_phage';
        end
    elseif y==2
        Group(i,1).Possible_source='chromosome';
        if x<t
            Group(i,1).Possible_source='uncertain_chromosome';
        end
    elseif y==3
        Group(i,1).Possible_source='plasmid';
        if x<t
            Group(i,1).Possible_source='uncertain_plasmid';
        end
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(newline)
disp(newline)
disp(newline)
disp(newline)
disp(newline)

if size(ResultFile,2)<4 || ~strcmp(ResultFile(end-3:end),'.csv')
    disp('Warning!! The name of the output file has been changed to:')
    disp([ResultFile,'.csv'])
    disp('Note: The current version of PPR-Meta uses "Comma-Separated Values (CSV)" as the format of the output file!!')
    ResultFile=[ResultFile,'.csv'];
end
result=cell2table(result,'VariableNames',{'Header','Length','phage_score','chromosome_score','plasmid_score','Possible_source'});
writetable(result,ResultFile);
cmd=['rm -rf ',pwd,'/tmp'];
unix(cmd);
disp(' ')
disp('Finished.')  




        
        
        
        
        
        
        
        
        
    
    
            
            
        
        