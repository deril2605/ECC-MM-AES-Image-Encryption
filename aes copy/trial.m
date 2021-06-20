% ENCRYPTION USING S-BOX, MAGIC MATRIX TECHNIQUE AND ROTATING KEY
%=================================================================
[s_box, inv_s_box, w, poly_mat, inv_poly_mat] = aes_init;
% inputMat = [[99,98,97,96,89];[95,94,93,92,78];[91,90,89,88,11];[87,86,8,0,22];[33,44,99,12,90]];  %This is a 2D image matrix
inputMat=imread('lena_128.jpg')
orig=inputMat
key = [34, 65, 98, 23, 56, 99, 14, 00, 89, 35, 12, 16, 67, 69, 25, 49];   %this is a 16 byte key
[row,col] = size(inputMat);
[m,n] = size(key);
for i=1:row
    for j=1:col
        mat(i,j) = s_box(inputMat(i,j)+1);   % s_box function returns the mapped s_box value 
    end
end
oneDimen = reshape(mat, [1,row*col]);  % reshape converts one matrix into another matrix of required dimensions 
x = mod(row*col,m*n);
if x~=0
    chunks = ((row*col)/(m*n))+1;
else
    chunks = (row*col)/(m*n);
end
for i=1:chunks
    encryShiftedKey = circshift(key, [0,i-1]);
    for j=1:m*n
        index = (i-1)*(m*n) + j;
        if index > row*col
            break;
        end
        oneDimen(index) = bitxor(oneDimen(index), encryShiftedKey(j));
    end
end
magicMatrix = magic(row);
for i=1:row
    for j=1:row
        magicMatrix(i,j) = oneDimen(magicMatrix(i,j));
    end
end
Z=magicMatrix
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
for i=1:chunks
    decryShiftedKey = circshift(key, [0,i-1]);
    for j=1:m*n
        index = (i-1)*(m*n) + j;
        if index > row*col
            break;
        end
        resultOneDMatrix(index) = bitxor(resultOneDMatrix(index), decryShiftedKey(j));
    end
end
result = reshape(resultOneDMatrix, [row,col]);
for i=1:row
    for j=1:col
        newMat(i,j) = inv_s_box(result(i,j)+1);   % inv_s_box function returns the inverse mapped s_box value 
    end
end
imshow(uint8(newMat))

%==============================================================
%THE "newMat" IS THE RESULTANT DECRYPTED OUTPUT




        









