require "spec2"
require "http/client/response"

struct RedirectToMatcher
  include Spec2::Matcher

  getter expected : String
  getter actual : String?

  def initialize(@expected : String)
  end

  def match(response : HTTP::Client::Response?)
    @actual = response.try &.headers["Location"]?
    @expected == @actual && response.try &.status_code >= 300
  end

  def failure_message
    <<-MSG
     bad redirect
     \t\t expected to redirect to: "#{expected}"
     \t\t but redirects to:        "#{actual}"
    MSG
  end

  def failure_message_when_negated
    <<-MSG
     bad redirect
     \t\t expected not to redirect to: "#{expected}"
     \t\t but redirects to:            "#{actual}"
    MSG
  end

  def description
    "(should redirect to #{expected_to})"
  end
end

Spec2.register_matcher redirect_to do |url|
  RedirectToMatcher.new url
end
