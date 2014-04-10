function clusteredPts=separateClusters(dataPts, idx, Nclusters)


for i=1:Nclusters,
    presentidList=idx-i;
    presentidList=(presentidList==0);
    clusteredPts{i}=dataPts(presentidList,:);
end
