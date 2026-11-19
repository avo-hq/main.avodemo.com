class Avo::Cards::ExampleAreaChart < Avo::Cards::ChartkickCard
  self.id = "user_signups"
  self.label = "User signups"
  self.chart_type = :area_chart
  self.description = "Users who signed up each day in the selected range"
  self.cols = 2
  self.initial_range = 30
  self.ranges = [7, 30, 60, 365, "TODAY", "MTD", "QTD", "YTD", "ALL"]

  # self.chart_options = {library: {plugins: {legend: {display: true}}}}
  # self.flush = true
  # self.legend = true
  # self.scale = false
  # self.legend_on_left = true

  # You have access to context, params, range, current dashboard, and current card
  def query
    to = Time.current
    from = case range.to_s
    when /\A\d+\z/ then to - range.to_i.days
    when "TODAY" then to.beginning_of_day
    when "MTD" then to.beginning_of_month
    when "QTD" then to.beginning_of_quarter
    when "YTD" then to.beginning_of_year
    when "ALL" then User.minimum(:created_at) || to
    else to - 7.days
    end

    # One entry per day that had signups, e.g. {Mon, 02 Nov 2026 => 3}.
    # DATE() takes the day of the stored UTC timestamp, which is the app's day
    # because this app runs in UTC. Apps on another Time.zone can use Groupdate's
    # `group_by_day(:created_at)` to bucket by their own days instead.
    signups = User.where(created_at: from..to).group("DATE(created_at)").count

    # Fill the days without signups with 0 so the chart doesn't skip them.
    data = (from.to_date..to.to_date).index_with { |day| signups.fetch(day, 0) }

    result [{name: "Signups", data: data}]
  end
end
