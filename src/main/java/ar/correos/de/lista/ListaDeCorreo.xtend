package ar.correos.de.lista

import ar.correos.de.lista.mailSender.EnviadorDeMail
import ar.correos.de.lista.mailSender.excepciones.CasillaLlenaException
import ar.correos.de.lista.mailSender.excepciones.CasillaNoExisteException
import ar.correos.de.lista.mailSender.excepciones.ServidorNoRespondeException
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

class ListaDeCorreo {
	
	@Accessors 
	List<Usuario> miembros
	
	@Accessors 
	List<Pendiente> pendientes = newArrayList()

	EnviadorDeMail enviadorDeMail
	
	new(EnviadorDeMail enviadorDeMail, ArrayList<Usuario> usuarios) {
		this.miembros = usuarios
		this.enviadorDeMail = enviadorDeMail
	}
	
	def post(Mail mail) {
		if (!hayUsuarios) {
			return
		}
		validarExistenciaDeRemitente(mail)
		miembros.clone.forEach[ enviar(mail, it) ]
	}
	
	def hayUsuarios() {
		!miembros.empty
	}
	
	def validarExistenciaDeRemitente(Mail mail) {
		if (! miembros.exists[it.direccionDeMail == mail.origen]) {
			throw new UsuarioNoEstaEnListaException ()
		}
	}
	
	def enviar(Mail mail, Usuario usuario) {
		try{
			enviadorDeMail.enviar(mail, usuario.direccionDeMail)
		} catch(CasillaNoExisteException ex){
			miembros.remove(usuario)
		} catch (CasillaLlenaException ex) {
			//No hago nada por requerimiento
		} catch (ServidorNoRespondeException ex) {
			intentarMasTarde(mail, usuario)
		} 
	}
	
	def intentarMasTarde(Mail mail, Usuario usuario) {
		pendientes.add(new Pendiente(mail, usuario))
	}
}







