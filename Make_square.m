function img = Make_square(input_img)
[x,y] = size(input_img);
if (x == y)
    img = input_img;
    return;
end

if(x > y)
    img = ones(x,x);
    if ((x-y) == 1)
        img(1:x,1:y) = input_img;
        return;
    end
    img(1:x,fix((x-y)/2):fix((x-y)/2)+y-1) = input_img;
    return;
end

if(x < y)
    img = ones(y,y);
    if ((y-x) == 1)
        img(1:x,1:y) = input_img;
        return;
    end
    img(fix((y-x)/2):fix((y-x)/2)+x-1,1:y) = input_img;
    return;
end