package ar.correos.de.lista

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Mail {
	
	String origen
	
	String titulo
	
	String texto
	
	new(String unOrigen, String unAsunto, String unCuerpo) {
		origen = unOrigen
		titulo = unAsunto
		texto = unCuerpo
	}
	
}