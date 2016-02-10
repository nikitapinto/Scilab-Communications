funcprot(0);

function y = ssbmod (x,fc,fs,varargin)

// Single Sideband Modulation
// Description :
// This function performs single sideband modulation of a carrier signal by a message signal. It returns the modulated signal which is sampled at a specifies frequency.            Note that this sampling frequency must satisfy the Nyquist Criterion where Freq_sampling >  2*(Freq_carrier + Bandwidth).
// y = ssbmod(x,fc,fs) performs single sideband amplitude modulation of carrier signal of frequency fc (Hz). fs (Hz) is the sampling frequency of signals x and fc. By default,     the modulated signal has zero initial phase, and lower sideband modulation.
// y = ssbmod(x, fc, fs, initial_phase) specifies the initial phase angle (rad) of the modulated signal.
// y = ssbmod(x, fc, fs, initial_phase, 'upper') defines upper sideband modulation.
// Details :
// Date - Feb/10/2016  Author - Nikita Roseann Pinto 

    
    // Input Checking
    
	// Number of inout arguments
    if (argn(2)>5) then
        error('Too many inputs. Number of inputs should be between 3 and 5' )
    end
    
    if (argn(2)< 3) then
        error('Insufficient inputs. Number of inputs should be between 3 and 5' )
    end
    
    // Check message signal - x
    check_x = (or(type(x)==[1,5,8]));
    if (~(check_x)) then
        error('x must be numeric ')
    end
    
    if (~isreal(x)| ~(check_x)) then
        error('x must be real')
    end
	
	// Check carrier frequency - fc
    check_fc = or(type(fc)==[1,5,8]);
    if (~(check_fc) ) then
        error('fc must be numeric')
    end
    
    if (~isreal(fc)| ~isscalar(fc)| fc<=0) then
        error('fc must be real, positive and scalar')
    end
    

    
	// Check sampling frequency - fs. 
	// fs >= 2*fc  (Nyquist sampling criterion)
    check_fs = or(type(fs)==[1,5,8]);
    if (~(check_fs) ) then
        error('fs must be numeric')
    end
    
    
    
    if(~isreal(fs) | ~isscalar(fs) | fs<=0 ) then
        error('fs must be real, positive and scalar');
    end
   

    
    if(~(fs>=2*fc))
        error('fs must be atleast 2* fc');
    end    
    
    // Check initial_phase
    if(argn(2)>=4)
        initial_phase = varargin(1);
        
        check_initialphase = or(type(initial_phase)==[1,5,8]) ;
        if(~check_initialphase)
            error('initial_phase must be a numeric value');
        end 
        
        if(isempty(initial_phase))
            initial_phase = 0;
        end
        
   
        
        if  (~isreal(initial_phase) | ~isscalar(initial_phase))
            error('initial_phase must be a real and scalar');
        end
        else 
        initial_phase = 0;
    end
    
	// Check method
    Method = '';
        if(argn(2)==5)
        Method = varargin(2);
        if(strcmpi(Method,'upper')~=0)
            error('Method must be in string format - ''upper''');
        end
        end
    
	// For one dimensional input
		row_data = size(x,1);	
			if (row_data == 1)
				x = x(:);
			end
	
    // Setup t matrix using fs 
		t = ((0:1:((size(x,1)-1)))/fs)';
	// Limit to dimensions of x
		t = t(:, ones(1, size(x, 2)));
    
	// Modulate using Hilbert transform
		if (strcmpi(Method, 'upper')==0) then
			y = x .* cos(2 * %pi * fc * t + initial_phase)- imag(hilbert(x)) .* sin(2 * %pi * fc * t + initial_phase);    
		else
			y = x .* cos(2 * %pi * fc * t + initial_phase) + imag(hilbert(x)) .* sin(2 * %pi * fc * t + initial_phase);    
		end; 
		
	// For one dimensional input
		if(row_data == 1)
			y = y';
		end
	
endfunction
