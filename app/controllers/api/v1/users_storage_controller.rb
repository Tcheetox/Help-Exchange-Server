class Api::V1::UsersStorageController < Api::V1::ApplicationController
    include Api::V1::ApplicationHelper
    rescue_from Exception, with: :server_error

    def create
        # Handle the (only) case of issued government ID
        if params.has_key?(:file) && params.has_key?(:file_type)
            if params[:file_type].downcase == 'government_id'
                if params[:file].size > 3145728 || !['.jpg', '.jpeg', '.png', '.pdf'].include?(File.extname(params[:file]).downcase)
                    return render_error(40002)
                else 
                    # Save the file as tmp
                    current_user.tmp_gov_id.attach(params[:file])
                    return render_response(201, :gov_id => url_for(current_user.tmp_gov_id))
                end
            else return render_error(40003) end
        else return render_error(40001) end
    end

end
