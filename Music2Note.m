notes = readtable('notes.csv');
[y,Fs] = audioread('test.m4a');
y = y(4e4:end);
Ts = 1/Fs;
%%
figure
subplot(2,1,1)
plot(y)
hold on
%% moving standard deviation
y_std = movstd(y, 2000);
plot(y_std, 'r')
hold on
%%
y_std_smooth = smoothdata(y_std, 'gaussian', 30000);
plot(y_std_smooth, 'g');
%% find peaks
[peaks_mag, peaks_times] = findpeaks(y_std_smooth);
%% disect signal in between peaks
windows = {};
for p = 1:size(peaks_times)-1
    windows{p} = y(peaks_times(p):peaks_times(p+1));
end
%% visualize windows
subplot(2,1,2)
count = 1;
for i = 1:size(windows, 2)
    plot(count:count+size(windows{i},1)-1, windows{i});
    hold on
    count = count + size(windows{i},1);
end

%%
figure
% signal = windows{6};
signal = y(2.5e5:3.4e5);
sound(signal, Fs)
nfft = length(signal);
nfft2 = 2^nextpow2(nfft);
ff = fft(signal, nfft2);
ff_by2 = ff(1:nfft2/2); %fff
xfft = Fs*(0:nfft2/2-1)/nfft2;
plot(xfft, abs(ff_by2 )) 
xlabel('Frequency (Hz)');
ylabel('amplitude (abs(fft))')

%%
[max_amp, max_index] = max(abs(ff_by2));
max_freq = xfft(max_index);
[min_diff, min_note_index] = min(abs(table2array(notes(:,2))-max_freq));
disp(notes(min_note_index,1))
%% visualize original signal in Time domain
dt = 0:Ts:length(y)*Ts;
dt_signal = dt(1:length(signal));
figure
subplot(2,1,1)
plot(dt_signal, signal)
xlabel('Time (s)');
ylabel('Amplitude');



%%

% %%
% signal = windows{1};
% smooth_signal = smoothdata(signal);
% ham_window = hamming(length(signal), 'periodic');
% % fft1 = fft(signal.*ham_window);
% % fft1 = fft(signal);
% fft1 = fft(smooth_signal);
% fft1_shifted = fftshift(fft1);
% figure
% plot(abs(fft1_shifted ))
% %%
% y_smooth_SG = sgolayfilt(y, 50, 301);
% plot(y_smooth_SG, 'r')
% %%
% thres = 0.2;
% y_thres = y;
% y_thres(y_thres<thres) = 0; 
% plot(y)
% hold on
% plot(y_thres, 'r')
% %%
% w_length = size(y,1)/10;                 % window length
% s = spectrogram(y, w_length);
%     
% %%
% s = spectrogram(y,w_length,0,128,1e3);
% spectrogram(y,w_length,0,128,1e3);
% 
% %%
% y_smooth = smoothdata(y, 'gaussian', 200);
% figure
% plot(y_smooth)
% % findpeaks(y_smooth)
% 
% %%
% cs = load('cob signal.mat');
% S1  = cs.coarse_d(:,1);
% S2  = cs.coarse_d(:,2);
% Fs = cs.fs_d;
% Fn = Fs/2;
% Ts = 1/Fs;
% T  = [0:length(S1)-1]*Ts;
% Wp = [950 1000]/Fn;
% Ws = [0.5 1/0.5].*Wp;
% Rp =  1;
% Rs = 30;
% [n,Wn] = buttord(Wp, Ws, Rp, Rs);
% [b, a] = butter(n, Wn);
% [sos, g] = tf2sos(b, a);
% S1F = filtfilt(sos, g, S1);
% SGS1 = sgolayfilt(abs(S1F), 1, 901);
% figure(1)
% plot(T, S1)
% hold on
% % plot(T, S1F)
% plot(T, SGS1, 'LineWidth',1.3)
% hold off
% grid
% % axis([0.5  1.5    ylim])