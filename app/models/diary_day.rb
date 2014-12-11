class DiaryDay < ActiveRecord::Base
  belongs_to :diarisable, polymorphic: true
 
  validates :day, presence: true

end 