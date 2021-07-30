function [AA, rr, x] = f_Gauss_Retro_2(A,r)% Subrotina para resolver um sistema de equacoes algebricas lineares% pelo metodo de Gauss com Retrossubstituicao% ULTIMA MODIFICACAO: 05/09/2018n=length(r);[nr,nc]=size(A);% Verificacao da matriz A e do vetor rif nr ~= nc    error('Matriz dos coeficientes nao e quadrada.')    exit;endif nr ~= n    error('Matriz A e vetor r tem dimensoes diferentes.')    exit;end% Verificando se a matriz A e singular (estima o numero de equacees% linearmente independentes)if det(A) == 0    fprintf('\n Rank=%7.3g\n',rank(A))    error('A matriz A e singular.')    exit;end% Metodo de Eliminacao de Gauss com Retrossubstituicao% Etapa de eliminacaofor i = 1:n-1   for j = i+1:n      Mji = A(j,i)/A(i,i);      r(j) = r(j) - Mji*r(i);      A(j,:) = A(j,:) - Mji*A(i,:);    endfor % Fim do for jendfor % Fim do for i       % Etapa de retrossubstituicaox = zeros(n,1);x(n) = r(n)/A(n,n);for i = n-1:-1:1  soma = 0;  for k = i+1:n    soma = soma + A(i,k)*x(k);  endfor % Fim do for k  x(i) = 1/A(i,i)*(r(i) - soma);endfor  % Fim do for i   % Retorna os valores da Nova Matriz A e do Novo Vetor r AA = A; rr = r;