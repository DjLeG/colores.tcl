#
# 	Declaramos el numero de versión de para que un script pueda
#	detectar que se ha cargado y si la versión es la necesaria
#
set colores_lib_version 110

#	\002	Ctrl-b	Negritas-Bold
#
#	\017	Ctrl-o	Texto plano
#
#	\026	Ctrl-r	Video inverso | Italicas en algunos clientes IRC
#
#	\037	Ctrl-u	Subrayado

#	Proc de formato de negritas
proc bold texto { return "\002$texto\002" }

#	Proc de formato de subrayado
proc uline texto { return "\037$texto\037" }

#	Proc de formato de video inverso
proc invid texto { return "\026$texto\026" }

#
#	Formato de colores IRC
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

#
#	Crea un proc por cada codigo de color mIRC
#
foreach {name code} { white 00 black 01 blue 02 green 03 lred 04 brown 05 \
		purple 06 orange 07 yellow 08 lgreen 09 cyan 10 lcyan 11 lblue 12 \
		pink 13 grey 14 lgrey 15} {
	set body [format {do_ff_color %s {*}$args} $code]
	proc $name args $body
}

#
#	name: do_ff_color
#	@param	string	$cc
#		codigo de color mirc uno o dos caracteres
#	@param	string	$args
#		parametros de entrada a formatear con el color dado en $cc
#		si uno de los parametros no es -nc o -noclose, la cadena de retorno
#		incluira al final un caracter \008 para marcar su final
#	@return string
#		cadena de retorno formateada
#
proc do_ff_color {cc args} {
	set cst ""; set close true
	foreach arg $args {
		if {$arg in {-nc -noclose}} {
			set close false
			continue
		}
		append cst $arg
	}
	if {[string index $cst 0] != "\003"} {
		# text no tiene su propio color podemos colorearlo
		set cst "\003$cc$cst"
	} elseif {[string index $cst 1] == ","} {
		set cst [strinsert $cst 1 "$cc"]
	}
	set index [string first "\010" $cst]
	while {$index >= 0} {
		if {[string index $args [expr $index +1]] != "\003"} {
			set cst [string replace $cst $index $index "\003$cc"]
		} else {
			set cst [string replace $cst $index $index ""]
		}
		set index [string first "\010" $cst]
	}
	if {$close && [string index $cst end] != "\010"} {append cst \010}
	return $cst
}

# Crea un comando chr usando alias y format
interp alias {} chr {} format %c

# Decrementa una variable en una cantidad dada o por defecto en 1
proc decr {nombreVar {decremento 1}} {
	upvar 1 $nombreVar var
	incr var -$decremento
}

# Genera números aleatorios entre dos límites dados.
proc rand_2 {min max} {
	return  [expr {int(rand()*($max-$min+1)+$min)}]
}

# Cambia los caracteres de una frase dada por caracteres ASCii.
proc rr1_coder {text} {
    return [string map -nocase {a ã b ß c © d Ð e ê f ƒ g G h H i î j J k K l £ m M n n ñ Ñ o ø p þ q ¶ r ® s § t T u µ v V w VV x × y ¥ z Z} $text]
}

#loadhelp colores.help

putlog "Cargado colores.tcl correctamente."
