module ActiveAdminImportable
  module DSL
    def active_admin_importable(data_store = CsvDb, &block)
      action_item :only => :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv"
      end

      collection_action :import_csv, :method => :post do
        data_store.convert_save(active_admin_config.resource_class, params[:dump][:file], &block)
        flash[:notice] = "#{active_admin_config.resource_name.to_s} imported successfully! It will be ready in couple minutes."
        redirect_to :action => :index
      end
    end
  end
end
