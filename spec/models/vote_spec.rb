require 'rails_helper'

describe Vote, type: :model do
  it { should belong_to :votable }
end
