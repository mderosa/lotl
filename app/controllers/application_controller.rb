class ApplicationController < ActionController::Base
  protect_from_forgery
  include SecurityHelper
  include SslRequirement

  before_filter :set_locale
  before_filter :authenticate

  @default_cache = ActiveSupport::Cache::MemoryStore.new
  @cache
  attr_accessor :cache

  class << self
    attr_accessor :default_cache
  end

  def initialize
    super
    @cache = ApplicationController.default_cache
  end

  def set_locale
    if params[:locale]
      I18n.locale = params[:locale]
    else 
      I18n.locale = extract_locale_from_accept_language || I18n.default_locale
    end
  end
  
 def default_url_options
   {:host => request.host}
 end

  private

  def extract_locale_from_accept_language
      # http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
      if lang = request.env["HTTP_ACCEPT_LANGUAGE"]
        lang = lang.split(",").map { |l|
          l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
          l.split(';q=')
        }.first
        locale = lang.first.split("-").first
      end
  end

  def authenticate
    if not user_authenticated?
      flash[:notice] = t "flash.msg.please-login"
      redirect_to home_path
    end
  end

  
end
