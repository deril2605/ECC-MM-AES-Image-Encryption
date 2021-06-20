%AES_DEMO  Demonstration of AES-components.
%
%   AES_DEMO
%   runs a demonstration of all components of 
%   the Advanced Encryption Standard (AES) toolbox.
%
%   In the initialization step the S-boxes, the round constants,
%   and the polynomial matrices are created and
%   an example cipher key is expanded into 
%   the round key schedule.
%   Step two and three finally convert 
%   an example plaintext to ciphertext and back to plaintext.

%   Copyright 2001-2005, J. J. Buchholz, Hochschule Bremen, buchholz@hs-bremen.de

%   Version 1.0     30.05.2001

% Initialization
clc
disp('START')
ciphertext1=zeros(1,16);
[s_box, inv_s_box, w, poly_mat, inv_poly_mat] = aes_init;
A=imread('girlwithhat.jpg');
[row,col,dim]=size(A);
B=rgb2gray(A);
C=dec2hex(B);
disp(C)
D=zeros(row,col);
E=zeros(row,col);
[r, c] =size(C);
% Define an arbitrary series of 16 plaintext bytes 
% in hexadecimal (string) representation
% The following two specific plaintexts are used as examples 
% in the AES-Specification (draft)
% plaintext_hex=array;
%
% ENCRYPTION
%
x=1;
y=1;
for i=1:16:r
%i=1;
    plaintext_hex = {strcat(C(i,1),C(i,2)) strcat(C(i+1,1),C(i+1,2)) strcat(C(i+2,1),C(i+2,2)) strcat(C(i+3,1),C(i+3,2)) strcat(C(i+4,1),C(i+4,2)) strcat(C(i+5,1),C(i+5,2)) strcat(C(i+6,1),C(i+6,2)) strcat(C(i+7,1),C(i+7,2)) ...
                     strcat(C(i+8,1),C(i+8,2)) strcat(C(i+9,1),C(i+9,2)) strcat(C(i+10,1),C(i+10,2)) strcat(C(i+11,1),C(i+11,2)) strcat(C(i+12,1),C(i+12,2)) strcat(C(i+13,1),C(i+13,2)) strcat(C(i+14,1),C(i+14,2)) strcat(C(i+15,1),C(i+15,2))};
    %plaintext_hex = {'32' '43' 'f6' 'a8' '88' '5a' '30' '8d' ...
    %                 '31' '31' '98' 'a2' 'e0' '37' '07' '34'};

    % Convert plaintext from hexadecimal (string) to decimal representation
    plaintext = hex2dec (plaintext_hex);

    % MAGIC MATRIX ENC
%     M=magic(4);
%     T=zeros(4,4);
%     for m=1:4
%         for n=1:4
%         temp = M(m,n);
%         T(m,n)=plaintext(temp);
%         end
%     end
%     T=T(:)';
%     plaintext=T;
    %    
    ciphertext = cipher (plaintext, w, s_box, poly_mat, 1);
    for z=1:16
        D(x,y)=ciphertext(1,z);
        x=x+1;
        if x>row
            x=1;
            y=y+1;
        end
        if y>col
            break;
        end
    end
end
    % Convert the ciphertext back to plaintext
    % using the expanded key, the inverse S-box, 
    % and the inverse polynomial transformation matrix
    disp(D)
%
%DECRYPTION
%
    Z=D;
    x=1;
    y=1;
    D=D(:)';
    [nr, nc]=size(D);
    for i=1:16:nc
        for j=1:16
            ciphertext1(1,j)=D(1,i+j-1);
        end
        re_plaintext = inv_cipher (ciphertext1, w, inv_s_box, inv_poly_mat, 1);
        % MAGIC MATRIX DECYP
        %conv replaintext to 4x4
%         T=zeros(1,16);
%         for m=1:4
%             for n=1:4
%         T(M(m,n))=replain(m,n);
%             end
%         end
%         re_plaintext=replain;    
        %
        for z=1:16
        E(x,y)=re_plaintext(1,z);
        x=x+1;
            if x>row
                x=1;
                y=y+1;
            end
            if y>col
                break;
            end
        end
    end 
    final=uint8(255*mat2gray(E));
    subplot(1,3,1),imshow(B);
    title('original');
    subplot(1,3,2),imshow(Z);
    title('encrypted');
    subplot(1,3,3),imshow(final);
    title('decrypted');
    disp('END')