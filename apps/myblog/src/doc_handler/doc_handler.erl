%% -*- coding: utf-8 -*-
-module(doc_handler).

-define(SAVE_PATH, "apps/myblog/priv/static/view/doc/").

-export([init/2]).

-compile(export_all).

init(Req0, State = ["/i"]) ->
    Req = cowboy_req:reply(200,
			   #{<<"content-type">> =>
				 <<"text/html;charset=UTF-8">>},
			   <<"zzz,你好！"/utf8>>, Req0),
    {ok, Req, State};
init(Req0, State = []) ->
    {<<"multipart">>, <<"form-data">>, _} =
	cowboy_req:parse_header(<<"content-type">>, Req0),
    multipart(Req0),
    Req = cowboy_req:reply(200,
			   #{<<"content-type">> => <<"text/plain">>},
			   <<"Hello world!">>, Req0),
    {ok, Req, State};
init(Req0, State = ["/list"]) ->
    {ok, FileList} = file:list_dir(?SAVE_PATH),
    io:format("fileList:~p~n", [FileList]),
    % FileListString =unicode:characters_to_binary(lists:flatten(FileList)),
    FileNameList = lists:map(fun (E) ->
				     unicode:characters_to_binary(E)
			     end,
			     FileList),
    io:format("FileList=~p~n",
	      [{?MODULE, ?LINE, FileNameList}]),
    Req = cowboy_req:reply(200,
			   #{<<"content-type">> =>
				 <<"text/plain;charset=UTF-8">>},
			   jsx:encode(FileNameList), Req0),
    {ok, Req, State}.

multipart(Req0) ->
    case cowboy_req:read_part(Req0) of
      {ok, Headers, Req1} ->
	  Req = case cow_multipart:form_data(Headers) of
		  {data, FieldName} ->
		      io:format("FieldName=~p~n",
				[{?MODULE, ?LINE, FieldName}]),
		      {ok, _Body, Req2} = cowboy_req:read_part_body(Req1),
		      Req2;
		  {file, _FieldName, Filename, _CType} ->
		      Path = (?SAVE_PATH) ++
			       unicode:characters_to_list(Filename),
		      stream_file(Req1, Path)
		end,
	  multipart(Req);
      {done, Req} -> Req
    end.

stream_file(Req0, Path) ->
    case cowboy_req:read_part_body(Req0) of
      {ok, LastBodyChunk, Req} ->
	  save_file(LastBodyChunk, Path), Req;
      {more, BodyChunk, Req} ->
	  save_file(BodyChunk, Path), stream_file(Req, Path)
    end.

%% save the file
save_file(Binary, Path) ->
    {ok, G} = file:open(Path, [raw, binary, append]),
    file:write(G, Binary),
    file:close(G),
    ok.
