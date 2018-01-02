function plot_notes(signal, Fs, plotHandle, ref_notes)

[notes, mags, diffs, freq_mags, xfft] = get_notes(signal, Fs, ref_notes, 1000, 1);
subplot(1,4,1);

rectangle('Position',[0,0,2,1], 'FaceColor', 'white')
if ~isempty(notes)   
    text(.025,0.6,['1: ', notes(1), ' ', diffs(1), ' ', mags(1)])
end
if length(notes) > 1
    text(.025,0.3,['2: ', notes(2), ' ', diffs(2), ' ', mags(2)])
end

end