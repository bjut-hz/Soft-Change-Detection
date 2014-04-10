function boundarynew=updateboundary(i, j, maskimage, boundary)
%
%boundarynew=updateboundary(i, j, maskimage, boundary)
%updates the boundary by considering neighbourhood around pt (i,j)
%

boundarynew=boundary;
boundarynew(i,j)=0;

Nr=size(maskimage,1);
Nc=size(maskimage,2);

nbrSize=2;
imin= max(1, i-floor(nbrSize/2));
imax= min(Nr, i+floor(nbrSize/2));

jmin= max(1, j-floor(nbrSize/2));
jmax= min(Nc, j+floor(nbrSize/2));

for r=imin:imax,%r: row index
    for c=jmin:jmax,%c: column index
        if(isboundary(r,c,maskimage)),
            boundarynew(r,c)=1;
        end
    end
end

function retval=isboundary(i, j, maskimage)
%boundary definition: Pts with value 0, and having a neighbour with
%value 1
retval=false;

if(maskimage(i,j))
    return;
end

Nr=size(maskimage,1);
Nc=size(maskimage,2);

nbrSize=2;
imin= max(1, i-floor(nbrSize/2));
imax= min(Nr, i+floor(nbrSize/2));

jmin= max(1, j-floor(nbrSize/2));
jmax= min(Nc, j+floor(nbrSize/2));

for r=imin:imax,%r: row index
    for c=jmin:jmax,%c: column index
        if(maskimage(r,c))%neighborhood has a 1(matting: element already determined
            retval=true;
            return;
        end
    end
end
