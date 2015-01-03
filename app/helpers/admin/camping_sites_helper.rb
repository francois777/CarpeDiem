module Admin::CampingSitesHelper

  def sti_camping_site_path(type = "camping_site", camping_site = nil, action = nil)
    send "#{format_sti(action, type, camping_site)}_path", camping_site
  end

  def format_sti(action, type, camping_site)
    action || camping_site ? "admin_#{format_action(action)}#{type.downcase}" : "#{type.pluralize}"
  end  

  def format_action(action)
    action ? "#{action}_" : ""
  end

end



# Returns a dynamic path based on the provided parameters
# def sti_animal_path(race = "animal", animal = nil, action = nil)
#   send "#{format_sti(action, race, animal)}_path", animal
# end

# def format_sti(action, race, animal)
#   action || animal ? "#{format_action(action)}#{race.underscore}" : "#{race.underscore.pluralize}"
# end

# def format_action(action)
#   action ? "#{action}_" : ""
# end