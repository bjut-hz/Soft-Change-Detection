function [ meandata, sigma ] = compute_mean_sigma( data, wts )

sizeData = size( data, 1 );
Nch = size( data, 2 );
wtdData = data;
for ch = 1:Nch
    %multiplying each channel by corresponding weights
    wtdData( :, ch ) = data( :, ch ) .* wts;
end

W = sum( wts );

meandata=sum(wtdData, 1);%sum the weighted data
if(W~=0)
	meandata=meandata/W;%average
end

meaddataMtrix = repmat(meandata, sizeData, 1);

dataCentered = data - meaddataMtrix;
sum_( 3, 3 ) = 0;
for index = 1:sizeData
    temp = dataCentered( index, : );  
    sum_ = sum_ + ( temp' * temp * wts( index ) );
end

sigma = sum_;
if( W ~= 0)
    sigma = sigma / W;
end
meandata = meandata';

