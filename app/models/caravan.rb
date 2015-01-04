class Caravan < CampingSite

  def self.available_count_between(start_date, end_date)
    site_count = 0 
    Caravan.all.each do |site|
      next unless site.reservable?
      site_count += 1 if site.available_between?(start_date, end_date)
    end
    site_count
  end

end