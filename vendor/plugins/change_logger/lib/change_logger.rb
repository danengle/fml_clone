require 'app/controllers/controller'
require 'change_logger/has_change_log'
require 'app/models/change_log'
puts "*** inside change_logger.rb ****"
module ChangeLogger
  # attr_accessor :controller_name, :action_name, :whodunnit
  
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

  # Thread-safe hash to hold PaperTrail's data.
  #
  # TODO: is this a memory leak?
  def self.change_logger_store
    Thread.current[:change_log] ||= {}
  end
end

=begin
module ChangeLogger
  # module Model
    def self.included(base)
      puts "**** in self.included(base)"
      base.send :extend, ClassMethods
    end  
  
    module ClassMethods # any method placed here will apply to classes, like Hickwall
      
      def has_change_log(options = {})
        cattr_accessor :controller_name, :action_name, :whodunnit
        puts "***** in def has_change_log *****"
        send :include, InstanceMethods
          
        cattr_accessor :ignore
        self.ignore = (options[:ignore] || []).map &:to_s
        
        has_many :change_logs, :as => :item, :order => 'created_at ASC'
        
        before_update :record_changes
      end
    end
  
    module InstanceMethods # any method placed here will apply to instaces, like @hickwall  
      
      def record_changes
        logger.info { "*** in record_changes" }
        changes = {}
        attributes.delete_if{|k,v| self.class.ignore.include?(k) }.each do |attribute|
          if self.send("#{attribute[0]}_changed?")
            changes["#{attribute[0]}"] = {}
            changes["#{attribute[0]}"]["was"] = self.send("#{attribute[0]}_was")
            changes["#{attribute[0]}"]["is"] = self.send("#{attribute[0]}")
            change_logs.create(:was => changes["#{attribute[0]}"]["was"],
                               :is_now => changes["#{attribute[0]}"]["is"],
                               :action_name => ChangeLogger.action_name,
                               :controller_name => ChangeLogger.controller_name,
                               :whodunnit => ChangeLogger.whodunnit)
          end
        end
      end
    end
  # end
end
=end