a=0:2570;
left=mod(a.^2,3049);
right=mod(a.^3-a+188,3049);
points=[];
for i=1:length(right)
    I=find(left==right(i));
    for j=1:length(I)
        points=[points;a(i),a(I(j))];
    end
end
points

k=10;
store=1;
mat=imread('lena256.jpg');
%mat=rgb2gray(mat);
%mat=uint8(mat);
[r c]=size(mat);
q=zeros(1,r*c);
%mat=uint8(255*mat2gray(mat));
mat
for l=1:r
    for m=1:c
        num=mat(l,m);
        value=10*int16(num);
        flag=0;
        for n=1:11
            if flag==1
                break;
            end
            compare=value+n-1;
            for o=1:2145
                if compare==points(o,1)
                    q(1,store)=fix(compare/255);
                    store=store+1;
                    mat(l,m)=mod(points(o,2),255);
                    flag=1;
                    break;
                end
            end
        end
    end
end
mat
% imshow(mat)
% mat=imread('lena1.jpg');
% mat=rgb2gray(mat);
mat=imread('lena256.jpg');
[m,n] = size(mat);

xorvar = int16(0);
for i=1:m
    for j=1:n
        temp=mat(i,j);
        xorvar = bitxor(xorvar,int16(temp));
    end
end
for i=1:m
    for j=1:n
        mat(i,j)=bitxor(int16(mat(i,j)),xorvar);
       
    end
end
transmat = mat(:)';
magicmatrix = magic(n);
newmat = zeros(n,m);
for i=1:m
    for j=1:n
        temp = magicmatrix(i,j);
        newmat(i,j)=transmat(temp);
    end
end
display(newmat)
imshow(newmat)
%  %================ DESCRAMBLING THE IMAGE INTO NEW ARRAY =================
% 
 zerosdecr = zeros(1,n*n);    %new array of mxn dimension
for i=1:m
    for j=1:n
        zerosdecr(magicmatrix(i,j))=newmat(i,j);
    end
end

finalmat = reshape(zerosdecr,[m,n]);

xorvar2 = int16(0);
for i=1:m
    for j=1:n
        temp2=finalmat(i,j);
        xorvar2 = bitxor(xorvar2,int16(temp2));
    end
end
for i=1:m
    for j=1:n
        finalmat(i,j)=bitxor(int16(finalmat(i,j)),xorvar2);
       
    end
end
final=uint8(255*mat2gray(finalmat));
final=uint8(finalmat);

display(final);
imshow(final)