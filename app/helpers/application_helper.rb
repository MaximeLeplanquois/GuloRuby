module ApplicationHelper

  def get_months_from_year(start_year)
    start_year.upto(Date.today.year)
              .flat_map { |y| Date::MONTHNAMES.compact.map { |m| "#{m} #{y}" } }
  end

end
