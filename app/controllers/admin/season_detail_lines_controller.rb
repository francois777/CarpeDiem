class Admin::SeasonDetailLinesController < ApplicationController

  def no_powerpoints
    @no_power_header = header_line(SeasonDetailLine.season_group_types[:without_power_points])
    @season_detail_lines = SeasonDetailLine.without_power_points
    puts "Admin::SeasonDetailLinesController#no_powerpoints"
    puts @season_detail_lines.inspect
    @col1_options = I18n.t(:col_1, scope: [:accommodation]).each_with_index.map { |nme, inx| [nme[1].to_s, inx] }
    @col2_options = I18n.t(:col_2, scope: [:accommodation]).each_with_index.map { |nme, inx| [nme[1].to_s, inx] }
    @col3_options = I18n.t(:col_3, scope: [:accommodation]).each_with_index.map { |nme, inx| [nme[1].to_s, inx] }
    @col4_options = I18n.t(:col_4, scope: [:accommodation]).each_with_index.map { |nme, inx| [nme[1].to_s, inx] }
  end

  def show
    puts "Params: #{params.inspect}"
  end
  
  def update
  end

  def destroy
  end

  def header_line(accommodation_type)
    case accommodation_type
    when SeasonDetailLine.season_group_types[:without_power_points]
      [ t(:without_power_points, scope: [:accommodation]).upcase,
        t(:per_site, scope: [:accommodation]).upcase,
        t(:per_person_per_night, scope: [:accommodation]).upcase,
        ""
      ]
    when SeasonDetailLine.season_group_types[:powered_tariff]
      [ t(:with_power_points, scope: [:accommodation]).upcase,
        t(:per_site, scope: [:accommodation]).upcase,
        t(:per_person_per_night, scope: [:accommodation]).upcase,
        ""
      ]
    when SeasonDetailLine.season_group_types[:day_visitor]
      [ "", "", t(:per_person, scope: [:accommodation]).upcase, ""]
    when SeasonDetailLine.season_group_types[:chalet_tariff]
      [ t(:with_power_points, scope: [:accommodation]).upcase,
        "",
        t(:per_night_for_chalet, scope: [:accommodation]).upcase,
        ""
      ]
    when SeasonDetailLine.season_group_types[:group_tariff]
      [ t(:without_power_points, scope: [:accommodation]).upcase,
        "",
        t(:per_person, scope: [:accommodation]).upcase,
        t(:tents_and_caravans, scope: [:accommodation]).upcase
      ]
    else
     [ "", "", "", ""]  
    end
  end

  def tariff_details(lines)
    tariffs = []
    lines.each do |line|
      tariffs.push [ line.line_col_1, line.line_col_2, line.line_col_3, line.line_col_4 ]
    end
    tariffs
  end

end
