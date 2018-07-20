clear all; close all;
clc;

xLen      = 25;
yLen      = 20;
X         = zeros(yLen,xLen); Y = X;  Z = X;
X         = kron(X,ones(6,6));

mask_z=[ 0,0,0,0,0,0
         0,0,0,0,0,0
         0,0,1,1,0,0
         0,0,1,1,0,0
         0,0,0,0,0,0
         0,0,0,0,0,0];





%{

%Data generation
[X,Y,Z] = peaks(5);

%First we plot the surface
h = surf(X,Y,Z);
%We change the view (optionnal)
view(45,30);
%The plot become white
colormap([1,1,1])
%h.EdgeColor = 'None';
%And now we plot our 3D lines.
hold on 
plot3(X,Y,Z,'b');
xlabel("x");
ylabel("y");
zlabel("z");
%}

