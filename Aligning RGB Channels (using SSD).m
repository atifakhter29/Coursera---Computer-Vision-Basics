%Aligning RGB Channels (using SSD)

%Read the image
img = imread('course1image.jpg');

%Get the size (rows and columns) of the image 
[r,c] = size(img);


%Write code to split the image into three equal parts and store them in B, G, R channels

B = img(1:r/3,:);
G = img((r/3)+1:(2*r/3),:);
R = img((2*r/3)+1:r,:);

ref_img_region = G;
[rg,cg] = size(ref_img_region);
ref_img_region = ref_img_region(ceil((rg-50)/2) :ceil((rg-50)/2) + 50,ceil((cg-50)/2) :ceil((cg-50)/2) + 50);

ref_img_region = double(ref_img_region);

nR = align(G,R);
nB = align(G,B);
ColorImg_aligned = cat(3,nR,G,nB);
imshow(ColorImg_aligned);


function aligned = align(green,red)
    [red_row,red_col] = size(red);
    [green_row,green_col] = size(green);

     
    cropped_red = red(ceil((red_row-50)/2) : ceil((red_row-50)/2) + 50,ceil((red_col-50)/2) :ceil((red_col-50)/2) + 50);
cropped_green = green(ceil((green_row-50)/2) : ceil((green_row-50)/2) + 50,ceil((green_col-50)/2) :ceil((green_col-50)/2) + 50);

    MiN = 9999999999;
    r_index = 0;
    r_dim = 1;
    
    for i = -10:10
        for j = -10:10
            ssd =     SSD(cropped_green,circshift(cropped_red,[i,j])); %circshift(A,[i,j])
            if ssd < MiN
                MiN = ssd;
                r_index = i;
                r_dim = j;
            end
        end
    end
    aligned = circshift(red,[r_index,r_dim]);
end       

function ssd = SSD(a1,a2)
    x = double(a1)-double(a2);
    ssd = sum(x(:).^2);
end 
