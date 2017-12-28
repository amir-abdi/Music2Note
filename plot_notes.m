function plot_notes(signal, Fs, plotHandle)

[notes, mags, diffs, freq_mags, xfft] = get_notes(signal, Fs, 2, 1);

% axes(plotHandle) % sets ax1 to current axes
subplot(1,4,2:4);
set(plotHandle, 'ydata', freq_mags, 'xdata', xfft); % Updating the plot
drawnow; % Update the plot

subplot(1,4,1);
if ~isempty(notes)
    rectangle('Position',[0,0,2,1], 'FaceColor', 'white')
    text(.025,0.6,['1: ', notes(1)])
end
if length(notes) > 1
    text(.025,0.3,['2: ', notes(2)])
end

end