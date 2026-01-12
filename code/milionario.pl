% ---------------------------------
% --- Quem quer ser Milionario? ---
% ---------------------------------
:- encoding(utf8).
:- use_module(library(pcre), [re_replace/4]).
:- use_module(player).
:- dynamic(ajuda_usada/1).      % Para registar as ajudas usadas
:- dynamic(jogador_acertou/0).  % Para registar se o jogador acertou a pergunta
:- dynamic(jogador_errou/0).    % Para registar se o jogador errou a pergunta
:- dynamic(acumulado/1).        % Para registar o valor acumulado pelo jogador
:- dynamic(nivel/1).            % Para registar o nível atual do jogador (pois pode voltar a patamares anteriores)
:- dynamic(level_index/2).      % Contador por nível para escolher perguntas sem repetições (Level,NextIndex)
:- dynamic(plays_done/1).       % Número de perguntas já apresentadas (max 15)

:- discontiguous(conclusao/1).
:- discontiguous(verdadeiro/1).
:- discontiguous(falso/1).

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
% Ajuda torna possível progredir no jogo apesar de resposta errada
verdadeiro(progresso) :- ajuda_usada(_).
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
    display_logo,
    play_sound('music/main-theme.mp3'),
    % Carregar perguntas
    consult('perguntas.pl'),
    % Reset do estado do jogo
    retractall(ajuda_usada(_)),
    retractall(jogador_acertou),
    retractall(jogador_errou),
    retractall(acumulado(_)),
    retractall(nivel(_)),
    retractall(level_index(_,_)),
    retractall(plays_done(_)),
    assertz(acumulado(0)),
    assertz(nivel(1)),
    assertz(plays_done(0)),
    init_level_indices,
    % Inserir aqui o LogoAsciiArt? Talvez seja melhor incluir no perguntas.pl?
    writeln('--- Bem-Vindo ao Quem Quer Ser Milionário ---'),
    % Inserir aqui o som de ínicio do jogo? 
    % Início do jogo na 1ª pergunta e com 0€ acumulados.
    writeln('\nPressione qualquer tecla para iniciar o desafio...'),
    get_single_char(_),
    play_sound('./music/let-s-play.mp3'),
    sleep(5),
    ciclo_jogo(1), !, halt.

% Fim do jogo, após 15 perguntas certas consecutivas.
ciclo_jogo(16) :-
    % Quando 15 perguntas foram completadas, verificar o valor acumulado.
    ( acumulado(Ac) -> true ; Ac = 0 ),
    format_thousands(Ac, FAc),
    ( Ac >= 1000000 ->
        format('PARABÉNS! É O NOVO MILIONÁRIO! Terminou com ~s€.~n', [FAc]);
        format('Fim do jogo. Terminou com ~s€.~n', [FAc])
    ), !, halt.

% Jogo
ciclo_jogo(N) :-
    format(atom(SoundFile), './music/levels/level~w.mp3', [N]),
    play_sound(SoundFile),
    % Se já foram apresentadas 15 perguntas, terminar via ciclo_jogo(16).
    ( plays_done(D), D >= 15 -> ciclo_jogo(16) ; true ),
    % validar índice do nível (questão) e selecionar um índice para esse nível
    ( integer(N), between(1,15,N) -> HintLevel = N ; HintLevel = 1 ),
    % select a question; if none left, end the game
    ( select_question(HintLevel, Level, Index) -> true
    ; acumulado(Ac), format_thousands(Ac, FAcNone), format('Não há mais perguntas disponíveis. Terminou o jogo com ~s€.~n', [FAcNone]), !
    ),
    pergunta(Level, Index, Texto, Opcoes, RCerta),
    valor_pergunta(Level, ValorN),
    % compute displayed question number from plays_done (number of questions already shown)
    ( plays_done(D) -> QNum is D+1 ; QNum = 1 ),
    format_thousands(ValorN, FValor),
    format('\nPergunta ~w (valor ~s€)\n~w\n', [QNum, FValor, Texto]),
    mostrar_opcoes(Opcoes),
    % Ler uma linha do utilizador para que possa digitar a opção escolhida (e.g., A ou a), ou Ajuda, ou Stop sem a sintaxe Prolog.
    read_line_to_string(user_input, RawInput),
    % Remover espaços em branco
    normalize_space(string(TrimmedInput), RawInput),
    % Converter para maiúsculas e transformar em átomo para comparações com RCerta
    string_upper(TrimmedInput, UpperString),
    atom_string(UpperAtom, UpperString),
    (   UpperAtom == 'STOP' -> Input = stop;
        UpperAtom == 'AJUDA' -> Input = ajuda;
        play_sound('./music/final-answer.mp3'),
        sleep(4),
        Input = UpperAtom
    ),
    % incrementar contador de perguntas apresentadas
    ( plays_done(D) -> retract(plays_done(D)), D2 is D+1, assertz(plays_done(D2)) ; assertz(plays_done(1)) ),
    processar_jogada(Input, RCerta, Level, Index, NextLevel),
    (   NextLevel == stop -> acumulado(A), format_thousands(A, FA), format('Desistiu de jogar. Terminou o jogo com um total de ~s€.~n~n', [FA]);
        ciclo_jogo(NextLevel)
    ).

% Parar o jogo
processar_jogada(stop, _, _Q, _Index, stop) :- !.

% Direct help commands typed at main prompt (allow '50/50', 'PUBLICO'/'PÚBLICO', 'TELEFONE')
processar_jogada('50/50', RCerta, Q, Index, NextQ) :- !,
    Ajuda = cinquenta_cinquenta,
    ( ajuda_usada(Ajuda) ->
        writeln('Já usou esta ajuda. Tente outra.'),
        writeln('\nResposta (A,B,C,D) ou Stop do jogo:'),
        write('> '),
        read_line_to_string(user_input, RawInput2), 
        normalize_space(string(Input2), RawInput2),
        string_upper(Input2, UpperInput2),
        ( UpperInput2 = "STOP" -> InputFinal = stop ; atom_string(InputFinal, UpperInput2) ),
        processar_jogada(InputFinal, RCerta, Q, Index, NextQ)
    ; assertz(ajuda_usada(Ajuda)), ( catch(aplicar_ajuda(Ajuda, RCerta, Q), E, (print_message(error,E), writeln('Erro ao aplicar ajuda'))) ; true ),
      writeln('Resposta (A,B,C,D) ou Stop do jogo: '),
      write('> '), 
      read_line_to_string(user_input, RawInput2), 
      normalize_space(string(Input2b), RawInput2),
      string_upper(Input2b, UpperInput2b),
      ( UpperInput2b = "STOP" -> InputFinal2 = stop ; atom_string(InputFinal2, UpperInput2b) ),
      processar_jogada(InputFinal2, RCerta, Q, Index, NextQ)
    ).

processar_jogada('PUBLICO', RCerta, Q, Index, NextQ) :- !,
    Ajuda = publico,
    ( ajuda_usada(Ajuda) ->
        writeln('Já usou esta ajuda. Tente outra.'),
        writeln('Resposta (A,B,C,D) ou Stop do jogo: '),
        write('> '), 
        read_line_to_string(user_input, RawInput2), 
        normalize_space(string(Input2), RawInput2),
        string_upper(Input2, UpperInput2),
        ( UpperInput2 = "STOP" -> InputFinal = stop ; atom_string(InputFinal, UpperInput2) ),
        processar_jogada(InputFinal, RCerta, Q, Index, NextQ)
    ; assertz(ajuda_usada(Ajuda)), ( catch(aplicar_ajuda(Ajuda, RCerta, Q), E, (print_message(error,E), writeln('Erro ao aplicar ajuda'))) ; true ),
      writeln('Resposta (A,B,C,D) ou Stop do jogo: '),
      write('> '), 
      read_line_to_string(user_input, RawInput2), 
      normalize_space(string(Input2b), RawInput2),
      string_upper(Input2b, UpperInput2b),
      ( UpperInput2b = "STOP" -> InputFinal2 = stop ; atom_string(InputFinal2, UpperInput2b) ),
      processar_jogada(InputFinal2, RCerta, Q, Index, NextQ)
    ).

processar_jogada('PÚBLICO', RCerta, Q, Index, NextQ) :- !,
    processar_jogada('PUBLICO', RCerta, Q, Index, NextQ).

processar_jogada('TELEFONE', RCerta, Q, Index, NextQ) :- !,
    Ajuda = telefone,
    ( ajuda_usada(Ajuda) ->
        writeln('Já usou esta ajuda. Tente outra.'),
        writeln('Resposta (A,B,C,D) ou Stop do jogo: '),
        write('> '), 
        read_line_to_string(user_input, RawInput2), 
        normalize_space(string(Input2), RawInput2),
        string_upper(Input2, UpperInput2),
        ( UpperInput2 = "STOP" -> InputFinal = stop ; atom_string(InputFinal, UpperInput2) ),
        processar_jogada(InputFinal, RCerta, Q, Index, NextQ)
    ; assertz(ajuda_usada(Ajuda)), ( catch(aplicar_ajuda(Ajuda, RCerta, Q), E, (print_message(error,E), writeln('Erro ao aplicar ajuda'))) ; true ),
      writeln('Resposta (A,B,C,D) ou Stop do jogo: '),
      write('> '), 
      read_line_to_string(user_input, RawInput2), 
      normalize_space(string(Input2b), RawInput2),
      string_upper(Input2b, UpperInput2b),
      ( UpperInput2b = "STOP" -> InputFinal2 = stop ; atom_string(InputFinal2, UpperInput2b) ),
      processar_jogada(InputFinal2, RCerta, Q, Index, NextQ)
    ).

% Usar ajuda (interactive flow when user types 'AJUDA')
processar_jogada(ajuda, RCerta, Q, Index, NextQ) :-
    writeln('Que ajuda pretende usar? (50/50, Público, Telefone)'),
    read_line_to_string(user_input, RawAjuda),
    normalize_space(string(AjudaInput), RawAjuda),
    string_upper(AjudaInput, UpperAjuda),
    ( UpperAjuda = "50/50" -> Ajuda = cinquenta_cinquenta
    ; UpperAjuda = "PUBLICO" -> Ajuda = publico, play_sound('./music/fastest-finger.mp3')
    ; UpperAjuda = "PÚBLICO" -> Ajuda = publico, play_sound('./music/fastest-finger.mp3')
    ; UpperAjuda = "TELEFONE" -> Ajuda = telefone, play_sound('./music/dialing-numbers.mp3'), sleep(3), play_sound('./music/phone-end.mp3')
    ; writeln('Ajuda inválida. Tente novamente.'), processar_jogada(ajuda, RCerta, Q, Index, NextQ), !
    ),
    ( ajuda_usada(Ajuda) -> writeln('Já usou esta ajuda. Tente outra.'), processar_jogada(ajuda, RCerta, Q, Index, NextQ), !
    ; assertz(ajuda_usada(Ajuda)), ( catch(aplicar_ajuda(Ajuda, RCerta, Q), E, (print_message(error,E), writeln('Erro ao aplicar ajuda'))) ; true )
    ),
    % Após aplicar a ajuda, pedir novamente a resposta
    writeln('Resposta (A,B,C,D) ou Stop do jogo: '),
    write('> '), 
    read_line_to_string(user_input, RawInput2), 
    normalize_space(string(Input2), RawInput2),
    string_upper(Input2, UpperInput2),
    ( UpperInput2 = "STOP" -> InputFinal = stop ; atom_string(InputFinal, UpperInput2) ),
    processar_jogada(InputFinal, RCerta, Q, Index, NextQ).

% Processar resposta correta (aplicando Modus Ponens / Modus Mistaken)
processar_jogada(Resp, RCerta, Q, _Index, NextQ) :-
    Resp == RCerta, !,
    play_sound('./music/correct-answer.mp3'),
    sleep(4),
    % reset any fail counter state (no-op)
    assertz(jogador_acertou),
    % Print success once whether proven by normal modus ponens or by help-driven modus mistaken
    ( once((conclusao(progresso) ; conclusao_incorrecta(resposta_certa))) -> writeln('Resposta certa! O jogo continua.') ; true ),
    retract(jogador_acertou),
    valor_pergunta(Q, ValorQ),
    ( acumulado(Old) -> true ; Old = 0 ),
    NewAcc is Old + ValorQ,
    retractall(acumulado(_)),
    assertz(acumulado(NewAcc)),
    retractall(nivel(_)),
    assertz(nivel(Q)),
    format_thousands(NewAcc, FAcc),
    format('Acumulado atual: ~s€.\n', [FAcc]),
    NextQ is Q + 1.

% Processar resposta incorrrecta (aplicando Modus Tollens)
% Numa resposta errada, calcular o patamar assegurado com base nas perguntas já respondidas corretamente,
% reportar o patamar e continuar o jogo, avançando para a próxima pergunta.
processar_jogada(_, _, Q, _Index, NextQ) :-
    play_sound('./music/wrong-answer.mp3'),
    sleep(4),
    assertz(jogador_errou),
    (conclusao(nao_resposta_certa) -> write('Resposta errada.')),
    retract(jogador_errou),
    M is Q - 1,
    ( M >= 10 -> SafetyQ = 10 ; M >= 5 -> SafetyQ = 5 ; SafetyQ = 0 ),
    ( SafetyQ =:= 0 -> Patamar = 0 ; valor_pergunta(SafetyQ, Patamar) ),
    NextQ is SafetyQ + 1,
    retractall(acumulado(_)), assertz(acumulado(Patamar)),
    retractall(nivel(_)), assertz(nivel(SafetyQ)),
    format_thousands(Patamar, FPat),
    format(' Desce para o último patamar assegurado de ~s€ e nível ~w.\n', [FPat, SafetyQ]).

% Mostrar opções
mostrar_opcoes([]).
mostrar_opcoes([H|T]) :- writeln(H), mostrar_opcoes(T).

% ----- Countadores por nível para evitar repetir perguntas (Level,NextIndex) -----
% Inicializar índices por nível para todos os níveis presentes em perguntas.pl
init_level_indices :-
    findall(L, pergunta(L,_,_,_,_), Ls0),
    sort(Ls0, Ls),
    forall(member(Level, Ls), assertz(level_index(Level, 1))).

% filtrar lista para elementos >= Cur
filter_ge([], _, []).
filter_ge([H|T], Cur, [H|R]) :- H >= Cur, !, filter_ge(T, Cur, R).
filter_ge([_|T], Cur, R) :- filter_ge(T, Cur, R).

% Obter próximo índice válido para um nível e avançar seu contador
get_next_index(Level, Index) :-
    level_index(Level, Cur),
    findall(I, pergunta(Level, I, _, _, _), Is0),
    sort(Is0, Is),
    filter_ge(Is, Cur, IsFiltered),
    IsFiltered \= [],
    nth0(0, IsFiltered, Index),
    Next is Index + 1,
    retract(level_index(Level, Cur)),
    assertz(level_index(Level, Next)).

% Selecionar uma pergunta: preferir o nível sugerido, caso contrário escolher qualquer nível com perguntas restantes
select_question(HintLevel, Level, Index) :-
    ( integer(HintLevel), between(1,15,HintLevel), get_next_index(HintLevel, Index) -> Level = HintLevel
    ; level_index(Other, _), get_next_index(Other, Index), Level = Other
    ).

% -----------------
% --- Ajudas ---
% -----------------
% Helper: extract option letter as an atom from option string like 'A - Texto'
option_letter(Opt, LetterAtom) :-
    % Opt is expected to be a string; take first character and convert to atom
    sub_string(Opt, 0, 1, _, S),
    atom_string(LA, S),
    LetterAtom = LA.

% find options list for a given Level and Index
get_opcoes(Level, Index, Opcoes) :- pergunta(Level, Index, _T, Opcoes, _R).

% 50/50: keep correct and one random incorrect option and print them
aplicar_ajuda(cinquenta_cinquenta, RCerta, Level) :-
        ( pergunta(Level, _, _, Opcoes, RCerta) -> true ; pergunta(Level, _, _, Opcoes, _) ),
        % Build list of option-letter pairs
        findall( letter_opt(LA, Opt), (member(Opt, Opcoes), option_letter(Opt, LA)), Pairs),
        % Separate wrong options (letters not equal to RCerta)
        findall(Opt, (member(letter_opt(LA, Opt), Pairs), LA \= RCerta), WrongList),
        ( WrongList = [] -> writeln('Não foi possível aplicar 50/50.')
        ; random_member(W, WrongList),
            % find the correct option string
            member(letter_opt(RCerta, CorrectOpt), Pairs),
            Two = [CorrectOpt, W],
            writeln('50/50: Mantidas as opções:'), mostrar_opcoes(Two)
        ).

% publico: simulate a distribution with bias towards correct
aplicar_ajuda(publico, RCerta, Level) :-
    ( pergunta(Level, _, _, Opcoes, _) -> true ; pergunta(Level, _, _, Opcoes, _) ),
    % get letters as atoms
    findall(LA, (member(Opt, Opcoes), option_letter(Opt, LA)), Lets),
    ( member(RCerta, Lets) -> true ; nth0(0, Lets, RCerta) ),
    random_between(40,70,CorrectShare),
    Rem is 100 - CorrectShare,
    findall(Lt, (member(Lt, Lets), Lt \= RCerta), Others),
    length(Others, N), N>0,
    split_remaining(Rem, N, Shares),
    writeln('Votos do público:'),
    % print for each letter
    forall(nth0(_I, Lets, L), (
        ( L == RCerta -> S = CorrectShare ; (nth0(J, Others, L), nth0(J, Shares, S)) ),
        format('Opção ~w: ~w%~n', [L, S])
    )).

% telefone: suggest one option with uncertainty
aplicar_ajuda(telefone, RCerta, Level) :-
    ( pergunta(Level, _, _, Opcoes, _) -> true ; pergunta(Level, _, _, Opcoes, _) ),
    % get letters as atoms
    findall(LA, (member(O, Opcoes), option_letter(O, LA)), Lets),
    % decide to be correct with 70% chance
    random_between(1,100,R), (R =< 70 -> Suggested = RCerta ;
        findall(L, (member(L, Lets), L \= RCerta), Ls), random_member(Suggested, Ls)
    ),
    random_between(50,95,Conf),
    format('Telefone sugere: opção ~w ~n', [Suggested]).

% helper: split remaining integer Rem into N parts
split_remaining(Rem, N, Shares) :-
    ( N =:= 1 -> Shares = [Rem]
    ; random_between(0, Rem, H), N1 is N-1, Rem1 is Rem-H, split_remaining(Rem1, N1, Rest), Shares = [H|Rest]
    ).

% Format integer with '.' as thousands separator using PCRE lookahead
format_thousands(Int, Formatted) :-
    integer(Int),
    ( Int < 0 -> Abs is -Int, Sign = '-' ; Abs = Int, Sign = '' ),
    number_string(Abs, S),
    string_chars(S, Chars),
    reverse(Chars, Rev),
    group_chunks(Rev, ChunksRev),
    maplist(reverse, ChunksRev, Chunks),
    maplist(chars_to_string, Chunks, ChunkStringsRev),
    reverse(ChunkStringsRev, ChunkStrings),
    atomic_list_concat(ChunkStrings, '.', Atom),
    string_concat(Sign, Atom, Formatted).

group_chunks([], []).
group_chunks(Rev, [Chunk|Rest]) :-
    length(Rev, L), L > 3,
    length(Chunk, 3), append(Chunk, Tail, Rev),
    group_chunks(Tail, Rest).
group_chunks(Rev, [Rev]) :- Rev \= [].

chars_to_string(Chars, Str) :- string_chars(Str, Chars).

display_logo :-
    exists_file('million.txt'),
    setup_call_cleanup(
        open('million.txt', read, In),
        ( repeat,
          read_line_to_string(In, Str),
          (   Str == end_of_file
          ->  !
          ;   writeln(Str),
              fail
          )
        ),
        close(In)
    ), !.
display_logo :- writeln('--- QUEM QUER SER MILIONÁRIO ---').
