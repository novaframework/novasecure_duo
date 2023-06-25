-module(novasecure_duo).

-export([callback/1]).

callback(#{json := Json}) ->
    {ok, #{api_hostname := APIHostname,
           factor := Factor}} = application:get_env(novasecure, duo),
    DuoMap = #{<<"factor">> => Factor},
    DuoBody = case Json of
                  #{<<"user_id">> := UserId } -> maps:merge(#{<<"user_id">> => UserId}, DuoMap);
                  #{<<"username">> := Username} -> maps:merge(#{<<"username">> => Username})
              end,
    Url = <<"https://api-", APIHostname/binary, "duosecurity.com">>,
    Json = thoas:encode(DuoBody),
    shttpc:post(Url, DuoBody, #{close => true}).