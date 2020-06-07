function [tmaxmin, ymaxmin, f, sf] = maxmin(tint, yy)
	ic = 0;

	%for loop analisa todos indexs exceto os últimos para não criar erros de overflow
	for i = 1 : numel(tint) - 2

		%Procura máximos ou mínimos no index i+1.
		if (yy(i) < yy(i + 1) && yy(i + 1) > yy(i + 2 )) || (yy(i) > yy(i + 1) && yy(i + 1) < yy(i + 2))
			ic = ic + 1;
			
			tmaxmin(ic) = tint(i + 1);
			ymaxmin(ic) = yy(i + 1);
		end
	end

	%Cálculo do período 
	%mean(diff(t...)) corresponde ao cálculo do tempo médio entre um máximo e mínimo, numa onda períodica, considerasse que este tempo corresponde a metade do periodo
	T = 2* mean(diff(tmaxmin));
	
	%Cálculo do incerteza do período (std = desvio padrão da amostra / dispersão das medidas em torno do valor mais provável). Com isto, obtem-se o Erro padrão
	sT = std(2*diff(tmaxmin)) / sqrt(numel(tmaxmin) - 1);

	f = 60 / T; %Fórmula da frequência em função do período (rpm = rotaçoes em 60 segundos)
	sf = 60 * sT / T ^ 2; %Incerteza da frequência pelo limite superior do erro
end
