-module(chat).
-compile(export_all).

% SUBMITTED BY: Beltran, Elysse Samantha T. (2019-01135)
% CMSC 124 S-2L

start() ->
	net_adm:ping('a@Nao'),
	net_adm:ping('d@Nao'),
	net_adm:ping('c@Nao').

% Receives messages and prints them
init_chat() ->
    Name = string:trim(io:get_line("Enter your name: ")),
    register(recMsg, spawn(chat, recMsg, [length(nodes())])),
    sendMsg(Name). % inits the receiver host

sendMsg(Name) ->
    Msg = string:trim(io:get_line(" ")),
    if
        Msg == "bye" -> 
            io:format("bye"),
            spawn(chat, sendMsg2, [Name, Msg, nodes()]);
        true ->
            spawn(chat, sendMsg2, [Name, Msg, nodes()]),
            sendMsg(Name)
    end.

sendMsg2(Name, Msg, [Ping_Pid | Rest]) ->
    if
        Msg == "bye" -> 
            {recMsg, Ping_Pid} ! finished,
            sendMsg2(Name, Msg, Rest);
        true ->
            {recMsg, Ping_Pid} ! {Name, Msg},
            sendMsg2(Name, Msg, Rest)
    end;


sendMsg2(_, _, []) ->
    % reset
    io:format("").


recMsg(0) ->
    io:format("You are now alone~n");

recMsg(Chatters) ->
    receive
        finished ->
            io:format("Someone left the chat.~n"),
            recMsg(Chatters-1);
        {Name, Message} ->
            io:format("~n~s: ~s", [Name, Message]),
            recMsg(Chatters)
    end.