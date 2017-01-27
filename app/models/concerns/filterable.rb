module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter(filtering_params, where_hash=nil)
      results = self.where(where_hash)
      if !filtering_params.nil?
        filtering_params.each do |key, value|
          results = results.public_send(key, value) if value.present?
        end
      end
      results
    end
  end
end