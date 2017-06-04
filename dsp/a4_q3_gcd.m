% Use the Euclidean algorithm to find the Greatest Common Divisor (GCD) 
% of the numbers 24679 and 13090
m = 24679;
n = 13090;

while n > 0     % Euclidean algorithm
   reminder = mod(m,n);
   m = n;
   n = reminder;
end
display(m);     % gcd calculated by Euclidean algorithm
GCD = gcd(m,n); % theorectical gcd calculated by matlab function
display(GCD);