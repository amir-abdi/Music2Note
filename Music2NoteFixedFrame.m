clc
clear all
close all

notes = readtable('notes.csv');
notes_names = table2array(notes(:,1));
notes_freqs = table2array(notes(:,2));
[y,Fs] = audioread('test.m4a');
y = y(4e4:end);
Ts = 1/Fs;
dt = 0:Ts:length(y)*Ts;
main_fig = figure;
plot(y)
%%
thres_accep = 1.0; %hertz
frame_size_secs = 0.5;
frame_size_samples = frame_size_secs/Ts;

%%
results_1 = {};
results_2 = {};
count_1 = 0;
count_2 = 0;
for i = 1 : frame_size_samples : length(y)-frame_size_samples        
    count_1 = count_1+1;
    count_2 = count_2+1;
    signal = y(i:i+frame_size_samples);
%     sound(signal, Fs)
    nfft = length(signal);
    nfft2 = 2^nextpow2(nfft);
    ff = fft(signal, nfft2);
    ff_by2 = ff(1:nfft2/2); %fff
    xfft = Fs*(0:nfft2/2-1)/nfft2;
    
    % max approach
%     [max_amp, max_index_1] = max(abs(ff_by2));
         
    % sort approach
    [sorted, sort_idx] = sort(abs(ff_by2));
    max_index_1 = sort_idx(end);
    max_index_2 = sort_idx(end-1);
%     assert(max_freq_1_test == max_freq_1, ...
%         [num2str(max_freq_1_test), ' ', num2str(max_freq_1)])
    
    
    max_freq_1 = xfft(max_index_1);    
    max_freq_2 = xfft(max_index_2);    
    [min_diff_1, min_note_index_1] = min(abs(notes_freqs-max_freq_1));
    [min_diff_2, min_note_index_2] = min(abs(notes_freqs-max_freq_2));
    
    if min_diff_1 < thres_accep
        note = notes_names(min_note_index_1);
        disp(note)
        results_1{1}(count_1) = min_diff_1;
        results_1{2}(count_1) = note;
        % add text to main figure
        figure(main_fig)
        hold on
        text(i, abs(y(i)), note)
    else
        results_1{1}(count_1) = min_diff_1;
        results_1{2}(count_1) = {'NULL'};
    end
    
    if min_note_index_2 ~= min_note_index_1 && ...
            min_diff_2 < thres_accep
        note = notes_names(min_note_index_2);
        disp(note)
        results_2{1}(count_2) = min_diff_2;
        results_2{2}(count_2) = note;
        % add text to main figure
        figure(main_fig)
        hold on
        text(i, abs(y(i))-0.1, note, 'color', 'red')
    else
        results_2{1}(count_2) = min_diff_2;
        results_2{2}(count_2) = {'NULL'};
    end
    
%     % visualize original signal in Time domain    
%     dt_signal = dt(1:length(signal));
%     figure
%     subplot(2,1,1)
%     plot(dt_signal, signal)
%     xlabel('Time (s)');
%     ylabel('Amplitude');
%     
%     subplot(2,1,2)
%     plot(xfft, abs(ff_by2 )) 
%     xlabel('Frequency (Hz)');
%     ylabel('amplitude (abs(fft))')
%     break;
end