:- module(player, [play_sound/1, stop_sound/0]).

:- dynamic current_audio_pid/1.

play_sound(File) :-
    stop_sound,
    detect_os(OS),
    catch(spawn_process(OS, File, PID), E, (print_message(warning, E), fail)),
    assertz(current_audio_pid(PID)).

stop_sound :-
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
    process_create(path(afplay), [File], [process(PID)]).

spawn_process(linux, File, PID) :-
    (   path_exists(aplay) 
    ->  process_create(path(aplay), [File], [process(PID)])
    ;   path_exists(paplay) 
    ->  process_create(path(paplay), [File], [process(PID)])
    ;   fail
    ).

spawn_process(windows, File, PID) :-
    format(atom(Command), 'powershell -c (New-Object Media.SoundPlayer "~w").PlaySync()', [File]),
    process_create(path(powershell), ['-Command', Command], [process(PID)]).

detect_os(windows) :- current_prolog_flag(windows, true), !.
detect_os(mac)     :- current_prolog_flag(apple, true), !.
detect_os(linux)   :- current_prolog_flag(unix, true), !.

path_exists(Cmd) :-
    catch(process_create(path(which), [Cmd], [stdout(null), stderr(null)]), _, fail).