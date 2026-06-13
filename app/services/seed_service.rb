require 'open-uri'

class SeedService
  def self.seed
    # abort JSON.parse(File.read(Rails.root.join('db', 'posts.json')))['posts'].inspect
    ActiveStorage::Attachment.all.each { |attachment| attachment.purge }
    Person.delete_all
    Review.delete_all
    Fish.delete_all
    Course.delete_all
    Course::Link.delete_all
    TeamMembership.delete_all
    Team.delete_all
    Comment.delete_all
    Post.delete_all
    ProjectUser.delete_all
    Project.delete_all
    User.delete_all
    City.delete_all
    Product.delete_all
    Event.delete_all
    Avo::Kanban::Item.delete_all
    Avo::Kanban::Column.delete_all
    Avo::Kanban::Board.delete_all
    Issue.delete_all
    PullRequest.delete_all
    Task.delete_all
    ['active_storage_blobs', 'active_storage_attachments', 'posts', 'projects', 'projects_users', 'team_memberships', 'teams', 'users', 'comments', 'people', 'reviews', 'courses', 'course_links', 'fish'].each do |table_name|
      ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY CASCADE")
    end

    cities = [
      {name: "New York", population: 8398748, is_capital: false, longitude: -74.006, latitude: 40.7128},
      {name: "Los Angeles", population: 3990456, is_capital: false, longitude: -118.2437, latitude: 34.0522},
      {name: "Bucharest", population: 1800000, is_capital: true, longitude: 26.1025, latitude: 44.4268},
      {name: "Hong Kong", population: 7500000, is_capital: true, longitude: 114.1694, latitude: 22.3193}
    ]

    cities.each do |city_params|
      City.create(city_params)
    end


    teams = []
    teams.push(FactoryBot.create(:team, name: 'Apple', url: 'https://apple.com'))
    teams.push(FactoryBot.create(:team, name: 'Google', url: 'https://google.com'))
    teams.push(FactoryBot.create(:team, name: 'Facebook', url: 'https://facebook.com'))
    teams.push(FactoryBot.create(:team, name: 'Amazon', url: 'https://amazon.com'))

    users = []
    38.times do
      users.push(FactoryBot.create(:user, team_id: teams.sample.id))
    end

    demo_user = User.create(
      first_name: 'Avo',
      last_name: 'Cado',
      email: 'avo@cado.com',
      password: 'secreto',
      active: true,
      roles: {
        admin: true,
        manager: true,
        editor: true,
      },
      birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
    )

    famous_users = [
      {
        first_name: 'Eric',
        last_name: 'Berry',
        email: 'eric@berry.sh'
      },
      {
        first_name: 'Vladimir',
        last_name: 'Dementyev',
        email: 'palkan@evilmartians.com'
      },
      {
        first_name: 'Jason',
        last_name: 'Charnes',
        email: 'jason@jasoncharnes.com'
      },
      {
        first_name: 'Andrew',
        last_name: 'Culver',
        email: 'andrew.culver@gmail.com'
      },
      {
        first_name: 'Yaroslav',
        last_name: 'Shmarov',
        email: 'yashm@outlook.com'
      },
      {
        first_name: 'Lucian',
        last_name: 'Ghinda',
        email: 'lucian@ghinda.com'
      },
      {
        first_name: 'Jason',
        last_name: 'Swett',
        email: 'jason@benfranklinlabs.com'
      },
      {
        first_name: 'Jeremy',
        last_name: 'Smith',
        email: 'jeremy@jeremysmith.co'
      },
      {
        first_name: 'Yukihiro "Matz"',
        last_name: 'Matsumoto',
        email: 'matz@ruby.or.jp'
      },
      {
        first_name: 'Joe',
        last_name: 'Masilotti',
        email: 'joe@masilotti.com'
      },
      {
        first_name: 'Mike',
        last_name: 'Perham',
        email: 'mperham@gmail.com'
      },
      {
        first_name: 'Taylor',
        last_name: 'Otwell',
        email: 'taylor@laravel.com'
      },
      {
        first_name: 'Adam',
        last_name: 'Watham',
        email: 'adam@adamwathan.me'
      },
      {
        first_name: 'Jeffery',
        last_name: 'Way',
        email: 'jeffrey@laracasts.com'
      },
      {
        first_name: 'Adrian',
        last_name: 'Marin',
        email: 'adrian@adrianthedev.com'
      },
    ]

    famous_users.reverse.each do |user|
      users.push(FactoryBot.create(:user, team_id: teams.sample.id, **user))
    end

    users.push User.create(
      first_name: "Avo",
      last_name: "Cado",
      email: "avo@avohq.io",
      birthday: "2020-03-28",
      password: "secreto",
      active: true,
      roles: {
        admin: true,
        manager: false,
        writer: false
      }
    )

    # People and Spouses
    people = FactoryBot.create_list(:person, 12)
    people.each do |person|
      person.spouses << FactoryBot.create(:spouse)
    end

    reviews = FactoryBot.create_list(:review, 32)
    reviews.each do |review|
      reviewable = [:fish, :post, :project, :team].sample
      review.reviewable = FactoryBot.create(reviewable, created_at: Time.now - 1.day)

      review.user = users.sample

      review.save
    end

    posts = JSON.parse(File.read(Rails.root.join('db', 'posts.json')))['posts']
    posts.shuffle.each do |post_payload|
      post = Post.create(
        name: CGI::unescapeHTML(post_payload['title']),
        body: CGI::unescapeHTML(post_payload['content']),
        is_featured: [true, false].sample,
        # custom_css: ".header {\n  color: red;\n}",
        user_id: users.sample.id,
        published_at: post_payload['pubDate'],
        updated_at: post_payload['pubDate'],
      )

      if post_payload['thumbnail'].present?
        post.cover_photo.attach(io: URI.open(Rails.root.join('db', 'seed_files', 'posts', "#{post_payload['thumbnail']}.png")), filename: 'cover.png')
      end

      rand(0..15).times do
        post.comments << FactoryBot.create(:comment, user_id: users.sample.id)
      end
    rescue => exception
      puts exception.inspect
    end

    projects = []
    30.times do
      projects.push(FactoryBot.create(:project))
    end

    # assign users to teams
    teams.each do |team|
      users.shuffle[0..rand(5...15)].each_with_index do |user, index|
        team.team_members << user

        membership = team.memberships.find_by user_id: user.id
        membership.update level: [:beginner, :intermediate, :advanced].sample

        if index == 0
          membership.update level: :admin
        end
      end
    end

    # assign users to projects
    projects.each do |project|
      users.shuffle[0..10].each do |user|
        project.users << user
      end

      rand(0..15).times do
        project.comments << FactoryBot.create(:comment, user_id: users.sample.id)
      end
    end

    # Courses and links
    courses = FactoryBot.create_list(:course, 150)
    courses.each do |course|
      FactoryBot.create_list(:course_link, 3, course: course)
    end

    # Create this last user so the grid view displays the gravatar image for an entry
    User.create(
      first_name: 'Avo',
      last_name: 'Cado',
      email: 'avo@avohq.io',
      password: 'secreto',
      active: true,
      roles: {
        admin: true,
        manager: true,
        editor: true,
      },
      birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
    )

    products = [
      {
        title: "iPod",
        description: "A portable music player.",
        category: "Music players",
        price_cents: 19900,
        price_currency: "USD",
        image: File.open(Rails.root.join('db', 'seed_files', 'ipod.jpg'))
      },
      {
        title: "iPhone",
        description: "A smartphone.",
        category: "Phones",
        price_cents: 99900,
        price_currency: "USD",
        image: File.open(Rails.root.join('db', 'seed_files', 'iphone.jpg'))
      },
      {
        title: "MacBook Pro",
        description: "A powerful laptop.",
        category: "Computers",
        price_cents: 239900,
        price_currency: "USD",
        image: File.open(Rails.root.join('db', 'seed_files', 'macbook.jpg'))
      },
      {
        title: "Apple Watch",
        description: "A smartwatch.",
        category: "Wearables",
        price_cents: 39900,
        price_currency: "USD",
        image: File.open(Rails.root.join('db', 'seed_files', 'watch.jpg'))
      }
    ]
    products.each do |product_attrs|
      Product.create!(product_attrs)
    end

    # Events
    event = Event.create(
      name: "Your friendly european Ruby conference",
      event_time: Time.new(2025, 9, 10, 10, 0, 0, "+02:00")
    )

    event.cover_photo.attach(io: URI.open(Rails.root.join('db', 'seed_files', 'events', 'friendly_cover.avif')), filename: 'friendly_cover.avif')
    event.profile_photo.attach(io: URI.open(Rails.root.join('db', 'seed_files', 'events', 'friendly_profile.png')), filename: 'friendly_profile.png')

    seed_kanban
  end

  # Issues, pull requests and tasks displayed together on a single kanban board.
  # The board groups records by their `status`, and each column's `value` is
  # matched against it — a record lands in the column whose value equals its
  # status (or the "No status" column when blank).
  def self.seed_kanban
    statuses = Issue::STATUSES

    issues = [
      ["Dark mode flickers on first paint", "High"],
      ["N+1 query on the projects index", "Urgent"],
      ["Add keyboard shortcuts to the board", "Low"],
      ["Timezone off by one on the events page", "Medium"],
      ["Search returns archived records", "Medium"],
      ["Upgrade to the latest Avo beta", "Low"],
      ["Broken avatar fallback for new users", "High"],
      ["Export CSV times out for large tables", "Urgent"],
      ["Tooltip copy is truncated on mobile", "Low"],
      ["Filters reset after editing a record", "Medium"]
    ].each_with_index.map do |(title, priority), i|
      Issue.create!(
        number: i + 1,
        title: title,
        priority: priority,
        status: (statuses + [nil]).sample,
        author: ["avo", "adrian", "paul", "ema"].sample,
        body: Faker::Lorem.paragraph(sentence_count: 3)
      )
    end

    pull_requests = [
      ["Cache the resource table queries", "feature/table-cache"],
      ["Fix dark mode first paint", "fix/dark-mode-flicker"],
      ["Introduce kanban boards", "feature/kanban"],
      ["Bump avo-advanced", "chore/bump-avo"],
      ["Add board keyboard shortcuts", "feature/board-shortcuts"],
      ["Stream CSV exports", "fix/csv-export-timeout"]
    ].each_with_index.map do |(title, branch), i|
      PullRequest.create!(
        number: 100 + i + 1,
        title: title,
        branch: branch,
        draft: [true, false, false].sample,
        status: (statuses + [nil]).sample,
        author: ["avo", "adrian", "paul", "ema"].sample,
        body: Faker::Lorem.paragraph(sentence_count: 3)
      )
    end

    tasks = [
      "Write the release notes",
      "Record a demo video",
      "Update the documentation",
      "Review the Q3 roadmap",
      "Triage incoming issues",
      "Prepare the changelog",
      "Schedule the team retro",
      "Audit the seed data"
    ].map do |title|
      Task.create!(
        title: title,
        completed: [true, false].sample,
        due_on: Faker::Date.between(from: Date.today, to: Date.today + 30),
        status: (statuses + [nil]).sample,
        assignee: ["avo", "adrian", "paul", "ema"].sample,
        description: Faker::Lorem.paragraph(sentence_count: 2)
      )
    end

    board = Avo::Kanban::Board.create!(
      name: "Engineering board",
      description: "Issues, pull requests and tasks across the engineering team.",
      allowed_resources: ["Avo::Resources::Issue", "Avo::Resources::PullRequest", "Avo::Resources::Task"],
      property: "status"
    )

    columns = {nil => board.columns.create!(name: "No status", value: nil)}
    statuses.each do |status|
      columns[status] = board.columns.create!(name: status, value: status)
    end

    (issues + pull_requests + tasks).shuffle.each do |record|
      column = columns[record.status]
      column.items.create!(record: record, board: board)
    end
  end
end
