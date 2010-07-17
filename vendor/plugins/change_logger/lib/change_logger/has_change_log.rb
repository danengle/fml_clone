puts "*** in has_change_log ***"
module ChangeLogger
  module Model
    def self.included(base)
      puts "**** in self.included(base)"
      base.send :extend, ClassMethods
    end  
  
    module ClassMethods # any method placed here will apply to classes, like Hickwall
      
      def has_change_log(options = {})
        
        puts "***** in def has_change_log *****"
        include InstanceMethods
          
        cattr_accessor :ignore
        self.ignore = (options[:ignore] || []).map &:to_s
        
        has_many :change_logs, :as => :item, :order => 'created_at ASC'
        
        before_update :record_changes
      end
    end
  
    module InstanceMethods # any method placed here will apply to instaces, like @hickwall  
      
      def record_changes
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
  end
end
ActiveRecord::Base.send :include, ChangeLogger::Model
