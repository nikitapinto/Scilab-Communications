funcprot(0);
// Find primitive polynomials for  Galois field
//   pr = primpoly(m) computes one degree-M primitive polynomial for gf(2^m). 
//
//   pr = primpoly(m, option) computes primitive polynomial(s) for GF(2^m).
//   option = 'min'  find one primitive polynomial of minimum weight.
//   option = 'max'  find one primitive polynomial of maximum weight.
//   option = 'all'  find all primitive polynomials. 
//   option = L      find all primitive polynomials of weight L.
//    
//   pr = primpoly(m, option, 'nodisplay') or pr = primpoly(m, 'nodisplay') disables printing of primitive polynomials  
//
//   The output vector is the decimal equivalent of the primitive polynomials.

function pr = primpoly(m,fd,display)

// Input checking
if (argn(2)<1 | argn(2)>3) then
    error('Incorrect number of inputs. Number of inputs should be between 1 and 3')
end

// Check m

if (isempty(m) | ~isreal(m) | m<1 | m>16 | (floor(m)~=m) | (size(m(:),1) * size(m(:),2)) ~= 1 ) then
    error('m must be a single real integer between 1 and 16');
end

// Check fd and display

// no specified fd or display
if (argn(2) == 1) then
    fd = 'one';
    display = '';
// 2 inputs specified
elseif (argn(2)==2) then
    if (type(fd)==10) then
        fd = convstr(fd,"l");
        if (~( strcmp(fd,'min') | strcmp(fd,'max') | strcmp(fd,'all') | strcmp(fd,'nodisplay') | strcmp(fd,'one') )) then
            error('Invalid Input String');
        end
        
        if (fd == 'nodisplay') then
            display = 'nodisplay';
            fd = 'one';
        else
            display = '';
        end
        
    elseif ( isempty(fd) | floor(fd)~=fd | ~isreal(fd) | prod(size(fd))~=1 | fd<2 | fd>m+1 ) then
        error('Invalid Input Option')
    else
        display = '';
    end
        
elseif (argn(2) > 2) then
    if (type(display)==10) then
        if (~(strcmp(display,'nodisplay'))) then
            error('Invalid Input String')
        end
    else
        error('Input must be in string format')
    end      
            
        
end
     

// Load the poly values and assign 

if (m==1) then
    prims = poly1;
elseif (m==2) then
    prims = poly2;
elseif(m==3) then
    prims = poly3;
elseif(m==4) then
    prims = poly4;
elseif(m==5) then
    prims = poly5;
elseif (m==6) then
    prims = poly6;
elseif(m==7) then
    prims = poly7;
elseif(m==8) then
    prims = poly8;
elseif(m==9) then
    prims = poly9;
elseif (m==10) then
    prims = poly10;
elseif(m==11) then
    prims = poly11;
elseif(m==12) then
    prims = poly12;
elseif(m==13) then
    prims = poly13;
elseif(m==14) then
    prims = poly14;
elseif(m==15) then
    prims = poly15;
else
    prims = poly16;
end


// Calculate weights of the polynomials
polyweight =zeros(length(prims),1);
for i = 1:length(prims)
    polyweight(i) = sum(strtod(strsplit(dec2bin(prims(i)))));
end

// Find specified primitive polynomials, 'one' is default case.
if (fd == 'one') then
    // the defaults from gf.m
    p_vec = [3 7 11 19 37 67 137 285 529 1033 2053 4179 8219 17475 32771 69643];
    pr = p_vec(m);
elseif (fd =='all') then
    pr = prims';
elseif (fd =='min') then
    pr=min(prims);
elseif (fd =='max') then
    pr=max(prims);
elseif (or(type(fd)==[1 5 8])) then
    //Check weight L
    if ( ~isreal(fd) | fd<1 | floor(fd)~=fd | prod(size(fd))~=1) then
    error('L must be a real,positive scalar ');
    end
    // Find the primitive polynomials of weight L
    polydec=find(polyweight==fd);
    if (~isempty(polydec)) then
        pr=prims(polydec)';
    else
        pr=[];
    end
end


if (isempty(pr)) then
    warning(('No primitive polynomial satisfies the given constraints'));
end;

if (~isempty(pr) & ~(display=='nodisplay')) then
    disp(' ')
    disp('Primitive polynomial(s) = ')
    disp(' ')
    disp_primpoly(pr)
end

endfunction

//  Display the polynomials
function disp_primpoly(pr)
    for (j = 1:length(pr))    
        pr_temp = pr(j);    
        pr_temp = strtod(strsplit(dec2bin(pr_temp)));
        pr_temp = pr_temp';
        pr_temp = pr_temp(:,$:-1:1);

            s=find(pr_temp);
            if (s(1)==1) then
                init_str='1';
            else
                init_str='0';
            end
            s(1)=[];
            s=s-1;

            if (~isempty(s)) then

                s = s(:,$:-1:1);
                str1 = [];
                for k = 1:length(s)
                    str1 = [str1, msprintf('D^%d+',s(k))];
                end
                str1 = [str1 init_str];
                if (str1($)=='0') then
                    str1($-1:$)=[]; 
                end
                disp(str1)
            end
        end

endfunction




