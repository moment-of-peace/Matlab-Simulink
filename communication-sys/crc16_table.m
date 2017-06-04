function [lcrc16] = crc16_table(lcrc16, data, len, tbl)

	% block code for CRC comes from Communication Research Center Canada
	% and is released under the GPL license

	idx = 1;
	while (len)
		len = len - 1;

		if (is_octave())
			newupper = bitshift(lcrc16, 8, 16);
			newlower = bitshift(lcrc16, -8, 16);
		else
			newupper = bitshift(lcrc16, 8, 'uint16');
			newlower = bitshift(lcrc16, -8, 'uint16');
		end
		byte = data(idx);

		lookup = bitxor(newlower, byte);

		lcrc16 = bitxor(newupper, tbl(lookup+1));
		idx = idx + 1;
	end

end

function r = is_octave ()
  persistent x;
  if (isempty (x))
    x = exist ('OCTAVE_VERSION', 'builtin');
  end
  r = x;
end
