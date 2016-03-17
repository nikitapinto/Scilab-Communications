funcprot(0)
function h = jakesir(fd,t)
    // Jakes Doppler Filter Response
    // h = jakesir(fd,t) returns the normalized impulse response of a Jakes 
    // Doppler filter.
    // fd is the maximum Doppler shift (Hz) and t is a vector of time domain values.

    // Input Checking
    if (argn(2) ~= 2) then
        error('Incorrect number of Inputs. Number of Inputs should be 2')
    end

    if (prod(size(fd))~= 1) then
        error('fd must be a single value')
    end

    if (~isrow(t) & ~iscolumn(t)) then
        error('t must be a vector')
    end


    // Compute x-1/4 J1/4(x) and peak value
    nuparam = 1/4;
    absx = abs(2*%pi*fd*t);
    JFpeak = ((1/2)^nuparam) / gamma(nuparam+1);
    JF = real(absx .^ -nuparam .* besselj(nuparam,absx));
    JF(isnan(JF)) = JFpeak;

    // Normalized Impulse Response
    win = window('hm',length(JF));
    h1 = JF .* win;
    h = h1 ./ sqrt(sum(abs(h1).^2));

endfunction
