class SeasonDetailLine < ActiveRecord::Base

  LINE_TYPES = I18n.t(:season_group_types, scope: [:activerecord, :attributes, :season_detail_line])

  enum season_group_type: I18n.t(:season_group_types, scope: [:activerecord, :attributes, :season_detail_line]).each_with_index.map { |ltyp| ltyp[0] }

  validates :sequence, presence: true,
                       numericality: { only_integer: true }

  default_scope -> { order('sequence') }  

  # scope :public_articles, -> { 
  #   where("approval_status = #{Article.approval_statuses[:approved]}") 
  # }
  # scope :own_and_other_articles, -> (current_user_id) { 
  #   where("author_id = ? OR approval_status = ?", current_user_id, Article.approval_statuses[:approved])
  # } 

end
