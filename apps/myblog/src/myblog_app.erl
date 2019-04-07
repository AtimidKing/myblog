%%%-------------------------------------------------------------------
%% @doc myblog public API
%% @end
%%%-------------------------------------------------------------------

-module(myblog_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([{'_',
				       [{"/up", doc_handler, []},
					{"/d/[...]", cowboy_static,
					 {priv_dir, myblog, "static"}}]}]),
    {ok, _} = cowboy:start_clear(my_http_listener,
				 [{port, 8080}],
				 #{env => #{dispatch => Dispatch}}),
    myblog_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) -> ok.

%%====================================================================
%% Internal functions
%%====================================================================

