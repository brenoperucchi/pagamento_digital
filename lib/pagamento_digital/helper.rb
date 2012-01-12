module PagamentoDigital::Helper
  def pagamento_digital_form(pedido, opcoes = {})
    opcoes.reverse_merge!(:submit => "Pagar com Pagamento Digital")
    render :partial => "pagamento_digital/pagamento_digital_form", :locals => {:opcoes => opcoes, :pedido => pedido}
  end
end