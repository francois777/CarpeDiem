require 'spec_helper'

describe SeasonDetailLine do

  include FactoryGirl::Syntax::Methods
  
  before do
    @season_detail_line = create(:season_detail_line)
  end

  subject { @season_detail_line }

  it { should respond_to(:sequence) }
  it { should respond_to(:line_col_1) }
  it { should respond_to(:line_col_2) }
  it { should respond_to(:line_col_3) }
  it { should respond_to(:line_col_4) }

end
