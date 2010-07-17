puts "**** in app/controllers/controller ***"
module ChangeLogger
  module Controller

    def self.included(base)
      base.before_filter :set_change_logger_request_info
      base.before_filter :set_change_logger_whodunnit
    end
   
    protected
    
    def user_for_change_logger
      current_user rescue nil
    end
    
    private
    
    def set_change_logger_request_info
      logger.info { "*** set_change_logger_request_info ***" }
      ::ChangeLogger.controller_name = controller_path
      ::ChangeLogger.action_name = action_name
    end
    
    def set_change_logger_whodunnit
      ::ChangeLogger.whodunnit = user_for_change_logger
    end
  end
end
ActionController::Base.send :include, ChangeLogger::Controller