function varargout = soundgen(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @soundgen_OpeningFcn, ...
                   'gui_OutputFcn',  @soundgen_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



function build(handles, input)
    fs=20500;  % sampling frequency
    duration=10;
    values=0:1/fs:duration;

    displayRange = 100;

    axes(handles.Individual);
    if strcmp(input,'user-input') == 1 % Generate based upon user input
        s1 = GenerateSound(getFreq(handles.freq1),getAmplitude(handles.Amp1, handles.on1),fs,duration); 
        s2 = GenerateSound(getFreq(handles.freq2),getAmplitude(handles.Amp2, handles.on2),fs,duration);
        s3 = GenerateSound(getFreq(handles.freq3),getAmplitude(handles.Amp3, handles.on3),fs,duration);
        s4 = GenerateSound(getFreq(handles.freq4),getAmplitude(handles.Amp4, handles.on4),fs,duration);
        s5 = GenerateSound(getFreq(handles.freq5),getAmplitude(handles.Amp5, handles.on5),fs,duration);
        sum = s1+s2+s3+s4+s5;

        dr1=getDisplayRange(s1,displayRange);
        dr2=getDisplayRange(s2,displayRange);
        dr3=getDisplayRange(s3,displayRange);
        dr4=getDisplayRange(s4,displayRange);
        dr5=getDisplayRange(s5,displayRange);
        plot (values(1:dr1), s1(1:dr1), values(1:dr2), s2(1:dr2), values(1:dr3), s3(1:dr3), values(1:dr4), s4(1:dr4),values(1:dr5), s5(1:dr5));
    elseif strcmp(input,'square') == 1 % Generate from square wave button press
        toggleAllOff(handles);
        baseFreq = 500;
        
        for i = 1:2:251
            newSound = GenerateSound(baseFreq*i,1/i,fs, duration);
            plot (values(1:displayRange), newSound(1:displayRange));
            hold on;
            if i ~= 1
                sum = sum + newSound;
            else 
                sum = newSound;
            end
        end
        hold off;
    elseif strcmp(input,'triangle') == 1 % Generate from triangle wave press
        toggleAllOff(handles);
        
        baseFreq = 500;
        volumeBoost = 2; % Amount to multiply amplitude by to increase volume
        for i = 1:2:251
            amp = volumeBoost*((-1)^((i-1)/2))/i^2;
            newSound = GenerateSound(baseFreq*i,amp,fs, duration);
            plot (values(1:displayRange), newSound(1:displayRange));
            hold on;
            if i ~= 1
                sum = sum + newSound;
            else
                sum = newSound;
            end
        end
        hold off;
        
    elseif strcmp(input,'sawtooth') == 1 % Sawtooth
        toggleAllOff(handles);
        
        baseFreq = 500;
        for i = 1:125;
            amp = 1/i;
            newSound = GenerateSound(baseFreq*i,amp,fs, duration);
            plot (values(1:displayRange), newSound(1:displayRange));
            hold on;
            if i ~= 1
                sum = sum + newSound;
            else
                sum = newSound;
            end
        end
        hold off;
    else
        toggleAllOff(handles);
        sum = rebuildSound(displayRange, duration);
    end
    
    title('Individual sine waves');
    ylabel('Amplitude(nm)');
    xlabel('Time(s)');

    global player;
    player = audioplayer(sum, fs);
    player.pause();
    player.play();


    axes(handles.Combined);
    plot (values(1:displayRange), sum(1:displayRange));
    title('Sum of sine waves');
    ylabel('Amplitude(nm)');
    xlabel('Time(s)');

    
    axes(handles.Moving);
    maxValue = max(sum);
    minValue = min(sum);
    if maxValue ~= 0 && minValue ~= 0
        maxOutput = maxValue + abs(maxValue/3);
        minOutput = minValue - abs(minValue/3);
        tic
        initialTime = toc;
        for i = 1:500:fs*duration
            while initialTime+i/fs > toc
                pause(.001);
            end
            plot(values(i:i+500), sum(i:i+500));
            axis([i/fs (i+500)/fs minOutput maxOutput]);
            title('Sum of sine waves in real time');
            ylabel('Amplitude(nm)');
            xlabel('Time(s)');
        end
    end


function [a] = GenerateSound( freq, amp, fs, duration)
    values=0:1/fs:duration;
    a=amp*sin(2*pi*freq*values);

function [sum] = rebuildSound(displayRange, t)
    % Generate signal
    fs = 44100;   % sample frequency (Hz)
    values=0:1/fs:t;

    x = audioread('sound.mp3');

    % Perform fft and get values
    y = fft(x);
    n = length(x);          % number of samples
    amp = abs(y)/n;    % amplitude of the DFT
    amp = amp(1:fs/2);
    f = (0:n-1)*(fs/n);     % frequency range
    f = f(1:fs/2);

%     plot(f,amp)
%     xlabel('Frequency')
%     ylabel('amplitude')

    % Turn fft back to signal
    % Find freq
    frequencies(1) = 0;
    amplitudes(1) = 0;
    cutoff = .001;%mean(amp) - abs(mean(amp))/4;
    for i = 1:length(amp)
        if amp(i) > cutoff
            frequencies(length(frequencies)+1) = f(i);
            amplitudes(length(amplitudes)+1) = amp(i);
        end
    end

    % Generate signal
    for i = 2:length(frequencies)
      newSound = GenerateSound(frequencies(i),amplitudes(i),fs, t);
      plot (values(1:displayRange), newSound(1:displayRange));
      hold on;
      if i ~= 2
        sum = sum + newSound;
      else
        sum = newSound;
      end
    end
    hold off;
    sum = sum * 6; % Make sound louder

function [freq] = getFreq(popup)
    switch get(popup,'Value')
        case 1
            freq=32.7;
        case 2
            freq=36.7;
        case 3 
            freq=49.0;
        case 4
            freq=82.4;
        case 5 
            freq=110;
        case 6
            freq=130.8;
        case 7
            freq=349.2;
        case 8 
            freq=440;
        case 9 
            freq=659.3;
        case 10
            freq=1396.9;
        otherwise
            allItems = get(popup,'string');
            selectedIndex = get(popup,'Value');
            freq = str2num(allItems{selectedIndex});
end

function [amp] = getAmplitude(popup, toggle)
    get(popup,'Value');
    allItems = get(popup,'string');
    selectedIndex = get(popup,'Value');
    amp = str2num(allItems{selectedIndex}) * get(toggle,'Value');

function addFreqToPopup(popup)
    current_entries = cellstr(get(popup, 'String'));
    current_entries{end+1} = '500';
    current_entries{end+1} = '1500';
    current_entries{end+1} = '2500';
    current_entries{end+1} = '3500';
    current_entries{end+1} = '4500';
    set(popup, 'String', current_entries);

function addAmplitudeToPopup(popup)
    current_entries = cellstr(get(popup, 'String'));
    for i = 3:2:9
        amp = strcat(num2str((-1)^((i-1)/2)), '/', num2str(i^2));
        current_entries{end+1} = amp;
    end
    set(popup, 'String', current_entries);
    
function toggleAllOff(handles)
    set(handles.on1,'value',0); 
    set(handles.on2,'value',0); 
    set(handles.on3,'value',0); 
    set(handles.on4,'value',0); 
    set(handles.on5,'value',0); 
    
function [dr] = getDisplayRange(s, displayRange)
    if max(s) == 0
        dr = 1;
    else 
        dr = displayRange;
    end
% --- Executes just before soundgen is made visible.
function soundgen_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

addFreqToPopup(handles.freq1);
addFreqToPopup(handles.freq2);
addFreqToPopup(handles.freq3);
addFreqToPopup(handles.freq4);
addFreqToPopup(handles.freq5);
addAmplitudeToPopup(handles.Amp1);
addAmplitudeToPopup(handles.Amp2);
addAmplitudeToPopup(handles.Amp3);
addAmplitudeToPopup(handles.Amp4);
addAmplitudeToPopup(handles.Amp5);

axes(handles.Logo);
imshow('Logo.PNG');


% --- Outputs from this function are returned to the command line.
function varargout = soundgen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in on1.
function on1_Callback(hObject, eventdata, handles)
build(handles, 'user-input');


% --- Executes on selection change in freq1.
function freq1_Callback(hObject, eventdata, handles)
build(handles, 'user-input');


% --- Executes during object creation, after setting all properties.
function freq1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in freq2.
function freq2_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes during object creation, after setting all properties.
function freq2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in freq3.
function freq3_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes during object creation, after setting all properties.
function freq3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in freq4.
function freq4_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes during object creation, after setting all properties.
function freq4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Amp1.
function Amp1_Callback(hObject, eventdata, handles)
build(handles, 'user-input');


% --- Executes during object creation, after setting all properties.
function Amp1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Amp2.
function Amp2_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes during object creation, after setting all properties.
function Amp2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Amp3.
function Amp3_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes during object creation, after setting all properties.
function Amp3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Amp4.
function Amp4_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes during object creation, after setting all properties.
function Amp4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in on2.
function on2_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes on button press in on3.
function on3_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes on button press in on4.
function on4_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes on selection change in freq5.
function freq5_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes during object creation, after setting all properties.
function freq5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Amp5.
function Amp5_Callback(hObject, eventdata, handles)
build(handles, 'user-input');

% --- Executes during object creation, after setting all properties.
function Amp5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Amp5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in on5.
function on5_Callback(hObject, eventdata, handles)
build(handles, 'user-input');


% --- Executes on button press in square.
function square_Callback(hObject, eventdata, handles)
    build(handles, 'square');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in triangle.
function triangle_Callback(hObject, eventdata, handles)
    build(handles, 'triangle');


% --- Executes on button press in sawtooth.
function sawtooth_Callback(hObject, eventdata, handles)
    build(handles, 'sawtooth');


% --- Executes on button press in Sound.
function Sound_Callback(hObject, eventdata, handles)
    build(handles, 'sound');
