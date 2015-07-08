g_PluginInfo =
{
	Name = "Wasteland",
	Version = 1,
	Date = "2015-07-2",
	Description = "Life is all but spent.",
	
	-- The following members will be documented in greater detail later:
	AdditionalInfo = {},
	Commands = {},
	ConsoleCommands = {
		wasteland = {
			HelpString = "Allows a world to be registered or unregistered as a Wasteland.",
			Subcommands = {
				register = {
					HelpString = "Register a world to be a Wasteland.",
					Handler = WastelandRegisterWorld,
					ParameterCombinations = {
						{
							Params = "name",
							Help = "Registers the world with the specified name as a Wasteland."
						}
					}
				},
				unregister = {}
			}
		}
	},
	Permissions = {},
}