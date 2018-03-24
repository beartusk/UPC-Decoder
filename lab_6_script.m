clc;

%--------------------------------------------------------------------
% Lab P-10: Edge Detection in Images: UPC Decoding
%--------------------------------------------------------------------
%--------------------------------------------------------------------
% 3 Lab: FIR Filtering of Images
%--------------------------------------------------------------------
% 3.1 Finding Edges: 1-D Filter Cascaded with a Nonlinear Operators
%--------------------------------------------------------------------
% 3.1.1 Edge Detection and Location via 1-D Filters
%--------------------------------------------------------------------
% a.
%--------------------------------------------------------------------
   
xx = 255*(rem(1:159,30)>19);
bb = [1 -1]; 
yy = firfilt(bb,xx);

subplot(2,1,1);
stem(xx);
title('x[n]');
subplot(2,1,2);
stem(yy);
title('y[n]');

%--------------------------------------------------------------------
% d.
%--------------------------------------------------------------------

Tao = 250;
edges = abs(yy) >= Tao;

%--------------------------------------------------------------------
% e.
%--------------------------------------------------------------------

edge_locations = find(edges);
figure(2);
stem(edge_locations);

%--------------------------------------------------------------------
% 3.2 Bar Code Detection and Decoding
%--------------------------------------------------------------------
% 3.2.1 Decode the UPC from a Scanned Image
%--------------------------------------------------------------------
% a.
%--------------------------------------------------------------------
 
upc = imread('HP110v3','png');
upc_middle = upc(250,:);

%--------------------------------------------------------------------
% b.
%--------------------------------------------------------------------

x_n = double(upc_middle);
y_n = firfilt(bb, x_n);
figure(3);
subplot(2,1,1);
stem(upc_middle);
title('x[n]');
subplot(2,1,2);
stem(y_n);
title('y{n}');

%--------------------------------------------------------------------
% c.
%--------------------------------------------------------------------

thresh = 150;
upc_edges = abs(y_n) > 150;
temp_upc_edge_locations = find(upc_edges);
upc_edge_locations = temp_upc_edge_locations(6:65);
%Line 74's purpos is to cutoff the black and white lines on the outside of 
%UPC code that is not actually part of the UPC code.
figure(4);
stem(upc_edge_locations);

%--------------------------------------------------------------------
% d.
%--------------------------------------------------------------------

delta_n = firfilt(bb, upc_edge_locations);
delta_n = delta_n(2:60);
figure(5);
subplot(2,1,1);
stem(upc_edge_locations);
title('l[n]');
subplot(2,1,2);
stem(delta_n);
title('delta[n]');

%--------------------------------------------------------------------
% g.
%--------------------------------------------------------------------

delta_n = round(delta_n/7.81);
figure(6);
stem(delta_n);
title('delta[n] fixed');

%--------------------------------------------------------------------
% h.
%--------------------------------------------------------------------

UPC_code = decodeUPC(delta_n);

%--------------------------------------------------------------------
% i.
%--------------------------------------------------------------------

True_code = [8 8 2 7 8 0 4 5 0 1 6 5];
if True_code == UPC_code
    display(UPC_code);
    display('This code is correct');
end

%--------------------------------------------------------------------
% j.
%--------------------------------------------------------------------

upc = imread('OFFv3','png');
upc_middle = upc(84,:);

x_n = double(upc_middle);
y_n = firfilt(bb, x_n);
% figure(7);
% stem(y_n);
% title('y{n}');

thresh = 150;
upc_edges = abs(y_n) > 150;
temp_upc_edge_locations = find(upc_edges);
upc_edge_locations = temp_upc_edge_locations(4:63);

delta_n = firfilt(bb, upc_edge_locations);
delta_n = delta_n(2:60);
% figure(7);
% subplot(2,1,1);
% stem(upc_edge_locations);
% title('l[n]');
% subplot(2,1,2);
% stem(delta_n);
% title('delta[n]');

delta_n = round(delta_n/2.42);
delta_n(58) = 1;
% figure(8);
% stem(delta_n);
% title('delta[n]');

UPC_code = decodeUPC(delta_n);

disp(UPC_code);