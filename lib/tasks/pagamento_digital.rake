# encoding: UTF-8

namespace :pagamento_digital do
  desc "Envia notificação para a URL especificada no arquivo config/pagamento_digital.yml"
  task :notify => :environment do
    PagamentoDigital::Rake.run
  end
end
