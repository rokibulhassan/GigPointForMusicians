namespace :populate_slug do
  desc "populate slug for friendly url"
  task(:all => :environment) do
    Artist.find_each(:batch_size => 10, &:save)
  end
end

