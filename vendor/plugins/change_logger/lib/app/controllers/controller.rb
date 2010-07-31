module ChangeLogger
  module Controller
    
    def self.included(base)
      base.before_filter :set_change_log_activity_info
      base.before_filter :set_change_log_whodunnit
    end
    
    protected
    
    def whodunnit
      logger.info { "* whodunnit: #{current_user.inspect}" }
      current_user rescue nil
    end
    
    private
    
    def set_change_log_activity_info
      ::ChangeLogger.controller_name = controller_path
      ::ChangeLogger.action_name = action_name
    end
    
    def set_change_log_whodunnit
      ::ChangeLogger.whodunnit = whodunnit
    end
  end
end

ActionController::Base.send :include, ChangeLogger::Controller