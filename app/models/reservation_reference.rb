class ReservationReference < ActiveRecord::Base

  MAX_REF = 2 ** ([42].pack('i').size * 7 - 2) - 1

  validates :refid, presence: true
  validates_uniqueness_of :refid
  belongs_to :reservation

  validates_numericality_of :refid, only_integer: true, greater_than_or_equal_to: 0
  before_validation :generate_reference

  protected

    def generate_reference
      return if !self.refid.nil? && self.refid > 0
      ref = (1 + SecureRandom.random_number(MAX_REF - 102))
      generate_reference if ReservationReference.exists?(refid: ref)
      self.refid = ref
    end


end