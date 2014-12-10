class Event < ActiveRecord::Base

  has_paper_trail on: [:update, :destroy]

  validates :title, presence: true, 
                    length: { minimum: 10, maximum: 50 }
  validates :organiser_name, presence: true, 
                    length: { minimum: 5, maximum: 40 }
  validates :organiser_telephone, presence: true, 
                    length: { minimum: 9, maximum: 20 }
  validates :start_date, presence:true
  validates :comments, length: { minimum: 0, maximum: 200 }
  validate :validate_end_date_before_start_date

  def validate_end_date_before_start_date
    if start_date && end_date
      errors.add(:end_date, "End date is before start date") if end_date < start_date
    end
  end

end