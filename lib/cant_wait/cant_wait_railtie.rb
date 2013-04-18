class CantWaitRailtie < Rails::Railtie

  initializer 'cant_wait.set_timeout' do
    begin
      database_config = Rails.configuration.database_configuration[Rails.env]
      if (database_config['adapter'].downcase == 'postgresql') && database_config['timeout']
        ActiveRecord::Base.connection.execute "set statement_timeout = #{database_config['timeout']}"
      end
    rescue Exception => e
      puts "\n#{e.message}\n\n"
    end
  end

end
