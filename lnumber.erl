-module(lnumber).
-compile(export_all).

start() ->
	spawn(lnumber,lnumber,[{1,1}]).

lnumber({P, Q}) ->
	receive
		{put,N} when (N > P) ->
			lnumber({N,Q});
		{query,Pid} ->
			Pid ! {largest,P},
			lnumber({P,P});
		{statistics,Pid} ->
			Pid ! {P,Q},
			lnumber({P,Q})
	end.

sendNumber(N,Pid) ->
	Pid ! {put,N}.

statistic(Pid)->
	Pid ! {statistics,self()},
	receive
		{P,Q} ->
			io:format("Largest = ~p~n",[P]),
			io:format("Last query = ~p~n",[Q])
	end.

whoLargest(Pid) ->
	Pid ! {query,self()},
	receive
		{largest,P} ->
			io:format("Actually largest = ~p~n",[P])	
	end.
