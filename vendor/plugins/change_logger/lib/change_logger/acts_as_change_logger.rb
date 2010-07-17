module ChangeLogger
  module ActsAsChangeLogger
    
    def self.included(base)
      base.send :extend, ChangeLogger::ActsAsChangeLogger::ClassMethods
    end
    
    module ClassMethods
      
      def acts_as_change_logger(options = {})
        send :include, InstanceMethods
        
        cattr_accessor :ignore
        self.ignore = (options[:ignore] || []).map &:to_s
        self.ignore.push('created_at', 'updated_at')
        
        has_many :change_logs, :as => :item, :order => 'created_at desc'
        
        before_update :record_changes
      end
    end
    
    module InstanceMethods
      def record_changes
        attributes.delete_if{|k,v| self.class.ignore.include?(k) }.each do |attribute|
          if send("#{attribute[0]}_changed?")
            change_log = change_logs.new(:was => self.send("#{attribute[0]}_was"),
                               :is_now => self.send("#{attribute[0]}"),
                               :action_name => ::ChangeLogger.action_name,
                               :controller_name => ::ChangeLogger.controller_name,
                               :whodunnit => ::ChangeLogger.whodunnit)
            unless change_log.save
              logger.info { "Couldn't save change log: #{change_log.inspect}\nErrors: #{change_log.errors}" }
            end
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send :include, ChangeLogger::ActsAsChangeLogger