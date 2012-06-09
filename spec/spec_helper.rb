require 'rubygems'
require 'bundler'
Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'tecepe'


require 'rspec'

module Support
  
  # Forks process and launches a service
  def fork_service(&block)
    begin
      pid = fork do
        trap('TERM') { exit }
        sleep 1
        yield
      end
    ensure
      if pid
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
    end
  end
end