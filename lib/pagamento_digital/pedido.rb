# encoding: UTF-8

module PagamentoDigital
  class Pedido
    
    # Map all billing attributes that will be added as form inputs.
    DADOS_DO_PAGAMENTO = {
      :nome                 => "nome",
      :email                => "email",
      :celular              => "celular",
      :cpf                  => "cpf",
      :sexo                 => "sexo",
      :data_de_nascimento   => "data_nascimento"
    }

    # Lista de produtos adicionados ao pedido
    attr_accessor :produtos

    # Informações do pagamento que serão enviados para o Pagamento Digital
    attr_accessor :pagamento

    # Define o tipo de frete
    attr_accessor :tipo_de_frete

    def initialize(pedido_id = nil)
      limpar!
      self.id = pedido_id
      self.pagamento = {}
    end

    # Define o identificador do pedido. Deve ser um valor
    # único para identificar este pedido na sua aplicação
    def id=(identificador)
      @id = identificador
    end

    # Obtém o identificador do pedido
    def id
      @id
    end

    # Remove todos os produtos do pedido
    def limpar!
      @produtos = []
    end

    # Add a new product to the PagSeguro order
    # The allowed values are:
    # - weight (Optional. If float, will be multiplied by 1000g)
    # - shipping (Optional. If float, will be multiplied by 100 cents)
    # - quantity (Optional. Defaults to 1)
    # - price (Required. If float, will be multiplied by 100 cents)
    # - description (Required. Identifies the product)
    # - id (Required. Should match the product on your database)
    # - fees (Optional. If float, will be multiplied by 100 cents)
    def <<(options)
      options = {
        :weight => nil,
        :shipping => nil,
        :fees => nil,
        :quantity => 1
      }.merge(options)

      # convert shipping to cents
      options[:shipping] = convert_unit(options[:shipping], 100)

      # convert fees to cents
      options[:fees] = convert_unit(options[:fees], 100)

      # convert price to cents
      options[:price] = convert_unit(options[:price], 100)

      # convert weight to grammes
      options[:weight] = convert_unit(options[:weight], 1000)

      produtos.push(options)
    end

    def add(options)
      self << options
    end

    private
    def convert_unit(number, unit)
      number = (BigDecimal("#{number}") * unit).to_i unless number.nil? || number.kind_of?(Integer)
      number
    end
  end
end