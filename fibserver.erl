-module(fibserver).
-compile([export_all]).

fib(1)->
	1;
fib(2)->
	1;
fib(N)->
	fib(N-1)+fib(N-2).


fibserver() ->
	receive
		{fib,N,Pid} ->
			Pid ! {fib,N,is,fib(N)},
			fibserver()
	end.

send(Pid) ->
	receive 
		{fib,N,is,Result}->
			io:format("fib = ~p~n",[Result]),
			Pid ! {fib,random:uniform(15),self()},
			send(Pid)
	end.


empezar(Pid) ->
	Pid ! {fib,10,is,10}.

start() -> 
	spawn(fibserver,fibserver,[]).

start(Pid)->
	spawn(fibserver,send,[Pid]).
