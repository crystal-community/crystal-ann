require "../spec_helper"
require "../../config/routes"
require "../../src/helpers/**"
require "../../src/controllers/**"

class Global
  @@response : HTTP::Client::Response?
  @@session : Amber::Router::Session::AbstractStore?
  @@cookies : Amber::Router::Cookies::Store?

  def self.response=(@@response)
  end

  def self.response
    @@response
  end

  def self.cookies(headers = HTTP::Headers.new)
    @@cookies = Amber::Router::Cookies::Store.new
    @@cookies.try &.update(Amber::Router::Cookies::Store.from_headers(headers))
    @@cookies.not_nil!
  end

  def self.session
    @@session ||= Amber::Router::Session::Store.new(cookies).build
  end
end

{% for method in %w(get head post put patch delete) %}
  def {{method.id}}(path, headers : HTTP::Headers? = nil, body : String? = nil)
    request = HTTP::Request.new("{{method.id}}".upcase, path, headers, body)
    request.headers["Content-Type"] = Amber::Router::Params::URL_ENCODED_FORM
    Global.response = process_request request
  end
{% end %}

def process_request(request)
  io = IO::Memory.new
  response = HTTP::Server::Response.new(io)
  context = HTTP::Server::Context.new(request, response)
  context.session = Global.session if Global.session
  context.params["_csrf"] ||= Amber::Pipe::CSRF.token(context).to_s
  main_handler = build_main_handler
  main_handler.call context
  response.close
  io.rewind
  client_response = HTTP::Client::Response.from_io(io, decompress: false)
  Global.response = client_response
end

def build_main_handler
  amber = Amber::Server.settings
  amber.handler.prepare_pipelines
  amber.handler
end

def response
  Global.response.not_nil!
end

def session
  Global.session.not_nil!
end

def login_as(user : User)
  raise ArgumentError.new("user has to be saved") if user.id.nil?

  session["user_id"] = user.id.to_s
end
