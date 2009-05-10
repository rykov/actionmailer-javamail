= actionmailer-javamail

== DESCRIPTION:

ActionMailer-JavaMail allows the emails to be delivered via the JavaMail library.  This allows to 
expand the capabilities of ActionMailer in the jRuby environment via existing JavaMail capabilities.   

The current capabilities are only implemented to send outgoing email without any support for incoming email.

Action Mailer is the part of the Ruby on Rails framework that's designing email-service layers. 

== FEATURES/PROBLEMS:

* Support for SMTP, SMTPS
* Support for DKIM message signing
* [Untested] Support for using Google App Engine 
* [Problem] No unit tests

== REQUIREMENTS:

* ActionMailer 2.3.2 
* JavaMail libraries in your CLASSPATH  

== INSTALL:

* sudo gem install actionmailer-javamail 

== CONFIGURATION:

In your config/environment.rb, add the following:

  config.gem "actionmailer-javamail", :lib => 'java_mail' if defined?(JRUBY_VERSION)

In one of your config/initializers files, add the following:

  ActionMailer::Base.delivery_method = :javamail
  ActionMailer::Base.javamail_settings = {
    :protocol  => :smtps,
    :address   => 'smtp.gmail.com',
    :port      => 465,
    :domain    => 'mydomain.com',
    :user_name => 'user@gmail.com',
    :password  => 'password',
    :dkim      => { :domain => 'mydomain.com', :selector => 'mysel', :key_file => KEY_FILE_PATH } 
  }

  :protocol  - the possible values are :smtp, :smtps, or :gm. (:gm is the Google App Engine protocol)
  :address   - allows you to use a remote server
  :port      - currently a required option for SMTP port
  :domain    - domain to be specified in HELO command
  :user_name - user_name for server authentication
  :password  - password for server authentication
  :dkim      - (optional) arguments for DKIM signing. Key file needs to be in DER format 

== GOOGLE APP ENGINE:

ActionMailer-JavaMail allows to interface with the Mail API within the Google App Engine.
Below is the simple configuration that you should place in a config/initializers file:

  ActionMailer::Base.delivery_method = :javamail
  ActionMailer::Base.javamail_settings = { :protocol => :gm }

That's it!

== REFERENCES:

  * The gem includes a copy of DKIM message signing library
    http://dkim-javamail.sourceforge.net 

  * The following patch was applied to the library
    http://gist.github.com/108966

== LICENSE:

(The MIT License)

Copyright (c) 2009  Michael Rykov 

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
