x = -10 : 0.1 : 10;
y = -10 : 0.1 : 10;

[x_new, y_new]=meshgrid(x,y);

for k1 = 1:size(x_new, 1)
    for k2 = 1:size(x_new, 2)
        X = [x_new(k1, k2), y_new(k1, k2)];
        z(k1, k2)=ObjectiveFunction(X);
    end
end

surfc(x_new, y_new, z);
xlabel('x');
ylabel('y');
zlabel('Objective Wert')
shading flat