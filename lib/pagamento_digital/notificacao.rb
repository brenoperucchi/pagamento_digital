# encoding: UTF-8

module PagamentoDigital
  class Notificacao

    # Parâmetros vindos do Pagamento Digital
    #
    ATRIBUTOS = {
      :tipo_de_pagamento  => "tipo_pagamento",
      :id_pedido          => "id_pedido",
      :data_transacao     => "data_transacao",
      :status             => "status",
      :cod_status         => "cod_status",
      :id_transacao       => "id_transacao",
      :tipo_de_frete      => "tipo_frete",
      :frete              => "frete"
    }

    # Status do pedido no Pagamento Digital
    #
    STATUS = {
      "Transação em Andamento"  => :andamento,
      "Transação Concluída"     => :concluida,
      "Transação Cancelada"     => :cancelada
    }
    
    # Códigos do status do pedido no Pagamento Digital
    #
    COD_STATUS = {
      0 => :andamento,
      1 => :concluida,
      2 => :cancelada
    }

    # Métodos de pagamento no Pagamento Digital
    #
    TIPO_DE_PAGAMENTO = {
      "Boleto Bancário"                       => :boleto_bancario,
      "Visa"                                  => :visa,
      "Mastercard"                            => :mastercard,
      "American Express"                      => :american_express,
      "Diners"                                => :diners,
      "Aura"                                  => :aura,
      "HiperCard"                             => :hipercard,
      "Transferência OnLine Banco do Brasil"  => :transferencia_banco_do_brasil,
      "Transferência OnLine Bradesco"         => :transferencia_bradesco,
      "Transferência OnLine Itaú"             => :transferencia_itau
    }

    # Hash de parâmetros do Rails
    #
    attr_accessor :params

    # Aguarda o objeto params da requisição atual.
    #
    def initialize(params, token = nil)
      @token = token
      @params = params
    end

    # Retorna a lista de produtos enviada pelo Pagamento Digital.
    # Os valores serão normalizados
    # (conversão de moedas, quantidades serão inteiros)
    #
    # def produtos
      # @produtos ||= begin
        # items = []
# 
        # for i in (1..params["NumItens"].to_i)
          # items << {
            # :id          => params["ProdID_#{i}"],
            # :description => params["ProdDescricao_#{i}"],
            # :quantity    => params["ProdQuantidade_#{i}"].to_i,
            # :price       => to_price(params["ProdValor_#{i}"]),
            # :shipping    => to_price(params["ProdFrete_#{i}"]),
            # :fees        => to_price(params["ProdExtras_#{i}"])
          # }
        # end
# 
        # items
      # end
    # end

    # Retorna o valor do frete.
    # Será convertido para um valor do tipo float.
    #
    def frete
      to_price mapping_for(:frete)
    end

    # Retorna o status do pedido.
    # Será mapeado para a constante STATUS.
    #
    def status
      @status ||= STATUS[mapping_for(:status)]
    end

    # Retorna o código do status do pedido.
    # Será mapeado para a constante COD_STATUS.
    #
    def codigo_do_status
      @codigo_do_status ||= COD_STATUS[mapping_for(:cod_status)]
    end

    # Retorna o tipo de pagamento.
    # Será mapeado para a constante TIPO_DE_PAGAMENTO.
    #
    def tipo_de_pagamento
      @tipo_de_pagamento ||= TIPO_DE_PAGAMENTO[mapping_for(:tipo_de_pagamento)]
    end

    # Converte a data de processamento para um objeto Ruby.
    #
    def data_da_transacao
      @data_da_transacao ||= begin
        groups = *mapping_for(:data_transacao).match(/(\d{2})\/(\d{2})\/(\d{4}) ([\d:]+)/sm)
        Time.parse("#{groups[3]}-#{groups[2]}-#{groups[1]} #{groups[4]}")
      end
    end

    # Retorna as informações do comprador.
    #
    def comprador
      @comprador ||= {
        :nome               => params["cliente_nome"],
        :email              => params["cliente_email"],
        :sexo               => params["cliente_sexo"],
        :data_de_nascimento => params["cliente_data_nascimento"],
        :cpf                => params["cliente_cpf"],
        :rg => {
          :numero           => params["cliente_rg"],
          :data_de_emissao  => params["cliente_data_emissao_rg"],
          :orgao_emissor    => params["cliente_orgao_emissor_rg"],
          :estado_emissor   => params["cliente_estado_emissor_rg"]
        },
        :endereco => {
          :logradouro       => params["cliente_endereco"],
          :complemento      => params["cliente_complemento"],
          :bairro           => params["cliente_bairro"],
          :cidade           => params["cliente_cidade"],
          :estado           => params["cliente_estado"],
          :cep              => params["cliente_cep"]
        }
      }
    end

    def method_missing(method, *args)
      return mapping_for(method) if ATRIBUTOS[method]
      super
    end

    def respond_to?(method, include_private = false)
      return true if ATRIBUTOS[method]
      super
    end

    # Um contêiner para o hash de parâmetros,
    # mapeando o retorno para símbolos.
    #
    def mapping_for(name)
      params[ATRIBUTOS[name]]
    end

    # Retorna todas as propriedades úteis em um único hash único.
    #
    def to_hash
      ATRIBUTOS.inject({}) do |buffer, (name,value)|
        buffer.merge(name => __send__(name))
      end
    end

    private

    # Converte formato de quantidade para float.
    #
    def to_price(amount)
      amount = "0#{amount}" if amount =~ /^\,/
      amount.to_s.gsub(/[^\d]/, "").gsub(/^(\d+)(\d{2})$/, '\1.\2').to_f
    end

  end
end
