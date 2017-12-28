clc
clear all
close all

w = warning ('off','all');

Fs = 44100;
%%
d = daq.getDevices;
dev = d(2);
s = daq.createSession('directsound');
addAudioInputChannel(s, dev.ID, 1);
s.IsContinuous = true;

% setup fft of the live input
%% empty figure
hf = figure;
% ax_text = axes('Position',[0 0 1 1],'Visible','off');
% axis([0 1 0 1])
% ax_main = axes('Position',[.3 .1 .6 .8]);
subplot(1,4,2:4);
hp = plot(zeros(1000,1));
T = title('Discrete FFT Plot');
xlabel('Frequency (Hz)')
ylabel('|FFT|')
grid on;
subplot(1,4,1);
plot(zeros(1,1))


%% background listener
% plotFFT = @(src, event) helper_continuous_fft(event.Data, src.Rate, hp);
% plotFFT = @(src, event) get_notes(event.Data, src.Rate);
plotFFT = @(src, event) plot_notes(event.Data, src.Rate, hp);
hl = addlistener(s, 'DataAvailable', plotFFT);

%% start
startBackground(s);
figure(hf);

%%
ButtonH=uicontrol('Parent',hf,'Style','pushbutton','String','Stop','Units','normalized',...
    'Position',[0.0 0.0 0.05 0.05],'Visible','on',...
    'Callback', {@stopProcess, hl, s});
%%
% pause(10);
% %%
% stop(s);
% s.IsContinuous = false;
% delete(hl);


%% record approach
% recObj = audiorecorder(Fs, 16, 1); %sampleRate, bits, channels (mono)
% disp('Start speaking.')
% recordblocking(recObj, 5);
% disp('End of Recording.');
% % play(recObj);
% audio = getaudiodata(recObj);
% % set(recObj,'TimerPeriod',1,'TimerFcn',{@audioTimer});

function stopProcess(source,event, hl, s)
stop(s);
s.IsContinuous = false;
delete(hl);
end