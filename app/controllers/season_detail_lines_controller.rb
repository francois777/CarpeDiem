class SeasonDetailLinesController < ApplicationController

  def show
    @no_power_header = header_line(SeasonDetailLine.season_group_types[:without_power_points])
    @no_power_dtl_lines = tariff_details(SeasonDetailLine.without_power_points)
    @power_header = header_line(SeasonDetailLine.season_group_types[:powered_tariff])
    @power_dtl_lines = tariff_details(SeasonDetailLine.powered_tariff)
    @day_visitor_header = header_line(SeasonDetailLine.season_group_types[:day_visitor])
    @day_visitor_dtl_lines = tariff_details(SeasonDetailLine.day_visitor)
    @chalet_header = header_line(SeasonDetailLine.season_group_types[:chalet_tariff])
    @chalet_dtl_lines = tariff_details(SeasonDetailLine.chalet_tariff)
    @groups_header = header_line(SeasonDetailLine.season_group_types[:group_tariff])
    @groups_dtl_lines = tariff_details(SeasonDetailLine.group_tariff)
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
