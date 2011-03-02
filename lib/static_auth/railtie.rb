module StaticAuth
  if defined? Rails::Railtie
    class Railtie < Rails::Railtie
    end
  end
  
  class Railtie
  end
end