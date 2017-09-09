class StaticPagesController < ApplicationController

  def home
  end

  def facilities
  end

  def activities
  end

  def directions
  end

  def memories
  end

  def terms
    @terms = I18n.t(:terms, scope: [:terms_and_conditions]).each_with_index.map { |rule, inx| [rule[1].to_s, inx + 1] }
    @cancellation_rules = []
    I18n.t(:policy_rules, scope: [:terms_and_conditions]).each_with_index do |rule, inx| 
      break if inx > 3
      @cancellation_rules << [rule[1].to_s, inx + 1]
    end   
    @cancellation_rules << [ I18n.t(:rule, scope: [:terms_and_conditions, :policy_rules, :rule05]), 5]
    @rule5_subrules = I18n.t(:sub_points, scope: [:terms_and_conditions, :policy_rules, :rule05]).each.map { |rule| rule[1]}
    @trespassing_rules = I18n.t(:trespassing_rules, scope: [:terms_and_conditions, :policy_rules]).each_with_index.map { |rule, inx| [rule[1].to_s, inx + 1] }
  end

  def views
  end

  def test
  end
end
