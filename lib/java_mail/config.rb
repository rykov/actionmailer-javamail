module JavaMail
  class Config
    def initialize(settings = {})
      @settings = settings
      @settings[:protocol] ||= :none
      
      unless [:smtp, :smtps, :none].include?(@settings[:protocol])
        raise JavaMailError.new("Invalid protocol #{@settings[:protocol].to_s}")
      end
    end
    
    def session_properties
      props = java.util.Properties.new()
      return props if @mode == :none
      
      # We only support SMTP (plan and SSL) for now
      props.put('mail.transport.protocol', @settings[:protocol].to_s);
      
      # Let's do the basic mapping for SMTP settings
      session_property_key_map.each_pair do |key, property|
        props.put(property, @settings[key].to_s) if @settings[key]
      end
      
      # Enable authentication and encryption
      props.put('mail.smtp.auth', 'true') if self.auth?
      props.put('mail.smtp.ssl.protocols', 'SSLv3 TLSv1') if @settings[:protocol] == :smtps;
      
      # Debugging
      props.put('mail.debug', 'true') if self.debug?
      
      # Return
      props
    end
    
    def debug?
      @settings[:debug] ? true : false
    end
    
    def dkim?
      @settings[:dkim] && @settings[:dkim][:domain] && @settings[:dkim][:selector] && @settings[:dkim][:key_file]
    end
    
    def auth?
      @settings[:user_name] && @settings[:password]
    end
    
    [:address, :user_name, :password, :port, :dkim].each do |attr|
      self.class_eval "def #{attr.to_s}; @settings[:#{attr}]; end"
    end
  
  protected
    def session_property_key_map
      @@key_map ||= { 
        :address   => 'mail.smtp.host',
        :port      => 'mail.smtp.port',
        :domain    => 'mail.smtp.localhost',
        :user_name => 'mail.smtp.user',
        :enable_starttls_auto => 'mail.smtp.starttls.enable'
      }
    end
  end
end
