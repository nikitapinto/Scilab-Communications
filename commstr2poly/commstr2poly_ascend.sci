funcprot(0);
// Code for commstr2poly(ascend) to generate a vector of coefficients from an input string.
// The coefficients vector is displayed in ascending order

function coeffvect = commstr2poly_ascend(text)


strs = strsplit(text);
minus_idx = find(strs == '-');

// Find indexes of minus signs
for i = 1:length(minus_idx)
    if (minus_idx(i)==1) then
        continue;
    end
    txt = strcat(strs(1:minus_idx(i)-1)) + '+' + strcat(strs(minus_idx(i): $));
    splittxt = strsplit(txt)
end


splittxt = [splittxt ; '0'];
loopcount = strindex(txt,'+');
length_loopcount = length(loopcount);

// Store individual terms in a cell 
terms = cell(length_loopcount+1,1);
start = 1;
loopcount = [loopcount size(splittxt,1)]

for i = 1:length(loopcount)
    terms(i) = cellstr(strcat(splittxt(start:loopcount(i)-1)));
    start = loopcount(i) + 1;
end


powers = repmat('',size(terms,1),1);
coeffs = repmat('',size(terms,1),1);

minus = zeros(size(terms,1),1);

length_terms = size(terms,1);

variableFound = %F;
constFound = %F;

// Extract all the values for each term..
for i = 1:length_terms
    [coeffs(i), powers(i),minus(i),variable(i),variableFound] = extractvalues(terms(i),variableFound);
end

// Setup final coefficients vector 
coeffvect = zeros(1,max(strtod(powers)));

// Fill coefficients vector for each term	
for i = 1:length_terms

    if ~isempty(variable(i)) then
        [coeffvect,powers,coeffs(i),constFound] = withvariable(powers,coeffs(i),constFound,minus(i),coeffvect,i);

    else
        [coeffvect,constFound] = wovariable(coeffs(i),constFound,coeffvect,minus(i),i);
     
    end

end

endfunction
// function to extract values - power,coefficient,variable name, minus sign.
function [coeffs,powers,minus,variable,variableFound] =  extractvalues(terms,variableFound)

    term = string(terms);

    // Remove all elements that dont belong to the test vector
    asciitest = [45, 48:57 , 65:90, 97:122];
    str1 = strsplit(term);
    str1(~members(ascii(str1),asciitest)) = [];

    // Check for minus signs and set flags 
    if (str1(1)== '-') then
        minus = 1;
        str1(1) = [];
    else
        minus = 0;
    end
    term = strcat(str1);


    // check pre processed term for constant and variable

    // only constant present
    if (~or(isnan(strtod(strsplit(term))))) then
        coeffs = term;
        powers = '';
        variable = [];    
    else    
        // if const and var present
        [a1,Nchar,c,token1]    = regexp(term,'/(?P<const>\d+)(?P<var>\w+)/');
        if (a1==1) then
            tempvar = strrev(token1(2));        
            [a2,N,c,token2] = regexp(tempvar,'/(?P<power>\d+)(?P<var>\w+)/');
            if (a2~=1) then
                coeffs = token1(1);
                variable = (token1(2));
                powers = '';
            else
                coeffs = token1(1);
                variable = strrev(token2(2));
                powers = strrev(token2(1));
            end

        else

            [a4,Nchar,c,token4]    = regexp(term,'/(?P<var>\w+)/');
            if (a4==1) then
                tempvar1 = strrev(token4(1));        
                [a5,N,c,token5] = regexp(tempvar1,'/(?P<power>\d+)(?P<var>\w+)/');
                if (a5 ~= 1) then
                    coeffs = '';
                    variable = (token4(1));
                    powers = '';
                else
                    coeffs = '';
                    variable = strrev(token5(2));
                    powers = strrev(token5(1)); 
                end
            end
        end
    end

    if (~isempty(variable)) then
        // Record if variable present for future use
        variableFound = %T; 
    end                


endfunction

// function to fill in final coefficient vector if variable present in the term
function [coeffvect,powers,coeffs,constFound] = withvariable(powers,coeffs,constFound,minus,coeffvect,idx)

    if (coeffs=='') then
        coeffs = '1';
    end


    if isempty(powers(idx)) then
        powerNum = 1;
        powers(idx) = '1';
    else
        powerNum = strtod(powers(idx));
        orig_power = powers(idx);

        if (powerNum ~= fix(powerNum) | powerNum < 0) then
            error('Power string must be only posit)ve integer values');     
        end
    end


    dupconst = ((powerNum == 0) & constFound);

    // Check if this power is already specified
    pidx = powerNum+1;
    if (dupconst |(length(find(powers == string(powerNum))))>1) then 
        error('Duplicate Powers in string' );
    end

    constFound = (constFound | powerNum==0);

    // Get the coefficients
    num_coeff = strtod(coeffs);

    coeffvect(pidx) = num_coeff;
    if (minus) then
        coeffvect(pidx) = -num_coeff;
    end


endfunction

// function to fill final coefficient vector if the term is a constant

function [coeffvect,constFound] = wovariable(coeffs,constFound,coeffvect,minus,idx)
    
if (~constFound) then
    constFound = %T;
    coeffvect(idx) = strtod(coeffs);
else
    error('Invalid constant in Input String')
end

if (minus) then
    coeffvect(idx) = -coeffvect(idx);
end
endfunction
