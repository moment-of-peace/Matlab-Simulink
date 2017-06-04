function [crc] = comp_crc16(input)
% comp_crc16 - computes the CRC16 of an array of bytes
% eg input might be [255 201 102 50 0 1]

	% before running this function run the following code
	% (select the appropriate save function for your environment)
	% tbl = crcmaketable();
	% save('-binary', 'crctables.mat', 'tbl'); % octave save
	% save('crctables.mat', 'tbl'); % matlab save
	load('crctables.mat');
	crc = 2^16-1; % 0xffff
	crc = crc16_table(crc, input, length(input), tbl);
	crc = bitxor(crc, 2^16-1);
