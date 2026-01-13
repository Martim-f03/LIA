:- module(player, [play_sound/1, stop_sound/0]).

:- dynamic current_audio_pid/1.

play_sound(File) :-
    stop_sound,
    detect_os(OS),
    ( catch(spawn_process(OS, File, PID), E, (print_message(warning, E), fail)) ->
        assertz(current_audio_pid(PID))
    ;
        % Se o início do áudio falhar, não falhar o jogo inteiro — registar e continuar.
        true
    ).

stop_sound :-
    % Try to kill by recorded PID first
    ( current_audio_pid(PID) ->
            ( catch(process_kill(PID, kill), _E,
                    ( detect_os(OS2),
                        ( OS2 == windows ->
                                format(atom(Kcmd), 'taskkill /PID ~w /F >nul 2>&1', [PID]) ;
                                format(atom(Kcmd), 'kill -9 ~w > /dev/null 2>&1', [PID])
                        ),
                        shell(Kcmd)
                    )
                )
            ; true
            ),
            retractall(current_audio_pid(_))
    ; true ),
    % Fallback: attempt to kill known audio player processes by name
    detect_os(OS),
    kill_os_audio(OS),
    retractall(current_audio_pid(_)).

kill_os_audio(mac) :-
    shell('killall afplay > /dev/null 2>&1'), !.
kill_os_audio(linux) :-
    shell('killall aplay > /dev/null 2>&1'),
    shell('killall paplay > /dev/null 2>&1'), !.
kill_os_audio(windows) :-
    shell('taskkill /IM powershell.exe /F >nul 2>&1'), !.
kill_os_audio(_).

spawn_process(mac, File, PID) :-
    process_create(path(afplay), [File], [detached(true), process(PID), stdout(null), stderr(null)]).

spawn_process(linux, File, PID) :-
    (   path_exists(mpv)
    ->  process_create(path(mpv), ['--no-terminal','--really-quiet','--no-video','--hwdec=no','--no-config','--msg-level=all=no', File], [detached(true), process(PID), stdout(null), stderr(null)])
    ;   path_exists(mpg123)
    ->  process_create(path(mpg123), ['-q', File], [detached(true), process(PID), stdout(null), stderr(null)])
    ;   path_exists(ffplay)
    ->  process_create(path(ffplay), ['-nodisp','-autoexit','-loglevel','quiet', File], [detached(true), process(PID), stdout(null), stderr(null)])
    ;   path_exists(paplay)
    ->  process_create(path(paplay), [File], [detached(true), process(PID), stdout(null), stderr(null)])
    ;   path_exists(aplay)
    ->  process_create(path(aplay), [File], [detached(true), process(PID), stdout(null), stderr(null)])
    ;   fail
    ).

spawn_process(windows, File, PID) :-
    % Use non-blocking Play and hide PowerShell window to avoid GUI popping up
    format(atom(Command), 'powershell -WindowStyle Hidden -c (New-Object Media.SoundPlayer "~w").Play()', [File]),
    process_create(path(powershell), ['-Command', Command], [detached(true), process(PID), stdout(null), stderr(null)]).

detect_os(windows) :- current_prolog_flag(windows, true), !.
detect_os(mac)     :- current_prolog_flag(apple, true), !.
detect_os(linux)   :- current_prolog_flag(unix, true), !.

path_exists(Cmd) :-
    catch(process_create(path(which), [Cmd], [stdout(null), stderr(null)]), _, fail).