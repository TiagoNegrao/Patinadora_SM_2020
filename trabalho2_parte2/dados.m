clear all
close all
clc

%definir matriz dos tempos iniciais de cada figura
%cada linha corresponde a uma figura
%coluna 1 = ti ; coluna 2 = tf
time = [3.3367, 10.1674; 11.0015, 14; 15.001, 17.0031; 19.3387, 23.3428];

%número de pontos
np = 2;

%ler video para mv e calcular número de frames por segundo
mv = VideoReader('video1.mp4'); 
fps = mv.FrameRate;

%for loop para cada figura individual (1 -> 4)
for fig = 1 : 4
	figure('Name', strcat('Definir pontos frame por frame - Figura ', num2str(fig)), 'NumberTitle', 'off');

	%definir arrays x e y, é necessário para fig > 1 para que o conteúdo seja apagado e não haja confusão entre figuras.
	x = [];
	y = [];

	%valor de n depende se a figura é par ou impar
	n(rem(fig, 2) == 0) = 3;
	n(rem(fig, 2) == 1) = 5;

	%Quantidade temporal (s) correspondente a cada n frames
	dtframes = n / fps;

	ti = time(fig, 1);
	tf = time(fig, 2);

	i = 0; t = ti; %definir o tempo inicial para determinada figura

	%While loop correspondente a cada intervalo temporal
	while (t <= tf)
		
		mv.CurrentTime = t; mov = readFrame(mv); image(mov);
		t = t + dtframes; i = i + 1;

		for ip = 1 : np
			title(strcat('Frame ', num2str(i), 'Ponto ', num2str(ip)));
			[x(i, ip), y(i, ip)] = ginput(1);
		end
	end

	%guardar dados no estilo de dados_(fig).mat para cada figura	
	save(strcat('dados_', num2str(fig),'.mat'), 'n', 'np', 'ti', 'tf', 'x', 'y');

	close
end
