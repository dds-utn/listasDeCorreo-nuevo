package ar.correos.de.lista

import org.eclipse.xtend.lib.annotations.Accessors

class Pendiente {
	@Accessors
	Usuario usuario
	
	Mail mail
	
	new(Mail mail, Usuario usuario) {
		this.mail = mail
		this.usuario = usuario
	}
	
}