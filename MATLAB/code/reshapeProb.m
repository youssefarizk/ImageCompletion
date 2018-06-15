function prob_final = reshapeProb(normalP,iroi)

x_l = iroi(1); x_r = iroi(2); y_u = iroi(3); y_d = iroi(4);
width = x_r - x_l;
height = y_d - y_u;

prob_final = reshape(normalP,[height, width]);

end