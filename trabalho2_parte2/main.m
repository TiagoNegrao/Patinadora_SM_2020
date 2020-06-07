%Trabalho realizado por Tiago Negrão nº 92990 e Clara Oliveira nº97848
%Simulação e Modelação - Trabalho 2
%Mestrado Integrado em Engenharia Física
%
%Este é o ficheiro main.m onde ocorre a interpolação dos dados obtidos e o desenho dos respetivos gráficos
%A ordem de utilização deste conjunto de programas segue-se pela seguinte ordem:
%dados.m -> Designar os pontos 
%main.m -> obter os gráficos para as diferentes figuras
%GUI.m -> GUI com todas as informações necessárias
%
%maxmin.m é apenas um ficheiro função que permite descobrir pontos máximos e mínimos como também calcular a frequência de rotação.
%
%Este trabalho é dedicado ao StackOverflow por estar cá quando mais foi preciso...

close all
clear all
clc

figure('Name', 'Gráficos interpolados dos ângulos ou tamanho dx em função do tempo', 'NumberTitle', 'off', 'Position', [10 10 800 600]);

%for loop, um loop por figura
for i = 1 : 4

	%Colocar dados para cada figura
	load(strcat('dados_', num2str(i), '.mat'));

	%definir um conjunto de tempos espaçados uniformemente de forma a obter length(x(:,, 1)) tempos
	t = transpose(linspace(ti, tf, length(x(:, 1))));

	%aumentar o número de tempos de forma a minimizar o erro da curva
	tint = linspace(t(1), t(end), length(t)*2*n);
	
	%para a segunda figura é diferente das restantes
	% spline encontra valores interpolados para os tempos em tint

	if i == 2
		dx = x(:, 1) - x(:, 2);
		yy = spline(t, dx, tint);
		y_axis = 'dx';
	else
		theta = atan2(y(:, 2) - y(:, 1), x(:, 2) - x(:, 1));
		theta = unwrap(theta);
		yy = spline(t, theta, tint);
		y_axis = 'theta';
	end

	%chamar a função	
	[tmaxmin ymaxmin f sf] = maxmin(tint, yy);

	%criar janelas com os plots numa única figura
	subplot(2, 2, i);

	hold on

	%desenhar os pontos maximos e minimos como bolas cyan
	plot(tmaxmin, ymaxmin, 'co');
	plot(tint, yy, 'b');
	
	title(strcat('Figure',  num2str(i)));
	ylabel(y_axis, 'FontSize', 14);
	xlabel('t (s)', 'FontSize', 14);

	tint = tint';
	yy = yy';

	%Criar tabela com dados pertinentes à construção do gráfico 
	T = table(tint, yy);

	%Criar ficheiro .csv para ser utilizado pelo GUI
	writetable(T, strcat('Figura_', num2str(i), '.csv'), 'writerownames', false);

end
