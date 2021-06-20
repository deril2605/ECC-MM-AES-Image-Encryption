%encrypt
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
mat=imread('girl.jpg');
%mat=rgb2gray(mat);
[r c]=size(mat);
q=zeros(1,r*c);
%mat=uint8(255*mat2gray(ans1));
%mat
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
%decrypt
ans=mat;
num2=int16(ans);
s=1;
comapre=0;
for i=1:r
    for j=1:c
           num2(i,j)=q(1,s)*255 + num2(i,j);
           s=s+1;
           compare= num2(i,j);
           for l=1:2145
               if compare == points(l,2)
                     num2(i,j)=points(l,1);
                     break;
               end    
           end
           mat(i,j)=floor((num2(i,j)-1)/10);
     end
end
imshow(mat)
