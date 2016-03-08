funcprot(0);
function gfpretty(polyvect,str,n)
//gfpretty(polyvect) displays the GF polynomial polyvect in a traditional format. polyvect is a row vector that
//specifies the polynomial coefficients in order of ascending powers. Terms whos coefficients are zero
//are eliminated from the output.
//
//gfpretty(polyvect, str) displays GF polynomial with the polynomial variable
//specified in the string variable str.
//
//gfpretty(polyvect, str, n) uses screen width n.

// Input checking

// Checking for str
if (argn(2) < 2) then
   str = 'X';
elseif (isempty(str) | (type(str)~=10))
   error('str is an invalid string')        
end
    
// Checking for n
if (argn(2) < 3) then
   n = 79;
end
    
// Checking for polyvect
if (isempty(polyvect) | (size(polyvect,1)~=1) | (ndims(polyvect) ~=2 )) then
    error('polyvect must be a row vector')  
end

chk_test = (or(floor(polyvect)~=polyvect) | or(~isreal(polyvect)) | or(polyvect<0));
if (chk_test) then
    error('Coefficients of polyvect must be real, positive integer values')
end


//% initial condition
lstr = [];
ustr = [];
polyvect = gftrunc(polyvect);

//% assign string based on the GF polynomial
if length(polyvect) <= 1
    lstr = string(polyvect);
else
    for i=1:length(polyvect)
        if polyvect(i) ~= 0
//            % the first one is constant
            if i == 1
                str1 = string(polyvect(1));
            else
                if abs(polyvect(i)) == 1
                    str1 = str;
                else
                    str1 = [string(polyvect(i)), ' ', str];
                end;
            end;
//            % the first assignment without '+'
            if isempty(lstr)
                lstr = str1;
                spa = size(str1,2);
            else
                lstr = [lstr, ' ','+',' ', str1]; 
                spa = size(strsplit(strcat(str1)),1)+3;
            end;
//            % match the power term
            if i > 2
                pow = string(i-1);
            else
                pow = string([]);
            end
            split_pow = strsplit(pow);
            length_pow = size(split_pow,1);
//            % set the string to be a same length
            ustr = [ustr,repmat(' ',1,spa),split_pow']
//            ustr = [ustr, char(ones(1,spa)*32), pow]; 
            lstr = [lstr, repmat(' ',1,length_pow) ]
//            lstr = [lstr, char(ones(1,length(pow))*32)]; 
        end;
    end;
end;

// display polynomial
if size(lstr,2) < n
//     under limit
    spa = floor((n-size(lstr,2))/2);
    pow = repmat(' ',1,spa);
    lstr = [pow, lstr];
    ustr = [pow, ustr];
else
//    over the limit
    while(size(lstr,2) >= n)
        temp = size(lstr,2);
//        ind = strindex(lstr, '+');
        ind = find(lstr == '+');
        sub_ind_1 = find(ind < 79);
        sub_ind = sub_ind_1($);
        
        disp(' ')
        disp(ustr(1:max(ind(sub_ind)-1)));
        disp(lstr(1:max(ind(sub_ind)-1)));
//        % add space for indent
        ustr = ['          ',ustr(ind(sub_ind):size(ustr,2))];
        lstr = ['          ',lstr(ind(sub_ind):size(lstr,2))];
        if ( temp == size(lstr,2) )
            break;
        end
    end;
end;

disp(' ')
disp(ustr);
disp(lstr);

 
endfunction
