extends Node

var db;
var dbTour
var to_file = "user://data"
var to_tourFile = "user://tourData"
var to_table = "Data"
# Called when the node enters the scene tree for the first time.
func _ready():
	db = SQLite.new()
	db.path = to_file
	if database_exist(to_file):
		loaddata()
	else:
		normalSetup(db)
	
	dbTour = SQLite.new()
	dbTour.path = to_tourFile
	if database_exist(to_tourFile):
		loaddata()
	else:
		tournamentSetup(dbTour)
		
		
func normalSetup(dbs):
	dbs.open_db()
	dbs.query("CREATE TABLE IF NOT EXISTS Data (
				ID INTEGER PRIMARY KEY AUTOINCREMENT,
				Name TEXT,
				Score INTEGER,
				Time INTEGER,
				Difficulty INTEGER
				);")
	dbs.close_db()
	
func tournamentSetup(dbs):
	dbs.open_db()
	dbs.query("CREATE TABLE IF NOT EXISTS Data (
				ID INTEGER PRIMARY KEY AUTOINCREMENT,
				Name TEXT,
				Score INTEGER,
				Time INTEGER,
				Difficulty INTEGER,
				StudentID TEXT
				);")
	dbs.close_db()

func savedata(nameP,score,curTime,dif):
	db.open_db()
	var data : Dictionary = Dictionary()
	data["Name"] = nameP
	data["Score"] = int(score)
	data["Time"] = snapped(curTime,0.01)
	data["Difficulty"] = dif
	db.insert_row(to_table,data)
	db.close_db()
	
func savedataTournament(nameP,score,curTime,dif,ID):
	db.open_db()
	var data : Dictionary = Dictionary()
	data["Name"] = nameP
	data["Score"] = int(score)
	data["Time"] = snapped(curTime,0.01)
	data["Difficulty"] = dif
	data["StudentID"] = ID
	db.insert_row(to_table,data)
	db.close_db()
	
func loaddata():
	db.open_db()
	db.query("SELECT * FROM Data ORDER BY Score DESC;")
	db.close_db()
	return [db.query_result,db.query_result.size()]

func loadTourData():
	dbTour.open_db()
	dbTour.query("SELECT * FROM Data ORDER BY Score DESC;")
	dbTour.close_db()
	return [db.query_result,db.query_result.size()]
	
func database_exist(path):
	return FileAccess.file_exists(path)
