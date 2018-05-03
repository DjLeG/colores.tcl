#	\002	Ctrl-b	Negritas-Bold
#
#	\017	Ctrl-o	Texto plano
#
#	\026	Ctrl-r	Video inverso | Italicas en algunos clientes IRC
#
#	\037	Ctrl-u	Subrayado
#
#	\003
#	\003FF
#	\003,BB
#	FF = color de frente, BB = color de fondo
#
#	0-	White			8-	Yellow
#	1-	Black			9-	Light Green
#	2-	Blue			10-	Cyan
#	3-	Green			11-	Light Cyan
#	4-	Light Red		12-	Light Blue
#	5-	Brown			13-	Pink
#	6-	Purple			14-	Grey
#	7-	Orange			15-	Light Grey
#

proc do_ff_color {cc texto} {
	set cst ""
	if {[string index $texto 0] != "\003" || [string index $texto 1] == ","} {
		# texto no tiene su propio color podemos colorearlo
		append cst "\003$cc$texto"
	} else {
		append cst $texto
	}
	set index [string first "\010" $cst]
	while {$index >= 0} {
		if {[string index $texto [expr $index +1]] != "\003"} {
			set cst [string replace $cst $index $index "\003$cc"]
		} else {
			set cst [string replace $cst $index $index ""]
		}
		set index [string first "\010" $cst]
	}
	if {[string index $cst end] != "\010"} {append cst \010}
	return $cst
}

proc bold texto { return "\002$texto\002" }

proc uline texto { return "\037$texto\037" }

foreach {name code} { white 00 black 01 blue 02 green 03 lred 04 brown 05 \
		purple 06 orange 07 yellow 08 lgreen 09 cyan 10 lcyan 11 lblue 12 \
		pink 13 grey 14 lgrey 15} {
	set body "do_ff_color $code \$texto"
	proc $name texto $body
}
