const config_path: String = "user://config.cfg"

static func save_config(config: ConfigFile) -> void:
	# Create new ConfigFile object.
	var config = ConfigFile.new()

	# Store some values.
	config.set_value("Player1", "player_name", "Steve")
	config.set_value("Player1", "best_score", 10)
	config.set_value("Player2", "player_name", "V3geta")
	config.set_value("Player2", "best_score", 9001)

	# Save it to a file (overwrite if already exists).
	config.save(config_path)

static func load_config() -> Dictionary:
	var data = {}
	var config = ConfigFile.new()
	
	var err = config.load(config_path)
	
	# If the file didn't load, ignore it.
	if err != OK:
		return data
	
	# Iterate over all sections.
	for section in config.get_sections():
		# Fetch the data for each section.
		var player_name = config.get_value(section, "player_name")
		var player_score = config.get_value(section, "best_score")
		data[player_name] = player_score
	
	return data
