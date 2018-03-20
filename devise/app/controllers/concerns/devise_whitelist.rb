#exporting white list params
#module has to be named after the file
#For example if named devise_white_list.rb = module DeviseWhiteList
module DeviseWhitelist
  extend ActiveSupport::Concern

  included do
    #Run method "configure_permitted_parameters" if communicating with devise_for
    before_filter :configure_permitted_parameters, if: :devise_controller?
  end

  def configure_permitted_parameters
    #allows name to be passed to "sign_up" page aka /register
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    #allows name to be passed to "account_update" page aka /edit
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

end
