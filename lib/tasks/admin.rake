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

      (1..20).each do |n|
        CampingSite.create(camping_type: 'T', location_code: "T#{n.to_s}", powered: true, reservable: true)
      end
      puts "20 tents have been loaded"
    end
  end

  task load_caravans: :environment do
    if CampingSite.caravans.count > 0
      puts "Caravans found - more caravans not created"
      # CampingSite.tents.delete_all
    else  
      puts "Loading Caravans.."

      (1..20).each do |n|
        CampingSite.create(camping_type: 'C', location_code: "C#{n.to_s}", powered: true, reservable: true)
      end
      puts "20 caravans have been loaded"
    end
  end


end
