extends Node

# new ritual selection
signal ritual_selected (ritual: Array, start: bool)
signal ritual_set(ritual: Array)

signal fetch_databases()
signal refresh_rituals()

signal submit_result(ritual: Array)
signal reset(response_code: int, results:String)

signal api_missing()
signal api_set()