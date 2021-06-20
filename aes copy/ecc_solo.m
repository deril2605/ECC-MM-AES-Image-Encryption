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
k=10;
store=1;
store1=1;
mat=imread('girl.jpg');
[r c]=size(mat);
q=zeros(1,r*c);
q1=zeros(1,r*c);
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
                    q(1,store)=fix(points(o,2)/255);
                    store=store+1;
                    mat(l,m)=mod(points(o,2),255);
                    flag=1;
                    q1(1,store1)=compare;
                    store1=store1+1;
                    break;
                end
            end
        end
    end
end
enc=mat
%decrypt
s=1;
z=1;
compare=0;
for i=1:r
    for j=1:c
           num2=int16(mat(i,j));
           num2=q(1,s)*255 + num2;
           s=s+1;
           compare= num2;
           for l=1:2145
               if compare == points(l,2) && q1(1,z)==points(l,1)
                     mat(i,j)=points(l,1)/10;
                     break;
               end    
           end
           z=z+1;
    end
end
imshow(mat)
