class RentedFacility < ActiveRecord::Base

  belongs_to :reservation
  belongs_to :rentable, polymorphic: true
  has_many :diary_days, as: :diarisable

  validates :start_date, presence:true
  validate :validate_end_date_before_start_date
  validate :validate_reservation_duration
  validate :validate_max_occupants
  validate :validate_min_occupants
  validate :validate_infant_requires_adult

  after_create :add_diary_dates 
  before_update :remove_existing_diary_dates
  before_update :add_diary_dates 

  default_scope { order('start_date DESC') }

  private

    def validate_max_occupants
      if adult_count + child_6_12_count + child_0_5_count > AppConfig.instance.max_occupants_per_camping_site
        errors.add(:adult_count, :exceeds_max_occupants_per_camping_site)
      end
    end

    def validate_min_occupants
      unless adult_count + child_6_12_count + child_0_5_count > 0
        errors.add(:adult_count, :no_occupants_for_reservation)
      end
    end

    def validate_infant_requires_adult
      if child_0_5_count > 0 && adult_count == 0
        errors.add(:adult_count, :adult_is_required)
      end
    end

    def validate_end_date_before_start_date
      if start_date && end_date
        errors.add(:end_date, :end_date_before_start_date) if end_date < start_date
      end
    end

    def validate_reservation_duration
      if end_date && start_date &&
        ((end_date.to_datetime - start_date.to_datetime).to_i + 1).to_i > AppConfig.instance.longest_reservation
        errors.add(:end_date, :reservation_exceeds_max_duration)
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
