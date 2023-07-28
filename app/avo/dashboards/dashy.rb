class Avo::Dashboards::Dashy < Avo::Dashboards::BaseDashboard
  self.id = "dashy"
  self.name = "Dashy"
  self.description = "The first dashbaord"
  self.grid_cols = 3

  def cards
    card Avo::Cards::ExampleMetric
    card Avo::Cards::ExampleAreaChart
    card Avo::Cards::ExampleScatterChart
    card Avo::Cards::PercentDone
    card Avo::Cards::AmountRaised
    card Avo::Cards::ExampleLineChart
    card Avo::Cards::ExampleColumnChart
    card Avo::Cards::ExamplePieChart
    card Avo::Cards::ExampleBarChart
    divider label: "Custom partials"
    card Avo::Cards::ExampleCustomPartial
    card Avo::Cards::MapCard
  end
end
