class ApplicationController < ActionController::Base
 	protect_from_forgery
  include SessionsHelper
  include ActivitiesHelper
  include ActivityworksHelper
  include WorksHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end

  def cleanNumbers(params)
    params.values.each do | v |
      v["income"] = v["income"].to_s.delete(",").delete("$").to_f
      v["retail"] = v["retail"].to_s.delete(",").delete("$").to_f
      v["quantity"] = v["quantity"].to_s.delete(",").to_i
      v["sold"] = v["sold"].to_s.delete(",").to_i
    end
    params
  end
  
end
