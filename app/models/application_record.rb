# frozen_string_literal: true

# All the model are inherit from this application record.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
