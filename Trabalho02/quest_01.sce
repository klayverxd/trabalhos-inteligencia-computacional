// PERCEPTRON

clear;
clc;

dados=[];

//captura da qtd de pontos da 1° classe
qtd_pontos_a = input("Digite a quantidade de pontos da classe 1: ");
dados(1:qtd_pontos_a, 1:4) = 0;

//captura da qtd de pontos da 2° classe
qtd_pontos_b = input("Digite a quantidade de pontos da classe 2: ");
dados(qtd_pontos_a+1 : qtd_pontos_a+qtd_pontos_b, 1:4) = 1;

//adicionando bias
dados(:, 1) = -1;

clc;

disp("===Tabela inicial===");
disp("===Bias | Inputs | Classes===");
disp(dados);

disp('===Digite os pontos da classe 1===')
for count = 1:qtd_pontos_a
    x_ponto = input("Digite a coordenada x do ponto " + string(count) + ": ");
    dados(count, 2) = x_ponto;
    y_ponto = input("Digite a coordenada y do ponto " + string(count) + ": ");
    dados(count, 3) = y_ponto;
end

disp('===Digite os pontos da classe 2===')
for count = 1:qtd_pontos_b
    x_ponto = input("Digite a coordenada x do ponto " + string(count) + ": ");
    dados(qtd_pontos_a + count, 2) = x_ponto;
    y_ponto = input("Digite a coordenada y do ponto " + string(count) + ": ");
    dados(qtd_pontos_a + count, 3) = y_ponto;
end

clc;

disp("===Tabela final===");
disp("===Bias | Inputs | Classes===");
disp(dados)

[linhas, colunas] = size(dados);

//escolha dos pesos aleatoriamente
w = [];
for i = 1:3
    w(i) = rand();
end

count = 1; //índice que percorre as linhas

epocas_input = input("Digite o número de épocas desejada: ");

taxa_aprendizagem = input("Digite o valor da taxa de aprendizagem desejada: ");

for epocas = 1:epocas_input
    x = dados(count, 1:3); //bias e inputs
    saida_esperada = dados(count, 4); //coluna das classes
    
    // somatório
    net = x * w;
    
    //função de ativação
    if net >= 0 then
        net = 1;
    else
        net = 0;
    end
    
    erro = saida_esperada - net;
    
    for i = 1:3
        w(i) = w(i) + taxa_aprendizagem * erro * x(i);
    end
    
    count = count + 1;
    
    if count > linhas then
        count = 1;
    end
    
    disp('---Entrada---');
    disp(x);
    disp('---Esperado---');
    disp(saida_esperada);
    disp('---Obtido---');
    disp(net);
    
    disp('==========================')
end

// PLOTS
x_classe_a = dados(1:qtd_pontos_a, 2);
y_classe_a = dados(1:qtd_pontos_a, 3);

x_classe_b = dados(qtd_pontos_a+1:qtd_pontos_a+qtd_pontos_b, 2);
y_classe_b = dados(qtd_pontos_a+1:qtd_pontos_a+qtd_pontos_b, 3);

//plots por classe
plot(x_classe_a, y_classe_a, 'o')
plot(x_classe_b, y_classe_b, 'x')

// reta divisora
x1 = linspace(-25, 25);
x2 = -((w(2)/w(3))*x1) + ((w(1)/w(3)));
x2_bias  = -((w(1)/w(3))*x1) + ((-1/w(2)));

plot(x1, x2, 'r-');







