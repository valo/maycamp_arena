class Admin::ReportsController < Admin::BaseController
  def show
    @daily_submits_report = Ezgraphix::Graphic.new(
                              :w => 900, 
                              :div_name => "daily_submits_report",
                              :c_type => "line",
                              :precision => 0,
                              :rotate => "1",
                              :caption => "Брой събмити на ден - Последни 3 седмици",
                              :data => Run.count(:id, 
                                                 :conditions => ["created_at > ?", 3.weeks.ago.to_s(:db)], 
                                                 :select => "id",
                                                 :group => "DATE_FORMAT(created_at, '%m/%d')"))

    @total_submits_report = Ezgraphix::Graphic.new(
                            :w => 900, 
                            :div_name => "total_submits_report",
                            :c_type => "area2d",
                            :names => "0",
                            :precision => 0,
                            :caption => "Брой събмити на ден",
                            :data => Run.count(:id, 
                                               :select => "id",
                                               :group => "DATE_FORMAT(created_at, '%Y/%m/%d')"))
  end
end
