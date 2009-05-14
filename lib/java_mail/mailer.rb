module JavaMail
  class Mailer
    def initialize(settings = {})
      @config = JavaMail::Config.new(settings)
      @session = JavaMail::Java::Session.getInstance(@config.session_properties)
      @session.setDebug(@config.debug?)      
      @transport = @session.getTransport
    end
    
    def self.open(settings, &block)
      self.new(settings).open(&block)
    end
    
    def open(&block)
      begin
        open_transport unless transport_ready?
        block.call(self)
      rescue Exception => e
        raise JavaMail::JavaMailError.new(e)
      ensure
        close_transport if transport_ready?
      end 
    end
    
    def send_message(tmail)
      raise JavaMail::JavaMailError.new("JavaMail Transport is not connected") unless transport_ready?
      send_message_to_transport(tmail, @transport)
    end
      
  protected
    def transport_ready?
      @transport && @transport.connected?
    end
  
    def open_transport
      @transport.connect(@config.address, (@config.port || -1).to_i, @config.user_name, @config.password)
    end
    
    def close_transport
      @transport.close
    end
  
    def send_message_to_transport(tmail, transport)
      # Dump TMail into ByteArray
      io_obj = java.io.ByteArrayInputStream.new(tmail.encoded.to_java_bytes)

      # Convert message ByteArray to MimeMessage
      msg = if @config.dkim?
        dkimSigner = JavaMail::Java::DKIMSigner.new(@config.dkim[:domain], @config.dkim[:selector], @config.dkim[:key_file]);
        JavaMail::Java::SMTPDKIMMessage.new(@session, io_obj, dkimSigner);
      else
        JavaMail::Java::MimeMessage.new(@session, io_obj);
      end
      
      # Convert recipients to InternetAddress java array
      recipients = tmail.to_addrs([]).map do |addy| 
        JavaMail::Java::InternetAddress.new(addy.address) 
      end.to_java(JavaMail::Java::InternetAddress)

      # Send message
      transport.sendMessage(msg, recipients)
    end
  end
end
