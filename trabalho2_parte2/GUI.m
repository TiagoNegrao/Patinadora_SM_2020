function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 06-Jun-2020 02:38:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

clc

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in figuras.
function figuras_Callback(hObject, eventdata, handles)
% hObject    handle to figuras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns figuras contents as cell array
%        contents{get(hObject,'Value')} returns selected item from figuras


% --- Executes during object creation, after setting all properties.
function figuras_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figuras (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [tt, yy] = graf(fig)
	interpol = readtable(strcat('Figura_', num2str(fig), '.csv'));
	
	%PASSAGEM DE TABELA A ARRAY
	x = table2array(interpol);

	tt = x(:, 1); yy = x(:, 2);

% --- Executes on button press in botao.
function botao_Callback(hObject, eventdata, handles)
% hObject    handle to botao (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%obter o número da figura que se pretende estudar
figura = get(handles.figuras, 'Value')

load(strcat('dados_',  num2str(figura), '.mat'));

%limpar plot
axes(handles.grafico);
cla reset;

set(handles.texto, 'String', '');

%obter valores para desenhar gráfico
[tt, yy] = graf(figura);

[tmaxmin, ymaxmin, f, sf] = maxmin(tt, yy);
	
hold (handles.grafico, 'on')
plot(handles.grafico, tt, yy, 'r-')
plot(handles.grafico, tmaxmin, ymaxmin, 'co')

if figura == 2
	ylabel(handles.grafico, 'dx');
else
	ylabel(handles.grafico, 'theta');
end

xlabel(handles.grafico, 't');

axis(handles.grafico, [tt(1), tt(end), min(yy), max(yy)]);

%Passando agora à animação das figuras
mv = VideoReader('video1.mp4');
fps = mv.FrameRate;

n(rem(figura, 2) == 0) = 3;
n(rem(figura, 2) == 1) = 5;

dtframes = n / fps;

ti = tt(1);
tf = tt(end);

t = ti;

i = 0;

axes(handles.video);

while (t <= tf)
	hold(handles.video, 'off');
	mv.CurrentTime = t; mov = readFrame(mv); image(mov);
	t = t + dtframes; i = i + 1;

	hold(handles.video, 'on');
	
	%PLOT DA LINHA VERMELHA QUE CONECTA 2 PONTOS
	plot(handles.video, [x(i, 1), x(i, 2)] , [y(i, 1), y(i, 2)], 'r-', 'LineWidth', 2);

end

%informações gerais (frequẽncia, periodo, frequencia angular e respetivos erros)
%frequencia angular = 2*pi / T rad s-1
%f = ... rpm

w = 2*pi*f / 60;
T = 60 / f;
sT = 60 * sf / f ^ 2;

info = sprintf('Informações relativas à acrobacia: \n \n f = %f +- %f rpm \n Periodo T = %f +- %f s \n frequencia angular w = %f rad s-1', f, sf, T, sT, w);

set(handles.texto, 'String', info);

guidata(hObject, handles);
