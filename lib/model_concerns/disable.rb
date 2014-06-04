# encoding: utf-8

module ModelConcerns
  module Disable
    extend ActiveSupport::Concern

    included do
      scope :disabled, -> { where "disabled_at is not null" }
      scope :enabled, -> { where disabled_at: nil }
    end

    def disable
      self.disabled_at = Time.now
    end

    def enable
      self.disabled_at = nil
    end

    def disabled?
      !self.disabled_at.nil?
    end

    def disabled=(value)
      if value == "1" || value == 1 || value == true
        self.disable
      else
        self.enable
      end
    end
  end
end