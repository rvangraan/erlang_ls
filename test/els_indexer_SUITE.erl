-module(els_indexer_SUITE).

%% CT Callbacks
-export([ all/0
        , groups/0
        , init_per_suite/1
        , end_per_suite/1
        , init_per_testcase/2
        , end_per_testcase/2
        ]).

%% Test cases
-export([ index_erl_file/1
        , index_hrl_file/1
        , skip_unkown_extension/1
        ]).

%%==============================================================================
%% Includes
%%==============================================================================
-include_lib("common_test/include/ct.hrl").
-include_lib("stdlib/include/assert.hrl").

%%==============================================================================
%% Types
%%==============================================================================
-type config() :: [{atom(), any()}].

%%==============================================================================
%% CT Callbacks
%%==============================================================================
-spec all() -> [atom()].
all() ->
  [{group, tcp}, {group, stdio}].

-spec groups() -> [atom()].
groups() ->
  els_test_utils:groups(?MODULE).

-spec init_per_suite(config()) -> config().
init_per_suite(Config) ->
  els_test_utils:init_per_suite(Config).

-spec end_per_suite(config()) -> ok.
end_per_suite(Config) ->
  els_test_utils:end_per_suite(Config).

-spec init_per_testcase(atom(), config()) -> config().
init_per_testcase(TestCase, Config) ->
  els_test_utils:init_per_testcase(TestCase, Config).

-spec end_per_testcase(atom(), config()) -> ok.
end_per_testcase(TestCase, Config) ->
  els_test_utils:end_per_testcase(TestCase, Config).

%%==============================================================================
%% Testcases
%%==============================================================================
-spec index_erl_file(config()) -> ok.
index_erl_file(Config) ->
  DataDir = ?config(data_dir, Config),
  Path = filename:join(list_to_binary(DataDir), "test.erl"),
  {ok, Uri} = els_indexer:index_file(Path, sync),
  {ok, [#{id := test, kind := module}]} = els_dt_document:lookup(Uri),
  ok.

-spec index_hrl_file(config()) -> ok.
index_hrl_file(Config) ->
  DataDir = ?config(data_dir, Config),
  Path = filename:join(list_to_binary(DataDir), "test.hrl"),
  {ok, Uri} = els_indexer:index_file(Path, sync),
  {ok, [#{id := test, kind := header}]} = els_dt_document:lookup(Uri),
  ok.

-spec skip_unkown_extension(config()) -> ok.
skip_unkown_extension(Config) ->
  DataDir = ?config(data_dir, Config),
  Path = filename:join(list_to_binary(DataDir), "test.foo"),
  {ok, Uri} = els_indexer:index_file(Path, sync),
  {ok, []} = els_dt_document:lookup(Uri),
  ok.
