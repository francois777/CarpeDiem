namespace :admin do
  desc "Create an admin user"

  task define_admin_user: :environment do
    if User.all.count > 0
      # User.delete_all
      puts "User found. New user not loaded"
    else
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

  task load_tents: :environment do
    if CampingSite.tents.count > 0
      puts "Tents found - more tents not created"
      # CampingSite.tents.delete_all
    else  
      puts "Loading Tents.."
      tent = nil

      ('01'..'20').each do |n|
        tent = Tent.create(location_code: "T#{n}", powered: true, reservable: true)
      end

      puts "20 tents have been loaded."
    end
  end

  task load_reservations: :environment do
    DiaryDay.delete_all
    RentedFacility.delete_all
    Reservation.delete_all

    date_range_A = [ { start: Date.today + 20, end: Date.today + 24 }, 
                     { start: Date.today + 24, end: Date.today + 28 },
                     { start: Date.today + 28, end: Date.today + 38 },
                     { start: Date.today + 51, end: Date.today + 54 },
                     { start: Date.today + 54, end: Date.today + 55 },
                     { start: Date.today + 61, end: Date.today + 72 }]
    date_range_B = [ { start: Date.today + 21, end: Date.today + 23 }, 
                     { start: Date.today + 24, end: Date.today + 26 },
                     { start: Date.today + 32, end: Date.today + 40 },
                     { start: Date.today + 50, end: Date.today + 60 }]
    date_range_C = [ { start: Date.today + 21, end: Date.today + 26 }, 
                     { start: Date.today + 26, end: Date.today + 30 },
                     { start: Date.today + 30, end: Date.today + 31 },
                     { start: Date.today + 37, end: Date.today + 44 },
                     { start: Date.today + 49, end: Date.today + 52 }]

    reservation = nil
    booking_cnt = 0
    site1 = Caravan.all[0]
    puts "Site1 = #{site1.inspect}"
    date_range_A.each do |r|
      booking_cnt += 1
      email = "Jonathan#{booking_cnt.to_s}.brooke@letussing.com"
      reservation = Reservation.create(start_date: r[:start], end_date: r[:end], reserved_for_name:
      "#{'Jonathan'}#{booking_cnt.to_s}", telephone: '123456789', mobile: '123456789', email: email, town: 'Lelierivier')
      if reservation.valid?
        reservation.save
      else
        puts "Reservation is not valid" 
        puts reservation.errors.inspect
      end 
      rf = reservation.rented_facilities.create(rentable: site1, reservation: reservation, start_date: r[:start], end_date: r[:end], adult_count: 4)
      puts "RentedFacility: #{rf.inspect}"
    end

    site2 = Caravan.all[1]
    date_range_B.each do |r|
      booking_cnt += 1
      email = "Jenny#{booking_cnt.to_s}.fredericks@letussing.com"
      reservation = Reservation.create(start_date: r[:start], end_date: r[:end], reserved_for_name:
      "#{'Jenny'}#{booking_cnt.to_s}", telephone: '123222789', mobile: '123456789', email: email, town: 'DangerCliff')
      reservation.rented_facilities.create(rentable: site2, reservation: reservation, start_date: r[:start], end_date: r[:end], adult_count: 4)
    end

    site3 = Caravan.all[2]
    date_range_C.each do |r|
      booking_cnt += 1
      email = "Hans#{booking_cnt.to_s}.goosen@letussing.com"
      reservation = Reservation.create(start_date: r[:start], end_date: r[:end], reserved_for_name:
      "#{'Hans'}#{booking_cnt.to_s}", telephone: '123222789', mobile: '123456789', email: email, town: 'Roseparadise')
      reservation.rented_facilities.create(rentable: site3, reservation: reservation, start_date: r[:start], end_date: r[:end], adult_count: 4)
    end
    puts "#{booking_cnt.to_s} reservations have been made."
  end

  task load_caravans: :environment do
    if CampingSite.caravans.count > 0
      puts "Caravans found - more caravans not created"
      # CampingSite.tents.delete_all
    else  
      puts "Loading Caravans.."

      ('01'..'20').each do |n|
        Caravan.create(location_code: "C#{n.to_s}", powered: true, reservable: true)
      end
      puts "20 caravans have been loaded"
    end
  end

end
