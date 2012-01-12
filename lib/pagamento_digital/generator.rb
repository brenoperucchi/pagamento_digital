require "rails/generators/base"

module PagamentoDigital
  class InstallGenerator < ::Rails::Generators::Base
    namespace "pagamento_digital:install"
    source_root File.dirname(__FILE__) + "/../../templates"

    def copy_configuration_file
      copy_file "config.yml", "config/pagamento_digital.yml"
    end
  end
end