package br.com.alura.mvc.estudo.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import br.com.alura.mvc.estudo.model.Pedido;

@Repository
public interface PedidoRepository extends JpaRepository<Pedido, Long> {


}
