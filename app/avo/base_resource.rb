class Avo::BaseResource < Avo::Resources::Base
  self.index_controls = -> {
    # Don't show bulk destroy for these resources
    return default_controls if resource.class.in?([
      Avo::Resources::User,
      Avo::Resources::Post,
      Avo::Resources::Product,
      Avo::Resources::Person,
      Avo::Resources::Spouse,
      Avo::Resources::Movie,
      Avo::Resources::Fish,
    ])

    bulk_title = tag.span(class: "text-xs") do
      safe_join([
        "Delete all selected #{resource.plural_name.downcase}",
        tag.br,
        "Select at least one #{resource.singular_name.downcase} to run this action"
      ])
    end.html_safe

    action Avo::Actions::BulkDestroy,
      icon: "heroicons/solid/trash",
      color: "red",
      label: "",
      style: :outline,
      title: bulk_title

    default_controls
  }
end