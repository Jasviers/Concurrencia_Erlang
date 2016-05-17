-module(bank).
-export([create_bank/0, new_account/2, withdraw_money/3,deposit_money/3,transfer/4, account/1, new_Bank/1]).

create_bank() ->
	spawn(bank, new_Bank, [accounts]).

new_Bank([Accounts]) ->
	receive
		{new_account,AccountNumber,From}->
			From ! ok,
			register(AccountNumber, spawn(bank, account, [0])),
			new_Bank([Accounts]++AccountNumber);
		{whithdraw, AccountNumber, Quantity, From} ->
			From ! ok,
			AccountNumber ! {whithdraw, Quantity},
			new_Bank([Accounts]);
		{deposit, AccountNumber, Quantity, From} ->
			From ! ok,
			AccountNumber ! {deposit, Quantity},
			new_Bank([Accounts])
	%%transfer, FromAccount, ToAccount, Quantity, From} when list:any(, [accounts]) ->
	%%From ! ok,
	end.

new_account(Bank, AccountNumber)->
	Bank ! {new_account, AccountNumber,self()},
	receive Reply -> Reply end.

withdraw_money(Bank, AccountNumber,Quantity) ->
	Bank ! {whithdraw, AccountNumber, Quantity,self()},
	receive Reply -> Reply end.

deposit_money(Bank, AccountNumber, Quantity) ->
	Bank ! {deposit, AccountNumber, Quantity, self()},
	receive Reply -> Reply end.

transfer(Bank, FromAccount, ToAccount, Quantity) ->
	Bank ! {transfer, FromAccount, ToAccount, Quantity, self()},
	receive Reply -> Reply end.

account(Money) ->
	receive
		{whitdraw, Quantity} when Money > Quantity ->
			account(Money - Quantity);
		{deposit, Quantity} ->
			account(Money + Quantity)
	end.
