package ar.correos.de.lista.mailSender

import ar.correos.de.lista.Mail

interface EnviadorDeMail {
	def void enviar(Mail mail, String unaDireccion)
}