%%%-------------------------------------------------------------------
%%% @copyright (C) 2011-2016, 2600Hz INC
%%% @doc
%%% Handle authn_req messages
%%% @end
%%% @contributors
%%%   James Aimonetti
%%%   Luis Azedo
%%%-------------------------------------------------------------------
-module(ts_authn_req).

-export([init/0
        ,handle_req/2
        ]).

-include("ts.hrl").

-spec init() -> 'ok'.
init() -> 'ok'.

-spec handle_req(kz_json:object(), kz_proplist()) -> 'ok'.
handle_req(JObj, _Props) ->
    'true' = kapi_authn:req_v(JObj),
    _ = kz_util:put_callid(JObj),
    Realm = kz_json:get_value(<<"Auth-Realm">>, JObj, <<"missing.realm">>),
    case kapps_util:get_account_by_realm(Realm) of
        {'ok', AccountId} -> handle_ip_auth(JObj, AccountId);
        _Else -> 'ok'
    end.

-spec handle_ip_auth(kz_json:object(), ne_binary()) -> 'ok'.
handle_ip_auth(JObj, AccountId) ->
    AccountDb = kz_util:format_account_db(AccountId),
    ViewOptions = [{'key', kz_json:get_value(<<"Orig-IP">>, JObj)}],
    case kz_datamgr:get_results(AccountDb, <<"trunkstore/list_by_ip">>, ViewOptions) of
        {'ok', [Server]} ->  authn_reply(JObj, Server, AccountId);
        _Else -> 'ok'
    end.

-spec authn_reply(kz_json:object(), kz_json:object(), ne_binary()) -> 'ok'.
authn_reply(JObj, Server, AccountId) ->
    Category = kz_json:get_value(<<"Event-Category">>, JObj),
    Resp = props:filter_undefined(
             [{<<"Msg-ID">>, kz_json:get_value(<<"Msg-ID">>, JObj)}
             ,{<<"Auth-Password">>, <<"12345">>}
             ,{<<"Auth-Method">>, <<"password">>}
             ,{<<"Expires">>, <<"0">>}
             ,{<<"Custom-Channel-Vars">>, create_ccvs(Server, AccountId)}
              | kz_api:default_headers(Category, <<"authn_resp">>, ?APP_NAME, ?APP_VERSION)
             ]),
    lager:info("sending SIP authentication reply", []),
    kapi_authn:publish_resp(kz_json:get_value(<<"Server-ID">>, JObj), Resp).

-spec create_ccvs(kz_json:object(), ne_binary()) -> kz_proplist().
create_ccvs(Server, AccountId) ->
  kz_json:from_list(
  [{<<"Account-ID">>, AccountId}
   ,{<<"Authorizing-ID">>, kz_json:get_value(<<"id">>, Server)}
   ,{<<"Authorizing-Type">>, <<"sys_info">>}
  ]).
