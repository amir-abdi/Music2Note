clc
clear all
close all

%% set parameteres
[y,Fs] = audioread('Happy-Birthday-Instrumental.mp3'); % input music file
frame_size_secs = 1.2; % how 
thres_accep = 1.0; % don't print the note if it is not accurate
num = 2; % number_of_notes_per_window
verbose = false;

%% load note frequencies
ref_notes = readtable('notes.csv');
notes_names = table2array(ref_notes(:,1));
notes_freqs = table2array(ref_notes(:,2));

%% FFT
y = y(4e4:end);
Ts = 1/Fs;
dt = 0:Ts:length(y)*Ts;
main_fig = figure;
plot(y)

%% Partition into frames of frame_size_secs seconds and analyse one by one
frame_size_samples = frame_size_secs/Ts;

for i = 1 : frame_size_samples : length(y)-frame_size_samples        
    signal = y(i:i+frame_size_samples);
    [notes, mags, diffs] = get_notes(signal, Fs, ref_notes, num, thres_accep, verbose);
    figure(main_fig)
    hold on
    if ~isempty(notes)
        text(i, 0, notes(1))
    end
    if length(notes) > 1
        text(i, -0.1, notes(2), 'color', 'red')
    end
end
