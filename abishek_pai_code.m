image=imread("/home/anirudh/Documents/MATLAB_PROJECT/s.jpeg");
%imshow(image);
gray_image=rgb2gray(image);
binary_image=imbinarize(gray_image);
[rows, cols, channels] = size(binary_image);

col1 = 1;
col2 = floor(cols/2);
col3 = col2 + 1;
row1 = 1;
row2 = floor(rows/2);
row3 = row2 + 1;

upperleft = imcrop(binary_image, [col1 row1 col2 row2]);
upperright = imcrop(binary_image, [col3 row1 cols - col2 row2]);
lowerleft = imcrop(binary_image, [col1 row3 col2 row2]);
lowerright = imcrop(binary_image, [col3 row3 cols - col2 rows - row2]);

subplot(2,2,1);
imshow(upperleft);
subplot(2,2,2);
imshow(upperright);
subplot(2,2,3);
imshow(lowerleft);
subplot(2,2,4);
imshow(lowerright);

ctr1 = sum(upperleft(:) == 0);
ctr2 = sum(upperright(:) == 0);
ctr3 = sum(lowerleft(:) == 0);
ctr4 = sum(lowerright(:) == 0);
disp(ctr1+ctr2+ctr3+ctr4); %exact no. of black pixels but cannot use ur new centroid coordinates. This is only for 
                           %standard origin

