funcprot(0)
function coeffvect =  commstr2poly(txt)


polyParams = init(txt);
length_polyParams = size(polyParams.terms,1);
isVarPresent = zeros(1,length_polyParams);

// Extract all the values for each term..
    for i = 1:length_polyParams
        [polyParams, isVarPresent(i)] = findvarnam(polyParams,i);
    end
    
    coeffvect = zeros(1,max(strtod(polyParams.powers)));
    
// Confirm the coeffs and setup polynomial vector
    for i = 1:length_polyParams

        if (isVarPresent(i)) then
           [polyParams,coeffvect]= parseterm(polyParams,coeffvect,i);
        else
           [polyParams,coeffvect] = parseconstant(polyParams,coeffvect,i);
        end

    end

endfunction

// Function initialize
function polyParams = init(txt)
    strs = strsplit(txt);
    minus_idx = find(strs == '-');

    for i = 1:length(minus_idx)
        if (minus_idx(i)==1) then
            continue;
        end
        txt = strcat(strs(1:minus_idx(i)-1)) + '+' + strcat(strs(minus_idx(i): $));
        strs = strsplit(txt)
    end

txt = strcat(strs);
    polyParams.txt                   = txt;
    polyParams.terms                 = splitterms(txt);
//  polyParams.coeffs = cell(size(polyParams.terms));
//    polyParams.powers = cell(size(polyParams.terms));
    polyParams.powers                = repmat('',size(polyParams.terms,1),1);
    polyParams.coeffs                = repmat('',size(polyParams.terms,1),1);
//    polyParams.coeffs                = [];
    polyParams.Vname                 = '';      
    polyParams.variableFound         = %F;
    polyParams.minus = zeros(size(polyParams.terms,1),1);
//    polyParams.negativePowers        = %F;
//    polyParams.positivePowers        = %F;
    polyParams.constSpecified        = %F;
//    polyParams.parseAlpha            = %F;
//    polyParams.primElemFound         = %F;

endfunction
 
function terms =  splitterms(txt)


splittxt = strsplit(txt);
splittxt = [splittxt ; '0'];
loopcount = strindex(txt,'+');

length_loopcount = length(loopcount);
terms = cell(length_loopcount+1,1);
start = 1;
loopcount = [loopcount size(splittxt,1)]

for i = 1:length(loopcount)
    terms(i) = cellstr(stripblanks(strcat(splittxt(start:loopcount(i)-1))));
    start = loopcount(i) + 1;
end

endfunction


function [polyParams, isVarPresent] = findvarnam(polyParams,idx)

term = string(polyParams.terms(idx));
asciitest = [45, 48:57 , 65:90, 97:122];
str1 = strsplit(term);
str1(~members(ascii(str1),asciitest)) = [];
if (str1(1)== '-') then
    minus = %T;
    str1(1) = [];
else
    minus = %F;
end
term = strcat(str1);

//no_nan = or(isnan(strtod(strsplit(term))));

if (~or(isnan(strtod(strsplit(term))))) then
    polyParams.coeffs(idx) = term;
    polyParams.powers(idx) = '';
    polyParams.variable = [];    
else    
    // if const and var present
    [a1,Nchar,c,token1]    = regexp(term,'/(?P<const>\d+)(?P<var>\w+)/');
    if (a1==1) then
        tempvar = strrev(token1(2));        
        [a2,N,c,token2] = regexp(tempvar,'/(?P<power>\d+)(?P<var>\w+)/');
        if (a2~=1) then
            polyParams.coeffs(idx) = token1(1);
            polyParams.variable = (token1(2));
            polyParams.powers(idx) = '';
        else
            polyParams.coeffs(idx) = token1(1);
            polyParams.variable = strrev(token2(2));
            polyParams.powers(idx) = strrev(token2(1));
        end
//        break;

    else

        [a4,Nchar,c,token4]    = regexp(term,'/(?P<var>\w+)/');
        if (a4==1) then
            tempvar1 = strrev(token4(1));        
            [a5,N,c,token5] = regexp(tempvar1,'/(?P<power>\d+)(?P<var>\w+)/');
            if (a5 ~= 1) then
                polyParams.coeffs(idx) = '';
                polyParams.variable = (token4(1));
                polyParams.powers(idx) = '';
            else
                polyParams.coeffs(idx) = '';
                polyParams.variable = strrev(token5(2));
                polyParams.powers(idx) = strrev(token5(1)); 
            end
        end
    end
end
    
    // check minus flag and add to coefficient
    if (minus) then
//        polyParams.minus(idx) = '-' + polyParams.coeffs(idx);
        polyParams.minus(idx) = 1;
    end




    isVarPresent = ~isempty(polyParams.variable);
    if (isVarPresent) then
        //        termCoeff = polyParams.coeffs(idx);

        if (~polyParams.variableFound) then 
            //            % We had no explicit Vname until now, so capture it:
            polyParams.Vname = polyParams.variable;
            polyParams.variableFound = %T; 
        end                
 
    end                
    
    

endfunction

// function for parse constant
function [polyParams,coeffvect] = parseconstant(polyParams,coeffvect,idx)

// test for already encountered constants
dupc = polyParams.constSpecified;

if (~dupc) then
    polyParams.constSpecified = %T;
    coeffvect(idx) = strtod(polyParams.coeffs(idx));
else
    error('Invalid constant in Input String')
end

if (polyParams.minus(idx)) then
    coeffvect(idx) = -coeffvect(idx);
end
endfunction


// function to parse string and fill coeffs vector;
function [polyParams,coeffvect]= parseterm(polyParams,coeffvect,idx)

coeffstr = polyParams.coeffs(idx);
powerStr = polyParams.powers(idx);

if (coeffstr=='') then
    coeffstr = '1';
end

if isempty(powerStr) then
//        % just x ... no x1 or x^1, but it means the same thing.
        powerNum = 1;
        polyParams.powers(idx) = '1';
    else
        powerNum = strtod(powerStr);
        orig_power = powerStr;
       
        if (powerNum ~= fix(powerNum) | powerNum < 0) then
            error('Power string must be only posit)ve integer values');     
        end
    end
    
        // case of repeated constant 
        dupconst = ((powerNum == 0) & polyParams.constSpecified);
        
//        % Check if this power is already specified.
        pidx = powerNum+1;
    if (dupconst |(length(find(polyParams.powers == string(powerNum))))>1) then 
        error('Duplicate Powers in string' );
    end
    
    polyParams.constSpecified = (polyParams.constSpecified | powerNum==0);
    
    // Get the coefficients
//    if isempty(strtod(coeffstr)) then
//        coeff = 1;
//    else
        coeff = strtod(coeffstr);
//    end
    coeffvect(pidx) = coeff;
    if (polyParams.minus(idx)) then
        coeffvect(pidx) = -coeff;
    end
    
       
    endfunction

