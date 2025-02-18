class Avo::Resources::Movie < Avo::Resources::ArrayResource
  def records
    [
      {
        id: 1,
        name: "The Shawshank Redemption",
        release_date: "1994-09-23"
      },
      {
        id: 2,
        name: "The Godfather",
        release_date: "1972-03-24",
        fun_fact: "The iconic cat in the opening scene was a stray found by director Francis Ford Coppola on the studio lot."
      },
      {
        id: 3,
        name: "Pulp Fiction",
        release_date: "1994-10-14"
      }
    ]
  end

  def fields
    main_panel do
      field :id, as: :id
      field :name, as: :text
      field :release_date, as: :date
      field :fun_fact, only_on: :index, visible: -> { resource.record.fun_fact.present? } do
        record.fun_fact.truncate_words(10)
      end

      sidebar do
        field :fun_fact do
          record.fun_fact || "There is no register of a fun fact for #{record.name}"
        end
      end
    end
  end
end
