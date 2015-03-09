function feature_vec = PlanktonImgFeatEx(img,origimg)
stats = regionprops(img,'all');
[area_feat,sorted_index] = AreaFeatEx(stats);
orien_feat = OrientationFeatEx(stats,sorted_index);
solidity_feat = SolidityFeatEx(stats,sorted_index);
filledarea_feat = FilledAreaFeatEx(stats,sorted_index);
eccentricity_feat = EccentricityFeatEx(stats,sorted_index);
eulernumber_feat = EulerNumberFeatEx(stats,sorted_index);
zernike_result = ZernikeFeatEx(img);
eb_result = EndBranchFeatEx(img);
mass_distance = MassDistanceFeatEx(img,origimg);
feature_vec = [ area_feat,orien_feat,solidity_feat,...
                filledarea_feat,eccentricity_feat,eulernumber_feat,...
                zernike_result(1),zernike_result(2)...
                eb_result(1),eb_result(2),eb_result(3),eb_result(4), mass_distance];
end

function [area_feat,sorted_index] = AreaFeatEx(stats)
[area_data,index] = sort([stats.Area],'descend');
area_feat = area_data(index(1));
sorted_index = index;
return;
end

function orien_feat = OrientationFeatEx(stats,sorted_index)
orien_feat = stats(sorted_index(1)).Orientation;
return;
end

function solidity_feat = SolidityFeatEx(stats,sorted_index)
solidity_feat = stats(sorted_index(1)).Solidity;
return;
end

function filledarea_feat = FilledAreaFeatEx(stats,sorted_index)
filledarea_feat = stats(sorted_index(1)).FilledArea;
return;
end

function eccentricity_feat = EccentricityFeatEx(stats,sorted_index)
eccentricity_feat = stats(sorted_index(1)).Eccentricity;
return;
end

function eulernumber_feat = EulerNumberFeatEx(stats,sorted_index)
eulernumber_feat = stats(sorted_index(1)).EulerNumber;
return;
end

function center_feat = MassDistanceFeatEx(stats,sorted_index,origimg)
center = stats(sorted_index(1)).Centroid;
mcenter = centerOfMass(origimg);
center_feat = pdist([center;mcenter],'euclidean')
return;
end

function result = ZernikeFeatEx(img)
[~, AOH, PhiOH] = Zernikmoment(img,4,2);
result = [AOH,PhiOH];
return;
end

function result = EndBranchFeatEx(img)
[branches, ~] = extract_end_branches(img, 2);
branch_numb = length(branches); % current plankton's number of branches
% if return no branch information
if branch_numb == 0
	result = [0.0000,0.0000, 0.0000, 0.0000]; % print length_mean, length_median, length_variance
    return;
end
% if return branch information
branch_lengths = zeros(1, branch_numb); % array that stores the length of each branch
        
for branch_idx = 1:branch_numb
	branch_lengths(branch_idx) = branches(branch_idx).length;
end
result = [branch_numb,mean(branch_lengths), median(branch_lengths), var(branch_lengths)];
return;
end
