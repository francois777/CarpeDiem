namespace :admin do
  desc "Create an admin user"

  task define_admin_user: :environment do
    if User.all.count == 0
      puts "User found. New user not loaded"
    else
      User.delete_all

      puts "Loading users.."
      admin_user = User.create( first_name: "Francois",
                                last_name: "van der Hoven",
                                email: "francoisvanderhoven@gmail.com",
                                password: "password",
                                password_confirmation: "password",
                                admin: true )
      if admin_user.valid?
        puts "Admin User has been loaded!"
      else
        puts admin_user.errors.inspect
        puts "Admin User create failed!"
      end  
    end
  end

  task define_season_detail_lines: :environment do
    if SeasonDetailLine.all.count > 0
      puts "SeasonDetailLines have already been loaded. No need to continue"
    else
      puts "Loading Season Detail Lines.."
      @group_types = SeasonDetailLine.season_group_types
      create_normal_tariff_lines
      create_powered_tariff_lines
      create_day_visitor_line
      create_chalet_lines
      create_groups_lines
      puts "Season detail lines loaded!"
    end
  end

  def create_normal_tariff_lines
    line1 = SeasonDetailLine.new
    line1.season_group_type = @group_types[:normal_tariff]
    line1.sequence = 1
    line1.line_col_1 = I18n.t(:tent_sites, scope: [:accommodation, :col_1]).upcase
    line1.line_col_2 = "R110"
    line1.line_col_3 = I18n.t(:child_amount_a, scope: [:accommodation, :col_3]).upcase
    line1.line_col_4 = I18n.t(:site_limit, scope: [:accommodation, :col_4]).upcase
    line1.save!

    line2 = SeasonDetailLine.new
    line2.season_group_type = @group_types[:normal_tariff]
    line2.sequence = 2
    line2.line_col_1 = I18n.t(:caravan_sites, scope: [:accommodation, :col_1]).upcase
    line2.line_col_2 = "R110"
    line2.line_col_3 = I18n.t(:child_amount_b, scope: [:accommodation, :col_3]).upcase
    line2.line_col_4 = I18n.t(:site_limit, scope: [:accommodation, :col_4]).upcase
    line2.save!

    line3 = SeasonDetailLine.new
    line3.season_group_type = @group_types[:normal_tariff]
    line3.sequence = 3
    line3.line_col_1 = I18n.t(:warrior_camps, scope: [:accommodation, :col_1]).upcase
    line3.line_col_2 = ""
    line3.line_col_3 = I18n.t(:person_weekend_tariff, scope: [:accommodation, :col_3]).upcase
    line3.line_col_4 = I18n.t(:friday_to_sunday, scope: [:accommodation, :col_4]).upcase
    line3.save!
  end

  def create_powered_tariff_lines
    line1 = SeasonDetailLine.new
    line1.season_group_type = @group_types[:powered_tariff]
    line1.sequence = 1
    line1.line_col_1 = I18n.t(:tent_sites, scope: [:accommodation, :col_1]).upcase
    line1.line_col_2 = "R110"
    line1.line_col_3 = I18n.t(:child_amount_a, scope: [:accommodation, :col_3]).upcase
    line1.line_col_4 = I18n.t(:site_limit, scope: [:accommodation, :col_4]).upcase
    line1.save!

    line2 = SeasonDetailLine.new
    line2.season_group_type = @group_types[:powered_tariff]
    line2.sequence = 2
    line2.line_col_1 = I18n.t(:caravan_sites, scope: [:accommodation, :col_1]).upcase
    line2.line_col_2 = "R150"
    line2.line_col_3 = I18n.t(:child_amount_c, scope: [:accommodation, :col_3]).upcase
    line2.line_col_4 = I18n.t(:site_limit, scope: [:accommodation, :col_4]).upcase
    line2.save!
  end

  def create_day_visitor_line
    line1 = SeasonDetailLine.new
    line1.season_group_type = @group_types[:day_visitor]
    line1.sequence = 1
    line1.line_col_1 = I18n.t(:day_visitors, scope: [:accommodation, :col_1]).upcase
    line1.line_col_2 = I18n.to(:reference_1, scope: [:accommodation, :col_1])
    line1.line_col_3 = I18n.t(:child_amount_b, scope: [:accommodation, :col_3]).upcase
    line1.line_col_4 = I18n.t(:day_visitor_times, scope: [:accommodation, :col_4]).upcase
    line1.save!
  end

  def create_chalet_lines
    line1 = SeasonDetailLine.new
    line1.season_group_type = @group_types[:chalet_tariff]
    line1.sequence = 1
    line1.line_col_1 = I18n.t(:chalet_a, scope: [:accommodation, :col_1]).upcase
    line1.line_col_2 = I18n.t(:fully_equipped, scope: [:accommodation, :col_2]).upcase
    line1.line_col_3 = I18n.t(:chalet_a_tariff, scope: [:accommodation, :col_3]).upcase
    line1.line_col_4 = I18n.t(:chalet_times, scope: [:accommodation, :col_4]).upcase
    line1.save!
  end

  def create_groups_lines
    line1 = SeasonDetailLine.new
    line1.season_group_type = @group_types[:group_tariff]
    line1.sequence = 1
    line1.line_col_1 = I18n.t(:group_reservations_budget, scope: [:accommodation, :col_1]).upcase
    line1.line_col_2 = I18n.t(:tents_and_caravans, scope: [:accommodation, :col_2]).upcase
    line1.line_col_3 = I18n.t(:group_reservations_budget, scope: [:accommodation, :col_3]).upcase
    line1.line_col_4 = I18n.t(:friday_to_sunday, scope: [:accommodation, :col_4]).upcase
    line1.save!

    line2 = SeasonDetailLine.new
    line2.season_group_type = @group_types[:group_tariff]
    line2.sequence = 2
    line2.line_col_1 = I18n.t(:group_reservations_meals, scope: [:accommodation, :col_1]).upcase
    line2.line_col_2 = I18n.t(:tents_and_caravans, scope: [:accommodation, :col_2]).upcase
    line2.line_col_3 = I18n.t(:group_reservations_meals, scope: [:accommodation, :col_3]).upcase
    line2.line_col_4 = I18n.t(:friday_to_sunday, scope: [:accommodation, :col_4]).upcase
    line2.save!
  end

end
