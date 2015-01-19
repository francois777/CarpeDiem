class Reservation < ActiveRecord::Base

  has_many :rented_facilities
  has_many :received_payments
  has_one :reservation_reference
  accepts_nested_attributes_for :rented_facilities

  validates :start_date, presence:true
  validate :validate_end_date_before_start_date
  validates :reserved_for_name, presence: true, 
                    length: { minimum: 5, maximum: 40 }
  validates :telephone, length: { minimum: 9, maximum: 20 }, unless: "telephone == ''"
  validates :mobile, length: { minimum: 9, maximum: 20 }, unless: "mobile == ''"
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX },
                    length: { maximum: 50 }
  validates :town,  length: { minimum: 2, maximum: 40 }
  validate :one_contact_number_required

  before_create :assign_reserved_datetime
  after_create :assign_reference_number

  def reference_no
    reservation_reference.refid
  end

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

    def one_contact_number_required
      if telephone == "" && mobile == ""
        errors.add(:telephone, :no_contact_numbers)
      end
    end

end

