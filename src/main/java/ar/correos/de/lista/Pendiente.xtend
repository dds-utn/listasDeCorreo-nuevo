package ar.correos.de.lista

class Pendiente {
	
	Usuario usuario
	
	Mail mail
	
	new(Mail mail, Usuario usuario) {
		this.mail = mail
		this.usuario = usuario
	}
	
}