#########################################################################
#             Felipe Leite Coelho
#           Exemplo - Multivariada: Introdu��o PCA
#########################################################################

#Considere os dados na Tabela 1.1 sobre as medidas(em mm) do corpo de 49
#pardais f�meas, ap�s uma forte tempestade. Em que:
# X1: comprimento total;
# X2: extens�o alar;
# X3: comprimento do bico e cabe�a;
# X4: comprimento do �mero;
# X5: comprimento da quilha do esterno;
# X6: sobreviveu (sob) ou morreu (mor).
#######################################################

rm(list=ls(all=TRUE))
setwd("~/R_felipe/Multivariada 2020")
dados = read.table("dados_pardais.txt",h=T,skip=3)
#dados = read.table(file.choose(),h=T,skip=3)
iden_pardal = dados[,1]
dados = dados[, -1]
#dados = dados[, 2:6]
dados$X6 = factor(c(rep('sob',21),rep('mor',28)))
head(dados,5)
tail(dados,4)
str(dados)
#Estatisticas descritivas
round(apply(dados[,1:5],2,var),4)
round(apply(dados[,1:5],2,mean),4)

#Boxplot
x11()
boxplot(dados[,1:5])

# Coeficiente de varia��o
#media = matrix(0,1,28)
media = variancia = desvio_padrao = coeficiente_variacao = NULL
for(i in 1:5)
{
  media[i] = mean(dados[,i])
  variancia[i] = var(dados[,i])
  desvio_padrao[i] = sqrt(variancia[i])
  coeficiente_variacao[i] = (desvio_padrao[i]/media[i])*100
}
media
variancia
desvio_padrao
coeficiente_variacao #Investigar o coeficiente de varia��o, ideal < 30%?

#Criando uma tabela de resultados
resultado = rbind(media,variancia,desvio_padrao, coeficiente_variacao)
#rownames(resultado)=c(M�dia, Vari�ncia, Desvio padr�o, Coeficiente de varia��o) # nomes das linhas
tabela_resultados = data.frame(resultado)
names(tabela_resultados) = c("X1", "X2", "X3", "X4", "X5")
library(xtable)
xtable(tabela_resultados)

attach(dados)
dados_1 = dados
require(ggplot2)
#require(scatterplot3d)
x11()
qplot(X1, X2, data=dados, colour=X6)

#Extens�o Alar (X2) vs Comprimento total (X1)
x11()
plot(X1[1:21],X2[1:21],xlim=c(150,165),ylim=c(225,255),
     pch=16,xlab="Comprimento Total (mm)",ylab="Extens�o Alar (mm)")
points(X1[22:49],X2[22:49])
legend(150,253,pch=c(16,1),c("Sobrevivente","N�o sobrevivente"),cex=.7)

#Gr�fico 3D considerando as vari�veis, Comprimento do bico e da cabe�a (X3) vs Comprimento total (X1) vs
#Extens�o Alar (X2)
require(scatterplot3d)
x11()
scatterplot3d(X1,X2,X3,highlight.3d=TRUE,pch=16,
              xlim=c(150,165), ylim=c(235,255), zlim=c(31,34),
              xlab="Extens�o Alar", ylab="Comprimento total",
              zlab="Comprimento do bico e cabe�a")
x11()
plot(dados,pch=21,bg=c("red","green"))

#Verificando se existe correla��o
matcor = cor(dados[,-6])
print(matcor, digits = 3)
# Usar o teste de Bartlet para verificar a correla��o
############# Teste de esferecidade de Barttlet ################
# Hip�teses 
# H0: Variaveis s�o n�o correlacionadas, sigma � diagonal
# Ha: 
require(psych)
cortest.bartlett(matcor, n = 48,diag=TRUE)
cortest.bartlett(matcor, n = 48,diag=TRUE)$p.value
# p-value=~0, logo rejeitamos h0 e concluimos que as variaveis s�o correlacionadas
#######################################################

#Padronizando
dados_padro = scale(dados[,-6])
round(apply(dados_padro,2,var),4) 

#Verificando se existe correla��o (dados padronizados)
matcor = var(dados_padro)
print(matcor, digits = 3)
matcor1 = cor(dados[,-6])
print(matcor1, digits = 3)
#gr�ficos de dispers�o
library(lattice)
x11()
splom(dados[,-6], pch = 20, col = "black", xlab = "")

#Usando a matriz de correla��es amostral na an�lise de componentes principais
acpcor = prcomp(dados[,-6], scale = TRUE) # scale = true (padroni) 
acpcor
#acpcor = prcomp(dados_padro, scale = FALSE) #Quando os dados estao padronizados
acpcor$sdev  #sqrt of eigenvalues
acpcor$sdev^2 # eigenvalues
summary(acpcor)

sum(acpcor$sdev^2) #soma tem que ser igual a 5

dados = dados[,-6]
x11()
plot(1:ncol(dados), acpcor$sdev^2, type = "b", xlab = "Componente", ylab = "Vari�ncia", pch = 20, cex.axis = 1.3, cex.lab = 1.3)

x11()
screeplot(acpcor)

x11()
plot(acpcor)

library(factoextra)
x11()
fviz_eig(acpcor)

#Os coeficientes dos componentes principais (os autovetores e1, e2, ..., ep)
#est�o armazenados no componente rotation
names(acpcor)
acpcor$rotation
acpcor$rotation[, 1:2]

x11()
biplot(acpcor, xlab = "CP1", ylab = "CP2",cex.lab = 1.5, cex.axis = 1.5)

#Interpreta��o
# Primeira componente est� relacionada com o tamanho dos pardais
# Segunda componente est� relacionada com a forma dos pardais

#As correla��es entre os dois primeiros componentes principais e as vari�veis s�o estimadas abaixo.
#O primeiro componente tem correla��o forte com todas as vari�veis e o segundo
#tem correla��o amostral baixa
print(acpcor$sdev[1:3] * t(acpcor$rotation[, 1:3]), digits = 3)

acpcor <- prcomp(dados, scale = TRUE, retx = TRUE)

# o primeiro componente principal representa o tamanho dos pardais
escores1 = acpcor$x[, 1]
names(escores1) = iden_pardal
ordem = order(escores1, decreasing = TRUE)
x11()
barplot(escores1[ordem], ylab = "Escore do CP1", las = 2)
box()