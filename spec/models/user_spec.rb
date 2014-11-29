require 'spec_helper'

describe User do

  include FactoryGirl::Syntax::Methods
  
  before do
    @user = User.new(first_name: "Firstname", last_name: "Lastname", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")
  end  

  subject { @user }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:admin) }

  it "must be valid" do
    expect(@user).to be_valid
  end

  it "must have a valid factory" do
    user_fact = build(:user)
    expect(user_fact).to be_valid
  end

  it "presents the correct full name" do
    expect(@user.full_name).to eq("Firstname Lastname")
  end

  it "must validate the user's first_name" do
    @user.first_name = 'H'
    expect(@user).not_to be_valid
    @user.first_name = "A" * 16
    expect(@user).not_to be_valid
  end

  it "must validate the user's last_name" do
    @user.last_name = 'H'
    expect(@user).not_to be_valid
    @user.last_name = "A" * 26
    expect(@user).not_to be_valid
  end  

  it "must validate the user's password" do
    @user.password = @user.password_confirmation = 'H' * 5
    expect(@user).not_to be_valid
    @user.password = @user.password_confirmation = "A" * 21
    expect(@user).not_to be_valid
    @user.password = 'abcdef'
    @user.password_confirmation = 'abcdeF'
    expect(@user).not_to be_valid
  end

  it "must validate the user's email address" do
    @user.email = 'sue.com.au'
    expect(@user).not_to be_valid
    @user.email = 'sue.scott@new.123'    
    expect(@user).not_to be_valid
    @user.email = 'jacktheripperswife@thebigbrownfox.thefoxcompany.com'
    expect(@user).not_to be_valid
    user2 = @user.dup
    expect(user2).not_to be_valid
  end

  it "must recognise locales" do
    puts I18n.t(:season_group_types, scope: [:activerecord, :attributes, :season_detail_line])  # .each_with_index.map { |ltyp| ltyp[0] }
  end  
end