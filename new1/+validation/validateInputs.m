% ==============================================================================
% TEN FILE: validateInputs.m
% CHUC NANG: Kiem tra dau vao cho cac ham GCC
% MODULE: validation
% ==============================================================================
%
% Mo ta: Kiem tra tinh hop le cua dau vao cho cac ham uoc luong do tre
%        Dam bao tin hieu co kich thuoc dung, pho hop le, v.v.
%
function isValid = validateInputs(varargin)

isValid = true;

% Kiem tra so luong tham so
if nargin < 2
    error('validation:validateInputs:NotEnoughInputs', ...
          'Can it nhat 2 tham so dau vao');
end

% Kiem tra tin hieu
s1 = varargin{1};
s2 = varargin{2};

if ~isvector(s1) || ~isvector(s2)
    error('validation:validateInputs:InvalidSignalType', ...
          'Tin hieu phai la vector');
end

if length(s1) ~= length(s2)
    error('validation:validateInputs:SignalLengthMismatch', ...
          'Hai tin hieu phai co cung do dai');
end

if length(s1) < 32
    error('validation:validateInputs:SignalTooShort', ...
          'Tin hieu phai co it nhat 32 mau');
end

if any(~isfinite(s1)) || any(~isfinite(s2))
    error('validation:validateInputs:NonFiniteValues', ...
          'Tin hieu khong duoc chua gia tri Inf hoac NaN');
end

% Kiem tra pho neu co
if nargin >= 3
    Pxy = varargin{3};
    if ~isvector(Pxy) || length(Pxy) ~= length(s1)
        error('validation:validateInputs:InvalidSpectrum', ...
              'Pho phai la vector co cung do dai voi tin hieu');
    end
end

end

