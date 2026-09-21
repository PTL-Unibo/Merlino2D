function [color] = Num2Color(num)

rgb_arr = [25, 76,  127, 178, 229;
           51, 102, 153, 204, 255;
           229, 178, 127, 76, 25]/255;

base = 5;
num = min((base^3)-1,num);
u = mod(num,base);
d = mod(num-u,base^2)/base;
c = (num-d*base-u)/base^2;

switch mod(num,3)
    case 0
        order = [c, d, u] + 1;
        k = [3,1,2];
    case 1
        order = [u, c, d] + 1;
        k = [2,3,1];
    case 2
        order = [d, u, c] + 1;
        k = [1,2,3];
end

color = [rgb_arr(k(1),order(1)), rgb_arr(k(2),order(2)), rgb_arr(k(3),order(3))];

end