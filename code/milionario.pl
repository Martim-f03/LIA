% ---------------------------------
% --- Quem quer ser Milionario? ---
% ---------------------------------
:- encoding(utf8).
:- dynamic(ajuda_usada/1).      % Para registar as ajudas usadas
:- dynamic(jogador_acertou/0).  % Para registar se o jogador acertou a pergunta
:- dynamic(jogador_errou/0).    % Para registar se o jogador errou a pergunta
:- consult('perguntas.pl').

% -----------------------------------
% --- Regras de Inferência Lógica ---
% -----------------------------------
% De acordo com o enunciado.
implica(resposta_certa, progresso).

% --------------------
% --- Modus Ponens ---
% --------------------
% Resposta certa -> progresso
verdadeiro(resposta_certa) :- jogador_acertou.
conclusao(progresso) :- 
    implica(resposta_certa, progresso),
    verdadeiro(resposta_certa).

% ---------------------
% --- Modus Tollens ---
% ---------------------
% Não progrediu -> Resposta errada
falso(progresso) :- jogador_errou.
conclusao(nao_resposta_certa) :-
    implica(resposta_certa, progresso),
    falso(progresso).

% ----------------------
% --- Modus Mistaken ---
% ----------------------
% Apesar da resposta errada, ajudas permitem progredir no jogo
verdadeiro(progresso).
conclusao_incorrecta(resposta_certa) :-
    implica(resposta_certa, progresso),
    verdadeiro(progresso).

% ----------------------------------------
% --- Definição de Valores e Patamares ---
% ----------------------------------------
% Numero da pergunta, Valor.
valor_pergunta(1, 100).
valor_pergunta(2, 200).
valor_pergunta(3, 300).
valor_pergunta(4, 500).
valor_pergunta(5, 1000).    % 1º patamar de segurança
valor_pergunta(6, 2000).
valor_pergunta(7, 5000).
valor_pergunta(8, 10000).
valor_pergunta(9, 20000).
valor_pergunta(10, 50000).  % 2º patamar de segurança
valor_pergunta(11, 75000).
valor_pergunta(12, 150000).
valor_pergunta(13, 250000).
valor_pergunta(14, 500000).
valor_pergunta(15, 1000000).

% ------------
% --- Jogo ---
% ------------
jogar :-
    consult('perguntas.pl'),
    retractall(ajuda_usada(_)),
    retractall(jogador_acertou),
    retractall(jogador_errou),
    % Inserir aqui o LogoAsciiArt? Talvez seja melhor incluir no perguntas.pl?
    writeln('--- Bem-Vindo ao Quem Quer Ser Milionário ---'),
    % Inserir aqui o som de ínicio do jogo? 
    % Início do jogo na 1ª pergunta e com 0€ acumulados.
    ciclo_jogo(1, 0).

% Fim do jogo, após 15 perguntas certas consecutivas.
ciclo_jogo(16, _) :- 
    writeln('PARABÉNS! É O NOVO MILIONÁRIO!'),
    % Inserir Ascii Art para festejar o jogador milionário
    % Inserir som para um jogador milionário
    !.

% Jogo
ciclo_jogo(N, Acumulado) :-
    pergunta(N, Texto, Opcoes, RCerta),
    valor_pergunta(N, ValorN),
    format('\n Pergunta ~w (~w€) ---\n~w\n', [N, ValorN, Texto]),
    mostrar_opcoes(Opcoes),
    write('\nResposta (A,B,C,D), Ajuda (50/50, Público, Telefone) ou stop do jogo: '),
    read(Input),
    processar_jogada(Input, RCerta, N, Acumulado, NovoN, NovoAcumulado),
    (   NovoN == erro -> format('Errou! Sai com o patamar de ~w€.\n', [NovoAcumulado]);
        NovoN == stop -> writeln('Desistiu de continuar a jogar.');
        ciclo_jogo(NovoN, NovoAcumulado)
    ).

% Parar o jogo
processar_jogada(stop, _, _, Acumulado, stop, Acumulado).

% Processar resposta correta (aplicando Modus Ponens / Modus Mistaken)
processar_jogada(Resp, RCerta, N, _, NovoN, ValorN) :-
    Resp == RCerta, !,
    assertz(jogador_acertou),
    (conclusao(progresso) -> writeln('Resposta certa! O jogo continua.')),                  % Acertou na resposta
    (conclusao_incorrecta(resposta_certa) -> writeln('Resposta certa! O jogo continua.')),  % Acertou com ajuda?
    retract(jogador_acertou),
    valor_pergunta(N, ValorN),
    NovoN is N + 1.

% Processar resposta incorrrecta (aplicando Modus Tollens)
processar_jogada(_, _, N, _, erro, Patamar) :-
    assertz(jogador_errou),
    (conclusao(nao_resposta_certa) -> writeln('Resposta errada. Desce para o último patamar assegurado.')),
    retract(jogador_errou),
    patamar(N, Patamar).

% Patamares
patamar(N, 50000) :- N > 10, !.
patamar(N, 1000) :- N > 5, !.
patamar(_, 0).

% Mostrar opções
mostrar_opcoes([]).
mostrar_opcoes([H|T]) :- writeln(H), mostrar_opcoes(T).