%w{ models controllers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  ActiveSupport::Dependencies.load_paths << path
  ActiveSupport::Dependencies.load_once_paths.delete(path)
end

module ChangeLogger
  def self.controller_name
    change_logger_store[:controller_name]
  end
  
  def self.controller_name=(value)
    change_logger_store[:controller_name] = value
  end
  
  def self.action_name
    change_logger_store[:action_name]
  end
  
  def self.action_name=(value)
    change_logger_store[:action_name] = value
  end
  
  def self.whodunnit
    change_logger_store[:whodunnit]
  end
  
  def self.whodunnit=(value)
    change_logger_store[:whodunnit] = value
  end
  
  private
  
  def self.change_logger_store
    Thread.current[:change_logger] ||= {}
  end
end

require 'app/controllers/controller'
require 'app/models/change_log'
require 'change_logger/acts_as_change_logger'