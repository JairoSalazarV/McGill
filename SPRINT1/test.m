%https://stackoverflow.com/questions/24180890/3d-histogram-with-gnuplot-or-octave

bin_values=rand(5,3); %some random data
bin_edges_x=[0:size(bin_values,2)]; 
x=kron(bin_edges_x,ones(1,5));
x=x(4:end-2);

bin_edges_y=[0:size(bin_values,1)]; 
y=kron(bin_edges_y,ones(1,5));
y=y(4:end-2);

mask_z=[0,0,0,0,0;0,1,1,0,0;0,1,1,0,0;0,0,0,0,0;0,0,0,0,0];
mask_c=ones(5);
z=kron(bin_values,mask_z);

surf(x,y,z);