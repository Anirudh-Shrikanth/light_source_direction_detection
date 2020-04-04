image=imread("/home/anirudh/Documents/MATLAB_PROJECT/s.jpeg");
% imshow(image);

gray_image=rgb2gray(image);
% pause(3);
% imshow(gray_image);
% disp(gray_image);
% pause(3);

binary_image=imbinarize(gray_image);
% imshow(binary_image);
% disp(binary_image);

% for i=1:size(binary_image,1)
%     for j=1:size(binary_image,2)
%         if binary_image(i,j)==1
%             a=i;     
                       %-----------------READ------------------------
%             b=j;     %to obtain the top-most boundary pixel. What if
%             break;   %we traverse row_wise ,and get the boundary pixels
%         end          %by observing a change in pixel value > 10(some 
%     end              %threshold) and put in an array. We'll have to do
% end                  %this 2 times as , in the same row , we'll observe
                       %greater than threshold pixel value changes 2wice.

                       
%code to highlight the boundary---not working as expected                       
% dim = size(binary_image);
% col = round(dim(2)/2)-90;
% row = min(find(binary_image(:,col),1));
% boundary = bwtraceboundary(binary_image,[row, col],'N');
% imshow(image)
% hold on;
% plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);

% [X_img,Y_img]=size(gray_image);
% disp(X_img);
% disp(Y_img);
% 
% X=X_img/2;
% Y=Y_img/2;

[height, width] = size(binary_image); % store the size of the image
centroid = ceil([height, width]./2); %get the center if the image . Here height and width are X_img and Y_img. Sub for it. 

[hh,ww] = meshgrid(1:height,1:width) ; % indices of all pixels
[theta, r] = cart2pol(hh-centroid(1), ww-centroid(1)) ; % convert to polar coordinates relative to the image centre
% to which sector does each pixel belong

E = 0:180:360;  %change it to 90:180:360 .... 180:270:360....270:360:360 and see.


[~, SectorIdx] = histcounts(theta * (180/pi), E) ;

%[N,edges] = histcounts(X) partitions the X values into bins, and returns the count in each bin, as well as the bin edges. The histcounts function uses an automatic binning algorithm that returns bins with a uniform width, chosen to cover the range of elements in X and reveal the underlying shape of the distribution.

N = arrayfun(@(k) nnz(binary_image(SectorIdx==k)==0), 1:max(SectorIdx)) ; % count for each sector the number of black (0) pixels
disp(N);
count_of_0s=0;
for i=1:size(N,1)
    for j=1:size(N,2)
        if(N(i,j)==0)
            count_of_0s=count_of_0s+1;
        end
    end
end

disp(count_of_0s);















