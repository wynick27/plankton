function [branches, branchMap] = extract_end_branches( bin_edge_map, length_threshold )
% function branches = extract_end_branches( bin_edge_map )
% INPUT: bin_edge_map: the binary image of edge map
% OUTPUT: branches is an arrary of the end branches
%         branchMap is the binary image of the end branches

if nargin < 2 || isempty(length_threshold)
    length_threshold = 0;
end

branches = [];
branchMap = zeros( size(bin_edge_map) );

bin_edge_map = bwmorph( bin_edge_map, 'thin', inf ); % double make sure 

endPtMap = bwmorph( bin_edge_map, 'endpoints' );
branchPtMap = bwmorph( bin_edge_map, 'branchpoints' );

bin_edge_map( imdilate(branchPtMap, ones(3)) ) = 0; % this is a coarse calculation

temp1 = bwlabel( endPtMap );
temp2 = bwlabel( bin_edge_map );

uLabels = setdiff( unique( temp2 ), 0 );
for k = 1 : length(uLabels)
    segment = (temp2 == uLabels(k));
    if sum(temp1(segment)) > 0 % overlapping with an endpoint
        branchMap = branchMap | segment;
    end
end

temp = regionprops( branchMap, 'Area', 'PixelIdxList', 'PixelList' );
n = 0;
for k = 1 : length(temp)
    if temp(k).Area >= length_threshold
        n = n+1;
        branches(n).length = temp(k).Area;
        branches(n).Pixels = temp(k).PixelList;
        branches(n).PixelIndexes = temp(k).PixelIdxList;
    else % remove short branches
        branchMap( temp(k).PixelIdxList ) = 0;
    end
end