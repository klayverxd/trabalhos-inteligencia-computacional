// ====== RBF with LEAVE-ONE-OUT ======

clear;
clc;

// base de flores (150x7)
// 0 - 50 -> classe 1
// 51 - 100 -> classe 2
// 101 - 150 -> classe 3
base = fscanfMat('iris_log.dat');

//inputs sem classes (4x150)
dados = base(:, 1:4)';

// normalização zscore **nos atributos**
for i = 1:4
    dados(i, :) = (dados(i, :) - mean(dados(i, :))) / stdev(dados(i, :));
end

// qtd de neurônios ocultos
Q = input("Digite a quantidade de neurônios: ");

acertos = 0;

for count = 1:150
    //===Separação dos dados de treino e teste===
    if count==1 then
        d_teste = dados(:, 1); //(4x1)
        
        d_treino = dados(:, 2:150); //(4x149)
        
        classes_base_sem_teste = base(2:150, 5:7)'; //(3x149)
    end
    
    if count>1 && count<150 then
        d_teste = dados(:, count);
        
        d_treino1 = dados(:, 1:count-1);  //primeira metade
        d_treino2 = dados(:, count+1:150);  //segunda metade
        d_treino=[d_treino1, d_treino2];
        
        classes_base_sem_teste1 = base(1:count-1, 5:7);  //primeira metade(149x3)
        classes_base_sem_teste2 = base(count+1:150, 5:7);  //segunda metade(149x3)
        classes_base_sem_teste=[classes_base_sem_teste1;classes_base_sem_teste2]'; //(3x149)
    end
    
    if count==150 then
        d_teste = dados(:, 150); //(4x1)
        
        d_treino = dados(:, 1:149); //(4x149)
        
        classes_base_sem_teste = base(1:149, 5:7)'; //(3x149)
    end
    
    // p -> qtd de atributos == 4
    // N -> qtd de amostras == 149
    [p N] = size(d_treino);
    
    // p_teste -> qtd de atributos == 4
    // N_teste -> qtd de amostras == 1
    [p_teste N_teste] = size(d_teste);
    
    // Centroides (4xQ)
    C = rand(p, Q, 'normal');
    
    // largura do neurônio
    sigma = 1;
    
    // PESOS
    // quantidade Q de neurônios ocultos por N colunas (Qx149)
    Z = zeros(Q, N);
    // matriz para a amostra de teste (Qx1)
    Z_teste = zeros(Q, N_teste);
    
    for i = 1:N //(1:149)
        for j = 1:Q
            // função de ativação (inputs - centroides)
            v = norm(d_treino(:, i) - C(:, j));
            
            // Função gaussiana
            // cada input passa pelos Q neurônios
            // Q linhas (valores/neuronios) para cada amostra
            Z(j, i) = exp(-(1/2)*v^2);  //para sigma==1
           
            if i==1 then
                // função de ativação teste (inputs - centroides)
                v_teste = norm(d_teste(:, 1) - C(:, j));
                
                Z_teste(j, 1) = exp(-(1/2)*v_teste^2);  //para sigma==1
            end
        end
    end
    
    // matriz de output da camada oculta com o bias
    Zb = [(-1) * ones(1, N); Z];
    
    Zb_teste = [(-1) * ones(1, 1); Z_teste];
    
    // pesos da camada de saída
    // saída esperada (pontência gerada)
    // (3 x Q+1) classes x neuronios+bias
    M = classes_base_sem_teste * Zb' / (Zb * Zb')
    
    // Dados de teste
    D_previsto = M * Zb_teste;
    disp('Previsão da amostra de teste ' + string(count))
    disp(D_previsto)
    
    D_previsto_abs=abs(D_previsto)
    Valor_classe_previsto = max(D_previsto_abs)
    C_previsto=find(D_previsto_abs==Valor_classe_previsto) //classe final
    disp('== obtido ==')
    disp(C_previsto)
    
    classes=base(count, 5:7);
    C_esperado=find(classes==1)
    disp('== esperado ==')
    disp(C_esperado)
    
    if C_previsto == C_esperado then
        acertos = acertos + 1
    end
end
    
porcentagem = (acertos / 150) * 100;

disp('Acertou ' + string(acertos) + ' amostras de 150');
disp('Acurácia ' + string(porcentagem) + '%');










