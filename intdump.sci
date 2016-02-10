funcprot(0);
function data_out = intdump(data, nsamp)

// Integrate and Dump
// Description : 
// This function performs integration of the data signal over a symbol period, and then dumps the averaged the value as output. 
// The symbol is represented by the number of samples per symbol as nsamp. In the case of 2-dimensional signals, the function supports multiple channels by treating each column    of the input matrix as a single channel.
// Note that the number of samples per channel of the input signal must be an integral multiple of the number of samples per symbol (nsamp).
// data_out = intdump(data,nsamp) integrates the data signal for one symbol period and outputs the averaged value into data_out.
// data_out is of dimension (no.samples_eachchannel / nsamp) by (no.channels).
// Details : 
// Date - Feb/10/2016  Author - Nikita Roseann Pinto 


// Input checking
// Check number of arguments
if (argn(2)~=2) then
    error('Incorrect number of inputs. Number of inputs should be 2')
end

// Check data
    if (length(size(data))> 2) then
        error('Data must be 2-dimensional')
    end


    check_data = (or(type(data)==[1,5,8]));
    if(~(check_data))  then
        error('Data must be numeric')
    end



// Check nsamp 
    check_nsamp = (or(type(nsamp)==[1,5,8]));
    if(~(check_nsamp)) then
    error('Nsamp must be a numeric value');
    end
    
    if(~isreal(nsamp) | ~isscalar(nsamp) | nsamp<=0 |(ceil(nsamp) ~=nsamp )) then
        error('Nsamp must be a real, positive and scalar integer value' )
    end
    
// If data is 1 dimensional
    row_data = size(data,1);
    if(row_data==1) then
        data = data(:);
    end

// Length of channels in data must be an integer multiple of length of symbols
    
    if( isvector(data)) then
        if( (length(data) - (fix(length(data)./ nsamp) .* nsamp)) ~=0 ) then
            error('Number of elements in each channel of data must be an integer multiple of nsamp' );
        end
    else
        if( (size(data,1) - (fix(size(data,1)./ nsamp) .* nsamp)) ~=0 ) then
            error('Number of elements in each channel of data must be an integer multiple of nsamp' );
        end
    end

// Extract dimensions of data
    [n_rows, n_cols] = size(data);

// Channel-wise integration of data over symbol length = nsamp
// Integrated value dumped to output matrix (m/nsamp x n)

//    temp = mean(matrix(data, nsamp, (n_rows*n_cols)/nsamp), 'r');
//   data_out = matrix(temp, 3, 2);      
      data_out = matrix((mean(matrix(data, nsamp, (n_rows*n_cols)/nsamp), 'r')),(n_rows/nsamp),n_cols);  

// If data is 1 dimensional
    if(row_data == 1) then
        data_out = data_out.';
    end

endfunction
