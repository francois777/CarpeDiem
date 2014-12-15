class Event < ActiveRecord::Base

  has_paper_trail on: [:update, :destroy]
  has_many :diary_days, as: :diarisable

  validates :title, presence: true, 
                    length: { minimum: 10, maximum: 50 }
  validates :organiser_name, presence: true, 
                    length: { minimum: 5, maximum: 40 }
  validates :organiser_telephone, presence: true, 
                    length: { minimum: 9, maximum: 20 }
  validates :start_date, presence:true
  validates :comments, length: { minimum: 0, maximum: 200 }
  validate :validate_end_date_before_start_date
  validate :validate_event_duration

  after_create :add_diary_dates 
  before_update :remove_existing_diary_dates
  before_update :add_diary_dates 

  private

    def validate_end_date_before_start_date
      if start_date && end_date
        errors.add(:end_date, :end_date_before_start_date) if end_date < start_date
      end
    end

    def validate_event_duration
      if end_date && start_date &&
        ((end_date.to_datetime - start_date.to_datetime).to_i + 1).to_i > AppConfig.instance.longest_event_duration
        errors.add(:end_date, :event_exceeds_max_duration)
      end   
    end

    def add_diary_dates
      dte1 = start_date.to_datetime
      dte2 = end_date.to_datetime

      while dte1 <= dte2 do
        DiaryDay.create(
            day: dte1,
            diarisable: self
          )
        dte1 += 1
      end
    end

    def remove_existing_diary_dates
      sqlstr = "DELETE FROM diary_days WHERE diarisable_id = #{id}"
      ActiveRecord::Base.connection.execute(sqlstr)
    end

end
