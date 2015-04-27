package ar.correos.de.lista

import ar.correos.de.lista.mailSender.EnviadorDeMail
import ar.correos.de.lista.mailSender.excepciones.CasillaNoExisteException
import ar.correos.de.lista.mailSender.excepciones.ServidorNoRespondeException
import org.junit.Test

import static org.assertj.core.api.Assertions.*
import static org.mockito.Matchers.*
import static org.mockito.Mockito.*

class TestListaDeCorreo {
	
	String direccion1 = "user1@dom.com" 
	
	@Test
	def void testUnaListaSinUsuariosNoMandaMails(){
		
		val enviadorDeMail = mock(EnviadorDeMail)
		val lista = new ListaDeCorreo(enviadorDeMail, newArrayList) 
		
		lista.post(getMail)		
		
		verify(enviadorDeMail, never()).enviar(any(Mail), anyString)
	}
	
	@Test
	def void testLaListaConDosUsuariosLeMandaElMailAAmbos(){
		
		val enviadorDeMail = mock(EnviadorDeMail)
		val direccion2 = "user2@dom.com" 
		
		val usuarios = newArrayList(new Usuario(direccion1), new Usuario(direccion2))
		val mail = getMail
		val lista = new ListaDeCorreo(enviadorDeMail, usuarios) 
		
		lista.post(mail)		
		
		verify(enviadorDeMail).enviar(mail, direccion1)
		verify(enviadorDeMail).enviar(mail, direccion2)
	}
	
	@Test
	def void testCuandoMandoMailAUnaCasillaQueNoExisteLoSacaDeLaLista(){
		
		val enviadorDeMail = mock(EnviadorDeMail)
		doThrow(new CasillaNoExisteException)
			.when(enviadorDeMail)
			.enviar(anyObject, eq("correo@existente.not"))	
			
		val direccion2 = "correo@existente.not" 
		
		val usuarioExistente = new Usuario(direccion1)
		val usuarios = newArrayList(usuarioExistente, new Usuario(direccion2))
		val mail = getMail
		val lista = new ListaDeCorreo(enviadorDeMail, usuarios) 
		
		lista.post(mail)		
		
		verify(enviadorDeMail).enviar(mail, direccion1)
		assertThat(lista.miembros).containsOnly(usuarioExistente)
	}
	
	@Test
	def void testCuandoMandoMailYFallaElServidorPoneEnPendienteAlQueFallo(){
		
		val enviadorDeMail = mock(EnviadorDeMail)
		doThrow(new ServidorNoRespondeException)
			.when(enviadorDeMail)
			.enviar(anyObject, eq("correo@server.not"))	
		val direccion2 = "correo@server.not" 
		
		val usuarioConServerFallido = new Usuario(direccion2)
		val usuarios = newArrayList(usuarioConServerFallido, new Usuario(direccion1))
		val mail = getMail
		val lista = new ListaDeCorreo(enviadorDeMail, usuarios) 
		
		lista.post(mail)		
		
	 	verify(enviadorDeMail).enviar(mail, direccion1)
	 	assertThat(lista.pendientes).hasSize(1)
	 	assertThat(lista.pendientes.get(0).usuario).isEqualTo(usuarioConServerFallido)
	}
	
	@Test
	def void test4(){
		
		val enviadorDeMail = mock(EnviadorDeMail)
		
		
		val mail = getMail
		val lista = new ListaDeCorreo(enviadorDeMail, newArrayList(new Usuario("otraDireccion@quenoExiste.com"))) 
		try {
			lista.post(mail)		
			failBecauseExceptionWasNotThrown(UsuarioNoEstaEnListaException)			
		} catch (UsuarioNoEstaEnListaException ex) {
			verify(enviadorDeMail, never()).enviar(any(Mail), anyString)
		}
		
	}
	
	///// 
	
	def getMail() {
		new Mail(direccion1, "Asunto 1", "este sería el cuerpo del mail. Saludos")
	}
	
}