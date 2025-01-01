extends Node
#16/12/24: You now can carry water on the bucket, fill it and use it for the waterers
"""
	TODO: 
	 	-- Make it so you can buy and place the 
			-- waterer 
			-- water tank
		-- Make a subscription fee so you have your water tank refilled every X time
		-- Make a basic pipe system with manual valves
		-- Make it so you can buy and place pipes
		-- Make it so you can plug in the pipes to the specific machines
		-- Add the autowaterer with pressure
		Make the humidity checkers
			One that you can place on the tile and shows when you on it
			One that checks current tile with E
			One that you place on the tile and you can use a device to show all checkers
		Add a wire and a processor, you can plug in a humidity sensor if it's more than X it sends TRUE
		Add an automatic valve, you can choose if open the valve with TRUE or FALSE

		-- Add time to the tasks, it's stupid otherwise
		-- Now you can automate proper watering!!! Pre-Alfa 0.3 --

		QOL STUFF:
		Fix the right hotbar
		Sell item on hand button (left click left bar right click right bar)
		The glove can take out the machines, pipes, etc. Pipes have the least pirority with lvl 1, max with lvl 2
		Make the pipes and waterers stackable
		-- More playable Pre-Alfa 0.4 --
		
		
		Make a barebones current system, you pay for it, if you go over budget you get it cut off (you select a plan)
		Make an assembler, you put in plastic bags and seeds, you get full bags to cell
		Make modules for the assembler, you unlock bags with 20 and 30 seeds
		Implement the fuel tank and it's things
		Make the first machine to pick up seeds (fuel)
		Make the first machine to plow (fuel)
		Make the first machine to place seeds (fuel)
		Make the map bigger so you can grow, place the market in the middle
		-- You can almost fully automate the game now! (you only have to fuel and move things around)
		
		Implement something that grabs the seeds from the truck, here's how it should work:
			You plant butterfly flowers, when they grow you have to wait X time and they give you a butterfly,
			that butterly will do the work by itself in this prototype, in the finished game you will be able to command it
	
		-- You only have to buy plastic bags and sell bags with seeds now!
		
		Add a little house you can get in and can buy and move furniture so you have your little home to relax!
		And that's the prototype I guess
"""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
