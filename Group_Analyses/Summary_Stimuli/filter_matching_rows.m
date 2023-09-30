function A_sub = filter_matching_rows(A, B)
    % This function filters rows in structure A that have the same values as 
    % those in structure B for the common fields. It returns a subset of A.
    %
    % Inputs:
    %   A - A structure array. Each field of A should be a column vector.
    %   B - A structure with fewer fields than A. All fields of B should also
    %       be present in A. Each field of B should be a scalar value.
    %
    % Outputs:
    %   A_sub - A subset of A. It contains all rows from A that have the
    %           same values as those in B for the common fields.

    % Get fieldnames from structure B
    fieldsB = fieldnames(B);
    
    % Initialize index as true
    idx = true(size(A));

    % Loop over all fields in B
    for i = 1:length(fieldsB)
        % Get current field name
        field = fieldsB{i};

        % Skip if B.(field) is empty
        if isempty(B.(field))
            continue;
        elseif isstring(B.(field)) && B.(field)== ""
            continue;
        end

        if isempty(B.(field))
            % Skip the current iteration if B.(field) is empty
            continue;
        end

        if isnan(B.(field))
            % Skip the current iteration if B.(field) is empty
            continue;
        end

        if ischar(B.(field))
            % Use strcmp for char arrays
            idx = idx & strcmp({A.(field)}', B.(field));
        elseif isnumeric(B.(field)) || islogical(B.(field))
            % Use equality operator for numeric and logical arrays
            idx = idx & ([A.(field)]' == B.(field));
        else
            error('Unsupported field value type in B.');
        end

    end
    
    % Return subset of A
    A_sub = A(idx);
end
