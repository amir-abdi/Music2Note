% Arguments
% 1- num: return only the biggest num notes/frequencies (default = 2)
% 2- thres_accept: Only accept the note if the absolute difference between 
% the recorded note and the reference note was less than thres_accept
% (default = no threshold)
% 3- verbose: if true, display the "num" number of most prominent notes.

function [notes, magnitudes, differences, mags, xfft] = get_notes(signal, Fs, ref_notes, varargin)

if length(varargin) > 3
    error('Too many input arguments; expected at most 5 arguments');
end

optargs = {2 1000 true}; 
optargs(1:length(varargin)) = varargin;
[num, thres_accept, verbose] = optargs{:};

notes_names = table2array(ref_notes(:,1));
notes_freqs = table2array(ref_notes(:,2));

nfft = length(signal);
nfft2 = 2^nextpow2(nfft);
ff = fft(signal, nfft2);
ff_by2 = ff(1:nfft2/2);
xfft = Fs*(0:nfft2/2-1)/nfft2;

mags = abs(ff_by2);
[freqs_mag, sort_idx] = sort(mags, 'descend');
freqs_x = xfft(sort_idx);

notes = [];
magnitudes = [];
differences = [];

for i=1:min(length(freqs_x), num)
    [min_diff, min_note_index] = min(abs(notes_freqs-freqs_x(i)));
    note = notes_names(min_note_index);
    if min_diff <= thres_accept && ... % difference less than threshold
            sum(strcmp(notes,note)) == 0 % note is not already inserted
        notes = [notes; note];
        differences = [differences; min_diff];
        magnitudes = [magnitudes; freqs_mag(i)];
    end    
end

if verbose && ~isempty(notes)
    disp([notes(1), differences(1), magnitudes(1)]) 
end