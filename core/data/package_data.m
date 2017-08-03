data = {};

data.raw = raw;
data.labels = zebra;


data.N = size(data.raw, 1);
data.D = size(data.raw, 2);
data.name = 'Zebra';
data.label_type = 'categorical';

odat = data


%%

data.N = size(data.raw, 1);
data.D = size(data.raw, 2);
data.name = 'caltech101-caffenet';
data.label_type = 'categorical';