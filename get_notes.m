function [notes, magnitudes, differences, mags, xfft] = get_notes(signal, Fs, varargin)

if length(varargin) > 2
    error('Too many input arguments; expected at most 4 arguments');
end

% default values:
% 2: only two top notes
% no thres: if the difference was beyond 10000 Hz, ignore the note.
optargs = {2 1000}; 
optargs(1:length(varargin)) = varargin;
[num, thres_accept] = optargs{:};

ref_notes = readtable('notes.csv');
notes_names = table2array(ref_notes(:,1));
notes_freqs = table2array(ref_notes(:,2));

nfft = length(signal);
% disp([length(signal), Fs]);
nfft2 = 2^nextpow2(nfft);
ff = fft(signal, nfft2);
ff_by2 = ff(1:nfft2/2); %fff
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

if ~isempty(notes)
    disp([notes(1), differences(1), magnitudes(1)]) 
end