-module(ping).
-compile([export_all]).

start()->
	Pid = spawn(ping, pin, []),
	spawn(ping, send, [Pid]);

pin()->
	receive
		{req,Msg,Pid} ->   %% Añadir guarda para comprobrar el Pid
			Pid ! {ack,Msg},
			pin();
		Other ->
			throw(Other)
	end.

send(Pid) ->
	receive
		{ack,Msg} ->
			io:format(Msg),
			send(Pid);
		after 500 ->
                        Pid ! {req, hola, self()},
                        send(Pid)

	end. 
