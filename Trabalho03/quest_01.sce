// === ALGORITMO GENÉTICO ===

clear;
clc;

// ===== POPULAÇÃO =====
populacao = grand(100, 30, 'uin', 0, 1);  //(100x30)

[individuos, bits] = size(populacao);

// (100xbits+5)
// bits -> bits
// bits+1 -> avaliação
// bits+2 -> valor real x
// bits+3 -> valor real y
// bits+4 -> valor real x no intervalo
// bits+5 -> valor real y no intervalo

geracoes = 50;

tax_mutacao = input("Digite a taxa de mutação desejada: ");

disp("1 -> 1 ponto de corte");
disp("2 -> Cruzamento uniforme");
tipo_cruzamento = input("Digite o tipo de cruzamento desejado: ");

clc;

intervalo_inf = -5;
intervalo_sup = 5;

function[G]=funcao(x,y)
    G = (1-x)^2+100*(y - x^2)^2;
endfunction

// === PLOT DA FUNÇÃO ROSENBROCK ===
quat_pontos = 40;
x1=linspace(intervalo_inf, intervalo_sup, quat_pontos);
y1=linspace(intervalo_inf, intervalo_sup, quat_pontos);
z1=zeros(quat_pontos,quat_pontos)
for k=1:quat_pontos
    for m=1:quat_pontos
        z1(k,m)=funcao(x1(k),y1(m))
    end    
end
graf3d = gcf();
graf3d.color_map = rainbowcolormap(32);

plot3d(x1,y1,z1);

for geracao = 1:geracoes    
    // ===== AVALIAÇÃO =====
    for individuo = 1:individuos
        //individuo_real_x -> converte a primeira metade para real CHECH
        populacao(individuo, bits+2) = bin2dec(strcat(string(populacao(individuo, 1:bits/2))))
        
        //individuo_real_y -> converte a segunta metade para real CHECH
        populacao(individuo, bits+3) = bin2dec(strcat(string(populacao(individuo, (bits/2)+1:bits))))
        
        // inf + (sup-inf / 2^k - 1) * r
        x = intervalo_inf + ((intervalo_sup - intervalo_inf) / (2^(bits/2) - 1)) * populacao(individuo, bits+2);
        y = intervalo_inf + ((intervalo_sup - intervalo_inf) / (2^(bits/2) - 1)) * populacao(individuo, bits+3);
        
        populacao(individuo, bits+4) = x;
        populacao(individuo, bits+5) = y;
        
        avaliacao = funcao(x, y);
        
        populacao(individuo, bits+1) = avaliacao;
    end
    
    // ===== SELEÇÃO =====
    // === Torneio ===
    for i = 1:individuos
        for p = 1:6
            pais_concorrentes(p, :) = populacao(ceil(rand() * individuos), 1:bits+1);
        end
        
        [avaliacao posicao] = min(pais_concorrentes(:, bits+1));
        
        pais(i, :) = pais_concorrentes(posicao(1, 1), 1:bits);
    end

    // ===== CRUZAMENTO =====
    if tipo_cruzamento == 1 then
        // === 1 ponto de corte ===
        for i = 1:2:individuos
            ponto_corte = int(rand() * (bits-1)) + 1;
            
            //Cortando os pais
            // pai de cima
            pai1_metade1 = pais(i, 1:ponto_corte);
            pai1_metade2 = pais(i, ponto_corte+1:bits);
            
            // pai de baixo
            pai2_metade1 = pais(i+1, 1:ponto_corte);
            pai2_metade2 = pais(i+1, ponto_corte+1:bits);
            
            //geração dos filhos
            filhos(i, :) = cat(2, pai1_metade1, pai2_metade2); //2 para juntar nas colunas
            filhos(i+1, :) = cat(2, pai2_metade1, pai1_metade2);
        end
    else
        // === Uniforme ===
        mascara = grand(1, bits, 'uin', 0, 1);
        
        for i = 1:2:individuos
            for bit = 1:bits
                if mascara(1, bit) == 0 then
                    filhos(i, bit) = pais(i, bit); //filho1<-pai1
                    filhos(i+1, bit) = pais(i+1, bit); //filho2<-pai2
                else
                    filhos(i, bit) = pais(i+1, bit); //filho1<-pai2
                    filhos(i+1, bit) = pais(i, bit); //filho2<-pai1
                end
            end
        end
    end
    
    // ===== MUTAÇÃO =====
    for individuo = 1:individuos
        for bit = 1:bits
            prob_mutacao = rand() * 100;
        
            if prob_mutacao < tax_mutacao then
                if filhos(individuo, bit) == 1 then
                    filhos(individuo, bit) = 0;
                else
                    filhos(individuo, bit) = 1;
                end
            end
        end
    end
    
    //capturando o melhor indivíduo da geração corrente
    [melhor_individuo posicao] = min(populacao(:, bits+1));
    minimos(geracao, :) = populacao(posicao(1, 1), :)
    
    avaliacoes(:, geracao) = populacao(:, bits+1);

    todos_x = populacao(:, bits+4);
    todos_y = populacao(:, bits+5);
    
    //PLOTANDO OS INDIVIDUOS
    p=gca();
    r=p.rotation_angles;
    h=scatter3d(todos_x, todos_y, avaliacoes(:, geracao), "fill"); //(x's, y's, avaliações, 'fill')
    a=gca();
    f=gcf();
    f.figure_name='Geração:'+ string(geracao);
    a.rotation_angles = r;
    sleep(100);
    if(~(geracao==geracoes)) then
        delete(h);
    end
    
    if(geracao<>geracoes) then
        populacao = filhos;
    end
end

[minimo posicao] = min(minimos(:, bits+1));
disp('Melhor individuo com valor: ' + string(minimo) + " da geração " + string(posicao));

disp("Valor de X: " + string(minimos(posicao(1, 1), bits+4)));
disp("Valor de Y: " + string(minimos(posicao(1, 1), bits+5)));


























