extends Resource
class_name MachineList

static var machines = {
	"aspersor_basico" : Aspersor.new(
		"Aspersor Basico",
		"",
		load("res://art/Machines/AutoWaterer1.png"),
		1,
		"Water",
		"Pressure"
	),
	"water_tank" : WaterTank.new(
		"Tanque de Agua",
		"",
		load("res://art/Machines/WaterTank.png"),
		1,
		"Water",
		"None",
		20
	)
}
