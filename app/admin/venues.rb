ActiveAdmin.register Venue do
  filter :name
  filter :latitude
  filter :longitude

  index do
    column :name, :sortable => 'venue.name' do |resource|
      link_to resource.name, resource_path(resource)
    end
    column :latitude
    column :longitude
    column :about
    column "Action" do |resource|
      links = ''.html_safe
      links += link_to "Edit", edit_resource_path(resource), :class => "member_link edit_link"
      links += link_to "Destroy", resource_path(resource), :method => :delete, :confirm => "Are you Sure?", :class => "member_link delete_link"
      links
    end
  end

  show do |venue|
    attributes_table do
      row :name
      row :latitude
      row :longitude
      row :about
    end
  end

  form :partial => "/admin/venue/form"

end
