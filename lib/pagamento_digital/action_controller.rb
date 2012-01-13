module PagamentoDigital
  module ActionController
    private
    def pagamento_digital_notificacao(token = nil, &block)
      return unless request.post?

      notificacao = PagamentoDigital::Notificacao.new(params, token)
      yield notificacao
    end
  end
end
