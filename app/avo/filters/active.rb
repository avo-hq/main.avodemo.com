class Avo::Filters::Active < Avo::Filters::BooleanFilter
  self.name = "Is Active"

  def apply(request, query, value)
    return query if value['is_active'] && value['is_inactive']

    query.where(active: value[:is_active])
  end

  def options
    {
      'is_active': 'Active',
      'is_inactive': 'Inactive',
    }
  end
end
