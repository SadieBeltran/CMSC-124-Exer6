-module(pingpong).
-compile(export_all).

start() ->
	net_adm:ping('a@acer-Altos-P10-F8'),
	net_adm:ping('b@acer-Altos-P10-F8'),
	net_adm:ping('c@acer-Altos-P10-F8').

start_pong() ->
	register (pong, spawn(pingpong,pong,[])).

pong() ->
	receive
		finished ->
			io:format("Pong finished ~n");
		{Message, Ping_Pid} ->
			io:format("Pong got ping~n"),
			Ping_Pid ! pong
	end.

start_ping([Pong_Node|Next_Node]) ->
	spawn(pingpong, ping, [3,Pong_Node]),
	start_ping(Next_Node);

start_ping([]) ->
	io:format("Finished").

ping(0, Pong_Node) ->
	{pong, Pong_Node} ! finished,
	io:format("Ping finished ~n");
ping(N, Pong_Node) ->
	{pong, Pong_Node} ! {N, self()},
	receive
		pong ->
			io:format("Ping got pong~n")
	end,
	ping(N-1,Pong_Node).