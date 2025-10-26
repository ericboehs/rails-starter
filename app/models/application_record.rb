# Base class for all application models, inheriting from ActiveRecord::Base
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
