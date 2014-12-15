module ApplicationHelper

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-notice"
      else
        flash_type.to_s
    end
  end

  def show_field_error(model, field)
    s=""
    if !model.errors[field].empty?
      s =
        <<-EOHTML
           <div id="error_message">
             #{field}: #{model.errors[field][0]}
           </div>
        EOHTML
    end
    s.html_safe
  end

  def admin_only(&block)
    block.call if current_user.try(:admin?)
  end

  def admin_or_author_only(subject, &block)
    return nil unless current_user && subject
    block.call if current_user.admin? || current_user == subject.created_by
  end

  def not_myself(user)
    current_user != user
  end

  def to_base_amount(amount)
    return 0 if amount.nil?
    result = (100 * amount.to_f).to_i
  end
  
  def to_local_amount(amount)
    return 0 if amount.nil?
    result = to_whole(amount).to_s
    result << "0" if result[-2] == '.'
    return result
  end

  def to_whole(an_amount)
    raise ArgumentError, "an_amount must not be nil" if an_amount.nil?
    return an_amount.to_f / 100 if an_amount.is_a?(Integer)
    return an_amount
  end


  def to_local_currency(amount)
    return "R #{to_local_amount(amount)}"
  end

  def display_date(date, options = {})
    return "" if date == nil
    return date.strftime("%d %B %Y") unless options[:format]
    case options[:format]
      when :short
        date.strftime("%d/%m/%Y")
      when :month  
        date.strftime("%B %Y")
    end
  end

end
