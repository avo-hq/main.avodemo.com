class Avo::Filters::Active < Avo::Filters::BooleanFilter
  self.name = "Is Active"

  def apply(request, query, value)
    query.where(active: value[:is_active])
  end

  def options
    {
      'is_active': 'Active',
      'is_inactive': 'Inactive',
    }
  end
end
