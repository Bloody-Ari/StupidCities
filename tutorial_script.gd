extends Node

@onready var ok_button = $Background/OkButton
@onready var background = $Background
@onready var title  = $Background/Title
@onready var paragraph = $Background/Text
@onready var stage_preparacion = $Background/PreparacionDeLaTierra
@onready var stage_water = $Background/PlantadoRegado
@onready var water_example = $Background/WaterExample
@onready var humidity_checkers_show = $Background/humidity_checkers_show

var stage = 0

func _ready():
	get_tree().paused = true
	
	ok_button.pressed.connect(func():
		match stage:
			0:
				title.text = "Flujo Principal"
				paragraph.text = "El flujo principal del juego consiste en:\n - Preparar la tierra\n - Plantar un girasol\n - Regar a discreción\n - Recolectar las semillas\n - Plantar nuevamente o juntar las semillas en una bolsa y venderlas como un snack"
				stage += 1
			1:
				title.text = "Preparación de la Tierra"
				paragraph.text = "Para preparar la tierra primero deberás utilizar tus guantes para limpiarla de\npasto, malezas y otras flores.\nLuego, podrás utilizar una hoz para hacer un curco donde plantar tus semillas"
				stage_preparacion.visible = true
				stage += 1
			2:
				stage_preparacion.visible = false
				stage_water.visible = true
				title.text = "Plantado y Regado de las Semillas"
				paragraph.text = "Una vez la tierra este lista puedes pararte sobre los surcos y utilizar\nlas semillas con la tecla 'E' para plantar.\nPara regar deberás utilizar la regadera y mantener la humedad del suelo\nen un nivel óptimo. \nMás adelante desbloquearás dispositivos para revisar la húmedad de manera precisa"
				stage += 1
			3:
				stage_water.visible = false
				title.text = "Sistema de regado"
				paragraph.text = "Podés colocar caños y conectarlos entre sí y a aysa para regar más agilmente\nPodes seleccionar un servicio hídrico en la esquina superior izquierda del mapa.\nUna vez seleccionado el plan podés conectar un tanque de agua y válvulas\nUtilizando la tecla 'E' podes activar y desactivar válvulas.\nAdemás el tanque de agua se llena por el lado izquierdo y se drena por el derecho.\nEl regador básico tenés que llenarlo de agua con un balde, el cual llenas en un tanque de agua\ny luego activarlo y desactivarlo utilizando la tecla 'E'\nPor otro lado, el aspersor 2 funciona a presión por lo que es controlable\nmediante una válvula.\nSi necesitás sacar máquinas necesitas tus guantes,\npero los caños podes sacarlos sin herramientas."
				stage+=1
			4:
				water_example.visible = true
				title.text = "Ejemplo de sistema de regado"
				paragraph.text = "Si lo necesitás, podes ver el nivel del agua en el tanque utilizando la tecla 'E'"
				stage+=1
			5:
				water_example.visible = false
				title.text = "Revisar Humedad"
				paragraph.text = "Hay 3 maneras para ver la húmedad de manera precisa:\n1. Este dispositivo se comporta como una máquina, lo colocás en una celda y \n    al pasar sobre ella verás su nivel de humedad\n2. Este dispositivo lo llevas en la mano y utilizas con la tecla 'E' mostrando\n        la casilla y su humedad, esto debes desactivarlo y activarlo\n        si deseas ver la humedad de otra celda.\n3.Este es el sistema más completo y conveniente, deber comprar las máquinas\n    y el control remoto, las máquinas, con forma de antena que se colocan en celdas,\n    luego puedes utilizar el control con la tecla 'E' para ver la humedad de todas las celdas\n    donde alla una de las antenas, sin importar la distancia."
				stage+=1
			6:
				humidity_checkers_show.visible = true
				title.text = "Dispositivos de humedad:"
				paragraph.text = "Acá se muestran los ya mencionados dispositivos en orden, de izquierda a derecha"
				stage += 1
			7:
				humidity_checkers_show.visible = false
				title.text = "Notas sobre Controles"
				paragraph.text = " - Los controles de movimiento son el tradicional WASD.\n - Tenés dos barras de acceso,\n        Seleccionás utilizando 1-0 para la izquierda y Shift + 1-0 para la derecha\n        Para utilizar la herramienta o colocar la máquina debes mantener apretado el click\n        correspondiente a la barra, izquierdo para izquierda, derecho para derecha\n        Esta distinción tambien aplica para vender y, si seleccionas la misma herramienta nuevamente\n        podés quedarte con las manos vacías, útil para sacar caños por ejemplo \n- Algunas cosas tienen interacciones especiales o,\n es posible utilizarlas sin esperar utilizando la tecla 'E'\n - Puedes acceder a un menú básico de pausa utilizando la tecla 'Escape'\nEste es el fin del tutorial, pero esta escena debería ser considerada una zona de pruebas\n ya que como podrás ver en la zona superior izquierda, el dinero no es un problema"
				stage += 1
			8:
				get_tree().paused = false
				background.visible = false
	)
	
	
