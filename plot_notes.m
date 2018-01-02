function plot_notes(signal, Fs, plotHandle, ref_notes)

[notes, mags, diffs, freq_mags, xfft] = get_notes(signal, Fs, ref_notes, 1000, 1);

% axes(plotHandle) % sets ax1 to current axes
subplot(1,4,2:4);
ylim([0, 150])
xlim([20, 8e3])
set(plotHandle, 'ydata', freq_mags, 'xdata', xfft); % Updating the plot
% drawnow; % Update the plot

subplot(1,4,1);

rectangle('Position',[0,0,2,1], 'FaceColor', 'white')
if ~isempty(notes)   
    text(.025,0.6,['Note:', notes(1), 'Error: ', diffs(1), 'Magnitude:', mags(1)])
end
end