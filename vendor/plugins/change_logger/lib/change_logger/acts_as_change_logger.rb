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
        
        has_many :change_logs, :as => :item, :order => 'created_at desc'
        
        before_update :record_changes
      end
    end
    
    module InstanceMethods
      def record_changes
        changes = {}
        attributes.delete_if{|k,v| self.class.ignore.include?(k) }.each do |attribute|
          if send("#{attribute[0]}_changed?")
            changes["#{attribute[0]}"] = {}
            changes["#{attribute[0]}"]["was"] = self.send("#{attribute[0]}_was")
            changes["#{attribute[0]}"]["is_now"] = self.send("#{attribute[0]}")
            change_logs.create(:was => changes["#{attribute[0]}"]["was"],
                               :is_now => changes["#{attribute[0]}"]["is_now"],
                               :action_name => ::ChangeLogger.action_name,
                               :controller_name => ::ChangeLogger.controller_name,
                               :whodunnit => ::ChangeLogger.whodunnit)
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send :include, ChangeLogger::ActsAsChangeLogger