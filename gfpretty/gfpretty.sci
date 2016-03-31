
funcprot(0);

function gfpretty_mod(polyvect,variable,n)

//gfpretty(polyvect) displays the GF polynomial polyvect in a traditional format. polyvect is a row vector that
//specifies the polynomial coefficients in order of ascending powers. Terms whos coefficients are zero
//are eliminated from the output.
//gfpretty(polyvect, variable) displays GF polynomial with the polynomial variable
//specified in the string variable str.
//gfpretty(polyvect, str, n) uses screen width n. 
// Written by Nikita Roseann Pinto

// Input Checking 

// Check variable

if (argn(2) < 2) then
   variable = 'X';
elseif (isempty(variable) | (type(variable)~=10))
   error('variable must be a non-empty string')        
end

// Check polyvect 
if (isempty(polyvect) | (size(polyvect,1)~=1) | (ndims(polyvect) ~=2 )) then
    error('polyvect must be a row vector')  
end

if ((or(floor(polyvect)~=polyvect) | or(~isreal(polyvect)) | or(polyvect<0))) then
    error('Coefficients of a must be real, positive integer values')
end

// Check screen width n 
if (argn(2) < 3) then
   n = 79;
end

if (~or(type(n)==[1 5 8]) | prod(size(n))~=1 | floor(n)~= n | n<0 ) then
    error('n must a positive scalar number')
end
    

// Initialize lower and upper strings 
lstr = '';
ustr = '';

// Loop through elements of polyvect
for  i = 1:length(polyvect)
	coeff = polyvect(i);
	power = (i-1);
	var = variable;

	
	
	if (coeff ~=0) then
		
// Generate lower string using coefficients and variables.		
		if (i == 1) then
			var = '';
			lstr = string(coeff);
		else
		
        lstr1 = string(coeff);
        

        
        if isempty(lstr) then
            lstr = lstr + lstr1 + var;
        else
        lstr = lstr + ' ' + '+' + ' ' + lstr1 + var; 
        end		
    end
	end
// Generate upper string using power and length of lower string
		
		if (power == 0) then
			powstr = ' ';
			ustr = strcat(repmat(' ',1,size(strsplit(lstr),1))) + powstr;
		else
			if (power == 1 ) then
				powstr = ' ';
			else
				powstr = string(power);
			end
			strlendiff = size(strsplit(lstr),1) - size(strsplit(ustr),1);
			ustr = ustr + strcat(repmat(' ',1,strlendiff)) + powstr;		
		end
		

end

// script to limit number of characters per line

if (size(strsplit(lstr),1) > n) then
	// divide into sub strings of length 79
	div_idx = size(strsplit(lstr),1) / n;
	ustrsplit = strsplit(ustr);
	lstrsplit = strsplit(lstr);
	
	g = i*n + 1;
	for i = 0:div_idx-1
		g = i*n + 1;
		disp(strcat(ustrsplit(g:g+(n-1))))
		disp(strcat(lstrsplit(g:g+(n-1))))
	end
	// last part of the strings outside the loop
    h = div_idx * n;
    disp(strcat(ustrsplit(h:$)))
    disp(strcat(lstrsplit(h:$)))
else
// Display lower and upper strings of polynpmial
	disp(ustr);
	disp(lstr);
end
endfunction

