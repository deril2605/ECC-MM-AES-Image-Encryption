% % ENCRYPTION USING S-BOX, MAGIC MATRIX TECHNIQUE AND ROTATING KEY
% %=================================================================
% clear all;
% [s_box, inv_s_box, w, poly_mat, inv_poly_mat] = aes_init;
% inputMat = imread('camera_128_gray.jpg');
% % inputMat = [[99,98,97,96,89];[95,94,93,92,78];[91,90,89,88,11];[87,86,8,0,22];[33,44,99,12,90]];  %This is a 2D image matrix
key = [34, 65, 98, 23, 55, 99, 14, 00, 89, 35, 12, 16, 67, 69, 25, 49];   %this is a 16 byte key
% [row,col] = size(inputMat);
% [keyRow,keyCol] = size(key);;
% xorOutput = 0;
% matrix = inputMat;
% for i=1:keyCol
%     xorOutput = bitxor(xorOutput,key(i));
% end
% for i=1:row
%     for j=1:col
%         inputMat(i,j) = bitxor(xorOutput, inputMat(i,j));
%         mat(i,j) = s_box(inputMat(i,j)+1);   % s_box function returns the mapped s_box value 
%     end
% end
% oneDimen = reshape(mat, [1,row*col]);  % reshape converts one matrix into another matrix of required dimensions 
% i1 = 1;
% j1 = 2;
% newOneDimen = zeros(1,row*col);
% mid = ceil((row*col)/2);
% for i=1:mid
%     if i1<=(row*col)
%         newOneDimen(i)=oneDimen(i1);
%         i1 = i1+2;
%     end
% end
% for i=mid+1:row*col
%     if j1<=(row*col)
%         newOneDimen(i)=oneDimen(j1);
%         j1 = j1+2;
%     end
% end
% 
% x = mod(row*col,keyRow*keyCol);
% if x~=0
%     chunks = ((row*col)/(keyRow*keyCol))+1;
% else
%     chunks = (row*col)/(keyRow*keyCol);
% end
% for i=1:chunks
%     encryShiftedKey = circshift(key, [0,i-1]);
%     for j=1:keyRow*keyCol
%         index = (i-1)*(keyRow*keyCol) + j;
%         if index > row*col
%             break;
%         end
%         newOneDimen(index) = bitxor(newOneDimen(index), encryShiftedKey(j));
%     end
% end
% magicMatrix = magic(row);
% for i=1:row
%     for j=1:row
%         magicMatrix(i,j) = newOneDimen(magicMatrix(i,j));
%     end
% end

%DECRYPTION OF THE OUTPUT USING INVERSE S-BOX, REVERSE MAPPING OF MAGIC
%MATRIX AND KEY
%=======================================================================
resultOneDMatrix = zeros(1,row*col);
dummyMagicMatrix = magic(row);
for i=1:row
    for j=1:row
        resultOneDMatrix(dummyMagicMatrix(i,j)) = magicMatrix(i,j);
    end
end
xorOutput2 = 0;
for i=1:keyCol
    xorOutput2 = bitxor(xorOutput2,key(i));
end
for i=1:chunks
    decryShiftedKey = circshift(key, [0,i-1]);
    for j=1:keyRow*keyCol
        index = (i-1)*(keyRow*keyCol) + j;
        if index > row*col
            break;
        end
        resultOneDMatrix(index) = bitxor(resultOneDMatrix(index), decryShiftedKey(j));
    end
end

newResult = zeros(1,row*row);
i1 = 1;
j1 = 2;
mid = ceil((row*row)/2);
for x=1:row*row
    if x<=mid
        newResult(i1) = resultOneDMatrix(x);
        i1 = i1+2;
    end
    if x>mid
        newResult(j1) = resultOneDMatrix(x);
        j1 = j1+2;
    end
end
    


result = reshape(newResult, [row,col]);
for i=1:row
    for j=1:col
        newMat(i,j) = inv_s_box(result(i,j)+1);   % inv_s_box function returns the inverse mapped s_box value 
        newMat(i,j) = bitxor(newMat(i,j),xorOutput2);
    end
end

imshow(uint8(newMat))
% 
% 
% imshow(uint8(newMat))
% if(newMat==matrix)
%     display("CORRECT");
% else
%     display("WRONG");
% end
%==============================================================
%THE "newMat" IS THE RESULTANT DECRYPTED OUTPUT