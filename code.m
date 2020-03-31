image=imread("/home/anirudh/Documents/MATLAB_PROJECT/s.jpeg");
imshow(image);

gray_image=rgb2gray(image);
pause(3);
imshow(gray_image);
disp(gray_image);
pause(3);

binary_image=imbinarize(gray_image);
imshow(binary_image);
disp(binary_image);

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
dim = size(binary_image);
col = round(dim(2)/2)-90;
row = min(find(binary_image(:,col),1));
boundary = bwtraceboundary(binary_image,[row, col],'N');
imshow(image)
hold on;
plot(boundary(:,2),boundary(:,1),'g','LineWidth',3);
        