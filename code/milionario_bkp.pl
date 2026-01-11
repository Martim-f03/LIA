% ---------------------------------
% --- Quem quer ser Milionario? ---
% ---------------------------------
:- encoding(utf8).
:- dynamic(ajuda_usada/1).      % Para registar as ajudas usadas
:- dynamic(jogador_acertou/0).  % Para registar se o jogador acertou a pergunta
:- dynamic(jogador_errou/0).    % Para registar se o jogador errou a pergunta
:- dynamic(acumulado/1).        % Para registar o valor acumulado pelo jogador
:- dynamic(nivel/1).            % Para registar o nível atual do jogador (pois pode voltar a patamares anteriores)

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
    % Carregar perguntas
    consult('perguntas.pl'),
    % Reset do estado do jogo
    retractall(ajuda_usada(_)),
    retractall(jogador_acertou),
    retractall(jogador_errou),
    retractall(acumulado(_)),
    retractall(nivel(_)),
    assertz(acumulado(0)),
    assertz(nivel(1)),
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
    format('\nPergunta ~w (~w€)\n~w\n', [N, ValorN, Texto]),
    mostrar_opcoes(Opcoes),
    write('\nResposta (A,B,C,D), Ajuda (50/50, Público, Telefone) ou stop do jogo: '),
    % Ler uma linha do utilizador para que possa digitar a opção escolhida (e.g., A ou a), ou Ajuda, ou Stop sem a sintaxe Prolog.
    read_line_to_string(user_input, RawInput),
    % Remover espaços em branco
    normalize_space(string(TrimmedInput), RawInput),
    % Converter para maiúsculas e transformar em átomo para comparações com RCerta
    string_upper(TrimmedInput, UpperString),
    atom_string(UpperAtom, UpperString),
    (   UpperAtom == 'STOP' -> Input = stop;
        UpperAtom == 'AJUDA' -> Input = ajuda;
        Input = UpperAtom
    ),
    processar_jogada(Input, RCerta, N, Acumulado, NovoN, NovoAcumulado, NivelActual),
    (   NovoN == stop -> format('Desistiu de jogar. Terminou o jogo com um total de ~w€.', [Acumulado]);
        ciclo_jogo(NovoN, NovoAcumulado)
    ).

% Parar o jogo
processar_jogada(stop, _, _, Acumulado, stop, Acumulado).

% Usar ajuda
processar_jogada(ajuda, RCerta, N, Acumulado, NovoN, NovoAcumulado, NivelActual) :-
    writeln('Que ajuda pretende usar? (50/50, Público, Telefone)'),
    read_line_to_string(user_input, RawAjuda),
    normalize_space(string(AjudaInput), RawAjuda),
    string_upper(AjudaInput, UpperAjuda),
    ( 
        UpperAjuda = "50/50" -> Ajuda = cinquenta_cinquenta;
        UpperAjuda = "PÚBLICO" -> Ajuda = publico;
        UpperAjuda = "TELEFONE" -> Ajuda = telefone;
        writeln('Ajuda inválida. Tente novamente.'), processar_jogada(ajuda, RCerta, N, Acumulado, NovoN, NovoAcumulado), !
    ),
    (ajuda_usada(Ajuda) -> 
        writeln('Já usou esta ajuda. Tente outra.'), 
        processar_jogada(ajuda, RCerta, N, Acumulado, NovoN, NovoAcumulado), !
    ;
        assertz(ajuda_usada(Ajuda)),
        aplicar_ajuda(Ajuda, RCerta, N)
    ),
    % Após aplicar a ajuda, pedir novamente a resposta
    write('Resposta (A,B,C,D) ou stop do jogo: '),
    read_line_to_string(user_input, RawInput2), 
    normalize_space(string(Input2), RawInput2),
    string_upper(Input2, UpperInput2),
    ( 
        UpperInput2 = "STOP" -> InputFinal = stop;
        atom_string(InputFinal, UpperInput2)
    ),
    processar_jogada(InputFinal, RCerta, N, Acumulado, NovoN, NovoAcumulado).

% Processar resposta correta (aplicando Modus Ponens / Modus Mistaken)
processar_jogada(Resp, RCerta, N, _, NovoN, ValorN, NivelActual) :-
    Resp == RCerta, !,
    assertz(jogador_acertou),
    (conclusao(progresso) -> writeln('Resposta certa! O jogo continua.')),                  % Acertou na resposta
    (conclusao_incorrecta(resposta_certa) -> writeln('Resposta certa! O jogo continua.')),  % Acertou com ajuda?
    retract(jogador_acertou),
    valor_pergunta(N, ValorN),
    assertz(acumulado(ValorN)),
    NovoN is N + 1.

% Processar resposta incorrrecta (aplicando Modus Tollens)
% Numa resposta errada, calcular o patamar assegurado com base nas perguntas já respondidas corretamente,
% reportar o patamar e continuar o jogo, avançando para a próxima pergunta.
processar_jogada(_, _, N, _, NovoN, Patamar, NivelActual) :-
    assertz(jogador_errou),
    (conclusao(nao_resposta_certa) -> write('Resposta errada.')),
    retract(jogador_errou),
    (   retract(acumulado(_)),
        N > 10 -> Patamar = 50000, assertz(acumulado(Patamar)), NivelActual = 10;
        N > 5  -> Patamar = 1000, assertz(acumulado(Patamar)), NivelActual = 5;
        Patamar = 0, assertz(acumulado(Patamar)), NivelActual = 1
    ),
    format(' Desce para o último patamar assegurado de ~w€ e para nível ~w.\n', [Patamar, NivelActual]),
    NovoN is N + 1.

% Patamares
% patamar(N, 50000) :- N > 10, !.
% patamar(N, 1000) :- N > 5, !.
% patamar(_, 0).

% Mostrar opções
mostrar_opcoes([]).
mostrar_opcoes([H|T]) :- writeln(H), mostrar_opcoes(T).