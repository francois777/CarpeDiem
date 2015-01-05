class ReservationRequest < ActiveRecord::Base

  FACILITY_TYPES = I18n.t(:facility_types).each_with_index.map { |iType, inx| [iType[0], inx] }
  FTYPES = { :tent => 0, :caravan => 1, :chalet_small => 2, :chalet_medium => 3, :chalet_large => 4 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

  # enum facility_types: I18n.t(:facility_types).each_with_index.map { |iType| iType[1] }

  validates :applicant_name, presence: true, 
                    length: { minimum: 5, maximum: 40 }
  validates :applicant_telephone, 
                    length: { minimum: 9, maximum: 20 }, unless: ->{ self.applicant_telephone.empty? }
  validates :applicant_mobile, 
                    length: { minimum: 9, maximum: 20 }, unless: ->{ self.applicant_mobile.empty? }
  validates :applicant_email, 
                    format: { with: VALID_EMAIL_REGEX },
                    length: { maximum: 50 }
  validates :applicant_town,  length: { minimum: 2, maximum: 40 }, unless: ->{ self.applicant_town.empty? }

  validates :start_date_1, presence:true
  validates :end_date_1, presence:true
  validate :validate_start_dates
  validate :validate_end_dates
  validate :validate_facility_details
  validate :one_contact_number_required

  private  

    def self.index_to_name(inx)
      #puts "ReservationRequest#self.index_to_name(inx)"
      name = case inx
      when 0
        'Tent'
      when 1
        'Caravan'
      when 2
        'Chalet_Small'
      when 3
        'Chalet_Medium'
      when 4 
        'Chalet_Large'
      else
        nil
      end  
      name
    end

    def one_contact_number_required
      if applicant_telephone == "" && applicant_mobile == ""
        errors.add(:applicant_telephone, :no_contact_numbers)
      end
    end

    def validate_start_dates
      if start_date_1 && start_date_1 < Date.today
        errors.add(:start_date_1, :invalid_start_date)
      end
      if start_date_2 && start_date_2 < Date.today
        errors.add(:start_date_2, :invalid_start_date)
      end
      if start_date_3 && start_date_3 < Date.today
        errors.add(:start_date_3, :invalid_start_date)
      end
    end

    def validate_end_dates
      return if start_date_1.nil? || end_date_1.nil?
      unless end_date_1 > start_date_1
        errors.add(:end_date_1, :invalid_end_date)
      end
      if start_date_2 && !end_date_2
        errors.add(:end_date_2, :end_date_missing)
      end
      if end_date_2 && end_date_2 <= start_date_2
        errors.add(:end_date_2, :end_date_invalid)
      end
      if start_date_3 && !end_date_3
        errors.add(:end_date_3, :end_date_missing)
      end
      if end_date_3 && end_date_3 <= start_date_3
        errors.add(:end_date_3, :end_date_invalid)
      end
    end

    def validate_facility_details
      # Facility 1
      unless (0..4).include? facility_type_1
        errors.add(facility_type_1, :invalid_facility_type) 
        return
      end
      total_occupants = adults_18_plus_count_1 + teenagers_count_1 + children_6_12_count_1 + infants_count_1
      errors.add(:adults_18_plus_count_1, :no_people_specified) if total_occupants == 0
      case facility_type_1 
      when FTYPES[:chalet_small] 
        if total_occupants > AppConfig.instance.max_occupants_per_small_chalet
          errors.add(:adults_18_plus_count_1, :exceeded_facility_max_capacity)
        end
      when FTYPES[:chalet_medium]  
        if total_occupants > AppConfig.instance.max_occupants_per_medium_chalet
          errors.add(:adults_18_plus_count_1, :exceeded_facility_max_capacity)
        end
      when FTYPES[:chalet_large]  
        if total_occupants > AppConfig.instance.max_occupants_per_large_chalet
          errors.add(:adults_18_plus_count_1, :exceeded_facility_max_capacity)
        end
      end
      if infants_count_1 > 0 and adults_18_plus_count_1 == 0
        errors.add(:adults_18_plus_count_1, :adult_required_for_infants)
      end

      # Facility 2
      total_occupants = adults_18_plus_count_2 + teenagers_count_2 + children_6_12_count_2 + infants_count_2
      errors.add(:adults_18_plus_count_2, :no_people_specified) if total_occupants == 0 && !start_date_2.nil?
      if total_occupants > 0
        unless (0..4).include? facility_type_2
          errors.add(facility_type_2, :invalid_facility_type) 
          return
        end
        case facility_type_2 
        when FTYPES[:chalet_small] 
          if total_occupants > AppConfig.instance.max_occupants_per_small_chalet
            errors.add(:adults_18_plus_count_2, :exceeded_facility_max_capacity)
          end
        when FTYPES[:chalet_medium]  
          if total_occupants > AppConfig.instance.max_occupants_per_medium_chalet
            errors.add(:adults_18_plus_count_2, :exceeded_facility_max_capacity)
          end
        when FTYPES[:chalet_large]  
          if total_occupants > AppConfig.instance.max_occupants_per_large_chalet
            errors.add(:adults_18_plus_count_2, :exceeded_facility_max_capacity)
          end
        end
        if infants_count_2 > 0 and adults_18_plus_count_2 == 0
          errors.add(:adults_18_plus_count_2, :adult_required_for_infants)
        end
      end

      # Facility 3
      total_occupants = adults_18_plus_count_3 + teenagers_count_3 + children_6_12_count_3 + infants_count_3
      errors.add(:adults_18_plus_count_3, :no_people_specified) if total_occupants == 0 && !start_date_3.nil?
      if total_occupants > 0
        unless (0..4).include? facility_type_3
          errors.add(facility_type_3, :invalid_facility_type) 
          return
        end
        case facility_type_3
        when FTYPES[:chalet_small] 
          if total_occupants > AppConfig.instance.max_occupants_per_small_chalet
            errors.add(:adults_18_plus_count_3, :exceeded_facility_max_capacity)
          end
        when FTYPES[:chalet_medium]  
          if total_occupants > AppConfig.instance.max_occupants_per_medium_chalet
            errors.add(:adults_18_plus_count_3, :exceeded_facility_max_capacity)
          end
        when FTYPES[:chalet_large]  
          if total_occupants > AppConfig.instance.max_occupants_per_large_chalet
            errors.add(:adults_18_plus_count_3, :exceeded_facility_max_capacity)
          end
        end
        if infants_count_3 > 0 and adults_18_plus_count_3 == 0
          errors.add(:adults_18_plus_count_3, :adult_required_for_infants)
        end
      end
    end
end
