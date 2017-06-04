% data analysis
fileName = 'netIncome.txt';
request = 10;
startAsset = 5;

% obtain probabilities
p = zeros(1,4);
fid = fopen(fileName, 'rt');
next = fgetl(fid);
while next ~= -1 
    switch str2double(next)
        case -2, p(1) = p(1) + 1;
        case -1, p(2) = p(2) + 1;
        case 1, p(3) = p(3) + 1;
        case 2, p(4) = p(4) + 1;
        otherwise, disp('Invalid weekly income');
    end
    next = fgetl(fid);
end
fclose(fid);
p = p / sum(p);

% construct transition matrix
len = request*3 + 1;
trans = zeros(len);
trans(1,1) = 1;
trans(2,1) = p(1) + p(2);
trans(2,3) = p(3);
trans(2,4) = p(4);
trans(len-1,len-3) = p(1);
trans(len-1,len-2) = p(2);
trans(len-1,len) = p(3) + p(4);
trans(len,len) = 1;
for i = 3:1:len-2
    trans(i,i-2) = p(1);
    trans(i,i-1) = p(2);
    trans(i,i+1) = p(3);
    trans(i,i+2) = p(4);
end

% solve absorption probability
len = size(trans,1) - 2;
A = trans(2:len+1,2:len+1);
for i = 1:1:len
    A(i,i) = A(i,i) -1;
end
b = -trans(2:len+1,len+2);
x = A\b;