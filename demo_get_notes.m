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

for i = 1 : frame_size_samples : length(y)-frame_size_samples        
    signal = y(i:i+frame_size_samples);
    [notes, mags, diffs] = get_notes(signal, Fs, 2, 1);
    figure(main_fig)
    hold on
    if ~isempty(notes)
        text(i, 0, notes(1))
    end
    if length(notes) > 1
        text(i, -0.1, notes(2), 'color', 'red')
    end
end
