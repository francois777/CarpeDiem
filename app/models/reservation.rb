class Reservation < ActiveRecord::Base

  has_many :rented_facilities, as: :rentable
  has_many :received_payments
  has_many :diary_days, as: :diarisable
  has_one :reservation_reference

  validates :start_date, presence:true
  validate :validate_end_date_before_start_date
  validates :reserved_for_name, presence: true, 
                    length: { minimum: 5, maximum: 40 }
  validates :telephone, presence: true, 
                    length: { minimum: 9, maximum: 20 }
  validates :mobile, presence: true, 
                    length: { minimum: 9, maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 50 }
  validates :town,  length: { minimum: 2, maximum: 40 }

  before_update :remove_existing_diary_dates
  before_update :add_diary_dates 
  before_create :assign_reserved_datetime
  after_create :assign_reference_number

  private

    def assign_reserved_datetime
      reserved_datetime = Time.now
    end

    def assign_reference_number
      reservation_reference = ReservationReference.create!(reservation: self)
    end

    def validate_end_date_before_start_date
      if start_date && end_date
        errors.add(:end_date, :end_date_before_start_date) if end_date < start_date
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

