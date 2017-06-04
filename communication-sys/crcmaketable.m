function [crctable] = crcmaketable()

	% we need a lookup table of 8 bit values
	% which we can then apply to byte values
	crctable = zeros(256, 1);
	for z=0:255
		zzbits = bitget(z, 16:-1:1);
		% convert z to bit string
		crctable(z + 1) = crccalc(zzbits);
	end


end

function [crc16] = crccalc(inx)
	% generator polynomial
	gp = [ 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1 ];

	gp = gp(:); % make gp into a column vector

	inx = inx(:); % make inx a column vector

	% step 1: multiply message by p^16
	in = [inx; zeros(16,1)];

	% remainder stored in p(2:17), p(1) is the 'extra bit' which needs to become 0
	p = zeros(17, 1);

	for zz=1:length(in)
		p = circshift(p, -1);
		if (p(1) == 1)
			p = xor(p, gp);
		end

		p(end) = xor(p(end), in(zz));
	end

	% the remainder
        crcout = p(2:17);
	% group the bits into a decimal number
	ss = sprintf('%i', crcout);
	crc16 = bin2dec(ss);
end	
