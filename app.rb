require 'sinatra/base'
require 'webrick'
require 'webrick/https'
require 'openssl'

set :bind, '0.0.0.0'
set :port, 8080

CERT_PATH = '/opt/myCA/server/'

webrick_options = {
       :Port               => 8080,
       :Logger             => WEBrick::Log::new($stderr, WEBrick::Log::DEBUG),
       :DocumentRoot       => "/ruby/htdocs",
       :SSLEnable          => true,
       :SSLVerifyClient    => OpenSSL::SSL::VERIFY_NONE,
       :SSLCertificate     => OpenSSL::X509::Certificate.new(  File.open(File.join(CERT_PATH, "healthcheck-https_stg_cloudapps_ao_dcn.crt")).read),
       :SSLPrivateKey      => OpenSSL::PKey::RSA.new(          File.open(File.join(CERT_PATH, "healthcheck-https_stg_cloudapps_ao_dcn.key")).read),
       :SSLCertName        => [ [ "CN",WEBrick::Utils::getservername ] ]
}

class MyServer  < Sinatra::Base
   post '/' do
     "Healthy Yo!!"
   end            
end

Rack::Handler::WEBrick.run MyServer, webrick_options

