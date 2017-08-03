function [ name ] = name_from_path( path )
%NAME_FROM_PATH Summary of this function goes here
%   Detailed explanation goes here
    elems = strsplit(path, '/');
    matname = elems{end};
    elems = strsplit(matname, '.');
    name = elems{1};
end

