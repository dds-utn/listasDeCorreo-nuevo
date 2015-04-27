package ar.correos.de.lista

import ar.correos.de.lista.mailSender.EnviadorDeMail
import ar.correos.de.lista.mailSender.excepciones.CasillaLlenaException
import ar.correos.de.lista.mailSender.excepciones.CasillaNoExisteException
import ar.correos.de.lista.mailSender.excepciones.ServidorNoRespondeException
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors

class ListaDeCorreo {
	
	List<Usuario> miembros
	
	EnviadorDeMail enviadorDeMail
	
	@Accessors List<Pendiente> pendientes = newArrayList()
	
	new(EnviadorDeMail enviadorDeMail, ArrayList<Usuario> usuarios) {
		this.miembros = usuarios
		this.enviadorDeMail = enviadorDeMail
	}
	
	def post(Mail mail) {
		validarExistenciaDeRemitente(mail)
		miembros.clone.forEach[ enviar(mail, it) ]
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







