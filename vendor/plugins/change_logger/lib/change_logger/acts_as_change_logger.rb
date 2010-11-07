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
        # belongs_to :user, :foreign_key => 'whodunnit'
        after_update :record_changes
      end
      
      def owns_changes(options = {})
        has_many :changes_made, :class_name => 'ChangeLog', :order => 'created_at desc', :foreign_key => 'whodunnit'
      end
    end
    
    module InstanceMethods
      def record_changes
        attributes.delete_if{|k,v| self.class.ignore.include?(k) }.each do |attribute|
          if send("#{attribute[0]}_changed?")
            logger.info { "** recording_changes: whodunnit = #{::ChangeLogger.whodunnit.inspect}" }
            change_log = change_logs.new(:was => send("#{attribute[0]}_was"),
                               :is_now => send("#{attribute[0]}"),
                               :item_attribute => attribute[0],
                               :action_name => ::ChangeLogger.action_name,
                               :controller_name => ::ChangeLogger.controller_name,
                               :whodunnit => ::ChangeLogger.whodunnit.id)
            unless change_log.save
              logger.error { "Couldn't save change log: #{change_log.inspect}\nErrors: #{change_log.errors}" }
            end
          end
        end
      end
    end
  end
end
ActiveRecord::Base.send :include, ChangeLogger::ActsAsChangeLogger