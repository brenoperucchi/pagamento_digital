module PagamentoDigital
  class Railtie < Rails::Railtie
    generators do
      require "pagamento_digital/generator"
    end

    # initializer :add_routing_paths do |app|
      # if PagSeguro.developer?
        # app.routes_reloader.paths.unshift(File.dirname(__FILE__) + "/routes.rb")
      # end
    # end

    rake_tasks do
      load File.dirname(__FILE__) + "/../tasks/pagamento_digital.rake"
    end

    initializer "pagamento_digital.initialize" do |app|
      ::ActionView::Base.send(:include, PagamentoDigital::Helper)
      ::ActionController::Base.send(:include, PagamentoDigital::ActionController)
    end

    # config.after_initialize do
      # require "pagseguro/developer_controller" if PagSeguro.developer?
    # end
  end
end