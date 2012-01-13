# encoding: UTF-8

module PagamentoDigital
  class Pedido
    
    # Mapeia todos atributos relacionados ao pagamento que serão adicionados às entradas do formulário.
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

    # Adiciona um novo produto a um pedido do Pagamento Digital
    # Os valores permitidos são:
    # - peso (Opcional. Se for float, será multiplicado por 1000g)
    # - frete (Opcional. Se float, será multiplicado por 100 centavos)
    # - quantidade (Opcional. O padrão é 1)
    # - preco (Obrigatório. Se float, será multiplicado por 100 centavos)
    # - descricao (Obrigatório. Identifica o produto)
    # - id (Obrigatório. Deve corresponder com o produto no seu banco de dados)
    # - taxa (Opcional. Se float, será multiplicado por 100 centavos)
    def <<(opcoes)
      opcoes = {
        :peso => nil,
        :frete => nil,
        :taxa => nil,
        :quantidade => 1
      }.merge(opcoes)

      # converte peso para gramas
      opcoes[:peso] = convert_unit(opcoes[:peso], 1000)

      produtos.push(opcoes)
    end

    def add(opcoes)
      self << opcoes
    end

    private
    def convert_unit(number, unit)
      number = (BigDecimal("#{number}") * unit).to_i unless number.nil? || number.kind_of?(Integer)
      number
    end
  end
end