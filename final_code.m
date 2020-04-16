% =========================================================================
% PROGRAM TO DETECT THE DIRECTION OF A SINGLE SOURCE OF LIGHT OF A NON BLACK
% OBJECT OF BRIGHTER COLOUR THAN THE BACKGROUND SETTING
% =========================================================================
% Code written and posted by Anirudh S Ayya, Abhishek Pai and Vishnu R 
% Dixit, April 2020 for MATLAB release R2019b
% Requires the Image Processing Toolbox (IPT) because it demonstates some functions
% supplied by that toolbox



% Clears all the variables present in the workspace before running
clear;
% Image name stored in a variable if the project is ever extrapolated to do
% more
imgName = uigetfile({'*.jpeg';});
% Reading the image into a variable for processing
image=imread(imgName);

% Converting the image into gray scale
% Reasons for this include
% Boundary detection functions/ region properties works only with images of
% one dimension
% It further needs to be converted to binary after applying a threshold for
% what counts as a shadow is this is easier from a grayscale image
% This threshold is implicitly done by imbinarize, and is sufficient for
% our requirements here
gray_image=rgb2gray(image);

% Conversion of grayscale to binary with the built in threshold
binary_image=imbinarize(gray_image);

% Obtaining dimensions of the object for object occupation percentage
% within the image
[rows, cols, channels] = size(binary_image);
area = rows * cols;

% Applying a threshold for what constitutes an object in the gray image
regPropInput = gray_image > 90 & gray_image < 165;

% Acquring the properties of the object which has been detected
stat = regionprops(regPropInput,'centroid','area');

% Filtering out the boundaries emperically which do not pose sufficient
% importance
% Minimum fraction of the image that must be occupied by the object
areaMaxThreshold = 0.04;

% Minimum size of the image required in terms of image area
objectErrorThreshold = 0.0675;

% Applying threshold to remove unwanted closed figures and their centroids.
statNew = stat(abs([stat.Area] - objectErrorThreshold * area) < areaMaxThreshold * area);

% Passing on the calculated centroids to the black pixel counting program
if (size(statNew) ~= 0)
    xCenter = statNew(1).Centroid(1);
    yCenter = statNew(1).Centroid(2);
% Approximate estimate in case of filter failure
else
    yCenter = floor(rows/2);
    xCenter = floor(cols/2);
end

% Column one is the starting of the image from the left
col1 = 1;
% Column two is the column where the left section of the image ends
% This column represents the apparents centroid of the image under
% consideration; this is done to maintain equal number of pixels of the
% object under observation
col2 = xCenter;
% Column three is the starting for the right portion of the image
col3 = col2 + 1;
% Similar explanation is applicable for the rows in the image
row1 = 1;
row2 = yCenter;
row3 = row2 + 1;

% Segregating out the 4 portions of the image using the boundaries as
% defined above to observe the number of pixels of shadow within each
% portion of the image
upperleft = imcrop(binary_image, [col1 row1 col2 row2]);
upperright = imcrop(binary_image, [col3 row1 cols - col2 row2]);
lowerleft = imcrop(binary_image, [col1 row3 col2 rows]);
lowerright = imcrop(binary_image, [col3 row3 cols - col2 rows - row2]);

% Plotting the 4 portions of the image for a visual estimate
subplot(2,3,1);
imshow(upperleft);
subplot(2,3,2);
imshow(upperright);
subplot(2,3,4);
imshow(lowerleft);
subplot(2,3,5);
imshow(lowerright);
subplot(2, 3, 3);

% The original black and white image with only the shadow and the object
% Further, the loop overlays all the centroids as calculated by regionprops
% This will be seen in the image on the right
imshow(regPropInput); hold on;
for x = 1: numel(statNew)
    % bx here stands for the fact that Blue X marks will be used to make
    % marks on the image
    plot(statNew(x).Centroid(1),statNew(x).Centroid(2),'bx');
end

% Counting the number of black pixels in each portion
% Can be generalised with a loop over each portion
ctr1 = sum(upperleft(:) == 0);
ctr2 = sum(upperright(:) == 0);
ctr3 = sum(lowerleft(:) == 0);
ctr4 = sum(lowerright(:) == 0);
% disp(ctr1+ctr2+ctr3+ctr4);

                           
%if(ctr1 <= ctr2+5000 or ctr1 <= ctr2-5000 or ctr1 >= ctr2+5000 or ctr1 >= ctr2-5000)
% disp("Estimate #1 for the direction of the source of light ");
% if(abs(ctr1-ctr2) <=8500 & abs(ctr3+ctr4) < 1000)
%     disp("Source is at south direction");
% elseif (abs(ctr1 -ctr2) >8500)
%     disp("Source is at south-east direction");
% elseif (abs(ctr2 -ctr1) >8500)
%     disp("Source is at south-west direction");
% 
% elseif(abs(ctr2-ctr3) <=8500 & abs(ctr1+ctr4) < 1000)
%     disp("Source is at west direction");
% elseif (abs(ctr3 -ctr2) >8500)
%     disp("Source is at north-east direction");
% elseif (abs(ctr2 -ctr3) >8500)
%     disp("Source is at south-east direction");
% 
% elseif(abs(ctr3-ctr4) <=8500 & abs(ctr1+ctr2) < 1000)
%     disp("Source is at north direction");
% elseif (abs(ctr3 -ctr4) >8500)
%     disp("Source is at north-east direction");
% elseif (abs(ctr4 -ctr3) >8500)
%     disp("Source is at north-west direction");
%     
% elseif(abs(ctr1-ctr4) <=8500 & abs(ctr2+ctr3) < 1000)
%     disp("Source is at east direction");
% elseif (abs(ctr1 -ctr4) >8500)
%     disp("Source is at south-east direction");
% elseif (abs(ctr4 -ctr1) >8500)
%     disp("Source is at north-east direction");
%     
% elseif(abs(ctr1-ctr2)<=6000||abs(ctr2-ctr3)<=6000||abs(ctr3-ctr4)<=6000||abs(ctr1-ctr4)<=6000)
%     disp("Source is at top");
% end

disp(" ");

% Estimate 1 for the angle using weights
% This estimate will work only if there is only a single light source.
noOfParts = 4;

% The center angle for each part is calculated here
angles = [0:noOfParts-1];
anglePerPart = 360/noOfParts;
angles = angles * anglePerPart + anglePerPart/2;

% BlackCount is the counter variables with the first n/2 in reverse order
% and the rest in order
% This is done as angles are measured anti-clockwise but image portions are
% taken in a clockwise fashion
% The final result is a weighted average of the central angles of each
% portion
% The weights for each portion are the number of black pixels of that
% portion
blackCount = [ctr2, ctr1, ctr3, ctr4];
blackPixelSum = sum(blackCount);
disp("Estimate #1");
blackFraction = zeros(1, noOfParts);
for portionNo = 1:noOfParts
    blackFraction(portionNo) = blackCount(portionNo)/blackPixelSum;
end
result = blackFraction.*angles;
result = sum(result);

% If the answer is close to 180, it means that the weights are equal and
% the light isn't coming from any direction in particular, or it is from
% the right                                                                                                                                                                     
fprintf("The shadow is at %f",result)
fprintf("\n");
fprintf("\n");

% The lightsource is directly to the opposite of the shadow
lightSource = mod((180 + result),360);
fprintf("Therefore , the light is at %f %s",lightSource,"degrees");
fprintf("\n");

minBlack = 1000;
if (abs(result - 180) < 15)
    if(ctr2 > minBlack && ctr4 > minBlack)
        disp("Light might be coming from the top");
        x=1;
    end
end

disp(" ");
disp("Estimate #2 for the direction of the source of light");
disp(" ");
if(lightSource>0 && lightSource<90)
    disp("The light source is at north-east direction");
elseif(lightSource>90 && lightSource<180)
    disp("The light source is at north-west direction");
elseif(lightSource>180 && lightSource<270)
    disp("The light source is at south-west direction");
elseif(lightSource>270 && lightSource<360 && x~=1)
    disp("The light source is at south-east direction");
elseif(lightSource==0)
    disp("Light source is at east direction");
elseif(lightSource==90)
    disp("Light source is at north direction");
elseif(lightSource==180)
    disp("Light source is at west direction");
elseif(lightSource==270)
    disp("Light source is at south direction");
else
    disp("Light source is at the top");
end
