require 'spec_helper'

describe ReservationReference do

  include FactoryGirl::Syntax::Methods

  it "should create a unique reservation reference" do
    reference = ReservationReference.create!(reservation_id: 1)
    expect(reference).not_to be_nil
    expect(reference.refid).not_to be_nil
    expect { ReservationReference.create!(refid: reference.refid, reservation_id: 2) }.to raise_error ActiveRecord::RecordInvalid
  end
  
end