require 'socket'

class WelcomeController < ApplicationController
  def index
    @hostname = Socket.gethostname
    @version = Consts::VERSION
  end
end
