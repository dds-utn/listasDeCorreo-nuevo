package ar.correos.de.lista

import org.eclipse.xtend.lib.annotations.Accessors

class Usuario {
	
	@Accessors String direccionDeMail
	
	new(String unaDireccion) {
		this.direccionDeMail = unaDireccion
	}
	
}