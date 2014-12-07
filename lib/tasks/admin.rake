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

end
