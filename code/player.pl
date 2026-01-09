:- module(audio_player, [play_sound/1, stop_sound/0]).

:- dynamic current_audio_thread/1.

play_sound(File) :-
    stop_sound,
    thread_create(play_sound_internal(File), Id, [detached(true)]),
    assert(current_audio_thread(Id)).

stop_sound :-
    retract(current_audio_thread(Id)), 
    !,
    (   thread_property(Id, status(running))
    ->  thread_signal(Id, abort)
    ;   true
    ).
stop_sound.

play_sound_internal(File) :-
    detect_os(OS),
    catch(play_on_os(OS, File), E, print_message(warning, E)).

detect_os(windows) :- current_prolog_flag(windows, true), !.
detect_os(mac)     :- current_prolog_flag(apple, true), !.
detect_os(linux)   :- current_prolog_flag(unix, true), !.

play_on_os(windows, File) :-
    catch(win_play(File, []), _, fail), !.

play_on_os(windows, File) :-
    format(atom(Command), 'powershell -c (New-Object Media.SoundPlayer "~w").PlaySync()', [File]),
    shell(Command).

play_on_os(mac, File) :-
    process_create(path(afplay), [File], []).

play_on_os(linux, File) :-
    (   path_exists(aplay) -> process_create(path(aplay), [File], [])
    ;   path_exists(paplay) -> process_create(path(paplay), [File], [])
    ;   true
    ).

path_exists(Cmd) :-
    catch(process_create(path(which), [Cmd], [stdout(null)]), _, fail).