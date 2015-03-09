A = imread('train\echinopluteus\4595.jpg');
%img = bwmorph(im2bw(A,250/255),'close',20);
%imshow(img)
C = centerOfMass(255 - A);
figure; imagesc(A); colormap gray; axis image
hold on; plot(C(2),C(1),'rx')

s = regionprops(1 - im2bw(A,250/255),A,'WeightedCentroid');
centroids = cat(1, s.WeightedCentroid);
imshow(A)
hold on
plot(centroids(:,1),centroids(:,2), 'bx')
hold off

