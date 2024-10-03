-module(reply).
-compile(export_all).

start() ->
	net_adm:ping('a@acer-Altos-P10-F8'),
	net_adm:ping('b@acer-Altos-P10-F8'),
	net_adm:ping('c@acer-Altos-P10-F8').

start_receive() ->
    register(rec, spawn(reply, rec, [])).

rec() ->
    receive
        goodbye ->
            io:format("Goodbye ~b");
        {send_message, Ping_Pid} ->
            flush(),
            Ping_Pid ! rep,
            start_receive()
    end.

% receives a node
start_reply() -> 
    