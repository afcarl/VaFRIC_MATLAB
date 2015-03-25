colours = [52 66 87;
    84 87 76;
    55 88 68;
    21 53 33;
    84 63 29;
    18 72 72;
    85 75 61;
    61 50 87;
    72 83 47;
    75 85 81;
    30 5 73;
    28 49 86;
    79 85 77;
    54 33 60;
    40 70 63];

colour_hash = colours(:,1) + 256*colours(:,2) + 256*256*colours(:,3);
colour_hash = [0; colour_hash];

classes = [0:15];

% mapping = zeros(1,256*256*256);
% mapping(colour_hash+1) = classes+1;
% 
% inverted_index_colour_hash = sparse(mapping);




