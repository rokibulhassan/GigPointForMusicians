ActiveAdmin.register Venue do
  filter :name
  filter :lat
  filter :lng

  index do
    column :name, :sortable => 'venue.name' do |resource|
      link_to resource.name, resource_path(resource)
    end
    column :lat
    column :lng
    column :city
    column :country
    column :description
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
      row :lat
      row :lng
      row :address1
      row :address2
      row :address3
      row :address4
      row :city
      row :state
      row :postcode
      row :country
      row :description
      row :location_map do
        render_gmap_coordinate_picker :default_coordinates => venue.try(:default_coordinates).nil? ? [23.7231, 90.4086] : venue.default_coordinates
      end
    end
  end

  form :partial => "/admin/venue/form"

end
