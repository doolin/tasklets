# frozen-string-literal: true

# Base class for Rails > 5 models
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
