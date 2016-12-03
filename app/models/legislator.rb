class Legislator < ApplicationRecord
  def self.house_majority
    Legislator.where(chamber: 'house', caucus:'majority')
  end

  def self.house_minority
    Legislator.where(chamber: 'house', caucus:'minority')
  end

  def self.house
    Legislator.where(chamber: 'house')
  end

  def self.senate
    Legislator.where(chamber: 'senate')
  end
end
