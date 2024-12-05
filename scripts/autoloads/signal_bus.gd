extends Node

# new ritual selection
signal ritual_selected (ritual: Array, start: bool)
signal ritual_set(ritual: Array)

signal fetch_databases()
signal refresh_rituals()

signal submit_result(ritual: Array)