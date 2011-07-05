class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    if params[:locale]
      I18n.locale = params[:locale]
    else 
      I18n.locale = extract_locale_from_accept_language || I18n.default_locale
    end
  end
  
#  def default_url_options
#
#  end

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

  
end
