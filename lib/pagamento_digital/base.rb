# encoding: UTF-8

module PagamentoDigital
  attr_accessor :token, :email, :return_to
  extend self

  def config_pd
    self.token ||= '9CA8D46AF0C6177CB4C23D76CAF5E4B0'
    self.email ||= 'user@example.com'
    self.return_to ||= 'http://exemplo.com.br/pedido/efetuado'
    @@config = {'authenticity_token'=> self.token, 'email' => self.email, 'return_to' => self.return_to }
  end

  # O Pagamento Digital recebe todos os pedidos nesta URL. Caso o modo desenvolvedor esteja
  # ativado então a URL será /pagamento_digital/checkout
  GATEWAY_URL = "https://www.pagamentodigital.com.br/checkout/pay/"

  # Armazena o conteúdo do arquivo de configuração config/pagamento_digital.yml
  @@config = nil

  # Caminho para o arquivo de configuração
  def config_file
    # Rails.root.join("config/pagamento_digital.yml")
  end

  # Verifica se o arquivo de configuração existe
  def config?
    # File.exist?(config_file)
    true
  end

  # Carrega o arquivo de configuração.
  def config
    # binding.pry
    # raise MissingConfigurationError, "arquivo não encontrado em #{config_file.inspect}" unless config?

    # Carrega arquivo caso o mesmo não esteja carregado
    # @@config ||= YAML.load_file(config_file)

    # Lança uma exceção se o ambiente não foi definidor
    # ou se o arquivo está vazio
    # if @@config == false || !@@config[Rails.env]
    #   raise MissingEnvironmentError, ":ambiente #{Rails.env} não definido em #{config_file.inspect}"
    # end

    # Obtém as configurações do ambiente
    # @@config[Rails.env]
    config_pd
  end

  # A URL apontará para uma URL local caso a aplicação
  # esteja rodando em modo de desenvolvimento
  def gateway_url
    if desenvolvedor?
      "/pagamento_digital"
    else
      GATEWAY_URL
    end
  end

  # Verifica se está com a configuração `desenvolvedor` habilitada
  def desenvolvedor?
    config? && config["desenvolvedor"] == true
  end

  class MissingEnvironmentError < StandardError; end
  class MissingConfigurationError < StandardError; end
end