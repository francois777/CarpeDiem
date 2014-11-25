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
end
