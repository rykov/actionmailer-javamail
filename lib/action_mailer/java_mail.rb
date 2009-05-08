module ActionMailer
  module JavaMail
    def self.included(base) #:nodoc:
      base.cattr_accessor :javamail_settings
      base.javamail_settings = {}
    end
    
    def perform_delivery_javamail(mail)
      ::JavaMail::Mailer.open(javamail_settings) do |mailer|
        mailer.send_message(mail)
      end
    end
  end
end
