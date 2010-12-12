# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  #@@matrix ||= Matrix.new(5,5) #take care this wont work with controller reload
  #@@arduino ||= Arduino.new #take care this wont work with controller reload
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
 # helper_method :matrix
 # 
 # def matrix
 #   @@matrix
 # end

  def arduino
    @@arduino
  end
       
end
