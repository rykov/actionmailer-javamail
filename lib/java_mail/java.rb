module JavaMail
  module Java
    require 'java' 
    Dir["#{JavaMail::JAVAMAIL_HOME}/ext/**/*.jar"].sort.each {|l| require l}
    include_package "javax.mail"
    include_package "javax.mail.internet"
    include_package "de.agitos.dkim"
  end
end
